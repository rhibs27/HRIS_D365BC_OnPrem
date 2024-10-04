table 33019833 "Payroll Column Configuration"
{
    // version PRM19.01.01

    // *PAYROLL 6.1.0 YURAN@AGILE*

    Caption = 'Variable Field Usage';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));

            trigger OnLookup()
            begin
                LookUpVariableUsageObject("Table No.");
                Validate("Table No.");
            end;
        }
        field(2; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));

            trigger OnLookup()
            begin
                LookUpVariableUsageField("Field No.", "Table No.");
                Validate("Field No.");
            end;
        }
        field(3; "Variable Field Code"; Code[100])
        {
            Caption = 'Variable Field Code';
            NotBlank = true;
            TableRelation = "Payroll Attributes";
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.") { }
        key(Key2; "Variable Field Code") { }
        key(Key3; "Table No.", "Variable Field Code") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        Rec.TestField("Variable Field Code")
    end;

    trigger OnModify()
    begin
        Rec.TestField("Variable Field Code")
    end;

    procedure LookUpVariableUsageObject(var ObjectID: Integer)
    var
        TempObject: Record AllObjWithCaption temporary;
        TempField: Record "Field" temporary;
        WhatToFind: Option Object,"Field";
    begin
        TempObject.Reset;
        TempObject.DeleteAll;

        WhatToFind := WhatToFind::Object;
        VariableFieldObjectNoList(TempObject, TempField, WhatToFind);

        if Page.RunModal(Page::Objects, TempObject) = Action::LookupOK then
            ObjectID := TempObject."Object ID";
    end;

    procedure VariableFieldObjectNoList(var TempObject: Record AllObjWithCaption temporary; var TempField: Record "Field" temporary; WhatToFind: Option Object,"Field")
    var
        Object: Record AllObjWithCaption;
        "Field": Record "Field";
        NumberOfObjects: Integer;
        NumberOfFields: Integer;
        TableIDArray: array[2] of Integer;
        FieldIDArray: array[2, 51] of Integer;
        Index: Integer;
        TableIndex: Integer;
    begin
        NumberOfObjects := 2;
        NumberOfFields := 51;
        Clear(TableIDArray);

        TableIDArray[1] := Database::"Payroll Line";
        if WhatToFind = WhatToFind::Field then
            FillFieldIDArray(FieldIDArray, 1, 51, 50490, 1);

        TableIDArray[2] := Database::"Level Wise Attributes";
        if WhatToFind = WhatToFind::Field then
            FillFieldIDArray(FieldIDArray, 2, 40, 50000, 1);

        if WhatToFind = WhatToFind::Object then begin
            Object.SetRange("Object Type", Object."Object Type"::Table);
            for Index := 1 to NumberOfObjects do begin
                Object.SetRange(Object."Object ID", TableIDArray[Index]);
                if Object.FindFirst then begin
                    TempObject := Object;
                    TempObject.Insert;
                end;
            end;
        end else begin
            TableIndex := 0;
            for Index := 1 to NumberOfObjects do
                if TableIDArray[Index] = TempObject."Object ID" then
                    TableIndex := Index;
            if TableIndex = 0 then
                exit;
            Field.SetRange(TableNo, TempObject."Object ID");
            for Index := 1 to NumberOfFields do begin
                if (FieldIDArray[TableIndex] [Index] <> 0) then begin
                    Field.SetRange("No.", FieldIDArray[TableIndex] [Index]);
                    if Field.FindFirst then begin
                        TempField := Field;
                        TempField.Insert;
                    end;
                end;
            end;
        end;
    end;

    procedure FillFieldIDArray(var FieldIDArray: array[2, 51] of Integer; TableID: Integer; FieldQty: Integer; StartNumber: Integer; FieldStep: Integer)
    var
        i: Integer;
    begin
        for i := 1 to FieldQty do
            FieldIDArray[TableID] [i] := StartNumber + (i - 1) * FieldStep;
    end;

    procedure LookUpVariableUsageField(var FieldID: Integer; TableID: Integer)
    var
        TempObject: Record AllObjWithCaption temporary;
        TempField: Record "Field" temporary;
        Object: Record AllObjWithCaption;
        WhatToFind: Option Object,"Field";
    begin
        TempField.Reset;
        TempField.DeleteAll;

        Object.SetRange("Object Type", Object."Object Type"::Table);
        Object.SetRange("Object ID", TableID);
        if Object.FindFirst then
            TempObject := Object;

        WhatToFind := WhatToFind::Field;
        VariableFieldObjectNoList(TempObject, TempField, WhatToFind);

        if Page.RunModal(Page::"Payroll Columns", TempField) = Action::LookupOK then
            FieldID := TempField."No.";
    end;
}
