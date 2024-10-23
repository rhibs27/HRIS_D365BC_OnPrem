table 50077 "Vacancy Header"
{
    // version HRM1.00,HR Recruitement

    DataCaptionFields = "No.", Description;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    HRSetup.Get;
                    NoSeriesMgt.TestManual(HRSetup."Vacancy Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[100]) { }
        field(3; "Reference No."; Text[30])
        {
            Editable = false;
            TableRelation = "Recruitement Memo"."Reference No.";
        }
        field(4; "Date of Request"; Date)
        {
            Editable = false;
        }
        field(5; "Requestor Employee Code"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Requestor Name" := '';
                "Requestor Designation" := '';
                if Employee.Get("Requestor Employee Code") then begin
                    "Requestor Name" := Employee.FullName;
                    "Requestor Designation" := Employee."Job Title";
                end;
            end;
        }
        field(6; "Requestor Name"; Text[100])
        {
            Editable = false;
        }
        field(7; "Requestor Designation"; Code[50])
        {
            Editable = false;
        }
        field(8; "Functional Title"; Code[20])
        {
            Caption = 'Position to be filled';
            TableRelation = "Functional Title".Code;

            trigger OnValidate()
            begin
                //HRMgt.ValidateJobTitle(Rec);
            end;
        }
        field(9; Location; Enum "Outside/Inside Valley")
        {

        }
        field(10; "New Position"; Boolean) { }
        field(11; "Salary Level Code"; Code[20])
        {
            Caption = 'Position / Vacancy';
            TableRelation = "Salary Level";

            trigger OnValidate()
            begin
                //HRMgt.ValidateJobTitle(Rec);
            end;
        }
        field(12; "Budget Salary / CTC"; Decimal) { }
        field(13; "Existing Salary"; Decimal) { }
        field(14; "New Position Salary"; Decimal) { }
        field(15; "Internal Candidate Identified"; Boolean) { }
        field(16; "Internal Candidate Code"; Code[10])
        {
            Description = 'Not required';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Internal Candidate Name" := '';
                if Employee.Get("Internal Candidate Code") then begin
                    "Internal Candidate Name" := Employee.FullName;
                end;
            end;
        }
        field(17; "Internal Candidate Name"; Text[30])
        {
            Description = 'Not required';
            Editable = false;
        }
        field(18; "Requester User ID"; Code[50])
        {
            Description = 'Not required';
            Editable = false;
        }
        field(19; "Banking Experience"; Decimal)
        {
            trigger OnValidate()
            begin
                CalcuateTotalExp;
            end;
        }
        field(20; "Non-Banking Experience"; Decimal)
        {
            trigger OnValidate()
            begin
                CalcuateTotalExp;
            end;
        }
        field(21; "Total Experience"; Decimal)
        {
            Editable = false;
        }
        field(22; "Experience Maximum Relevant"; Decimal)
        {
        }
        field(23; "Minimum Age"; Integer)
        {
        }
        field(24; "Requirement for two/four wheel"; Enum "Requirement for two/four wheel")
        {

        }
        field(25; "Recruitment to be filled"; Enum BeforeAfter)
        {

        }
        field(26; "Reporting to Employee ID"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Reporting to Employee ID") then
                    "Reporting To Employee Name" := Employee.FullName
                else
                    "Reporting To Employee Name" := '';
            end;
        }
        field(27; "Reporting To Employee Name"; Text[30])
        {
            Editable = false;
        }
        field(28; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(29; "Last Modified Date"; Date)
        {
        }
        field(30; "Approval Status"; Enum "Attendance Status")
        {
        }
        field(31; Posted; Boolean)
        {
            Description = 'Not Required';
        }
        field(32; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(33; "No of Vacancy"; Integer)
        {
        }
        field(34; Type; Enum InternalExternal)
        {
            Editable = false;
        }
        field(35; "Memo No."; Code[20])
        {
            Editable = false;
            TableRelation = "Recruitement Memo";
        }
        field(36; Status; Enum "Vacancy Header Status")
        {
        }
        field(37; "Vacancy Published Date"; Date)
        {
            trigger OnValidate()
            begin
                if "Vacancy Expiry Date" <> 0D then
                    "Vacancy Expiry Date" := 0D;
            end;
        }
        field(38; "Notice Period"; DateFormula)
        {
            trigger OnValidate()
            begin
                Validate("Vacancy Expiry Date", CalcDate("Notice Period", "Vacancy Published Date"));
            end;
        }
        field(39; "Vacancy Expiry Date"; Date) { }
        field(40; Newspaper; Text[50]) { }
        field(41; "Selection Committee Approved"; Boolean) { }
        field(42; "Selection Com. Approved Date"; DateTime)
        {
            Caption = 'Selection Committee Approved Date';
        }
    }

    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField("Vacancy Nos.");
            NoSeriesMgt.InitSeries(HRSetup."Vacancy Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        Validate("Requester User ID", UserId);

        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        if Employee.FindFirst then begin
            Validate("Requestor Employee Code", Employee."No.");
            Validate("Requestor Designation", Employee."Job Title Code");
        end;

        "Date of Request" := Today;
    end;

    trigger OnModify()
    begin
        /*TESTFIELD("Approval Status", Rec."Approval Status"::Open);
        "Last Modified Date" := TODAY;
        */
    end;

    var
        Employee: Record Employee;
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        VacancyHdr: Record "Vacancy Header";

    procedure AssistEdit(OldVacancy: Record "Vacancy Header"): Boolean
    var
        HumanResSetup: Record "Human Resources Setup";
    begin
        VacancyHdr := Rec;
        HumanResSetup.Get;
        HumanResSetup.TestField("Vacancy Nos.");
        if NoSeriesMgt.SelectSeries(HumanResSetup."Vacancy Nos.", OldVacancy."No. Series", VacancyHdr."No. Series") then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Vacancy Nos.");
            NoSeriesMgt.SetSeries(VacancyHdr."No.");
            Rec := VacancyHdr;
            exit(true);
        end;
    end;

    procedure SetStyle(): Text
    begin
        HRSetup.Get;
        if Posted then begin
            Employee.Reset;
            Employee.SetRange("Converted To Emp. Date", "Approved Date", "Approved Date" + HRSetup."No. of days to hire");
            if Employee.FindFirst then
                exit('Favorable')
            else begin
                if Today - "Approved Date" > HRSetup."No. of days to hire" then
                    exit('Unfavorable');
            end
        end;

        exit('');
    end;

    local procedure CalcuateTotalExp()
    begin
        "Total Experience" := "Banking Experience" + "Non-Banking Experience";
    end;

    procedure SendMailToCandidate()
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendVacancyDocForApproval(var Vacancy: Record "Vacancy Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelVacancyDocForApproval(var Vacancy: Record "Vacancy Header")
    begin
    end;

    procedure UpdateApprovalStatus(var Vacancy: Record "Vacancy Header"; ApprovalStatus: Option)
    begin
        Vacancy.Validate("Approval Status", ApprovalStatus);
        if Vacancy."Approval Status" = Vacancy."Approval Status"::released then begin
            Vacancy.Validate(Posted, true);
            Vacancy."Approved Date" := Today;
        end;
        Vacancy.Modify;
    end;
}
