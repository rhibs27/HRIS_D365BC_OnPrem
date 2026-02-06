page 50391 "Appraisal List"
{
    Caption = 'Appraisal List';
    CardPageId = "Appraisal Form Card";
    PageType = List;
    SourceTable = Appraisal;
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed=false;

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
                field("Appraisal Template"; Rec."Appraisal Template")
                {
                    ToolTip = 'Specifies the value of the Appraisal Template field.';
                    ApplicationArea = All;
                }
                field("Functional Title Desc"; Rec."Functional Title Desc")
                {
                    Caption = 'Functional Title Description';
                    ToolTip = 'Specifies the value of the Functional Title Desc field.';
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
        Rec.SetRange(Posted, false);
        UserSetup.Get(UserId);
        if not UserSetup."Can View Appraisal List" then
            Error(Err001);
    end;

    var
        UserSetup: Record "User Setup";
        Err001: Label 'You do not have permission to view Appraisal List Page.';
}
