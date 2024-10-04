query 33019800 "Payroll Query"
{
    elements
    {
        dataitem(Detailed_Employee_Ledger_Entry; "Detailed Employee Ledger Entry")
        {
            SqlJoinType = LeftOuterJoin;
            filter(Finacle_GL_No; "Finacle GL No") { }
            filter(Document_No; "Document No.") { }
            filter(Attribute_Sub_Type; "Attribute Sub Type") { }
            column(FinacleAccNo; "Finacle GL No") { }
            column(FinacleGLName; "Finacle GL Name") { }
            column(Pay_Cycle_Code; "Pay Cycle Code") { }
            column(Pay_Cycle_Period; "Pay Cycle Period") { }
            column(Posting_Date; "Posting Date") { }
            column(Sum_Amount; Amount)
            {
                Method = Sum;
            }
        }
    }
}
