table 50099 "Employee Insurance Information"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Insurance No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "Insurance No." <> '' then begin
                    HRSetup.Get;
                    HRSetup.TestField("Employee Insurance No.");
                    NoSeriesMgt.TestManual(HRSetup."Employee Insurance No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then
                    Validate("Employee Name", Employee."Full Name")
                else
                    Clear("Employee Name");
            end;
        }
        field(3; "Employee Name"; Text[50]) { }
        field(4; "Insurance Company"; Text[50]) { }
        field(5; "Policy Number"; Text[30])
        {
            trigger OnValidate()
            begin
                Clear(Len); //Min >> --- for Special Characters Control Add.
                Len := StrLen(DelChr("Policy Number", '=', DelChr("Policy Number", '=', SpecialChars)));
                if Len > 0 then
                    Error(SpecialCharsErr);
                EmpInsurance.Reset; //Min >> --- For add control in duplicate Policy No.
                EmpInsurance.SetRange("Employee No.", Rec."Employee No.");
                EmpInsurance.SetRange("Policy Number", Rec."Policy Number");
                if EmpInsurance.FindFirst then
                    Error(Text019, Rec."Policy Number", EmpInsurance."Insurance No.");
            end;
        }
        field(6; "Insurance Start Date (AD)"; Date)
        {
            trigger OnValidate()
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Insurance Start Date (AD)");
                if EngNepDate.FindFirst then
                    Validate("Insurance Start Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("Insurance Start Date (BS)");
                if "Insurance Start Date (AD)" > Today then //Min
                    Error(Error002, Today);
            end;
        }
        field(7; "Insurance Start Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(8; "Insurance Expiry Date (AD)"; Date)
        {
            trigger OnValidate()
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Insurance Expiry Date (AD)");
                if EngNepDate.FindFirst then
                    Validate("Insurance Expiry Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("Insurance Expiry Date (BS)");
                if "Insurance Start Date (AD)" > "Insurance Expiry Date (AD)" then //Min
                    Error(Error001, "Insurance Start Date (AD)");
            end;
        }
        field(9; "Insurance Expiry Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(10; "Insurance Amount"; Decimal) { }
        field(11; "Annual Premium Amount"; Decimal)
        {
            trigger OnValidate()
            begin
                if "Annual Premium Amount" > "Insurance Amount" then //Min
                    Error('Annual Premium Amount Should be less than Insurance Amount.');
            end;
        }
        field(12; "Monthly Premium Amount"; Decimal) { }
        field(13; "Linked Home Loan Account No."; Text[30]) { }
        field(14; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(15; "Is Home Loan TieUp"; Boolean) { }
        field(16; "Requested Date"; Date) { }
        field(17; Status; Enum "Employee Insurance Status")
        {

        }
        field(18; Type; Enum "Employee Insurance Type")
        {

        }
        field(19; Remarks; Text[250]) { }
        field(20; "Life Insurance Company"; Enum "Life Insurance Company")
        {
        }
        field(21; "Medical/Property Ins Company"; Enum "Medical/Property Ins Company")
        {
        }
    }

    keys
    {
        key(Key1; "Insurance No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "Requested Date" := Today;
        Validate("Employee No.", "Employee No.");
        if "Insurance No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField("Employee Insurance No.");
            NoSeriesMgt.InitSeries(HRSetup."Employee Insurance No.", xRec."No. Series", "Requested Date", "Insurance No.", "No. Series");
        end;
        /*EmpInsurance.RESET;
        EmpInsurance.SETRANGE("Employee No.","Employee No.");
        EmpInsurance.SETFILTER(Status,'%1|%2',EmpInsurance.Status::Open,EmpInsurance.Status::Pending);
        EmpInsurance.SETFILTER("Insurance No.",'<>%1',"Insurance No.");
        IF EmpInsurance.FINDFIRST THEN
          ERROR('Insurance of employee %1 (%2) is pending.',EmpInsurance."Employee Name","Employee No.");*/
        if not GuiAllowed then begin
            LoanMgt.CheckInsuranceAttachment('', "Employee No.");
            IncomingDoc.Reset;
            IncomingDoc.SetRange("No.", '');
            IncomingDoc.SetRange("Employee Code", "Employee No.");
            IncomingDoc.ModifyAll("No.", "Insurance No.");
        end;
        if GuiAllowed then begin
            AttachmentSetup.Reset;
            AttachmentSetup.SetRange(Type, AttachmentSetup.Type::Insurance);
            if AttachmentSetup.Find('-') then
                repeat
                    IncomingDoc.Init;
                    IncomingDoc.Validate("No.", "Insurance No.");
                    IncomingDoc.Validate("Table ID", Database::"Employee Insurance Information");
                    IncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
                    IncomingDoc.Validate("Employee Code", "Employee No.");
                    IncomingDoc.Validate("Employee Activity Type", IncomingDoc."Employee Activity Type"::Insurance);
                    IncomingDoc."Entry No." := IncomingDoc.GetEntryNo();
                    IncomingDoc.Insert;
                until AttachmentSetup.Next = 0;
        end;
    end;

    trigger OnModify()
    begin
        if Status in [Status::Open, Status::Pending] then //Min
            LoanMgt.CheckInsuranceAttachment("Insurance No.", "Employee No.");
        if not GuiAllowed then
            if Status = Status::Open then
                Status := Status::Pending;
        /*EmpInsurance.RESET; //Min >> --- For add control in duplicate Policy No.
        EmpInsurance.SETRANGE("Employee No.",Rec."Employee No.");
        EmpInsurance.SETRANGE("Policy Number",Rec."Policy Number");
        IF EmpInsurance.FINDFIRST THEN
          ERROR(Text019,Rec."Policy Number",EmpInsurance."Insurance No.");*/
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        EngNepDate: Record "English-Nepali Date";
        AttachmentSetup: Record "Attachment Setup";
        IncomingDoc: Record "Incoming Document";
        EmpInsurance: Record "Employee Insurance Information";
        LoanMgt: Codeunit "Loan Mgt.";
        SpecialCharsErr: Label 'You cannot enter the special characters. ';
        SpecialChars: Label '!|@|#|$|%|&|*|(|)|_|-|+|=| |?';
        Len: Integer;
        Text019: Label 'Policy No. %1 already used in Insurance No. %2.';
        Error001: Label 'Insurance Expiry Date must be greater then Insurance Start Date %1.';
        Error002: Label 'Insurance Start Date must be less or equal to %1.';
}
