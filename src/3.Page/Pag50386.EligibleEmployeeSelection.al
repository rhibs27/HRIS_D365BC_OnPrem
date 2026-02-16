page 50386 "Eligible Employee Selection"
{
    ApplicationArea = All;
    Caption = 'Eligible Employee Selection';
    PageType = List;
    SourceTable = Employee;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Full Name"; Rec."Full Name") { ApplicationArea = All; }
                field("Employment Type"; Rec."Employment Type") { ApplicationArea = All; }
                field("Functional Title"; Rec."Functional Title") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Employment Date"; Rec."Employment Date") { ApplicationArea = All; }
                field("Confirmation Date"; Rec."Confirmation Date") { ApplicationArea = All; }
                field("Province Code"; Rec."Province Code") { ApplicationArea = All; }
                field("Branch Code"; Rec."Branch Code") { ApplicationArea = All; }
                field("Department Code"; Rec."Department Code") { ApplicationArea = All; }
                field("Extension Counter Code"; Rec."Extension Counter Code") { ApplicationArea = All; }
                field("Unit Code"; Rec."Unit Code") { ApplicationArea = All; }
                field("Sub-Unit code"; Rec."Sub Unit Code") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Add to Eligible Employees")
            {
                ApplicationArea = All;
                Caption = 'Add to Eligible Employees';
                Image = Entry;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    EmployeeSelection: Record Employee;
                    AppraisalEmployee: Record "Appraisal Employee";
                    SelectedCount: Integer;
                    SkippedCount: Integer;
                begin
                    if CurrentTemplateMasterNo = '' then
                        Error('Template information not available.');

                    EmployeeSelection.CopyFilters(Rec);
                    CurrPage.SetSelectionFilter(EmployeeSelection);

                    if EmployeeSelection.FindSet() then begin
                        if not Confirm('Do you want to add %1 employees to the eligible list', true, EmployeeSelection.Count) then
                            exit;
                        repeat
                            AppraisalEmployee.Reset();
                            AppraisalEmployee.SetRange("Template Master No.", CurrentTemplateMasterNo);
                            AppraisalEmployee.SetRange("Employee No.", EmployeeSelection."No.");
                            if not AppraisalEmployee.FindFirst() then begin
                                // Employee doesn't exist, add to eligible list
                                AppraisalEmployee.Init();
                                AppraisalEmployee."Template Master No." := CurrentTemplateMasterNo;
                                AppraisalEmployee."Line No." := GetNextLineNo(CurrentTemplateMasterNo);
                                AppraisalEmployee."Employee No." := EmployeeSelection."No.";
                                AppraisalEmployee."Full Name" := EmployeeSelection."Full Name";
                                AppraisalEmployee."Employment Type" := EmployeeSelection."Employment Type";
                                AppraisalEmployee."Functional Title" := EmployeeSelection."Functional Title";
                                AppraisalEmployee.Status := EmployeeSelection.Status;
                                AppraisalEmployee."Employment Date" := EmployeeSelection."Employment Date";
                                AppraisalEmployee."Confirmation Date" := EmployeeSelection."Confirmation Date";
                                AppraisalEmployee."Province Code" := EmployeeSelection."Province Code";
                                AppraisalEmployee."Branch Code" := EmployeeSelection."Branch Code";
                                AppraisalEmployee."Department Code" := EmployeeSelection."Department Code";
                                AppraisalEmployee."Extension Counter Code" := EmployeeSelection."Extension Counter Code";
                                AppraisalEmployee."Unit Code" := EmployeeSelection."Unit Code";
                                AppraisalEmployee."Sub-Unit Code" := EmployeeSelection."Sub Unit Code";

                                AppraisalEmployee.Insert();
                                SelectedCount += 1;
                            end else begin
                                SkippedCount += 1;
                            end;
                        until EmployeeSelection.Next() = 0;

                        if SkippedCount > 0 then
                            Message('%1 employees added to eligible list.\%2 employees skipped (already exist).', SelectedCount, SkippedCount)
                        else
                            Message('%1 employees added to eligible list.', SelectedCount);

                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    var
        CurrentTemplateMasterNo: Code[20];

    procedure SetCurrentTemplateNo(TemplateNo: Code[20])
    begin
        CurrentTemplateMasterNo := TemplateNo;
    end;

    local procedure GetNextLineNo(TemplateNo: Code[20]): Integer
    var
        AppraisalEmployee: Record "Appraisal Employee";
    begin
        AppraisalEmployee.SetRange("Template Master No.", TemplateNo);
        if AppraisalEmployee.FindLast() then
            exit(AppraisalEmployee."Line No." + 1);
        exit(1);
    end;

}