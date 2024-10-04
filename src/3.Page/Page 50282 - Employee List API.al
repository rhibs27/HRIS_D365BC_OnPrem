page 50282 "Employee List API"
{
    // version NAVW113.00/KPI1.00

    // //Min Feb-4-2022 -- For Calculate "Contact Remaining Days".
    // //Min Feb-4-2022 -- Added Field "Resignation Date",Satus in "Employee List" Page.
    //                     Hide Note factbox page.

    ApplicationArea = BasicHR;
    Caption = 'Employees';
    CardPageId = "Employee Card";
    Editable = false;
    EntityName = 'employeelist';
    EntitySetName = 'employeeslist';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    PromotedActionCategories = 'New,Process,Report,Employee Activity,Loan,Other Information,Update Information,Retirement Fund Management';
    SourceTable = Employee;
    // UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(No; Rec."No.")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Employee No.';
                    ToolTip = 'Specifies the number for the employee';
                }
                field(FullName; Rec."Full Name") { }
                field(EmploymentType; Rec."Employment Type") { }
                field(ProbationPeriod; Rec."Probation Period") { }
                field(EmploymentDate; Rec."Employment Date") { }
                field(FunctionalTitle; Rec."Functional Title") { }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("E&mployee")
            {
                Caption = 'E&mployee';
                Image = Employee;
                action("Payroll Attributes Usage")
                {
                    Image = Components;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Payroll Attributes Usage";
                    RunPageLink = "Employee Code" = field("No.");
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = const(Employee),
                                  "No." = field("No.");
                    ToolTip = 'View or add comments for the record.';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = page "Default Dimensions";
                        RunPageLink = "Table ID" = const(5200),
                                      "No." = field("No.");
                        ShortcutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = tabledata Dimension = R;
                        ApplicationArea = Dimensions;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            Employee: Record Employee;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Employee);
                            DefaultDimMultiple.SetMultiEmployee(Employee);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
                action("&Picture")
                {
                    ApplicationArea = BasicHR;
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = page "Employee Picture";
                    RunPageLink = "No." = field("No.");
                    ToolTip = 'View or add a picture of the employee or, for example, the company''s logo.';
                }
                action(AlternativeAddresses)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Alternate Addresses';
                    Image = Addresses;
                    RunObject = page "Alternative Address List";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Open the list of addresses that are registered for the employee.';
                }
                action("&Relatives")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Relatives';
                    Image = Relatives;
                    RunObject = page "Employee Relatives";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Open the list of relatives that are registered for the employee.';
                }
                action("Mi&sc. Article Information")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Mi&sc. Article Information';
                    Image = Filed;
                    RunObject = page "Misc. Article Information";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Open the list of miscellaneous articles that are registered for the employee.';
                }
                action("Co&nfidential Information")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Co&nfidential Information';
                    Image = Lock;
                    RunObject = page "Confidential Information";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Open the list of any confidential information that is registered for the employee.';
                }
                action("Q&ualifications")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Q&ualifications';
                    Image = Certificate;
                    RunObject = page "Employee Qualifications";
                    RunPageLink = "Employee No." = field("No."),
                                  "Emp Qualification Type" = filter(" ");
                    ToolTip = 'Open the list of qualifications that are registered for the employee.';
                }
                action("Employee Work Experience")
                {
                    Caption = 'Work Experience';
                    Image = Certificate;
                    RunObject = page "Employee Work Qualification";
                    RunPageLink = "Employee No." = field("No."),
                                  "Emp Qualification Type" = filter(Education);
                }
                action("A&bsences")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'A&bsences';
                    Image = Absence;
                    RunObject = page "Employee Absences";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'View absence information for the employee.';
                }
                separator(Separator51) { }
                action("Absences by Ca&tegories")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Absences by Ca&tegories';
                    Image = AbsenceCategory;
                    RunObject = page "Empl. Absences by Categories";
                    RunPageLink = "No." = field("No."),
                                  "Employee No. Filter" = field("No.");
                    ToolTip = 'View categorized absence information for the employee.';
                }
                action("Misc. Articles &Overview")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Misc. Articles &Overview';
                    Image = FiledOverview;
                    RunObject = page "Misc. Articles Overview";
                    ToolTip = 'View miscellaneous articles that are registered for the employee.';
                }
                action("Con&fidential Info. Overview")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Con&fidential Info. Overview';
                    Image = ConfidentialOverview;
                    RunObject = page "Confidential Info. Overview";
                    ToolTip = 'View confidential information that is registered for the employee.';
                }
            }
        }
        area(Processing)
        {
            action("Absence Registration")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Absence Registration';
                Image = Absence;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Absence Registration";
                ToolTip = 'Register absence for the employee.';
            }
            action("Ledger E&ntries")
            {
                ApplicationArea = BasicHR;
                Caption = 'Ledger E&ntries';
                Image = VendorLedger;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Employee Ledger Entries";
                RunPageLink = "Employee No." = field("No.");
                RunPageView = sorting("Employee No.")
                              order(descending);
                ShortcutKey = 'Ctrl+F7';
                ToolTip = 'View the history of transactions that have been posted for the selected record.';
            }
            action(PayEmployee)
            {
                ApplicationArea = BasicHR;
                Caption = 'Pay Employee';
                Image = SuggestVendorPayments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Employee Ledger Entries";
                RunPageLink = "Employee No." = field("No."),
                              "Remaining Amount" = filter(< 0),
                              "Applies-to ID" = filter('');
                ToolTip = 'View employee ledger entries for the selected record with remaining amount that have not been paid yet.';
            }
            action("Generate New Employee Card")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Generate New Employee Card';
                Image = Archive;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if not Confirm('Do you want to create new employee card?', false) then
                        exit;
                    Employee.GenerateNewEmployeeCard(Rec);
                end;
            }
            action("Test Approval")
            {
                trigger OnAction()
                var
                    LoanMgt: Codeunit "Loan Mgt.";
                    Temp1: Code[150];
                    Temp2: Code[150];
                    Temp3: Text;
                    Temp4: Text;
                begin
                    LoanMgt.UpdateApproval(Rec, Temp1, Temp2, Temp3, Temp4, true);
                end;
            }
            action("Generate Leave Balance")
            {
                Image = GiroPlus;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Employee.Reset;
                    Employee.SetRange("No.", Rec."No.");
                    Report.RunModal(60014, true, false, Employee);
                end;
            }
            action("Update Approval Code")
            {
                Image = CoupledUser;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Employee.Reset;
                    Employee.SetRange("No.", Rec."No.");
                    Report.Run(Report::"Employee Approval Report", true, true, Employee);
                end;
            }
            action(temp)
            {
                trigger OnAction()
                begin
                    /*
                    Employee.RESET;
                    IF Employee.FINDFIRST THEN
                      REPEAT
                        Employee.VALIDATE("Recommender Code");
                        Employee.VALIDATE("Approver Code");
                        Employee.MODIFY;
                      UNTIL Employee.NEXT = 0;

                    MESSAGE('done.');
                    */
                end;
            }
            action("Leave Earn (Contract)")
            {
                Image = EditFilter;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    LeaveMgt.CreateLeaveEarnContract(Rec);
                end;
            }
            action("Attendance & Activities")
            {
                Image = BookingsLogo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Employee Attendance & Activity";
                RunPageLink = "Employee No." = field("No.");
            }
            action("Portal Attendance")
            {
                Image = BulletList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Attendance Logs";
                RunPageLink = "Employee ID" = field("No.");
            }
            action("Resign Employee")
            {
                Image = VoidCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Do you want to terminate %1 ?', false, Rec."Full Name") then
                        ResignationMgt.UpdateResign(Rec."No.");
                end;
            }
            action("Insert Payroll Attributes")
            {
                Image = AddContacts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Do you want to update payroll attributes usage ?', false) then
                        PayrollEngine.InsertPayrollAttributes;
                end;
            }
            action(SycnEmployeesToPortal)
            {
                Caption = 'Sync Employees To Portal';
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Do you want to sync employees to portal?', false) then begin
                        HRMgt.SyncEmployee();
                        Message('Success');
                    end;
                end;
            }
            group("Retirement Fund")
            {
                Caption = 'Retirement Fund';
                action("Request Retirement Fund")
                {
                    Image = Allocate;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.RFRequest;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //Min Feb-4-2022
        Rec."Contract Expiry Remaining Days" := 0;
        if Rec."Contract Expiry Date" > Today then
            Rec."Contract Expiry Remaining Days" := Rec."Contract Expiry Date" - Today;
    end;

    trigger OnOpenPage()
    begin
        Usersetup.Get(UserId);
        PayrollFieldsVisible := Usersetup."Can View Payroll Fields";
    end;

    var
        [InDataSet]
        PayrollFieldsVisible: Boolean;
        Usersetup: Record "User Setup";
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        PayrollEngine: Codeunit "Payroll Engine";
}
