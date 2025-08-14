table 50120 "Employee Edit Line"
{
    //use for uploading multiple document at once
    Caption = 'Employee Edit Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Change in Emp Type"; Enum "Employee Edit Type")
        {
            Caption = 'Change in Emp Type';
        }
        field(4; Attachment; Media)
        {
            Caption = 'Attachment';
        }
        field(5; "Employee Document Type"; Enum "Emp. Document Type")
        {
            Caption = 'Employee Document Type';
        }
        field(18; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
        }

        field(23; "Qualification Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Qualification';
        }
        field(24; Description; text[100])
        {
            DataClassification = CustomerContent;
            Description = 'Qualification';
        }
        field(25; "Institution/Company"; Text[100])
        {
            DataClassification = CustomerContent;
            Description = 'Qualification';
        }
        field(26; Percentage; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Qualification';
        }
        field(27; Stream; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'example- Science, Management etc.';
        }
        field(28; Year; Text[4])
        {
            DataClassification = CustomerContent;
            Description = 'Date of Completion of particular study';
            CharAllowed = '09';
            trigger OnValidate()
            var
                Date: Integer;
            begin
                Evaluate(Date, year);
                if Date > Date2DMY(Today, 3) then
                    Error('Date is in Future');

            end;
        }
        field(29; Designation; Text[30])
        { DataClassification = CustomerContent; }
        field(30; "Time Period"; Decimal)
        { DataClassification = CustomerContent; }
        field(31; Remuneration; Decimal)
        { DataClassification = CustomerContent; }
        field(32; "Contact Number"; Text[30])
        { DataClassification = CustomerContent; }
        field(33; Remarks; Text[50])
        { DataClassification = CustomerContent; }
        field(34; Rank; Integer)
        { DataClassification = CustomerContent; }
        field(35; "Qualification Type"; Enum "Qualification Type")
        {
            DataClassification = CustomerContent;
        }
        field(36; CGPA; Decimal)
        {
            DataClassification = CustomerContent;
            MaxValue = 4;
        }
        field(39; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Relative Code"; Code[10])
        {
            Caption = 'Relative Code';
            Description = 'Employee Relative';
            DataClassification = CustomerContent;
            TableRelation = Relative;
        }
        field(46; "Full Name"; Text[30])
        {
            Caption = 'Full Name';
            Description = 'Employee Relative';
            DataClassification = CustomerContent;
        }
        field(59; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
            Description = 'Employee Relative';
            DataClassification = CustomerContent;
        }
        field(47; "Relative Phone No."; Code[20])
        {
            Description = 'Employee Relatives';
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(48; "Employee Relative In Bank"; Enum "Employee/BOD Relation")
        {
            Description = 'Employee Relatives';
            Caption = 'Employee Relative In Bank';
            DataClassification = CustomerContent;
        }
        field(49; "Relative's Employee No."; Code[20])
        {
            Description = 'Employee Relatives';
            Caption = 'Relative Employee No.';
            DataClassification = CustomerContent;
        }
        field(50; "Relative CitizenShip No."; Code[20])
        {
            Description = 'Employee Relatives';
            Caption = 'Relative CitizenShip No.';
            DataClassification = CustomerContent;
        }
        field(51; "Relative District"; Code[20])
        {
            Description = 'Employee Relatives';
            Caption = 'Relative District';
            DataClassification = CustomerContent;
        }
        field(52; "Relative VDC/Municipality"; Code[20])
        {
            Description = 'Employee Relatives';
            Caption = 'Relative VDC/Municipality';
            DataClassification = CustomerContent;
        }
        field(53; "Ward No."; Integer)
        {
            Description = 'Employee Relatives';
            Caption = 'Relative Ward No.';
            MinValue = 1;
            MaxValue = 32;
            DataClassification = CustomerContent;
        }

        // Language Proficiency
        field(54; Language; Code[20])
        {
            Caption = 'Language';
            Description = 'Language Proficiency';
            TableRelation = Language;
            DataClassification = CustomerContent;
        }
        field(55; Reading; Integer)
        {
            Caption = 'Reading';
            Description = 'Language Proficiency';
            DataClassification = CustomerContent;
        }
        field(56; Writing; Integer)
        {
            Caption = 'Writing';
            Description = 'Language Proficiency';
            DataClassification = CustomerContent;
        }
        field(57; Speaking; Integer)
        {
            Caption = 'Speaking';
            Description = 'Language Proficiency';
            DataClassification = CustomerContent;
        }
        field(58; Typing; Integer)
        {
            Caption = 'Typing';
            Description = 'Language Proficiency';
            DataClassification = CustomerContent;
        }
        field(60; Running; Boolean)
        {

        }
        field(61; "CitizenShip No."; Code[50])
        {
            Caption = 'CitizenShip No.';
            Description = 'Official Document';
            DataClassification = CustomerContent;
        }
        field(62; VDC; Text[50])
        {
            Caption = 'VDC';
            DataClassification = CustomerContent;
        }
        field(63; "Relative Mail"; Text[30])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("Relative Mail");
            end;
        }
        field(64; "Set Emergency Contact"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(65; "lt."; Boolean)
        {

        }
        field(1000; "Changed Field"; Text[1020])
        {
            Description = 'This field includes the name of fields that are updated from portal';
        }
        field(1001; "Original Line No."; Integer)
        {

        }

    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
