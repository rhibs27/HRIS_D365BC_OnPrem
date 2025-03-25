page 50102 "Travel Claim Lists"
{
    CardPageId = "Travel Claim";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,SetFilter';
    SourceTable = "Travel Request";
    SourceTableView = WHERE(Type = CONST("Travel Claim"));
    UsageCategory = Lists;
    ApplicationArea = All;

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
                field("Type Of Visit"; Rec."Type Of Visit")
                {
                    ToolTip = 'Specifies the value of the Type Of Visit field.';
                    ApplicationArea = All;
                }
                field("Claim Type"; Rec."Claim Type")
                {
                    ToolTip = 'Specifies the value of the Claim Type field.';
                    ApplicationArea = All;
                }
                field("Travel Claimed"; Rec."Travel Claimed")
                {
                    ToolTip = 'Specifies the value of the travel Claim field.';
                    ApplicationArea = All;
                }
                field("Advance Cash"; Rec."Advance Cash")
                {
                    ToolTip = 'Specifies the value of the Advance Cash field.';
                    ApplicationArea = All;
                }
                field("Travel With"; TravelWith."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
                field("Net Receivable/Payable"; Rec."Net Receivable/Payable")
                {
                    ToolTip = 'Specifies the value of the Net Receivable/Payable field.';
                    ApplicationArea = All;
                }
                field("Total Claimed Amount"; Rec."Total Claimed Amount")
                {
                    ToolTip = 'Specifies the value of the Total Claimed Amount field.';
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
                    // if Confirm('Do you want to recommend the travel claim?', false) then
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
                    if Confirm('Do you want to approve the travel claim?', false) then
                        TravelMgt.ApprovedRejectTravelApproval(true, Rec."No.");
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
                    if Confirm('Do you want to reject travel claim?', false) then
                        TravelMgt.ApprovedRejectTravelApproval(false, Rec."No.");
                end;
            }
            action(Screen)
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Screen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // TravelMgt.ScreenResignationforTravel(Rec);
                    // CurrPage.Close;
                end;
            }
            action("Final Approve Request")
            {
                Caption = 'Final Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Final Approve action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // TravelMgt.FinalApproveForTravel(Rec);
                    // CurrPage.Close;
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
        area(Reporting)
        {
            action("Print Travel Claim")
            {
                Image = Travel;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Print Travel Claim action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if not Confirm('Do you want to print travel claim ?', false) then
                        exit;
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(Report::"Travel Claim Processing Report", true, false, Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Clear(TravelWith);
        // IsRecommended := Rec."Approval Status" = Rec."Approval Status"::Recommended;
        // IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        //IsScreened := Rec."Approval Status" = Rec."Approval Status"::Screened;
        // if Salarylevel.Get(Rec."Salary Level Code") then;
        // if TravelWith.Get(Rec."Travel With") then;
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        TravelMgt: Codeunit "Travel Mgt.";
        [InDataSet]
        IsPending: Boolean;
        IsApproved: Boolean;
        //IsScreened: Boolean;
        Salarylevel: Record "Salary Level";
        TravelWith: Record Employee;
}
