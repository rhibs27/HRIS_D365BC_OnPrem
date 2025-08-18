page 50011 "Request to Approve HRIS"
{
    ApplicationArea = All;
    Caption = 'Request to Approve HRIS';
    PageType = List;
    SourceTable = "Approval HRMS";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Employee No"; Rec."Employee No")
                {
                    Caption = 'Requested By';
                    ToolTip = 'Specifies the value of the Employee No field.', Comment = '%';
                }
                field("Approver No"; Rec."Approver No")
                {
                    ToolTip = 'Specifies the value of the Approver No field.', Comment = '%';
                }
                field("Approver Name"; Rec."Approver Name")
                {
                    ToolTip = 'Specifies the value of the Approver Name field.', Comment = '%';
                }
                field("Approval Sequence"; Rec."Approval Sequence")
                {
                    ToolTip = 'Specifies the value of the Approval Sequence field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Promoted)
        {
            actionref(OpenRecord; "Record")
            { }
            actionref(ApproveRequest; "Approve Request")
            { }
            actionref(RejectRequest; "Reject Request")
            { }

        }
        area(navigation)
        {
            action("Record")
            {
                ApplicationArea = Suite;
                Caption = 'Open Record';
                Image = Document;
                Scope = Repeater;
                ToolTip = 'Open the document, journal line, or card that the approval is requested for.';

                trigger OnAction()
                begin
                    Rec.ShowRecord();
                end;
            }
            action("Approve Request")
            {
                ApplicationArea = Suite;
                Caption = 'Approve';
                Image = Approve;
                Scope = Repeater;
                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(ApprovalHRMS);
                    if ApprovalHRMS.FindSet() then
                        repeat
                            ApprovalHRMS.ApproveRecord();
                        until ApprovalHRMS.Next() = 0;
                    CurrPage.Update();
                end;
            }
            action("Reject Request")
            {
                ApplicationArea = Suite;
                Caption = 'Reject';
                Image = Reject;
                Scope = Repeater;
                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(ApprovalHRMS);
                    if ApprovalHRMS.FindSet() then
                        repeat
                            ApprovalHRMS.RejectRecord();
                        until ApprovalHRMS.Next() = 0;
                    CurrPage.Update();
                end;
            }

        }
    }
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Rec.FilterGroup(0);
        Rec.SetRange("Approval Status", Rec."Approval Status"::Open);
    end;

    var
        HrMgt: Codeunit "HR Mgt.";
        ApprovalHRMS: Record "Approval HRMS";

}
