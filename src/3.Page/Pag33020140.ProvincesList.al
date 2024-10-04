page 33020140 "Provinces List"
{
    ApplicationArea = All;
    Caption = 'Provinces List';
    PageType = List;
    SourceTable = Province;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Check; Check)
                {
                    ApplicationArea = All;
                    Visible = IsForBaseCalendar;
                    trigger OnValidate()
                    begin
                        InserttoTempProvience;
                    end;
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Sol ID"; Rec."Sol ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sol ID field.', Comment = '%';
                }
                field("Posting Region"; Rec."Posting Region")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Region field.', Comment = '%';
                }
                field("Inside/Outside Valley"; Rec."Inside/Outside Valley")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inside/Outside Valley field.', Comment = '%';
                }
                field("Reporting Category"; Rec."Reporting Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reporting Category field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage()

    begin
        Rec.SetRange(Blocked, false); //Min
    end;

    trigger OnAfterGetRecord()
    begin
        Check := CheckMark(Rec.Code);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean

    begin
        Clear(ProvText);
        Clear(TempProvience);
        if TempProvience.Find('-') then
            repeat
                if ProvText = '' then
                    ProvText := TempProvience.Code
                else
                    ProvText += '|' + TempProvience.Code;
            until TempProvience.Next = 0;
        TempProvience.DeleteAll;
    end;

    trigger OnAfterGetCurrRecord()

    begin
        TempProvience.Reset;
        TempProvience.SetRange(Code, Rec.Code);
        if TempProvience.FindFirst then
            Check := true
        else
            Check := false;
    end;

    var
        IsForBaseCalendar: Boolean;
        Check: Boolean;
        ProvText: Text[150];
        TempProvience: Record Province temporary;

    procedure ForBaseCalendar();
    begin
        IsForBaseCalendar := true;
    end;

    procedure ReturnProvText(): Text;
    begin
        exit(ProvText);
    end;

    local procedure InserttoTempProvience();
    begin
        if Check then begin
            TempProvience.Reset;
            TempProvience.SetRange(Code, Rec.Code);
            if not TempProvience.FindFirst then begin
                TempProvience.Init;
                TempProvience.Validate(Code, Rec.Code);
                TempProvience.Insert;
            end;
        end else begin
            TempProvience.Reset;
            TempProvience.SetRange(Code, Rec.Code);
            if TempProvience.FindFirst then
                TempProvience.Delete;
        end;
    end;

    procedure InitProvinText(InitProvinText: Text);
    begin
        ProvText := InitProvinText;
        if ProvText <> '' then
            InsertTempProv;
    end;

    procedure InsertTempProv();
    var
        Province: Record Province;
    begin
        Province.Reset;
        Province.SetFilter(Code, ProvText);
        if Province.Find('-') then
            repeat
                TempProvience.Init;
                TempProvience.Validate(Code, Province.Code);
                TempProvience.Insert;
            until Province.Next = 0;
    end;

    local procedure CheckMark(varcode: Code[20]): Boolean;
    begin
        TempProvience.Reset;
        TempProvience.SetRange(Code, varcode);
        if TempProvience.FindFirst then
            exit(true);
    end;
}
