xmlport 33019801 "Import/Export Training Line"
{
    Format = VariableText;
    TableSeparator = '<NewLine>';
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoUpdate = true;
                XmlName = 'TrainingLineTitle';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(EmployeeNoTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EmployeeNoTitle := "Training Line".FieldCaption("Employee Code");
                    end;
                }
                textelement(EmployeeNameTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EmployeeNameTitle := "Training Line".FieldCaption(Name);
                    end;
                }
                textelement(DepartmentCodeTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DepartmentCodeTitle := "Training Line".FieldCaption("Department Code");
                    end;
                }
                textelement(DepartmentNameTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DepartmentNameTitle := "Training Line".FieldCaption("Department Name");
                    end;
                }
                textelement(BranchCodeTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        BranchCodeTitle := 'Branch Code';
                    end;
                }
                textelement(BranchNameTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        BranchNameTitle := "Training Line".FieldCaption("Branch Name");
                    end;
                }
            }
            tableelement("Training Line"; "Training Line")
            {
                XmlName = 'TrainingLine';
                SourceTableView = where(Type = const(Trainee));
                fieldelement("EmployeeNo."; "Training Line"."Employee Code") { }
                fieldelement(EmployeeName; "Training Line".Name) { }
                fieldelement(DepartmentCode; "Training Line"."Department Code") { }
                fieldelement(DepartmentName; "Training Line"."Department Name") { }
                fieldelement(BranchCode; "Training Line"."Shortcut Dimension 1 Code") { }
                fieldelement(BranchName; "Training Line"."Branch Name") { }

                trigger OnBeforeInsertRecord()
                begin
                    if FirstLine then begin
                        FirstLine := false;
                        currXMLport.Skip;
                    end;
                end;
            }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    trigger OnInitXmlPort()
    begin
        FirstLine := true;
    end;

    var
        FirstLine: Boolean;
}
