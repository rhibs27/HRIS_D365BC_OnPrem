page 50072 "KRA Master Setup"
{
    Caption = 'KRA Master Setup';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "KRA Master Setup";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("KRA No."; Rec."KRA No.")
                {
                    ToolTip = 'Specifies the value of the KRA No. field.';
                    ApplicationArea = All;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field(Weightage; Rec.Weightage)
                {
                    ToolTip = 'Specifies the value of the Weightage field.';
                    ApplicationArea = All;
                }
                field("Key Result Area"; Rec."Key Result Area")
                {
                    ToolTip = 'Specifies the value of the Key Result Area field.';
                    ApplicationArea = All;
                }
                field("KRA Master Name"; Rec."KRA Master Name")
                {
                    ToolTip = 'Specifies the value of the KRA Master Name field.';
                    ApplicationArea = All;
                }
                field("KRA Category"; Rec."KRA Category")
                {
                    ToolTip = 'Specifies the value of the KRA Category field.';
                    ApplicationArea = All;
                }
                field("Deputation on"; Rec."Deputation on")
                {
                    ToolTip = 'Specifies the value of the Deputation on field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Weightage Percent"; Rec."Weightage Percent")
                {
                    ToolTip = 'Specifies the value of the Weightage Percent field.';
                    ApplicationArea = All;
                }
                field("Target Assigned"; Rec."Target Assigned")
                {
                    ToolTip = 'Specifies the value of the Target Assigned field.';
                    ApplicationArea = All;
                }
                field("Actual Achievement"; Rec."Actual Achievement")
                {
                    ToolTip = 'Specifies the value of the Actual Achievement field.';
                    ApplicationArea = All;
                }
                field("Sol Id"; Rec."Sol Id")
                {
                    ToolTip = 'Specifies the value of the Sol Id field.';
                    ApplicationArea = All;
                }
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specifies the value of the Province Code field.';
                    ApplicationArea = All;
                }
                // field("Sub Province Code"; Rec."Sub Province Code")
                // {
                //     ToolTip = 'Specifies the value of the Sub Province Code field.';
                //     ApplicationArea = All;
                // }
                field("Transfer Deputation on"; Rec."Transfer Deputation on")
                {
                    ToolTip = 'Specifies the value of the Transfer Deputation on field.';
                    ApplicationArea = All;
                }
                field("Transfer Province Code"; Rec."Transfer Province Code")
                {
                    ToolTip = 'Specifies the value of the Transfer Province Code field.';
                    ApplicationArea = All;
                }
                // field("Transfer Sub Province Code"; Rec."Transfer Sub Province Code")
                // {
                //     ToolTip = 'Specifies the value of the Sub Province Code field.';
                //     ApplicationArea = All;
                // }
                field("Transfer Sol Id"; Rec."Transfer Sol Id")
                {
                    ToolTip = 'Specifies the value of the Transfer Sol Id field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
