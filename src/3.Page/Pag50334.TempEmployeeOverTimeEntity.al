page 50334 "Temp Employee OverTime Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'tempEmployeeOverTimeEntity';
    DelayedInsert = true;
    EntityName = 'tempEmployeeOvertime';
    EntitySetName = 'tempEmployeeOvertimeEntity';
    PageType = API;
    SourceTable = OverTime;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {

                field(no; Rec."No.") { }
                field(type; Rec.Type) { }
                field(employeeNo; Rec."Employee No.")
                {
                    Editable = true;
                }
                field(employeeName; Rec."Employee Name") { }
                field(salaryLevel; Rec."Salary Level Code") { }
                field(department; Rec.Department) { }
                field(departmentName; Rec."Department Name") { }
                field(branchCode; Rec."Shortcut Dimension 1 Code") { }
                field(branchName; Rec."Branch Name") { }
                field(functionalTitle; Rec."Functional Title") { }
                // field(leavecode; Rec."Leave Code") { }
                field(cancelled; Rec.Cancelled) { }
                field(startDate; Rec."Start Date") { }
                field(startDateBS; Rec."Start Date (BS)") { }
                field(endDate; Rec."End Date") { }
                field(endDateBS; Rec."End Date (BS)") { }
                field(noOfDays; Rec."No. of Days")
                {
                    Editable = true;
                }
                field(requestedDate; Rec."Requested Date") { }
                field(fiscalYear; Rec."Fiscal Year") { }
                field(approvalStatus; Rec."Approval Status") { }
                field(cancelledNo; Rec."Cancelled No.") { }
                field(cancelledDocNo; Rec."Cancelled Document No.")
                {
                    Editable = true;
                }
                field(approverType; Rec."Approver Type") { }
                field(reasonCode; Rec."Reason Code") { }
                field(reasonDescription; Rec."Reason Description") { }
            }
            group(Overtime)
            {
                field(timeDuration; Rec."Time Duration") { }
                field(estimatedHours; Rec."Estimated Hours") { }
                field(actualHours; Rec."Actual Hours") { }
                field(enCashmentCode; Rec."Encashment Code")
                {
                }
                field(OTAmount; Rec."OT Amount")
                {
                }
                field(ReasonOfOT; Rec.Remarks)
                {
                }

            }
            group(Approval)
            {
                field(recommenderCode; Rec."Recommender Code")
                {
                    trigger OnValidate()
                    begin
                        // if Rec.Type = Rec.Type::Resignation then
                        //     ResignationMgt.SendResignationApproval(Rec);
                        // if Rec.Type = Rec.Type::"Employee Transfer" then
                        //     TransferMgt.SendTransferApproval(Rec);
                    end;
                }
                field(recommenderName; Rec."Recommender Name") { }
                field(approverCode; Rec."Approver Code")
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
                            Rec.Type::"Out of Office", Rec.Type::Overtime, Rec.Type::"Bulk Cash":
                                OverTimeMgt.ApplyForOverTimeApprovalForms(Rec);
                        //     Rec.Type::"Attendance Missed":
                        // //     HRMgt.ApplyCancelEmployeeActivity(Rec);
                        end;
                    end;
                }
                field(approverName; Rec."Approver Name") { }
            }
            part(Attachment; "Attachment Subform")
            {
                EntityName = 'attachmentEntity';
                EntitySetName = 'attachmentEntities';
                SubPageLink = "No." = field("No.");
            }
        }
    }
    var
        OverTimeMgt: codeUnit "OverTime Mgt";
}
