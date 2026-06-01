codeunit 50036 "Grievance Mgt"
{
    procedure OpenGrievanceRequest(EmpCode: Code[20]): Text
    var
        Grievance, Grievance2 : Record "Grievance Header";
        AlreadyOpen: Label 'This employee already has an open grievance. Click Ok to open it.';
    begin
        Grievance.Reset();
        Grievance.SetRange("Employee No.", EmpCode);
        Grievance.SetFilter("Approval Status", '%1|%2', Grievance."Approval Status"::" ", Grievance."Approval Status"::Open);
        if Grievance.FindFirst() then begin
            if GuiAllowed then begin
                Message(AlreadyOpen);
                Page.Run(Page::"Grievance Card", Grievance);
                exit;
            end else
                Error('You Already have OpenGrievanceRequest %1', Grievance."No.");
        end;
        Grievance2.Init();
        Grievance2.Validate("Employee No.", EmpCode);
        Grievance2.Validate("Approval Status", Grievance2."Approval Status"::Open);
        Grievance2.Validate("Grievance Date", Today);
        Grievance2.Insert(true);
        if GuiAllowed then
            Page.Run(Page::"Grievance Card", Grievance2)
        else
            exit(Grievance2."No.")
    end;

    procedure SubmitGrievance(var Grievance: Record "Grievance Header"): Boolean
    var
        ConfirmSubmit: Label 'Do you want to submit this grievance for review?';
        SubmitSuccess: Label 'Grievance has been submitted for HR review.';
    begin
        if GuiAllowed then
            if not Confirm(ConfirmSubmit, false) then
                exit;
        if not Grievance.Anonymous then
            Grievance.TestField("Employee No.");
        Grievance.TestField("Subject Code");
        Grievance.TestField(Description);
        Grievance.Validate("Approval Status", "Approval Status"::Submitted);
        Grievance.Modify(true);
        AddComment(Grievance."No.", 'Grievance submitted for review.');
        EmailMgt.SendGrievanceNotificationEmail(Grievance);
        if GuiAllowed then begin
            Message(SubmitSuccess);
        end;
        exit(true);
    end;

    procedure ApproveGrievance(var Grievance: Record "Grievance Header")
    var
        AlreadyResolved: Label 'This grievance has already been resolved.';
    begin
        if Grievance."Approval Status" = Grievance."Approval Status"::Settled then
            Error(AlreadyResolved);
        AddComment(Grievance."No.", 'Grievance approved and resolved.');
        Grievance.TestField("HR Remarks");
        Grievance.Validate("Approval Status", "Approval Status"::Settled);
        if Grievance."Resolution Date" = 0D then
            Grievance.Validate("Resolution Date", Today);
        Grievance.Validate("Resolved By", HRMgt.GetEmployeeNo());
        Grievance.Modify(true);
    end;

    procedure RejectGrievance(var Grievance: Record "Grievance Header")
    var
        AlreadyRejected: Label 'This grievance has already been rejected.';
    begin
        if Grievance."Approval Status" = Grievance."Approval Status"::Rejected then
            Error(AlreadyRejected);
        Grievance.TestField("Rejection Remarks");
        Grievance.Validate("Approval Status", "Approval Status"::Rejected);
        Grievance.Modify(true);
        AddComment(Grievance."No.", StrSubstNo('Grievance rejected. Reason: %1', Grievance."Rejection Remarks"));
    end;

    procedure WithdrawGrievance(var Grievance: Record "Grievance Header"): Boolean
    var
        CannotWithdraw: Label 'Only grievances in submitted status can be withdrawn.';
        WithdrawSuccess: Label 'Grievance withdrawn';
    begin
        if not (Grievance."Approval Status" in [Grievance."Approval Status"::" ", Grievance."Approval Status"::Submitted]) then
            Error(CannotWithdraw);
        Grievance.Validate("Approval Status", "Approval Status"::Withdrawn);
        Grievance.Modify(true);
        AddComment(Grievance."No.", 'Grievance withdrawn by employee.');
        if GuiAllowed then
            Message(WithdrawSuccess);
        exit(true);
    end;

    procedure AddComment(GrievanceNo: Code[20]; CommentText: Text[2000])
    var
        GrievanceComment: Record "Grievance Comment";
        GrievanceHeader: Record "Grievance Header";
        EmpNo: Code[20];
    begin
        if CommentText = '' then
            Error('Add Comment text First.');
        if GrievanceHeader.Get(GrievanceNo) then
            if GrievanceHeader."Approval Status" = GrievanceHeader."Approval Status"::Settled then
                Error('Grievance is already settled.');
        EmpNo := HRMgt.GetEmployeeNo();
        GrievanceComment.Init();
        GrievanceComment.Validate("Grievance No.", GrievanceNo);
        GrievanceComment.Validate("Commented By", HRMgt.GetEmployeeNo());
        GrievanceComment.Validate("Comment Date", CurrentDateTime);
        GrievanceComment.Comment := CommentText;
        GrievanceComment.Insert(true);
    end;

    procedure CheckOpenGrievance(EmpNo: Code[20]): Boolean
    var
        Grievance: Record "Grievance Header";
    begin
        Grievance.Reset();
        Grievance.SetRange("Employee No.", EmpNo);
        Grievance.SetFilter("Approval Status", '%1|%2', Grievance."Approval Status"::" ", Grievance."Approval Status"::Open);
        exit(not Grievance.IsEmpty);
    end;

    procedure GenerateUserFriendlyToken(): Text
    var
        RawGuid: Text;
        CleanGuid: Text;
        Token: Text;
    begin
        RawGuid := Format(CreateGuid());
        CleanGuid := UpperCase(DelChr(RawGuid, '=', '{}-')); // 32 hex chars

        // Format as XXXXXXXXXXXX (12 chars + 2 dashes)
        Token := CopyStr(CleanGuid, 1, 4) + '-' +
                 CopyStr(CleanGuid, 5, 4) + '-' +
                 CopyStr(CleanGuid, 9, 4);

        exit(Token); // e.g. A3F9-C2E1-B847
    end;

    procedure GenerateAnonymousToken(var GrievanceRec: Record "Grievance Header"; UserPIN: Text): Text
    var
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
        PlainToken: Text;
        TokenHash: Text;
    begin
        if StrLen(UserPIN) < 6 then
            Error('PIN should not be less than 6 characters.');
        PlainToken := UserPIN + CopyStr(GrievanceRec."No.", 10, 5); //GenerateUserFriendlyToken();

        TokenHash := CryptographyMgmt.GenerateHash(PlainToken, HashAlgorithmType::SHA256);

        GrievanceRec."Grievance Token Hash" := TokenHash;
        GrievanceRec.Modify(true);

        exit(PlainToken); // Returned once to show the user, never stored
    end;

    procedure ValidateTokenAndGetGrievance(InputToken: Text; var GrievanceRec: Record "Grievance Header"): Boolean
    var
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
        InputHash: Text;
        NormalizedToken: Text;
    begin

        NormalizedToken := InputToken;

        // Normalize: uppercase and strip any spaces the user may have typed
        // NormalizedToken := UpperCase(DelChr(InputToken, '=', ' '));

        // Re-add dashes if user typed without them e.g. "A3F9C2E1B847"
        // if StrLen(NormalizedToken) = 12 then
        //     NormalizedToken := CopyStr(NormalizedToken, 1, 4) + '-' +
        //                        CopyStr(NormalizedToken, 5, 4) + '-' +
        //                        CopyStr(NormalizedToken, 9, 4);

        InputHash := CryptographyMgmt.GenerateHash(NormalizedToken, HashAlgorithmType::SHA256);

        GrievanceRec.Reset();
        GrievanceRec.SetRange(Anonymous, true);
        GrievanceRec.SetRange("Grievance Token Hash", InputHash);

        exit(GrievanceRec.FindFirst());
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        CryptographyMgmt: Codeunit "Cryptography Management";
        EmailMgt: Codeunit "Email Mgt";
}

