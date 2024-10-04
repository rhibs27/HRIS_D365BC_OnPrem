page 50094 "HR Transfer Requests"
{
    // //Min -- Added field of "Shortcut Dimension 1 Code (To)".

    CardPageId = "Transfer Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Employee/HR Transfer";
    SourceTableView = WHERE(Type = CONST("HR Transfer"));
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
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
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
                field("Transfer Category"; Rec."Transfer Category")
                {
                    ToolTip = 'Specifies the value of the Transfer Category field.';
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
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("Transfer Effective Date"; Rec."Transfer Effective Date")
                {
                    ToolTip = 'Specifies the value of the Transfer Effective Date field.';
                    ApplicationArea = All;
                }
                field("Acknowledged Date"; Rec."Acknowledged Date")
                {
                    ToolTip = 'Specifies the value of the Acknowledged Date field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
                field("Cancelled Date"; Rec."Cancelled Date")
                {
                    ToolTip = 'Specifies the value of the Cancelled Date field.';
                    ApplicationArea = All;
                }
                field(Cancelled; Rec.Cancelled)
                {
                    ToolTip = 'Specifies the value of the Cancelled field.';
                    ApplicationArea = All;
                }
                field("Deputation On (To)"; Rec."Deputation On (To)")
                {
                    ToolTip = 'Specifies the value of the Deputation On (To) field.';
                    ApplicationArea = All;
                }
                field("Deputation Value"; DeputationValue)
                {
                    ToolTip = 'Specifies the value of the DeputationValue field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code (To)"; Rec."Shortcut Dimension 1 Code (To)")
                {
                    Caption = 'Branch Code (To)';
                    ToolTip = 'Specifies the value of the Branch Code (To) field.';
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
            }
        }
    }

    actions
    {
        area(Processing)
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
            action(Screened)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Screened action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ClearAll();
                    Rec.FilterGroup(2);
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Screened);
                    Rec.FilterGroup(0);
                end;
            }
            action("Pending Approval")
            {
                Image = PendingApproval;
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
                    Rec.SetRange("Recommender Code", HRMgt.GetEmployeeNo());
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
            action(Reviewed)
            {
                Image = ReviewWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Reviewed action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ClearAll();
                    Rec.FilterGroup(2);
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Reviewed);
                    Rec.SetRange(Reviewer, HRMgt.GetEmployeeNo());
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

    trigger OnAfterGetRecord()
    begin
        DeputationValue := ExitTransferDeputationWise(Rec."Deputation On (To)");
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        GLSetup: Record "General Ledger Setup";
        DeputationValue: Text;

    local procedure ExitTransferDeputationWise(DeputationOn: Option " ",Branch,"Extension Counter","Sub Province",Province,Unit,Department): Text
    var
        DimValue: Record "Dimension Value";
        Depart: Record Department;
        EmpHie: Record "Employee Hierarchy Master";
        SubProvince: Record "Sub Province";
        Province: Record Province;
    begin
        Clear(DimValue);
        Clear(Depart);
        Clear(EmpHie);
        Clear(SubProvince);
        Clear(Province);
        GLSetup.Get;
        case DeputationOn of
            DeputationOn::Branch:
                begin
                    if DimValue.Get(GLSetup."Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code (To)") then
                        exit(DimValue.Name);
                end;

            DeputationOn::Department:
                begin
                    if Depart.Get(Rec."Department Code (To)") then
                        exit(Depart.Name);
                end;

            DeputationOn::"Extension Counter":
                begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    EmpHie.SetRange(Code, Rec."Extension Counter (To)");
                    if EmpHie.FindFirst then
                        exit(EmpHie.Description);
                end;

            DeputationOn::"Sub Province":
                begin
                    SubProvince.Reset;
                    SubProvince.SetRange(Code, Rec."Sub Province Code (To)");
                    if SubProvince.FindFirst then
                        exit(SubProvince.City);
                end;

            DeputationOn::Unit:
                begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::Unit);
                    EmpHie.SetRange(Code, Rec."Unit (To)");
                    if EmpHie.FindFirst then
                        exit(EmpHie.Description);
                end;

            DeputationOn::Province:
                begin
                    if Province.Get(Rec."Province Code (To)") then
                        exit(Province.Description);
                end;
        end;
    end;
}
