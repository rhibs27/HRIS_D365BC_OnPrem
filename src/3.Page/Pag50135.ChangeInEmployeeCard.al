page 50135 "Change In Employee Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Employee Edit";
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Changes In Employee Type"; Rec."Changes In Employee Type")
                {
                    ToolTip = 'Specifies the value of the Changes In Employee Type field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field(Status; rec.Status)
                {
                    Caption = 'Approval Status';
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }

            }
            group(Remarks)
            {

                field(Remark; Rec.Remarks)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                    Editable = IsPending;
                }
            }

            group("Employee Information")
            {
                Editable = DetailsChanges;
                Visible = DetailsChanges;
                field("Mobile No."; Rec."Mobile No.")
                {
                    ToolTip = 'Specifies the value of the Mobile No. field.';
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ToolTip = 'Specifies the value of the Marital Status field.';
                    ApplicationArea = All;
                }
                field("Email (Personal)"; Rec."Email (Personal)")
                {
                    ToolTip = 'Specifies the value of the Email (Personal) field.';
                    ApplicationArea = All;
                }
                field("Passport No."; Rec."Passport No.")
                {
                    ToolTip = 'Specifies the value of the Passport No. field.';
                    ApplicationArea = All;
                }
                field("Differently Able"; Rec."Differently Able")
                {
                    ToolTip = 'Specifies the value of the Differently Able field.';
                    ApplicationArea = All;
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    ToolTip = 'Specifies the value of the Vehicle Type field.';
                    ApplicationArea = All;
                }
                field("Temporary Address"; Rec."Temporary Address")
                {
                    ToolTip = 'Specifies the value of the Temporary Address field.';
                    ApplicationArea = All;
                }
                field("Temporary Province"; Rec."Temporary Province")
                {
                    ToolTip = 'Specifies the value of the Temporary Province field.';
                    ApplicationArea = All;
                }
                field(VDC; Rec.VDC)
                {
                    ToolTip = 'Specifies the value of the VDC field.';
                    ApplicationArea = All;
                }
                field("Temporary District"; Rec."Temporary District")
                {
                    ToolTip = 'Specifies the value of the Temporary District field.';
                    ApplicationArea = All;
                }
                field(House; Rec.House)
                {
                    ToolTip = 'Specifies the value of the House field.';
                    ApplicationArea = All;
                }
                field("Blood Group"; Rec."Blood Group")
                {
                    ToolTip = 'Specifies the value of the Blood Group field.';
                    ApplicationArea = All;
                }
            }
            group("Employee Qualification")
            {
                Editable = false;
                // Caption = GroupCaption;
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Percentage field.';
                    Visible = QualificationChanges;
                }
                field(CGPA; Rec.CGPA)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CGPA field.';
                    Visible = QualificationChanges;
                }
                field(Stream; Rec.Stream)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stream field.';
                    Visible = QualificationChanges;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year of completion field.';
                    Visible = QualificationChanges;
                }
                field("Emp Document Type"; Rec."Emp Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Emp Document Type field.';
                }

                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                field("Qualification Code"; Rec."Qualification Code")
                {
                    CaptionClass = WorkExperience;
                }
                field("Qualification Type"; rec."Qualification Type")
                {
                    Visible = QualificationChanges;
                }
                field(Description; Rec.Description)
                {
                }
                field("Institution/Company"; Rec."Institution/Company")
                {
                }
                field(Designation; Rec.Designation)
                {
                    Visible = WorkExperienceChanges;
                }
                field(Remuneration; Rec.Remuneration)
                {
                }
            }
            group("Official Document")
            {
                Editable = false;
                Visible = OfficialDocument;
                field(passportNo; Rec."Passport No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Passport No. field.';
                }
                field(citizenShipNo; Rec."CitizenShip No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CitizenShip No. field.';
                }
                field(citizenShipIssueDate; Rec."CitizenShip Issue Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CitizenShip Issue Date field.';
                    // Visible = QualificationChanges;
                }
                field(nIDNo; Rec."NID No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the National ID No. field.';
                    // Visible = QualificationChanges;
                }
                field(drivingLicenseNo; Rec."Driving License No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Driving License No field.';
                }
            }
            group(Relative)
            {
                Editable = false;
                Visible = Relative;
                field(relativeCode; Rec."Relative Code")
                {
                }
                field(fullName; Rec."Full Name")
                {
                }
                field(relativePhoneNo; Rec."Relative Phone No.")
                {
                }
                field(employeeRelativeInBank; rec."Employee Relative In Bank")
                {
                }
                field(relativeEmployeeNo; Rec."Relative's Employee No.")
                {
                }
                field(relativeCitizenShipNo; Rec."Relative CitizenShip No.")
                {
                }
                field(relativeDistrict; Rec."Relative District")
                {
                }
                field(relativeVDCMunicipality; Rec."Relative VDC/Municipality")
                {
                }
                field(wardNo; Rec."Ward No.")
                {
                }
            }
            group("Language Proficiency")
            {
                Editable = false;
                Visible = LanguageChange;
                field(Language; Rec.Language)
                {
                }
                field(Reading; Rec.Reading)
                {
                }
                field(Writing; Rec.Writing)
                {
                }
                field(Speaking; Rec.Speaking)
                {
                }
                field(Typing; Rec.Typing)
                {
                }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No."),
                                "Employee No" = field("Employee No."),
                                "Document Type" = field(Type);
                ApplicationArea = all;
            }
        }
        area(factboxes)
        {
            part(Control3; "Employee Edit Picture")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        IsPending: Boolean;
        IsApproved: Boolean;
        IsRejected: Boolean;
        StatusView: Boolean;
        ApprovalStatusView: Boolean;
        RecRef: RecordRef;
        DetailsChanges: Boolean;
        OfficialDocument: Boolean;
        Relative: Boolean;
        LanguageChange: Boolean;
        QualificationChanges: Boolean;
        WorkExperienceChanges: Boolean;
        AchievementChanges: Boolean;
        WorkExperience: text;
        GroupCaption: text;

    local procedure SetLayout()
    begin
        DetailsChanges := Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::Details;
        QualificationChanges := Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::Qualification;
        WorkExperienceChanges := Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::"Work Experience";
        AchievementChanges := Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::Achievement;
        OfficialDocument := Rec."Changes In Employee Type" = rec."Changes In Employee Type"::"Official Document";
        Relative := Rec."Changes In Employee Type" = rec."Changes In Employee Type"::Relative;
        LanguageChange := Rec."Changes In Employee Type" = rec."Changes In Employee Type"::Language;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        IsRejected := Rec."Approval Status" = rec."Approval Status"::Rejected;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        RecRef.GetTable(Rec);
        if IsRejected then
            CurrPage.Editable := false;
        if QualificationChanges then begin
            WorkExperience := 'Experience Code';
            GroupCaption := 'Employee Qualification';
        end else if WorkExperienceChanges then begin
            WorkExperience := 'Qualification Code';
            GroupCaption := 'Employee Work Experience';
        end else if AchievementChanges then begin
            WorkExperience := 'Achievement Code';
            GroupCaption := 'Employee Achievement';
        end;
    end;
}