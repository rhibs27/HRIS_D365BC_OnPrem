table 33019838 "Payroll Journal Batch"
{
    // version PRM19.01.01

    DataCaptionFields = "Code", Description;
    LookupPageId = "Payroll Journal Batches";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[10]) { }
        field(2; Description; Text[50]) { }
        field(3; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(4; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }
}
