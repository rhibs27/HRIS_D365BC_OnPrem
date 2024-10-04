page 50246 "BOD/EOD Card"
{
    Editable = false;
    PageType = Card;
    SourceTable = "BOD-EOD Header";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("EOD/BOD Date"; Rec."EOD/BOD Date")
                {
                    ToolTip = 'Specifies the value of the EOD/BOD Date field.';
                    ApplicationArea = All;
                }
                field("Reviewer Code"; Rec."Reviewer Code")
                {
                    ToolTip = 'Specifies the value of the Reviewer Code field.';
                    ApplicationArea = All;
                }
                field("Reviewer Name"; Rec."Reviewer Name")
                {
                    ToolTip = 'Specifies the value of the Reviewer Name field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ToolTip = 'Specifies the value of the Created DateTime field.';
                    ApplicationArea = All;
                }
                field("BOD Remarks"; Rec."BOD Remarks")
                {
                    ToolTip = 'Specifies the value of the BOD Remarks field.';
                    ApplicationArea = All;
                }
                field("EOD Remarks"; Rec."EOD Remarks")
                {
                    ToolTip = 'Specifies the value of the EOD Remarks field.';
                    ApplicationArea = All;
                }
                field("BOD-Status"; Rec."BOD-Status")
                {
                    ToolTip = 'Specifies the value of the BOD-Status field.';
                    ApplicationArea = All;
                }
                field("EOD-Status"; Rec."EOD-Status")
                {
                    ToolTip = 'Specifies the value of the EOD-Status field.';
                    ApplicationArea = All;
                }
                field("Province Name"; Rec."Province Name")
                {
                    ToolTip = 'Specifies the value of the Province Name field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("Sub-Province Name"; Rec."Sub-Province Name")
                {
                    ToolTip = 'Specifies the value of the Sub-Province Name field.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                }
                field("Functional Title Description"; Rec."Functional Title Description")
                {
                    ToolTip = 'Specifies the value of the Functional Title Description field.';
                    ApplicationArea = All;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ToolTip = 'Specifies the value of the Unit Name field.';
                    ApplicationArea = All;
                }
                field("Extension Counter Name"; Rec."Extension Counter Name")
                {
                    ToolTip = 'Specifies the value of the Extension Counter Name field.';
                    ApplicationArea = All;
                }
            }
            part("BOD Subform"; "EOD/BOD Subform")
            {
                SubPageLink = "Entry No" = field("Entry No.");
                SubPageView = where("Is Created on EOD" = const(false));
                ApplicationArea = All;
            }
            part("EOD Subfrom"; "EOD/BOD Subform")
            {
                SubPageLink = "Entry No" = field("Entry No.");
                ApplicationArea = All;
            }
        }
    }

    actions { }
}
