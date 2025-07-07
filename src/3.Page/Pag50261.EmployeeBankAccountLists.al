page 50261 "Employee Bank Account Lists"
{
    ApplicationArea = All;
    Caption = 'Employee Bank Account Lists';
    PageType = List;
    SourceTable = "Employee Bank Account";
    UsageCategory = Lists;
    CardPageId = "Employee Bank Account Card";
    InsertAllowed = false;
    Editable = false;

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
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ToolTip = 'Specifies the value of the Name 2 field.', Comment = '%';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field.', Comment = '%';
                }
                field("Primary Payroll Account"; Rec."Primary Payroll Account")
                {
                    ToolTip = 'Specifies the Primary Payroll Account';
                }
            }
        }
    }
}
