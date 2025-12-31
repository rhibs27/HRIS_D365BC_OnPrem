table 50151 "Approval Setup"
{
    Caption = 'Approval Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Request Type"; Enum "Employee Activity Type")
        {
            Caption = 'Request Type';
        }
        field(2; "Deputation On"; Enum "Deputation Type")
        {
            Caption = 'Deputation On';
        }
        field(3; "Approval Sending Policy"; enum "Approval Sending Policy") { }
        field(4; "Approval Entry Creation Policy"; Enum "Approval Entry Creation Policy") { }
    }
    keys
    {
        key(PK; "Request Type", "Deputation On")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        ApproverSetupLine: Record "Approval Setup Line";
    begin
        ApproverSetupLine.Reset();
        ApproverSetupLine.SetRange("Request Type", "Request Type");
        ApproverSetupLine.SetRange("Deputation On", "Deputation On");
        ApproverSetupLine.DeleteAll();
    end;
}
