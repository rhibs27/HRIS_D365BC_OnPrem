page 33019950 "Allowance Assignment Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Allowance Assignment Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Editable = FormEditable;
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
                field("Allowance Type"; Rec."Allowance Type")
                {
                    ToolTip = 'Specifies the value of the Allowance Type field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("From Date"; Rec."From Date")
                {
                    Caption = 'Date';
                    ToolTip = 'Specifies the value of the Date field.';
                    ApplicationArea = All;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field(Panel; Rec.Panel)
                {
                    ToolTip = 'Specifies the value of the Panel field.';
                    ApplicationArea = All;
                }
                field("Allowance Amount"; Rec."Allowance Amount")
                {
                    ToolTip = 'Specifies the value of the Allowance Amount field.';
                    ApplicationArea = All;
                }
                field("Is Substitute"; Rec."Is Substitute")
                {
                    ToolTip = 'Specifies the value of the Is Substitute field.';
                    ApplicationArea = All;
                }
                field("Substitue of Line No."; Rec."Substitue of Line No.")
                {
                    ToolTip = 'Specifies the value of the Substitue of Line No. field.';
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

    actions
    {
        area(Processing)
        {
            action(Substitute)
            {
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Substitute action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    AllowanceLineTemp: Record "Allowance Assignment Line" temporary;
                begin
                    Rec.TestField("Is Substitute", false);
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    AllowanceLineTemp.Reset;
                    AllowanceLineTemp.SetRange("Entry No.", Rec."Entry No.");
                    AllowanceLineTemp.SetRange("Substitue of Line No.", Rec."Line No.");
                    AllowanceLineTemp.SetRange("Is Substitute", true);
                    AllowanceLineTemp.SetRange("Employee Code", '');
                    if not AllowanceLineTemp.FindFirst then begin
                        AllowanceLineTemp.Reset;
                        AllowanceLineTemp.Init;
                        AllowanceLineTemp."Entry No." := Rec."Entry No.";
                        AllowanceLineTemp."Is Substitute" := true;
                        AllowanceLineTemp."Substitue of Line No." := Rec."Line No.";
                        AllowanceLineTemp."Allowance Type" := Rec."Allowance Type";
                        AllowanceLineTemp.Insert(true);
                        /*
                        AllowanceLineTemp."Employee Code" := "Employee Code";
                        AllowanceLineTemp."From Date" := "From Date";
                        AllowanceLineTemp."To Date" := "To Date";
                        AllowanceLineTemp."Employee Name" := "Employee Name";
                        AllowanceLineTemp.MODIFY(TRUE);*/
                    end;
                    Page.Run(Page::"Allowance Assign. Substitute", AllowanceLineTemp);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetLayout();
    end;

    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Allowance Type" := AllowanceTypeFilter;
        Rec.FilterGroup(4);
        Typefilter := Rec.GetFilter(Type);
        Rec.Code := Rec.GetFilter(Code);
        Rec.FilterGroup(0);
        case Typefilter of
            Format(Rec.Type::Branch):
                Rec.Type := Rec.Type::Branch;

            Format(Rec.Type::"Extension Counter"):
                Rec.Type := Rec.Type::"Extension Counter";
        end;
        SetLayout();
    end;

    var
        AllowanceTypeFilter: Code[20];
        [InDataSet]
        ToDateEditable: Boolean;
        FormEditable: Boolean;
        Typefilter: Text;

    procedure _SetFilter(_AllowanceTypeFilter: Code[20])
    begin
        AllowanceTypeFilter := _AllowanceTypeFilter;
        Rec.SetFilter("Allowance Type", AllowanceTypeFilter);
        CurrPage.Update;
    end;

    local procedure SetLayout()
    begin
        ToDateEditable := true;

        if Rec."Allowance Type" = 'FRIDAY COUNTER' then
            ToDateEditable := false;

        FormEditable := Rec."Approval Status" <> Rec."Approval Status"::Approved;
        /*

        BaseCalendarChange.RESET;
        BaseCalendarChange.SETRANGE(Nonworking, TRUE);
        BaseCalendarChange.SETRANGE(Date, "From Date");
        IF BaseCalendarChange.FINDFIRST THEN
          ToDateEditable := FALSE;
        */
    end;

    procedure GetSelectedLines(var _AllowanceLine: Record "Allowance Assignment Line")
    begin
        CurrPage.SetSelectionFilter(_AllowanceLine);
    end;
}
