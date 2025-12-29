page 50187 "Payroll Setup Lines"
{
    ApplicationArea = All;
    Caption = 'Payroll Setup Lines';
    PageType = ListPart;
    SourceTable = "Payroll Setup Lines";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.', Comment = '%';
                }
                field("Tax Ex. Amt Divsion"; Rec."Tax Ex. Amt Divsion")
                {
                    ToolTip = 'Specifies the value of the Tax Ex. Amt Divsion field.', Comment = '%';
                }

                field("Tax Ex. Amt. not Exceeding"; Rec."Tax Ex. Amt. not Exceeding")
                {
                    ApplicationArea = All;
                }
                field("Tax Ex. Amt. not Exceeding SSF"; Rec."Tax Ex. Amt. not Exceeding SSF")
                {
                    ApplicationArea = All;
                }
                field("Tax Ex. Insurance Amt."; Rec."Tax Ex. Insurance Amt.")
                {
                    ApplicationArea = All;
                }
                field("Tax Ex. Medical Insurance Amt."; Rec."Tax Ex. Medical Insurance Amt.")
                {
                    ApplicationArea = All;
                }
                field("Tax Ex. House Insurance Amt."; Rec."Tax Ex. House Insurance Amt.")
                {
                    ApplicationArea = All;
                }
                field("Tax Ex. Amt. on Donation"; Rec."Tax Ex. Amt. on Donation")
                {
                    ApplicationArea = All;
                }
                field("Tax Ex. Amt. not Exceed Don."; Rec."Tax Ex. Amt. not Exceed Don.")
                {
                    ApplicationArea = All;
                }
                field("Tax Ex. Amt. on Medical Reim"; Rec."Tax Ex. Amt. on Medical Reim")
                {
                    ApplicationArea = All;
                }
                field("Tax Ex. Amt. not Exceed Med."; Rec."Tax Ex. Amt. not Exceed Med.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
