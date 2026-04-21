report 50020 "Trainer Traning Hours"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019821.TrainerTraningHours.rdl';
    Caption = 'Trainee Traning Hours';
    ApplicationArea = All;

    dataset
    {
        dataitem("Training Line"; "Training Line")
        {
            DataItemTableView = where(Type = filter(Trainer), "Employee Name" = filter(<> ''));
            column(TrainerType_TrainingLine; "Training Line"."Trainer Type") { }
            column(Name_TrainingLine; "Training Line"."Employee Name") { }
            column(Type_TrainingLine; "Training Line".Type) { }
            column(TotalHours_TrainingLine; Hours) { }
            column(TrainingType_TrainingLine; "Training Line"."Training Type") { }

            trigger OnAfterGetRecord()
            begin
                Hours := ("Training Line"."Total Hours") / 3600000;
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    var
        Hours: Decimal;
}
