page 50379 "Det Salary Deduction Entries"
{
    PageType = List;
    SourceTable = "Det Salary Deduction Entry";
    Caption = 'Detailed Salary Deduction Entries';
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Employee No."; Rec."Employee No.") { }
                field("Employee Name"; Rec."Employee Name") { }
                field("Deduction Date"; Rec."Deduction Date") { }
                field("Deduction Type"; Rec."Deduction Type") { }
                field("Pay Cycle Term"; Rec."Pay Cycle Term") { }
                field("Pay Cycle Period"; Rec."Pay Cycle Period") { }
                field("Attribute Type"; Rec."Attribute Type") { }
                field("Attribute Code"; Rec."Attribute Code") { }
                field(Amount; Rec.Amount) { }
                field(Reversed; Rec.Reversed) { }
                field("Reversed From Pay Cycle Term"; Rec."Reversed From Pay Cycle Term") { }
                field("Reversed From Pay Cycle Period"; Rec."Reversed From Pay Cycle Period") { }
                field("Blocked"; Rec.Blocked) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {

        }

    }
}