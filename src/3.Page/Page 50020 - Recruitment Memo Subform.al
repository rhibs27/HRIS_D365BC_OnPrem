page 50020 "Recruitment Memo Subform"
{
    // //ratan 1.11.2021 provinance visible condition added

    AutoSplitKey = true;
    DeleteAllowed = true;
    PageType = ListPart;
    SourceTable = "Recruitement Memo Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Funtional Title"; Rec."Funtional Title")
                {
                    ToolTip = 'Specifies the value of the Funtional Title field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec.Type = Rec.Type::External then
                            ProvinanceVisible := false
                        else
                            ProvinanceVisible := true;
                        CurrPage.Update;
                    end;
                }
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    ToolTip = 'Specifies the value of the Salary Level Code field.';
                    ApplicationArea = All;
                }
                field("Salary Level Description"; Rec."Salary Level Description")
                {
                    ToolTip = 'Specifies the value of the Salary Level Description field.';
                    ApplicationArea = All;
                }
                field(Location; Rec.Location)
                {
                    ToolTip = 'Specifies the value of the Location field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec.Type = Rec.Type::External then
                            ProvinanceVisible := false
                        else
                            ProvinanceVisible := true;
                        CurrPage.Update;
                    end;
                }
                field("Required No."; Rec."Required No.")
                {
                    ToolTip = 'Specifies the value of the Required No. field.';
                    ApplicationArea = All;
                }
                field("Province Code"; Rec."Province Code")
                {
                    Visible = ProvinanceVisible;
                    ToolTip = 'Specifies the value of the Province Code field.';
                    ApplicationArea = All;
                }
                field("Province Name"; Rec."Province Name")
                {
                    Visible = ProvinanceVisible;
                    ToolTip = 'Specifies the value of the Province Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Type = Rec.Type::External then
            ProvinanceVisible := false
        else
            ProvinanceVisible := true;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.Type = Rec.Type::External then
            ProvinanceVisible := false
        else
            ProvinanceVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        RecruitementMemo.Reset;
        if RecruitementMemo.Get(Rec."Memo No.") then
            Rec.Type := RecruitementMemo.Type;

        if Rec.Type = Rec.Type::External then
            ProvinanceVisible := false
        else
            ProvinanceVisible := true;
    end;

    trigger OnOpenPage()
    begin

        //ProvinanceVisible := TRUE;
        if (Rec."Memo No." <> '') and (Rec."Line No." <> 0) then begin
            RecruitHdr.Get(Rec."Memo No.");
            if RecruitHdr.Type = RecruitHdr.Type::External then
                ProvinanceVisible := false
        end
        else
            ProvinanceVisible := true;
    end;

    var
        RecruitementMemo: Record "Recruitement Memo";
        ProvinanceVisible: Boolean;
        RecruitHdr: Record "Recruitement Memo";
}
