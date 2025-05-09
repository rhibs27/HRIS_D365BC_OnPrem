page 50177 "Allowance Header API"
{
    Caption = 'Allowance Assignment';
    EntityName = 'allowanceHeaderEntity';
    EntitySetName = 'allowanceHeaderEntities';
    ODataKeyFields = "No.";
    DelayedInsert = true;
    PageType = API;
    APIVersion = 'v2.0';
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Allowance Assignment Header";
    SourceTableView = sorting("No.")
                      order(descending);
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(no; Rec."No.") { }
                field(type; Rec.Type)
                { }
            }
            field(activityType; Rec."Activity Type") { }
            field(employeeNo; Rec."Employee No.")
            {
                ApplicationArea = All;
            }
            field(code; Rec.Code) { }
            field(name; Rec.Name)
            {
                Editable = true;
            }
            field(fromDate; Rec."From Date") { }
            field(toDate; Rec."To date") { }
            field(approvalStatus; Rec."Approval Status") { }
            // field(approverID; Rec."Approver ID") { }
            field(approverDate; Rec."Approved Date") { }
            // field(approverName; Rec."Approver Name") { }
            // field(week; Rec.Week) { }
            // field(englishMonth; Rec."English Month") { }
            field(fiscalYear; Rec."Fiscal Year") { }
            field(createdBy; Rec."Created By") { }
            field(return; Rec.Return) { }
            field(rejectionRemarks; Rec."Rejection Remarks")
            {
            }
            field(allowanceTypeFilter; Rec."Allowance Type Filter")
            {
            }
            part(allowanceSubformEntities; "Allowance Assign Subform API")
            {
                EntityName = 'allowanceSubformEntity';
                EntitySetName = 'allowanceSubformEntities';
                SubPageLink = "No." = field("No."),
                                  Code = field(Code);
            }
            part(allowanceFactBoxEntities; "Allowance FactBox")
            {
                EntityName = 'allowanceFactBoxEntity';
                EntitySetName = 'allowanceFactBoxEntities';
                SubPageLink = "Entry No. Filter" = field("No."),
                                  "Branch Filter" = field(Code);
            }
        }
    }



    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
    end;

    trigger OnOpenPage()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        // GetMonthlyFilter;
        Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
        Rec.SetAscending("No.", false);
    end;

    var
        PGSetup: Record "Payroll General Setup";
        StartDate: Date;

    local procedure GetMonthlyFilter()
    begin
        PGSetup.Get;
        StartDate := CalcDate('<-CM>', Today - PGSetup."Allowance Grace Period");
        Rec.SetFilter("From Date", '%1..', StartDate);
    end;
}
