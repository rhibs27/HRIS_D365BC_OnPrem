tableextension 50017 "Employee Relative Ext" extends "Employee Relative"
{
    fields
    {
        modify("Employee No.")
        {
            trigger OnAfterValidate()
            begin
                if Rec.IsTemporary then
                    exit;
                // only assign new line no. if thid is a new record(not already exisiting one)
                if Rec."Line No." = 0 then
                    GetNextLineNo;
            end;
        }


        modify("Phone No.")
        {
            trigger OnAfterValidate()
            var
                TypeHelper: Codeunit "Type Helper";
            begin
                if not TypeHelper.IsPhoneNumber(Rec."Phone No.") then
                    Error('Phone No Validation Error');
            End;
        }
        field(50000; Address; Text[30])
        {
            DataClassification = CustomerContent;
        }
        // field(50001; Relation; Text[30])
        // {
        //     DataClassification = CustomerContent;
        // }
        field(50002; "Master Type"; Enum EmployeeCandidate)
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Name(Nepali)"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50004; "Fathers Name(Nepali)"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50005; "GrandFather Name(Nepali)"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50006; District; Text[50])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
            trigger OnValidate()
            begin
                if (Rec."District" <> xRec."District") and ("District" <> '') then
                    HRMgt.CheckDistrictName("District");
            end;

            trigger OnLookup()
            begin
                Validate("District", HRMgt.LookupAllDistrict());
            end;
        }
        field(50007; "VDC/Municipality"; Text[50])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
            trigger OnValidate()
            begin
                if (Rec."VDC/Municipality" <> xRec."VDC/Municipality") and ("VDC/Municipality" <> '') then
                    HRMgt.CheckMunicipalityName("VDC/Municipality");
            end;

            trigger OnLookup()
            begin
                Validate("VDC/Municipality", HRMgt.LookupMunicipalityName('', "VDC/Municipality"));
            end;
        }
        field(50008; "Ward No"; Integer)
        {
            DataClassification = CustomerContent;
            MinValue = 1;
            MaxValue = 35;
            Description = 'In Nepali   for loan';
        }
        field(50009; "Citizenship No."; Text[20])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50010; Age; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50011; "Citizenship Date"; Date)
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50012; "Citizenship Issued District"; Text[50])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if (Rec."District" <> xRec."District") and ("District" <> '') then
                    HRMgt.CheckDistrictName("District");
            end;

            trigger OnLookup()
            begin
                Validate("District", HRMgt.LookupAllDistrict());
            end;
        }
        field(50013; "Citizenship Date (Nepali)"; Text[10])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali';
        }
        field(50014; "Relationship"; Enum Relation)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Relative.Relation WHERE(Code = FIELD("Relative Code")));
            Editable = false;
        }
        field(50015; "Full Name"; Text[50])
        {
            DataClassification = CustomerContent;
            CharAllowed = 'AZaz  ';
        }
        field(50016; Employee_BOD; Enum "Employee/BOD Relation")
        {
            DataClassification = CustomerContent;
        }
        field(50017; "Set Emergency Contact"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Employee: Record Employee;
                EmployeeRelative: Record "Employee Relative";
            begin
                //case when emergency contact is cleared
                if GuiAllowed then begin
                    if (not Rec."Set Emergency Contact") and xRec."Set Emergency Contact" then begin
                        Employee.Get("Employee No.");
                        Employee."Relation With Emergency Cont" := '';
                        Employee."Emergency Contact Name" := '';
                        Employee."Emergency Contact Email" := '';
                        Employee."Emergency Mobile No." := '';
                        Employee.Modify();
                    end
                    else if "Set Emergency Contact" then begin
                        // no two emergency contact
                        EmployeeRelative.SetRange("Employee No.", "Employee No.");
                        EmployeeRelative.SetRange("Set Emergency Contact", true);
                        EmployeeRelative.SetFilter("Line No.", '<>%1', "Line No.");
                        if EmployeeRelative.Count() > 0 then
                            Error('Employee can have only one emergency contact at a time');

                        // flow data to employee
                        TestField("Relative Code");
                        TestField("Full Name");
                        TestField("Phone No.");
                        Employee.Get("Employee No.");
                        Employee."Relation With Emergency Cont" := "Relative Code";
                        Employee."Emergency Contact Name" := "Full Name";
                        Employee."Emergency Contact Email" := "E-mail";
                        Employee."Emergency Mobile No." := "Phone No.";
                        Employee.Modify();

                        Message('Emergency contact details updated sucessfully!');
                    end;
                end
                else if "Set Emergency Contact" then begin
                    Employee.Get("Employee No.");
                    Employee."Relation With Emergency Cont" := "Relative Code";
                    Employee."Emergency Contact Name" := "Full Name";
                    Employee."Emergency Contact Email" := "E-mail";
                    Employee."Emergency Mobile No." := "Phone No.";
                    Employee.Modify();
                end;

            end;
        }
        field(50018; "E-mail"; text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50019; "Lt."; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50020; "Set Nominee"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Employee: Record Employee;
                EmployeeRelative: Record "Employee Relative";
            begin
                // Case when nominee is cleared
                if GuiAllowed then begin
                    if (not Rec."Set Nominee") and xRec."Set Nominee" then begin
                        Employee.Get("Employee No.");
                        Employee."Relation With Nominee" := '';
                        Employee."Nominee Name" := '';
                        Employee."Nominee Email" := '';
                        Employee."Nominee Mobile No." := '';
                        Employee.Modify();
                    end
                    else if "Set Nominee" then begin
                        // No two nominee entries
                        EmployeeRelative.SetRange("Employee No.", "Employee No.");
                        EmployeeRelative.SetRange("Set Nominee", true);
                        EmployeeRelative.SetFilter("Line No.", '<>%1', "Line No.");
                        if EmployeeRelative.Count() > 0 then
                            Error('Employee can have only one nominee at a time');

                        // Flow data to employee
                        TestField("Relative Code");
                        TestField("Full Name");
                        TestField("Phone No.");
                        Employee.Get("Employee No.");
                        Employee."Relation With Nominee" := "Relative Code";
                        Employee."Nominee Name" := "Full Name";
                        Employee."Nominee Email" := "E-mail";
                        Employee."Nominee Mobile No." := "Phone No.";
                        Employee.Modify();

                        Message('Nominee details updated successfully!');
                    end;
                end
                else if "Set Nominee" then begin
                    Employee.Get("Employee No.");
                    Employee."Relation With Nominee" := "Relative Code";
                    Employee."Nominee Name" := "Full Name";
                    Employee."Nominee Email" := "E-mail";
                    Employee."Nominee Mobile No." := "Phone No.";
                    Employee.Modify();
                end;
            end;
        }

        field(301; "Access Token"; code[60])
        {
            caption = 'Access Token';
            DataClassification = CustomerContent;

        }

    }
    keys
    {
        key(key2; "Relative Code")
        {

        }
    }
    fieldgroups
    {
        addlast(DropDown; "Relative Code", "Full Name")
        {

        }
    }
    var
        Hrmgt: Codeunit "HR Mgt.";

    trigger OnDelete()
    var
        HRCommentLine: Record "Human Resource Comment Line";
    begin
        if "Master Type" = "Master Type"::Employee then begin
            HRCommentLine.SetRange("Table Name", HRCommentLine."Table Name"::"Employee Relative");
            HRCommentLine.SetRange("No.", "Employee No.");
            HRCommentLine.DeleteAll;
        end;
    end;

    trigger OnAfterModify()
    begin
        if GuiAllowed then
            if "Set Emergency Contact" then begin
                Validate("Set Emergency Contact");
            end;
        if "Set Nominee" then begin
            Validate("Set Nominee");
        end;

    end;

    local procedure GetNextLineNo();
    var
        EmployeeRelative: Record "Employee Relative";
    begin
        EmployeeRelative.Reset;
        EmployeeRelative.SetRange("Employee No.", "Employee No.");
        if EmployeeRelative.FindLast then
            Validate("Line No.", EmployeeRelative."Line No." + 10000)
        else
            Validate("Line No.", 10000);
    end;
}
