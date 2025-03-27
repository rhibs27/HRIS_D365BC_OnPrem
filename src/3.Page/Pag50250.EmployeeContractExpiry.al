page 50250 "Employee Contract Expiry"
{
    PageType = List;
    SourceTable = Employee;
    SourceTableView = where(Status = const(Active),
                            "Employment Type" = const(Contract));
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Caption = 'Employee ID';
                    ToolTip = 'Specifies the value of the Employee ID field.';
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.';
                    ApplicationArea = All;
                }
                field(RemainingDays; RemainingDays)
                {
                    Caption = 'Remaining Days';
                    ToolTip = 'Specifies the value of the Remaining Days field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        if Rec."Contract Expiry Date" <> 0D then
            RemainingDays := Rec."Contract Expiry Date" - Today;
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("Contract Expiry Date", '>=%1', Today);
        Rec.FilterGroup(0);
    end;

    var
        RemainingDays: Integer;
}
