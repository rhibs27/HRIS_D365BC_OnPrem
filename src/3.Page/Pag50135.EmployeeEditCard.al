page 50135 "Employee Edit Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Employee Edit";
    // InsertAllowed = false;
    // DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {

                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Changes In Employee Type"; Rec."Changes In Employee Type")
                {
                    ToolTip = 'Specifies the value of the Changes In Employee Type field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = ApprovalStatusView;
                }
                field(Status; rec.Status)
                {
                    Caption = 'Approval Status';
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = StatusView;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }

            }
            group(Remarks)
            {

                field(Remark; Rec.Remarks)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                    Editable = IsPending;
                }
            }

            group("Employee Information")
            {
                Editable = false;
                Visible = DetailsChanges;
                field("Mobile No."; Rec."Mobile No.")
                {
                    ToolTip = 'Specifies the value of the Mobile No. field.';
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ToolTip = 'Specifies the value of the Marital Status field.';
                    ApplicationArea = All;
                }
                field("Email (Personal)"; Rec."Email (Personal)")
                {
                    ToolTip = 'Specifies the value of the Email (Personal) field.';
                    ApplicationArea = All;
                }
                field("Differently Able"; Rec."Differently Able")
                {
                    ToolTip = 'Specifies the value of the Differently Able field.';
                    ApplicationArea = All;
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    ToolTip = 'Specifies the value of the Vehicle Type field.';
                    ApplicationArea = All;
                }
                field("Temporary Address"; Rec."Temporary Address")
                {
                    ToolTip = 'Specifies the value of the Temporary Address field.';
                    ApplicationArea = All;
                }
                field("Temporary Province"; Rec."Temporary Province")
                {
                    ToolTip = 'Specifies the value of the Temporary Province field.';
                    ApplicationArea = All;
                }
                field(VDC; Rec.VDC)
                {
                    ToolTip = 'Specifies the value of the VDC field.';
                    ApplicationArea = All;
                }
                field("Temporary District"; Rec."Temporary District")
                {
                    ToolTip = 'Specifies the value of the Temporary District field.';
                    ApplicationArea = All;
                }
                field(House; Rec.House)
                {
                    ToolTip = 'Specifies the value of the House field.';
                    ApplicationArea = All;
                }
                field("Blood Group"; Rec."Blood Group")
                {
                    ToolTip = 'Specifies the value of the Blood Group field.';
                    ApplicationArea = All;
                }
            }
            group("Employee Qualification")
            {
                Editable = false;
                Visible = QualificationChanges or WorkExperienceChanges or AchievementChanges;
                // Caption = GroupCaption;
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Percentage field.';
                    Visible = QualificationChanges;
                }
                field(CGPA; Rec.CGPA)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CGPA field.';
                    Visible = QualificationChanges;
                }
                field(Stream; Rec.Stream)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stream field.';
                    Visible = QualificationChanges;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year of completion field.';
                    Visible = QualificationChanges;
                }
                field("Emp Document Type"; Rec."Emp Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Emp Document Type field.';
                }

                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                field("Qualification Code"; Rec."Qualification Code")
                {
                    CaptionClass = WorkExperience;
                }
                field("Qualification Type"; rec."Qualification Type")
                {
                    Visible = QualificationChanges;
                }
                field(Description; Rec.Description)
                {
                }
                field("Institution/Company"; Rec."Institution/Company")
                {
                }
                field(Designation; Rec.Designation)
                {
                    Visible = WorkExperienceChanges;
                }
                field(Remuneration; Rec.Remuneration)
                {
                }
            }
            group("Official Document")
            {
                Editable = false;
                Visible = DetailsChanges;
                field("passport No."; Rec."Passport No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Passport No. field.';
                }
                field("CitizenShip  No."; Rec."CitizenShip No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CitizenShip No. field.';
                }
                field("CitizenShip IssueDate"; Rec."CitizenShip Issue Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CitizenShip Issue Date field.';
                }
                field("NID No."; Rec."NID No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the National ID No. field.';
                }
                field("Driving License No."; Rec."Driving License No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Driving License No field.';
                }
            }
            group(Relative)
            {
                Editable = false;
                Visible = Relative;
                field("Relative Code"; Rec."Relative Code")
                {
                }
                field("Full Name"; Rec."Full Name")
                {
                }
                field("Relative Phone No."; Rec."Relative Phone No.")
                {
                }
                field("Relative Mail"; Rec."Relative Mail")
                {
                }
                field("Set Emergency Contact"; Rec."Set Emergency Contact")
                {
                }
                field("Employee Relative In Bank"; rec."Employee Relative In Bank")
                {
                }
                field("Relative Employee No."; Rec."Relative's Employee No.")
                {
                }
                field("Relative CitizenShip No."; Rec."Relative CitizenShip No.")
                {
                }
                field("Relative District"; Rec."Relative District")
                {
                }
                field("Relative VDC/Municipality"; Rec."Relative VDC/Municipality")
                {
                }
                field("Ward No."; Rec."Ward No.")
                {
                }
            }
            group("Language Proficiency")
            {
                Editable = false;
                Visible = LanguageChange;
                field(Language; Rec.Language)
                {
                }
                field(Reading; Rec.Reading)
                {
                }
                field(Writing; Rec.Writing)
                {
                }
                field(Speaking; Rec.Speaking)
                {
                }
                field(Typing; Rec.Typing)
                {
                }
            }
            part("Employee Edit Line"; "Employee Edit Subform")
            {
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = all;

            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No."),
                                // "Employee No" = field("Employee No."),
                                "Document Type" = field(Type);
                ApplicationArea = all;
            }
        }
        area(factboxes)
        {
            part(Control3; "Employee Edit Picture")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsPending;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the request?', false) then begin
                        ApprovalMgt.ApproveRejectDocument(RecRef, true);
                        Message('Employee Edit is Approved by %1', HRMgt.GetEmpName());
                    end;
                end;
            }
            action("Reject Request")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Reject Request action.';
                ApplicationArea = All;
                Visible = IsPending;
                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            ApprovalMgt.ApproveRejectDocument(RecRef, false);
                            Message('Employee Edit is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
        }
    }
    // trigger OnOpenPage()
    // begin
    //     SetLayout;
    // end;

    // trigger OnAfterGetRecord()
    // begin
    //     SetLayout;
    // end;

    var
        IsPending, IsRejected, IsApproved : Boolean;
        StatusView, ApprovalStatusView : Boolean;
        RecRef: RecordRef;
        DetailsChanges, Relative, LanguageChange, QualificationChanges, WorkExperienceChanges, AchievementChanges : Boolean;
        WorkExperience, GroupCaption : text;
        ApprovalMgt: Codeunit "Approver Mgt";
        HRMgt: Codeunit "HR Mgt.";

    local procedure SetLayout()
    begin
        DetailsChanges := Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::Details;
        QualificationChanges := Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::Qualification;
        WorkExperienceChanges := Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::"Work Experience";
        AchievementChanges := Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::Achievement;
        Relative := Rec."Changes In Employee Type" = rec."Changes In Employee Type"::Relative;
        LanguageChange := Rec."Changes In Employee Type" = rec."Changes In Employee Type"::Language;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        IsRejected := Rec."Approval Status" = rec."Approval Status"::Rejected;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        RecRef.GetTable(Rec);
        if IsRejected then
            CurrPage.Editable := false;
        if QualificationChanges then begin
            WorkExperience := 'Experience Code';
            GroupCaption := 'Employee Qualification';
        end else if WorkExperienceChanges then begin
            WorkExperience := 'Qualification Code';
            GroupCaption := 'Employee Work Experience';
        end else if AchievementChanges then begin
            WorkExperience := 'Achievement Code';
            GroupCaption := 'Employee Achievement';
        end;
    end;
}