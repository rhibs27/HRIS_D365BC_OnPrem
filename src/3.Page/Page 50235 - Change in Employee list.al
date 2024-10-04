page 50235 "Change in Employee list"
{
    ApplicationArea = BasicHR;
    Editable = false;
    PageType = List;
    SourceTable = "Employee Activity";
    SourceTableView = where(Type = const("Changes in employee"));
    UsageCategory = Lists;

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
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    ToolTip = 'Specifies the value of the Mobile No. field.';
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ToolTip = 'Specifies the value of the Marital Status field.';
                    ApplicationArea = All;
                }
                field("Email (Personal)"; Rec."Email (Personal)")
                {
                    ToolTip = 'Specifies the value of the Email (Personal) field.';
                    ApplicationArea = All;
                }
                field("Passport No."; Rec."Passport No.")
                {
                    ToolTip = 'Specifies the value of the Passport No. field.';
                    ApplicationArea = All;
                }
                field("Differently Able"; Rec."Differently Able")
                {
                    ToolTip = 'Specifies the value of the Differently Able field.';
                    ApplicationArea = All;
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    ToolTip = 'Specifies the value of the Vehicle Type field.';
                    ApplicationArea = All;
                }
                field("Temporary Address"; Rec."Temporary Address")
                {
                    ToolTip = 'Specifies the value of the Temporary Address field.';
                    ApplicationArea = All;
                }
                field("Temporary Province"; Rec."Temporary Province")
                {
                    ToolTip = 'Specifies the value of the Temporary Province field.';
                    ApplicationArea = All;
                }
                field(VDC; Rec.VDC)
                {
                    ToolTip = 'Specifies the value of the VDC field.';
                    ApplicationArea = All;
                }
                field("Temporary District"; Rec."Temporary District")
                {
                    ToolTip = 'Specifies the value of the Temporary District field.';
                    ApplicationArea = All;
                }
                field(House; Rec.House)
                {
                    ToolTip = 'Specifies the value of the House field.';
                    ApplicationArea = All;
                }
                field("Blood Group"; Rec."Blood Group")
                {
                    ToolTip = 'Specifies the value of the Blood Group field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Approve action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve this document?', false) then
                        HRMgt.ApproveRejctChangeforEmp(Rec, true);
                end;
            }
            action(Reject)
            {
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Reject action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to reject this document?', false) then
                        HRMgt.ApproveRejctChangeforEmp(Rec, false);
                end;
            }
        }
    }

    var
        HRMgt: Codeunit "HR Mgt.";
}
