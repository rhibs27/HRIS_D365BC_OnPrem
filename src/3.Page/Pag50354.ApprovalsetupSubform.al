page 50354 "Approval setup Subform"
{
    ApplicationArea = All;
    Caption = 'Approval setup Subform';
    PageType = ListPart;
    SourceTable = "Approval Setup Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee Role"; Rec."Employee Role")
                {
                    ToolTip = 'Specifies the value of the Employee Role field.', Comment = '%';
                }
                field("Approver Role"; Rec."Approver Role")
                {
                    ToolTip = 'Specifies the value of the Approver Role field.', Comment = '%';
                }
                field("Approver Name"; Rec."Approver Role Name")
                {
                    ToolTip = 'Specifies the value of the Approver Role field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
                field("Approval Sequence"; Rec."Approval Sequence")
                {
                    ToolTip = 'Specifies the value of the Approval Sequence field.', Comment = '%';
                }
                field("Deputation Type"; Rec."Deputation Type")
                {
                    ToolTip = 'Specifies the value of the Approval From Same Deputation.', Comment = '%';
                }
                field("Alternative Approval Workflow"; Rec."Alternative Approval Workflow")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var

    begin
        Rec.TestField("Approval Sequence");
    end;
}
