pageextension 33019815 Relatives extends Relatives
{
    layout
    {
        addafter(Description)
        {
            field("Relation (In Nepali)"; Rec."Relation (In Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Relation (In Nepali) field.';
            }
            field("Male Corres. Relation (Nepali)"; Rec."Male Corres. Relation (Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Male Corres. Relation (Nepali) field.';
            }
            field("FemaleCorres. Relation(Nepali)"; Rec."FemaleCorres. Relation(Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FemaleCorres. Relation(Nepali) field.';
            }
            field(Relation; Rec.Relation)
            {
                ApplicationArea = All;
            }
        }
    }
}
