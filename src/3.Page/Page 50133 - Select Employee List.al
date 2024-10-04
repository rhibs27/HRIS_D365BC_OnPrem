page 50133 "Select Employee List"
{
    // version IME Remit

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Employee;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field(Select; IsSelected)
                {
                    Visible = IsTransferNotify;
                    ToolTip = 'Specifies the value of the IsSelected field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InserttoTempEmployee;
                    end;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.';
                    ApplicationArea = All;
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Company Email field.';
                    ApplicationArea = All;
                }
                field("Deputation on"; Rec."Deputation on")
                {
                    Editable = false;
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
                    Caption = 'Sub-Province Name';
                    ToolTip = 'Specifies the value of the Sub-Province Name field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("Extension Counter Name"; Rec."Extension Counter Name")
                {
                    ToolTip = 'Specifies the value of the Extension Counter Name field.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ToolTip = 'Specifies the value of the Unit Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        IsSelected := CheckMark(Rec."No.");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Clear(EmpCodeText);
        Clear(TempEmployee);
        if TempEmployee.Find('-') then
            repeat
                if EmpCodeText = '' then
                    EmpCodeText := TempEmployee."No."
                else
                    EmpCodeText += '|' + TempEmployee."No.";
            until TempEmployee.Next = 0;
        TempEmployee.DeleteAll;
    end;

    var
        IsSelected: Boolean;
        [InDataSet]
        IsTransferNotify: Boolean;
        EmpCodeText: Text;
        TempEmployee: Record Employee temporary;
        Employee: Record Employee;

    procedure ForTransferNotify()
    begin
        IsTransferNotify := true;
    end;

    procedure ReturnEmployeeText(): Text
    begin
        exit(EmpCodeText);
    end;

    local procedure InserttoTempEmployee()
    begin
        if IsSelected then begin
            TempEmployee.Reset;
            TempEmployee.SetRange("No.", Rec."No.");
            if not TempEmployee.FindFirst then begin
                TempEmployee.Init;
                TempEmployee.Validate("No.", Rec."No.");
                TempEmployee.Insert;
            end;
        end else begin
            TempEmployee.Reset;
            TempEmployee.SetRange("No.", Rec."No.");
            if TempEmployee.FindFirst then
                TempEmployee.Delete;
        end;
    end;

    procedure InitEmployeeText(InitEmpText: Text)
    begin
        EmpCodeText := InitEmpText;
        if EmpCodeText <> '' then
            InsertTempEmployee;
    end;

    procedure InsertTempEmployee()
    begin
        Employee.Reset;
        Employee.SetFilter("No.", EmpCodeText);
        if Employee.Find('-') then
            repeat
                TempEmployee.Init;
                TempEmployee.Validate("No.", Employee."No.");
                TempEmployee.Insert;
            until Employee.Next = 0;
    end;

    local procedure CheckMark(varcode: Code[20]): Boolean
    begin
        TempEmployee.Reset;
        TempEmployee.SetRange("No.", varcode);
        if TempEmployee.FindFirst then
            exit(true);
    end;
}
