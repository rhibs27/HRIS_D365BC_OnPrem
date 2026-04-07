page 50360 "Grievance List"
{
    PageType = List;
    SourceTable = "Grievance Header";
    ApplicationArea = All;
    Caption = 'Grievances';
    CardPageId = "Grievance Card";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the grievance document number.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the employee who filed the grievance.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the name of the employee who filed the grievance.';
                    ApplicationArea = All;
                }
                field("Grievance Date"; Rec."Grievance Date")
                {
                    ToolTip = 'Specifies the date the grievance was filed.';
                    ApplicationArea = All;
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the category of the grievance.';
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ToolTip = 'Specifies the priority level of the grievance.';
                    ApplicationArea = All;
                }
                field(Subject; Rec.Subject)
                {
                    ToolTip = 'Specifies the subject of the grievance.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the current approval status of the grievance.';
                    ApplicationArea = All;
                }
                field("Deputation On"; Rec."Deputation On")
                {
                    ToolTip = 'Specifies the current deputation on of the employee';
                    ApplicationArea = All;
                }
                field("Deputation On Code"; Rec."Deputation Code")
                {
                    ToolTip = 'Specifies the current deputation code of the employee';
                    ApplicationArea = All;
                }
                field("Against Employee Name"; Rec."Against Employee Name")
                {
                    ToolTip = 'Specifies the name of the employee the grievance is filed against.';
                    ApplicationArea = All;
                }
                field("Resolution Date"; Rec."Resolution Date")
                {
                    ToolTip = 'Specifies the date the grievance was resolved.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the fiscal year of the grievance.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Notes; Notes) { ApplicationArea = All; }
            systempart(Links; Links) { ApplicationArea = All; }
        }
    }

    actions
    {
        area(Processing)
        {
            action("New Grievance")
            {
                Caption = 'New Grievance';
                Image = New;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ToolTip = 'Opens a new grievance card for the current employee.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    GrievanceMgt.OpenGrievanceRequest(HRMgt.GetEmployeeNo());
                end;
            }
        }
    }

    var
        GrievanceMgt: Codeunit "Grievance Mgt";
        HRMgt: Codeunit "HR Mgt.";
}
