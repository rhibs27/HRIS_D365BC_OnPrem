page 33020007 "Medical Insurance Claim"
{
    PageType = Card;
    SourceTable = "Medical Insurance Claim";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group("Employee Details")
            {
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
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
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
                field("Sub Province Code"; Rec."Sub Province Code")
                {
                    ToolTip = 'Specifies the value of the Sub Province Code field.';
                    ApplicationArea = All;
                }
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specifies the value of the Province Code field.';
                    ApplicationArea = All;
                }
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    Caption = 'Job Title';
                    ToolTip = 'Specifies the value of the Job Title field.';
                    ApplicationArea = All;
                }
                field("Insurance Status"; Rec."Insurance Status")
                {
                    ToolTip = 'Specifies the value of the Insurance Status field.';
                    ApplicationArea = All;
                }
            }
            group("Insurance Details")
            {
                field("Insurance Claim"; Rec."Insurance Claim")
                {
                    ToolTip = 'Specifies the value of the Insurance Claim field.';
                    ApplicationArea = All;
                }
                field("Father Name"; Rec."Father Name")
                {
                    ToolTip = 'Specifies the value of the Father Name field.';
                    ApplicationArea = All;
                }
                field("Mother Name"; Rec."Mother Name")
                {
                    ToolTip = 'Specifies the value of the Mother Name field.';
                    ApplicationArea = All;
                }
                field("Spouse Name"; Rec."Spouse Name")
                {
                    ToolTip = 'Specifies the value of the Spouse Name field.';
                    ApplicationArea = All;
                }
                field("Child Name"; Rec."Child Name")
                {
                    ToolTip = 'Specifies the value of the Child Name field.';
                    ApplicationArea = All;
                }
                field("Total Insurance Claim Amount"; Rec."Total Insurance Claim Amount")
                {
                    ToolTip = 'Specifies the value of the Total Insurance Claim Amount field.';
                    ApplicationArea = All;
                }
                field("Medical Prescription Date"; Rec."Medical Prescription Date")
                {
                    ToolTip = 'Specifies the value of the Medical Prescription Date field.';
                    ApplicationArea = All;
                }
                field("Discharge Date"; Rec."Discharge Date")
                {
                    ToolTip = 'Specifies the value of the Discharge Date field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Send Request to DTMD")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ApprovalSent;
                ToolTip = 'Executes the Send Request to DTMD action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Validate("Insurance Status", Rec."Insurance Status"::"Request to DTMD");
                    CurrPage.Close();
                end;
            }
            action(Screen)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Screen;
                ToolTip = 'Executes the Screen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    MedicalInsuranceMgt.ScreenMedicalInsurance(Rec);
                    CurrPage.Close();
                end;
            }
            action("Send to Insurance Company")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Screened;
                ToolTip = 'Executes the Send to Insurance Company action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    HRMgt: Codeunit "HR Mgt.";
                    EmpAct: Record "Employee Activity";
                    ApprovalRequestSent: Label 'Insurance Claim email to company has been sent.';
                begin
                    if Rec."Insurance Status" = Rec."Insurance Status"::Screened then begin
                        HRMgt.SendMailFromTemplate(Database::"Employee Activity", EmpAct.Type::"Medical Insurance Claim", EmpAct."Approval Status"::Rejected, '', EmpAct."Employee No.", EmpAct."No.", 0);   //For email
                        Message(ApprovalRequestSent);
                        Rec.Validate("Insurance Status", Rec."Insurance Status"::"Forwarded to Insurance Co.");
                        Rec.Modify;
                    end;
                    CurrPage.Close();
                end;
            }
            action(Reimbursed)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ApproveReject;
                ToolTip = 'Executes the Reimbursed action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    MedicalInsuranceMgt.ApproveRejectMedicalInsurance(true, Rec);
                end;
            }
            action("Rejected by Insurance Company")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ApproveReject;
                ToolTip = 'Executes the Rejected by Insurance Company action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    MedicalInsuranceMgt.ApproveRejectMedicalInsurance(false, Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        MedicalInsuranceMgt: Codeunit "MedicalInsurance Mgt";
        ApprovalSent: Boolean;
        Screen: Boolean;
        Screened: Boolean;
        ApproveReject: Boolean;

    procedure SetLayout()
    begin
        ApprovalSent := Rec."Insurance Status" in [Rec."Insurance Status"::" ", Rec."Insurance Status"::"Request to DTMD"];
        Screen := Rec."Insurance Status" = Rec."Insurance Status"::"Request to DTMD";
        Screened := Rec."Insurance Status" = Rec."Insurance Status"::Screened;
        ApproveReject := Rec."Insurance Status" = Rec."Insurance Status"::"Forwarded to Insurance Co.";
    end;
}
