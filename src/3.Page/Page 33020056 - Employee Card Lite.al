page 33020056 "Employee Card Lite"
{
    // version NAVW113.02

    // Pradhan modification for NIC Asia
    //   updating date (1st Dec 2019)

    Caption = 'Employee Card Lite';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Employee Activity,Loan,Other Information,Update Information,Retirement Fund Management';
    SourceTable = Employee;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Employee No.';
                    Importance = Standard;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Visible = NoFieldVisible;

                    trigger OnAssistEdit()
                    begin
                        Rec.AssistEdit;
                    end;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the employee''s first name.';
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the employee''s middle name.';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = BasicHR;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the employee''s last name.';
                }
                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.';
                    ApplicationArea = All;
                }
                field("NAV Login ID"; Rec."NAV Login ID")
                {
                    ToolTip = 'Specifies the value of the NAV Login ID field.';
                    ApplicationArea = All;
                }
                field(Initials; Rec.Initials)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the employee''s initials.';
                    Visible = false;
                }
                field(Salutation; Rec.Salutation)
                {
                    ToolTip = 'Specifies the value of the Salutation field.';
                    ApplicationArea = All;
                }
                field("Search Name(NA)"; "Search Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                    Visible = false;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the employee''s gender.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the employee''s telephone number.';
                }
                field(Extension; Rec.Extension)
                {
                    ToolTip = 'Specifies the value of the Extension field.';
                    ApplicationArea = All;
                }
                field("Mobile No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Primary Mobile No.';
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s private telephone number.';
                }
                field("Secondary Mobile No."; Rec."Secondary Mobile No.")
                {
                    ToolTip = 'Specifies the value of the Secondary Mobile No. field.';
                    ApplicationArea = All;
                }
                field("Relation With Emergency Cont"; Rec."Relation With Emergency Cont")
                {
                    ToolTip = 'Specifies the value of the Relation With Emergency Cont field.';
                    ApplicationArea = All;
                }
                field("Emergency Mobile No."; Rec."Emergency Mobile No.")
                {
                    ToolTip = 'Specifies the value of the Emergency Mobile No. field.';
                    ApplicationArea = All;
                }
                field("Date of Birth (A.D.)"; Rec."Birth Date")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Date of Birth (A.D.)';
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s date of birth.';
                }
                field("Date of Birth (B.S.)"; Rec."Date of Birth (B.S.)")
                {
                    ToolTip = 'Specifies the value of the Date of Birth (B.S.) field.';
                    ApplicationArea = All;
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the value of the Age field.';
                    ApplicationArea = All;
                }
                field("CIF ID"; Rec."CIF ID")
                {
                    ToolTip = 'Specifies the value of the CIF ID field.';
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ToolTip = 'Specifies the value of the Marital Status field.';
                    ApplicationArea = All;
                }
                field("E-Mail(Personal)"; "E-Mail")
                {
                    Caption = 'E-Mail (Personal)';
                    ToolTip = 'Specifies the value of the E-Mail (Personal) field.';
                    ApplicationArea = All;
                }
                field("Citizen Number"; Rec."Citizen Number")
                {
                    Caption = 'Citizenship Number';
                    ToolTip = 'Specifies the value of the Citizenship Number field.';
                    ApplicationArea = All;
                }
                field("Citizenship Issue Place Code"; Rec."Citizenship Issue Place Code")
                {
                    Caption = 'Issue Place Code';
                    ToolTip = 'Specifies the value of the Issue Place Code field.';
                    ApplicationArea = All;
                }
                field("Citizenship Issue Place"; Rec."Citizenship Issue Place")
                {
                    Caption = 'Issue Place';
                    ToolTip = 'Specifies the value of the Issue Place field.';
                    ApplicationArea = All;
                }
                field("Citizenship No. (Nepali)"; Rec."Citizenship No. (Nepali)")
                {
                    ToolTip = 'Specifies the value of the Citizenship No. (Nepali) field.';
                    ApplicationArea = All;
                }
                field("VDC/Municipality (Nepali)"; Rec."VDC/Municipality (Nepali)")
                {
                    ToolTip = 'Specifies the value of the VDC/Municipality (Nepali) field.';
                    ApplicationArea = All;
                }
                field("Citizenship Issue Date"; Rec."Citizenship Issue Date")
                {
                    Caption = 'Issue Date';
                    ToolTip = 'Specifies the value of the Issue Date field.';
                    ApplicationArea = All;
                }
                field("Citizenship Date(Nepali)"; Rec."Citizenship Date(Nepali)")
                {
                    ToolTip = 'Specifies the value of the Citizenship Date(Nepali) field.';
                    ApplicationArea = All;
                }
                field("Passport Number"; Rec."Passport Number")
                {
                    ToolTip = 'Specifies the value of the Passport Number field.';
                    ApplicationArea = All;
                }
                field("Blood Group"; Rec."Blood Group")
                {
                    ToolTip = 'Specifies the value of the Blood Group field.';
                    ApplicationArea = All;
                }
                field("Old Employee No."; Rec."Old Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Old Employee No. field.';
                    ApplicationArea = All;
                }
                field("Old Employee ID (Regular)"; Rec."Old Employee ID (Regular)")
                {
                    ToolTip = 'Specifies the value of the Old Employee ID (Regular) field.';
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = BasicHR;
                    Importance = Additional;
                    ToolTip = 'Specifies when this record was last modified.';
                }
                field("Tax Code"; Rec."Tax Code")
                {
                    ToolTip = 'Specifies the value of the Tax Code field.';
                    ApplicationArea = All;
                }
                field(Disabled; Rec.Disabled)
                {
                    Caption = 'Differently Able';
                    ToolTip = 'Specifies the value of the Differently Able field.';
                    ApplicationArea = All;
                }
                field("Distance betn Res and Office"; Rec."Distance betn Res and Office")
                {
                    BlankZero = true;
                    Caption = 'Distance Between Area of Residence and Office(km)';
                    ToolTip = 'Specifies the value of the Distance Between Area of Residence and Office(km) field.';
                    ApplicationArea = All;
                }
                field("Employee Work Shift"; Rec."Employee Work Shift")
                {
                    ToolTip = 'Specifies the value of the Employee Work Shift field.';
                    ApplicationArea = All;
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    ToolTip = 'Specifies the value of the Vehicle Type field.';
                    ApplicationArea = All;
                }
                field("Facebook Url"; Rec."Facebook Url")
                {
                    ToolTip = 'Specifies the value of the Facebook Url field.';
                    ApplicationArea = All;
                }
            }
            group("Address & Contact")
            {
                Caption = 'Address & Contact';
                grid("Permanent Address")
                {
                    Caption = 'Permanent Address';
                }
                field(Address; Address)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Permanent Address';
                    ToolTip = 'Specifies the employee''s address.';
                }
                field("Permanent District"; Rec."Permanent District")
                {
                    Caption = 'Permanent District';
                    ToolTip = 'Specifies the value of the Permanent District field.';
                    ApplicationArea = All;
                }
                field("Permanent Province"; Rec."Permanent Province")
                {
                    ToolTip = 'Specifies the value of the Permanent Province field.';
                    ApplicationArea = All;
                }
                field("Permanent VDC"; Rec."Permanent VDC")
                {
                    Caption = 'VDC';
                    ToolTip = 'Specifies the value of the VDC field.';
                    ApplicationArea = All;
                }
                field("Permanent House"; Rec."Permanent House")
                {
                    Caption = 'House';
                    ToolTip = 'Specifies the value of the House field.';
                    ApplicationArea = All;
                }
                field("Ward No"; Rec."Ward No")
                {
                    ToolTip = 'Specifies the value of the Ward No field.';
                    ApplicationArea = All;
                }
                grid(Control86)
                {
                    Caption = 'Temporary Address';
                }
                field("Temporary Address"; Rec."Address 2")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Temporary Address';
                    ToolTip = 'Specifies additional address information.';
                }
                field("Temporary District"; Rec."Temporary District")
                {
                    Caption = 'Temporary District';
                    ToolTip = 'Specifies the value of the Temporary District field.';
                    ApplicationArea = All;
                }
                field("Temporary Province"; Rec."Temporary Province")
                {
                    ToolTip = 'Specifies the value of the Temporary Province field.';
                    ApplicationArea = All;
                }
                field("Temporary VDC"; Rec."Temporary VDC")
                {
                    Caption = 'VDC';
                    ToolTip = 'Specifies the value of the VDC field.';
                    ApplicationArea = All;
                }
                field("Temporary House"; Rec."Temporary House")
                {
                    Caption = 'House';
                    ToolTip = 'Specifies the value of the House field.';
                    ApplicationArea = All;
                }
                field("Temporary Ward No"; Rec."Temporary Ward No")
                {
                    Caption = 'Ward No';
                    ToolTip = 'Specifies the value of the Ward No field.';
                    ApplicationArea = All;
                }
            }
            group("Official Information")
            {
                Caption = 'Official Information';
                field(Status; Rec.Status)
                {
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employment status of the employee.';
                }
                field("Job Title(NA)"; Rec."Job Title")
                {
                    Caption = 'Job Position';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Job Position field.';
                    ApplicationArea = All;
                }
                field("Salary Level"; Rec."Salary Level")
                {
                    Caption = 'Job Position';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Job Position field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Functional Title Description"; Rec."Functional Title Desc")
                {
                    ToolTip = 'Specifies the value of the Functional Title Desc field.';
                    ApplicationArea = All;
                }
                field("Employment Type"; Rec."Employment Type")
                {
                    Caption = 'Employment Type';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employment Type field.';
                    ApplicationArea = All;
                }
                field("Probation Period"; Rec."Probation Period")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Probation Period field.';
                    ApplicationArea = All;
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ApplicationArea = BasicHR;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the employee began to work for the company.';
                }
                field("Contract Renew Date"; Rec."Contract Renew Date")
                {
                    ToolTip = 'Specifies the value of the Contract Renew Date field.';
                    ApplicationArea = All;
                }
                field("Contract Expiry Month"; Rec."Contract Expiry Month")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Expiry Month field.';
                    ApplicationArea = All;
                }
                field("Contract Expiry Date"; Rec."Contract Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Contract Expiry Date field.';
                    ApplicationArea = All;
                }
                field("Deputation on"; Rec."Deputation on")
                {
                    ToolTip = 'Specifies the value of the Deputation on field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetFieldEnable;
                    end;
                }
                field("Extension Counter Code"; Rec."Extension Counter Code")
                {
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Extension Counter Code field.';
                    ApplicationArea = All;
                }
                field("Extension Counter Name"; Rec."Extension Counter Name")
                {
                    ToolTip = 'Specifies the value of the Extension Counter Name field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("Sub Province Code"; Rec."Sub Province Code")
                {
                    Caption = 'Sub Province  Code';
                    ToolTip = 'Specifies the value of the Sub Province  Code field.';
                    ApplicationArea = All;
                }
                field("Sub Province"; Rec."Sub Province Name")
                {
                    Caption = 'Sub Province';
                    ToolTip = 'Specifies the value of the Sub Province field.';
                    ApplicationArea = All;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ToolTip = 'Specifies the value of the Unit Code field.';
                    ApplicationArea = All;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ToolTip = 'Specifies the value of the Unit Name field.';
                    ApplicationArea = All;
                }
                field("Department Code"; Rec."Department Code")
                {
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Department Code field.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                }
                field("Eco-System"; Rec."Eco-System")
                {
                    ToolTip = 'Specifies the value of the Eco-System field.';
                    ApplicationArea = All;
                }
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specifies the value of the Province Code field.';
                    ApplicationArea = All;
                }
                field("Province Name"; Rec."Province Name")
                {
                    ToolTip = 'Specifies the value of the Province Name field.';
                    ApplicationArea = All;
                }
                field(Cluster; Rec.Cluster)
                {
                    ToolTip = 'Specifies the value of the Cluster field.';
                    ApplicationArea = All;
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Email (Official)';
                    ExtendedDatatype = EMail;
                    ToolTip = 'Specifies the employee''s email address at the company.';
                }
                field("Inside/Outisde Valley"; Rec."Inside/Outisde Valley")
                {
                    ToolTip = 'Specifies the value of the Inside/Outisde Valley field.';
                    ApplicationArea = All;
                }
                field("Posting Region"; Rec."Posting Region")
                {
                    ToolTip = 'Specifies the value of the Posting Region field.';
                    ApplicationArea = All;
                }
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.';
                    ApplicationArea = All;
                }
                field("Resignation Date"; Rec."Resignation Date")
                {
                    ToolTip = 'Specifies the value of the Resignation Date field.';
                    ApplicationArea = All;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the date when the employee was terminated, due to retirement or dismissal, for example.';
                    Visible = false;
                }
                field("Sol Id"; Rec."Sol Id")
                {
                    ToolTip = 'Specifies the value of the Sol Id field.';
                    ApplicationArea = All;
                }
                field("Out-Station eligible"; Rec."Out-Station eligible")
                {
                    ToolTip = 'Specifies the value of the Out-Station eligible field.';
                    ApplicationArea = All;
                }
                field("Gratuity Eligibility"; Rec."Gratuity Eligibility")
                {
                    ToolTip = 'Specifies the value of the Gratuity Eligibility field.';
                    ApplicationArea = All;
                }
                field("Last Placement Date"; Rec."Last Placement Date")
                {
                    ToolTip = 'Specifies the value of the Last Placement Date field.';
                    ApplicationArea = All;
                }
                field("Approver Code"; Rec."Approver Code")
                {
                    ToolTip = 'Specifies the value of the Approver Code field.';
                    ApplicationArea = All;
                }
                field("Promotion Date"; Rec."Promotion Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Promotion Date field.';
                    ApplicationArea = All;
                }
                field("Confirmation Date"; Rec."Confirmation Date")
                {
                    ToolTip = 'Specifies the value of the Confirmation Date field.';
                    ApplicationArea = All;
                }
                field("Department Head"; Rec."Department Head")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department Head field.';
                    ApplicationArea = All;
                }
                field("Chief Of Eco-System"; Rec."Chief Of Eco-System")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Chief Of Eco-System field.';
                    ApplicationArea = All;
                }
                field("KPI Deputation"; Rec."KPI Deputation")
                {
                    ToolTip = 'Specifies the value of the KPI Deputation field.';
                    ApplicationArea = All;
                }
                field("KPI Deputation Value"; Rec."KPI Deputation Value")
                {
                    ToolTip = 'Specifies the value of the KPI Deputation Value field.';
                    ApplicationArea = All;
                }
                field("KPI Functional Title"; Rec."KPI Functional Title")
                {
                    ToolTip = 'Specifies the value of the KPI Functional Title field.';
                    ApplicationArea = All;
                }
            }
            group("Employee Information In Nepali")
            {
                field("Full Name (Nepali)"; Rec."Full Name (Nepali)")
                {
                    ToolTip = 'Specifies the value of the Full Name (Nepali) field.';
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
                field("GrandFather's Name (Nepali)"; Rec."GrandFather's Name (Nepali)")
                {
                    ToolTip = 'Specifies the value of the GrandFather''s Name (Nepali) field.';
                    ApplicationArea = All;
                }
            }
            group(Permission)
            {
                field("Disable Punch in"; Rec."Disable Punch in")
                {
                    ToolTip = 'Specifies the value of the Disable Punch in field.';
                    ApplicationArea = All;
                }
                field(Screener; Rec.Screener)
                {
                    ToolTip = 'Specifies the value of the Screener field.';
                    ApplicationArea = All;
                }
                field("Resignation Approver"; Rec."Resignation Approver")
                {
                    ToolTip = 'Specifies the value of the Resignation Approver field.';
                    ApplicationArea = All;
                }
                field("Selection committee"; Rec."Selection committee")
                {
                    ToolTip = 'Specifies the value of the Selection committee field.';
                    ApplicationArea = All;
                }
                field("System Owner"; Rec."System Owner")
                {
                    ToolTip = 'Specifies the value of the System Owner field.';
                    ApplicationArea = All;
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                field("Union Membership No.(NA)"; Rec."Union Membership No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the employee''s labor union membership number.';
                    Visible = false;
                }
                field("Bank No."; Rec."Bank No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Bank No. field.';
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                    ApplicationArea = All;
                }
                field("CIT No."; Rec."CIT No.")
                {
                    Caption = 'CIT Account Number';
                    ToolTip = 'Specifies the value of the CIT Account Number field.';
                    ApplicationArea = All;
                }
                field("PF No."; Rec."PF No.")
                {
                    Caption = 'PF Account Number';
                    ToolTip = 'Specifies the value of the PF Account Number field.';
                    ApplicationArea = All;
                }
                field("PAN No."; Rec."PAN No.")
                {
                    Caption = 'PAN Number';
                    ToolTip = 'Specifies the value of the PAN Number field.';
                    ApplicationArea = All;
                }
            }
            group("Payments 1")
            {
                Caption = 'Payments 1';
                Visible = false;
                field("Employee Posting Group"; Rec."Employee Posting Group")
                {
                    ApplicationArea = BasicHR;
                    LookupPageId = "Employee Posting Groups";
                    ToolTip = 'Specifies the employee''s type to link business transactions made for the employee with the appropriate account in the general ledger.';
                    Visible = true;
                }
                field("Application Method"; Rec."Application Method")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies how to apply payments to entries for this employee.';
                    Visible = false;
                }
            }
            group(Payroll)
            {
                Caption = 'Payroll';
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
                field("Premium Property Insurance"; Rec."Premium Property Insurance")
                {
                    ToolTip = 'Specifies the value of the Premium Property Insurance field.';
                    ApplicationArea = All;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ToolTip = 'Specifies the value of the Assigned User ID field.';
                    ApplicationArea = All;
                }
                field("Salary Adv Outstanding Amount"; Rec.GetOutstandingAmt)
                {
                    ToolTip = 'Specifies the value of the GetOutstandingAmt field.';
                    ApplicationArea = All;
                }
                field("Contract Salary Amount"; Rec."Contract Salary Amount")
                {
                    ToolTip = 'Specifies the value of the Contract Salary Amount field.';
                    ApplicationArea = All;
                }
                field("Lumpsum CIT (Not Actual)"; Rec."Lumpsum CIT (Not Actual)")
                {
                    ToolTip = 'Specifies the value of the Lumpsum CIT (Not Actual) field.';
                    ApplicationArea = All;
                }
                field("Lumpsum RF (Not Actual)"; Rec."Lumpsum RF (Not Actual)")
                {
                    ToolTip = 'Specifies the value of the Lumpsum RF (Not Actual) field.';
                    ApplicationArea = All;
                }
            }
            group("Insurance Details")
            {
                Caption = 'Insurance Details';
                field("Insurance Code"; Rec."Insurance Code")
                {
                    ToolTip = 'Specifies the value of the Insurance Code field.';
                    ApplicationArea = All;
                }
                field("Insurance Name"; Rec."Insurance Name")
                {
                    ToolTip = 'Specifies the value of the Insurance Name field.';
                    ApplicationArea = All;
                }
                field("Policy No."; Rec."Policy No.")
                {
                    ToolTip = 'Specifies the value of the Policy No. field.';
                    ApplicationArea = All;
                }
                field("Insurance Date"; Rec."Insurance Date")
                {
                    ToolTip = 'Specifies the value of the Insurance Date field.';
                    ApplicationArea = All;
                }
                field("Insurance Expiry Date"; Rec."Insurance Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Insurance Expiry Date field.';
                    ApplicationArea = All;
                }
                field("Insurance Date (B.S.)"; Rec."Insurance Date (B.S.)")
                {
                    ToolTip = 'Specifies the value of the Insurance Date (B.S.) field.';
                    ApplicationArea = All;
                }
                field("Insurance Expiry Date (B.S.)"; Rec."Insurance Expiry Date (B.S.)")
                {
                    ToolTip = 'Specifies the value of the Insurance Expiry Date (B.S.) field.';
                    ApplicationArea = All;
                }
                field("Premium Amount"; Rec."Premium Amount")
                {
                    ToolTip = 'Specifies the value of the Premium Amount field.';
                    ApplicationArea = All;
                }
                field("Rebate Amount"; Rec."Rebate Amount")
                {
                    ToolTip = 'Specifies the value of the Rebate Amount field.';
                    ApplicationArea = All;
                }
                field("Insurance Disabled"; Rec."Insurance Disabled")
                {
                    ToolTip = 'Specifies the value of the Disabled field.';
                    ApplicationArea = All;
                }
            }
            part("Retirement Fund Deduction"; "Payroll Attributes Usage")
            {
                Caption = 'Retirement Fund Deduction';
                SubPageLink = "Employee Code" = field("No.");
                SubPageView = where(Subtype = filter("Employer Contribution" | "Employee Contribution" | CIT | "Lump Sum Contribution" | RF),
                                    Type = const(Deduction));
                ApplicationArea = All;
            }
            part(Control193; "Access Control Subform")
            {
                Editable = false;
                SubPageLink = Type = const(Employee),
                              Code = field("No.");
                ApplicationArea = All;
            }
            part(AttachmentsSubform; "Attachment Subform")
            {
                Caption = 'Attachments';
                SubPageLink = "Order No." = field("No.");
                ApplicationArea = All;
            }
            part(Control197; "Loan Outstanding Subform")
            {
                SubPageLink = "Employee No." = field("No.");
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
                action(Dimensions)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = page "Default Dimensions";
                    RunPageLink = "Table ID" = const(5200),
                                  "No." = field("No.");
                    ShortcutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
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
                    RunPageLink = "Employee No." = field("No."),
                                  "Master Type" = const(Employee);
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
                action("&Confidential Information")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Confidential Information';
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
                                  "Emp Qualification Type" = const(Education),
                                  "Master Type" = const(Employee);
                    ToolTip = 'Open the list of qualifications that are registered for the employee.';
                }
                action("Employee Work Experience")
                {
                    Caption = 'Work Experience';
                    Image = Certificate;
                    RunObject = page "Employee Work Qualification";
                    RunPageLink = "Employee No." = field("No."),
                                  "Emp Qualification Type" = const(Work),
                                  "Master Type" = const(Employee);
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
                separator(Separator23) { }
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
                action("Co&nfidential Info. Overview")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Co&nfidential Info. Overview';
                    Image = ConfidentialOverview;
                    RunObject = page "Confidential Info. Overview";
                    ToolTip = 'View confidential information that is registered for the employee.';
                }
                separator(Separator61) { }
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
                    ToolTip = 'View employee ledger entries for the record with remaining amount that have not been paid yet.';
                    Visible = false;
                }
            }
            group("Employee Activity")
            {
                action("Request Leave")
                {
                    Image = MiniForm;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Request Leave action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.LeaveRequest;
                    end;
                }
                action("Request Travel")
                {
                    Image = Travel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Request Travel action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TravelRequest;
                    end;
                }
                action("Request Transfer")
                {
                    Image = TransferReceipt;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Request Transfer action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        TransferMgt.OpenTransferRequest(Rec."No.");
                    end;
                }
                action("Request Resign")
                {
                    Image = BookingsLogo;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Request Resign action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ResignationMgt.OpenResignationRequest(Rec."No.");
                        CurrPage.Close();
                    end;
                }
                action("Request Attendace Missed")
                {
                    Image = Absence;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Request Attendace Missed action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.OpenAttendanceMissed(Rec."No.");
                    end;
                }
                action("Out of Office Forms")
                {
                    Image = Planning;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Out of Office Forms action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.OutOfOffice;
                        CurrPage.Close
                    end;
                }
                action("Medical insurance")
                {
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Medical insurance action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        MedicalInsuranceMgt.OpenMedicalInsuranePage(Rec."No.");
                    end;
                }
                action("Bulk Cash")
                {
                    Image = CashFlow;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Bulk Cash action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.BulkCash;
                        CurrPage.Close;
                    end;
                }
                action("OT Form")
                {
                    Image = PhysicalInventory;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the OT Form action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.OTRequest;
                        CurrPage.Close
                    end;
                }
                action("Apply for Promotion")
                {
                    Image = PhysicalInventory;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Apply for Promotion action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        Candidate: Record Candidate;
                    begin
                        Candidate.Reset;
                        Candidate.SetRange("No.", Rec."No.");
                        if not Candidate.FindFirst then begin
                            Candidate.Init;
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
                            Candidate."Permanent Address" := Rec.Address;
                            Candidate.Initials := Format(Rec.Salutation);
                            Candidate."Candidate Type" := Candidate."Candidate Type"::Internal;
                            Candidate.Insert;
                        end;
                        Page.Run(Page::"Candidate Card", Candidate);
                    end;
                }
                action("Request Appraisal")
                {
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Request Appraisal action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        AppraisalRec.Reset;
                        AppraisalRec.SetRange("Employee Code", Rec."No.");
                        if not AppraisalRec.FindFirst then begin
                            AppraisalRec.Init;
                            AppraisalRec.Validate("Employee Code", Rec."No.");
                            AppraisalRec.Insert(true);
                            Page.Run(60077, AppraisalRec);
                        end
                        else
                            Page.Run(60077, AppraisalRec);
                    end;
                }
            }
            group("Loan/Advance")
            {
                action("Request Salary Advance")
                {
                    Image = Payment;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Request Salary Advance action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Clear(LoanMgt);
                        LoanMgt.OpenLoan(Rec."No.", Type::"Salary Advance");
                    end;
                }
                action("Request Personal Loan")
                {
                    Image = Loaners;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Request Personal Loan action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Clear(LoanMgt);
                        LoanMgt.OpenLoan(Rec."No.", Type::"Personal Loan");
                    end;
                }
                action("Request Vehicle Loan")
                {
                    Image = CalculateShipment;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Request Vehicle Loan action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Clear(LoanMgt);
                        LoanMgt.OpenLoan(Rec."No.", Type::"Vehicle Loan");
                    end;
                }
                action("Request Home Loan")
                {
                    Image = AddToHome;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Request Home Loan action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Clear(LoanMgt);
                        LoanMgt.OpenLoan(Rec."No.", Type::"Home Loan");
                    end;
                }
            }
            group("Other Information")
            {
                action("Payroll Attributes Usage")
                {
                    Image = Components;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = page "Payroll Attributes Usage";
                    RunPageLink = "Employee Code" = field("No.");
                    ToolTip = 'Executes the Payroll Attributes Usage action.';
                    ApplicationArea = All;
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Ledger E&ntries';
                    Image = VendorLedger;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = page "Employee Ledger Entries";
                    RunPageLink = "Employee No." = field("No.");
                    RunPageView = sorting("Employee No.")
                                  order(descending);
                    ShortcutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
                action("Training History")
                {
                    Image = AllLines;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page "List of Training by Employee";
                    RunPageLink = "Employee Code" = field("No."),
                                  Type = const(Trainee);
                    RunPageMode = View;
                    ToolTip = 'Executes the Training History action.';
                    ApplicationArea = All;
                }
                action("Training Given")
                {
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page "List of Training by Employee";
                    RunPageLink = "Employee Code" = field("No."),
                                  Type = const(Trainer);
                    RunPageMode = View;
                    ToolTip = 'Executes the Training Given action.';
                    ApplicationArea = All;
                }
                action("Access Control")
                {
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = false;
                    ToolTip = 'Executes the Access Control action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.OpenGrantAccessControl(Rec."No.");
                    end;
                }
                action("Transfer History")
                {
                    Image = History;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Transfer History action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PageTransferHistory: Page "Employee Transfer Requests";
                    begin
                        EmployeeAct.Reset;
                        Rec.FilterGroup(2);
                        EmployeeAct.SetFilter(Type, '%1|%2', EmployeeAct.Type::"HR Transfer", EmployeeAct.Type::"Employee Transfer");
                        EmployeeAct.SetRange("Employee No.", Rec."No.");
                        EmployeeAct.SetFilter("Approval Status", '%1|%2', EmployeeAct."Approval Status"::Acknowledged, EmployeeAct."Approval Status"::Approved); //Min -- Approved filter added.
                        Rec.FilterGroup(0);
                        Clear(PageTransferHistory);
                        PageTransferHistory.ForHistoryPage;
                        PageTransferHistory.SetTableView(EmployeeAct);
                        PageTransferHistory.SetRecord(EmployeeAct);
                        PageTransferHistory.Run;
                    end;
                }
                action("Access Control History")
                {
                    Image = History;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page "Access Control History";
                    RunPageLink = "Employee No." = field("No.");
                    RunPageMode = View;
                    RunPageView = where(Status = const(approved));
                    ToolTip = 'Executes the Access Control History action.';
                    ApplicationArea = All;
                }
                action(Attachments)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal;
                    end;
                }
                action("Show Leave Earn")
                {
                    Image = AbsenceCategory;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = page "Leave Earn";
                    RunPageLink = EmpNo = field("No.");
                    ToolTip = 'Executes the Show Leave Earn action.';
                    ApplicationArea = All;
                }
                action("Promotion History")
                {
                    Image = Production;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page "Promotion History";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Executes the Promotion History action.';
                    ApplicationArea = All;
                }
                action("Service History")
                {
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Service History action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ServiceHistory.Reset;
                        ServiceHistory.FilterGroup(2);
                        ServiceHistory.SetRange("Employee No.", Rec."No.");
                        ServiceHistory.FilterGroup(0);
                        Page.Run(Page::"Service History Lists", ServiceHistory);
                    end;
                }
                action("Export Service History")
                {
                    Image = ExportToExcel;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Export Service History action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        /*ServiceHistory.RESET;
                        ServiceHistory.SETRANGE("Employee No.","No.");
                        REPORT.RUN(REPORT::Report60136,TRUE,FALSE,ServiceHistory);*/
                    end;
                }
            }
            group("Update Information")
            {
                action(Save)
                {
                    Image = Save;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Save action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CheckEmployee;
                        if not CheckForLeaveEarnExist then begin
                            if Rec."Employment Type" = Rec."Employment Type"::Contract then
                                LeaveMgt.UpdateLeaveEmployeeContract(Rec."No.", Rec."Employment Date", Rec."Employment Type", Rec.Gender, Rec."Marital Status")
                            else if Rec."Employment Type" in [Rec."Employment Type"::Permanent, Rec."Employment Type"::Probation] then
                                LeaveMgt.UpdateLeaveEmployee(Rec."No.", Rec."Employment Date", Rec."Employment Type", Rec.Gender, Rec."Marital Status");

                        end;
                        //PayrollEngine.InsertPayrollAttributesUsage("No.");
                        Rec.Saved := true;
                        Rec.Modify;
                        Message('Saved');
                    end;
                }
                action("Resignation Email Submit")
                {
                    Image = Save;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = false;
                    ToolTip = 'Executes the Resignation Email Submit action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgmt.ResignationEmailSend(Rec."No.");
                        Message('Email Send.');
                    end;
                }
                action("Assign Job Function")
                {
                    Image = AddWatch;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Assign Job Function action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to assign job function?', false) then
                            HRMgt.PopUpForJobAssignment(Rec);
                    end;
                }
                action("Appointment Job Function")
                {
                    Image = Campaign;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Appointment Job Function action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        AppointmentOfEmployee: Report "Formation of Department/Branch";
                    begin
                        if Confirm('Do you want to appoint job function?', false) then begin
                            Clear(AppointmentOfEmployee);
                            AppointmentOfEmployee.SetAppointment(Rec."No.");
                            AppointmentOfEmployee.Run;
                        end;
                    end;
                }
                action("Add Job Function")
                {
                    Image = Insert;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Add Job Function action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to add job function?', false) then
                            HRMgt.PopUpForJobAddition(Rec);
                    end;
                }
                action("Contract Renew")
                {
                    Image = ContactReference;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Contract Renew action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to renew the contract?', false) then
                            HRMgt.PopUpForContractRenew(Rec);
                    end;
                }
                action("Generate New Employee Card")
                {
                    ApplicationArea = Basic, Suite;
                    Image = Archive;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Generate New Employee Card action.';

                    trigger OnAction()
                    begin
                        if not Confirm('Do you want to create new employee card?', false) then
                            exit;
                        Employee.GenerateNewEmployeeCard(Rec);
                    end;
                }
                action("Permsission Needed Leave")
                {
                    Image = PreviewChecks;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Permsission Needed Leave action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to grant HR permission Leave for this employee?', false) then begin
                            CurrPage.SetSelectionFilter(Rec);
                            Report.Run(Report::"Grant Permission Needed Leave", true, false, Rec);
                        end;
                    end;
                }
                action("Promote Employee")
                {
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Promote Employee action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to promote employee %1 ?', false, Rec."Full Name") then
                            HRMgt.UpdatePromotion(Rec."No.");
                    end;
                }
                action(UpdatePRAttributes)
                {
                    Caption = 'Update Payroll Att Usage';
                    Image = UpdateDescription;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    Visible = false;
                    ToolTip = 'Executes the Update Payroll Att Usage action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(Rec);
                        Report.Run(50001, true, false, Rec);
                    end;
                }
                action("Insert Payroll Attributes")
                {
                    Image = AddContacts;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Insert Payroll Attributes action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to update payroll attributes usage ?', false) then
                            PayrollEngine.InsertPayrollAttributes;
                    end;
                }
                action("Confirmation Employee")
                {
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Confirmation Employee action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Employee.Reset;
                        Employee.SetRange("No.", Rec."No.");
                        Employee.FindFirst;
                        Employee.TestField("Employment Type", Rec."Employment Type"::Probation);
                        Report.Run(Report::"Generate Leave Balance", true, false, Employee);
                    end;
                }
                action("Update Loan Details")
                {
                    Image = UpdateXML;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Update Loan Details action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Employee.Reset;
                        Employee.SetRange("No.", Rec."No.");
                        if Employee.FindFirst then
                            Report.RunModal(Report::"Emp Loan Outstanding Update", true, false, Employee);
                    end;
                }
                action("Generate Leave Balance")
                {
                    Image = GiroPlus;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Generate Leave Balance action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Employee.Reset;
                        Employee.SetRange("No.", Rec."No.");
                        Report.RunModal(60014, true, false, Employee);
                    end;
                }
                action("Leave Earn (Contract)")
                {
                    Image = EditFilter;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Leave Earn (Contract) action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        LeaveMgt.CreateLeaveEarnContract(Rec);
                    end;
                }
                action("Insert Mandatory Attachments")
                {
                    Image = Insert;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Insert Mandatory Attachments action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        InsertAttachmentLines(Rec)
                    end;
                }
                action("Upate Employment Date")
                {
                    Image = UpdateUnitCost;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = false;
                    ToolTip = 'Executes the Upate Employment Date action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if not Confirm('Do you want to upate employment date?', false) then
                            exit;
                        HRMgt.UpdateEmploymentDate(Rec."No.");
                    end;
                }
            }
            separator(Separator151) { }
            action("Employee Experience Letter")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Fieldvisible;
                ToolTip = 'Executes the Employee Experience Letter action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    EmployeeAct.Reset;
                    EmployeeAct.SetRange("Employee No.", Rec."No.");
                    EmployeeAct.SetRange(Type, EmployeeAct.Type::Resignation);
                    EmployeeAct.SetRange("Approval Status", EmployeeAct."Approval Status"::Settled);
                    if EmployeeAct.FindFirst then begin
                        Employee.Reset;
                        Employee.SetRange("No.", Rec."No.");
                        if Employee.FindFirst then begin
                            Employee.TestField(Salutation);
                            Report.Run(70022, true, true, Employee);
                        end;
                    end;
                end;
            }
            action("Resignation Acceptance Letter")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Fieldvisible1;
                ToolTip = 'Executes the Resignation Acceptance Letter action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    EmployeeAct.Reset;
                    EmployeeAct.SetRange(Type, EmployeeAct.Type::Resignation);
                    EmployeeAct.SetRange("Employee No.", Rec."No.");
                    if EmployeeAct.FindLast then
                        EmployeeAct.TestField("Approval Status", EmployeeAct."Approval Status"::Approved);

                    Employee.Reset;
                    Employee.SetRange("No.", Rec."No.");
                    if Employee.FindFirst then begin
                        Employee.TestField(Salutation);
                        Report.Run(70023, true, true, Employee);
                    end;
                end;
            }
            action("Resignation Release Letter")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Fieldvisible;
                ToolTip = 'Executes the Resignation Release Letter action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Employee.Reset;
                    Employee.SetRange("No.", Rec."No.");
                    if Employee.FindFirst then begin
                        Employee.TestField(Salutation);
                        EmployeeAct.Reset;
                        EmployeeAct.SetRange(Type, EmployeeAct.Type::Resignation);
                        EmployeeAct.SetRange("Employee No.", Employee."No.");
                        if EmployeeAct.FindLast then
                            EmployeeAct.TestField("Approval Status", EmployeeAct."Approval Status"::Settled);
                        Report.Run(70024, true, true, Employee);
                    end;
                end;
            }
            action(Memo)
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Memo action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Employee.Reset;
                    Employee.SetRange("No.", Rec."No.");
                    if Employee.FindFirst then begin
                        Employee.TestField(Salutation);
                        Report.Run(70026, true, true, Employee);
                    end;
                end;
            }
            action("Insert Grade")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "Insert Grade";
                Visible = false;
                ToolTip = 'Executes the Insert Grade action.';
                ApplicationArea = All;
            }
            action("Change Job Position")
            {
                Image = Change;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                ToolTip = 'Executes the Change Job Position action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*IF CONFIRM(ConfirmMessage) THEN BEGIN //Min -- for change Job Position.
                      IF (Rec."New Employee") AND ("Employment Type" IN ["Employment Type"::Probation,"Employment Type"::Contract]) THEN
                        HRMgt.PopUpChangingJobPositionEmployee(Rec)
                      ELSE
                        ERROR(ErrorMessage);
                    END;*/
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
        //SetFieldEnable;
        //CALCFIELDS("Lump Sum CIT");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        PGSetup.Get;
        PGSetup.TestField("Default Work Shift");
        Rec.Validate("Employee Work Shift", PGSetup."Default Work Shift");
    end;

    trigger OnOpenPage()
    begin
        SetNoFieldVisible;
        IsCountyVisible := FormatAddress.UseCounty(Rec."Country/Region Code");
        Usersetup.Get(UserId);
        PayrollFieldsVisible := Usersetup."Can View Payroll Fields";

        SetFieldEnable;

        //>>updating date
        if Rec."Birth Date" <> 0D then begin
            Rec.Age := Round((Today - Rec."Birth Date") / 365.4, 1, '<');
            Rec.Modify;
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // if not Rec.Saved then
        //     Error('Employee Card must be saved first');
    end;

    var
        FormatAddress: Codeunit "Format Address";
        NoFieldVisible: Boolean;
        IsCountyVisible: Boolean;
        Usersetup: Record "User Setup";
        [InDataSet]
        PayrollFieldsVisible: Boolean;
        Employee: Record Employee;
        EmployeeAct: Record "Employee Activity";
        LoanMgt: Codeunit "Loan Mgt.";
        Type: Option " ","Salary Advance","Personal Loan","Home Loan","Vehicle Loan";
        AppraisalRec: Record Appraisal;
        Fieldvisible: Boolean;
        Fieldvisible1: Boolean;
        HRMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";
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
        HRMgmt: Codeunit "HR Mgt.";

 
    local procedure SetNoFieldVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        NoFieldVisible := DocumentNoVisibility.EmployeeNoIsVisible;
        EmployeeAct.Reset;
        EmployeeAct.SetRange("Employee No.", Rec."No.");
        EmployeeAct.SetRange(Type, EmployeeAct.Type::Resignation);
        EmployeeAct.SetRange("Approval Status", EmployeeAct."Approval Status"::Settled);
        if EmployeeAct.FindFirst then
            Fieldvisible := true
        else
            Fieldvisible := false;

        EmployeeAct.Reset;
        EmployeeAct.SetRange("Employee No.", Rec."No.");
        EmployeeAct.SetRange(Type, EmployeeAct.Type::Resignation);
        EmployeeAct.SetRange("Approval Status", EmployeeAct."Approval Status"::Approved);
        if EmployeeAct.FindFirst then
            Fieldvisible1 := true
        else
            Fieldvisible1 := false;
    end;

    local procedure InsertAttachmentLines(var Emp: Record Employee)
    var
        IncomingDocument: Record "Incoming Document";
        AttachmentMandatory: Record "Attachment Setup";
    begin
        AttachmentMandatory.Reset;
        AttachmentMandatory.SetFilter(Type, '%1|%2|%3|%4', AttachmentMandatory.Type::Education,
                  AttachmentMandatory.Type::"Employee Profile", AttachmentMandatory.Type::"Work Experience",
                  AttachmentMandatory.Type::"Complaince Requirement Forms");
        if AttachmentMandatory.FindFirst then
            repeat
                IncomingDocument.Reset;
                IncomingDocument.SetRange("Order No.", Emp."No.");
                IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
                if not IncomingDocument.FindFirst then begin
                    IncomingDocument.Reset;
                    IncomingDocument.Init;
                    IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
                    IncomingDocument.Description := Emp.TableName;
                    IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
                    //IncomingDocument."Order No." := Emp."No.";
                    IncomingDocument."Order No." := Format(Emp."No.");
                    IncomingDocument."Employee Code" := Format(Emp."No.");
                    IncomingDocument.Insert(true);
                end;
            until AttachmentMandatory.Next = 0;
    end;

    local procedure SetFieldEnable()
    begin
        case Rec."Deputation on" of
            Rec."Deputation on"::"Extension Counter":
                begin
                    BranchEditable := false;
                    ProvinceEditable := false;
                    SubProvinceEditable := false;
                    ExtensionCounterEditable := true;
                    UnitEditable := false;
                    DepartmentEditable := false;
                end;
            Rec."Deputation on"::Branch:
                begin
                    BranchEditable := true;
                    ProvinceEditable := false;
                    SubProvinceEditable := false;
                    ExtensionCounterEditable := false;
                    UnitEditable := false;
                    DepartmentEditable := false;
                end;
            Rec."Deputation on"::Province:
                begin
                    BranchEditable := false;
                    ProvinceEditable := true;
                    SubProvinceEditable := false;
                    ExtensionCounterEditable := false;
                    UnitEditable := false;
                    DepartmentEditable := false;
                end;
            Rec."Deputation on"::"Sub Province":
                begin
                    BranchEditable := false;
                    ProvinceEditable := false;
                    SubProvinceEditable := true;
                    ExtensionCounterEditable := false;
                    UnitEditable := false;
                    DepartmentEditable := false;
                end;
            Rec."Deputation on"::Unit, Rec."Deputation on"::Department:
                begin
                    BranchEditable := false;
                    ProvinceEditable := false;
                    SubProvinceEditable := false;
                    ExtensionCounterEditable := false;
                    UnitEditable := true;
                    DepartmentEditable := true;
                end;
        end;
    end;

    local procedure CheckEmployee()
    begin
        /*IF NOT (Status = Status::Active) THEN
          EXIT;*///Min 1.1 commented for only control apply for new creation employee
        if Rec."New Employee" then begin //Min 1.2
            Rec.TestField("Full Name");
            Rec.TestField("Deputation on");
            Rec.TestField("Salary Level");
            Rec.TestField("Salary Grade");
            Rec.TestField(Gender);
            Rec.TestField("Marital Status");
            Rec.TestField("Employment Type");
            Rec.TestField("NAV Login ID");
            Rec.TestField("Functional Title");
            Rec.TestField("Employment Date");
            //TESTFIELD("Tax Code");
            Rec.TestField("Inside/Outisde Valley");
            Rec.TestField("Posting Region");
            Rec.TestField("Date of Birth (B.S.)"); //Min <<
            Rec.TestField("PAN No.");
            Rec.TestField("Citizen Number");//Min >>
            if Rec."Employment Type" = Rec."Employment Type"::Permanent then
                Rec.TestField("Confirmation Date");
            if Rec."Employment Type" = Rec."Employment Type"::Contract then
                Rec.TestField("Contract Salary Amount");
            if Rec."Employment Type" = Rec."Employment Type"::Probation then //Min
                Rec.TestField("Probation Period");
            if Rec."Employment Type" = Rec."Employment Type"::Contract then begin
                Rec.TestField("Contract Expiry Month");
            end;

            case Rec."Deputation on" of
                Rec."Deputation on"::Branch:
                    begin
                        Rec.TestField("Branch Name");
                        Rec.TestField("Global Dimension 1 Code");
                        Rec.TestField("Province Code");
                        Rec.TestField("Sub Province Code");
                    end;

                Rec."Deputation on"::Department:
                    begin
                        Rec.TestField("Department Code");
                        Rec.TestField("Department Name");
                    end;

                Rec."Deputation on"::"Extension Counter":
                    begin
                        Rec.TestField("Extension Counter Code");
                        Rec.TestField("Extension Counter Name");
                        Rec.TestField("Global Dimension 1 Code");
                        Rec.TestField("Province Code");
                        Rec.TestField("Sub Province Code");
                    end;

                Rec."Deputation on"::Province:
                    begin
                        Rec.TestField("Province Code");
                        Rec.TestField("Province Name");
                    end;

                Rec."Deputation on"::"Sub Province":
                    begin
                        Rec.TestField("Province Code");
                        Rec.TestField("Sub Province Code");
                        Rec.TestField("Sub Province Name");
                    end;

                Rec."Deputation on"::Unit:
                    begin
                        Rec.TestField("Unit Code");
                        Rec.TestField("Unit Name");
                    end;
            end;
        end;
    end;

    local procedure CheckForLeaveEarnExist(): Boolean
    var
        LeaveEarn: Record "Leave Earn";
    begin
        LeaveEarn.Reset;
        LeaveEarn.SetRange(EmpNo, Rec."No.");
        if LeaveEarn.FindFirst then
            exit(true);
    end;
}
