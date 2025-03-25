page 50093 "Travel Requests"
{
    CardPageId = "Travel Form";
    // Editable = false;
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Travel Request";
    PromotedActionCategories = 'New,Process,Report,SetFilter';
    SourceTableView = WHERE(Type = CONST("Travel Request"));
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field(Extended; Rec.Extended)
                {
                    ToolTip = 'Specifies the value of the Extended Travel field.';
                    ApplicationArea = All;
                }
                field("Travel Claimed"; Rec."Travel Claimed")
                {
                    ToolTip = 'Specifies the value of the Travel Claimed field.';
                    ApplicationArea = All;
                }
                field("Advance Cash Required"; Rec."Advance Cash Required")
                {
                    ToolTip = 'Specifies the value of the Advance Cash Required field.';
                    ApplicationArea = All;
                }
                field("Purpose of Travel"; Rec."Purpose of Travel")
                {
                    ToolTip = 'Specifies the value of the Purpose of Travel field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Recommend Travel Request")
            {
                Image = Register;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Recommend Travel Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // if Confirm('Do you want to recommend the travel request?', false) then
                    //     TravelMgt.RecommendEmployeeTravel(Rec."No.");
                end;
            }
            action("Approve Travel Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                ToolTip = 'Executes the Approve Travel Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the travel request?', false) then
                        ApprovalMgt.ApproveRejectDocument(RecRef, true);
                end;
            }
            action("Reject Travel Request")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Reject Travel Request action.';
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    if Confirm('Do you want to reject travel requet?', false) then
                        ApprovalMgt.ApproveRejectDocument(RecRef, false);
                end;
            }
        }
        area(Navigation)
        {
            action(Open)
            {
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Open action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetFilter("Approval Status", '%1|%2', Rec."Approval Status"::" ", Rec."Approval Status"::Open);
                    Rec.FilterGroup(0);
                end;
            }
            action(Screened)
            {
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Screened action.';
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                begin
                    // Rec.FilterGroup(2);
                    // ClearAll();
                    // Rec.SetRange("Approval Status", Rec."Approval Status"::Screened);
                    // Rec.FilterGroup(0);
                end;
            }
            action("Pending Approval")
            {
                Image = PendingApproval;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Pending Approval action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Pending);
                    Rec.FilterGroup(0);
                end;
            }
            action(Recommended)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Recommended action.';
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    // Rec.FilterGroup(2);
                    // ClearAll();
                    // Rec.SetRange("Approval Status", Rec."Approval Status"::Recommended);

                    // Rec.FilterGroup(0);
                end;
            }
            action(Approved)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Approved action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Approved);
                    Rec.FilterGroup(0);
                end;
            }
            action(Rejected)
            {
                Image = DeleteQtyToHandle;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Rejected action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Rejected);
                    Rec.FilterGroup(0);
                end;
            }
            action("Final Approve")
            {
                Image = Flow;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Final Approve action.';
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    // Rec.FilterGroup(2);
                    // ClearAll();
                    // Rec.SetRange("Approval Status", Rec."Approval Status"::"Final Approved & Forwarded to Finance Department");
                    // Rec.FilterGroup(0);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        RecRef.GetTable(Rec);
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        [InDataSet]
        IsPending: Boolean;
        TravelMgt: CodeUnit "Travel Mgt.";
        ApprovalMgt: Codeunit "Approver Mgt";
        RecRef: RecordRef;
}
