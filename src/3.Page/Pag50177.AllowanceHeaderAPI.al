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
                {
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin

                    end;
                }
                field(activityType; Rec."Activity Type") { }
                field(employeeNo; Rec."Employee No.")
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
                // field(approverID; Rec."Approver ID") { }
                field(approverDate; Rec."Approved Date") { }
                // field(approverName; Rec."Approver Name") { }
                field(Week; Rec.Week) { }
                field(englishMonth; Rec."English Month") { }
                field(englishYear; Rec."English Year") { }
                field(createdBy; Rec."Created By") { }
                part(allowanceSubformEntities; "Allowance Assign Subfrom API")
                {
                    EntityName = 'allowanceSubformEntity';
                    EntitySetName = 'allowanceSubformEntities';
                    SubPageLink = "No." = field("No."),
                                  Code = field(Code);
                }
                part(allowanceFactboxEntities; "Allowance Factbox")
                {
                    EntityName = 'allowanceFactboxEntity';
                    EntitySetName = 'allowanceFactboxEntities';
                    SubPageLink = "Entry No. Filter" = field("No."),
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
