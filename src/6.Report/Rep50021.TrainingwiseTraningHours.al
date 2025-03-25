report 50021 "Training wise Traning Hours"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019822.TrainingwiseTraningHours.rdl';
    Caption = 'Training wise Traning Hours';
    ApplicationArea = All;

    dataset
    {
        dataitem("Training Header"; "Training Header")
        {
            column(No_TrainingHeader; "Training Header"."No.") { }
            column(Description_TrainingHeader; "Training Header".Description) { }
            dataitem("Training Line"; "Training Line")
            {
                DataItemLink = "Training No." = field("No.");
                column(TrainerType_TrainingLine; "Training Line"."Trainer Type") { }
                column(Name_TrainingLine; "Training Line".Name) { }
                column(Type_TrainingLine; "Training Line".Type) { }
                column(TotalHours_TrainingLine; Hours) { }
                column(TrainingType_TrainingLine; "Training Line"."Training Type") { }

                trigger OnAfterGetRecord()
                begin
                    Hours := ("Training Line"."Total Hours") / 3600000;
                end;
            }
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
