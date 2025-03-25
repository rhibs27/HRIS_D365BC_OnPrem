report 50142 "Generate KPI"
{
    // version KPI1.00

    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                AppHdr: Record "KPI Appraisal Header Bank";
            begin
                if Employee."Employment Type" = Employee."Employment Type"::Contract then
                    exit;
                if (Employee.Status = Employee.Status::Active) and (Employee."Functional Title" <> '') then begin
                    Clear(AppriasalHeader);
                    AppriasalHeader.Reset;
                    AppriasalHeader.SetRange("Functional Title", Employee."KPI Functional Title");
                    AppriasalHeader.SetRange("Employee Code", Employee."No.");
                    if Employee."Employment Type" = Employee."Employment Type"::Permanent then
                        AppriasalHeader.SetRange(Quarter, Format(Quarterly));
                    if not AppriasalHeader.FindFirst then begin
                        if Employee."Employment Type" = Employee."Employment Type"::Probation then begin
                            AppHdr.Reset;
                            AppHdr.SetRange("Employee Code", Employee."No.");
                            if not AppHdr.IsEmpty then
                                exit;
                        end;
                        AppriasalHeader.Init;
                        if Employee."Employment Type" in [Employee."Employment Type"::Probation] then begin
                            AppriasalHeader.Quarter := '';
                        end else
                            AppriasalHeader.Validate(Quarter, Format(Quarterly));
                        AppriasalHeader.Insert(true);
                        AppriasalHeader.Validate("Employee Code", Employee."No.");
                        AppriasalHeader.Modify;
                        //>>KPI1.00
                    end;
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(Quater; Quarterly)
                {
                    Caption = 'Quarter';
                    ToolTip = 'Specifies the value of the Quarter field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    var
        Quarterly: Option Q1,Q2,Q3,Q4;
        AppriasalHeader: Record "KPI Appraisal Header Bank";
}
