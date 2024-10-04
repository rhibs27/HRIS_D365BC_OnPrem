page 33019884 "KRA Subform"
{
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "KRA Subform List";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("KRA Category"; Rec."KRA Category")
                {
                    ToolTip = 'Specifies the value of the KRA Category field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Key Result Area"; Rec."Key Result Area")
                {
                    ToolTip = 'Specifies the value of the Key Result Area field.';
                    ApplicationArea = All;
                }
                field("Weightage (%)"; Rec."Weightage (%)")
                {
                    ToolTip = 'Specifies the value of the Weightage (%) field.';
                    ApplicationArea = All;
                }
                field(Score; Rec.Score)
                {
                    ToolTip = 'Specifies the value of the Score field.';
                    ApplicationArea = All;
                }
                field("Final Score"; Rec."Final Score")
                {
                    ToolTip = 'Specifies the value of the Final Score field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Reviewers Score"; Rec."Reviewers Score")
                {
                    ToolTip = 'Specifies the value of the Reviewers Score field.';
                    ApplicationArea = All;
                }
                field("Reviewers Remarks"; Rec."Reviewers Remarks")
                {
                    ToolTip = 'Specifies the value of the Reviewers Remarks field.';
                    ApplicationArea = All;
                }
                field("Check Reviewers Score"; Rec."Check Reviewers Score")
                {
                    ToolTip = 'Specifies the value of the Check Reviewers Score field.';
                    ApplicationArea = All;
                }
                field("Reviewers Final Score"; Rec."Reviewers Final Score")
                {
                    ToolTip = 'Specifies the value of the Reviewers Final Score field.';
                    ApplicationArea = All;
                }
                field("Check Reviewers Final Score"; Rec."Check Reviewers Final Score")
                {
                    ToolTip = 'Specifies the value of the Check Reviewers Final Score field.';
                    ApplicationArea = All;
                }
                field("Check Reviewers Remarks"; Rec."Check Reviewers Remarks")
                {
                    ToolTip = 'Specifies the value of the Check Reviewers Remarks field.';
                    ApplicationArea = All;
                }
                field("HR Score"; Rec."HR Score")
                {
                    ToolTip = 'Specifies the value of the HR Score field.';
                    ApplicationArea = All;
                }
                field("HR Remarks"; Rec."HR Remarks")
                {
                    ToolTip = 'Specifies the value of the HR Remarks field.';
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
                Promoted = true;
                RunPageOnRec = false;
                ToolTip = 'Executes the View Key Performance indices action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    HRMgt: Codeunit "HR Mgt.";
                begin
                    Appraisal.Get(Rec."Appraisal Code");
                    OpenKPIForKRARelated(Appraisal, HRMgt.ReturnFiscalYear(Appraisal."Requested Date"), Rec."Key Result Area");
                end;
            }
            action("KPI Submitted")
            {
                Image = Confirm;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
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
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
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
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Check Reviewed action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Appraisal.Get(Rec."Appraisal Code");
                    Appraisal.Validate(Status, Appraisal.Status::"Check Reviewed");
                    Appraisal.Modify;
                end;
            }
            action(KPIAssigned)
            {
                Image = Confirm;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the KPIAssigned action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Appraisal.Get(Rec."Appraisal Code");
                    Appraisal.Validate(Status, Appraisal.Status::"KPI Assigned");
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
        KPIEmpRec.SetRange("KRA Category", Rec."KRA Category");
        KPIEmpRec.SetRange("Key Result Area", Rec."Key Result Area");
        KPIEmpRec.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        KPIEmpRec.SetRange("Employee Code", AppraisalRec."Employee Code");
        Page.Run(Page::"KPI Employee", KPIEmpRec);
    end;
}
