page 33020006 "All Reports"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Item;
    SourceTableTemporary = true;
    SourceTableView = sorting("Statistics Group");
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(SN; Rec."Statistics Group")
                {
                    Caption = 'SN';
                    ToolTip = 'Specifies the value of the SN field.';
                    ApplicationArea = All;
                }
                field(ReportCategory; Rec."Vendor Item No.")
                {
                    Caption = 'Category';
                    StyleExpr = ReportType;
                    ToolTip = 'Specifies the value of the Category field.';
                    ApplicationArea = All;
                }
                field(ReportName; Rec.Description)
                {
                    Caption = 'Report Name';
                    DrillDown = true;
                    Lookup = true;
                    StyleExpr = ReportType;
                    ToolTip = 'Specifies the value of the Report Name field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        RunDealersReport
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        RunDealersReport
                    end;
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        case Rec."Vendor Item No." of
            'Leave Request':
                ReportType := LeaveStyle;
            'Travel':
                ReportType := TravelStyle;
            'Training':
                ReportType := TrainingStyle;
            'Transfer':
                ReportType := TransferStyle;
            'Allowance':
                ReportType := AllowanceStyle;
        end;
    end;

    trigger OnOpenPage()
    begin
        PrepareDealersReport(Rec);
        if Rec.FindFirst then;
    end;

    var
        ReportType: Text;
        LeaveStyle: Label 'Favorable';
        TravelStyle: Label 'Subordinate';
        TrainingStyle: Label 'Ambiguous';
        TransferStyle: Label 'StandardAccent';
        AllowanceStyle: Label 'StrongAccent';

    local procedure RunDealersReport()
    begin
        RunReport(Rec);
    end;

    procedure PrepareDealersReport(var NewReport: Record Item)
    var
        ReportCount: Integer;
        Training: Label 'Training';
        Travel: Label 'Travel';
        Allowance: Label 'Allowance';
        PaymentMemo: Report "Payment Memo";
        TrainerTraningHours: Report "Trainer Traning Hours";
        TrainingwiseTraningHours: Report "Training wise Traning Hours";
        TravelRequest: Report "Travel Request";
        TravelSettlement: Report "Travel Settlement";
        AllowanceAssignment: Report "Allowance Assignment";
        TraineeTraningHours: Report Settlement;
    begin

        CreateReport(NewReport, ReportCount, 4, Training, CopyStr(PaymentMemo.ObjectId, 8, 250), CopyStr(PaymentMemo.ObjectId, 1, 6));
        CreateReport(NewReport, ReportCount, 4, Training, CopyStr(TraineeTraningHours.ObjectId, 8, 250), CopyStr(TraineeTraningHours.ObjectId, 1, 6));
        CreateReport(NewReport, ReportCount, 4, Training, CopyStr(TrainerTraningHours.ObjectId, 8, 250), CopyStr(TrainerTraningHours.ObjectId, 1, 6));
        CreateReport(NewReport, ReportCount, 4, Training, CopyStr(TrainingwiseTraningHours.ObjectId, 8, 250), CopyStr(TrainingwiseTraningHours.ObjectId, 1, 6));
        CreateReport(NewReport, ReportCount, 4, Travel, CopyStr(TravelRequest.ObjectId, 8, 250), CopyStr(TravelRequest.ObjectId, 1, 6));
        CreateReport(NewReport, ReportCount, 4, Travel, CopyStr(TravelSettlement.ObjectId, 8, 250), CopyStr(TravelSettlement.ObjectId, 1, 6));
        CreateReport(NewReport, ReportCount, 4, Allowance, CopyStr(AllowanceAssignment.ObjectId, 8, 250), CopyStr(AllowanceAssignment.ObjectId, 1, 6));
    end;

    local procedure CreateReport(var NewReport: Record Item; var ReportCount: Integer; ReportID: Integer; ReportCategory: Text; ReportName: Text; Type: Text)
    begin
        ReportCount += 1;
        NewReport.Init;
        NewReport."Statistics Group" := ReportCount;
        NewReport."No." := Format(ReportCount);
        NewReport."Price Unit Conversion" := ReportID;
        NewReport.Description := CopyStr(ReportName, 1, 50);
        NewReport."Description 2" := Type;
        NewReport."Vendor Item No." := ReportCategory;
        NewReport.Insert;
    end;

    procedure RunReport(var NewReport: Record Item)
    var
        Type: Option "Report","Page";
    begin
        case NewReport."Description 2" of
            Format(Type::Report):
                Report.Run(NewReport."Price Unit Conversion");
            Format(Type::Page):
                Page.Run(NewReport."Price Unit Conversion");
        end;
    end;
}
