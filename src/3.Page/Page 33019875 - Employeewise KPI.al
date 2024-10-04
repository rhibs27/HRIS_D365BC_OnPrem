page 33019875 "Employeewise KPI"
{
    PageType = List;
    SourceTable = "Employee Activity Second";
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
                field("Employee No."; Rec."Employee No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Salary Level"; Rec."Salary Level")
                {
                    ToolTip = 'Specifies the value of the Salary Level field.';
                    ApplicationArea = All;
                }
                field("Salary Level Description"; Rec."Salary Level Description")
                {
                    ToolTip = 'Specifies the value of the Salary Level Description field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Functional Title Desc"; Rec."Functional Title Desc")
                {
                    ToolTip = 'Specifies the value of the Functional Title Desc field.';
                    ApplicationArea = All;
                }
                field("Deputation on"; Rec."Deputation on")
                {
                    ToolTip = 'Specifies the value of the Deputation on field.';
                    ApplicationArea = All;
                }
                field(Province; Rec.Province)
                {
                    ToolTip = 'Specifies the value of the Province field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
