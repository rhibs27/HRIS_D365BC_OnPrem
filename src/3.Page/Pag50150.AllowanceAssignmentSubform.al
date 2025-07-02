page 50150 "Allowance Assignment Subform"
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
                //Editable = FormEditable;
                field("No."; Rec."No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = True;
                    Editable = False;
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
                field("From Date"; Rec."From Date")
                {
                    Caption = 'Date';
                    ToolTip = 'Specifies the value of the Date field.';
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
                field("Substitute Type"; Rec."Substitute Type")
                {
                    ToolTip = 'Specifies the value of the Is Substitute field.';
                    ApplicationArea = All;
                }
                field("Substitute of Line No."; Rec."Substitute of Line No.")
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
                Visible = DocumentApproved;

                trigger OnAction()
                var
                    AllowanceLineTemp: Record "Allowance Assignment Line" temporary;
                begin
                    Rec.TestField("Substitute type", rec."Substitute Type"::" ");
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    AllowanceLineTemp.Reset;
                    AllowanceLineTemp.SetRange("No.", Rec."No.");
                    AllowanceLineTemp.SetRange("Substitute of Line No.", Rec."Line No.");
                    AllowanceLineTemp.SetRange("Substitute Type", AllowanceLineTemp."Substitute Type"::"Added as Substitute");
                    AllowanceLineTemp.SetRange("Employee Code", '');
                    if not AllowanceLineTemp.FindFirst then begin
                        AllowanceLineTemp.Reset;
                        AllowanceLineTemp.Init;
                        AllowanceLineTemp."No." := Rec."No.";
                        AllowanceLineTemp."Substitute type" := AllowanceLineTemp."Substitute type"::"Added as Substitute";
                        AllowanceLineTemp."Substitute of Line No." := Rec."Line No.";
                        AllowanceLineTemp."Allowance Type" := Rec."Allowance Type";
                        AllowanceLineTemp.Type := rec.Type;
                        AllowanceLineTemp.Code := rec.code;
                        AllowanceLineTemp.Panel := rec.Panel;
                        // AllowanceLineTemp."Approval Status" := Rec."Approval Status"::Approved;
                        AllowanceLineTemp."From Date" := rec."From Date";
                        AllowanceLineTemp."To Date" := rec."To Date";
                        AllowanceLineTemp.Insert();
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
            action("Allowance In Range")
            {
                Image = Insert;
                ToolTip = 'Executes the Substitute action.';
                ApplicationArea = All;
                Visible = DocumentOpen;

                trigger OnAction()
                var
                    FilterPage: FilterPageBuilder;
                    AllowanceLine: Record "Allowance Assignment Line";
                    FromDate, ToDate : Date;
                    AllowanceType, EmployeeCode : Code[20];
                    panel: Enum panel;
                    AllowanceAssignmentHeader: Record "Allowance Assignment Header";
                begin
                    IF AllowanceAssignmentHeader.Get(Rec."No.") THEN
                        if AllowanceAssignmentHeader."Approval Status" = AllowanceAssignmentHeader."Approval Status"::Open then begin
                            FilterPage.AddRecord('Select Employee Details', AllowanceLine);
                            FilterPage.AddField('Select Employee Details', AllowanceLine."From Date");
                            FilterPage.AddField('Select Employee Details', AllowanceLine."To Date");
                            FilterPage.AddField('Select Employee Details', AllowanceLine."Employee Code");
                            FilterPage.AddField('Select Employee Details', AllowanceLine."Allowance Type");
                            if FilterPage.RunModal() then begin
                                AllowanceLine.SetView(FilterPage.GetView('Select Employee Details'));
                                Evaluate(FromDate, AllowanceLine.GetFilter("From Date"));
                                Evaluate(ToDate, AllowanceLine.GetFilter("To Date"));
                                Evaluate(AllowanceType, AllowanceLine.GetFilter("Allowance Type"));
                                Evaluate(EmployeeCode, AllowanceLine.GetFilter("Employee Code"));
                            end;
                            AllowanceAssignmentMgt.InsertAllowanceLine(rec."No.", AllowanceType, panel::" ", EmployeeCode, FromDate, ToDate);
                            CurrPage.Update();
                        end;
                end;
            }
            action("Approve Substitute")
            {
                Image = Approve;
                ToolTip = 'Executes the Approve Substitute action.';
                ApplicationArea = All;
                Visible = DocumentApproved;
                trigger OnAction()
                var
                    AllowanceLine1: Record "Allowance Assignment Line";
                begin
                    Rec.TestField("Substitute Type", Rec."Substitute Type"::"Added as Substitute");
                    Rec.TestField("Approval Status", Rec."Approval Status"::"Pending Approval");
                    Rec.Validate("Approval Status", Rec."Approval Status"::Approved);
                    AllowanceAssignmentMgt.InsertAllowanceAssignmentDayInAttendance(Rec);
                    AllowanceAssignmentMgt.RemoveAllowanceAssignmentDayInAttendance(Rec."No.", rec."Substitute of Line No.");
                    Rec.Modify();
                    Message('Substitute Allowance is Approved');
                end;
            }
            action("Reject Substitute")
            {
                Image = Approve;
                ToolTip = 'Executes the Reject Substitute action.';
                ApplicationArea = All;
                Visible = DocumentApproved;
                trigger OnAction()
                var
                    AllowanceLine1: Record "Allowance Assignment Line";
                begin
                    Rec.TestField("Substitute Type", Rec."Substitute Type"::"Added as Substitute");
                    Rec.TestField("Approval Status", Rec."Approval Status"::"Pending Approval");
                    Rec.Validate("Approval Status", Rec."Approval Status"::Rejected);
                    if AllowanceLine1.Get(Rec."No.", Rec."Substitute of Line No.") then begin
                        AllowanceLine1."Substitute Type" := Rec."Substitute Type"::" ";
                        AllowanceLine1."Approved Date" := Today;
                        AllowanceLine1.Modify();
                    end;
                    rec.Modify();
                    Message('Substitute Allowance is Rejected');
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
        DocumentOpen: Boolean;
        DocumentApproved: Boolean;
        FormEditable: Boolean;
        Typefilter: Text;
        AllowanceAssignmentMgt: Codeunit "Allowance Assignment Mgt";

    procedure _SetFilter(_AllowanceTypeFilter: Code[20])
    begin
        AllowanceTypeFilter := _AllowanceTypeFilter;
        Rec.SetFilter("Allowance Type", AllowanceTypeFilter);
        CurrPage.Update;
    end;

    local procedure SetLayout()
    var
        AllowanceHeader: Record "Allowance Assignment Header";
    begin
        ToDateEditable := true;
        if AllowanceHeader.Get(rec."No.") then begin
            DocumentOpen := AllowanceHeader."Approval Status" = AllowanceHeader."Approval Status"::Open;
            DocumentApproved := AllowanceHeader."Approval Status" = AllowanceHeader."Approval Status"::Approved;
        end;
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
