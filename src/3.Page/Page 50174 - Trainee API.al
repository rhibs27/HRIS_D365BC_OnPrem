page 50174 "Trainee API"
{
    // version NIC Asia1.00,Training,APINICASIA1.00

    AutoSplitKey = true;
    EntityName = 'traineeEntity';
    EntitySetName = 'traineeEntities';
    InsertAllowed = false;
    PageType = API;
    APIVersion = 'v2.0';
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    RefreshOnActivate = true;
    SourceTable = "Training Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(trainingNo; Rec."Training No.") { }
                field(traininigDescription; TrainHead.Description) { }
                field(trainingStartDate; Rec."Training Start Date") { }
                field(trainingEndDate; Rec."Training End Date") { }
                field(employeeCode; Rec."Employee Code") { }
                field(employeeName; Rec.Name) { }
                part(employeeTrainingEntities; "Employee Training API")
                {
                    EntityName = 'employeeTrainingEntity';
                    EntitySetName = 'employeeTrainingEntities';
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        if TrainHead.Get(Rec."Training No.") then;
    end;

    var
        TrainHead: Record "Training Header";
}
