page 50237 "Employee Birthday Entity"
{

    EntityName = 'employeeBirthdayEntity';
    EntitySetName = 'employeeBirthdayEntities';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = Employee;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(No; Rec."No.") { }
                field(FullName; Rec."Full Name") { }
                field(BirthDate; Rec."Birth Date") { }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        GetBirthDayEmployee();
    end;

    var
        CurrentDay: Integer;
        CurrentMonth: Integer;
        NoofDaysInMonth: Integer;
        BirthMonth: Integer;
        BirthDay: Integer;
        EmployeeFilter: Text;
        Employee: Record Employee;

    local procedure GetBirthDayEmployee(): Boolean
    begin
        Employee.Reset;
        Employee.SetRange(Status, Employee.Status::Active);
        NoofDaysInMonth := CalcDate('CM', Today) - CalcDate('-CM', Today) + 1;
        if Employee.Find('-') then
            repeat
                if Employee."Birth Date" <> 0D then begin
                    CurrentDay := Date2DMY(Today, 1);
                    CurrentMonth := Date2DMY(Today, 2);
                    BirthMonth := Date2DMY(Employee."Birth Date", 2);
                    BirthDay := Date2DMY(Employee."Birth Date", 1);

                    if (BirthMonth - CurrentMonth) in [0, 1] then begin
                        if (BirthMonth - CurrentMonth) = 0 then begin
                            if ((BirthDay - CurrentDay) <= 5) and ((BirthDay - CurrentDay) >= 0) then begin
                                if EmployeeFilter = '' then
                                    EmployeeFilter := Employee."No."
                                else
                                    EmployeeFilter += '|' + Employee."No.";
                            end;
                        end else begin
                            if ((NoofDaysInMonth - CurrentDay + BirthDay) <= 5) and ((NoofDaysInMonth - CurrentDay + BirthDay) <= 0) then begin
                                if EmployeeFilter = '' then
                                    EmployeeFilter := Employee."No."
                                else
                                    EmployeeFilter += '|' + Employee."No.";
                            end;
                        end;
                    end;
                end;
            until Employee.Next = 0;

        if EmployeeFilter = '' then
            Rec.SetRange("No.", EmployeeFilter)
        else
            Rec.SetFilter("No.", EmployeeFilter);
    end;
}
