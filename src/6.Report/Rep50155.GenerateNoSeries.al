report 50155 "Generate No Series"
{
    ApplicationArea = All;
    Caption = 'Generate No. Series Line';
    UsageCategory = Administration;
    ProcessingOnly = true;
    dataset
    {
        dataitem("No. Series Line"; "No. Series Line")
        {

            trigger OnPreDataItem()
            begin
                ProgressWindow.Open(Text000);
                totalcount := 0;
                NoFilter := '*' + SearchString + '*';
                "No. Series Line".SETFILTER("Starting No.", NoFilter);
                if StartingDate = 0D then
                    ERROR('please select staring date!');
                MESSAGE('%1', "No. Series Line".GETFILTERS);
            end;

            trigger OnAfterGetRecord()
            begin
                totalcount += 1;
                ProgressWindow.UPDATE(2, "No. Series Line".COUNT);
                ProgressWindow.UPDATE(1, totalcount);
                PreviousStartingNo := "Starting No.";

                if NOT NoSeries.get("Series Code") then
                    CurrReport.SKIP;

                NoSeriesLine.reset;
                NoSeriesLine.setcurrentkey(NoSeriesLine."Line No.");
                NoSeriesLine.setrange("Series Code", "No. Series Line"."Series Code");
                if NoSeriesLine.FINDLAST then
                    LastLineNo := NoSeriesLine."Line No." + 10000
                ELSE
                    LastLineNo := 10000;

                if (StartingDate <> 0D) AND (SearchString <> '') AND (ReplaceWith <> '') then begin //for format like ABC78/77-0001
                    Position := STRPOS(PreviousStartingNo, SearchString);
                    if Position <> 0 then begin
                        NewStartingNo := ReplaceString(PreviousStartingNo, SearchString, ReplaceWith);
                        NoSeriesLine.reset;
                        NoSeriesLine.setrange("Series Code", "No. Series Line"."Series Code");
                        NoSeriesLine.setrange(NoSeriesLine."Starting No.", NewStartingNo);
                        if NOT NoSeriesLine.findfirst then begin
                            NoSeriesLine.INIT;
                            NoSeriesLine."Series Code" := "Series Code";
                            NoSeriesLine."Line No." := LastLineNo;
                            NoSeriesLine."Starting Date" := StartingDate;
                            NoSeriesLine."Starting No." := NewStartingNo;
                            NoSeriesLine."Increment-by No." := 1;
                            NoSeriesLine.Open := TRUE;
                            NoSeriesLine.New := TRUE;
                            NoSeriesLine.insert;

                            NoSeries.get("No. Series Line"."Series Code");
                            NoSeries."New Series Line Created" := TRUE;
                            NoSeries.MODIFY;
                        END;
                        ProgressWindow.UPDATE(3, totalcount);
                    END;
                END;
            end;

            trigger OnPostDataItem()
            begin
                Message('update Successfully!');
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group("Format Like ABC76/77-0001")
                {
                    field(SearchString; SearchString)
                    {
                        Caption = 'Fy search String';
                        ApplicationArea = all;
                    }
                    field(ReplaceWith; ReplaceWith)
                    {
                        Caption = 'New Fy Code';
                        ApplicationArea = all;
                    }
                }
                group("English Date")
                {
                    field(StartingDate; StartingDate)
                    {
                        Caption = 'Starting Date(Eng)';
                        ApplicationArea = all;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    begin
        WHILE STRPOS(String, FindWhat) > 0 DO
            String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
        NewString := String;
        EXIT(NewString);
    end;

    var
        Year: Integer;
        StartingDate: Date;
        NoFilter: code[20];
        PreviousStartingNo: code[20];
        NewStartingNo: code[20];
        Position: Integer;
        NoSeriesLine: Record "No. Series Line";
        totalcount: integer;
        ProgressWindow: Dialog;
        LastLineNo: Integer;
        SearchString: Text;
        NewString: Text;
        ReplaceWith: Text;
        NoSeries: Record "No. Series";
        Text000: Label 'Processed : #1######\Total Records : #2######## \Modified : #3######';
}
