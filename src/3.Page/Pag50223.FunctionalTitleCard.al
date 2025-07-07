page 50223 "Functional Title Card"
{
    // version KPI1.00

    PageType = Card;
    SourceTable = "Functional Title";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("COPO/COSPO Allowance"; Rec."COPO/COSPO Allowance")
                {
                    ToolTip = 'Specifies the value of the PH/ DPH Allowance field.';
                    Caption = 'PH/ DPH Allowance';
                    ApplicationArea = All;
                }
                field("BM Allowance"; Rec."BM Allowance")
                {
                    ToolTip = 'Specifies the value of the BM Allowance field.';
                    Caption = 'BM Allowance';
                    ApplicationArea = All;
                }
                field(Locationwise; Rec.Locationwise)
                {
                    ToolTip = 'Specifies the value of the Locationwise field.';
                    ApplicationArea = All;
                }
                field("Communication Rein."; Rec."Communication Rein.")
                {
                    Caption = 'Communication Reimbursement';
                    ToolTip = 'Specifies the value of the Communication Reimbursement field.';
                    ApplicationArea = All;
                }
                field("Rank Value"; Rec."Rank Value")
                {
                    ToolTip = 'Specifies the value of the Rank Value field.';
                    ApplicationArea = All;
                }
                field("Rank Check Range"; Rec."Rank Check Range")
                {
                    ToolTip = 'Specifies the value of the Rank Check Range field.';
                    ApplicationArea = All;
                }
                field("Check Branchwise Only"; Rec."Check Branchwise Only")
                {
                    ToolTip = 'Specifies the value of the Check Branchwise Only field.';
                    ApplicationArea = All;
                }
                field("Risk Title"; Rec."Risk Title")
                {
                    Caption = 'Risk and Morning counter Title Elligible';
                    ToolTip = 'Specifies the value of the Risk Title field.';
                    ApplicationArea = All;
                }
                field("Written Exam"; Rec."Written Exam")
                {
                    ToolTip = 'Specifies the value of the Written Exam field.';
                    ApplicationArea = All;
                }
                field("Group Discussion"; Rec."Group Discussion")
                {
                    ToolTip = 'Specifies the value of the Group Discussion field.';
                    ApplicationArea = All;
                }
                field("Evening Counter Eligible"; Rec."Evening Counter Eligible")
                {
                    ToolTip = 'Specifies the value of the Evening Counter Eligible field.';
                    ApplicationArea = All;
                }
                field("Holiday Counter Eligible"; Rec."Holiday Counter Eligible")
                {
                    ToolTip = 'Specifies the value of the Holiday Counter Eligible field.';
                    ApplicationArea = All;
                }
                field("Allowance Reminder Mail"; Rec."Allowance Reminder Mail")
                {
                    ToolTip = 'Specifies the value of the Allowance Reminder Mail field.';
                    ApplicationArea = All;
                }
                field("Is Allowance Approval"; Rec."Is Allowance Approval")
                {
                    ToolTip = 'Specifies the value of the Is Allowance Approval field.';
                    ApplicationArea = All;
                }
                field("EM/ECM Identifier"; Rec."EM/ECM Identifier")
                {
                    ToolTip = 'Specifies the value of the EM/ECM Identifier field.';
                    ApplicationArea = All;
                }
                field("BM/OBM"; Rec."BM/OBM")
                {
                    ToolTip = 'Specifies the value of the BM/OBM field.';
                    ApplicationArea = All;
                }
                field("KPI Incentive %"; Rec."KPI Incentive %")
                {
                    ToolTip = 'Specifies the value of the KPI Incentive % field.';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.';
                    ApplicationArea = All;
                }
            }
            // part(Control13; "Access Control Subform")
            // {
            //     SubPageLink = Type = const("Funtional Title"),
            //                   Code = field(Code);
            //     ApplicationArea = All;
            // }
        }
    }

    actions
    {
        area(Creation)
        {
            // action("KPI Setup")
            // {
            //     RunObject = Page Page60273;
            //     RunPageLink = Field1 = CONST("0"),
            //                   Field2 = FIELD(Code);
            //     Scope = Repeater;
            //     ToolTip = 'Executes the KPI Setup action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         /*FunctionalTitle := GETFILTER(Code);//KPI1.00
            //         IF FunctionalTitle <> '' THEN
            //           Code := FunctionalTitle;
            //         */

            //     end;
            // }
        }
    }
}
