page 33019851 "Attendance List"
{
    // version ATM.19.01.01

    CardPageId = "Attendance Card";
    Editable = false;
    PageType = List;
    SourceTable = "Attendance Header";
    SourceTableView = where(Posted = const(false));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.';
                    ApplicationArea = All;
                }
                field(Month; Rec.Month)
                {
                    ToolTip = 'Specifies the value of the Month field.';
                    ApplicationArea = All;
                }
                field("From Date (B.S)"; Rec."From Date (B.S)")
                {
                    ToolTip = 'Specifies the value of the From Date (B.S) field.';
                    ApplicationArea = All;
                }
                field("To Date (B.S)"; Rec."To Date (B.S)")
                {
                    ToolTip = 'Specifies the value of the To Date (B.S) field.';
                    ApplicationArea = All;
                }
                field("Nepali Month"; Rec."Nepali Month")
                {
                    ToolTip = 'Specifies the value of the Nepali Month field.';
                    ApplicationArea = All;
                }
                field("Nepali Year"; Rec."Nepali Year")
                {
                    ToolTip = 'Specifies the value of the Nepali Year field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
