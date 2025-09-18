table 50157 "Payroll Setup Lines"
{
    Caption = 'Payroll Setup Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Pay Cycle Term"; Code[10])
        {
            Caption = 'Pay Cycle Term';
            TableRelation = "Pay Cycle Term".Term;
        }
        field(2; "Tax Ex. Amt. on Retirement"; Decimal)
        {
            Caption = 'Tax Ex. Amt. (%) on Retirement Contribution';
        }
        field(3; "Tax Ex. Amt. not Exceeding"; Decimal)
        {
            Caption = 'Tax Ex. Amt. not Exceeding Retirement Limit';
        }
        field(4; "Tax Ex. Amt. not Exceeding SSF"; Decimal)
        {
            Caption = '	Tax Ex. Amt. not Exceeding Retirement Limit (SSF)';
        }
        field(5; "Tax Ex. Insurance Amt."; Decimal)
        {
            Caption = 'Tax Ex. Life Insurance Amt. Limit';
        }
        field(6; "Tax Ex. Medical Insurance Amt."; Decimal)
        {
            Caption = 'Tax Ex. Medical Insurance Amt. Limit';
        }
        field(7; "Tax Ex. House Insurance Amt."; Decimal)
        {
            Caption = 'Tax Ex. House Insurance Amt. Limit';
        }
        field(8; "Tax Ex. Amt. on Donation"; Decimal)
        {
            Caption = 'Tax Ex. Amt. (%) on Donation';
        }
        field(9; "Tax Ex. Amt. not Exceed Don."; Decimal)
        {
            Caption = 'Tax Ex. Amt. not Exceed on Donation Limit';
        }
        field(10; "Tax Ex. Amt. on Medical Reim"; Decimal)
        {
            Caption = 'Tax Ex. Amt. (%) on Medical Reimbursement';
        }
        field(11; "Tax Ex. Amt. not Exceed Med."; Decimal)
        {
            Caption = 'Tax Ex. Amt. not Exceed Medical Reimbursement Limit';
        }
    }
    keys
    {
        key(PK; "Pay Cycle Term")
        {
            Clustered = true;
        }
    }
}
