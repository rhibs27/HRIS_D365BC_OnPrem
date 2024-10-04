page 33020028 "Access Control Selection"
{
    // version Access Control 1.00

    PageType = List;
    SourceTable = Employee;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Selected; Selected)
                {
                    ToolTip = 'Specifies the value of the Selected field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Selected then
                            InsertSelectedEmp(Rec."No.")
                        else
                            DeleteSelectedEmp(Rec."No.");
                    end;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Salary Level"; Rec."Salary Level")
                {
                    ToolTip = 'Specifies the value of the Salary Level field.';
                    ApplicationArea = All;
                }
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        TempEmpVar.Reset;
        TempEmpVar.SetRange("No.", Rec."No.");
        if TempEmpVar.FindFirst then
            Selected := true
        else
            Selected := false;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        TempEmpVar.Reset;
        Clear(LineNo);
        if TempEmpVar.Find('-') then
            repeat
                EmpVar.Get(TempEmpVar."No.");
                AccessControlDetails.Reset;
                AccessControlDetails.SetRange(Type, AccessControlDetails.Type::"Funtional Title");
                AccessControlDetails.SetRange(Code, EmpVar."Functional Title");
                if AccessControlDetails.Find('-') then
                    repeat
                        LineNo += 10000;
                        AccessControlLine.Init;
                        AccessControlLine.Validate("Document No.", DocNo);
                        AccessControlLine.Validate("Line No.", LineNo);
                        AccessControlLine.Validate("Employee No.", EmpVar."No.");
                        AccessControlLine.Validate("Employee Name", EmpVar."Full Name");
                        AccessControlLine.Validate(Status, AccessControlLine.Status::open);
                        AccessControlLine.Validate("Access Type", AccessControlLine."Access Type"::Grant);
                        AccessControlLine.Validate("System Type", AccessControlDetails."System Type Code");
                        AccessControlLine.Insert;
                    until AccessControlDetails.Next = 0;
            until TempEmpVar.Next = 0;
    end;

    var
        Selected: Boolean;
        DocNo: Code[20];
        TempEmpVar: Record Employee temporary;
        EmpVar: Record Employee;
        LineNo: Integer;
        AccessControlLine: Record "Access Control Request Line";
        AccessControlDetails: Record "Access Control Details";

    procedure SetDocNo(DocumentNo: Code[20])
    begin
        DocNo := DocumentNo;
    end;

    local procedure InsertSelectedEmp(EmpNo: Code[20])
    begin
        TempEmpVar.Init;
        TempEmpVar.Validate("No.", EmpNo);
        TempEmpVar.Insert;
    end;

    local procedure DeleteSelectedEmp(EmpNo: Code[20])
    begin
        TempEmpVar.Reset;
        TempEmpVar.SetRange("No.", EmpNo);
        if TempEmpVar.FindFirst then
            TempEmpVar.Delete;
    end;
}
