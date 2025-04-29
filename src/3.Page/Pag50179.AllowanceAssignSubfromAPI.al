page 50179 "Allowance Assign Subform API"
{
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
                field(no; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(lineNo; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
                field(type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(allowanceType; Rec."Allowance Type")
                {
                    ToolTip = 'Specifies the value of the Allowance Type field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TestField("Allowance Type");
                    end;
                }
                field(fromDate; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TestField("From Date");
                    end;
                }
                field(employeeCode; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TestField("Employee Code");
                    end;
                }
                field(employeeName; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field(toDate; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TestField("To Date");
                    end;
                }
                field(noOfDays; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field(isSubstitute; Rec."Is Substitute")
                {
                    ToolTip = 'Specifies the value of the Is Substitute field.';
                    ApplicationArea = All;
                }
                field(substituteOfLineNo; Rec."Substitute of Line No.")
                {

                }
                field(panel; Rec.Panel)
                {
                    ToolTip = 'Specifies the value of the Panel field.';
                    ApplicationArea = All;
                }
                field(approvalStatus; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     GetEntryNo;
    // end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::"open";
    end;

    // local procedure GetEntryNo()
    // var
    //     AllowanceHeader: Record "Allowance Assignment Header";
    //     AllowanceLine: Record "Allowance Assignment Line";
    // begin
    //     AllowanceHeader.Reset;
    //     AllowanceHeader.SetCurrentKey("No.");
    //     if Rec."No." <> '' then
    //         AllowanceHeader.SetRange("No.", Rec."No.");
    //     if AllowanceHeader.FindLast then begin
    //         Rec."No." := AllowanceHeader."No.";
    //         Rec.Code := AllowanceHeader.Code;
    //     end;
    //     AllowanceLine.Reset;
    //     AllowanceLine.SetRange("No.", AllowanceHeader."No.");
    //     AllowanceLine.SetCurrentKey("No.", "Line No.");
    //     if AllowanceLine.FindLast then
    //         Rec."Line No." := AllowanceLine."Line No." + 10000
    //     else
    //         Rec."Line No." := 10000;
    // end;
}
