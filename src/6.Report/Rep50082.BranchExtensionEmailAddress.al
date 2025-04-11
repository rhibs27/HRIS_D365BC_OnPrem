report 50082 "Branch/Extension Email Address"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019883.BranchExtensionEmailAddress.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(Title; Title) { }
            dataitem("Organization Structure List"; "Organization Structure List")
            {
                DataItemTableView = where(Type = filter(type::Branch));
                column(BranchCode; Code) { }
                column(BranchName; Name) { }
                column(ECMail; ECMail) { }
                column(BMMail; BMMail) { }

                trigger OnAfterGetRecord()
                begin
                    Clear(ECMail);
                    Clear(BMMail);
                    FunctionalTitle.Reset;
                    FunctionalTitle.SetRange("EM/ECM Identifier", true);
                    if FunctionalTitle.Find('-') then
                        repeat
                            Employee.Reset;
                            Employee.SetRange("Deputation on", Employee."Deputation on"::Branch);
                            Employee.SetRange("Global Dimension 1 Code", Code);
                            Employee.SetRange("Functional Title", FunctionalTitle.Code);
                            if Employee.FindFirst then begin
                                if ECMail = '' then
                                    ECMail := Employee."Company E-Mail"
                                else
                                    ECMail += ', ' + Employee."Company E-Mail";
                            end;
                        until FunctionalTitle.Next = 0;

                    FunctionalTitle.Reset;
                    FunctionalTitle.SetRange("BM/OBM", true);
                    if FunctionalTitle.Find('-') then
                        repeat
                            Employee.Reset;
                            Employee.SetRange("Deputation on", Employee."Deputation on"::Branch);
                            Employee.SetRange("Global Dimension 1 Code", Code);
                            Employee.SetRange("Functional Title", FunctionalTitle.Code);
                            if Employee.FindFirst then begin
                                if BMMail = '' then
                                    BMMail := Employee."Company E-Mail"
                                else
                                    BMMail += ', ' + Employee."Company E-Mail";
                            end;
                        until FunctionalTitle.Next = 0;
                end;
            }
            dataitem("Organization Structure List 1"; "Organization Structure List")
            {
                DataItemTableView = where(Type = filter(type::"Extension Counter"));
                column(ExtensionCode; Code) { }
                column(ExtensionName; Name) { }
                column(ECMail1; ECMail1) { }
                column(BMMail1; BMMail1) { }

                trigger OnAfterGetRecord()
                begin
                    Clear(ECMail1);
                    Clear(BMMail1);
                    FunctionalTitle.Reset;
                    FunctionalTitle.SetRange("EM/ECM Identifier", true);
                    if FunctionalTitle.Find('-') then
                        repeat
                            EmpVar.Reset;
                            EmpVar.SetRange("Deputation on", EmpVar."Deputation on"::"Extension Counter");
                            EmpVar.SetRange("Extension Counter Code", Code);
                            EmpVar.SetRange("Functional Title", FunctionalTitle.Code);
                            if EmpVar.FindFirst then begin
                                if ECMail1 = '' then
                                    ECMail1 := EmpVar."Company E-Mail"
                                else
                                    ECMail1 += ', ' + EmpVar."Company E-Mail";
                            end;
                        until FunctionalTitle.Next = 0;

                    FunctionalTitle.Reset;
                    FunctionalTitle.SetRange("BM/OBM", true);
                    if FunctionalTitle.Find('-') then
                        repeat
                            EmpVar.Reset;
                            EmpVar.SetRange("Deputation on", EmpVar."Deputation on"::Branch);
                            EmpVar.SetRange("Global Dimension 1 Code", code);
                            EmpVar.SetRange("Functional Title", FunctionalTitle.Code);
                            if EmpVar.FindFirst then begin
                                if BMMail1 = '' then
                                    BMMail1 := EmpVar."Company E-Mail"
                                else
                                    BMMail1 += ', ' + EmpVar."Company E-Mail";
                            end;
                        until FunctionalTitle.Next = 0;
                end;
            }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    var
        Employee: Record Employee;
        EmpVar: Record Employee;
        FunctionalTitle: Record "Functional Title";
        ECMail: Text;
        BMMail: Text;
        ECMail1: Text;
        BMMail1: Text;
        Title: Label 'Branch/Extension Counter Email Reports';
}
