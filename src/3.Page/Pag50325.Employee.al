page 50325 Employee
{
    // ApplicationArea = All;
    Caption = 'Employee';
    PageType = List;
    SourceTable = Employee;
    Editable = false;
    SourceTableView = where(Status = const(Active));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number for the employee';
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Salary Level Description"; Rec."Salary Level Description")
                {
                    ToolTip = 'Specifies the value of the Salary Level Description field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
