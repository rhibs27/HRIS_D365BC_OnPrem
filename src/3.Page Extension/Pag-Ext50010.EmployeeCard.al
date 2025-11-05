pageextension 50010 "Employee Card" extends "Employee Card"
{
    PromotedActionCategories = 'New,Process,Report,,Loan,History,Others';
    layout
    {
        modify("No.")
        {
            Editable = false;
            Caption = 'Employee No.';
        }
        modify(Address)
        {
            Editable = false;
        }
        modify("Address 2")
        {
            Caption = 'Temporary Address';
            Editable = false;
            Visible = false;
        }
        movebefore(Gender; "Birth Date")
        modify("Birth Date")
        {
            Caption = 'Date of Birth (A.D.)';
        }
        modify("Union Membership No.")
        {
            visible = false;
        }
        modify(Initials)
        {
            visible = false;
        }
        modify(Personal)
        {
            Visible = false;
        }
        modify("Balance (LCY)")
        {
            visible = false;
        }
        modify("Search Name")
        {
            visible = false;
        }
        // modify("Employment Date")
        // {
        //    Editable = false;
        // }
        modify("Application Method")

        {
            Visible = false;
        }
        modify("Employee Posting Group")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify(IBAN)
        {
            Visible = false;
        }
        modify("SWIFT Code")
        {
            Visible = false;
        }
        modify(Control1905767507)
        {
            Visible = false;
        }
        modify("Alt. Address Code")
        {
            Visible = false;
        }
        modify("Alt. Address End Date")
        {
            Visible = false;
        }
        modify("Alt. Address Start Date")
        {
            Visible = false;
        }
        modify("ShowMap")
        {
            Visible = false;
        }
        modify("Resource No.")
        {
            Visible = false;
        }
        modify("Salespers./Purch. Code")
        {
            Visible = false;
        }
        modify(Pager)
        {
            Visible = false;
        }
        modify("Phone No.")
        { Visible = false; }
        // modify("Country/Region Code")
        // {
        //     Editable = false;
        // }
        modify("Post Code")
        {
            Editable = false;
        }
        modify("Job Title")
        { visible = false; }
        moveafter("Country/Region Code"; "Company E-Mail", "Phone No.2", "Phone No.")

        addafter(Address)
        {
            field("Temporary Address"; Rec."Temporary Address")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Temporary Address field.';
            }
            field("Distance between Residence and Office"; Rec."Distance betwn Res and Office")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Distance between Residence and Office field.';

            }
        }
        addbefore("First Name")
        {
            field(Salutation; Rec.Salutation)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Salutation field.';

            }
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
            // field("Mobile No."; Rec."Mobile No.")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Mobile No. field.';

            // }

            field("Date of Birth (B.S.)"; Rec."Date of Birth (B.S.)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Date of Birth (B.S.) field.';

            }
            field(Age; Rec.Age)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Age field.';
                Editable = false;

            }
            field("Age Text"; Rec."Age Text")
            {
                Caption = 'Age';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Age Text field.';
                Editable = false;


            }
            field("CIF ID"; Rec."CIF ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CIF ID field.';
                Visible = false;

            }
            field("Marital Status"; Rec."Marital Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Marital Status field.';

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
                Visible = false;

            }
            field("Old Employee ID (Regular)"; Rec."Old Employee ID (Regular)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Old Employee ID (Regular) field.';
                Visible = false;
            }
            field("Tax Code"; Rec."Tax Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tax Code field.';

            }
            field("Do not Calculate Salary"; Rec."Do not Calculate Salary")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Do not Calculate Salary field.', Comment = '%';
            }
            field(Disabled; Rec.Disabled)
            {
                ApplicationArea = All;
                Caption = 'Differently Able';
                ToolTip = 'Specifies the value of the Differently Able field.';

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
                Visible = false;
            }
            field("Mother Tongue"; Rec."Mother Tongue")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mother Tongue field.';
            }
            field("Religion"; Rec.Religion)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Religion field.';
            }
            field(Community; Rec.Community)
            {
                ApplicationArea = all;
            }
            field("Automatic Attendance"; Rec."Automatic Attendance")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Automatic Attendance field.', Comment = '%';
            }
            field("Identity Mark"; Rec."Identity Mark")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Identity Mark field.', Comment = '%';
            }

        }
        addafter(General)
        {
            group("Identification Details")
            {
                group("Citizenship Details")
                {
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
                    field("Citizenship Issue Date"; Rec."Citizenship Issue Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Citizenship Issue Date field.';

                    }
                }
                group(cardcontrol001)
                {
                    ShowCaption = false;
                    group("Passport Details")
                    {
                        field("Passport Number"; Rec."Passport Number")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Passport Number field.';

                        }
                        field("Passport Validity Date"; Rec."Passport Validity Date")
                        {
                            ApplicationArea = all;
                        }
                    }
                    group(Others)
                    {
                        field("NID No"; Rec."NID No")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the National Identity Number field.';
                        }
                        field("Driving License No."; Rec."Driving License No.")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Driving License Number field.';
                        }
                        field("Digital Signature"; Rec."Digital Signature")
                        {
                            ApplicationArea = All;
                            visible = false;
                        }

                    }
                }

            }
        }
        addlast("Address & Contact")
        {

            group("Permanent Address")
            {
                field("Permanent Province"; Rec."Permanent Province")
                {
                    Caption = 'Province';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Permanent Province field.';

                }
                field("Permanent District"; Rec."Permanent District")
                {
                    Caption = 'District';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Permanent District field.';

                }

                field("Permanent VDC"; Rec."Permanent VDC")
                {
                    Caption = 'VDC (Rural-Municipality)/ Municipality/ Metropolitan city';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Permanent VDC field.';

                }
                field("Permanent Locality"; Rec."Permanent Locality")
                {
                    Caption = 'Locality';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Permanent Locality.';

                }
                field("Permanent House"; Rec."Permanent House")
                {
                    Caption = 'House No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Permanent House field.';

                }
                field("Ward No"; Rec."Permanent Ward No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ward No field.';

                }
            }
            group("Temporary Address Group")
            {
                Caption = 'Temporary Address';
                field("Same As Permanent"; SameAsPermanent)
                {
                    Editable = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if SameAsPermanent then
                            CopyPermanentAddress()
                        else
                            ClearTemporaryAddress();
                    end;
                }
                field("Temporary Province"; Rec."Temporary Province")
                {
                    Caption = 'Province';
                    Editable = not SameAsPermanent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Temporary Province field.';

                }
                field("Temporary District"; Rec."Temporary District")
                {
                    Caption = 'District';
                    Editable = not SameAsPermanent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Temporary District field.';

                }
                field("Temporary VDC"; Rec."Temporary VDC")
                {
                    Caption = 'VDC (Rural-Municipality)/ Municipality/ Metropolitan city';
                    Editable = not SameAsPermanent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Temporary VDC field.';

                }
                field("Temporary Locality"; Rec."Temporary Locality")
                {
                    Caption = 'Locality';
                    Editable = not SameAsPermanent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Temporary Locality.';

                }
                field("Temporary House"; Rec."Temporary House")
                {
                    Caption = 'House No.';
                    Editable = not SameAsPermanent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Temporary House field.';

                }
                field("Temporary Ward No"; Rec."Temporary Ward No")
                {
                    Caption = 'Ward No.';
                    Editable = not SameAsPermanent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Temporary Ward No field.';

                }

            }
            group("Emergency Contact Details")
            {
                Editable = false;
                field("Relation With Emergency Cont"; Rec."Relation With Emergency Cont")
                {
                    Caption = 'Relation';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Relation With Emergency Cont field.';
                }
                field("Emergency Cont. Name"; Rec."Emergency Contact Name")
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Relation With Emergency Cont. Name field.';
                }
                field("Emergency Mobile No."; Rec."Emergency Mobile No.")
                {
                    Caption = 'Mobile No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Emergency Mobile No. field.';
                }
                field("Emergency Cont. Email"; Rec."Emergency Contact Email")
                {
                    Caption = 'E-mail';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Relation With Emergency Cont. Email field.';
                }

            }
            group("Nominee Contact Details")
            {
                Editable = false;

                field("Relation With Nominee"; Rec."Relation With Nominee")
                {
                    Caption = 'Relation';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Relation With Nominee field.';
                }

                field("Nominee Name"; Rec."Nominee Name")
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nominee Name field.';
                }

                field("Nominee Mobile No."; Rec."Nominee Mobile No.")
                {
                    Caption = 'Mobile No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nominee Mobile No. field.';
                }

                field("Nominee Email"; Rec."Nominee Email")
                {
                    Caption = 'E-mail';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nominee Email field.';
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
                    Editable = True;
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
                field("Staff Type"; Rec."Staff level")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Staff Type field.';
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
                field("Contract Expiry Date"; Rec."Contract Expiry Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Expiry Date field.';
                }
                field("Contract Expiry Month"; Rec."Contract Expiry Month")
                {
                    ApplicationArea = All;
                    Editable = Rec."Employment Type" = rec."Employment Type"::Contract;
                    ToolTip = 'Specifies the value of the Contract Expiry Month field.';
                }
                field("Deputation on"; Rec."Deputation on")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Deputation on field.';
                    trigger OnValidate()
                    begin
                        SetFieldEnable;
                    end;

                }
                field("Deputation On Code"; Rec."Deputation On Code")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Province Code"; Rec."Province Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Province Code field.';

                }
                field("Province Name"; Rec."Province Name")
                {
                    Visible = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Province Name field.';
                }

                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    // Editable = BranchEdit;
                    // Enabled = BranchVisible;
                    // Enabled = false;
                    ToolTip = 'Specifies the value of the Branch Code field.';

                }
                field("Branch Name"; Rec."Branch Name")
                {
                    Enabled = BranchVisible;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Name field.';

                }
                field("Extension Counter Code"; Rec."Extension Counter Code")
                {
                    ApplicationArea = All;
                    // Editable = ExtensionCounterEdit;
                    // Enabled = ExtensionCounterVisible;
                    ToolTip = 'Specifies the value of the Extension Counter Code field.';

                }
                field("Extension Counter Name"; Rec."Extension Counter Name")
                {
                    Enabled = ExtensionCounterVisible;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Extension Counter Name field.';
                }
                field("Sub Unit Code"; Rec."Sub Unit Code")
                {
                    //Enabled = Rec."Deputation on" = Rec."Deputation on"::Branch;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sub Unit Code field.';
                    Visible = false;
                }
                field("Sub Unit Name"; Rec."Sub Unit Name")
                {
                    Enabled = Rec."Deputation on" = Rec."Deputation on"::Branch;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sub Unit Name field.';
                    Visible = false;
                }
                field("Department Code"; Rec."Department Code")
                {
                    // Editable = DepartmentEdit;
                    // Enabled = DepartmentVisible;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Code field.';

                }
                field("Department Name"; Rec."Department Name")
                {
                    Enabled = DepartmentVisible;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Name field.';

                }
                field("Unit Code"; Rec."Unit Code")
                {
                    // Editable = UnitEdit;
                    // Enabled = UnitVisible;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Code field.';

                }
                field("Unit Name"; Rec."Unit Name")
                {
                    Enabled = UnitVisible;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Name field.';

                }
                // field(Cluster; Rec.Cluster)
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Cluster field.';

                // }
                field("Inside/Outside Valley"; Rec."Inside/Outside Valley")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inside/Outside Valley field.';

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
                field("Promotion Date (B.S.)"; Rec."Promotion Date (B.S.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Promotion Date (B.S) field.';

                }
                field("Resignation Date"; Rec."Resignation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Resignation Date field.';

                }
                field("Resignation Date (B.S.)"; Rec."Resignation Date (B.S.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Resignation Date (B.S.) field.';

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
                field("Trainee Period"; Rec."Trainee Period")
                {
                    ApplicationArea = All;
                }
                field("Trainee/Probation End date"; Rec."Trainee/Probation End date")
                {
                    ApplicationArea = All;
                }
                field("Gratuity Number"; Rec."Gratuity Number")
                {
                    ApplicationArea = all;
                }
                field("Last Placement Date"; Rec."Last Placement Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Placement Date field.';

                }
                // field("Approver Code"; Rec."Approver Code")
                // {
                //     Visible = false;
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Approver Code field.';
                // }
                field("Approver Role"; Rec."Approver Role")
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
                field("Citizenship Issue Date(B.S.)"; Rec."Citizenship Date (B.S.)")
                {
                    Caption = 'Citizenship Issue Date(B.S.)';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Citizenship Issue Date(B.S.) field.';
                }

            }
            group(Permission)
            {
                field("Disable Punch in"; Rec."Disable Punch in")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disable Punch in field.';
                }
                field("Portal Attendance"; Rec."Portal Attendance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Portal Attendance field.';

                }
                field("Resignation Approver"; Rec."Resignation Approver")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Resignation Approver field.';
                }
                field("Attendance Device ID"; Rec."Attendance Device ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Attendance Device ID field.';
                }
                field("Employee Attendance ID"; Rec."Employee Attendance ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Attendance ID field.';

                }
                field("Manual Approver User"; Rec."Manual Approver User")
                {
                    ApplicationArea = All;
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
            field("Confirmation Date (B.S.)"; Rec."Confirmation Date (B.S.)")
            {
                ApplicationArea = All;
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
            // field("CIT Office Cont. Deduction"; Rec."CIT Office Cont. Deduction")
            // {
            //     ApplicationArea = All;
            //     Caption = 'CIT Deduction Amount';
            //     ToolTip = 'Specifies the value of the CIT Deduction Amount field.';

            // }
            field("PF No."; Rec."PF No.")
            {
                ApplicationArea = All;
                Caption = 'PF Account Number';
                ToolTip = 'Specifies the value of the PF Account Number field.';

            }
            field("PF Contribution"; Rec."PF Contribution")
            {
                Visible = false;
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
        addbefore("Employment Date")
        {
            field("Appointment Date"; Rec."Appointment Letter Date")
            {
                ApplicationArea = all;
            }
            Field("Appointment Date (B.S.)"; Rec."Appointment Letter Date (B.S.)")
            {
                ApplicationArea = all;
            }
        }
        addafter(Payments)
        {
            group(Payrolls)
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
                Visible = false;
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
            // part(PayrollAttributesUsage; "Payroll Attributes Usage")
            // {
            //     ApplicationArea = All;
            //     SubPageView = WHERE(Subtype = FILTER("Employer Contribution" | "Employee Contribution" | CIT | "Lump Sum Contribution" | RF),
            //                       Type = CONST(Deduction));
            //     SubPageLink = "Employee Code" = FIELD("No.");

            // }
            // part(AccessControlSubform; "Access Control Subform")
            // {
            //     ApplicationArea = All;
            //     SubPageLink = Type = CONST(Employee), Code = FIELD("No.");
            //     Editable = false;
            // }
            // part(AttachmentSubform; "Attachment Subform")
            // {
            //     Caption = 'Attachments';
            //     SubPageLink = "Order No." = FIELD("No.");
            //     ApplicationArea = All;

            // }
            // part(LoanOutstandingSubform; "Loan Outstanding Subform")
            // {
            //     ApplicationArea = All;
            //     SubPageLink = "Employee No." = FIELD("No.");

            // }
            // part(EmployeeLeaveDays; "Employee Leave Days")
            // {
            //     Editable = false;
            //     ApplicationArea = All;
            //     //SubPageLink =
            //     SubPageView = WHERE("Remaining Days" = FILTER(> 0));
            //     SubPageLink = "Employee No. Filter" = FIELD("No.");
            // }
        }
        moveafter(Control3; "Attached Documents")

        addafter(Control1905767507)
        {
            part(EmployeeLeaveDays; "Employee Leave Days")
            {
                ApplicationArea = all;
                Editable = false;
                SubPageView = WHERE("Remaining Days" = FILTER(> 0));
                SubPageLink = "Employee No. Filter" = FIELD("No.");
            }
        }
        addafter("Employment Date")
        {
            field("Employment Date (B.S.)"; Rec."Employment Date (B.S.)")
            {
                ApplicationArea = All;
            }
            field("Service Period Text"; Rec."Service Period Text")
            {
                caption = 'Service Period';
                ApplicationArea = all;
                Editable = false;
            }
        }

    }
    actions
    {
        modify("Q&ualifications")
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify("Ledger E&ntries")
        {
            Promoted = true;
            PromotedCategory = Process;
        }

        modify(Dimensions)
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify(Attachments)
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify("&Relatives")
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify("&Picture")
        {
            Visible = false;
        }
        modify("Sent Emails")
        {
            Visible = false;
        }
        modify(Contact)
        {
            Visible = false;
        }
        modify(Email)
        {
            Visible = false;
        }
        modify(AlternativeAddresses)
        {
            Visible = false;
        }
        modify("Co&mments")
        {
            Visible = false;
        }
        modify("&Confidential Information")
        {
            Visible = false;
        }
        modify("A&bsences")
        {
            Visible = false;
        }
        modify("Mi&sc. Article Information")
        {
            Visible = false;
        }
        modify("Misc. Articles &Overview")
        {
            Visible = false;
        }
        modify("Absences by Ca&tegories")
        {
            Visible = false;
        }
        modify("Co&nfidential Info. Overview")
        {
            Visible = false;
        }

        addafter("Co&nfidential Info. Overview")
        {
            action("Employee Bank Account")
            {
                ApplicationArea = all;
                ToolTip = 'view Employee Bank account list';
                RunObject = page "Employee Bank Account Lists";
                RunPageLink = "Employee No." = FIELD("No.");
                Promoted = true;
                Image = Bank;
                PromotedCategory = Process;
            }
            action("Service Inactivity Details")
            {
                ApplicationArea = all;
                Tooltip = 'view Service Inactivity Details';
                RunObject = page "Service Inactivity Details";
                RunPageLink = "Employee No." = Field("No.");
                promoted = true;
                image = ServiceLedger;
                PromotedCategory = Process;
            }
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
            action("Permission Needed Leave")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PreviewChecks;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Permission Needed Leave action.';

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to grant HR permission Leave for this employee?', FALSE) THEN begin
                        CurrPage.SETSELECTIONFILTER(Rec);
                        REPORT.RUN(REPORT::"Grant Permission Needed Leave", TRUE, FALSE, Rec);
                    end;
                end;
            }
            action("Generate New Employee Card")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Archive;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Generate New Employee Card action.';
                Visible = false;

                trigger OnAction()
                begin
                    IF NOT CONFIRM('Do you want to create new employee card?', FALSE) THEN
                        EXIT;
                    Employee.GenerateNewEmployeeCard(Rec);
                end;
            }
            action("Language Proficiency")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Language Proficiency';
                Image = Language;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Language Proficiency";
                RunPageLink = "Employee Code" = field("No.");
                ToolTip = 'Open the list of Language Proficiency of the employee.';
            }
            action(References)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'References';
                Image = Relationship;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page References;
                RunPageLink = "Employee Code" = field("No.");
                ToolTip = 'Open the list of References of the employee.';
            }
            action(Insurance)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Insurance';
                Image = Insurance;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Employee Insurance Lists";
                RunPageLink = "Employee No." = field("No.");
                ToolTip = 'Open the list of insurances of the employee.';
            }
            action("Employee Work Experience")
            {
                ApplicationArea = All;
                Caption = 'Work Experience';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Employee Work Qualification";
                RunPageLink = "Employee No." = field("No."), "Emp Qualification Type" = filter(Work | Achievement);
                Image = Certificate;
                ToolTip = 'Executes the Work Experience action.';
            }
            action("Payroll Attributes Usage")
            {
                ApplicationArea = All;
                RunObject = Page "Payroll Attributes Usage";
                RunPageLink = "Employee Code" = FIELD("No.");
                Promoted = true;
                PromotedIsBig = true;
                Image = Components;
                PromotedCategory = Process;
                ToolTip = 'Executes the Payroll Attributes Usage action.';
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
                action("Allowance Assignment")
                {
                    Image = ApplicationWorksheet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Allowance Assignment action.';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        AllowanceAssignmentMgt.OpenAllowanceRequest(Rec."No.");
                    end;
                }
                action("Allowance Assignment Claim")
                {
                    Image = ApplicationWorksheet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Allowance Assignment Claim action.';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        AllowanceAssignmentMgt.OpenAllowanceClaimRequest(Rec."No.");
                    end;
                }
                action("Request Allowance")
                {
                    Image = ApplicationWorksheet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Allowance Assignment Claim action.';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        FilterPageBuilder: FilterPageBuilder;
                        Allowanceconfig: Record "Assignment Memo Header";
                        AllowanceType: Code[20];
                        AssignmentMemoMgt: Codeunit "Assignment Memo Mgt";
                    begin
                        FilterPageBuilder.AddRecord('Select Allowance Type', Allowanceconfig);
                        FilterPageBuilder.ADdField('Select Allowance Type', Allowanceconfig."Payroll Attribute Code");
                        if FilterPageBuilder.RunModal then begin
                            Allowanceconfig.SetView(FilterPageBuilder.GetView('Select Allowance Type'));
                            if Allowanceconfig.GetFilter("Payroll Attribute Code") = '' then
                                Error('Allowance Type must have value');
                            AllowanceType := Allowanceconfig.GetFilter("Payroll Attribute Code");
                        end else
                            if AllowanceType = '' then
                                Error('Allowance Type must have value');

                        AssignmentMemoMgt.OpenAllowance(Rec."No.", AllowanceType);

                    end;
                }
                action("Allowance Assignment Memo")
                {
                    Image = ApplicationWorksheet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Allowance Assignment action.';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        AllowanceMemoMgt: Codeunit "Assignment Memo Mgt";
                    begin
                        AllowanceMemoMgt.OpenAllowanceRequestMemo(Rec."No.");
                    end;
                }
                action("Shift Assignment")
                {
                    Image = ApplicationWorksheet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Shift Assignment action.';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        ShiftAssignmentMgt.OpenShiftRequest(Rec."No.");
                    end;
                }
                action("Request Attendance Missed")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Absence;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Request Attendance Missed action.';
                    trigger OnAction()
                    begin
                        AttendanceMissedMgt.OpenAttendanceMissed(Rec."No.");
                    end;
                }
                action("Request Late Attendance")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Absence;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Late Attendance Request action.';
                    trigger OnAction()
                    begin
                        AttendanceMissedMgt.OpenLateAttendance(Rec."No.");
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
                    Visible = false;
                    ToolTip = 'Executes the Out of Office Forms action.';
                    trigger OnAction()
                    begin
                        Rec.OutOfOffice;
                        CurrPage.CLOSE
                    end;
                }
                action("Medical insurance Claim")
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
                        InsuranceMgt.OpenMedicalInsurancePage(Rec."No.");
                    end;
                }
                action("Employee Insurance")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = List;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the insurance action.';
                    trigger OnAction()
                    begin
                        InsuranceMgt.OpenEmployeeInsurance(Rec."No.");
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
                    Visible = false;
                    ToolTip = 'Executes the Bulk Cash action.';
                    trigger OnAction()
                    begin
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
                action("OT Bulk")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = PhysicalInventory;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the OT Form action.';
                    trigger OnAction()
                    var
                        OvertimeMgt: Codeunit "OverTime Mgt";
                    begin
                        OvertimeMgt.OpenOTBulk(Rec."No.");
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
                        Candidate.Reset();
                        Candidate.SetRange("No.", Rec."No.");
                        IF NOT Candidate.FindFirst() THEN begin
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
                        end;
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
                        AppraisalRec.Reset();
                        AppraisalRec.SetRange("Employee Code", Rec."No.");
                        IF NOT AppraisalRec.FindFirst() THEN begin
                            AppraisalRec.INIT;
                            AppraisalRec.VALIDATE("Employee Code", Rec."No.");
                            AppraisalRec.INSERT(TRUE);
                            PAGE.RUN(Page::"Appraisal Form Card", AppraisalRec);
                        END
                        ELSE
                            PAGE.RUN(Page::"Appraisal Form Card", AppraisalRec);
                    end;
                }
                action("Promote Employee")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Post;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Promote Employee action.';

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to promote employee %1 ?', FALSE, Rec."Full Name") THEN
                            HRMgt.UpdatePromotion(Rec."No.");
                    end;
                }

                action("Generate Leave Balance")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = GiroPlus;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Generate Leave Balance action.';
                    trigger OnAction()
                    begin
                        Employee.Reset();
                        Employee.SetRange("No.", Rec."No.");
                        Report.RunModal(Report::"Generate Leave Balance", true, false, Employee);
                    end;
                }
                action("Confirmation Employee")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Confirm;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Confirmation Employee action.';
                    trigger OnAction()
                    begin
                        Employee.Reset();
                        Employee.SetRange("No.", Rec."No.");
                        Employee.FindFirst();
                        Employee.TestField("Employment Type", Rec."Employment Type"::Probation);
                        REPORT.RUN(REPORT::"Generate Leave Balance", TRUE, FALSE, Employee);
                    end;
                }
                action("Request Retirement Fund")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Allocate;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Request Retirement Fund action.';
                    trigger OnAction()
                    begin
                        Rec.RFRequest;
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
                action("Update Loan Details")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = UpdateXML;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Update Loan Details action.';
                    Visible = false;
                    trigger OnAction()
                    begin
                        Employee.Reset();
                        Employee.SetRange("No.", Rec."No.");
                        IF Employee.FindFirst() THEN
                            REPORT.RUNMODAL(REPORT::"Emp Loan Outstanding Update", TRUE, FALSE, Employee);
                    end;
                }
            }
        }
        addafter("Request Home Loan")
        {
            group("Other Information")
            {
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
                // action("Access Control")
                // {
                //     ApplicationArea = All;
                //     Promoted = true;
                //     Visible = false;
                //     PromotedIsBig = true;
                //     Image = Register;
                //     PromotedCategory = Category6;
                //     PromotedOnly = true;
                //     ToolTip = 'Executes the Access Control action.';
                //     trigger OnAction()
                //     begin
                //         HRMgt.OpenGrantAccessControl(Rec."No.");
                //     end;
                // }
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
                        EmployeeTransfer: Record "Employee Transfer";
                    begin
                        EmployeeTransfer.Reset();
                        Rec.FilterGroup(2);
                        EmployeeTransfer.SetRange("Employee No.", Rec."No.");
                        EmployeeTransfer.SETFILTER(Type, '%1|%2', EmployeeTransfer.Type::"HR Transfer", EmployeeTransfer.Type::"Employee Transfer");
                        EmployeeTransfer.SETFILTER("Approval Status", '%1|%2', EmployeeTransfer."Approval Status"::Acknowledged, EmployeeTransfer."Approval Status"::Approved);
                        Rec.FilterGroup(0);
                        CLEAR(PageTransferHistory);
                        PageTransferHistory.ForHistoryPage;
                        PageTransferHistory.SETTABLEVIEW(EmployeeTransfer);
                        PageTransferHistory.SETRECORD(EmployeeTransfer);
                        PageTransferHistory.RUN;
                    end;
                }
                // action("Access Control History")
                // {
                //     ApplicationArea = All;
                //     RunObject = Page "Access Control History";
                //     RunPageView = WHERE(Status = CONST(approved));
                //     RunPageLink = "Employee No." = FIELD("No.");
                //     Promoted = true;
                //     PromotedIsBig = true;
                //     Image = History;
                //     PromotedCategory = Category6;
                //     PromotedOnly = true;
                //     RunPageMode = View;
                //     ToolTip = 'Executes the Access Control History action.';

                //     trigger OnAction()
                //     begin

                //     end;
                // }
                action("Show Leave Earn")
                {
                    ApplicationArea = All;
                    RunObject = Page "Leave Earn";
                    RunPageLink = "Employee No." = FIELD("No.");
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
                        ServiceHistory.Reset();
                        ServiceHistory.FILTERGROUP(2);
                        ServiceHistory.SetRange("Employee No.", Rec."No.");
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
                    Visible = false;
                    trigger OnAction()
                    begin
                        CheckEmployee;
                        IF NOT CheckForLeaveEarnExist THEN begin
                            IF rec."Employment Type" = rec."Employment Type"::Contract THEN
                                LeaveMgt.UpdateLeaveEmployeeContract(Rec."No.", Rec."Employment Date", rec."Employment Type", rec.Gender, rec."Marital Status")
                            ELSE IF rec."Employment Type" IN [rec."Employment Type"::Permanent, rec."Employment Type"::Probation] THEN
                                LeaveMgt.UpdateLeaveEmployee(rec."No.", rec."Employment Date", rec."Employment Type", rec.Gender, rec."Marital Status");
                        end;
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
                    ToolTip = 'Executes the Assign Job Function action. Which updates info based on deputation';
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to assign job function?', false) THEN
                            ServiceHistoryMgt.PopUpForJobAssignment(Rec);
                    end;
                }
                action("Update Service Event")
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
                        EmployeeEventUpdate: Report "Service Event Update";
                    begin
                        rec.TestField(Gender);
                        IF CONFIRM('Do you want to update Employee Service event?', FALSE) THEN begin
                            CLEAR(EmployeeEventUpdate);
                            EmployeeEventUpdate.SetAppointment(Rec."No.");
                            EmployeeEventUpdate.RUN;
                        end;
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
                    Visible = false;
                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to add job function?', FALSE) THEN
                            ServiceHistoryMgt.PopUpForJobAddition(Rec);
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
                // action("Leave Earn (Contract)")
                // {
                //     ApplicationArea = All;
                //     Promoted = true;
                //     PromotedIsBig = true;
                //     Image = EditFilter;
                //     PromotedCategory = Category7;
                //     PromotedOnly = true;
                //     ToolTip = 'Executes the Leave Earn (Contract) action.';
                //     trigger OnAction()
                //     var

                //         TempLeaveEarn: Record "Leave Earn";
                //     begin
                //         LeaveMgt.CreateLeaveEarnContract(Rec);
                //     end;
                // }
                // action("Insert Mandatory Attachments")
                // {
                //     ApplicationArea = All;
                //     Promoted = true;
                //     PromotedIsBig = true;
                //     Image = Insert;
                //     PromotedCategory = Category7;
                //     PromotedOnly = true;
                //     ToolTip = 'Executes the Insert Mandatory Attachments action.';
                //     trigger OnAction()
                //     begin
                //         InsertAttachmentLines(Rec);
                //     end;
                // }
                action("Update Employment Date")
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
                var
                    Resignation: Record Resignation;
                begin
                    Resignation.SetRange("Employee No.", Rec."No.");
                    Resignation.SetRange("Approval Status", Resignation."Approval Status"::Settled);
                    IF Resignation.FindFirst() THEN begin
                        Employee.Reset();
                        Employee.SetRange("No.", Rec."No.");
                        IF Employee.FindFirst() THEN begin
                            Employee.TestField(Salutation);
                            REPORT.RUN(70022, TRUE, TRUE, Employee);

                        end;
                    end;
                end;
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
                var
                    Resignation: Record Resignation;
                begin
                    Resignation.SetRange("Employee No.", Rec."No.");
                    IF Resignation.FindLast() THEN
                        Resignation.TestField("Approval Status", Resignation."Approval Status"::Approved);

                    Employee.Reset();
                    Employee.SetRange("No.", Rec."No.");
                    IF Employee.FindFirst() THEN begin
                        Employee.TestField(Salutation);
                        REPORT.RUN(70023, TRUE, TRUE, Employee);
                    end;
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
                var
                    Resignation: Record Resignation;
                begin
                    Employee.Reset();
                    Employee.SetRange("No.", Rec."No.");
                    IF Employee.FindFirst() THEN begin
                        Employee.TestField(Salutation);
                        Resignation.Reset();
                        Resignation.SetRange("Employee No.", Employee."No.");
                        IF Resignation.FindLast() THEN
                            Resignation.TestField("Approval Status", Resignation."Approval Status"::Settled);
                        REPORT.RUN(70024, TRUE, TRUE, Employee);
                    end;
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
                    Employee.Reset();
                    Employee.SetRange("No.", Rec."No.");
                    IF Employee.FindFirst() THEN begin
                        Employee.TestField(Salutation);
                        REPORT.RUN(70026, TRUE, TRUE, Employee);
                    end;
                end;
            }
            action("Insert Grade")
            {
                ApplicationArea = All;
                RunObject = Report "Insert Grade";
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
        }

    }
    var
        ServiceEvent: Enum "Service Event";
        SameAsPermanent: Boolean;
        Usersetup: Record "User Setup";
        PayrollFieldsVisible: Boolean;
        Employee: Record Employee;
        ValdiateEmp: Report ValidateEmpAttributes;
        TransferCard: Page "Transfer Card";
        LoanMgt: Codeunit "Loan Mgt.";
        Type: Enum "Loan Type";
        AppraisalRec: Record Appraisal;
        FieldVisible: Boolean;
        FieldVisible1: Boolean;
        HRMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        InsuranceMgt: Codeunit "Insurance Mgt";
        ServiceHistoryMgt: Codeunit "Service History Mgt";
        ExtensionCounterEdit: Boolean;
        BranchEdit: Boolean;
        ProvinceEdit: Boolean;
        UnitEdit: Boolean;
        DepartmentEdit: Boolean;
        ExtensionCounterVisible: Boolean;
        BranchVisible: Boolean;
        ProvinceVisible: Boolean;
        UnitVisible: Boolean;
        DepartmentVisible: Boolean;
        PayrollEngine: Codeunit "Payroll Engine";
        ServiceHistory: Record "Employee Service History";
        PGSetup: Record "Payroll General Setup";
        TransferMgt: Codeunit "Transfer Mgt.";
        AttendanceMissedMgt: Codeunit "AttendanceMiss Mgt";
        AllowanceAssignmentMgt: Codeunit "Allowance Assignment Mgt";
        ShiftAssignmentMgt: Codeunit "Shift Assignment Mgt";


    trigger OnOpenPage()
    begin
        Usersetup.GET(USERID);
        PayrollFieldsVisible := Usersetup."Can View Payroll Fields";

        SetFieldEnable;

        //>>updating date
        IF Rec."Birth Date" <> 0D THEN begin
            Rec.Age := ROUND((TODAY - Rec."Birth Date") / 365.4, 1, '<');
            Rec.MODIFY;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        SetFieldEnable();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        EmployeeWorkShift: Record "Employee Work Shift";
    begin
        EmployeeWorkShift.SetRange("Default Employee Type", Rec."Employment Type");
        if EmployeeWorkShift.FindFirst() then
            Rec."Employee Work Shift" := EmployeeWorkShift.Code
        else begin
            EmployeeWorkShift.Reset();
            EmployeeWorkShift.SetRange("Default Employee Type", EmployeeWorkShift."Default Employee Type"::" ");
            if EmployeeWorkShift.FindFirst() then
                Rec."Employee Work Shift" := EmployeeWorkShift.Code;
        end;
    end;

    local procedure SetFieldEnable();
    begin
        CASE Rec."Deputation on" OF
            Rec."Deputation on"::Branch:
                begin
                    ProvinceEdit := true;
                    BranchEdit := true;
                    ExtensionCounterEdit := true;
                    DepartmentEdit := false;
                    UnitEdit := false;
                    ExtensionCounterVisible := true;
                    BranchVisible := true;
                    ProvinceVisible := true;
                    UnitVisible := false;
                    DepartmentVisible := false;
                end;
            Rec."Deputation on"::Province:
                begin
                    ProvinceEdit := true;
                    BranchEdit := false;
                    ExtensionCounterEdit := false;
                    DepartmentEdit := false;
                    UnitEdit := false;
                    ExtensionCounterVisible := false;
                    BranchVisible := false;
                    ProvinceVisible := true;
                    UnitVisible := false;
                    DepartmentVisible := false;
                end;
            Rec."Deputation on"::Department:
                begin
                    ProvinceEdit := false;
                    BranchEdit := false;
                    ExtensionCounterEdit := false;
                    DepartmentEdit := true;
                    UnitEdit := true;
                    ExtensionCounterVisible := false;
                    BranchVisible := false;
                    ProvinceVisible := true;
                    UnitVisible := true;
                    DepartmentVisible := true;
                end;
            Rec."Deputation on"::Unit:
                begin
                    ProvinceEdit := false;
                    BranchEdit := false;
                    ExtensionCounterEdit := false;
                    DepartmentEdit := true;
                    UnitEdit := true;
                    ExtensionCounterVisible := false;
                    BranchVisible := false;
                    ProvinceVisible := true;
                    UnitVisible := true;
                    DepartmentVisible := true;
                end;
            Rec."Deputation on"::"Extension Counter":
                begin
                    ProvinceEdit := true;
                    BranchEdit := true;
                    ExtensionCounterEdit := TRUE;
                    DepartmentEdit := false;
                    UnitEdit := false;
                    ExtensionCounterVisible := true;
                    BranchVisible := true;
                    ProvinceVisible := true;
                    UnitVisible := false;
                    DepartmentVisible := false;
                end;
        end;
    end;

    local procedure CheckEmployee();
    begin
        IF Rec."New Employee" THEN begin
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
            Rec.TestField("Tax Code");
            Rec.TestField("Inside/Outside Valley");
            Rec.TestField("Posting Region");
            Rec.TestField("Date of Birth (B.S.)");
            Rec.TestField("PAN No.");
            Rec.TestField("Citizen Number");
            IF Rec."Employment Type" = Rec."Employment Type"::Permanent THEN
                Rec.TestField("Confirmation Date");
            IF Rec."Employment Type" = Rec."Employment Type"::Contract THEN
                Rec.TestField("Contract Salary Amount");
            IF Rec."Employment Type" = Rec."Employment Type"::Probation THEN
                Rec.TestField("Probation Period");
            IF Rec."Employment Type" = Rec."Employment Type"::Contract THEN begin
                Rec.TestField("Contract Expiry Month");
            end;

            CASE Rec."Deputation on" OF
                Rec."Deputation on"::Branch:
                    begin
                        Rec.TestField("Branch Name");
                        Rec.TestField("Global Dimension 1 Code");
                        Rec.TestField("Province Code");
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
                    end;

                Rec."Deputation on"::Province:
                    begin
                        Rec.TestField("Province Code");
                        Rec.TestField("Province Name");
                    end;
                Rec."Deputation on"::Unit:
                    begin
                        Rec.TestField("Unit Code");
                        Rec.TestField("Unit Name");
                    end;
            end;
        end;
    end;

    local procedure CheckForLeaveEarnExist(): Boolean;
    VAR
        LeaveEarn: Record "Leave Earn";
    begin
        LeaveEarn.Reset();
        LeaveEarn.SetRange("Employee No.", Rec."No.");
        IF LeaveEarn.FindFirst() THEN
            EXIT(TRUE);
    end;

    local procedure CopyPermanentAddress()
    begin
        rec."Temporary Province" := rec."Permanent Province";
        rec."Temporary District" := rec."Permanent District";
        rec."Temporary VDC" := rec."Permanent VDC";
        rec."Temporary Locality" := rec."Permanent Locality";
        rec.Validate("Temporary Ward No", rec."Permanent Ward No");
        Rec."Temporary House" := rec."Permanent House";
    end;

    procedure ClearTemporaryAddress()
    begin
        Rec."Temporary Province" := '';
        Rec."Temporary District" := '';
        Rec."Temporary VDC" := '';
        rec."Temporary Locality" := '';
        Rec."Temporary Ward No" := 0;
        Rec."Temporary House" := '';
        rec."Temporary Address" := '';
    end;

}

