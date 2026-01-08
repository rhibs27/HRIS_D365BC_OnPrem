page 50265 "Appraisal KRA Master"
{
    ApplicationArea = BasicHR;
    PageType = List;
    SourceTable = "Appraisal KRA Master";
    UsageCategory = Lists;
    Caption = 'Appraisal KRA Master';
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
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Employment Type"; Rec."Employment Type")
                {
                    ApplicationArea = All;
                    Editable = Rec.Type = Rec.Type::"KRA Master";
                }
                field("Check Date From"; Rec."Check Date From")
                {
                    ToolTip = 'Specifies the date to check service period from (Date of Employment or Confirmation Date).';
                    ApplicationArea = All;
                    Editable = Rec.Type = Rec.Type::"KRA Master";
                }
                field("Minimum Service Period"; Rec."Minimum Service Period")
                {
                    ToolTip = 'Specifies the minimum service period required for this KRA.';
                    ApplicationArea = All;
                    Editable = Rec.Type = Rec.Type::"KRA Master";
                }
            }
        }
    }

}