page 33020126 SubProvinceList
{
    ApplicationArea = All;
    Caption = 'Sub Province List';
    PageType = List;
    SourceTable = "Sub Province";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specifies the value of the Province Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Province Name"; Rec."Province Name")
                {
                    ToolTip = 'Specifies the value of the Province Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the postal code that is associated with a city.';
                    ApplicationArea = All;
                }
                field("Sol ID"; Rec."Sol ID")
                {
                    ToolTip = 'Specifies the value of the Sol ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posting Region"; Rec."Posting Region")
                {
                    ToolTip = 'Specifies the value of the Posting Region field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Inside/Outside Valley"; Rec."Inside/Outside Valley")
                {
                    ToolTip = 'Specifies the value of the Inside/Outside Valley field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reporting Category"; Rec."Reporting Category")
                {
                    ToolTip = 'Specifies the value of the Reporting Category field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Selected; Selected)
                {
                    ApplicationArea = All;
                    Visible = ShowSelected;
                    ToolTip = 'Specifies the value of the Selected field.';
                    trigger OnValidate()
                    begin
                        if Selected then
                            InsertTempSubProv(Rec.Code)      //Inserting to temp table
                        else
                            DeleteUnselected(Rec.Code);       //Deleting from temp table
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()

    begin
        Selected := CheckSelected(Rec.Code);
    end;

    trigger OnOpenPage()
    var
    begin

        Rec.SetRange(Blocked, false);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if ShowSelected then begin
            Clear(SubPovinceText);
            TempSubProv.Reset;
            if TempSubProv.Find('-') then
                repeat
                    if SubPovinceText = '' then
                        SubPovinceText := TempSubProv.Code
                    else
                        SubPovinceText += '|' + TempSubProv.Code;
                until TempSubProv.Next = 0;
        end;
    end;

    var
        Selected: Boolean;
        ShowSelected: Boolean;
        SubPovinceText: Text;
        TempSubProv: Record "Sub Province";
        SubProv: Record "Sub Province";

    procedure AssignShowSelected();
    begin
        ShowSelected := true;
    end;

    procedure InsertTempSubProv(SubProvText: Text);
    begin
        //Inserting to temp table
        if SubProvText = '' then
            exit;
        SubProv.Reset;
        SubProv.SetFilter(Code, SubProvText);
        if SubProv.Find('-') then
            repeat
                TempSubProv.Init;
                TempSubProv.Code := SubProv.Code;
                TempSubProv.Insert;
            until SubProv.Next = 0;
    end;

    local procedure CheckSelected(SubProvText: Text): Boolean;
    begin
        //Checking if selected
        TempSubProv.Reset;
        TempSubProv.SetRange(Code, SubProvText);
        if TempSubProv.FindFirst then
            exit(true);
    end;

    local procedure DeleteUnselected(SubProvText: Text);
    begin
        //Deleting from temp table
        TempSubProv.Reset;
        TempSubProv.SetRange(Code, SubProvText);
        TempSubProv.Delete;
    end;

    procedure ReturnSubProvText(): Text;
    begin
        exit(SubPovinceText);
    end;
}
