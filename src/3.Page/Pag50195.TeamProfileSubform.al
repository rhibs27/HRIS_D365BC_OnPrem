page 50195 "Team Profile Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Team Profile Line";
    Caption = 'Lines';
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type.';
                }
                field("Org. Structuire Code"; Rec."Org. Structuire Code")
                {
                    ToolTip = 'Specifies the value of the Organization Structure Code field.', Comment = '%';
                }

                field("View Birthday"; Rec."View Birthday")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if birthday view is enabled.';
                }
                field("View Employees Leave"; Rec."View Employees Leave")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if employees leave view is enabled.';
                }
                field("View Employee List"; Rec."View Employee List")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if employee list view is enabled.';
                }
                field("View Employee Card"; Rec."View Employee Card")
                {
                    ToolTip = 'Specifies the value of the View Employee Card field.', Comment = '%';
                }

                field("View Employee History"; Rec."View Employee History")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if employee history view is enabled.';
                }
                field("View Attendance"; Rec."View Attendance")
                {
                    ToolTip = 'Specifies the value of the View Attendance field.', Comment = '%';
                }
            }
        }
    }

    var
        TypeFilterEditable: Boolean;

    trigger OnAfterGetRecord()
    begin
        SetTypeFilterEditable();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetTypeFilterEditable();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec.type in [Rec.Type::Prov, Rec.Type::Branch, Rec.Type::Dept, Rec.Type::Unit, Rec.Type::"Ext Counter"] then
            Rec.TestField("Org. Structuire Code");
    end;

    local procedure SetTypeFilterEditable()
    begin
        TypeFilterEditable := Rec."Type" in [Rec."Type"::Prov, Rec."Type"::Branch, Rec."Type"::Dept];
    end;
}
