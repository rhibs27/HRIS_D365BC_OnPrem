page 50135 "Employee Edit Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Employee Edit";
    // InsertAllowed = false;
    // DeleteAllowed = false;
    // Editable = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = isOpenOrCreated;
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
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = ApprovalStatusView;
                }
                field(Status; rec.Status)
                {
                    Caption = 'Approval Status';
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = StatusView;
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
                    Editable = isOpenOrCreated;
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
                Editable = isOpenOrCreated and (Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::Details);
                Visible = DetailsChanges;
                field("Mobile No."; Rec."Mobile No.")
                {
                    ToolTip = 'Specifies the value of the Mobile No. field.';
                    ApplicationArea = All;
                }
                field("Email (Personal)"; Rec."Email (Personal)")
                {
                    ToolTip = 'Specifies the value of the Email (Personal) field.';
                    ApplicationArea = All;
                }
                field("Differently Able"; Rec."Differently Able")
                {
                    ToolTip = 'Specifies the value of the Differently Able field.';
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

                field("Temporary District"; Rec."Temporary District")
                {
                    ToolTip = 'Specifies the value of the Temporary District field.';
                    ApplicationArea = All;
                }
                field("Temporary VDC"; Rec."Temporary VDC")
                {
                    ToolTip = 'Specifies the value of the Temporary VDC field.', Comment = '%';
                }
                field("Temporary Ward No"; Rec."Temporary Ward No")
                {
                    ToolTip = 'Specifies the value of the Temporary Ward No field.', Comment = '%';
                }
                field("Temporary Locality"; Rec."Temporary Locality")
                {
                    ToolTip = 'Specifies the value of the Temporary Locality field.', Comment = '%';
                }
                field("Temporary House"; Rec."Temporary House")
                {
                    ToolTip = 'Specifies the value of the Temporary House field.', Comment = '%';
                }

                field("Blood Group"; Rec."Blood Group")
                {
                    ToolTip = 'Specifies the value of the Blood Group field.';
                    ApplicationArea = All;
                }
            }

            group("Official Document")
            {
                Editable = isOpenOrCreated and (Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::Details);

                Visible = DetailsChanges;
                field("passport No."; Rec."Passport No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Passport No. field.';
                }
                field("CitizenShip  No."; Rec."CitizenShip No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CitizenShip No. field.';
                }
                field("CitizenShip IssueDate"; Rec."CitizenShip Issue Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CitizenShip Issue Date field.';
                }
                field("NID No."; Rec."NID No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the National ID No. field.';
                }
                field("Driving License No."; Rec."Driving License No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Driving License No field.';
                }
            }
            group(VehicleInformation)
            {
                Editable = isOpenOrCreated and ((Rec."Approval Status" = Rec."Approval Status"::Open) or (Rec."Approval Status" = Rec."Approval Status"::Created));

                Visible = Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::"Vehicle Info Update";
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    ToolTip = 'Specifies the value of the Vehicle Type field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ToolTip = 'Specifies the value of the Vehicle No. field.';
                    ApplicationArea = All;
                    Editable = (Rec."Vehicle Type" <> Rec."Vehicle Type"::"No Vehicle") or (Rec."Vehicle Type" = Rec."Vehicle Type"::" ");
                }
                field("Vehicle Owner Name"; Rec."Vehicle Owner Name")
                {
                    ToolTip = 'Specifies the value of the Vehicle Owner Name field.', Comment = '%';
                    Editable = (Rec."Vehicle Type" <> Rec."Vehicle Type"::"No Vehicle") or (Rec."Vehicle Type" = Rec."Vehicle Type"::" ");
                }
                field("Ownership Start/End Date"; Rec."Ownership Start/End Date")
                {
                    ToolTip = 'Specifies the value of the Ownership Start/End Date field.', Comment = '%';
                    Editable = (Rec."Vehicle Type" <> Rec."Vehicle Type"::"No Vehicle") or (Rec."Vehicle Type" = Rec."Vehicle Type"::" ");
                }
                field("Claim Type"; Rec."Claim Type")
                {
                    ToolTip = 'Specifies the value of the Claim Type field.', Comment = '%';
                }
            }
            group(MaritalStatusUpdate)
            {
                Editable = isOpenOrCreated and ((Rec."Approval Status" = Rec."Approval Status"::Open) or (Rec."Approval Status" = Rec."Approval Status"::Created));
                Visible = Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::"Marital Status Update";
                field("Marital Status"; Rec."Marital Status")
                {
                    ToolTip = 'Specifies the value of the Marital Status field.';
                    ApplicationArea = All;
                }
                field("Spouse Name"; Rec."Spouse Name")
                {
                    ToolTip = 'Specifies the value of the Spouse Name field.', Comment = '%';
                }
                field("Spouse DOB"; Rec."Spouse DOB")
                {
                    ToolTip = 'Specifies the value of the Spouse DOB field.', Comment = '%';
                }
                field("Spouse citizenship No."; Rec."Spouse citizenship No.")
                {
                    ToolTip = 'Specifies the value of the Spouse citizenship No. field.', Comment = '%';
                }
                field("Spouse Citiz. Issued Place"; Rec."Spouse Citiz. Issued Place")
                {
                    ToolTip = 'Specifies the value of the Spouse Citiz. Issued Place field.', Comment = '%';
                }

            }

            part("Qualification Details"; "Emp. Edit Qualifi Subform")
            {
                Visible = QualificationChanges;
                SubPageLink = "Document No." = field("No.");
                SubPageView = where("Change in Emp Type" = filter(Qualification));
                ApplicationArea = all;

            }
            part("Work Experience Details"; "Emp Edit Work Exp. Subform")
            {
                Visible = WorkExperienceChanges;
                SubPageLink = "Document No." = field("No.");
                SubPageView = where("Change in Emp Type" = filter("Work Experience"));
                ApplicationArea = all;
            }
            part("Achievement Details"; "Emp. Edit Achievement Subform")
            {
                Visible = AchievementChanges;
                SubPageLink = "Document No." = field("No.");
                SubPageView = where("Change in Emp Type" = filter(Achievement));
                ApplicationArea = all;
            }
            part("Relative Details"; "Emp. Edit Relative Subform")
            {
                Visible = Relative;
                SubPageLink = "Document No." = field("No.");
                SubPageView = where("Change in Emp Type" = filter(Relative));
                ApplicationArea = all;
            }
            part("language Details"; "Emp Edit Language Prof Subform")
            {
                Visible = LanguageChange;
                SubPageLink = "Document No." = field("No.");
                SubPageView = where("Change in Emp Type" = filter(Language));
                ApplicationArea = all;
            }
            part("Additional Attachments"; "Emp. Edit Add. Attach. Subform")
            {
                Visible = AdditionalDocuments;
                SubPageLink = "Document No." = field("No.");
                SubPageView = where("Change in Emp Type" = filter("Additional Documents"));
                ApplicationArea = all;
            }

            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No."),
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
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = isOpenOrCreated;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    EmployeeEditMgt: Codeunit "Employee Edit Mgt.";
                begin
                    if Confirm('Do you want to send for approval the request?', false) then begin
                        EmployeeEditMgt.EmployeeEditSendForApproval(Rec."No.");
                    end;
                end;
            }
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsPending;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the request?', false) then begin
                        ApprovalMgt.ApproveRejectDocument(RecRef, true);
                        Message('Employee Edit is Approved by %1', HRMgt.GetEmpName());
                    end;
                end;
            }
            action("Reject Request")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Reject Request action.';
                ApplicationArea = All;
                Visible = IsPending;
                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            ApprovalMgt.ApproveRejectDocument(RecRef, false);
                            Message('Employee Edit is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        SetLayout;
    end;

    trigger OnAfterGetRecord()
    begin
        SetLayout;
    end;

    var
        IsPending, IsRejected, IsApproved, isOpenOrCreated : Boolean;
        StatusView, ApprovalStatusView : Boolean;
        RecRef: RecordRef;
        DetailsChanges, Relative, LanguageChange, QualificationChanges, WorkExperienceChanges, AchievementChanges, AdditionalDocuments : Boolean;
        WorkExperience, GroupCaption : text;
        ApprovalMgt: Codeunit "Approver Mgt";
        HRMgt: Codeunit "HR Mgt.";

    local procedure SetLayout()
    begin
        DetailsChanges := Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::Details;
        QualificationChanges := Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::Qualification;
        WorkExperienceChanges := Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::"Work Experience";
        AchievementChanges := Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::Achievement;
        Relative := Rec."Changes In Employee Type" = rec."Changes In Employee Type"::Relative;
        LanguageChange := Rec."Changes In Employee Type" = rec."Changes In Employee Type"::Language;
        AdditionalDocuments := Rec."Changes In Employee Type" = Rec."Changes In Employee Type"::"Additional Documents";
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        IsRejected := Rec."Approval Status" = rec."Approval Status"::Rejected;
        isOpenOrCreated := (Rec."Approval Status" = Rec."Approval Status"::Open) or (Rec."Approval Status" = Rec."Approval Status"::Created);
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