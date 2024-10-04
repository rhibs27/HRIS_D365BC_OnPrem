page 33019868 "Resignation List"
{
    // version NIC Asia1.00

    CardPageId = "Resignation Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Resignation";
    SourceTableView = WHERE(Type = CONST(Resignation));
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
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Recommender Code"; Rec."Recommender Code")
                {
                    ToolTip = 'Specifies the value of the Recommender Code field.';
                    ApplicationArea = All;
                }
                field("Approver Code"; Rec."Approver Code")
                {
                    ToolTip = 'Specifies the value of the Approver Code field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(Open)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Open action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ClearAll();
                    Rec.FilterGroup(2);
                    Rec.SetFilter("Approval Status", '%1|%2', Rec."Approval Status"::" ", Rec."Approval Status"::Open);
                    Rec.FilterGroup(0);
                end;
            }
            action("Pending Approval")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Pending Approval action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ClearAll();
                    Rec.FilterGroup(2);
                    Rec.SetRange("Approval Status", Rec."Approval Status"::"Pending Approval");
                    Rec.FilterGroup(0);
                end;
            }
            action(Verified)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Verified action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ClearAll();
                    Rec.FilterGroup(2);
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Screened);
                    Rec.FilterGroup(0);
                end;
            }
            action(Recommended)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Recommended action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ClearAll();
                    Rec.FilterGroup(2);
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Recommended);
                    Rec.SetRange("Approver Code", HRMgt.GetEmployeeNo());
                    Rec.FilterGroup(0);
                end;
            }
            action(Approved)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Approved action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ClearAll();
                    Rec.FilterGroup(2);
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Approved);
                    Rec.FilterGroup(0);
                end;
            }
            action(Rejected)
            {
                Image = DeleteQtyToHandle;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Rejected action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Rejected);
                end;
            }
        }
    }

    var
        HRMgt: Codeunit "HR Mgt.";
}
