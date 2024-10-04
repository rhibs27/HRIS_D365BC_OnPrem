page 33020060 "Service History API"
{
    EntityName = 'ServiceHistoryList';
    EntitySetName = 'ServiceHistoryLists';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Employee Service History";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(ServiceHistoryCode; Rec."Service History Code") { }
                field(EmployeeNo; Rec."Employee No.") { }
                field(EmployeeName; Rec."Employee Name") { }
                field(ServiceEvent; Rec."Service Event") { }
                field(FunctionalTitleFrom; Rec."Functional Title (From)") { }
                field(FunctionalTitleDescFrom; Rec."Functional Title Desc. (From)") { }
                field(SalaryLevelFrom; Rec."Salary Level (From)") { }
                field(SalarylevelDescFrom; Rec."Salary level Desc. (From)") { }
                field(DeputationOnFrom; Rec."Deputation On(From)") { }
                field(DeputationCodeFrom; Rec."Deputation Code (From)") { }
                field(DeputationValueFrom; Rec."Deputation Value (From)") { }
                field(FunctionalTitleTo; Rec."Functional Title (To)") { }
                field(FunctionalTitleDescTo; Rec."Functional Title Desc. (To)") { }
                field(SalaryLevelTo; Rec."Salary Level (To)") { }
                field(SalaryLevelDescTo; Rec."Salary Level Desc. (To)") { }
                field(DeputationOnTo; Rec."Deputation On (To)") { }
                field(DeputationCodeTo; Rec."Deputation Code (To)") { }
                field(DeputationValueTo; Rec."Deputation Value (To)") { }
                field(SalaryGradeFrom; Rec."Salary Grade (From)") { }
                field(SalaryGradeTo; Rec."Salary Grade (To)") { }
                field(DocumentNo; Rec."Document No.") { }
                field(OutstationEligible; Rec."Outstation Eligible") { }
                field(EffectiveDate; Rec."Effective Date") { }
                field(Remarks; Rec.Remarks) { }
                field(Createdby; Rec."Created by") { }
                field(CreatedDateTime; Rec."Created DateTime") { }
            }
        }
    }

    actions { }
}
