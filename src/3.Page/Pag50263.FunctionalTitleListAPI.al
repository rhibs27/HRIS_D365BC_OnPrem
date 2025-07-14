page 50263 "Functional Title List API"
{
    // version HR Transfer

    // Pradhan
    //     //Inserting to temp table     12th Jan 2020
    //     //Deleting from temp table    12th Jan 2020
    //     //Checking if selected        12th Jan 2020

    EntityName = 'FunctionalTitle';
    EntitySetName = 'FunctionalTitles';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Functional Title";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code) { }
                field(Description; Rec.Description) { }
                field(Blocked; Rec.Blocked) { }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        Selected := CheckSelected(Rec.Code);
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Blocked, false); //Min
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if ShowSelected then begin
            Clear(FunctionalTitleText);
            TempFunctTitle.Reset;
            if TempFunctTitle.Find('-') then
                repeat
                    if FunctionalTitleText = '' then
                        FunctionalTitleText := TempFunctTitle.Code
                    else
                        FunctionalTitleText += '|' + TempFunctTitle.Code;
                until TempFunctTitle.Next = 0;
        end;
    end;

    var
        Selected: Boolean;
        ShowSelected: Boolean;
        FunctTitle: Record "Functional Title";
        TempFunctTitle: Record "Functional Title" temporary;
        FunctionalTitleText: Text;

    procedure AssignShowSelected()
    begin
        ShowSelected := true;
    end;

    procedure InsertFunctTitle(FunctTitleText: Text)
    begin
        //Inserting to temp table
        if FunctTitleText = '' then
            exit;
        FunctTitle.Reset;
        FunctTitle.SetFilter(Code, FunctTitleText);
        if FunctTitle.Find('-') then
            repeat
                TempFunctTitle.Init;
                TempFunctTitle.Validate(Code, FunctTitle.Code);
                TempFunctTitle.Insert;
            until FunctTitle.Next = 0;
    end;

    local procedure CheckSelected(FunctTitleText: Text): Boolean
    begin
        //Checking if selected
        TempFunctTitle.Reset;
        TempFunctTitle.SetRange(Code, FunctTitleText);
        if TempFunctTitle.FindFirst then
            exit(true);
    end;

    local procedure DeleteUnselected(FunctTitleText: Text)
    begin
        //Deleting from temp table
        TempFunctTitle.Reset;
        TempFunctTitle.SetRange(Code, FunctTitleText);
        TempFunctTitle.Delete;
    end;

    procedure ReturnFunctTitleText(): Text
    begin
        exit(FunctionalTitleText);
    end;
}
