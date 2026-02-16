page 50084 "KRA Subform"
{
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "KPI Employee";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("KPI No."; Rec."KPI No.")
                {
                    ApplicationArea = All;
                }
                field("KRA"; Rec."KRA")
                {
                    ApplicationArea = All;
                }
                field("KPI"; Rec."KPI")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Template"; Rec."Appraisal Template")
                {
                    ApplicationArea = All;
                }
                field("Questionnaire/Description"; Rec."Questionnaire/Description")
                {
                    ApplicationArea = All;
                }
                field("KPI Rating Type"; Rec."KPI Rating Type")
                {
                    ApplicationArea = All;
                }
                field("Weightage"; Rec."Weightage")
                {
                    ApplicationArea = All;
                }
                field("Self Rating Applicable"; Rec."Self Rating Applicable")
                {
                    ApplicationArea = All;
                }
                // field("Target Assigned"; Rec."Target Assigned")
                // {
                //     ApplicationArea = All;
                // }
                // field("Actual Achievement"; Rec."Actual Achievement")
                // {
                //     ApplicationArea = All;
                // }
                // field("Self Rating"; Rec."Self Score")
                // {
                //     ApplicationArea = All;
                // }
                // field("Self Remarks"; Rec."Self Remarks")
                // {
                //     ApplicationArea = All;
                // }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("View Key Performance indices")
            {
                Image = View;
                RunPageOnRec = false;
                ToolTip = 'Executes the View Key Performance indices action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    HRMgt: Codeunit "HR Mgt.";
                begin
                    Appraisal.Get(Rec."Appraisal Code");
                    OpenKPIForKRARelated(Appraisal, HRMgt.ReturnFiscalYear(Appraisal."Requested Date"), Rec."KPI");
                end;
            }
            action(KPIAssigned)
            {
                Image = Confirm;
                ToolTip = 'Executes the KPIAssigned action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Appraisal.Get(Rec."Appraisal Code");
                    Appraisal.Validate("Approval Status", Appraisal."Approval Status"::Pending);
                    Appraisal.Modify;
                end;
            }
            action("KPI Submitted")
            {
                Image = Confirm;
                ToolTip = 'Executes the KPI Submitted action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Appraisal.Get(Rec."Appraisal Code");
                    Appraisal.Validate("Approval Status", Appraisal."Approval Status"::Pending);
                    Appraisal.Modify;
                end;
            }
            action("KPI Reviewed")
            {
                Image = Confirm;
                ToolTip = 'Executes the KPI Reviewed action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Appraisal.Get(Rec."Appraisal Code");
                    Appraisal.Validate("Approval Status", Appraisal."Approval Status"::Pending);
                    Appraisal.Modify;
                end;
            }
            action("Check Reviewed")
            {
                Image = Confirm;
                ToolTip = 'Executes the Check Reviewed action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Appraisal.Get(Rec."Appraisal Code");
                    Appraisal.Validate("Approval Status", Appraisal."Approval Status"::Pending);
                    Appraisal.Modify;
                end;
            }

        }
    }

    var
        Appraisal: Record Appraisal;

    local procedure OpenKPIForKRARelated(AppraisalRec: Record Appraisal; FiscalYear: Text; KeyValueCode: Code[20])
    var
        KPIEmpRec: Record "KPI Employee";
    begin
        KPIEmpRec.Reset;
        KPIEmpRec.SetRange("KRA", Rec."KRA");
        KPIEmpRec.SetRange("KPI", Rec."KPI");
        KPIEmpRec.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        KPIEmpRec.SetRange("Employee Code", AppraisalRec."Employee Code");
        Page.Run(Page::"KPI Employee", KPIEmpRec);
    end;
}