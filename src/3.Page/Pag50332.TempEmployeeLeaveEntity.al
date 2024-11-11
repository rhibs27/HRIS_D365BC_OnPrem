page 50332 "Temp Employee Leave Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    Caption = 'tempEmployeeLeaveEntity';
    DelayedInsert = true;
    EntityName = 'tempEmployeeLeave';
    EntitySetName = 'tempEmployeeLeaveEntity';
    PageType = API;
    SourceTable = Leave;
    // SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(No; Rec."No.") { }
                field(type; Rec.Type) { }
                field(employeeno; Rec."Employee No.")
                {
                    Editable = true;
                }
                field(employeename; Rec."Employee Name") { }
                field(salaryLevel; Rec."Salary Level Code") { }
                field(department; Rec.Department) { }
                field(departmenname; Rec."Department Name") { }
                field(branchcode; Rec."Shortcut Dimension 1 Code") { }
                field(branchname; Rec."Branch Name") { }
                field(functionaltitle; Rec."Functional Title") { }
                field(leavecode; Rec."Leave Code") { }
                field(cancelled; Rec.Cancelled) { }
                field(startdate; Rec."Start Date") { }
                field(startdateBS; Rec."Start Date (BS)") { }
                field(enddate; Rec."End Date") { }
                field(enddateBS; Rec."End Date (BS)") { }
                field(noofdays; Rec."No. of Days")
                {
                    Editable = true;
                }
                field(requesteddate; Rec."Requested Date") { }
                field(fiscalyear; Rec."Fiscal Year") { }
                field(approvalstatus; Rec."Approval Status") { }
                field(cancelledNo; Rec."Cancelled No.") { }
                field(cancelledDocNo; Rec."Cancelled Document No.")
                {
                    Editable = true;
                }
                field(approverType; Rec."Approver Type") { }
                field(reasonCode; Rec."Reason Code") { }
                field(reasonDescription; Rec."Reason Description") { }

            }
            group(Leave)
            {
                field(leavedescription; Rec."Leave Description") { }
                field(leavetype; Rec."Leave Type") { }
                field(paytype; Rec."Pay Type") { }
                field(starttime; Rec."Start Time") { }
                field(endtime; Rec."End Time") { }
                field(compensatorydate; Rec."Compensatory Date") { }
                field(childGender; Rec."Child's Gender") { }
                field(forDeathOf; Rec."For Death Of") { }
                field(contactNo; Rec."Contact No.") { }
                field(remarks; Rec.Remarks) { }
            }
            group(Approval)
            {
                field(recommendercode; Rec."Recommender Code")
                {
                    trigger OnValidate()
                    begin
                        // if Rec.Type = Rec.Type::Resignation then
                        //     ResignationMgt.SendResignationApproval(Rec);
                        // if Rec.Type = Rec.Type::"Employee Transfer" then
                        //     TransferMgt.SendTransferApproval(Rec);
                    end;
                }
                field(recommendername; Rec."Recommender Name") { }
                field(approvercode; Rec."Approver Code")
                {
                    trigger OnValidate()
                    begin
                        case Rec.Type of
                        // Rec.Type::"Leave Request":
                        //     begin
                        //         if Rec.Cancelled then
                        //             HRMgt.ApplyCancelEmployeeActivity(Rec)
                        //         // else
                        //         //     HRMgt.ApplyForLeave(Rec); NIlesh
                        //     end;
                        // Rec.Type::"Travel Request": //nilesh
                        //     HRMgt.ApplyForTravel(Rec); //nilesh
                        // Rec.Type::"Travel Claim": //nilesh
                        //     HRMgt.ApplyForTravelClaim(Rec); //nilesh
                        // Rec.Type::"Out of Office", Rec.Type::Overtime, Rec.Type::"Bulk Cash":
                        //     TransferMgt.ApplyForApprovalForms(Rec);
                        // Rec.Type::"Attendance Missed":
                        //     HRMgt.ApplyCancelEmployeeActivity(Rec);
                        end;
                    end;
                }
                field(approvername; Rec."Approver Name") { }
            }
            part(Attachment; "Attachment Subform")
            {
                EntityName = 'attachmentEntity';
                EntitySetName = 'attachmentEntities';
                SubPageLink = "No." = field("No.");
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::"Pending Approval";
    end;
}
