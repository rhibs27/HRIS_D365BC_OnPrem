page 50254 "Employee Lite"
{
    // version NAVW113.00

    // //Min Feb-4-2022 -- For Calculate "Contact Remaining Days".
    // //Min Feb-4-2022 -- Added Field "Resignation Date",Satus in "Employee List" Page.
    //                     Hide Note factbox page.

    ApplicationArea = BasicHR;
    Caption = 'Employee Lite';
    CardPageId = "Employee Card Lite";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Employee Activity,Loan,Other Information,Update Information,Retirement Fund Management';
    SourceTable = Employee;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Employee No.';
                    ToolTip = 'Specifies the number for the employee';
                }
                field("Last Placement Date"; Rec."Last Placement Date")
                {
                    ToolTip = 'Specifies the value of the Last Placement Date field.';
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.';
                    ApplicationArea = All;
                }
                field("Full Name (Nepali)"; Rec."Full Name (Nepali)")
                {
                    ToolTip = 'Specifies the value of the Full Name (Nepali) field.';
                    ApplicationArea = All;
                }
                field("Disable Punch in"; Rec."Disable Punch in")
                {
                    ToolTip = 'Specifies the value of the Disable Punch in field.';
                    ApplicationArea = All;
                }
                field("Contract Expiry Date"; Rec."Contract Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Contract Expiry Date field.';
                    ApplicationArea = All;
                }
                field("Contract Expiry Remaining Days"; Rec."Contract Expiry Remaining Days")
                {
                    ToolTip = 'Specifies the value of the Contract Expiry Remaining Days field.';
                    ApplicationArea = All;
                }
                field("Contract Expiry Month"; Rec."Contract Expiry Month")
                {
                    Caption = 'Contract Period';
                    ToolTip = 'Specifies the value of the Contract Period field.';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("Resignation Date"; Rec."Resignation Date")
                {
                    ToolTip = 'Specifies the value of the Resignation Date field.';
                    ApplicationArea = All;
                }
                field("Deputation on"; Rec."Deputation on")
                {
                    ToolTip = 'Specifies the value of the Deputation on field.';
                    ApplicationArea = All;
                }
                field("Province Name"; Rec."Province Name")
                {
                    ToolTip = 'Specifies the value of the Province Name field.';
                    ApplicationArea = All;
                }
                field("Sub Province Name"; Rec."Sub Province Name")
                {
                    ToolTip = 'Specifies the value of the Sub Province Name field.';
                    ApplicationArea = All;
                }
                field("Eco-System"; Rec."Eco-System")
                {
                    ToolTip = 'Specifies the value of the Eco-System field.';
                    ApplicationArea = All;
                }
                field(Cluster; Rec.Cluster)
                {
                    ToolTip = 'Specifies the value of the Cluster field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                }
                field("Functional Title Desc"; Rec."Functional Title Desc")
                {
                    Caption = 'Functinal Title Description';
                    ToolTip = 'Specifies the value of the Functinal Title Description field.';
                    ApplicationArea = All;
                }
                field("Employment Type"; Rec."Employment Type")
                {
                    ToolTip = 'Specifies the value of the Employment Type field.';
                    ApplicationArea = All;
                }
                field("Salary Level"; Rec."Salary Level")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Salary Level field.';
                    ApplicationArea = All;
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ToolTip = 'Specifies the value of the Employment Date field.';
                    ApplicationArea = All;
                }
                field("Confirmation Date"; Rec."Confirmation Date")
                {
                    ToolTip = 'Specifies the value of the Confirmation Date field.';
                    ApplicationArea = All;
                }
                field("Promotion Date"; Rec."Promotion Date")
                {
                    Caption = 'Last Promotion Date';
                    ToolTip = 'Specifies the value of the Last Promotion Date field.';
                    ApplicationArea = All;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ToolTip = 'Specifies the value of the Birth Date field.';
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the value of the Mobile Phone No. field.';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.';
                    ApplicationArea = All;
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                    ToolTip = 'Specifies the value of the Company Email field.';
                    ApplicationArea = All;
                }
                field("Date of Birth (B.S.)"; Rec."Date of Birth (B.S.)")
                {
                    ToolTip = 'Specifies the value of the Date of Birth (B.S.) field.';
                    ApplicationArea = All;
                }
                field("NAV Login ID"; Rec."NAV Login ID")
                {
                    ToolTip = 'Specifies the value of the NAV Login ID field.';
                    ApplicationArea = All;
                }
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.';
                    ApplicationArea = All;
                }
                field("GrandFather's Name (Nepali)"; Rec."GrandFather's Name (Nepali)")
                {
                    ToolTip = 'Specifies the value of the GrandFather''s Name (Nepali) field.';
                    ApplicationArea = All;
                }
                field("Father's Name (Nepali)"; Rec."Father's Name (Nepali)")
                {
                    ToolTip = 'Specifies the value of the Father''s Name (Nepali) field.';
                    ApplicationArea = All;
                }
                field("Mother's Name (Nepali)"; Rec."Mother's Name (Nepali)")
                {
                    ToolTip = 'Specifies the value of the Mother''s Name (Nepali) field.';
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                    ApplicationArea = All;
                }
                field("Permanent Address"; Rec.Address)
                {
                    Caption = 'Permanent Address';
                    ToolTip = 'Specifies the value of the Permanent Address field.';
                    ApplicationArea = All;
                }
                field("Temporary Address"; Rec."Address 2")
                {
                    Caption = 'Current Address';
                    ToolTip = 'Specifies the value of the Current Address field.';
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ToolTip = 'Specifies the value of the Marital Status field.';
                    ApplicationArea = All;
                }
                field("Attendance Missed Count"; Rec."Attendance Missed Count")
                {
                    ToolTip = 'Specifies the value of the Attendance Missed Count field.';
                    ApplicationArea = All;
                }
                field("Attendance Missed On"; Rec."Attendance Missed On")
                {
                    ToolTip = 'Specifies the value of the Attendance Missed On field.';
                    ApplicationArea = All;
                }
                field("Premium of Life Insurance"; Rec."Premium of Life Insurance")
                {
                    ToolTip = 'Specifies the value of the Premium of Life Insurance field.';
                    ApplicationArea = All;
                }
                field("Premium of Health Insurance"; Rec."Premium of Health Insurance")
                {
                    ToolTip = 'Specifies the value of the Premium of Health Insurance field.';
                    ApplicationArea = All;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field(COPO; Rec.COPO)
                {
                    ToolTip = 'Specifies the value of the COPO field.';
                    ApplicationArea = All;
                }
                field("Department Head"; Rec."Department Head")
                {
                    ToolTip = 'Specifies the value of the Department Head field.';
                    ApplicationArea = All;
                }
                field("Chief Of Eco-System"; Rec."Chief Of Eco-System")
                {
                    ToolTip = 'Specifies the value of the Chief Of Eco-System field.';
                    ApplicationArea = All;
                }
                field("Extension Counter Code"; Rec."Extension Counter Code")
                {
                    ToolTip = 'Specifies the value of the Extension Counter Code field.';
                    ApplicationArea = All;
                }
                field("Sub Province Code"; Rec."Sub Province Code")
                {
                    ToolTip = 'Specifies the value of the Sub Province Code field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
                ApplicationArea = All;
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
                    ToolTip = 'Executes the Payroll Attributes Usage action.';
                    ApplicationArea = All;
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
                    ToolTip = 'Executes the Work Experience action.';
                    ApplicationArea = All;
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
                ToolTip = 'Executes the Generate New Employee Card action.';

                trigger OnAction()
                begin
                    if not Confirm('Do you want to create new employee card?', false) then
                        exit;
                    Employee.GenerateNewEmployeeCard(Rec);
                end;
            }
            action("Test Approval")
            {
                ToolTip = 'Executes the Test Approval action.';
                ApplicationArea = All;

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
                ToolTip = 'Executes the Generate Leave Balance action.';
                ApplicationArea = All;

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
                ToolTip = 'Executes the Update Approval Code action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Employee.Reset;
                    Employee.SetRange("No.", Rec."No.");
                    Report.Run(Report::"Employee Approval Report", true, true, Employee);
                end;
            }
            action(temp)
            {
                ToolTip = 'Executes the temp action.';
                ApplicationArea = All;

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
                ToolTip = 'Executes the Leave Earn (Contract) action.';
                ApplicationArea = All;

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
                ToolTip = 'Executes the Attendance & Activities action.';
                ApplicationArea = All;
            }
            action("Portal Attendance")
            {
                Image = BulletList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Attendance Logs";
                RunPageLink = "Employee ID" = field("No.");
                ToolTip = 'Executes the Portal Attendance action.';
                ApplicationArea = All;
            }
            action("Resign Employee")
            {
                Image = VoidCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Resign Employee action.';
                ApplicationArea = All;

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
                ToolTip = 'Executes the Insert Payroll Attributes action.';
                ApplicationArea = All;

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
                ToolTip = 'Executes the Sync Employees To Portal action.';
                ApplicationArea = All;

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
                    ToolTip = 'Executes the Request Retirement Fund action.';
                    ApplicationArea = All;

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
