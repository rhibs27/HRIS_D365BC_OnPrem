page 50056 "Resign Document Approver Setup"
{
    ApplicationArea = All;
    Caption = 'Resign Document Approver Setup';
    PageType = List;
    SourceTable = "Resign Doc Approver Setup";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Approver Code"; Rec."Approver Code")
                {
                    ToolTip = 'Specifies the value of the Approver Code field.', Comment = '%';
                }
                field("Emp Act Type"; Rec."Emp Act Type")
                {
                    ToolTip = 'Specifies the value of the Emp Act Type field.', Comment = '%';
                }
                field("Deputation Type"; Rec."Deputation Type")
                {
                    ToolTip = 'Specifies the value of the Deputation Type field.', Comment = '%';
                }
                field("Deputation Code"; Rec."Deputation Code")
                {
                    ToolTip = 'Specifies the value of the Deputation Code field.', Comment = '%';
                }
                field("Approver Deputation Type"; Rec."Approver Deputation Type")
                {
                    ToolTip = 'Specifies the value of the Approver Deputation Type field.', Comment = '%';
                }
                field("Approver Deputation Code"; Rec."Approver Deputation Code")
                {
                    ToolTip = 'Specifies the value of the Approver Deputation Code field.', Comment = '%';
                }
                field("Same Deputation Approver"; Rec."Same Deputation Approver")
                {
                    ToolTip = 'Specifies the value of the Same Deputation Approver field.', Comment = '%';
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.', Comment = '%';
                }
                field("Approver Role"; Rec."Approver Role")
                {
                    ToolTip = 'Specifies the value of the Approver Role field.', Comment = '%';
                }
                field("Employee No"; Rec."Employee No")
                {
                    ToolTip = 'Specifies the value of the Employee No field.', Comment = '%';
                }
                field("Approver Sequence"; Rec."Approver Sequence")
                {
                    ToolTip = 'Specifies the value of the Approver Sequence field.', Comment = '%';
                }
            }
        }
    }
}
