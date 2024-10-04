page 50099 "Trainer Subform"
{
    // version NIC Asia1.00,Training

    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Training Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Trainer Type"; Rec."Trainer Type")
                {
                    ToolTip = 'Specifies the value of the Trainer Type field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IsExternal := Rec."Trainer Type" = Rec."Trainer Type"::External;
                    end;
                }
                field("Trainer Date"; Rec."Trainer Date")
                {
                    ToolTip = 'Specifies the value of the Trainer Date field.';
                    ApplicationArea = All;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("Name of Organization"; Rec."Name of Organization")
                {
                    ToolTip = 'Specifies the value of the Name of Organization field.';
                    ApplicationArea = All;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("Start Time"; Rec."Start Time")
                {
                    ToolTip = 'Specifies the value of the Start Time field.';
                    ApplicationArea = All;
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.';
                    ApplicationArea = All;
                }
                field("Total Hours"; Rec."Total Hours")
                {
                    ToolTip = 'Specifies the value of the Total Hours field.';
                    ApplicationArea = All;
                }
                field("Trainer Cost"; Rec."Trainer Cost")
                {
                    Editable = IsExternal;
                    ToolTip = 'Specifies the value of the Trainer Cost field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Trainer;
    end;

    trigger OnOpenPage()
    begin
        IsExternal := Rec."Trainer Type" = Rec."Trainer Type"::External;
    end;

    var
        [InDataSet]
        IsExternal: Boolean;
}
