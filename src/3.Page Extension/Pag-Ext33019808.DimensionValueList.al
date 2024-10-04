pageextension 33019808 DimensionValueList extends "Dimension Value List"
{
    trigger OnOpenPage()
    begin
        Rec.SetRange(Blocked, false);
    end;
}
