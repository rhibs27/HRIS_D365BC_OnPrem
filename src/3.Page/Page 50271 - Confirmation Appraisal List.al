page 50271 "Confirmation Appraisal List"
{
    Caption = 'Confirmation Appraisal List';
    CardPageId = "Appraisal Form Card";
    PageType = List;
    SourceTable = Appraisal;
    UsageCategory = Lists;
    ApplicationArea = All;

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
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
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
                field(Hide; Rec.Hide)
                {
                    ToolTip = 'Specifies the value of the Hide field.';
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
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("KRA Category"; Rec."KRA Category")
                {
                    ToolTip = 'Specifies the value of the KRA Category field.';
                    ApplicationArea = All;
                }
                field(Reviewer; Rec.Reviewer)
                {
                    ToolTip = 'Specifies the value of the Reviewer field.';
                    ApplicationArea = All;
                }
                field("Check Reviewer"; Rec."Check Reviewer")
                {
                    ToolTip = 'Specifies the value of the Check Reviewer field.';
                    ApplicationArea = All;
                }
                field("Total Final Score"; Rec."Total Final Score")
                {
                    ToolTip = 'Specifies the value of the Total Final Score field.';
                    ApplicationArea = All;
                }
                field("Total Reviewers Score"; Rec."Total Reviewers Score")
                {
                    ToolTip = 'Specifies the value of the Total Reviewers Score field.';
                    ApplicationArea = All;
                }
                field("Total Check Reviewers Score"; Rec."Total Check Reviewers Score")
                {
                    ToolTip = 'Specifies the value of the Total Check Reviewers Score field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Functional Title Desc"; Rec."Functional Title Desc")
                {
                    ToolTip = 'Specifies the value of the Functional Title Desc field.';
                    ApplicationArea = All;
                }
                field("Final Score"; Rec."Final Score")
                {
                    ToolTip = 'Specifies the value of the Final Score field.';
                    ApplicationArea = All;
                }
                field("Final Grade"; Rec."Final Grade")
                {
                    ToolTip = 'Specifies the value of the Final Grade field.';
                    ApplicationArea = All;
                }
                field("Final Grading"; Rec."Final Grading")
                {
                    ToolTip = 'Specifies the value of the Final Grading field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
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
                field("Total Tenure in Crc Position"; Rec."Total Tenure in Crc Position")
                {
                    Caption = 'Total Tenure in Current Position';
                    ToolTip = 'Specifies the value of the Total Tenure in Current Position field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        //HRpermission.GET(USERID);
        //IF (NOT HREmployeeLookup) AND (NOT SubsEmpLookup) THEN BEGIN
        //  IF (NOT HRpermission."Super Permission")  THEN BEGIN
        //Employee.RESET;
        //Employee.SETRANGE("Assigned User ID",USERID);
        // IF Employee.FINDFIRST THEN  BEGIN
        // Employee.TESTFIELD("Branch Code");
        //  Employee.TESTFIELD("Department Code");
        //FILTERGROUP(2);
        //SETRANGE("Branch Code",Employee."Branch Code");
        // IF NOT HRpermission.CRE THEN
        //SETRANGE("Department Code",Employee."Department Code");
        /*
           FILTERGROUP(-1);
           SETFILTER("Employee Code",'%1',Employee."No.");
           SETFILTER("Appraiser I Code",Employee."No.");
           SETFILTER("Appraiser II Code" ,Employee."No.");
           IF FINDFIRST THEN REPEAT
             MARK(TRUE);
           UNTIL NEXT=0;
           FILTERGROUP(0);
           MARKEDONLY(TRUE);
         END;
         */
        //END;
        Rec.SetRange(Posted, false);
        Rec.SetRange(Hide, false);
        Rec.FilterGroup(2);
        Rec.SetRange("Appraisal Type", Rec."Appraisal Type"::Confirmation);
        Rec.FilterGroup(1);
        UserSetup.Get(UserId); //Min
        if not UserSetup."Can View Confirmation Appraisal" then
            Error(Err001);
    end;

    var
        UserSetup: Record "User Setup";
        Err001: Label 'You do not have permission to view Confirmation Appraisal List Page.';
}
