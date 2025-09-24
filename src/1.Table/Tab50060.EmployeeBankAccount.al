table 50060 "Employee Bank Account"
{
    Caption = 'Employee Bank Account';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(5; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(6; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(7; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(8; City; Text[30])
        {
            Caption = 'City';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(9; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code"
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;

        }
        field(10; Contact; Text[100])
        {
            Caption = 'Contact';
        }
        field(11; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(12; "Telex No."; Text[20])
        {
            Caption = 'Telex No.';
        }
        field(13; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
        }
        field(14; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
        }
        field(15; "Transit No."; Text[20])
        {
            Caption = 'Transit No.';
        }
        field(16; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(17; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }

        field(19; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(20; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(21; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(22; "E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }

        field(24; IBAN; Code[50])
        {
            Caption = 'IBAN';

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
                IsHandled: Boolean;
            begin
                IsHandled := false;

                if IsHandled then
                    exit;

                CompanyInfo.CheckIBAN(IBAN);
            end;
        }
        field(25; "SWIFT Code"; Code[20])
        {
            Caption = 'SWIFT Code';
            TableRelation = "SWIFT Code";
            ValidateTableRelation = false;
        }
        field(26; "Primary Payroll Account"; Boolean)
        {
            caption = 'Primary Payroll Account';
            trigger OnValidate()
            var
                EmpBankAccount: Record "Employee Bank Account";
            begin
                if Rec."Primary Payroll Account" <> xRec."Primary Payroll Account" then begin
                    if Rec."Primary Payroll Account" then begin
                        //check for multiple
                        EmpBankAccount.Reset();
                        EmpBankAccount.SetRange("Employee No.", Rec."Employee No.");
                        EmpBankAccount.SetRange("Primary Payroll Account", true);
                        EmpBankAccount.SetFilter(Code, '<>%1', Rec.Code);
                        if EmpBankAccount.Count() > 0 then
                            Error('Employee can have only one primary payroll account at a time');

                        // Ensure RF Account is false then Primary Payroll Account is true
                        if Rec."Is RF Account" then
                            Rec."Is RF Account" := false;
                    end
                end;

            end;

        }
        //new RF boolean added
        field(27; "Is RF Account"; Boolean)
        {
            Caption = 'RF Account';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                EmpBankAccount: Record "Employee Bank Account";
                EmployeeRec: Record Employee;
            begin
                if Rec."Is RF Account" <> xRec."Is RF Account" then begin
                    if Rec."Is RF Account" then begin
                        // Check that no other bank account for this employee is marked as RF Account
                        EmpBankAccount.Reset();
                        EmpBankAccount.SetRange("Employee No.", Rec."Employee No.");
                        EmpBankAccount.SetRange("Is RF Account", true);
                        EmpBankAccount.SetFilter(Code, '<>%1', Rec.Code);
                        if EmpBankAccount.Count() > 0 then
                            Error('Employee can have only one RF account at a time');

                        // If RF Account is true then Primary Payroll Account is false
                        if Rec."Primary Payroll Account" then
                            Rec."Primary Payroll Account" := false;

                        //  update Employee table CIT No. with this bank account number
                        if EmployeeRec.Get(Rec."Employee No.") then begin
                            EmployeeRec."CIT No." := Rec."Bank Account No.";
                            EmployeeRec.Modify();
                        end;
                    end else begin
                        // If unmarked as RF Account, clear Employee's CIT No. only if it was this bank account
                        if EmployeeRec.Get(Rec."Employee No.") then begin
                            if EmployeeRec."CIT No." = Rec."Bank Account No." then begin
                                EmployeeRec."CIT No." := '';
                                EmployeeRec.Modify();
                            end;
                        end;
                    end;
                end;
            end;
        }


        field(1211; "Bank Clearing Code"; Text[50])
        {
            Caption = 'Bank Clearing Code';
        }
        field(1212; "Bank Clearing Standard"; Text[50])
        {
            Caption = 'Bank Clearing Standard';
            TableRelation = "Bank Clearing Standard";
        }
    }
    keys
    {
        key(PK; "Employee No.", Code)
        {
            Clustered = true;
        }
    }
}
