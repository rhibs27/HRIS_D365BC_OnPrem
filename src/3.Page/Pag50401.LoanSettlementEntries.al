page 50401 "Loan Settlement Entries"
{
    Caption = 'Loan Settlement Entries';
    PageType = List;
    SourceTable = "Loan Settlement Entry";
    Editable = false;
    ApplicationArea = All;
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the entry number.';
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ToolTip = 'Specifies the loan document number.';
                    ApplicationArea = All;
                }
                field("Settlement Source No."; Rec."Settlement Source No.")
                {
                    ToolTip = 'Specifies the settlement request document that generated this entry.';
                    ApplicationArea = All;
                }
                field("Settlement Date"; Rec."Settlement Date")
                {
                    ToolTip = 'Specifies the date this settlement was posted.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the employee number.';
                    ApplicationArea = All;
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ToolTip = 'Specifies the type of loan.';
                    ApplicationArea = All;
                }
                field("Settlement Type"; Rec."Settlement Type")
                {
                    ToolTip = 'Specifies whether this was a full or partial settlement.';
                    ApplicationArea = All;
                }
                field("Settled Amount"; Rec."Settled Amount")
                {
                    ToolTip = 'Specifies the amount settled in this entry.';
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the user who posted this settlement.';
                    ApplicationArea = All;
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ToolTip = 'Specifies the date and time this entry was created.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
