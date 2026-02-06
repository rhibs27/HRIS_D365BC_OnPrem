page 50392 "Posted Appraisal List"
{
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Appraisal;
    SourceTableView = where(Posted = const(true));
    ApplicationArea = All;
    CardPageId = "Appraisal form Card";


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
                    ApplicationArea = All;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Date of Employement"; Rec."Date of Employement")
                {
                    ToolTip = 'Specifies the value of the Date of Employement field.';
                    ApplicationArea = All;
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ToolTip = 'Specifies the value of the Appraisal Type field.';
                    ApplicationArea = All;
                }
                field("Reviewer III"; Rec."Reviewer III")
                {
                    ToolTip = 'Specifies the value of the Reviewer III field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
                field("Reviewed Score I"; Rec."Reviewed Score I")
                {
                    ToolTip = 'Specifies the value of the Reviewed Score I field.';
                    ApplicationArea = All;
                }
                field("Reviewed Score II"; Rec."Reviewed Score II")
                {
                    ToolTip = 'Specifies the value of the Reviewed Score II field.';
                    ApplicationArea = All;
                }
                field("Reviewed Score III"; Rec."Reviewed Score III")
                {
                    ToolTip = 'Specifies the value of the Reviewed Score III field.';
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

                field("Job Grade"; Rec."Job Grade")
                {
                    ToolTip = 'Specifies the value of the Job Grade field.';
                    ApplicationArea = All;
                }
                field("Total Tenure in Bank"; Rec."Total Tenure in Bank")
                {
                    ToolTip = 'Specifies the value of the Total Tenure in Bank field.';
                    ApplicationArea = All;
                }
                field("Submission Date"; Rec."Submission Date")
                {
                    ToolTip = 'Specifies the value of the Submission Date field.';
                    ApplicationArea = All;
                }
                field("Reviewed Date I"; Rec."Reviewed Date I")
                {
                    ToolTip = 'Specifies the value of the Reviewed Date I field.';
                    ApplicationArea = All;
                }
                field("Reviewed Date II"; Rec."Reviewed Date II")
                {
                    ToolTip = 'Specifies the value of the Reviewed Date II field.';
                    ApplicationArea = All;
                }
                field("Reviewed Date III"; Rec."Reviewed Date III")
                {
                    ToolTip = 'Specifies the value of the Reviewed Date III field.';
                    ApplicationArea = All;
                }
                field(Branch; Rec.Branch)
                {
                    ToolTip = 'Specifies the value of the Branch field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }

}
