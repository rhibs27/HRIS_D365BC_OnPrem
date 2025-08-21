table 50086 "Potential Candidates"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    HumanResSetup.Get;
                    NoSeriesMgt.TestManual(HumanResSetup."Candidate Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(3; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
        }
        field(4; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
        }
        field(5; Initials; Text[30])
        {
            Caption = 'Initials';
        }
        field(6; "Job Title"; Text[30])
        {
            Caption = 'Job Title';
        }
        field(7; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(8; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(9; County; Text[30])
        {
            Caption = 'County';
        }
        field(10; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(11; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(12; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(13; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
        }
        field(14; Gender; Enum "Employee Gender")
        {
            Caption = 'Gender';

        }
        field(15; Status; Enum "Employee Status")
        {
            Caption = 'Status';
            trigger OnValidate()
            begin
                /*EmployeeQualification.SetRange("Employee No.","No.");
                EmployeeQualification.MODIFYALL("Employee Status",Status);
                MODIFY;
                */
            end;
        }
        field(16; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                /*ValidateShortcutDimCode(1,"Global Dimension 1 Code");*/
            end;
        }
        field(17; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                /*ValidateShortcutDimCode(2,"Global Dimension 2 Code");*/
            end;
        }
        field(18; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(19; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(20; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(21; "Cause of Absence Filter"; Code[20])
        {
            Caption = 'Cause of Absence Filter';
            FieldClass = FlowFilter;
            TableRelation = "Cause of Absence";
        }
        field(22; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(23; "G/L Account Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "G/L Account"."No.";
        }
        field(24; "User Id"; Code[50])
        {
        }
        field(25; "Third Party Payroll Emp Code"; Code[20])
        {
        }
        field(26; "Job Position Type"; Enum "Job Position Type")
        {

        }
        field(27; "Recruitement Status"; Enum "Recruitement Status")
        {

        }
        field(28; "Job Title Code"; Code[20])
        {
            TableRelation = "Job Title";
        }
        field(29; Age; Decimal) { }
        field(30; Experience; Integer) { }
        field(31; "Offer Letter Printed"; Boolean) { }
        field(32; "Application Letter Printed"; Boolean) { }
        field(33; "Personal Title"; Text[10])
        {
            Description = 'refered to as Mr.,Mrs.';
        }
        field(34; "Vacancy Code"; Code[20])
        {
            TableRelation = "Vacancy Header"."No." where(Posted = const(true));
        }
        field(35; "Education Qualification"; Code[20])
        {
            TableRelation = Qualification where(Rank = filter(<> 0));
        }
        field(36; "Shortlisted Process"; Boolean) { }
    }

    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Candidate Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Candidate Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PotenCand: Record "Potential Candidates";

    procedure AssistEdit(): Boolean
    begin
        PotenCand := Rec;
        HumanResSetup.Get;
        HumanResSetup.TestField("Candidate Nos.");
        if NoSeriesMgt.SelectSeries(HumanResSetup."Candidate Nos.", xRec."No. Series", PotenCand."No. Series") then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Candidate Nos.");
            NoSeriesMgt.SetSeries(PotenCand."No.");
            Rec := PotenCand;
            exit(true);
        end;
    end;
}
