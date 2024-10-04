pageextension 50020 "Base Calendar Entries Subform" extends "Base Calendar Entries Subform"
{
    layout
    {
        modify(Nonworking)
        {
            trigger OnAfterValidate()

            begin
                if not Rec.Nonworking then begin
                    Clear(Rec.Provinces);
                    Clear(Rec.Gender);
                    Clear(Rec.InOutValley);
                    Clear(Rec.PostingRegion);
                    Clear(Rec.Branch);
                end;
            end;
        }
        addafter(Description)
        {
            field(Provinces; Rec.Provinces)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Provinces field.';
            }
            field(Gender; Rec.Gender)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gender field.';
            }
            field(InOutValley; Rec.InOutValley)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the InOutValley field.';
            }
            field(PostingRegion; Rec.PostingRegion)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PostingRegion field.';
            }
            field(Branch; Rec.Branch)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Branch field.';
            }
        }
    }
}
