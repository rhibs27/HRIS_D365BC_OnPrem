table 50098 "Employee Declaration"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "No." <> '' then begin
                    HRSetup.Get;
                    NoSeriesMgt.TestManual(HRSetup."Employee Declaration No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Empvar.Get("Employee No.") then begin
                    Validate("Employee Name", Empvar."Full Name");
                    Validate("Salary Level", Empvar."Salary Level");
                    Validate("Functional Title", Empvar."Functional Title");
                    Validate("Deputation On", Empvar."Deputation on");
                    Validate("Deputation Code", ServiceHistoryMgt.ExitTransferDeputationWiseCode("Deputation On", "Employee No."));
                    Validate("Deputation Value", ServiceHistoryMgt.ExitTransferDeputationWiseValue("Deputation On", "Employee No."));
                    Validate("Fiscal Year", HRMgt.ReturnFiscalYear(CalcDate('<-1Y>'))); //Min -- Validate Previous Fiscal Year
                end else begin
                    Validate("Employee Name", '');
                    Validate("Salary Level", '');
                    Validate("Functional Title", '');
                    Validate("Deputation On", "Deputation On"::" ");
                    Validate("Deputation Code", '');
                    Validate("Deputation Value", '');
                    Validate("Fiscal Year", ''); //Min
                end;
            end;
        }
        field(3; "Employee Name"; Text[100]) { }
        field(4; "Fiscal Year"; Code[20]) { }
        field(5; "Salary Level"; Code[20])
        {
            trigger OnValidate()
            var
                SalaryLevel: Record "Salary Level";
            begin
                if SalaryLevel.Get("Salary Level") then
                    Validate("Salary Level Description", SalaryLevel.Description)
                else
                    Validate("Salary Level Description", '');
            end;
        }
        field(6; "Functional Title"; Code[20])
        {
            trigger OnValidate()
            var
                FunctionalTitle: Record "Functional Title";
            begin
                if FunctionalTitle.Get("Functional Title") then
                    Validate("Functional Title Description", FunctionalTitle.Description)
                else
                    Validate("Functional Title Description", '');
            end;
        }
        field(7; "Deputation On"; Enum "Deputation Type")
        {

        }
        field(8; "Deputation Code"; Code[20]) { }
        field(9; "Code of Ethics"; Boolean) { }
        field(10; "By Laws Policies"; Boolean) { }
        field(11; "Corporate Communication"; Boolean) { }
        field(12; "Family Availed Loan"; Boolean) { }
        field(13; "Loan Booking Branch"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                if DimValue.Get('Branch', "Loan Booking Branch") then
                    Validate("Loan Booking Branch Name", DimValue.Name)
                else
                    Validate("Loan Booking Branch Name", '');
            end;
        }
        field(14; "Loan Booking Branch Name"; Text[50]) { }
        field(15; "Functional Title Description"; Text[100]) { }
        field(16; "Salary Level Description"; Text[40]) { }
        field(17; "Name of Borrower"; Text[100]) { }
        field(18; Limit; Decimal) { }
        field(19; "Relation To staff"; Text[30]) { }
        field(20; "Credit Close Relative Submit"; Boolean) { }
        field(21; "Have Passport"; Boolean) { }
        field(22; "Passport Number"; Code[30]) { }
        field(23; "Declaration Passport Submit"; Boolean) { }
        field(24; "Document 1 under Custody"; Text[100]) { }
        field(25; "Document 2 under Custody"; Text[100]) { }
        field(26; "Document 3 under Custody"; Text[100]) { }
        field(27; "Document 4 under Custody"; Text[100]) { }
        field(28; "Document 5 under Custody"; Text[100]) { }
        field(29; "Document 6 under Custody"; Text[100]) { }
        field(30; "Other Documents if Any"; Text[250]) { }
        field(31; "Owner Official Document Submit"; Boolean) { }
        field(32; "Inventory 1 under Custody"; Text[100]) { }
        field(33; "Inventory 2 under Custody"; Text[100]) { }
        field(34; "Inventory 3 under Custody"; Text[100]) { }
        field(35; "Inventory 4 under Custody"; Text[100]) { }
        field(36; "Inventory 5 under Custody"; Text[100]) { }
        field(37; "Inventory 6 under Custody"; Text[100]) { }
        field(38; "Other Inventory If Any"; Text[250]) { }
        field(39; "Ownership of Inventory Submit"; Boolean) { }
        field(40; "Involved In Outside Business"; Boolean) { }
        field(41; "Engage/Managing Business Field"; Text[250]) { }
        field(42; "Name of Institution"; Text[250]) { }
        field(43; "Date of Involvement"; Date) { }
        field(44; "Outside Busin. Interest Subm"; Boolean) { }
        field(45; "Souvenir/Gift"; Boolean) { }
        field(46; "Souvenir/Gift From"; Text[250]) { }
        field(47; "Souvenir/Gift/Present Type"; Text[100]) { }
        field(48; "Souvenir/Gift/Present Amount"; Text[100]) { }
        field(49; "Relation with Gift Provider"; Text[100]) { }
        field(50; "Souvenir Declaration"; Boolean) { }
        field(51; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(52; "Created Date"; Date) { }
        field(53; "Deputation Value"; Text[100]) { }
        field(54; "Passport Attachment"; Text[145]) { }
        field(55; "Outside Business Attachment"; Text[145]) { }
        field(56; "Property Declaration Attachmen"; Text[145]) { }
    }

    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "Created Date" := Today;
        HRSetup.Get;
        if "No." = '' then begin
            HRSetup.TestField("Employee Declaration No.");
            NoSeriesMgt.InitSeries(HRSetup."Employee Declaration No.", xRec."No. Series", "Created Date", "No.", "No. Series");
        end;
        Validate("Employee No.", HRMgt.GetEmployeeNo());
        TestField("Code of Ethics");
        TestField("By Laws Policies");
        TestField("Corporate Communication");
        TestField("Declaration Passport Submit");
        TestField("Owner Official Document Submit");
        TestField("Ownership of Inventory Submit");
        TestField("Outside Busin. Interest Subm");
        TestField("Souvenir Declaration");
        TestField("Property Declaration Attachmen");

        if "Family Availed Loan" then begin
            TestField("Loan Booking Branch");
            TestField("Name of Borrower");
            TestField(Limit);
            TestField("Relation To staff");
        end;

        if "Have Passport" then begin
            TestField("Passport Number");
            TestField("Passport Attachment");
        end;

        if "Involved In Outside Business" then begin
            TestField("Engage/Managing Business Field");
            TestField("Name of Institution");
            TestField("Date of Involvement");
            TestField("Outside Business Attachment");
        end;

        if "Souvenir/Gift" then begin
            TestField("Souvenir/Gift From");
            TestField("Souvenir/Gift/Present Amount");
            TestField("Souvenir/Gift/Present Type");
            TestField("Relation with Gift Provider");
        end;
        EmpDeclaration.Reset;
        EmpDeclaration.SetRange("Employee No.", "Employee No.");
        EmpDeclaration.SetRange("Fiscal Year", "Fiscal Year");
        EmpDeclaration.SetFilter("No.", '<>%1', "No.");
        if EmpDeclaration.FindFirst then
            Error('Declaration for this %1 fiscal year has already send.', Rec."Fiscal Year");
    end;

    var
        Empvar: Record Employee;
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRMgt: Codeunit "HR Mgt.";
        ServiceHistoryMgt: Codeunit "Service History Mgt";
        DimValue: Record "Dimension Value";
        EmpDeclaration: Record "Employee Declaration";

    procedure DownloadAttachment(AttachName: Text)
    Instream: InStream;
    begin
        Instream.Read(AttachName);
        if AttachName <> '' then
            DownloadFromStream(Instream, 'Save To', '', '', AttachName)
        //Download(AttachName, 'Save To', '', '', AttachName)//santosh
        else
            Error('No attachment found.');
    end;
}
