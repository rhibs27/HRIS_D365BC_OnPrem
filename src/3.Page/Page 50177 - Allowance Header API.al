page 50177 "Allowance Header API"
{
    Caption = 'Allowance Assignment';
    DelayedInsert = true;
    EntityName = 'allowanceHeaderEntity';
    EntitySetName = 'allowanceHeaderEntities';
    ODataKeyFields = "Entry No.";
    PageType = API;
    APIVersion = 'v2.0';
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Allowance Assignment Header";
    SourceTableView = sorting("Entry No.")
                      order(descending);

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EntryNo; Rec."Entry No.") { }
                field(type; Rec.Type) { }
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("code"; Rec.Code) { }
                field(name; Rec.Name)
                {
                    Editable = true;
                }
                field(fromDate; Rec."From Date") { }
                field(toDate; Rec."To date") { }
                field(approvalStatus; Rec."Approval Status") { }
                field(approverID; Rec."Approver ID") { }
                field(approverDate; Rec."Approved Date") { }
                field(approverName; Rec."Approver Name") { }
                field(Week; Rec.Week) { }
                field(EnglishMonth; Rec."English Month") { }
                field(EnglishYear; Rec."English Year") { }
                field(CreatedBy; Rec."Created By") { }
                part(allowanceSubformEntities; "Allowance Assign Subfrom API")
                {
                    EntityName = 'allowanceSubformEntity';
                    EntitySetName = 'allowanceSubformEntities';
                    SubPageLink = "Entry No." = field("Entry No."),
                                  Code = field(Code);
                }
                part(allowanceFactboxEntities; "Allowance Factbox")
                {
                    EntityName = 'allowanceFactboxEntity';
                    EntitySetName = 'allowanceFactboxEntities';
                    SubPageLink = "Entry No. Filter" = field("Entry No."),
                                  "Branch Filter" = field(Code);
                }
            }
        }
    }

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
    end;

    trigger OnOpenPage()
    begin
        GetMonthlyFilter;
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
