page 50104 "Training Question Setup"
{
    // version NIC Asia1.00,Training

    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Employee Question Setup";
    SourceTableView = where(Type = const(Training));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Question Code"; Rec."Question Code")
                {
                    ToolTip = 'Specifies the value of the Question Code field.';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Sub Type"; Rec."Sub Type")
                {
                    ToolTip = 'Specifies the value of the Sub Type field.';
                    ApplicationArea = All;
                }
                field(Question; Rec.Question)
                {
                    ToolTip = 'Specifies the value of the Question field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Training;
    end;
}
