page 50073 "Suspension Level Setup"
{
    ApplicationArea = All;
    Caption = 'Suspension Level Setup';
    PageType = List;
    SourceTable = "Suspension Level";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Payroll Impact"; Rec."Payroll Impact")
                {
                    ToolTip = 'Specifies the value of the Payroll Impact field.', Comment = '%';
                }
                field("Payroll Impact Percentage"; Rec."Payroll Impact Percentage")
                {
                    ToolTip = 'Specifies the value of the Payroll Impact Percentage field.', Comment = '%';
                }
            }
        }
    }
}
