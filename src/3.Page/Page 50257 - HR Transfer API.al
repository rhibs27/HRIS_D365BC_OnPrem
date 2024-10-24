page 50257 "HR Transfer API"
{
    // version NIC Asia1.00

    // //Min -- Update field caption of "Shortcut Dimension 1 Code (To)" to "Branch Code (To)".

    EntityName = 'HRTransfer';
    EntitySetName = 'HRTransfers';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Employee/HR Transfer";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = ForOpen;
                field(No; Rec."No.")
                {
                    Editable = false;
                }
                field(EmployeeNo; Rec."Employee No.")
                {
                    Editable = true;
                }
                field(EmployeeName; Rec."Employee Name") { }
                field(TransferCategory; Rec."Transfer Category")
                {
                    trigger OnValidate()
                    begin
                        GetTransferEditibility;
                    end;
                }
                field(Type; Rec.Type)
                {
                    Visible = false;
                }
                field(StartDate; Rec."Start Date")
                {
                    Editable = TransferCategoryEditable;
                }
                field(EndDate; Rec."End Date")
                {
                    Editable = TransferCategoryEditable;
                }
            }
            group(Transfer)
            {
                field(TransferEffectiveDate; Rec."Transfer Effective Date")
                {
                    Editable = not ForAck;
                }
                field(ReasonForTransfer; Rec."Reason for Resignation")
                {
                    Editable = ForOpen;
                }
                field(Notifyto; Rec."Notify to") { }
            }
            group(Placement)
            {
                Editable = not ForApprove;
                Visible = ForReview;
                field(TransferType; Rec."Transfer Type")
                {
                    trigger OnValidate()
                    begin
                        //SetLayout;
                        //CurrPage.UPDATE;
                    end;
                }
            }
            group("Proposed Placement")
            {
                field(DeputationOnTo; Rec."Deputation On (To)")
                {
                    trigger OnValidate()
                    begin
                        SetLayout;
                        GetTransferName;
                    end;
                }
                field(ExtensionCounterTo; Rec."Extension Counter (To)")
                {
                    Editable = ExtensionCounterEdit;

                    trigger OnValidate()
                    begin
                        GetTransferName;
                    end;
                }
                field(ExtensionNameTo; ExtensionNameTo)
                {
                    Editable = false;
                }
                field(FunctionalTitleTo; Rec."Functional Title (To)")
                {
                    trigger OnValidate()
                    begin
                        GetTransferName;
                    end;
                }
                field(FunctionalDescTo; FunctionalDescTo)
                {
                    Caption = 'Functional Title Description(To)';
                    Editable = false;
                }
                field(ShortcutDimension1CodeTo; Rec."Shortcut Dimension 1 Code (To)")
                {
                    Caption = 'Branch Code (To)';
                    Editable = BranchEdit;

                    trigger OnValidate()
                    begin
                        GetTransferName;
                    end;
                }
                field(BranchNameTo; BranchNameTo)
                {
                    Editable = false;
                }
                field(SubProvinceCodeTo; Rec."Sub Province Code (To)")
                {
                    Editable = SubProvinceEdit;

                    trigger OnValidate()
                    begin
                        GetTransferName;
                    end;
                }
                field(SubProvinceNameTo; SubProvinceNameTo)
                {
                    Editable = false;
                }
                field(ProvinceCodeTo; Rec."Province Code (To)")
                {
                    Editable = ProvinceEdit;

                    trigger OnValidate()
                    begin
                        GetTransferName;
                    end;
                }
                field(ProvinceNameTo; ProvinceNameTo)
                {
                    Editable = false;
                }
                field(UnitTo; Rec."Unit (To)")
                {
                    Editable = UnitEdit;

                    trigger OnValidate()
                    begin
                        GetTransferName;
                    end;
                }
                field(UnitNameTo; UnitNameTo)
                {
                    Editable = false;
                }
                field(DepartmentCodeTo; Rec."Department Code (To)")
                {
                    Editable = DepartEdit;

                    trigger OnValidate()
                    begin
                        GetTransferName;
                    end;
                }
                field(DepartmentNameTo; DepartmentNameTo)
                {
                    Editable = false;
                }
                field(IncomingSupervisior; Rec."Incoming Supervisior") { }
                field(IncomingSupervisiorName; Rec."Incoming Supervisior Name") { }
                field(OutgoingBranchRepPerson; Rec."Outgoing Branch Rep. Person")
                {
                    trigger OnValidate()
                    begin
                        Rec.CalcFields("Outgoing Reporting Person Name");
                    end;
                }
                field(OutgoingReportingPersonName; Rec."Outgoing Reporting Person Name") { }
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
                Visible = (Rec."Approval Status" = Rec."Approval Status"::Open) and (Rec.Type = Rec.Type::"Employee Transfer");

                trigger OnAction()
                var
                    ConfirmTransfer: Label 'Do you want to send transfer request ?';
                begin
                    if Confirm(ConfirmTransfer, false) then begin
                        TransferMgt.SendTransferApproval(Rec);
                        IsApplied := true;
                        CurrPage.Close;
                    end;
                end;
            }
            action(Recommend)
            {
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Rec."Approval Status" = Rec."Approval Status"::"Pending Approval";

                trigger OnAction()
                begin
                    if Confirm('Do you want to recommend this document?', false) then begin
                        TransferMgt.RecommendTransfer(Rec);
                        CurrPage.Close;
                    end;
                end;
            }
            action(Review)
            {
                Image = Register;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Rec."Approval Status" = Rec."Approval Status"::Recommended;

                trigger OnAction()
                begin
                    if Confirm('Do you want to review this document?', false) then begin
                        TransferMgt.ReviewTransfer(Rec);
                        CurrPage.Close;
                    end;
                end;
            }
            action(Screen)
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ForScreenButton;

                trigger OnAction()
                begin
                    if Confirm('Do you want to screen this document?', false) then begin
                        TransferMgt.ScreenTransfer(Rec);
                        CurrPage.Close;
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
                Visible = Rec."Approval Status" = Rec."Approval Status"::Screened;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve this document?', false) then begin
                        TransferMgt.ApproveTransfer(Rec);
                    end;
                end;
            }
            action("Hold Transfer")
            {
                Image = Stop;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ForApprove;

                trigger OnAction()
                begin
                    if Confirm('Do you want to hold this document?', false) then begin
                        TransferMgt.HoldTransfer(Rec);
                        CurrPage.Close;
                    end;
                end;
            }
            action("Cancel Transfer")
            {
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ForApprove;

                trigger OnAction()
                begin
                    if Confirm('Do you want to cancel this document?', false) then begin
                        TransferMgt.CancelTransfer(Rec);
                        CurrPage.Close;
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
                Visible = not (Rec."Approval Status" = Rec."Approval Status"::Open);

                trigger OnAction()
                begin
                    if Confirm('Do you want to reject this document?', false) then begin
                        TransferMgt.RejectTransfer(Rec);
                    end;
                end;
            }
            action("Acknowledge Transfer")
            {
                Image = Alerts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ForApprove or (Rec."Approval Status" = Rec."Approval Status"::"On Hold");

                trigger OnAction()
                begin
                    TransferMgt.AcknowledgeTransfer(Rec);
                end;
            }
            action("Access Control")
            {
                Image = Register;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ForApprove;

                trigger OnAction()
                begin
                    if Confirm('Do you want to open access control card?', false) then
                        HRMgt.OpenGrantAccessControlFromTransfer(Rec."No.");
                end;
            }
            action("Transfer Claim")
            {
                Image = CreateForm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Transfer Claim Form";
                RunPageLink = "No." = field("No.");
                RunPageView = where(Type = filter("Employee Transfer" | "HR Transfer"));
                Visible = ForApprove;
            }
            action("Return Transfer")
            {
                trigger OnAction()
                begin
                    if Confirm('Do you want to return this document?', false) then begin
                        TransferMgt.ReturnTransfer(Rec);
                    end;
                end;
            }
            action("Transfer History")
            {
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = not ForAck;

                trigger OnAction()
                var
                    EmployeeAct: Record "Employee Activity";
                    PageTransferHistory: Page "Employee Transfer Requests";
                begin
                    EmployeeAct.Reset;
                    Rec.FilterGroup(2);
                    EmployeeAct.SetFilter(Type, '%1|%2', EmployeeAct.Type::"HR Transfer", EmployeeAct.Type::"Employee Transfer");
                    EmployeeAct.SetRange("Employee No.", Rec."Employee No.");
                    EmployeeAct.SetRange("Approval Status", EmployeeAct."Approval Status"::Acknowledged);
                    Rec.FilterGroup(0);
                    Clear(PageTransferHistory);
                    PageTransferHistory.ForHistoryPage;
                    PageTransferHistory.SetTableView(EmployeeAct);
                    PageTransferHistory.SetRecord(EmployeeAct);
                    PageTransferHistory.Run;
                end;
            }
            action("Attendance Missed")
            {
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    TempEmpActivity.DeleteAll;
                    TempEmpActivity.Init;
                    TempEmpActivity.Validate("Employee No.", Rec."Employee No.");
                    TempEmpActivity.Validate(Type, EmployeeActivity.Type::"Attendance Missed");
                    TempEmpActivity.Insert;
                    Page.Run(Page::"Cancel Document", TempEmpActivity);
                end;
            }
            action("Change Approver")
            {
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Rec."Approval Status" = Rec."Approval Status"::Screened;

                trigger OnAction()
                begin
                    if Confirm('Do you want to modify approver?') then begin
                        TransferMgt.PopUpChangingTransferApprover(Rec);
                    end;
                end;
            }
            action("Update Missed Transfer")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    /*IF CONFIRM('Do you want to Update this document?',FALSE) THEN BEGIN
                      HRMgt.UpdateMissedTransfer(Rec); //Min
                    END;*/
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetLayout;
        GetTransferName;
        GetTransferEditibility;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnNewTransferRecord;
    end;

    trigger OnOpenPage()
    begin
        SetLayout;
        GetTransferName;
        Rec.CalcFields("Outgoing Reporting Person Name");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."No." <> '' then
            exit;
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            if not IsApplied then
                if not Confirm('The data will be erased.Do you want to continue?', false) then
                    Error('');
    end;

    var
        EmployeeActivity: Record "Employee Activity";
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";
        IsApplied: Boolean;
        [InDataSet]
        ForRecommend: Boolean;
        [InDataSet]
        ForApprove: Boolean;
        [InDataSet]
        ForReview: Boolean;
        [InDataSet]
        ForScreen: Boolean;
        [InDataSet]
        ForPending: Boolean;
        [InDataSet]
        ForOpen: Boolean;
        [InDataSet]
        ProvinceEdit: Boolean;
        [InDataSet]
        DepartEdit: Boolean;
        [InDataSet]
        UnitEdit: Boolean;
        [InDataSet]
        BranchEdit: Boolean;
        [InDataSet]
        FunctionalEdit: Boolean;
        [InDataSet]
        ForAck: Boolean;
        TypeFilter: Text;
        [InDataSet]
        ForScreenButton: Boolean;
        BranchNameTo: Text;
        DepartmentNameTo: Text;
        ProvinceNameTo: Text;
        SubProvinceNameTo: Text;
        ExtensionNameTo: Text;
        UnitNameTo: Text;
        BranchName: Text;
        DepartmentName: Text;
        ProvinceName: Text;
        SubProvinceName: Text;
        ExtensionName: Text;
        UnitName: Text;
        [InDataSet]
        SubProvinceEdit: Boolean;
        [InDataSet]
        ExtensionCounterEdit: Boolean;
        TempEmpActivity: Record "Employee Activity" temporary;
        [InDataSet]
        TransferCategoryEditable: Boolean;
        HRSetup: Record "Human Resources Setup";
        FunctionalTitle: Record "Functional Title";
        FunctionalDescFrom: Text;
        FunctionalDescTo: Text;

    local procedure SetLayout()
    begin
        if Rec.Type = Rec.Type::"Employee Transfer" then begin
            if Rec."Approval Status" = Rec."Approval Status"::Reviewed then
                ForScreenButton := true
            else
                ForScreenButton := false;
        end else if Rec.Type = Rec.Type::"HR Transfer" then begin
            if Rec."Approval Status" in [Rec."Approval Status"::Open, Rec."Approval Status"::" "] then
                ForScreenButton := true
            else
                ForScreenButton := false;
        end;

        case Rec."Approval Status" of
            Rec."Approval Status"::Open:
                ForOpen := true;
            Rec."Approval Status"::"Pending Approval":
                ForPending := true;
            Rec."Approval Status"::Recommended:
                ForRecommend := true;
            Rec."Approval Status"::Reviewed:
                begin
                    ForRecommend := true;
                    ForReview := true;
                end;
            Rec."Approval Status"::Approved, Rec."Approval Status"::"On Hold":
                begin
                    ForApprove := true;
                    ForRecommend := true;
                    ForScreen := true;
                    ForReview := true;
                end;
            Rec."Approval Status"::Screened:
                begin
                    ForRecommend := true;
                    ForScreen := true;
                    ForReview := true;
                end;

            Rec."Approval Status"::Acknowledged:
                begin
                    ForApprove := true;
                    ForAck := true;
                    ForRecommend := true;
                    ForScreen := true;
                    ForReview := true;
                end;
        end;

        case Rec."Deputation On (To)" of
            Rec."Deputation On (To)"::"Extension Counter":
                begin
                    BranchEdit := false;
                    ProvinceEdit := false;
                    SubProvinceEdit := false;
                    ExtensionCounterEdit := true;
                    UnitEdit := false;
                    DepartEdit := false;
                end;
            Rec."Deputation On (To)"::Branch:
                begin
                    BranchEdit := true;
                    ProvinceEdit := false;
                    SubProvinceEdit := false;
                    ExtensionCounterEdit := false;
                    UnitEdit := false;
                    DepartEdit := false;
                end;
            Rec."Deputation On (To)"::Province:
                begin
                    BranchEdit := false;
                    ProvinceEdit := true;
                    SubProvinceEdit := false;
                    ExtensionCounterEdit := false;
                    UnitEdit := false;
                    DepartEdit := false;
                end;
            Rec."Deputation On (To)"::"Sub Province":
                begin
                    BranchEdit := false;
                    ProvinceEdit := false;
                    SubProvinceEdit := true;
                    ExtensionCounterEdit := false;
                    UnitEdit := false;
                    DepartEdit := false;
                end;
            Rec."Deputation On (To)"::Unit:
                begin
                    BranchEdit := false;
                    ProvinceEdit := false;
                    SubProvinceEdit := false;
                    ExtensionCounterEdit := false;
                    UnitEdit := true;
                    DepartEdit := false;
                end;

            Rec."Deputation On (To)"::Department:
                begin
                    BranchEdit := false;
                    ProvinceEdit := false;
                    SubProvinceEdit := false;
                    ExtensionCounterEdit := false;
                    UnitEdit := false;
                    DepartEdit := true;
                end;
        end;

        if Rec."Transfer Type" = Rec."Transfer Type"::"Cross Transfer" then begin
            ProvinceEdit := true;
            FunctionalEdit := true;
            BranchEdit := true;
            DepartEdit := true;
            UnitEdit := true;
        end;

        if Rec.Type = Rec.Type::"HR Transfer" then begin
            ForReview := true;
            if Rec."Approval Status" in [Rec."Approval Status"::Open, Rec."Approval Status"::" "] then
                ForOpen := true;
        end;
    end;

    local procedure GetTransferName()
    var
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        DepartVar: Record Department;
        ProvinceVar: Record Province;
        SubProvinceVar: Record "Sub Province";
        EmpHie: Record "Employee Hierarchy Master";
    begin
        Clear(BranchName);
        Clear(BranchNameTo);
        Clear(DepartmentNameTo);
        Clear(DepartmentName);
        Clear(ProvinceName);
        Clear(ProvinceNameTo);
        Clear(SubProvinceName);
        Clear(SubProvinceNameTo);
        Clear(UnitNameTo);
        Clear(UnitName);
        Clear(ExtensionName);
        Clear(ExtensionNameTo);
        GLSetup.Get;

        if FunctionalTitle.Get(Rec."Functional Title") then
            FunctionalDescFrom := FunctionalTitle.Description;
        if FunctionalTitle.Get(Rec."Functional Title (To)") then
            FunctionalDescTo := FunctionalTitle.Description;

        if DimValue.Get(GLSetup."Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code") then
            BranchName := DimValue.Name;

        if DimValue.Get(GLSetup."Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code (To)") then
            BranchNameTo := DimValue.Name;

        if DepartVar.Get(Rec.Department) then
            DepartmentName := DepartVar.Name;

        if DepartVar.Get(Rec."Department Code (To)") then
            DepartmentNameTo := DepartVar.Name;

        if ProvinceVar.Get(Rec."Province Code") then
            ProvinceName := ProvinceVar.Description;

        if ProvinceVar.Get(Rec."Province Code (To)") then
            ProvinceNameTo := ProvinceVar.Description;

        SubProvinceVar.Reset;
        SubProvinceVar.SetRange(Code, Rec."Sub Province Code");
        if SubProvinceVar.FindFirst then
            SubProvinceName := SubProvinceVar.City;

        SubProvinceVar.Reset;
        SubProvinceVar.SetRange(Code, Rec."Sub Province Code (To)");
        if SubProvinceVar.FindFirst then
            SubProvinceNameTo := SubProvinceVar.City;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::Unit);
        EmpHie.SetRange(Code, Rec."Unit Code");
        if EmpHie.FindFirst then
            UnitName := EmpHie.Description;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::Unit);
        EmpHie.SetRange(Code, Rec."Unit (To)");
        if EmpHie.FindFirst then
            UnitNameTo := EmpHie.Description;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
        EmpHie.SetRange(Code, Rec."Extension Counter Code");
        if EmpHie.FindFirst then
            ExtensionName := EmpHie.Description;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
        EmpHie.SetRange(Code, Rec."Extension Counter (To)");
        if EmpHie.FindFirst then
            ExtensionNameTo := EmpHie.Description;
    end;

    procedure GetTransferEditibility()
    begin
        TransferCategoryEditable := Rec."Transfer Category" in [Rec."Transfer Category"::Officiating, Rec."Transfer Category"::"Temporary"];
    end;

    local procedure OnNewTransferRecord()
    begin
        Rec.FilterGroup(2);
        TypeFilter := Rec.GetFilter(Type);
        Rec.FilterGroup(0);
        case TypeFilter of
            Format(Rec.Type::"Employee Transfer"):
                Rec.Type := Rec.Type::"Employee Transfer";

            Format(Rec.Type::"HR Transfer"):
                Rec.Type := Rec.Type::"HR Transfer";
        end;
        Rec."Approval Status" := Rec."Approval Status"::Open;
        HRSetup.Get;
        Employee.Reset;
        Employee.SetRange("Functional Title", HRSetup."HR Head Functional Title");
        Employee.SetRange("Department Code", HRSetup."HR Department Code");
        if Employee.FindFirst then
            Rec.Validate("Approver Code", Employee."No.");
    end;
}
