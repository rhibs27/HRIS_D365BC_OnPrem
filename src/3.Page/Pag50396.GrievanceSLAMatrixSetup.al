page 50396 "Grievance SLA Matrix Setup"
{
    PageType = List;
    SourceTable = "Grievance SLA Matrix";
    ApplicationArea = All;
    Caption = 'Grievance SLA Matrix Setup';
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority level (P1=Critical, P2=High, P3=Medium, P4=Low).';
                }
                field(Severity; Rec.Severity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the severity level (S1=Critical, S2=High, S3=Medium, S4=Low).';
                }
                field("Response Time (Hours)"; Rec."Response Time (Hours)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum hours within which the grievance must be acknowledged.';
                }
                field("Resolution Time (Hours)"; Rec."Resolution Time (Hours)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum hours within which the grievance must be resolved.';
                }
                field("Escalation Time (Hours)"; Rec."Escalation Time (Hours)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the hours after which an unresolved grievance is escalated.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional details about this SLA configuration.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PopulateDefaults)
            {
                Caption = 'Populate Default SLA';
                Image = SetupList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                ToolTip = 'Populates the SLA Matrix with default values for all Priority and Severity combinations.';
                trigger OnAction()
                begin
                    InsertDefaultSLAMatrix();
                    Message('Default SLA Matrix values have been populated.');
                end;
            }
        }
    }

    local procedure InsertDefaultSLAMatrix()
    var
        SLAMatrix: Record "Grievance SLA Matrix";
        Priority: Enum "Grievance Priority";
        Severity: Enum "Grievance Severity";
    begin
        // P1 (Critical) combinations
        InsertSLALine(Severity::Critical, Priority::S1, 'P1-S1: Highest urgency - immediate response required');
        InsertSLALine(Severity::Critical, Priority::S2, 'P1-S2: Critical priority with high severity');
        InsertSLALine(Severity::Critical, Priority::S3, 'P1-S3: Critical priority with medium severity');
        InsertSLALine(Severity::Critical, Priority::S4, 'P1-S4: Critical priority with low severity');

        // P2 (High) combinations
        InsertSLALine(Severity::High, Priority::S1, 'P2-S1: High priority with critical severity');
        InsertSLALine(Severity::High, Priority::S2, 'P2-S2: High priority with high severity');
        InsertSLALine(Severity::High, Priority::S3, 'P2-S3: High priority with medium severity');
        InsertSLALine(Severity::High, Priority::S4, 'P2-S4: High priority with low severity');

        // P3 (Medium) combinations
        InsertSLALine(Severity::Medium, Priority::S1, 'P3-S1: Medium priority with critical severity');
        InsertSLALine(Severity::Medium, Priority::S2, 'P3-S2: Medium priority with high severity');
        InsertSLALine(Severity::Medium, Priority::S3, 'P3-S3: Medium priority with medium severity');
        InsertSLALine(Severity::Medium, Priority::S4, 'P3-S4: Medium priority with low severity');

        // P4 (Low) combinations
        InsertSLALine(Severity::Low, Priority::S1, 'P4-S1: Low priority with critical severity');
        InsertSLALine(Severity::Low, Priority::S2, 'P4-S2: Low priority with high severity');
        InsertSLALine(Severity::Low, Priority::S3, 'P4-S3: Low priority with medium severity');
        InsertSLALine(Severity::Low, Priority::S4, 'P4-S4: Standard - lowest urgency');
    end;

    local procedure InsertSLALine(Severity: Enum "Grievance Severity"; Priority: Enum "Grievance Priority"; Desc: Text[250])
    var
        SLAMatrix: Record "Grievance SLA Matrix";
    begin
        if not SLAMatrix.Get(Priority, Severity) then begin
            SLAMatrix.Init();
            SLAMatrix.Priority := Priority;
            SLAMatrix.Severity := Severity;
            SLAMatrix.Description := Desc;
            SLAMatrix.Insert();
        end;
    end;
}
