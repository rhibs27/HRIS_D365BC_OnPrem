page 33020029 "Access Control History"
{
    // version Access Control 1.00

    Editable = false;
    PageType = List;
    SourceTable = "Access Control Request Line";
    SourceTableView = where(Status = const(approved));
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
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
                field("System Type Name"; Rec."System Type Name")
                {
                    ToolTip = 'Specifies the value of the System Type Name field.';
                    ApplicationArea = All;
                }
                field("Employee Activity Type"; Rec."Employee Activity Type")
                {
                    ToolTip = 'Specifies the value of the Employee Activity Type field.';
                    ApplicationArea = All;
                }
                field("System Category Code"; Rec."System Category Code")
                {
                    ToolTip = 'Specifies the value of the System Category Code field.';
                    ApplicationArea = All;
                }
                field("System Category Name"; Rec."System Category Name")
                {
                    ToolTip = 'Specifies the value of the System Category Name field.';
                    ApplicationArea = All;
                }
                field("Access Type"; Rec."Access Type")
                {
                    ToolTip = 'Specifies the value of the Access Type field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ToolTip = 'Specifies the value of the Approved By field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
