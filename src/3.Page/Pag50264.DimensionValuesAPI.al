// page 50264 "Dimension Values API"
// {
//     // version HR Transfer

//     // Pradhan
//     //     //Inserting to temp table     12th Jan 2020
//     //     //Deleting from temp table    12th Jan 2020
//     //     //Checking if selected        12th Jan 2020

//     Caption = 'Dimension Values API';
//     DataCaptionFields = "Dimension Code";
//     EntityName = 'DimensionValueEntity';
//     EntitySetName = 'DimensionValuesEntities';
//     PageType = API;
//     DelayedInsert = true;
//     APIGroup = 'HRMS';
//     APIPublisher = 'Agile';
//     SourceTable = "Dimension Value";
//     APIVersion = 'v2.0';

//     layout
//     {
//         area(Content)
//         {
//             repeater(Control1)
//             {
//                 IndentationColumn = NameIndent;
//                 IndentationControls = Name;
//                 ShowCaption = false;
//                 field("Code"; Rec.Code)
//                 {
//                     ApplicationArea = Dimensions;
//                     Style = Strong;
//                     StyleExpr = Emphasize;
//                     ToolTip = 'Specifies the code for the dimension value.';
//                 }
//                 field(Name; Rec.Name)
//                 {
//                     ApplicationArea = Dimensions;
//                     Style = Strong;
//                     StyleExpr = Emphasize;
//                     ToolTip = 'Specifies a descriptive name for the dimension value.';
//                 }
//                 field(Blocked; Rec.Blocked)
//                 {
//                     ApplicationArea = Dimensions;
//                     ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
//                 }
//                 field(DimensionCode; Rec."Dimension Code") { }
//                 field(SolID; Rec."Sol ID") { }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("Indent Dimension Values")
//                 {
//                     ApplicationArea = Dimensions;
//                     Caption = 'Indent Dimension Values';
//                     Image = Indent;
//                     RunObject = codeunit "Dimension Value-Indent";
//                     RunPageOnRec = true;
//                     ToolTip = 'Indent dimension values between a Begin-Total and the matching End-Total one level to make the list easier to read.';
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         NameIndent := 0;
//         FormatLine;
//         Selected := CheckSelected(Rec.Code);
//     end;

//     trigger OnOpenPage()
//     var
//         DimensionCode: Code[20];
//     begin
//         if Rec.GetFilter("Dimension Code") <> '' then
//             DimensionCode := Rec.GetRangeMin("Dimension Code");
//         if DimensionCode <> '' then begin
//             Rec.FilterGroup(2);
//             Rec.SetRange("Dimension Code", DimensionCode);
//             Rec.FilterGroup(0);
//         end;
//     end;

//     trigger OnQueryClosePage(CloseAction: Action): Boolean
//     begin
//         if ShowSelected then begin
//             Clear(DimText);
//             TempDimValue.Reset;
//             if TempDimValue.Find('-') then
//                 repeat
//                     if DimText = '' then
//                         DimText := TempDimValue.Code
//                     else
//                         DimText += '|' + TempDimValue.Code;
//                 until TempDimValue.Next = 0;
//         end;
//     end;

//     var
//         [InDataSet]
//         Emphasize: Boolean;
//         [InDataSet]
//         NameIndent: Integer;
//         Selected: Boolean;
//         [InDataSet]
//         ShowSelected: Boolean;
//         TempDimValue: Record "Dimension Value" temporary;
//         DimValue: Record "Dimension Value";
//         GLSetup: Record "General Ledger Setup";
//         DimText: Text;

//     local procedure FormatLine()
//     begin
//         Emphasize := Rec."Dimension Value Type" <> Rec."Dimension Value Type"::Standard;
//         NameIndent := Rec.Indentation;
//     end;

//     procedure AssignShowSelected()
//     begin
//         ShowSelected := true;
//     end;

//     procedure InsertTempDimValue(DimValueText: Text)
//     begin
//         //Inserting to temp table
//         if DimValueText = '' then
//             exit;
//         GLSetup.Get;
//         DimValue.Reset;
//         DimValue.SetFilter("Dimension Code", GLSetup."Global Dimension 1 Code");
//         DimValue.SetFilter(Code, DimValueText);
//         if DimValue.Find('-') then
//             repeat
//                 TempDimValue.Init;
//                 TempDimValue.Validate("Dimension Code", DimValue."Dimension Code");
//                 TempDimValue.Validate(Code, DimValue.Code);
//                 TempDimValue.Insert;
//             until DimValue.Next = 0;
//     end;

//     local procedure CheckSelected(DimValueCode: Text): Boolean
//     begin
//         //Checking if selected
//         TempDimValue.Reset;
//         TempDimValue.SetRange(Code, DimValueCode);
//         if TempDimValue.FindFirst then
//             exit(true);
//     end;

//     local procedure DeleteUnselected(DimvalueCode: Text)
//     begin
//         //Deleting from temp table
//         TempDimValue.Reset;
//         TempDimValue.SetRange(Code, DimvalueCode);
//         if TempDimValue.FindFirst then
//             TempDimValue.Delete;
//     end;

//     procedure ReturnDimText(): Text
//     begin
//         exit(DimText);
//     end;
// }
