page 50181 "Request Allowance Subform"
{
    ApplicationArea = All;
    Caption = 'Request Allowance Subform';
    PageType = ListPart;
    SourceTable = "Assignment Memo Line";
    SourceTableView = where("Emp Act Type" = const("Request Allowance"));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Editable = FormEditable;

                field("Payroll Attribute Code"; Rec."Payroll Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute Code field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }

                field("Allowance Amount"; Rec."Allowance Amount")
                {
                    ToolTip = 'Specifies the value of the Allowance Amount field.';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    Editable = false;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Reject ALlowance Requests")
            {
                Image = Reject;
                ToolTip = 'Executes the Reject Allowance Claim action.';
                ApplicationArea = All;
                Visible = DocumentPending;
                trigger OnAction()
                var
                    ApproverHrms: Record "Approval HRMS";
                    FilterpageBuilder: FilterPageBuilder;
                    AllowanceAssLine: Record "Allowance Assignment Line";
                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::"Pending");

                    FilterpageBuilder.AddRecord('Input Rejection Remarks', AllowanceAssLine);
                    FilterpageBuilder.AddField('Input Rejection Remarks', AllowanceAssLine."Rejection Remarks");
                    if FilterpageBuilder.RunModal() then begin
                        AllowanceAssLine.SetView(FilterpageBuilder.GetView('Input Rejection Remarks'));
                        if AllowanceAssLine.GetFilter("Rejection Remarks") = '' then
                            Error('Must input rejection remarks to reject the document');

                        Rec."Rejection Remarks" := AllowanceAssLine.GetFilter("Rejection Remarks");
                        Rec.Validate("Approval Status", Rec."Approval Status"::Rejected);
                        rec.Modify();
                    end;

                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetLayout();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Emp Act Type" := Rec."Emp Act Type"::"Request Allowance";
        SetLayout();
    end;

    trigger OnOpenPage()
    begin
        SetLayout;
    end;


    var
        AllowanceTypeFilter: Code[20];
        ToDateEditable, FormEditable, AllowanceClaim : Boolean;
        DocumentOpen, DocumentApproved, DocumentPending : Boolean;
        Typefilter: Text;
        AllowanceAssignmentMgt: Codeunit "Allowance Assignment Mgt";


    local procedure SetLayout()
    var
        AssignmentMemoHeader: Record "Assignment Memo Header";
    begin
        ToDateEditable := true;
        if AssignmentMemoHeader.Get(rec."Document No.") then begin
            DocumentOpen := AssignmentMemoHeader."Approval Status" = AssignmentMemoHeader."Approval Status"::Open;
            DocumentPending := AssignmentMemoHeader."Approval Status" = AssignmentMemoHeader."Approval Status"::Pending;
            DocumentApproved := AssignmentMemoHeader."Approval Status" = AssignmentMemoHeader."Approval Status"::Approved;
        end;
        FormEditable := DocumentOpen;
    end;
}