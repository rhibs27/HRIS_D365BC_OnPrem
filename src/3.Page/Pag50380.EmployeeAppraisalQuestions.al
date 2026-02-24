page 50380 "Employee Appraisal Questions"
{
    ApplicationArea = All;
    Caption = 'Employee Appraisal Questionnaire';
    PageType = ListPart;
    SourceTable = "Employee Appraisal Question";
    UsageCategory = Lists;
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number';
                    Editable = false;
                }
                field(appraisalNo; Rec."Appraisal Code")
                {
                    Caption = 'Appraisal No';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the appraisal code';
                    Editable = false;
                }
                field(EmployeeNo; Rec."Employee Code")
                {
                    Caption = 'Employee No';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee code';
                    Editable = false;
                }
                field(employeeName; Rec."Employee Name")
                {
                    Caption = 'Employee Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee name';
                    Editable = false;
                }
                field(question; Rec."Question")
                {
                    Caption = 'Question';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the question';
                    Editable = false;
                }
                field(questionType; Rec."Question Type")
                {
                    Caption = 'Question Type';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of question';
                    Editable = false;
                }
                field(comment; Rec."Comment")
                {
                    Caption = 'Comment';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the response of Question';
                    Editable = Rec."Question Type" = Rec."Question Type"::Text;
                    Enabled = Rec."Question Type" = Rec."Question Type"::Text;
                }
                field(yesNo; Rec."Yes/No")
                {
                    Caption = 'Yes/No';
                    ApplicationArea = All;
                    ToolTip = 'Specifies Yes/No answer';
                    Editable = Editable1 and (Rec."Question Type" = Rec."Question Type"::"Yes/No");
                    Enabled = Editable1 and (Rec."Question Type" = Rec."Question Type"::"Yes/No");
                }
                field(reviewerType; Rec."Reviewer Type")
                {
                    Caption = 'Reviewer Type';
                    ApplicationArea = All;
                }
                field(reviewerCode; Rec."Reviewer Code")
                {
                    Caption = 'Reviewer Code';
                    ApplicationArea = All;
                }
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        UpdateEditability();
    end;

    local procedure UpdateEditability()
    begin
        Editable1 := true;

        if not Appraisal.Get(Rec."Appraisal Code") then
            exit;

        if Appraisal."Approval Status" = Appraisal."Approval Status"::Approved then
            Editable1 := false;
    end;


    var
        Editable1: Boolean;
        Appraisal: Record Appraisal;

}