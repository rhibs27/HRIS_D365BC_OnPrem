page 50182 "Allowance Requests"
{
    ApplicationArea = All;
    Caption = 'Allowance Requests';
    CardPageId = "Request Allowance Card";
    PageType = List;
    SourceTable = "Assignment Memo Header";
    SourceTableView = where("Activity Type" = const("Request Allowance"));
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Requester Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field("Requester Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Payroll Attribute Code"; Rec."Payroll Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute Code field.', Comment = '%';
                }
                field("Payroll Attr. Description"; Rec."Payroll Attr. Description")
                {
                    ToolTip = 'Specifies the value of the Payroll Attr. Description field.', Comment = '%';
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.', Comment = '%';
                }
                field("Pay Cycle Period"; Rec."Pay Cycle Period")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Period field.', Comment = '%';
                }
                field("Nepali Month"; Rec."Nepali Month")
                {
                    ToolTip = 'Specifies the value of the Nepali Month field.', Comment = '%';
                    Editable = false;
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field("To date"; Rec."To date")
                {
                    ToolTip = 'Specifies the value of the To date field.';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.', Comment = '%';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                }
                field("Attachment Exists"; Rec."Attachment Exists")
                {
                    ToolTip = 'Indicates whether an attachment exists for the allowance request.';
                }
                field("No of Lines"; Rec."No of Lines")
                {
                    ToolTip = 'Specifies the value of the No of Lines field.', Comment = '%';
                }
                field("Total Line Amount"; Rec."Total Line Amount")
                {
                    ToolTip = 'Specifies the value of the Total Line Amount field.', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        PGSetup: Record "Payroll general Setup";
    begin
        PGSetup.Get();
        if not PGSetup."Use Allowance Configuration" then
            Error('Allowance Configuration is not enabled in Payroll General Setup. Please enable it to access Allowance Requests.');
    end;
}
