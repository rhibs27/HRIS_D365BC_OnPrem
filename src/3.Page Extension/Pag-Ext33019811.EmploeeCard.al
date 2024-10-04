pageextension 33019811 "Employee Card" extends "Employee Card"
{
    layout
    {
        modify("No.")
        {
            Caption = 'Employee No.';
        }
        modify("Birth Date")
        {
            Caption = 'Date of Birth (A.D.)';
        }
        modify("Union Membership No.")
        {
            visible = false;
        }
        modify("Employment Date")
        {
            Editable = false;
        }
        modify("Application Method")

        {
            Visible = false;
        }
        modify("Employee Posting Group")
        {
            Visible = false;
        }
        addafter("Last Name")
        {
            field(FullName; Rec.FullName)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FullName field.';
            }
            field("NAV Login ID"; Rec."NAV Login ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NAV Login ID field.';
            }
            field(Salutation; Rec.Salutation)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Salutation field.';

            }
            field("Secondary Mobile No."; Rec."Secondary Mobile No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Secondary Mobile No. field.';

            }
            field("Relation With Emergency Cont"; Rec."Relation With Emergency Cont")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Relation With Emergency Cont field.';

            }
            field("Emergency Mobile No."; Rec."Emergency Mobile No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Emergency Mobile No. field.';

            }
            field("Date of Birth (B.S.)"; Rec."Date of Birth (B.S.)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Date of Birth (B.S.) field.';

            }

            field(Age; Rec.Age)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Age field.';

            }
            field("CIF ID"; Rec."CIF ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CIF ID field.';

            }
            field("Marital Status"; Rec."Marital Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Marital Status field.';

            }
            field("Citizen Number"; Rec."Citizen Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizen Number field.';

            }
            field("Citizenship Issue Place Code"; Rec."Citizenship Issue Place Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizenship Issue Place Code field.';

            }
            field("Citizenship Issue Place"; Rec."Citizenship Issue Place")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizenship Issue Place field.';

            }
            field("Citizenship No. (Nepali)"; Rec."Citizenship No. (Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizenship No. (Nepali) field.';

            }
            field("VDC/Municipality (Nepali)"; Rec."VDC/Municipality (Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VDC/Municipality (Nepali) field.';

            }
            field("Citizenship Issue Date"; Rec."Citizenship Issue Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizenship Issue Date field.';

            }
            field("Citizenship Date(Nepali)"; Rec."Citizenship Date(Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizenship Date(Nepali) field.';

            }
            field("Passport Number"; Rec."Passport Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Passport Number field.';

            }
            field("Blood Group"; Rec."Blood Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Blood Group field.';

            }
            field("Old Employee No."; Rec."Old Employee No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Old Employee No. field.';

            }
            field("Old Employee ID (Regular)"; Rec."Old Employee ID (Regular)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Old Employee ID (Regular) field.';

            }
            field("Tax Code"; Rec."Tax Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tax Code field.';

            }
            field(Disabled; Rec.Disabled)
            {
                ApplicationArea = All;
                Caption = 'Differently Able';
                ToolTip = 'Specifies the value of the Differently Able field.';

            }
            field("Distance betn Res and Office"; Rec."Distance betn Res and Office")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Distance betn Res and Office field.';

            }
            field("Employee Work Shift"; Rec."Employee Work Shift")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Employee Work Shift field.';

            }
            field("Vehicle Type"; Rec."Vehicle Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vehicle Type field.';

            }
            field("Facebook Url"; Rec."Facebook Url")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Facebook Url field.';

            }
        }
        addlast("Address & Contact")
        {
            group("Parmanent Address")
            {
                field("Permanent District"; Rec."Permanent District")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Permanent District field.';

                }
                field("Permanent Province"; Rec."Permanent Province")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Permanent Province field.';

                }
                field("Permanent VDC"; Rec."Permanent VDC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Permanent VDC field.';

                }
                field("Permanent House"; Rec."Permanent House")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Permanent House field.';

                }
                field("Ward No"; Rec."Ward No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ward No field.';

                }
            }
            group("Temporary Address")
            {
                field("Temporary District"; Rec."Temporary District")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Temporary District field.';

                }
                field("Temporary Province"; Rec."Temporary Province")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Temporary Province field.';

                }
                field("Temporary VDC"; Rec."Temporary VDC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Temporary VDC field.';

                }
                field("Temporary House"; Rec."Temporary House")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Temporary House field.';

                }
                field("Temporary Ward No"; Rec."Temporary Ward No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Temporary Ward No field.';

                }

            }

        }
        addafter("Address & Contact")
        {
            group("Official Information")
            {
                field("Salary Level"; Rec."Salary Level")
                {
                    ApplicationArea = All;
                    Caption = 'Job Position';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Job Position field.';

                }

                field("Functional Title"; Rec."Functional Title")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Functional Title field.';

                }
                field("Functional Title Desc"; Rec."Functional Title Desc")
                {
                    ApplicationArea = All;
                    Caption = 'Functional Title Description';
                    ToolTip = 'Specifies the value of the Functional Title Description field.';

                }
                field("Employment Type"; Rec."Employment Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employment Type field.';

                }
                field("Probation Period"; Rec."Probation Period")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Probation Period field.';

                }
                field("Contract Renew Date"; Rec."Contract Renew Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contract Renew Date field.';

                }
                field("Contract Expiry Month"; Rec."Contract Expiry Month")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Expiry Month field.';

                }
                field("Deputation on"; Rec."Deputation on")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Deputation on field.';
                    trigger OnValidate()
                    begin
                        SetFieldEnable;
                    end;

                }
                field("Extension Counter Code"; Rec."Extension Counter Code")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Extension Counter Code field.';

                }
                field("Extension Counter Name"; Rec."Extension Counter Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Extension Counter Name field.';

                }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';

                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Name field.';

                }
                field("Sub Province Code"; Rec."Sub Province Code")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Sub Province Code field.';

                }
                field("Sub Province Name"; Rec."Sub Province Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sub Province Name field.';

                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Code field.';

                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Name field.';

                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Code field.';

                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Name field.';

                }
                field("Province Code"; Rec."Province Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Province Code field.';

                }
                field("Province Name"; Rec."Province Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Province Name field.';

                }
                field(Cluster; Rec.Cluster)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cluster field.';

                }
                field("Inside/Outisde Valley"; Rec."Inside/Outisde Valley")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inside/Outisde Valley field.';

                }
                field("Posting Region"; Rec."Posting Region")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Region field.';

                }
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salary Grade field.';

                }
                field("Promotion Date"; Rec."Promotion Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Promotion Date field.';

                }
                field("Resignation Date"; Rec."Resignation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Resignation Date field.';

                }
                field("Sol Id"; Rec."Sol Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sol Id field.';

                }
                field("Out-Station eligible"; Rec."Out-Station eligible")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Out-Station eligible field.';

                }
                field("Gratuity Eligibility"; Rec."Gratuity Eligibility")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gratuity Eligibility field.';

                }
                field("Last Placement Date"; Rec."Last Placement Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Placement Date field.';

                }
                field("Approver Code"; Rec."Approver Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approver Code field.';

                }

            }
            group("Employee Information In Nepali")
            {
                field("Full Name (Nepali)"; Rec."Full Name (Nepali)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Full Name (Nepali) field.';

                }
                field("Father's Name (Nepali)"; Rec."Father's Name (Nepali)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Father''s Name (Nepali) field.';

                }
                field("Mother's Name (Nepali)"; Rec."Mother's Name (Nepali)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mother''s Name (Nepali) field.';

                }
            }
            group(Permission)
            {
                field("Disable Punch in"; Rec."Disable Punch in")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disable Punch in field.';

                }
                field(Screener; Rec.Screener)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Screener field.';

                }
                field("Resignation Approver"; Rec."Resignation Approver")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Resignation Approver field.';

                }
                field("Selection committee"; Rec."Selection committee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Selection committee field.';

                }
                field("System Owner"; Rec."System Owner")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the System Owner field.';

                }
            }
        }
        addlast(Payments)
        {
            field("Confirmation Date"; Rec."Confirmation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Confirmation Date field.';

            }
            field("Bank No."; Rec."Bank No.")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Bank No. field.';

            }
            field("CIT No."; Rec."CIT No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CIT No. field.';

            }
            field("CIT Office Cont. Deduction"; Rec."CIT Office Cont. Deduction")
            {
                ApplicationArea = All;
                Caption = 'CIT Deduction Amount';
                ToolTip = 'Specifies the value of the CIT Deduction Amount field.';

            }
            field("PF No."; Rec."PF No.")
            {
                ApplicationArea = All;
                Caption = 'PF Account Number';
                ToolTip = 'Specifies the value of the PF Account Number field.';

            }
            field("PF Contribution"; Rec."PF Contribution")
            {
                ApplicationArea = All;
                Caption = 'PF Deduction %';
                ToolTip = 'Specifies the value of the PF Deduction % field.';

            }
            field("PAN No."; Rec."PAN No.")
            {
                ApplicationArea = All;
                Caption = 'PAN Number';
                ToolTip = 'Specifies the value of the PAN Number field.';

            }
        }
        addafter(Payments)
        {
            group(Payroll)
            {
                field("Total Earning"; Rec."Total Earning")
                {
                    ApplicationArea = All;
                    Visible = PayrollFieldsVisible;
                    ToolTip = 'Specifies the value of the Total Earning field.';

                }
                field("Social Security Tax"; Rec."Social Security Tax")
                {
                    ApplicationArea = All;
                    Visible = PayrollFieldsVisible;
                    ToolTip = 'Specifies the value of the Social Security Tax field.';

                }
                field("Remuneration & Benefits Tax"; Rec."Remuneration & Benefits Tax")
                {
                    ApplicationArea = All;
                    Visible = PayrollFieldsVisible;
                    ToolTip = 'Specifies the value of the Remuneration & Benefits Tax field.';

                }
                field("Total Retirement Contribution"; Rec."Total Retirement Contribution")
                {
                    ApplicationArea = All;
                    Visible = PayrollFieldsVisible;
                    ToolTip = 'Specifies the value of the Total Retirement Contribution field.';

                }
                field("Total Donation Contribution"; Rec."Total Donation Contribution")
                {
                    ApplicationArea = All;
                    Visible = PayrollFieldsVisible;
                    ToolTip = 'Specifies the value of the Total Donation Contribution field.';

                }
                field("Total Medical Re-Imbursement"; Rec."Total Medical Re-Imbursement")
                {
                    ApplicationArea = All;
                    Visible = PayrollFieldsVisible;
                    ToolTip = 'Specifies the value of the Total Medical Re-Imbursement field.';

                }
                field("PF Loan Advance"; Rec."PF Loan Advance")
                {
                    ApplicationArea = All;
                    Visible = PayrollFieldsVisible;
                    ToolTip = 'Specifies the value of the PF Loan Advance field.';

                }
                field("Salary Advance"; Rec."Salary Advance")
                {
                    ApplicationArea = All;
                    Visible = PayrollFieldsVisible;
                    ToolTip = 'Specifies the value of the Salary Advance field.';

                }
                field("Vehicle Advance"; Rec."Vehicle Advance")
                {
                    ApplicationArea = All;
                    Visible = PayrollFieldsVisible;
                    ToolTip = 'Specifies the value of the Vehicle Advance field.';

                }
                field("Maintenance Advance"; Rec."Maintenance Advance")
                {
                    ApplicationArea = All;
                    Visible = PayrollFieldsVisible;
                    ToolTip = 'Specifies the value of the Maintenance Advance field.';

                }
                field("Total Loan"; Rec."Total Loan")
                {
                    ApplicationArea = All;
                    Visible = PayrollFieldsVisible;
                    ToolTip = 'Specifies the value of the Total Loan field.';

                }
                field("Premium of Life Insurance"; Rec."Premium of Life Insurance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Premium of Life Insurance field.', Comment = '%';
                }
                field("Premium of Health Insurance"; Rec."Premium of Health Insurance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Premium of Health Insurance field.', Comment = '%';
                }
                field("Premium Property Insurance"; Rec."Premium Property Insurance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Premium Property Insurance field.', Comment = '%';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assigned User ID field.', Comment = '%';
                }
                field("Contract Salary Amount"; Rec."Contract Salary Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contract Salary Amount field.', Comment = '%';
                }
                field("Lumpsum CIT (Not Actual)"; Rec."Lumpsum CIT (Not Actual)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lumpsum CIT (Not Actual) field.', Comment = '%';
                }
                field("Lumpsum RF (Not Actual)"; Rec."Lumpsum RF (Not Actual)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lumpsum RF (Not Actual) field.', Comment = '%';
                }
            }
            group("Insurance Details")
            {

                field("Insurance Code"; Rec."Insurance Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance Code field.', Comment = '%';
                }
                field("Insurance Name"; Rec."Insurance Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance Name field.', Comment = '%';
                }
                field("Policy No."; Rec."Policy No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Policy No. field.', Comment = '%';
                }
                field("Insurance Date"; Rec."Insurance Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance Date field.', Comment = '%';
                }
                field("Insurance Expiry Date"; Rec."Insurance Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance Expiry Date field.', Comment = '%';
                }
                field("Insurance Expiry Date (B.S.)"; Rec."Insurance Expiry Date (B.S.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance Expiry Date (B.S.) field.', Comment = '%';
                }
                field("Premium Amount"; Rec."Premium Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Premium Amount field.', Comment = '%';
                }
                field("Rebate Amount"; Rec."Rebate Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rebate Amount field.', Comment = '%';
                }
                field("Insurance Disabled"; Rec."Insurance Disabled")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disabled field.', Comment = '%';
                }
                field("KPI Functional Title"; Rec."KPI Functional Title")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the KPI Functional Title field.', Comment = '%';
                }
                field("KPI Deputation Value"; Rec."KPI Deputation Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the KPI Deputation Value field.', Comment = '%';
                }
                field("KPI Deputation"; Rec."KPI Deputation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the KPI Deputation field.', Comment = '%';
                }
            }
            part(PayrollAttributesUsage; "Payroll Attributes Usage")
            {
                ApplicationArea = All;
                SubPageView = WHERE(Subtype = FILTER("Employer Contribution" | "Employee Contribution" | CIT | "Lump Sum Contribution" | RF),
                                  Type = CONST(Deduction));
                SubPageLink = "Employee Code" = FIELD("No.");

            }
            part(AccessControlSubform; "Access Control Subform")
            {
                ApplicationArea = All;
                SubPageLink = Type = CONST(Employee), Code = FIELD("No.");
                Editable = false;
            }
            part(AttachmentSubform; "Attachment Subform")
            {
                Caption = 'Attachments';
                SubPageLink = "Order No." = FIELD("No.");
                ApplicationArea = All;

            }
            part(LoanOutstandingSubform; "Loan Outstanding Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Employee No." = FIELD("No.");

            }
            part(EmployeeLeaveDays; "Employee Leave Days")
            {
                ApplicationArea = All;
                //SubPageLink = 
                SubPageView = WHERE("Remaining Days" = FILTER(> 0));
                // SubPageLink ="Employee No."=FIELD("No.");
            }
        }
    }
    actions
    {
        addafter("Q&ualifications")
        {
            action("Employee Work Experience")
            {
                ApplicationArea = All;
                Caption = 'Work Experience';
                RunObject = Page "Employee Work Qualification";
                RunPageLink = "Employee No." = field("No."), "Emp Qualification Type" = CONST(Work), "Master Type" = CONST(Employee);
                Image = Certificate;
                ToolTip = 'Executes the Work Experience action.';
            }
        }
        addafter("Co&nfidential Info. Overview")
        {
            action("Pay Employee")
            {
                ApplicationArea = All;
                ToolTip = 'View employee ledger entries for the record with remaining amount that have not been paid yet.';
                RunObject = page "Employee Ledger Entries";
                RunPageLink = "Employee No." = FIELD("No."),
                                                  "Remaining Amount" = FILTER(< 0),
                                  "Applies-to ID" = FILTER('');
                Promoted = true;
                Visible = false;
                PromotedIsBig = true;
                Image = SuggestVendorPayments;
                PromotedCategory = Process;
                trigger OnAction()
                begin

                end;
            }
        }
        addafter("Pay Employee")
        {
            group("Employee Activity")
            {
                action("Request Leave")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = MiniForm;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Request Leave action.';
                    trigger OnAction()
                    begin
                        Rec.LeaveRequest;
                    end;
                }
                action("Request Travel")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Travel;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Request Travel action.';
                    trigger OnAction()
                    begin
                        Rec.TravelRequest;
                    end;
                }
                action("Request Resign")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = BookingsLogo;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Request Resign action.';
                    trigger OnAction()
                    begin
                        ResignationMgt.OpenResignationRequest(Rec."No.");
                        CurrPage.CLOSE();
                    end;
                }
                action("Request Attendace Missed")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Absence;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Request Attendace Missed action.';
                    trigger OnAction()
                    begin
                        HRMgt.OpenAttendanceMissed(Rec."No.");
                    end;
                }
                action("Out of Office Forms")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Planning;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Out of Office Forms action.';
                    trigger OnAction()
                    begin
                        Rec.OutOfOffice;
                        CurrPage.CLOSE
                    end;
                }
                action("Medical insurance")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = List;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Medical insurance action.';
                    trigger OnAction()
                    begin
                        MedicalInsuranceMgt.OpenMedicalInsuranePage(Rec."No.");
                    end;
                }
                action("Bulk Cash")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = CashFlow;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Bulk Cash action.';
                    trigger OnAction()
                    begin
                        Rec.BulkCash;
                        CurrPage.CLOSE;
                    end;
                }
                action("OT Form")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = PhysicalInventory;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the OT Form action.';
                    trigger OnAction()
                    begin
                        Rec.OTRequest;
                        CurrPage.CLOSE;
                    end;
                }
                action("Apply for Promotion")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = PhysicalInventory;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Apply for Promotion action.';
                    trigger OnAction()
                    var
                        Candidate: Record Candidate;
                    begin
                        Candidate.RESET;
                        Candidate.SETRANGE("No.", Rec."No.");
                        IF NOT Candidate.FINDFIRST THEN BEGIN
                            Candidate.INIT;
                            Candidate."No." := Rec."No.";
                            Candidate."First Name" := Rec."First Name";
                            Candidate."Middle Name" := Rec."Middle Name";
                            Candidate."Last Name" := Rec."Last Name";
                            Candidate."Birth Date" := Rec."Birth Date";
                            Candidate."Employment Type" := Rec."Employment Type";
                            Candidate.Gender := Rec.Gender;
                            Candidate."Phone No." := Rec."Phone No.";
                            Candidate."E-Mail" := Rec."E-Mail";
                            Candidate."Mobile No." := Rec."Mobile Phone No.";
                            //Candidate."Permanent Address" := Rec."Permanent Address";
                            Candidate.Initials := FORMAT(Rec.Salutation);
                            Candidate."Candidate Type" := Candidate."Candidate Type"::Internal;
                            Candidate.INSERT;
                        END;
                        PAGE.RUN(PAGE::"Candidate Card", Candidate);
                    end;
                }
                action("Request Appraisal")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = List;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Request Appraisal action.';
                    trigger OnAction()
                    begin
                        AppraisalRec.RESET;
                        AppraisalRec.SETRANGE("Employee Code", Rec."No.");
                        IF NOT AppraisalRec.FINDFIRST THEN BEGIN
                            AppraisalRec.INIT;
                            AppraisalRec.VALIDATE("Employee Code", Rec."No.");
                            AppraisalRec.INSERT(TRUE);
                            PAGE.RUN(33019878, AppraisalRec);
                        END
                        ELSE
                            PAGE.RUN(33019878, AppraisalRec);
                    end;
                }
            }
        }
        addafter("Request Appraisal")
        {
            group("Loan/Advance")
            {
                action("Request Salary Advance")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Payment;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Request Salary Advance action.';
                    trigger OnAction()
                    var
                        SalaryAdvance: Record "Employee Loan/Advance";
                    begin
                        CLEAR(LoanMgt);
                        LoanMgt.OpenLoan(Rec."No.", Type::"Salary Advance");
                    end;
                }
                action("Request Personal Loan")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Loaners;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Request Personal Loan action.';
                    trigger OnAction()
                    begin
                        CLEAR(LoanMgt);
                        LoanMgt.OpenLoan(Rec."No.", Type::"Personal Loan");
                    end;
                }
                action("Request Vehicle Loan")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = CalculateShipment;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Request Vehicle Loan action.';

                    trigger OnAction()
                    begin
                        CLEAR(LoanMgt);
                        LoanMgt.OpenLoan(Rec."No.", Type::"Vehicle Loan");
                    end;
                }
                action("Request Home Loan")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = AddToHome;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Request Home Loan action.';

                    trigger OnAction()
                    begin
                        CLEAR(LoanMgt);
                        LoanMgt.OpenLoan(Rec."No.", Type::"Home Loan");
                    end;
                }
            }
        }
        addafter("Request Home Loan")
        {
            group("Other Information")
            {
                action("Payroll Attributes Usage")
                {
                    ApplicationArea = All;
                    RunObject = Page "Payroll Attributes Usage";
                    RunPageLink = "Employee Code" = FIELD("No.");
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Components;
                    PromotedCategory = Category6;
                    ToolTip = 'Executes the Payroll Attributes Usage action.';
                    trigger OnAction()
                    begin

                    end;
                }
                action("Training History")
                {
                    ApplicationArea = All;
                    RunObject = Page "List of Training by Employee";
                    RunPageLink = "Employee Code" = FIELD("No."),
                                                  Type = CONST(Trainee);
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = AllLines;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    RunPageMode = View;
                    ToolTip = 'Executes the Training History action.';
                    trigger OnAction()
                    begin

                    end;
                }
                action("Training Given")
                {
                    ApplicationArea = All;
                    RunObject = Page "List of Training by Employee";
                    RunPageLink = "Employee Code" = FIELD("No."),
                                                  Type = CONST(Trainer);
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Allocations;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    RunPageMode = View;
                    ToolTip = 'Executes the Training Given action.';
                    trigger OnAction()
                    begin

                    end;
                }
                action("Access Control")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    Visible = false;
                    PromotedIsBig = true;
                    Image = Register;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Access Control action.';
                    trigger OnAction()
                    begin
                        HRMgt.OpenGrantAccessControl(Rec."No.");
                    end;
                }
                action("Transfer History")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = History;
                    PromotedCategory = Category6;
                    ToolTip = 'Executes the Transfer History action.';
                    trigger OnAction()
                    var
                        PageTransferHistory: Page "Employee Transfer Requests";
                    begin
                        EmployeeAct.RESET;
                        Rec.FILTERGROUP(2);
                        EmployeeAct.SETFILTER(Type, '%1|%2', EmployeeAct.Type::"HR Transfer", EmployeeAct.Type::"Employee Transfer");
                        EmployeeAct.SETRANGE("Employee No.", Rec."No.");
                        EmployeeAct.SETFILTER("Approval Status", '%1|%2', EmployeeAct."Approval Status"::Acknowledged, EmployeeAct."Approval Status"::Approved); //Min -- Approved filter added.
                        Rec.FILTERGROUP(0);
                        CLEAR(PageTransferHistory);
                        PageTransferHistory.ForHistoryPage;
                        PageTransferHistory.SETTABLEVIEW(EmployeeAct);
                        PageTransferHistory.SETRECORD(EmployeeAct);
                        PageTransferHistory.RUN;
                    end;
                }
                action("Access Control History")
                {
                    ApplicationArea = All;
                    RunObject = Page "Access Control History";
                    RunPageView = WHERE(Status = CONST(approved));
                    RunPageLink = "Employee No." = FIELD("No.");
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = History;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    RunPageMode = View;
                    ToolTip = 'Executes the Access Control History action.';

                    trigger OnAction()
                    begin

                    end;
                }
                action("Show Leave Earn")
                {
                    ApplicationArea = All;
                    RunObject = Page "Leave Earn";
                    RunPageLink = "EmpNo" = FIELD("No.");
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = AbsenceCategory;
                    PromotedCategory = Category6;
                    ToolTip = 'Executes the Show Leave Earn action.';
                    trigger OnAction()
                    begin

                    end;
                }
                action("Promotion History")
                {
                    ApplicationArea = All;
                    RunObject = Page "Promotion History";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Production;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Promotion History action.';
                    trigger OnAction()
                    begin

                    end;
                }
                action("Service History")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = ServiceAgreement;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Service History action.';

                    trigger OnAction()
                    begin
                        ServiceHistory.RESET;
                        ServiceHistory.FILTERGROUP(2);
                        ServiceHistory.SETRANGE("Employee No.", Rec."No.");
                        ServiceHistory.FILTERGROUP(0);
                        PAGE.RUN(PAGE::"Service History Lists", ServiceHistory);
                    end;
                }
            }

        }
        addafter("Service History")
        {
            group("Update Information")
            {
                action(Save)
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Save;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Save action.';

                    trigger OnAction()
                    begin
                        CheckEmployee;
                        IF NOT CheckForLeaveEarnExist THEN BEGIN
                            IF rec."Employment Type" = rec."Employment Type"::Contract THEN
                                LeaveMgt.UpdateLeaveEmployeeContract(Rec."No.", Rec."Employment Date", rec."Employment Type", rec.Gender, rec."Marital Status")
                            ELSE IF rec."Employment Type" IN [rec."Employment Type"::Permanent, rec."Employment Type"::Probation] THEN
                                LeaveMgt.UpdateLeaveEmployee(rec."No.", rec."Employment Date", rec."Employment Type", rec.Gender, rec."Marital Status");
                        END;
                        //PayrollEngine.InsertPayrollAttributesUsage("No.");
                        rec.Saved := TRUE;
                        rec.MODIFY;
                        MESSAGE('Saved');
                    end;
                }
                action("Assign Job Function")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = AddWatch;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Assign Job Function action.';
                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to assign job function?', FALSE) THEN
                            HRMgt.PopUpForJobAssignment(Rec);
                    end;
                }
                action("Appointment Job Function")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Campaign;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Appointment Job Function action.';
                    trigger OnAction()
                    var
                        AppointmentOfEmployee: Report "Formation of Department/Branch";
                    begin
                        IF CONFIRM('Do you want to appoint job function?', FALSE) THEN BEGIN
                            CLEAR(AppointmentOfEmployee);
                            AppointmentOfEmployee.SetAppointment(Rec."No.");
                            AppointmentOfEmployee.RUN;
                        END;
                    end;
                }
                action("Add Job Function")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Insert;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Add Job Function action.';
                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to add job function?', FALSE) THEN
                            HRMgt.PopUpForJobAddition(Rec);
                    end;
                }
                action("Contract Renew")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = ContactReference;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Contract Renew action.';
                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to renew the contract?', FALSE) THEN
                            HRMgt.PopUpForContractRenew(Rec);
                    end;
                }
                action("Generate New Employee Card")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Archive;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Generate New Employee Card action.';

                    trigger OnAction()
                    begin
                        IF NOT CONFIRM('Do you want to create new employee card?', FALSE) THEN
                            EXIT;
                        Employee.GenerateNewEmployeeCard(Rec);
                    end;
                }
                action("Permsission Needed Leave")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = PreviewChecks;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Permsission Needed Leave action.';

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to grant HR permission Leave for this employee?', FALSE) THEN BEGIN
                            CurrPage.SETSELECTIONFILTER(Rec);
                            REPORT.RUN(REPORT::"Grant Permission Needed Leave", TRUE, FALSE, Rec);
                        END;
                    end;
                }
                action("Promote Employee")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Post;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Promote Employee action.';

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to promote employee %1 ?', FALSE, Rec."Full Name") THEN
                            HRMgt.UpdatePromotion(Rec."No.");
                    end;
                }
                action("UpdatePRAttributes")
                {
                    ApplicationArea = All;
                    Caption = 'Update Payroll Att Usage';
                    Promoted = true;
                    Visible = FALSE;
                    PromotedIsBig = true;
                    Image = UpdateDescription;
                    PromotedCategory = Category7;
                    ToolTip = 'Executes the Update Payroll Att Usage action.';

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(Rec);
                        REPORT.RUN(33019801, TRUE, FALSE, Rec);
                    end;
                }
                action("Insert Payroll Attributes")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = AddContacts;
                    PromotedCategory = Category7;
                    ToolTip = 'Executes the Insert Payroll Attributes action.';
                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to update payroll attributes usage ?', FALSE) THEN
                            PayrollEngine.InsertPayrollAttributes;
                    end;
                }
                action("Confirmation Employee")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Confirm;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Confirmation Employee action.';
                    trigger OnAction()
                    begin
                        Employee.RESET;
                        Employee.SETRANGE("No.", Rec."No.");
                        Employee.FINDFIRST;
                        Employee.TESTFIELD("Employment Type", Rec."Employment Type"::Probation);
                        REPORT.RUN(REPORT::"Generate Leave Balance", TRUE, FALSE, Employee);
                    end;
                }
                action("Update Loan Details")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = UpdateXML;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Update Loan Details action.';
                    trigger OnAction()
                    begin
                        Employee.RESET;
                        Employee.SETRANGE("No.", Rec."No.");
                        IF Employee.FINDFIRST THEN
                            REPORT.RUNMODAL(REPORT::"Emp Loan Outstanding Update", TRUE, FALSE, Employee);
                    end;
                }
                action("Generate Leave Balance")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = GiroPlus;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Generate Leave Balance action.';
                    trigger OnAction()
                    begin
                        Employee.RESET;
                        Employee.SETRANGE("No.", Rec."No.");
                        REPORT.RUNMODAL(33019818, TRUE, FALSE, Employee);
                    end;
                }
                action("Leave Earn (Contract)")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = EditFilter;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Leave Earn (Contract) action.';
                    trigger OnAction()
                    var

                        TempLeaveEarn: Record "Leave Earn";
                    begin
                        LeaveMgt.CreateLeaveEarnContract(Rec);
                    end;
                }
                action("Insert Mandatory Attachments")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Insert;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Insert Mandatory Attachments action.';
                    trigger OnAction()
                    begin
                        InsertAttachmentLines(Rec);
                    end;
                }
                action("Upate Employment Date")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    Visible = False;
                    PromotedIsBig = true;
                    Image = UpdateUnitCost;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Upate Employment Date action.';

                    trigger OnAction()
                    begin
                        IF NOT CONFIRM('Do you want to upate employment date?', FALSE) THEN
                            EXIT;
                        HRMgt.UpdateEmploymentDate(Rec."No.");
                    end;
                }
            }
            action("Employee Experience Letter")
            {
                ApplicationArea = All;
                Promoted = true;
                Visible = FieldVisible;
                PromotedIsBig = true;
                Image = Report;
                PromotedCategory = Report;
                PromotedOnly = true;
                ToolTip = 'Executes the Employee Experience Letter action.';

                trigger OnAction()
                begin
                    EmployeeAct.RESET;
                    EmployeeAct.SETRANGE("Employee No.", Rec."No.");
                    EmployeeAct.SETRANGE(Type, EmployeeAct.Type::Resignation);
                    EmployeeAct.SETRANGE("Approval Status", EmployeeAct."Approval Status"::Settled);
                    IF EmployeeAct.FINDFIRST THEN BEGIN
                        Employee.RESET;
                        Employee.SETRANGE("No.", Rec."No.");
                        IF Employee.FINDFIRST THEN BEGIN
                            Employee.TESTFIELD(Salutation);
                            REPORT.RUN(70022, TRUE, TRUE, Employee);

                        END;
                    END;
                END;
            }
            action("Resignation Acceptance Letter")
            {
                ApplicationArea = All;
                Promoted = true;
                Visible = FieldVisible1;
                PromotedIsBig = true;
                Image = Report;
                PromotedCategory = Report;
                PromotedOnly = true;
                ToolTip = 'Executes the Resignation Acceptance Letter action.';

                trigger OnAction()
                begin
                    EmployeeAct.RESET;
                    EmployeeAct.SETRANGE(Type, EmployeeAct.Type::Resignation);
                    EmployeeAct.SETRANGE("Employee No.", Rec."No.");
                    IF EmployeeAct.FINDLAST THEN
                        EmployeeAct.TESTFIELD("Approval Status", EmployeeAct."Approval Status"::Approved);

                    Employee.RESET;
                    Employee.SETRANGE("No.", Rec."No.");
                    IF Employee.FINDFIRST THEN BEGIN
                        Employee.TESTFIELD(Salutation);
                        REPORT.RUN(70023, TRUE, TRUE, Employee);
                    END;
                end;
            }
            action("Resignation Release Letter")
            {
                ApplicationArea = All;
                Promoted = true;
                Visible = FieldVisible;
                PromotedIsBig = true;
                Image = Report;
                PromotedCategory = Report;
                PromotedOnly = true;
                ToolTip = 'Executes the Resignation Release Letter action.';

                trigger OnAction()

                begin
                    Employee.RESET;
                    Employee.SETRANGE("No.", Rec."No.");
                    IF Employee.FINDFIRST THEN BEGIN
                        Employee.TESTFIELD(Salutation);
                        EmployeeAct.RESET;
                        EmployeeAct.SETRANGE(Type, EmployeeAct.Type::Resignation);
                        EmployeeAct.SETRANGE("Employee No.", Employee."No.");
                        IF EmployeeAct.FINDLAST THEN
                            EmployeeAct.TESTFIELD("Approval Status", EmployeeAct."Approval Status"::Settled);
                        REPORT.RUN(70024, TRUE, TRUE, Employee);
                    END;
                end;
            }
            action(Memo)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Report;
                PromotedCategory = Report;
                PromotedOnly = true;
                ToolTip = 'Executes the Memo action.';

                trigger OnAction()
                begin
                    Employee.RESET;
                    Employee.SETRANGE("No.", Rec."No.");
                    IF Employee.FINDFIRST THEN BEGIN
                        Employee.TESTFIELD(Salutation);
                        REPORT.RUN(70026, TRUE, TRUE, Employee);
                    END;
                end;
            }
            action("Insert Grade")
            {
                ApplicationArea = All;
                RunObject = Report 33019833;
                Promoted = true;
                Visible = false;
                PromotedIsBig = true;
                Image = Action;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Insert Grade action.';
                trigger OnAction()
                begin

                end;
            }
            group("Retirement Fund")
            {
                action("Request Retirement Fund")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Allocate;
                    PromotedCategory = Category8;
                    ToolTip = 'Executes the Request Retirement Fund action.';
                    trigger OnAction()
                    begin
                        Rec.RFRequest;
                    end;
                }
            }
        }

    }
    var
        Usersetup: Record "User Setup";
        PayrollFieldsVisible: Boolean;
        Employee: Record Employee;
        ValdiateEmp: Report 33019804;
        EmployeeAct: Record "Employee Activity";
        TransferCard: Page "Transfer Card";
        LoanMgt: Codeunit "Loan Mgt.";
        Type: Option ,"Salary Advance","Personal Loan","Home Loan","Vehicle Loan";
        AppraisalRec: Record Appraisal;
        Fieldvisible: Boolean;
        Fieldvisible1: Boolean;
        HRMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        MedicalInsuranceMgt: Codeunit "MedicalInsurance Mgt";
        ExtensionCounterEditable: Boolean;
        BranchEditable: Boolean;
        SubProvinceEditable: Boolean;
        ProvinceEditable: Boolean;
        UnitEditable: Boolean;
        DepartmentEditable: Boolean;
        PayrollEngine: Codeunit "Payroll Engine";
        ServiceHistory: Record "Employee Service History";
        PGSetup: Record "Payroll General Setup";


    trigger OnOpenPage()
    begin
        Usersetup.GET(USERID);
        PayrollFieldsVisible := Usersetup."Can View Payroll Fields";

        SetFieldEnable;

        //>>updating date
        IF Rec."Birth Date" <> 0D THEN BEGIN
            Rec.Age := ROUND((TODAY - Rec."Birth Date") / 365.4, 1, '<');
            Rec.MODIFY;
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        WorkShift: Record "Work Shift";
    begin
        PGSetup.GET;
        PGSetup.TESTFIELD("Default Work Shift");
        Rec.VALIDATE("Employee Work Shift", PGSetup."Default Work Shift");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // IF NOT Rec.Saved THEN
        //     ERROR('Employee Card must be saved first');
    end;

    LOCAL PROCEDURE SetNoFieldVisible();
    VAR
        DocumentNoVisibility: Codeunit 1400;
    BEGIN
        EmployeeAct.RESET;
        EmployeeAct.SETRANGE("Employee No.", Rec."No.");
        EmployeeAct.SETRANGE(Type, EmployeeAct.Type::Resignation);
        EmployeeAct.SETRANGE("Approval Status", EmployeeAct."Approval Status"::Settled);
        IF EmployeeAct.FINDFIRST THEN
            Fieldvisible := TRUE
        ELSE
            Fieldvisible := FALSE;

        EmployeeAct.RESET;
        EmployeeAct.SETRANGE("Employee No.", Rec."No.");
        EmployeeAct.SETRANGE(Type, EmployeeAct.Type::Resignation);
        EmployeeAct.SETRANGE("Approval Status", EmployeeAct."Approval Status"::Approved);
        IF EmployeeAct.FINDFIRST THEN
            Fieldvisible1 := TRUE
        ELSE
            Fieldvisible1 := FALSE;
    END;

    LOCAL PROCEDURE InsertAttachmentLines(VAR Emp: Record Employee);
    VAR
        IncomingDocument: Record "Incoming Document";
        AttachmentMandatory: Record "Attachment Setup";
    BEGIN
        AttachmentMandatory.RESET;
        AttachmentMandatory.SETFILTER(Type, '%1|%2|%3|%4', AttachmentMandatory.Type::Education,
                  AttachmentMandatory.Type::"Employee Profile", AttachmentMandatory.Type::"Work Experience",
                  AttachmentMandatory.Type::"Complaince Requirement Forms");
        IF AttachmentMandatory.FINDFIRST THEN
            REPEAT
                IncomingDocument.RESET;
                IncomingDocument.SETRANGE("Order No.", Emp."No.");
                IncomingDocument.SETRANGE("Attachment Code", AttachmentMandatory."Attachment Code");
                IF NOT IncomingDocument.FINDFIRST THEN BEGIN
                    IncomingDocument.RESET;
                    IncomingDocument.INIT;
                    IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
                    IncomingDocument.Description := Emp.TABLENAME;
                    IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
                    //IncomingDocument."Order No." := Emp."No.";
                    IncomingDocument."Order No." := FORMAT(Emp."No.");
                    IncomingDocument."Employee Code" := FORMAT(Emp."No.");
                    IncomingDocument.INSERT(TRUE);

                END;
            UNTIL AttachmentMandatory.NEXT = 0;
    END;

    LOCAL PROCEDURE SetFieldEnable();
    BEGIN
        CASE Rec."Deputation on" OF
            Rec."Deputation on"::"Extension Counter":
                BEGIN
                    BranchEditable := FALSE;
                    ProvinceEditable := FALSE;
                    SubProvinceEditable := FALSE;
                    ExtensionCounterEditable := TRUE;
                    UnitEditable := FALSE;
                    DepartmentEditable := FALSE;
                END;
            Rec."Deputation on"::Branch:
                BEGIN
                    BranchEditable := TRUE;
                    ProvinceEditable := FALSE;
                    SubProvinceEditable := FALSE;
                    ExtensionCounterEditable := FALSE;
                    UnitEditable := FALSE;
                    DepartmentEditable := FALSE;
                END;
            Rec."Deputation on"::Province:
                BEGIN
                    BranchEditable := FALSE;
                    ProvinceEditable := TRUE;
                    SubProvinceEditable := FALSE;
                    ExtensionCounterEditable := FALSE;
                    UnitEditable := FALSE;
                    DepartmentEditable := FALSE;
                END;
            Rec."Deputation on"::"Sub Province":
                BEGIN
                    BranchEditable := FALSE;
                    ProvinceEditable := FALSE;
                    SubProvinceEditable := TRUE;
                    ExtensionCounterEditable := FALSE;
                    UnitEditable := FALSE;
                    DepartmentEditable := FALSE;
                END;
            Rec."Deputation on"::Unit, Rec."Deputation on"::Department:
                BEGIN
                    BranchEditable := FALSE;
                    ProvinceEditable := FALSE;
                    SubProvinceEditable := FALSE;
                    ExtensionCounterEditable := FALSE;
                    UnitEditable := TRUE;
                    DepartmentEditable := TRUE;
                END;
        END;
    END;

    LOCAL PROCEDURE CheckEmployee();
    BEGIN
        //   {IF NOT (Status = Status::Active) THEN
        //         EXIT;} //Min 1.1 commented for only control apply for new creation employee
        IF Rec."New Employee" THEN BEGIN //Min 1.2
            Rec.TESTFIELD("Full Name");
            Rec.TESTFIELD("Deputation on");
            Rec.TESTFIELD("Salary Level");
            Rec.TESTFIELD("Salary Grade");
            Rec.TESTFIELD(Gender);
            Rec.TESTFIELD("Marital Status");
            Rec.TESTFIELD("Employment Type");
            Rec.TESTFIELD("NAV Login ID");
            Rec.TESTFIELD("Functional Title");
            Rec.TESTFIELD("Employment Date");
            Rec.TESTFIELD("Tax Code");
            Rec.TESTFIELD("Inside/Outisde Valley");
            Rec.TESTFIELD("Posting Region");
            Rec.TESTFIELD("Date of Birth (B.S.)"); //Min <<
            Rec.TESTFIELD("PAN No.");
            Rec.TESTFIELD("Citizen Number");//Min >>
            IF Rec."Employment Type" = Rec."Employment Type"::Permanent THEN
                Rec.TESTFIELD("Confirmation Date");
            IF Rec."Employment Type" = Rec."Employment Type"::Contract THEN
                Rec.TESTFIELD("Contract Salary Amount");
            IF Rec."Employment Type" = Rec."Employment Type"::Probation THEN //Min
                Rec.TESTFIELD("Probation Period");
            IF Rec."Employment Type" = Rec."Employment Type"::Contract THEN BEGIN
                Rec.TESTFIELD("Contract Expiry Month");
            END;

            CASE Rec."Deputation on" OF
                Rec."Deputation on"::Branch:
                    BEGIN
                        Rec.TESTFIELD("Branch Name");
                        Rec.TESTFIELD("Global Dimension 1 Code");
                        Rec.TESTFIELD("Province Code");
                        Rec.TESTFIELD("Sub Province Code");
                    END;

                Rec."Deputation on"::Department:
                    BEGIN
                        Rec.TESTFIELD("Department Code");
                        Rec.TESTFIELD("Department Name");
                    END;

                Rec."Deputation on"::"Extension Counter":
                    BEGIN
                        Rec.TESTFIELD("Extension Counter Code");
                        Rec.TESTFIELD("Extension Counter Name");
                        Rec.TESTFIELD("Global Dimension 1 Code");
                        Rec.TESTFIELD("Province Code");
                        Rec.TESTFIELD("Sub Province Code");
                    END;

                Rec."Deputation on"::Province:
                    BEGIN
                        Rec.TESTFIELD("Province Code");
                        Rec.TESTFIELD("Province Name");
                    END;

                Rec."Deputation on"::"Sub Province":
                    BEGIN
                        Rec.TESTFIELD("Province Code");
                        Rec.TESTFIELD("Sub Province Code");
                        Rec.TESTFIELD("Sub Province Name");
                    END;

                Rec."Deputation on"::Unit:
                    BEGIN
                        Rec.TESTFIELD("Unit Code");
                        Rec.TESTFIELD("Unit Name");
                    END;
            END;
        END;
    END;

    LOCAL PROCEDURE CheckForLeaveEarnExist(): Boolean;
    VAR
        LeaveEarn: Record "Leave Earn";
    BEGIN
        LeaveEarn.RESET;
        LeaveEarn.SETRANGE(EmpNo, Rec."No.");
        IF LeaveEarn.FINDFIRST THEN
            EXIT(TRUE);
    END;

}

