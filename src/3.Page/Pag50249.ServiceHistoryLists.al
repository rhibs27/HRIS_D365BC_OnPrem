page 50249 "Service History Lists"
{
    Editable = false;
    PageType = List;
    SourceTable = "Employee Service History";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Service History Code"; Rec."Service History Code")
                {
                    ToolTip = 'Specifies the value of the Service History Code field.';
                    ApplicationArea = All;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Service Event"; Rec."Service Event")
                {
                    ToolTip = 'Specifies the value of the Service Event field.';
                    ApplicationArea = All;
                }
                field("Functional Title (From)"; Rec."Functional Title (From)")
                {
                    ToolTip = 'Specifies the value of the Functional Title (From) field.';
                    ApplicationArea = All;
                }
                field("Functional Title Desc. (From)"; Rec."Functional Title Desc. (From)")
                {
                    ToolTip = 'Specifies the value of the Functional Title Desc. (From) field.';
                    ApplicationArea = All;
                }
                field("Salary Level (From)"; Rec."Salary Level (From)")
                {
                    ToolTip = 'Specifies the value of the Salary Level (From) field.';
                    ApplicationArea = All;
                }
                field("Salary level Desc. (From)"; Rec."Salary level Desc. (From)")
                {
                    ToolTip = 'Specifies the value of the Salary level Desc. (From) field.';
                    ApplicationArea = All;
                }
                field("Deputation On(From)"; Rec."Deputation On(From)")
                {
                    ToolTip = 'Specifies the value of the Deputation On(From) field.';
                    ApplicationArea = All;
                }
                field("Deputation Code (From)"; Rec."Deputation Code (From)")
                {
                    ToolTip = 'Specifies the value of the Deputation Code (From) field.';
                    ApplicationArea = All;
                }
                field("Deputation Value (From)"; Rec."Deputation Value (From)")
                {
                    ToolTip = 'Specifies the value of the Deputation Value (From) field.';
                    ApplicationArea = All;
                }
                field("Functional Title (To)"; Rec."Functional Title (To)")
                {
                    ToolTip = 'Specifies the value of the Functional Title (To) field.';
                    ApplicationArea = All;
                }
                field("Functional Title Desc. (To)"; Rec."Functional Title Desc. (To)")
                {
                    ToolTip = 'Specifies the value of the Functional Title Desc. (To) field.';
                    ApplicationArea = All;
                }
                field("Salary Level (To)"; Rec."Salary Level (To)")
                {
                    ToolTip = 'Specifies the value of the Salary Level (To) field.';
                    ApplicationArea = All;
                }
                field("Salary Level Desc. (To)"; Rec."Salary Level Desc. (To)")
                {
                    ToolTip = 'Specifies the value of the Salary Level Desc. (To) field.';
                    ApplicationArea = All;
                }
                field("Deputation On (To)"; Rec."Deputation On (To)")
                {
                    ToolTip = 'Specifies the value of the Deputation On (To) field.';
                    ApplicationArea = All;
                }
                field("Deputation Code (To)"; Rec."Deputation Code (To)")
                {
                    ToolTip = 'Specifies the value of the Deputation Code (To) field.';
                    ApplicationArea = All;
                }
                field("Deputation Value (To)"; Rec."Deputation Value (To)")
                {
                    ToolTip = 'Specifies the value of the Deputation Value (To) field.';
                    ApplicationArea = All;
                }
                field("Salary Grade (From)"; Rec."Salary Grade (From)")
                {
                    ToolTip = 'Specifies the value of the Salary Grade (From) field.';
                    ApplicationArea = All;
                }
                field("Salary Grade (To)"; Rec."Salary Grade (To)")
                {
                    ToolTip = 'Specifies the value of the Salary Grade (To) field.';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = All;
                }
                field("Outstation Eligible"; Rec."Outstation Eligible")
                {
                    ToolTip = 'Specifies the value of the Outstation Eligible field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Created by"; Rec."Created by")
                {
                    ToolTip = 'Specifies the value of the Created by field.';
                    ApplicationArea = All;
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ToolTip = 'Specifies the value of the Created DateTime field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Effective Date");
    end;
}
