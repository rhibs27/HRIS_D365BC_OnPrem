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
                field("KRA Master"; Rec."KRA Master")
                {
                    ApplicationArea = All;
                }
                field("KRA Subtype"; Rec."KRA Subtype")
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
                field("Group Performance Based Score"; Rec."Group Performance Based Score")
                {
                    ApplicationArea = All;
                }
                field("Target Assigned"; Rec."Target Assigned")
                {
                    ApplicationArea = All;
                }
                field("Actual Achievement"; Rec."Actual Achievement")
                {
                    ApplicationArea = All;
                }
                field("Self Rating"; Rec."Self Score")
                {
                    ApplicationArea = All;
                }
                field("Self Remarks"; Rec."Self Remarks")
                {
                    ApplicationArea = All;
                }
                field("Deputation on"; Rec."Deputation on")
                {
                    ApplicationArea = All;
                }
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
                    OpenKPIForKRARelated(Appraisal, HRMgt.ReturnFiscalYear(Appraisal."Requested Date"), Rec."KRA Subtype");
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
                    Appraisal.Validate(Status, Appraisal.Status::"KPI Assigned");
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
                    Appraisal.Validate(Status, Appraisal.Status::Submitted);
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
                    Appraisal.Validate(Status, Appraisal.Status::Reviewed);
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
                    Appraisal.Validate(Status, Appraisal.Status::"Check Reviewed");
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
        KPIEmpRec.SetRange("KRA Master", Rec."KRA Master");
        KPIEmpRec.SetRange("KRA Subtype", Rec."KRA Subtype");
        KPIEmpRec.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        KPIEmpRec.SetRange("Employee Code", AppraisalRec."Employee Code");
        Page.Run(Page::"KPI Employee", KPIEmpRec);
    end;
}