page 50151 "Allowance Assign. Substitute"
{
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Allowance Assignment Line";
    SourceTableTemporary = true;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Substitute Employee")
            {
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Substitute action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    AllowanceLine, AllowanceLine1 : Record "Allowance Assignment Line";
                begin
                    AllowanceLine.Init();
                    AllowanceLine.TransferFields(Rec);
                    AllowanceLine.Validate("Allowance Type", Rec."Allowance Type");
                    AllowanceLine.Validate("Employee Code", Rec."Employee Code");
                    AllowanceLine.Validate("From Date", Rec."From Date");
                    AllowanceLine."Approval Status" := Rec."Approval Status"::"Pending";
                    AllowanceAssignmentMgt.GetLineNo(AllowanceLine);
                    AllowanceLine.Insert();
                    if AllowanceLine1.Get(Rec."No.", Rec."Substitute of Line No.") then
                        AllowanceLine1."Substitute Type" := Rec."Substitute Type"::Substituted;
                    AllowanceLine1.Modify();
                    Message('%1 is Successfully Substituted by %2', Rec."Allowance Type", Rec."Employee Name");
                    CurrPage.Close();
                end;
            }
        }
    }
    var
        AllowanceLine: Record "Allowance Assignment Line";
        AllowanceAssignmentMgt: Codeunit "Allowance Assignment Mgt";
}
