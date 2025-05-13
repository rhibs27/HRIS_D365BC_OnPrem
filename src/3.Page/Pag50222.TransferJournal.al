page 50222 "Transfer Journal"
{
    ApplicationArea = All;
    Caption = 'Transfer Journal';
    PageType = Worksheet;
    SourceTable = "Transfer Journal";
    UsageCategory = Tasks;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Deputation On (To)"; Rec."Deputation On (To)")
                {
                    ToolTip = 'Specifies the value of the Deputation On (To) field.', Comment = '%';
                }
                field("Province Code (To)"; Rec."Province Code (To)")
                {
                    ToolTip = 'Specifies the value of the Province Code (To) field.', Comment = '%';
                    Editable = ProvinceEdit;
                }
                field("To Branch"; Rec."To Branch")
                {
                    ToolTip = 'Specifies the value of the To Branch field.', Comment = '%';
                    Editable = BranchEdit;
                }
                field("Department Code (To)"; Rec."Department Code (To)")
                {
                    ToolTip = 'Specifies the value of the Department Code (To) field.', Comment = '%';
                    Editable = DepartmentEdit;
                }
                field("Extension Counter (To)"; Rec."Extension Counter (To)")
                {
                    ToolTip = 'Specifies the value of the Extension Counter (To) field.', Comment = '%';
                    Editable = ExtensionCounterEdit;
                }
                field("Unit (To)"; Rec."Unit (To)")
                {
                    ToolTip = 'Specifies the value of the Unit (To) field.', Comment = '%';
                    Editable = UnitEdit;
                }
                field("Functional Title (To)"; Rec."Functional Title (To)")
                {
                    ToolTip = 'Specifies the value of the Functional Title (To) field.', Comment = '%';
                    Editable = UnitEdit;
                }

                field("Transfer Type"; Rec."Transfer Type")
                {
                    ToolTip = 'Specifies the value of the Transfer Type field.', Comment = '%';
                }
                field("Transfer Category"; Rec."Transfer Category")
                {
                    ToolTip = 'Specifies the value of the Transfer Category field.', Comment = '%';
                }
                field("Transfer Effective Date"; Rec."Transfer Effective Date")
                {
                    ToolTip = 'Specifies the value of the Transfer Effective Date field.', Comment = '%';
                }
                field("Incoming Supervisior"; Rec."Incoming Supervisior")
                {
                    ToolTip = 'Specifies the value of the Incoming Supervisior field.', Comment = '%';
                }
                field("Incoming Supervisior Name"; Rec."Incoming Supervisior Name")
                {
                    ToolTip = 'Specifies the value of the Incoming Supervisior Name field.', Comment = '%';
                }
                field("Notify to"; Rec."Notify to")
                {
                    ToolTip = 'Specifies the value of the Notify to field.', Comment = '%';
                }

                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Post)
            {
                trigger OnAction()
                begin
                    TransferMgt.PostTransferInBulk(Rec);
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        SetFieldEnable
    end;

    var
        // DepartmentVisible: Boolean;
        // UnitVisible: Boolean;
        // ProvinceVisible: Boolean;
        // BranchVisible: Boolean;
        // ExtensionCounterVisible: Boolean;
        UnitEdit: Boolean;
        DepartmentEdit: Boolean;
        ExtensionCounterEdit: Boolean;
        BranchEdit: Boolean;
        ProvinceEdit: Boolean;
        TransferMgt: Codeunit "Transfer Mgt.";


    LOCAL PROCEDURE SetFieldEnable();
    BEGIN
        CASE Rec."Deputation on" OF
            Rec."Deputation on"::Branch:
                BEGIN
                    ProvinceEdit := false;
                    BranchEdit := true;
                    ExtensionCounterEdit := true;
                    DepartmentEdit := FALSE;
                    UnitEdit := FALSE;
                    // ExtensionCounterVisible := true;
                    // BranchVisible := true;
                    // ProvinceVisible := true;
                    // UnitVisible := false;
                    // DepartmentVisible := false;
                END;
            Rec."Deputation on"::Province:
                BEGIN
                    ProvinceEdit := true;
                    BranchEdit := false;
                    ExtensionCounterEdit := false;
                    DepartmentEdit := FALSE;
                    UnitEdit := FALSE;
                    // ExtensionCounterVisible := false;
                    // BranchVisible := false;
                    // ProvinceVisible := true;
                    // UnitVisible := false;
                    // DepartmentVisible := false;
                END;
            Rec."Deputation on"::Department:
                BEGIN
                    ProvinceEdit := false;
                    BranchEdit := false;
                    ExtensionCounterEdit := false;
                    DepartmentEdit := true;
                    UnitEdit := true;
                    // ExtensionCounterVisible := false;
                    // BranchVisible := false;
                    // ProvinceVisible := true;
                    // UnitVisible := true;
                    // DepartmentVisible := true;
                END;
            Rec."Deputation on"::Unit:
                BEGIN
                    ProvinceEdit := false;
                    BranchEdit := false;
                    ExtensionCounterEdit := false;
                    DepartmentEdit := true;
                    UnitEdit := true;
                    // ExtensionCounterVisible := false;
                    // BranchVisible := false;
                    // ProvinceVisible := true;
                    // UnitVisible := true;
                    // DepartmentVisible := true;
                END;
            Rec."Deputation on"::"Extension Counter":
                BEGIN
                    ProvinceEdit := false;
                    BranchEdit := true;
                    ExtensionCounterEdit := TRUE;
                    DepartmentEdit := FALSE;
                    UnitEdit := FALSE;
                    // ExtensionCounterVisible := true;
                    // BranchVisible := true;
                    // ProvinceVisible := true;
                    // UnitVisible := false;
                    // DepartmentVisible := false;
                END;
        END;
    END;
}
