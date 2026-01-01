page 50378 "Det Salary Deduction Entries"
{
    PageType = List;
    SourceTable = "Det Salary Deduction Entries";
    Caption = 'Detailed Salary Deduction Entries';
    ApplicationArea = All;
    //Editable = false;
    UsageCategory = Lists;

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
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}
