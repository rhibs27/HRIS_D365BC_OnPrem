table 50007 References
{
    Caption = 'References';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(2; "Reference Name"; Text[50])
        {
            Caption = 'Reference Name';
            DataClassification = CustomerContent;
        }
        field(3; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(4; Occupation; Text[50])
        {
            Caption = 'Occupation';
            DataClassification = CustomerContent;
        }
        field(5; "Known Since"; Integer)
        {
            Caption = 'Known Since';
            DataClassification = CustomerContent;
        }
        field(6; "Contact No"; Code[15])
        {
            Caption = 'Contact No';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                TypeHelper: Codeunit "Type Helper";
            begin
                if not TypeHelper.IsPhoneNumber(Rec."Contact No") then
                    Error('Phone No Validation Error');
            End;
        }
        field(7; "Email Address"; Text[50])
        {
            Caption = 'Email Address';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.CheckValidEmailAddresses("Email Address");
            end;
        }
        field(8; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
    }
    keys
    {
        key(PK; "Employee Code", "Line No")
        {
            Clustered = true;
        }
    }
}
