table 50103 "Transfer Claim Detail"
{
    Caption = 'Transfer Claim Detail';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transfer No"; Code[20])
        {
            Caption = 'Transfer No';
        }
        field(2; "Attribute code"; Code[20])
        {
            Caption = 'Attribute code';
            TableRelation = "Payroll Attributes";
        }
        field(3; "Employee No"; Code[20])
        {
            Caption = 'Employee No';
        }
        field(4; "Requested Amount"; Decimal)
        {
            Caption = 'Requested Amount';
        }
        field(5; "Maximum Eligible Amount"; Decimal)
        {
            Caption = 'Maximum Eligible Amount';
        }
        field(6; "Approved Amount"; Decimal)
        {
            Caption = 'Approved Amount';
        }
        field(7; "Line No"; Integer)
        {
            Caption = 'Line no';
        }
    }
    keys
    {
        key(PK; "Transfer No", "Line No")
        {
            Clustered = true;
        }
    }
}
