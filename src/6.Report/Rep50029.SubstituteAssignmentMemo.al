report 50029 "Substitute Assignment Memo"
{
    Caption = 'Substitute Assignment Memo';
    ProcessingOnly = true;
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = 'Filter Criteria';
                    field("From Date"; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                    }
                    field("To Date"; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                    }
                    field(EmployeeNo; EmployeeNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Employee No.';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            EmployeeRec: Record Employee;
                        begin
                            AssignmentmemoHdr.TestField("Branch Code");
                            EmployeeRec.SetRange(Status, EmployeeRec.Status::Active);
                            EmployeeRec.SetRange("Branch Code", AssignmentmemoHdr."Branch Code");
                            if Page.RunModal(Page::"Employee List", EmployeeRec) = Action::LookupOK then
                                EmployeeNo := EmployeeRec."No.";
                        end;
                    }
                }
            }
        }
        actions
        {
            area(Processing) { }
        }
    }
    trigger OnPreReport()
    begin
        // Initialization or filtering logic can be added here
        if FromDate = 0D then
            Error('From Date is required.');
        if ToDate = 0D then
            Error('To Date is required.');
        if EmployeeNo = '' then
            Error('Employee No. is required.');

        AssignmentMemoMgt.InsertSubstituteAssignmentMemo(AssignmentMemoLine."Document No.", AssignmentMemoLine."Line No.", FromDate, ToDate, EmployeeNo);
        Message('Substituted successfully.');
    end;

    var
        FromDate: Date;
        ToDate: Date;
        EmployeeNo: Code[20];
        AssignmentmemoHdr: Record "Assignment Memo Header";
        AssignmentMemoLine: Record "Assignment Memo Line";
        AssignmentMemoMgt: Codeunit "Assignment Memo Mgt";

    procedure SetAssignmentmemoLine(AMemoLine: Record "Assignment Memo Line")
    begin
        AssignmentMemoLine := AMemoLine;
        AssignmentmemoHdr.Get(AMemoLine."Document No.");
    end;

    procedure SetParamenterFromPortal(AMemoLine: Record "Assignment Memo Line"; FromDatePara: Date; ToDatePara: Date; EmpNo: Code[20])
    begin
        AssignmentMemoLine := AMemoLine;
        AssignmentmemoHdr.Get(AMemoLine."Document No.");
        FromDate := FromDatePara;
        ToDate := ToDatePara;
        EmployeeNo := EmpNo;
    end;
}
