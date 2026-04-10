page 50104 "Training Question Setup"
{
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
                field("Is Subjective"; Rec."Is Subjective")
                {
                    ToolTip = 'Specifies the value of the Is Subjective field.';
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
