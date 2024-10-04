page 33019822 "Vacancy Subforms"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Vacancy Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Salary Level"; Rec."Salary Level")
                {
                    ToolTip = 'Specifies the value of the Salary Level field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Banking Experince"; Rec."Banking Experince")
                {
                    ToolTip = 'Specifies the value of the Banking Experince field.';
                    ApplicationArea = All;
                }
                field("Non Banking Experince"; Rec."Non Banking Experince")
                {
                    ToolTip = 'Specifies the value of the Non Banking Experince field.';
                    ApplicationArea = All;
                }
                field("Minimum Age"; Rec."Minimum Age")
                {
                    ToolTip = 'Specifies the value of the Minimum Age field.';
                    ApplicationArea = All;
                }
                field("Maximum Age"; Rec."Maximum Age")
                {
                    ToolTip = 'Specifies the value of the Maximum Age field.';
                    ApplicationArea = All;
                }
                field("No. of People"; Rec."No. of People")
                {
                    ToolTip = 'Specifies the value of the No. of People field.';
                    ApplicationArea = All;
                }
                field("Qualification Code"; Rec."Qualification Code")
                {
                    ToolTip = 'Specifies the value of the Qualification Code field.';
                    ApplicationArea = All;
                }
                field(Rank; Rec.Rank)
                {
                    ToolTip = 'Specifies the value of the Rank field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
