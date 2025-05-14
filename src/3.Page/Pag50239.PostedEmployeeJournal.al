page 50239 "Posted Employee Journal"
{
    ApplicationArea = All;
    Caption = 'Posted Employee Journal';
    PageType = List;
    SourceTable = "Posted Employee Journal";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ToolTip = 'Specifies the value of the Entry No field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Document No"; Rec."Document No")
                {
                    ToolTip = 'Specifies the value of the Document No field.', Comment = '%';
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.', Comment = '%';
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.', Comment = '%';
                }

                field("Acknowledged Date"; Rec."Acknowledged Date")
                {
                    ToolTip = 'Specifies the value of the Acknowledged Date field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.', Comment = '%';
                }
                field("BM Accomodation Allow."; Rec."BM Accomodation Allow.")
                {
                    ToolTip = 'Specifies the value of the BM Accomodation Allow. field.', Comment = '%';
                }
                field("BMAF Distance"; Rec."BMAF Distance")
                {
                    ToolTip = 'Specifies the value of the BMAF Distance field.', Comment = '%';
                }

                field(Cancelled; Rec.Cancelled)
                {
                    ToolTip = 'Specifies the value of the Cancelled field.', Comment = '%';
                }
                field("Cancelled Date"; Rec."Cancelled Date")
                {
                    ToolTip = 'Specifies the value of the Cancelled Date field.', Comment = '%';
                }
                field("Child's Gender"; Rec."Child's Gender")
                {
                    ToolTip = 'Specifies the value of the Child''s Gender field.', Comment = '%';
                }
                field("Compensatory Date"; Rec."Compensatory Date")
                {
                    ToolTip = 'Specifies the value of the Compensatory Date field.', Comment = '%';
                }
                field("Compensatory Days"; Rec."Compensatory Days")
                {
                    ToolTip = 'Specifies the value of the Compensatory Days field.', Comment = '%';
                }
                field("Curr. Placement Period(Month)"; Rec."Curr. Placement Period(Month)")
                {
                    ToolTip = 'Specifies the value of the Curr. Placement Period(Month) field.', Comment = '%';
                }
                field("Date of Joining Of Transfer"; Rec."Date of Joining Of Transfer")
                {
                    ToolTip = 'Specifies the value of the Date of Joining Of Transfer field.', Comment = '%';
                }
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.', Comment = '%';
                }
                field("Department Code (To)"; Rec."Department Code (To)")
                {
                    ToolTip = 'Specifies the value of the Department Code (To) field.', Comment = '%';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.', Comment = '%';
                }
                field("Deputation On"; Rec."Deputation On")
                {
                    ToolTip = 'Specifies the value of the Deputation On field.', Comment = '%';
                }
                field("Deputation On (To)"; Rec."Deputation On (To)")
                {
                    ToolTip = 'Specifies the value of the Deputation On (To) field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Employee Work Shift"; Rec."Employee Work Shift")
                {
                    ToolTip = 'Specifies the value of the Employee Work Shift field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                }
                field("End Date (BS)"; Rec."End Date (BS)")
                {
                    ToolTip = 'Specifies the value of the End Date (BS) field.', Comment = '%';
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.', Comment = '%';
                }

                field("Extension Counter (To)"; Rec."Extension Counter (To)")
                {
                    ToolTip = 'Specifies the value of the Extension Counter (To) field.', Comment = '%';
                }
                field("Extension Counter Code"; Rec."Extension Counter Code")
                {
                    ToolTip = 'Specifies the value of the Extension Counter Code field.', Comment = '%';
                }

                field("For Death Of"; Rec."For Death Of")
                {
                    ToolTip = 'Specifies the value of the For Death Of field.', Comment = '%';
                }
                field("From Branch"; Rec."From Branch")
                {
                    ToolTip = 'Specifies the value of the From Branch field.', Comment = '%';
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.', Comment = '%';
                }
                field("Functional Title (To)"; Rec."Functional Title (To)")
                {
                    ToolTip = 'Specifies the value of the Functional Title (To) field.', Comment = '%';
                }
                field("Incoming Supervisior"; Rec."Incoming Supervisior")
                {
                    ToolTip = 'Specifies the value of the Incoming Supervisior field.', Comment = '%';
                }
                field("Incoming Supervisior Name"; Rec."Incoming Supervisior Name")
                {
                    ToolTip = 'Specifies the value of the Incoming Supervisior Name field.', Comment = '%';
                }
                field("Is Transfer Details Added"; Rec."Is Transfer Details Added")
                {
                    ToolTip = 'Specifies the value of the Is Transfer Details Added field.', Comment = '%';
                }
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code field.', Comment = '%';
                }
                field("Leave Description"; Rec."Leave Description")
                {
                    ToolTip = 'Specifies the value of the Leave Description field.', Comment = '%';
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the value of the Leave Type field.', Comment = '%';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.', Comment = '%';
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.', Comment = '%';
                }
                field("Notify to"; Rec."Notify to")
                {
                    ToolTip = 'Specifies the value of the Notify to field.', Comment = '%';
                }
                field("Officiating Allow."; Rec."Officiating Allow.")
                {
                    ToolTip = 'Specifies the value of the Officiating Allow. field.', Comment = '%';
                }
                field("On Hold Date"; Rec."On Hold Date")
                {
                    ToolTip = 'Specifies the value of the On Hold Date field.', Comment = '%';
                }
                field("Outgoing Branch Rep. Person"; Rec."Outgoing Branch Rep. Person")
                {
                    ToolTip = 'Specifies the value of the Outgoing Branch Rep. Person field.', Comment = '%';
                }
                field("Outgoing Reporting Person Name"; Rec."Outgoing Reporting Person Name")
                {
                    ToolTip = 'Specifies the value of the Outgoing Reporting Person Name field.', Comment = '%';
                }
                field("Outstation Distance"; Rec."Outstation Distance")
                {
                    ToolTip = 'Specifies the value of the Outstation Distance field.', Comment = '%';
                }
                field("Outstation/Discomfort Allow."; Rec."Outstation/Discomfort Allow.")
                {
                    ToolTip = 'Specifies the value of the Outstation/Discomfort Allow. field.', Comment = '%';
                }
                field("Pay Type"; Rec."Pay Type")
                {
                    ToolTip = 'Specifies the value of the Pay Type field.', Comment = '%';
                }
                field("Payroll No."; Rec."Payroll No.")
                {
                    ToolTip = 'Specifies the value of the Payroll No. field.', Comment = '%';
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.', Comment = '%';
                }
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specifies the value of the Province Code field.', Comment = '%';
                }
                field("Province Code (To)"; Rec."Province Code (To)")
                {
                    ToolTip = 'Specifies the value of the Province Code (To) field.', Comment = '%';
                }
                field("Reason For Cancel"; Rec."Reason For Cancel")
                {
                    ToolTip = 'Specifies the value of the Reason For Cancel field.', Comment = '%';
                }
                field("Reason For Hold"; Rec."Reason For Hold")
                {
                    ToolTip = 'Specifies the value of the Reason For Hold field.', Comment = '%';
                }
                field("Reason for Transfer"; Rec."Reason for Transfer")
                {
                    ToolTip = 'Specifies the value of the Reason for Transfer field.', Comment = '%';
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.', Comment = '%';
                }
                field("Relocation Allow."; Rec."Relocation Allow.")
                {
                    ToolTip = 'Specifies the value of the Relocation Allow. field.', Comment = '%';
                }
                field("Relocation Distance"; Rec."Relocation Distance")
                {
                    ToolTip = 'Specifies the value of the Relocation Distance field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field("Remote Area Allow."; Rec."Remote Area Allow.")
                {
                    ToolTip = 'Specifies the value of the Remote Area Allow. field.', Comment = '%';
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.', Comment = '%';
                }
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    ToolTip = 'Specifies the value of the Salary Level Code field.', Comment = '%';
                }
                field("Screener Remarks"; Rec."Screener Remarks")
                {
                    ToolTip = 'Specifies the value of the Screener Remarks field.', Comment = '%';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.', Comment = '%';
                }
                field("Shortcut Dimension 1 Code (To)"; Rec."Shortcut Dimension 1 Code (To)")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code (To) field.', Comment = '%';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                }
                field("Start Date (BS)"; Rec."Start Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Start Date (BS) field.', Comment = '%';
                }
                field("Start Time"; Rec."Start Time")
                {
                    ToolTip = 'Specifies the value of the Start Time field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Temporary Address"; Rec."Temporary Address")
                {
                    ToolTip = 'Specifies the value of the Temporary Address field.', Comment = '%';
                }
                field("Temporary District"; Rec."Temporary District")
                {
                    ToolTip = 'Specifies the value of the Temporary District field.', Comment = '%';
                }
                field("Temporary Province"; Rec."Temporary Province")
                {
                    ToolTip = 'Specifies the value of the Temporary Province field.', Comment = '%';
                }
                field("To Branch"; Rec."To Branch")
                {
                    ToolTip = 'Specifies the value of the To Branch field.', Comment = '%';
                }
                field("Transfer Category"; Rec."Transfer Category")
                {
                    ToolTip = 'Specifies the value of the Transfer Category field.', Comment = '%';
                }
                field("Transfer Claim"; Rec."Transfer Claim")
                {
                    ToolTip = 'Specifies the value of the Transfer Claim field.', Comment = '%';
                }
                field("Transfer Effective Date"; Rec."Transfer Effective Date")
                {
                    ToolTip = 'Specifies the value of the Transfer Effective Date field.', Comment = '%';
                }
                field("Transfer Propose Date"; Rec."Transfer Propose Date")
                {
                    ToolTip = 'Specifies the value of the Transfer Propose Date field.', Comment = '%';
                }
                field("Transfer Remarks"; Rec."Transfer Remarks")
                {
                    ToolTip = 'Specifies the value of the Transfer Remarks field.', Comment = '%';
                }
                field("Transfer Type"; Rec."Transfer Type")
                {
                    ToolTip = 'Specifies the value of the Transfer Type field.', Comment = '%';
                }
                field("Travel Order No"; Rec."Travel Order No")
                {
                    ToolTip = 'Specifies the value of the Travel Order No field.', Comment = '%';
                }

                field("Unit (To)"; Rec."Unit (To)")
                {
                    ToolTip = 'Specifies the value of the Unit (To) field.', Comment = '%';
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ToolTip = 'Specifies the value of the Unit Code field.', Comment = '%';
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                }
            }
        }
    }
}
