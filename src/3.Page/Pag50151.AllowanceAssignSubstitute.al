page 50151 "Allowance Assign. Substitute"
{
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Allowance Assignment Line";
    SourceTableTemporary = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.';
                    ApplicationArea = All;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Creation) { }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Code);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        AllowanceLine.Copy(Rec);
        if (AllowanceLine."Employee Code" <> '') and (AllowanceLine."From Date" <> 0D)
          and (AllowanceLine."To Date" <> 0D) then begin
            AllowanceLine."Line No." := 0;
            AllowanceLine.Insert(true);
            AllowanceLine.UpdateSubstitue();
        end;
    end;

    var
        AllowanceLine: Record "Allowance Assignment Line";
}
