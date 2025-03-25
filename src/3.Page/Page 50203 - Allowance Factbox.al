page 50203 "Allowance Factbox"
{


    PageType = ListPart;
    SourceTable = "Payroll Attributes";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control5)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field("No. of Staffs"; Rec."No. of Staffs")
                {
                    ToolTip = 'Specifies the value of the No. of Staffs field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.SetFilter("No. of Staffs", '>%1', 0);
    end;
}
