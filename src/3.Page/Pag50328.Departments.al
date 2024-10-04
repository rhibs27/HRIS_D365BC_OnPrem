page 50328 Departments
{
    ApplicationArea = All;
    Caption = 'Departments';
    PageType = List;
    SourceTable = Department;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a union code.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the union.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                }
                field("Province Code"; Rec."Province Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Province Code field.', Comment = '%';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the City field.', Comment = '%';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phone No. field.', Comment = '%';
                }
                field("No. of Members Employed"; Rec."No. of Members Employed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Members Employed field.', Comment = '%';
                }
                field("Eco-System"; Rec."Eco-System")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Eco-System field.', Comment = '%';
                }
                field("Eco-System Description"; Rec."Eco-System Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Eco-System Description field.', Comment = '%';
                }
                field("Sol ID"; Rec."Sol ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sol ID field.', Comment = '%';
                }
                field("KPI Incentive %"; Rec."KPI Incentive %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the KPI Incentive % field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage()

    begin
        Rec.SetRange(Blocked, false); //Min
        Rec.SetRange(Type, Rec.Type::Department);
    end;

    trigger OnAfterGetRecord()

    begin
        Selected := CheckSelected(Rec.Code);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)

    begin
        Rec.Type := Rec.Type::Department;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean

    begin
        if ShowSelected then begin
            Clear(DepartmentText);
            TempDepart.Reset;
            if TempDepart.Find('-') then
                repeat
                    if DepartmentText = '' then
                        DepartmentText := TempDepart.Code
                    else
                        DepartmentText += '|' + TempDepart.Code;
                until TempDepart.Next = 0;
        end;
    end;

    var
        Selected: Boolean;
        ShowSelected: Boolean;
        TempDepart: Record Department temporary;
        Depart: Record Department;
        DepartmentText: Text;

    procedure AssignShowSelected();
    begin
        ShowSelected := true;
    end;

    procedure InsertTempDepart(DepartText: Text);
    begin
        //Inserting to temp table
        if DepartText = '' then
            exit;
        Depart.Reset;
        Depart.SetFilter(Code, DepartText);
        if Depart.Find('-') then
            repeat
                TempDepart.Init;
                TempDepart.Validate(Code, Depart.Code);
                TempDepart.Insert;
            until Depart.Next = 0;
    end;

    local procedure CheckSelected(DepartText: Text): Boolean;
    begin
        //Checking if selected
        TempDepart.Reset;
        TempDepart.SetRange(Code, DepartText);
        if TempDepart.FindFirst then
            exit(true);
    end;

    local procedure DeleteUnselected(DepartText: Text);
    begin
        //Deleting from temp table
        TempDepart.Reset;
        TempDepart.SetRange(Code, DepartText);
        TempDepart.Delete;
    end;

    procedure ReturnDepartText(): Text;
    begin
        exit(DepartmentText);
    end;
}
