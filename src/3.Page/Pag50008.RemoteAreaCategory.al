page 50008 "Remote Area Category"
{
    PageType = List;
    SourceTable = "Remote Area Category";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the value of the Category field.';
                    ApplicationArea = All;
                }
                field("Remote allowance Percentage"; Rec."Remote allowance Percentage")
                {
                    ToolTip = 'Specifies the value of the Remote allowance Percentage field.';
                    ApplicationArea = All;
                }
                field("Remote Allowance Amount"; Rec."Remote Allowance Amount")
                {
                    ToolTip = 'Specifies the value of the Remote Allowance Amount field.';
                    ApplicationArea = All;
                }
                field("BM Accomodation Amount"; Rec."BM Accomodation Amount")
                {
                    ToolTip = 'Specifies the value of the BM Accomodation Amount field.';
                    ApplicationArea = All;
                }
                field("Remote Area Deduction"; Rec."Remote Area Deduction")
                {
                    ToolTip = 'Specifies the value of the Remote Area Deduction field.';
                    ApplicationArea = All;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.';
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
        area(Processing)
        {
            action("&Archive")
            {
                Image = Archive;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Archive action.';
                trigger OnAction()
                var
                    PayrollArchive: Record "Payroll Archive";
                    RecRef: RecordRef;
                begin

                    RecRef.Open(Database::"Remote Area Category");
                    RecRef.Get(Rec.RecordId);
                    PayrollArchive.RunArchive(RecRef.Number, Rec."Effective Date");
                end;
            }
        }
    }
}
