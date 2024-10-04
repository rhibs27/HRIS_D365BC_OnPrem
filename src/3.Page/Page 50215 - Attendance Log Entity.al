page 50215 "Attendance Log Entity"
{
    // version AMS6.1.0,APINICASIA1.00

    DeleteAllowed = false;
    EntityName = 'attendancelog';
    EntitySetName = 'attendancelogs';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Attendance Log";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(EmployeeID; Rec."Employee ID") { }
                field(EmployeeName; Rec."Employee Name") { }
                field(Date; Rec.Date) { }
                field(CheckInTime; Rec."Check In Time") { }
                field(CheckOutTime; Rec."Check Out Time") { }
                field(LateRemarks; Rec."Late Remarks")
                {
                    trigger OnValidate()
                    begin
                        if Rec."Late Remarks" <> '' then
                            Rec.Status := Rec.Status::"Pending Approval";
                    end;
                }
                field(ApproverRemarks; Rec."Approver Remarks") { }
                field(ApproverCode; Rec."Approver Code") { }
                field(Approval_Status; Rec.Status) { }
                field(Approver_Name; Employee."Full Name") { }
                field(Punch_Out_Remarks; Rec."Punch out Remarks") { }
                field(iPAddress; Rec."IP address") { }
                field(PunchOutReviewer; Rec."Punch Out Reviewer") { }
                field(PunchOutCheckReviewer; Rec."Punch Out Check Reviewer") { }
                field(NightShiftCheckOutTime; Rec."Night Shift Check Out Time") { }
                field(TrainingCheckInTime; Rec."Training Check In Time") { }
                field(TrainingCheckOutTime; Rec."Training Check Out Time") { }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("<Action1000000001>")
            {
                Caption = 'Import File';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    CurrStream: InStream;
                    ClientFileName: Text[1024];
                    SelectCSVFile: Label 'Select the CSV Requisition File.';
                begin
                    begin
                        if IsServiceTier then begin
                            if not UploadIntoStream(
                                              SelectCSVFile,
                                               'C:\',
                                               'XML File *.csv| *.csv',
                                                ClientFileName,
                                                CurrStream) then
                                exit;
                        end
                        else begin

                            // CurrFile.Open('C:\');
                            // CurrFile.CreateInStream(CurrStream);
                        end;
                        // XMLPORT.Import(50015, CurrStream);
                        // if not IsServiceTier then CurrFile.Close;
                    end;
                end;
            }
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.SendApprovalRequest;
                end;
            }
            action("Cancel Approval Reqeust")
            {
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.CancelApprovalRequest;
                end;
            }
            action(Approve)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.ApproveRequest;
                end;
            }
            action("Validate Delayed")
            {
                Visible = false;

                trigger OnAction()
                var
                    HRSetup: Record "Human Resources Setup";
                    AttendanceLog: Record "Attendance Log";
                begin

                    HRSetup.Get;
                    if (HRSetup."Office Start Time" = 0T) or (HRSetup."Office End Time" = 0T) then
                        exit;

                    AttendanceLog.Reset;
                    if AttendanceLog.FindFirst then
                        repeat
                            if (AttendanceLog."Check In Time" > HRSetup."Office Start Time") and (AttendanceLog."Check In Time" < 120000T) then begin
                                AttendanceLog.Delayed := true;
                                AttendanceLog.Modify;
                            end
                            else begin
                                AttendanceLog.Delayed := false;
                                AttendanceLog.Modify;
                            end;
                        until AttendanceLog.Next = 0;

                    Message('Updated.');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Employee.Get(Rec."Approver Code") then;
    end;

    trigger OnOpenPage()
    begin
        /*Employee.RESET;
        Employee.SETRANGE("NAV Login ID",USERID);
        IF Employee.FINDFIRST THEN
          SETFILTER("Employee ID",Employee."No.");
          */ //commented for approval of late attendance
    end;

    var
        Employee: Record Employee;
}
