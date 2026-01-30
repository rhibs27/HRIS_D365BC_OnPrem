page 50384 "Appraisal Template Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Appraisal Template";
    Caption = 'Appraisal Template Card';


    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Template Master No."; Rec."Template Master No.")
                {
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ApplicationArea = All;
                }
                field("Designation"; Rec."Designation")
                {
                    ApplicationArea = All;
                }
                field("Employment Type"; Rec."Employment Type")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ToolTip = 'Specifies the value of the Appraisal Type field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        FieldEditableRules();
                    end;
                }
                field("Appraisal Subtype Monthly"; Rec."Appraisal Subtype Monthly")
                {
                    Editable = FieldEditable1;
                    ToolTip = 'Specifies the value of the Appraisal Subtype Monthly field.';
                    ApplicationArea = All;
                }
                field("Appraisal Subtype Quarterly"; Rec."Appraisal Subtype Quarterly")
                {
                    Editable = FieldEditable2;
                    ToolTip = 'Specifies the value of the Appraisal Subtype Quarterly field.';
                    ApplicationArea = All;
                }
                field("Check Date From"; Rec."Check Date From")
                {
                    ApplicationArea = All;
                }
                field("Minimum Service Period"; Rec."Minimum Service Period")
                {
                    ApplicationArea = All;
                }
                field("KPI Rating Type"; Rec."KPI Rating Type")
                {
                    ApplicationArea = All;
                }
            }
            part(EligibleEmployees; "Eligible Appraisal Employee")
            {
                ApplicationArea = All;
                Caption = 'Eligible Employees';
                SubPageLink = "Template Master No." = field("Template Master No.");
            }
            part(ReviewerWeightageSetups; "Reviewer Weightage Setups")
            {
                ApplicationArea = All;
                Caption = 'Reviewer Weightage Setups';
                SubPageLink = "Appraisal Template" = field("Template Master No."), "Fiscal Year" = field("Fiscal Year");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Get Eligible Employees")
            {
                ApplicationArea = All;
                Caption = 'Get Eligible Employees';
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    Employee: Record Employee;
                    EligibleEmployeePage: Page "Eligible Employee Selection";
                    ServiceStartDate: Date;
                    ServiceEndDate: Date;
                    FiscalYearEndDate: Date;
                    Hrmgt: Codeunit "HR Mgt.";
                    IsEligible: Boolean;
                begin
                    Rec.TestField("Template Master No.");
                    Rec.TestField("Employment Type");
                    Rec.TestField("Fiscal Year");
                    Rec.TestField("Check Date From");
                    Employee.Reset();
                    Employee.MarkedOnly(false);
                    Employee.SetRange(Status, Employee.Status::Active);
                    Employee.SetRange("Employment Type", Rec."Employment Type");

                    if Rec.Designation <> '' then
                        Employee.SetFilter("Functional Title", Rec.Designation);

                    if Employee.FindSet() then
                        repeat
                            IsEligible := true;
                            ServiceStartDate := 0D;

                            case Rec."Check Date From" of
                                Rec."Check Date From"::"Date of Employment":
                                    ServiceStartDate := Employee."Employment Date";
                                Rec."Check Date From"::"Confirmation Date":
                                    ServiceStartDate := Employee."Confirmation Date";
                            end;

                            if ServiceStartDate = 0D then
                                IsEligible := false;

                            if IsEligible and (Format(Rec."Minimum Service Period") <> '') then begin
                                ServiceEndDate := CalcDate(Rec."Minimum Service Period", ServiceStartDate);
                                FiscalYearEndDate := Hrmgt.ReturnEndDateFY(Rec."Fiscal Year");

                                if (FiscalYearEndDate = 0D) or (ServiceEndDate > FiscalYearEndDate) then
                                    IsEligible := false;
                            end;

                            Employee.Mark(IsEligible);
                        until Employee.Next() = 0;

                    Employee.MarkedOnly(true);

                    EligibleEmployeePage.SetTableView(Employee);
                    EligibleEmployeePage.SetCurrentTemplateNo(Rec."Template Master No.");
                    EligibleEmployeePage.Run();
                    CurrPage.EligibleEmployees.PAGE.Update(false);
                end;
            }
            action("Create Appraisal")
            {
                ApplicationArea = All;
                Caption = 'Create Appraisal';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    AppraisalEmployee: Record "Appraisal Employee";
                    Appraisal: Record Appraisal;
                    ReviewerWeightageSetup: Record "Reviewer Weightage Setup";
                    ScoreDetail: Record "Score Detail";
                    KPIEmployee: Record "KPI Employee";
                    CreatedCount: Integer;
                    SkippedCount: Integer;
                    EmployeeCode: Code[20];
                    TotalWeightage: Decimal;
                    AppraisalMgt: codeunit "AppraisalMgt.";
                begin
                    Rec.TestField("Template Master No.");
                    Rec.TestField("Fiscal Year");
                    Rec.TestField("Appraisal Type");
                    Rec.TestField("KPI Rating Type");

                    if Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly then
                        Rec.TestField("Appraisal Subtype Monthly")
                    else if Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly then
                        Rec.TestField("Appraisal Subtype Quarterly");
                    ReviewerWeightageSetup.Reset();
                    ReviewerWeightageSetup.SetRange("Appraisal Template", Rec."Template Master No.");
                    ReviewerWeightageSetup.SetRange("Fiscal Year", Rec."Fiscal Year");

                    if ReviewerWeightageSetup.FindSet() then begin
                        TotalWeightage := 0;
                        repeat
                            TotalWeightage += ReviewerWeightageSetup.Weightage;
                        until ReviewerWeightageSetup.Next() = 0;

                        if TotalWeightage <> 100 then
                            Error('Total weightage for Appraisal Template %1 and Fiscal Year %2 is %3. It must be 100 to create appraisal.',
                                  Rec."Template Master No.", Rec."Fiscal Year", TotalWeightage);
                    end else begin
                    end;

                    AppraisalEmployee.Reset();
                    AppraisalEmployee.SetRange("Template Master No.", Rec."Template Master No.");

                    if not AppraisalEmployee.FindSet() then
                        Error('No eligible employees found in the template. Please add employees first.');

                    if not Confirm('Do you want to create appraisal for %1 employees?', true, AppraisalEmployee.Count) then
                        exit;

                    CreatedCount := 0;
                    SkippedCount := 0;

                    repeat
                        EmployeeCode := AppraisalEmployee."Employee No.";
                        // Check if appraisal already exists for this employee
                        Appraisal.Reset();
                        Appraisal.SetRange("Employee Code", EmployeeCode);
                        Appraisal.SetRange("Fiscal Year", Rec."Fiscal Year");
                        Appraisal.SetRange("Appraisal Type", Rec."Appraisal Type");
                        Appraisal.SetRange("KPI Rating Type", rec."KPI Rating Type");

                        if Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly then
                            Appraisal.SetRange("Appraisal Subtype Monthly", Rec."Appraisal Subtype Monthly")
                        else if Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly then
                            Appraisal.SetRange("Appraisal Subtype Quarterly", Rec."Appraisal Subtype Quarterly");

                        if Appraisal.FindFirst() then begin

                            if Appraisal."KPI Rating Type" <> Rec."KPI Rating Type" then begin
                                KPIEmployee.Reset();
                                KPIEmployee.SetRange("Appraisal Code", Appraisal."Appraisal Code");
                                KPIEmployee.ModifyAll(Score, 0);
                                KPIEmployee.ModifyAll(Rating, 0);
                                KPIEmployee.ModifyAll("Score Total", 0);
                            end;

                            SkippedCount += 1;
                        end else begin
                            // Create new appraisal record
                            Clear(Appraisal);
                            Appraisal.Init();
                            Appraisal.Validate("Fiscal Year", Rec."Fiscal Year");
                            Appraisal.Validate("Employee Code", EmployeeCode);
                            Appraisal.Insert(true);
                            Appraisal.Validate("Appraisal Template", Rec."Template Master No.");
                            Appraisal.Validate("Appraisal Type", Rec."Appraisal Type");
                            Appraisal.Validate("KPI Rating Type", Rec."KPI Rating Type");
                            if Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly then
                                Appraisal.Validate("Appraisal Subtype Monthly", Rec."Appraisal Subtype Monthly")
                            else if Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly then
                                Appraisal.Validate("Appraisal Subtype Quarterly", Rec."Appraisal Subtype Quarterly");
                            Appraisal.Modify(true);
                            AppraisalMgt.InsertScoreDetail(Appraisal);
                            CreatedCount += 1;
                        end;

                    until AppraisalEmployee.Next() = 0;

                    if SkippedCount > 0 then
                        Message('%1 appraisals created successfully.\%2 employees skipped (appraisal already exists).', CreatedCount, SkippedCount)
                    else
                        Message('%1 appraisals created successfully.', CreatedCount);
                end;
            }
        }
    }
    trigger OnModifyRecord(): Boolean
    var
        HasChanges: Boolean;
    begin
        HasChanges := (Rec."Fiscal Year" <> xRec."Fiscal Year") or
                      (Rec."Appraisal Type" <> xRec."Appraisal Type") or
                      (Rec."Appraisal Subtype Monthly" <> xRec."Appraisal Subtype Monthly") or
                      (Rec."Appraisal Subtype Quarterly" <> xRec."Appraisal Subtype Quarterly") or
                      (Rec."KPI Rating Type" <> xRec."KPI Rating Type");
        if HasChanges then begin
            if not Confirm('This will update KPI Master Table as well. Do you want to continue?', false) then begin
                DefaultValues();
                exit(false);
            end;
        end;
        exit(true);
    end;

    var
        FieldEditable1, FieldEditable2 : Boolean;
    local procedure FieldEditableRules()
    begin
        FieldEditable1 := Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly;
        FieldEditable2 := Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly;
    end;

    local procedure DefaultValues()
    begin
        Rec."Fiscal Year" := xRec."Fiscal Year";
        Rec."Appraisal Type" := xRec."Appraisal Type";
        Rec."Appraisal Subtype Monthly" := xRec."Appraisal Subtype Monthly";
        Rec."Appraisal Subtype Quarterly" := xRec."Appraisal Subtype Quarterly";
        Rec."KPI Rating Type" := xRec."KPI Rating Type";
        FieldEditableRules();
    end;
}