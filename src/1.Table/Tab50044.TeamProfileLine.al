table 50044 "Team Profile Line"
{
    DataClassification = ToBeClassified;
    Caption = 'Team Profile Line';

    fields
    {
        field(1; "Team Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Team Code';
        }
        field(2; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No';
        }
        field(3; "Employee Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Employee Code';
            TableRelation = Employee;
        }
        field(4; "Type"; Enum "Employee Team Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
            trigger OnValidate()
            begin
                if Rec.Type <> xRec.Type then begin
                    "Org. Structuire Code" := '';
                    "View Birthday" := false;
                    "View Employee History" := false;
                    "View Employee List" := false;
                    "View Employees Leave" := false;
                end;
            end;
        }
        field(5; "Org. Structuire Code"; Code[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Organization Structure Code';
            trigger OnValidate()
            begin
                if "Org. Structuire Code" <> '' then
                    case Type of
                        Type::Branch, Type::Dept, type::Prov, Type::Unit, Type::"Ext Counter":
                            begin

                            end
                        else
                            Error('Invalid selection of type');
                    end;
            end;

            trigger OnLookup()
            var
                TeamProfileMgt: Codeunit "Team Profile Mgt.";
            begin
                case Type of
                    Type::Branch:
                        begin
                            "Org. Structuire Code" := TeamProfileMgt.LookUpOrgStructureCode(Enum::"Deputation Type"::Branch)
                        end;
                    Type::Dept:
                        begin
                            "Org. Structuire Code" := TeamProfileMgt.LookUpOrgStructureCode(Enum::"Deputation Type"::Department)
                        end;
                    Type::Prov:
                        begin
                            "Org. Structuire Code" := TeamProfileMgt.LookUpOrgStructureCode(Enum::"Deputation Type"::Province);
                        end;
                    Type::Unit:
                        begin
                            "Org. Structuire Code" := TeamProfileMgt.LookUpOrgStructureCode(Enum::"Deputation Type"::Unit);
                        end;
                    Type::"Ext Counter":
                        begin
                            "Org. Structuire Code" := TeamProfileMgt.LookUpOrgStructureCode(Enum::"Deputation Type"::"Extension Counter");
                        end;
                    else
                        Error('Invalid selection of type');

                end;
            end;
        }
        field(6; "View Birthday"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'View Birthday';
        }
        field(7; "View Employees Leave"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'View Employees Leave';
        }
        field(8; "View Employee List"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'View Employee List';
        }
        field(9; "View Employee History"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'View Employee History';
            trigger OnValidate()
            begin
                if "View Employee History" then
                    TestField("View Employee Card");
            end;
        }
        field(10; "View Employee Card"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'View Employee Card';
        }
        field(11; "View Attendance"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'View Attendance';
        }
    }

    keys
    {
        key(PK; "Team Code", "Line No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnDelete()
    begin
    end;

    var
        EmployeeTeamHeader: Record "Team Profile Header";
}
