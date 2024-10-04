page 33020096 "Unit Setup"
{
    // version KPI1.00

    PageType = List;
    SourceTable = Department;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                    ApplicationArea = All;
                }
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specifies the value of the Province Code field.';
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.';
                    ApplicationArea = All;
                }
                field("KPI Incentive %"; Rec."KPI Incentive %")
                {
                    ToolTip = 'Specifies the value of the KPI Incentive % field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(KPISetup)
            {
                Caption = 'KPI Setup';
                Image = ServiceSetup;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                // RunObject = Page kpi setup;
                ToolTip = 'Executes the KPI Setup action.';
                ApplicationArea = All;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Unit;
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(0);
        Rec.SetRange(Type, Rec.Type::Unit);
        Rec.FilterGroup(2);
    end;
}
