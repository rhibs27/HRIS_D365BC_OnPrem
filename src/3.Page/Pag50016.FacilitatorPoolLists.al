page 50016 "Facilitator Pool Lists"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Facilitator Pool";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field(Province; Rec.Province)
                {
                    ToolTip = 'Specifies the value of the Province field.';
                    ApplicationArea = All;
                }
                // field("Sub Province"; Rec."Sub Province")
                // {
                //     ToolTip = 'Specifies the value of the Sub Province field.';
                //     ApplicationArea = All;
                // }
                field(District; Rec.District)
                {
                    ToolTip = 'Specifies the value of the District field.';
                    ApplicationArea = All;
                }
                field(Branch; Rec.Branch)
                {
                    ToolTip = 'Specifies the value of the Branch field.';
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field(Position; Rec.Position)
                {
                    ToolTip = 'Specifies the value of the Position field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field(Skill; Rec.Skill)
                {
                    ToolTip = 'Specifies the value of the Skill field.';
                    ApplicationArea = All;
                }
                field(Qualification; Rec.Qualification)
                {
                    ToolTip = 'Specifies the value of the Qualification field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Appointed Date"; Rec."Appointed Date")
                {
                    ToolTip = 'Specifies the value of the Appointed Date field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                // Visible = false;
                action("Send Approval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send A&pproval Request action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if not Rec.CheckApprovalEntries(Rec) then begin
                            if (Rec."Approval Status" = Rec."Approval Status"::open) then
                                Rec.OnSendFacilitatorDocForApproval(Rec)
                            else
                                Message('not send');
                        end else
                            Message('Approval not sent');
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.OnCancelFacilitatorDocForApproval(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        OpenApprovalEntriesExist := not (Rec."Approval Status" = Rec."Approval Status"::open);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::open
    end;

    trigger OnOpenPage()
    begin
        //OpenApprovalEntriesExist := CheckApprovalEntries(Rec);
    end;

    var

        OpenApprovalEntriesExist: Boolean;
}
