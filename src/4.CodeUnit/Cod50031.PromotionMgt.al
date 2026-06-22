codeunit 50031 "Promotion Mgt"
{
    procedure UpdateInEmployeeProfile(ServiceHistoryCode: Code[20])
    begin
        if ServiceHistory.Get(ServiceHistoryCode) then
            if EmployeeRec.Get(ServiceHistory."Employee No.") then begin
                EmployeeRec.Validate("Salary Level", ServiceHistory."Salary Level (To)");
                EmployeeRec.Validate("Salary Grade", ServiceHistory."Salary Grade (To)");
                EmployeeRec.Validate("Approver Role", ServiceHistory."Approver Role (To)");
                EmployeeRec.Validate("Functional Title", ServiceHistory."Functional Title (To)");
                EmployeeRec.Validate("Staff level", ServiceHistory."Staff Level (To)");
                EmployeeRec.Validate("Promotion Date", ServiceHistory."Effective Date");
                EmployeeRec.Modify(true);
            end;
    end;

    procedure UpdatePromotion(EmpNo: Code[20])
    var
        PromotionPageBuilder: FilterPageBuilder;
        PromotionHistory: Record "Promotion";
        PromoHis: Record "Promotion";
        PromotedDate: Date;
        ServiceHistory: Record "Employee Service History";
        ServiceHistoryCode: Code[20];
        PreviousServiceHistory: Record "Employee Service History";
        ServiceHistoryMgt: Codeunit "Service History Mgt";
    begin
        EmployeeRec.Get(EmpNo);
        PromotionPageBuilder.AddRecord('Promote Employee', PromotionHistory);
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory."Promoted Salary Level");
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory."Promoted Salary Grade");
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory."Promotion Date");
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory."Promoted Functional Title");
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory.Remarks);
        if PromotionPageBuilder.RunModal then begin
            PromotionHistory.SetView(PromotionPageBuilder.GetView('Promote Employee'));
            Evaluate(PromotedDate, PromotionHistory.GetFilter("Promotion Date"));
            Clear(PromoHis);
            PromoHis.Init;
            PromoHis.Validate("Employee No.", EmpNo);
            PromoHis.Validate("Promotion Date", PromotedDate);
            PromoHis.Validate("Promoted Salary Level", PromotionHistory.GetFilter("Promoted Salary Level"));
            PromoHis.Validate("Promoted Salary Grade", PromotionHistory.GetFilter("Promoted Salary Grade"));
            PromoHis.Validate("Promoted Functional Title", PromotionHistory.GetFilter("Promoted Functional Title"));
            PromoHis.Validate(Remarks, PromotionHistory.GetFilter(Remarks));
            PromoHis.Insert(true);
            ServiceHistoryCode := ServiceHistoryMgt.AddToServiceHistory(EmpNo, ServiceHistory."Service Event"::"Internal Appointment", 'Promoted', PromotedDate);
            EmployeeRec.Validate("Salary Level", PromotionHistory.GetFilter("Promoted Salary Level"));
            EmployeeRec.Validate("Salary Grade", PromotionHistory.GetFilter("Promoted Salary Grade"));
            EmployeeRec.Validate("Functional Title", PromotionHistory.GetFilter("Promoted Functional Title"));
            EmployeeRec.Validate("Promotion Date", PromotedDate);
            EmployeeRec.Modify;
            if ServiceHistory.Get(ServiceHistoryCode) then begin
                ServiceHistory.Validate("Functional Title (To)", EmployeeRec."Functional Title");
                ServiceHistory.Validate("Salary Grade (To)", EmployeeRec."Salary Grade");
                ServiceHistory.Validate("Salary Level (To)", EmployeeRec."Salary Level");
                ServiceHistory.Validate("Deputation On (To)", EmployeeRec."Deputation on");
                ServiceHistory.Validate("Deputation Code (To)", ServiceHistoryMgt.ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                ServiceHistory.Validate("Deputation Value (To)", ServiceHistoryMgt.ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                ServiceHistory.Validate(Remarks, PromotionHistory.GetFilter(Remarks));
                PreviousServiceHistory.Reset;
                PreviousServiceHistory.SetRange("Employee No.", EmployeeRec."No.");
                PreviousServiceHistory.SetFilter("Service History Code", '<>%1', ServiceHistoryCode);
                PreviousServiceHistory.SetCurrentKey("Effective Date");
                if PreviousServiceHistory.FindLast then begin
                    ServiceHistory."Outstation Eligible" := PreviousServiceHistory."Outstation Eligible";
                end;
                ServiceHistory.Modify;
            end;
            Message('Employee Promoted');
        end;
    end;

    var
        EmployeeRec: Record Employee;
        ServiceHistory: Record "Employee Service History";
}
