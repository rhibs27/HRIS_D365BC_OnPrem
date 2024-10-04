page 33019922 "Vacancy List"
{
    // version HRM1.00

    CardPageId = "Vacancy Card";
    Editable = false;
    PageType = List;
    SourceTable = "Vacancy Header";
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
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the Reference No. field.';
                    ApplicationArea = All;
                }
                field("Date of Request"; Rec."Date of Request")
                {
                    ToolTip = 'Specifies the value of the Date of Request field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Position to be filled field.';
                    ApplicationArea = All;
                }
                field(Location; Rec.Location)
                {
                    ToolTip = 'Specifies the value of the Location field.';
                    ApplicationArea = All;
                }
                field("Budget Salary / CTC"; Rec."Budget Salary / CTC")
                {
                    ToolTip = 'Specifies the value of the Budget Salary / CTC field.';
                    ApplicationArea = All;
                }
                field("Existing Salary"; Rec."Existing Salary")
                {
                    ToolTip = 'Specifies the value of the Existing Salary field.';
                    ApplicationArea = All;
                }
                field("New Position Salary"; Rec."New Position Salary")
                {
                    ToolTip = 'Specifies the value of the New Position Salary field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        if not IsOpenFromRecruitment then begin
            Rec.FilterGroup(2);
            Rec.SetRange(Posted, false);
            Rec.FilterGroup(0);
        end;
    end;

    var
        StyleTxt: Text;
        IsOpenFromRecruitment: Boolean;

    procedure FromRecruitment()
    begin
        IsOpenFromRecruitment := true;
    end;
}
