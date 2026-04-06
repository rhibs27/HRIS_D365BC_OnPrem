table 50182 "Grievance Comment"
{
    Caption = 'Grievance Comment';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Grievance No."; Code[20])
        {
            TableRelation = "Grievance Header";
        }
        field(2; "Line No."; Integer) { }
        field(3; "Comment Date"; DateTime) { }
        field(4; "Commented By"; Code[20])
        {
            TableRelation = Employee;
            trigger OnValidate()
            begin
                if Employee.Get("Commented By") then
                    Validate("Commented By Name", Employee."Full Name")
                else
                    Validate("Commented By Name", '');
            end;
        }
        field(5; "Commented By Name"; Text[100])
        {
            Editable = false;
        }
        field(6; Comment; Text[2000]) { }
        field(7; Role; Text[50]) { }
    }

    keys
    {
        key(Key1; "Grievance No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        GrievanceComment: Record "Grievance Comment";
    begin
        if "Comment Date" = 0DT then
            "Comment Date" := CurrentDateTime;
        GrievanceComment.Reset();
        GrievanceComment.SetRange("Grievance No.", "Grievance No.");
        if GrievanceComment.FindLast() then
            "Line No." := GrievanceComment."Line No." + 10000
        else
            "Line No." := 10000;
    end;

    trigger OnDelete()
    begin
        Error('Cannot Delete Comment');
    end;

    var
        Employee: Record Employee;
}
