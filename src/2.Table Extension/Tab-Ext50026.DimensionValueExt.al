tableextension 50026 "Dimension Value Ext" extends "Dimension Value"
{
    fields
    {
        field(50000; "Head Office"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Deputation On Type"; Enum "Deputation Type")
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Dimension."Deputation On Type" where(Code = field("Dimension Code")));
        }
    }
}