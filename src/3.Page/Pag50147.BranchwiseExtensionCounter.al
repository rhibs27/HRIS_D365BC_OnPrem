page 50147 "Branchwise/Extension Counter"
{
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Branchwise/Extension Allowance";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("Allowance Type"; Rec."Allowance Type")
                {
                    ToolTip = 'Specifies the value of the Allowance Type field.';
                    ApplicationArea = All;
                }
                field("Max. No. of Staffs"; Rec."Max. No. of Staffs")
                {
                    ToolTip = 'Specifies the value of the Max. No. of Staffs field.';
                    ApplicationArea = All;
                }
                field(Disabled; Rec.Disabled)
                {
                    ToolTip = 'Specifies the value of the Disabled field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
