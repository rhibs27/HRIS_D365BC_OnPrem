page 50079 "Appraisal List"
{
    Caption = 'Appraisal List';
    CardPageId = "Appraisal Form Card";
    PageType = List;
    SourceTable = Appraisal;
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;

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
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ToolTip = 'Specifies the value of the Appraisal Type field.';
                    ApplicationArea = All;
                }
                field("Appraisal Subtype Monthly"; Rec."Appraisal Subtype Monthly")
                {

                    ToolTip = 'Specifies the value of the Appraisal Subtype Monthly field.';
                    ApplicationArea = All;
                }
                field("Appraisal Subtype Quarterly"; Rec."Appraisal Subtype Quarterly")
                {
                    ToolTip = 'Specifies the value of the Appraisal Subtype Quarterly field.';
                    ApplicationArea = All;
                }
                field("KRA Category"; Rec."KRA Category")
                {
                    ToolTip = 'Specifies the value of the KRA Category field.';
                    ApplicationArea = All;
                }
                field("Functional Title Desc"; Rec."Functional Title Desc")
                {
                    Caption = 'Designation';
                    ToolTip = 'Specifies the value of the Functional Title Desc field.';
                    ApplicationArea = All;
                }
                field("Immediate Supervisor"; Rec."Immediate Supervisor")
                {
                    ToolTip = 'Specifies the value of the Reviewer field.';
                    ApplicationArea = All;
                }
                field("Reviewer"; Rec."Reviewer")
                {
                    ToolTip = 'Specifies the value of the Check Reviewer field.';
                    ApplicationArea = All;
                }
                field("Total Immediate Supv Score"; Rec."Total Immediate Supv Score")
                {
                    caption = 'Total Immediate Supervisor Score';
                    ToolTip = 'Specifies the value of the Total Reviewers Score field.';
                    ApplicationArea = All;
                }
                field("Total Reviewer Score"; Rec."Total Reviewer Score")
                {
                    ToolTip = 'Specifies the value of the Total Check Reviewers Score field.';
                    ApplicationArea = All;
                }
                field("Total Final Score"; Rec."Total Final Score")
                {
                    ToolTip = 'Specifies the value of the Total Final Score field.';
                    ApplicationArea = All;
                }
                field("Final Grading"; Rec."Final Grading")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
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

            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        //HRpermission.GET(USERID);
        //IF (NOT HREmployeeLookup) AND (NOT SubsEmpLookup) THEN begin
        //  IF (NOT HRpermission."Super Permission")  THEN begin
        //Employee.Reset();
        //Employee.SetRange("Assigned User ID",USERID);
        // IF Employee.FindFirst() THEN  begin
        // Employee.TestField("Branch Code");
        //  Employee.TestField("Department Code");
        //FILTERGROUP(2);
        //SetRange("Branch Code",Employee."Branch Code");
        // IF NOT HRpermission.CRE THEN
        //SetRange("Department Code",Employee."Department Code");
        /*
           FILTERGROUP(-1);
           SETFILTER("Employee Code",'%1',Employee."No.");
           SETFILTER("Appraiser I Code",Employee."No.");
           SETFILTER("Appraiser II Code" ,Employee."No.");
           IF FINDFIRST THEN repeat
             MARK(TRUE);
           until NEXT=0;
           FILTERGROUP(0);
           MARKEDONLY(TRUE);
         end;
         */
        //end;
        Rec.SetRange(Posted, false);
        //Rec.SetRange(Hide, false);
        UserSetup.Get(UserId);
        if not UserSetup."Can View Appraisal List" then
            Error(Err001);
    end;

    var
        UserSetup: Record "User Setup";
        Err001: Label 'You do not have permission to view Appraisal List Page.';
}
