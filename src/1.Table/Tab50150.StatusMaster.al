table 50150 "Status Master"
{
    Caption = 'Status Master';
    DataClassification = ToBeClassified;
    LookupPageId = "Status Master";
    DrillDownPageId = "Status Master";
    fields
    {

        field(1; Status; Text[20])
        {
            Caption = 'Status';
        }
        field(2; Role; Text[20])
        {
            Caption = 'Role';
            trigger OnValidate()
            begin
                if Rejected then
                    Error('You Cannot Modify Role when Rejected if true');
            end;
        }
        field(3; Rejected; Boolean)
        {
            Caption = 'Rejected';
            trigger OnValidate()
            var
                StatusMaster: Record "Status Master";
            begin
                if Rejected then
                    if not (Role = '') then
                        Error('If Rejected is True Role should be Blank');
                StatusMaster.Reset();
                StatusMaster.SetRange(Rejected, true);
                if StatusMaster.Count = 1 then
                    Error('Rejected Status Cannot be more than One');
            end;
        }
    }
    keys
    {
        key(PK; Status)
        {
            Clustered = true;
        }
    }
}
