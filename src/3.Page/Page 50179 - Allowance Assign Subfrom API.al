page 50179 "Allowance Assign Subfrom API"
{
    // version APINICASIA1.00

    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Allowance Assignment Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field("Allowance Type"; Rec."Allowance Type")
                {
                    ToolTip = 'Specifies the value of the Allowance Type field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TestField("Allowance Type");
                    end;
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TestField("From Date");
                    end;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TestField("Employee Code");
                    end;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TestField("To Date");
                    end;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Is Substitute"; Rec."Is Substitute")
                {
                    ToolTip = 'Specifies the value of the Is Substitute field.';
                    ApplicationArea = All;
                }
                field(Panel; Rec.Panel)
                {
                    ToolTip = 'Specifies the value of the Panel field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        GetEntryNo;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::"Pending Approval";
    end;

    local procedure GetEntryNo()
    var
        AllowanceHeader: Record "Allowance Assignment Header";
        AllowanceLine: Record "Allowance Assignment Line";
    begin
        AllowanceHeader.Reset;
        AllowanceHeader.SetCurrentKey("Entry No.");
        if Rec."Entry No." <> 0 then
            AllowanceHeader.SetRange("Entry No.", Rec."Entry No.");
        if AllowanceHeader.FindLast then begin
            Rec."Entry No." := AllowanceHeader."Entry No.";
            Rec.Code := AllowanceHeader.Code;
        end;
        AllowanceLine.Reset;
        AllowanceLine.SetRange("Entry No.", AllowanceHeader."Entry No.");
        AllowanceLine.SetCurrentKey("Entry No.", "Line No.");
        if AllowanceLine.FindLast then
            Rec."Line No." := AllowanceLine."Line No." + 10000
        else
            Rec."Line No." := 10000;
    end;
}
