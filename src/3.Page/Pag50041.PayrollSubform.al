page 50041 "Payroll Subform"
{
    // version PRM19.01.01

    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Payroll Line";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field(Number; Rec.Number)
                {
                    ToolTip = 'Specifies the value of the Number field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Employee Type"; Rec."Employee Type")
                {
                    ToolTip = 'Specifies the value of the Employee Type field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Salary Level"; Rec."Salary Level")
                {
                    ToolTip = 'Specifies the value of the Salary Level field.';
                    ApplicationArea = All;
                }
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.';
                    ApplicationArea = All;
                }
                field("Present Days"; Rec."Present Days")
                {
                    ToolTip = 'Specifies the value of the Present Days field.';
                    ApplicationArea = All;
                }
                field("Week off Days"; Rec."Week off Days")
                {
                    ToolTip = 'Specifies the value of the Week off Days field.';
                    ApplicationArea = All;
                }
                field("Leave Days"; Rec."Leave Days")
                {
                    ToolTip = 'Specifies the value of the Leave Days field.';
                    ApplicationArea = All;
                }
                field("Absent Days"; Rec."Absent Days")
                {
                    ToolTip = 'Specifies the value of the Absent Days field.';
                    ApplicationArea = All;
                }
                field("Prior Present Days"; Rec."Prior Present Days")
                {
                    ToolTip = 'Specifies the value of the Prior Present Days field.';
                    ApplicationArea = All;
                }
                field("LWP Days"; Rec."LWP Days")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the LWP Days field.';
                    ApplicationArea = All;
                }
                field("Prior Leave Days"; Rec."Prior Leave Days")
                {
                    ToolTip = 'Specifies the value of the Prior Leave Days field.';
                    ApplicationArea = All;
                }
                field("Total Days"; Rec."Total Days")
                {
                    ToolTip = 'Specifies the value of the Total Days field.';
                    ApplicationArea = All;
                }
                field("Prior Absent Days"; Rec."Prior Absent Days")
                {
                    ToolTip = 'Specifies the value of the Prior Absent Days field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50487"; Rec."Variable Field 50487")
                {
                    Visible = Field50487Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50487 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50488"; Rec."Variable Field 50488")
                {
                    Visible = Field50488Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50488 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50489"; Rec."Variable Field 50489")
                {
                    Visible = Field50489Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50489 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50490"; Rec."Variable Field 50490")
                {
                    Visible = Field50490Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50490 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50491"; Rec."Variable Field 50491")
                {
                    Visible = Field50491Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50491 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50492"; Rec."Variable Field 50492")
                {
                    Visible = Field50492Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50492 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50493"; Rec."Variable Field 50493")
                {
                    Visible = Field50493Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50493 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50494"; Rec."Variable Field 50494")
                {
                    Visible = Field50494Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50494 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50495"; Rec."Variable Field 50495")
                {
                    Visible = Field50495Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50495 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50496"; Rec."Variable Field 50496")
                {
                    Visible = Field50496Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50496 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50497"; Rec."Variable Field 50497")
                {
                    Visible = Field50497Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50497 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50498"; Rec."Variable Field 50498")
                {
                    Visible = Field50498Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50498 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50499"; Rec."Variable Field 50499")
                {
                    Visible = Field50499Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50499 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50500"; Rec."Variable Field 50500")
                {
                    Visible = Field50500Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50500 field.';
                    ApplicationArea = All;
                }
                field("Variable Field 50501"; Rec."Variable Field 50501")
                {
                    Visible = Field50501Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50501 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50501"));
                    end;
                }
                field("Variable Field 50502"; Rec."Variable Field 50502")
                {
                    Visible = Field50502Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50502 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50502"));
                    end;
                }
                field("Variable Field 50503"; Rec."Variable Field 50503")
                {
                    Visible = Field50503Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50503 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50503"));
                    end;
                }
                field("Variable Field 50504"; Rec."Variable Field 50504")
                {
                    Visible = Field50504Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50504 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50504"));
                    end;
                }
                field("Variable Field 50505"; Rec."Variable Field 50505")
                {
                    Visible = Field50505Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50505 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50505"));
                    end;
                }
                field("Variable Field 50506"; Rec."Variable Field 50506")
                {
                    Visible = Field50506Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50506 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50506"));
                    end;
                }
                field("Variable Field 50507"; Rec."Variable Field 50507")
                {
                    Visible = Field50507Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50507 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50507"));
                    end;
                }
                field("Variable Field 50508"; Rec."Variable Field 50508")
                {
                    Visible = Field50508Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50508 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50508"));
                    end;
                }
                field("Variable Field 50509"; Rec."Variable Field 50509")
                {
                    Visible = Field50509Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50509 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50509"));
                    end;
                }
                field("Variable Field 50510"; Rec."Variable Field 50510")
                {
                    Visible = Field50510Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50510 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50510"));
                    end;
                }
                field("Variable Field 50511"; Rec."Variable Field 50511")
                {
                    Visible = Field50511Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50511 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50511"));
                    end;
                }
                field("Variable Field 50512"; Rec."Variable Field 50512")
                {
                    Visible = Field50512Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50512 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50512"));
                    end;
                }
                field("Variable Field 50513"; Rec."Variable Field 50513")
                {
                    Visible = Field50513Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50513 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50513"));
                    end;
                }
                field("Variable Field 50514"; Rec."Variable Field 50514")
                {
                    Visible = Field50514Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50514 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50514"));
                    end;
                }
                field("Variable Field 50515"; Rec."Variable Field 50515")
                {
                    Visible = Field50515Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50515 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50515"));
                    end;
                }
                field("Variable Field 50516"; Rec."Variable Field 50516")
                {
                    Visible = Field50516Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50516 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50516"));
                    end;
                }
                field("Variable Field 50517"; Rec."Variable Field 50517")
                {
                    Visible = Field50517Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50517 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50517"));
                    end;
                }
                field("Variable Field 50518"; Rec."Variable Field 50518")
                {
                    Visible = Field50518Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50518 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50518"));
                    end;
                }
                field("Variable Field 50519"; Rec."Variable Field 50519")
                {
                    Visible = Field50519Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50519 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50519"));
                    end;
                }
                field("Variable Field 50520"; Rec."Variable Field 50520")
                {
                    Visible = Field50520Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50520 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50520"));
                    end;
                }
                field("Variable Field 50521"; Rec."Variable Field 50521")
                {
                    Visible = Field50521Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50521 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50521"));
                    end;
                }
                field("Variable Field 50522"; Rec."Variable Field 50522")
                {
                    Visible = Field50522Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50522 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50522"));
                    end;
                }
                field("Variable Field 50523"; Rec."Variable Field 50523")
                {
                    Visible = Field50523Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50523 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50523"));
                    end;
                }
                field("Variable Field 50524"; Rec."Variable Field 50524")
                {
                    Visible = Field50524Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50524 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50524"));
                    end;
                }
                field("Variable Field 50525"; Rec."Variable Field 50525")
                {
                    Visible = Field50525Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50525 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50525"));
                    end;
                }
                field("Variable Field 50526"; Rec."Variable Field 50526")
                {
                    Visible = Field50526Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50526 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50526"));
                    end;
                }
                field("Variable Field 50527"; Rec."Variable Field 50527")
                {
                    Visible = Field50527Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50527 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50527"));
                    end;
                }
                field("Variable Field 50528"; Rec."Variable Field 50528")
                {
                    Visible = Field50528Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50528 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50528"));
                    end;
                }
                field("Variable Field 50529"; Rec."Variable Field 50529")
                {
                    Visible = Field50529Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50529 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50529"));
                    end;
                }
                field("Variable Field 50530"; Rec."Variable Field 50530")
                {
                    Visible = Field50530Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50530 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50530"));
                    end;
                }
                field("Variable Field 50531"; Rec."Variable Field 50531")
                {
                    Visible = Field50531Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50531 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50531"));
                    end;
                }
                field("Variable Field 50532"; Rec."Variable Field 50532")
                {
                    Visible = Field50532Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50532 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50532"));
                    end;
                }
                field("Variable Field 50533"; Rec."Variable Field 50533")
                {
                    Visible = Field50533Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50533 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50533"));
                    end;
                }
                field("Variable Field 50534"; Rec."Variable Field 50534")
                {
                    Visible = Field50534Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50534 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50534"));
                    end;
                }
                field("Variable Field 50535"; Rec."Variable Field 50535")
                {
                    Visible = Field50535Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50535 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50535"));
                    end;
                }
                field("Variable Field 50536"; Rec."Variable Field 50536")
                {
                    Visible = Field50536Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50536 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50536"));
                    end;
                }
                field("Variable Field 50537"; Rec."Variable Field 50537")
                {
                    Visible = Field50537Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50537 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50537"));
                    end;
                }
                field("Variable Field 50538"; Rec."Variable Field 50538")
                {
                    Visible = Field50538Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50538 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50538"));
                    end;
                }
                field("Variable Field 50539"; Rec."Variable Field 50539")
                {
                    Visible = Field50539Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50539 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50539"));
                    end;
                }
                field("Variable Field 50540"; Rec."Variable Field 50540")
                {
                    Visible = Field50540Visible;
                    ToolTip = 'Specifies the value of the Variable Field 50540 field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CheckFlexibility(Rec.FieldNo("Variable Field 50540"));
                    end;
                }
                field("Projection Month"; Rec."Projection Month")
                {
                    ToolTip = 'Specifies the value of the Projection Month field.';
                    ApplicationArea = All;
                }
                field("Carry Forward Annual"; Rec."Carry Forward Annual")
                {
                    Visible = SettlementVisible;
                    ToolTip = 'Specifies the value of the Carry Forward Annual field.';
                    ApplicationArea = All;
                }
                field("Prorata Annual"; Rec."Prorata Annual")
                {
                    Visible = SettlementVisible;
                    ToolTip = 'Specifies the value of the Prorata Annual field.';
                    ApplicationArea = All;
                }
                field("Used Leave Annual"; Rec."Used Leave Annual")
                {
                    Visible = SettlementVisible;
                    ToolTip = 'Specifies the value of the Used Leave Annual field.';
                    ApplicationArea = All;
                }
                field("Annual Leave Days"; Rec."Annual Leave Days")
                {
                    Visible = SettlementVisible;
                    ToolTip = 'Specifies the value of the Annual Leave Days field.';
                    ApplicationArea = All;
                }
                field("Carry Forwarded Sick"; Rec."Carry Forwarded Sick")
                {
                    Visible = SettlementVisible;
                    ToolTip = 'Specifies the value of the Carry Forwarded Sick field.';
                    ApplicationArea = All;
                }
                field("Prorata Sick"; Rec."Prorata Sick")
                {
                    Visible = SettlementVisible;
                    ToolTip = 'Specifies the value of the Prorata Sick field.';
                    ApplicationArea = All;
                }
                field("Used Leave Sick"; Rec."Used Leave Sick")
                {
                    Visible = SettlementVisible;
                    ToolTip = 'Specifies the value of the Used Leave Sick field.';
                    ApplicationArea = All;
                }
                field("Sick Leave Days"; Rec."Sick Leave Days")
                {
                    Visible = SettlementVisible;
                    ToolTip = 'Specifies the value of the Sick Leave Days field.';
                    ApplicationArea = All;
                }
                field("Total Adjusted Leave Days"; Rec."Total Adjusted Leave Days")
                {
                    Visible = SettlementVisible;
                    ToolTip = 'Specifies the value of the Total Adjusted Leave Days field.';
                    ApplicationArea = All;
                }
                field("Gratuity & leave Encash Tax"; Rec."Gratuity & leave Encash Tax")
                {
                    Visible = SettlementVisible;
                    ToolTip = 'Specifies the value of the Gratuity & leave Encash Tax field.';
                    ApplicationArea = All;
                }
                field("Tax for Period"; Rec."Tax for Period")
                {
                    ToolTip = 'Specifies the value of the Tax for Period field.';
                    ApplicationArea = All;
                }
                field("Current Benefit"; Rec."Current Benefit")
                {
                    ToolTip = 'Specifies the value of the Current Benefit field.';
                    ApplicationArea = All;
                }
                field("Current Non-Payments"; Rec."Current Non-Payments")
                {
                    ToolTip = 'Specifies the value of the Current Non-Payments field.';
                    ApplicationArea = All;
                }
                field("Projected Benefit"; Rec."Projected Benefit")
                {
                    ToolTip = 'Specifies the value of the Projected Benefit field.';
                    ApplicationArea = All;
                }
                field("Projected Non-Payments"; Rec."Projected Non-Payments")
                {
                    ToolTip = 'Specifies the value of the Projected Non-Payment field.';
                    ApplicationArea = All;
                }
                field("Past Benefit"; Rec."Past Benefit")
                {
                    ToolTip = 'Specifies the value of the Past Benefit field.';
                    ApplicationArea = All;
                }
                field("Past Non-Payment"; Rec."Past Non-Payments")
                {
                    ToolTip = 'Specifies the value of the Past Non-Payment field.';
                    ApplicationArea = All;
                }

                field("Assessable Income"; Rec."Assessable Income")
                {
                    ToolTip = 'Specifies the value of the Assessable Income field.';
                    ApplicationArea = All;
                }
                field("Past Retirement Fund"; Rec."Past Retirement Fund")
                {
                    ToolTip = 'Specifies the value of the Past Retirement Fund field.';
                    ApplicationArea = All;
                }
                field("Projected Retirement Fund"; Rec."Projected Retirement Fund")
                {
                    ToolTip = 'Specifies the value of the Projected Retirement Fund field.';
                    ApplicationArea = All;
                }
                field("Actual RF Contribution"; Rec."Actual RF Contribution")
                {
                    ToolTip = 'Specifies the value of the Actual RF Contribution field.';
                    ApplicationArea = All;
                }
                field("1/3 of Assessable Income"; Rec."1/3 of Assessable Income")
                {
                    ToolTip = 'Specifies the value of the 1/3 of Assessable Income field.';
                    ApplicationArea = All;
                }
                field("Eligible RF Deduction"; Rec."Eligible RF Deduction")
                {
                    ToolTip = 'Specifies the value of the Eligible RF Deduction field.';
                    ApplicationArea = All;
                }
                field("Taxable Income"; Rec."Taxable Income")
                {
                    ToolTip = 'Specifies the value of the Taxable Income field.';
                    ApplicationArea = All;
                }
                field("Disable Person Reduction"; Rec."Disable Person Reduction")
                {
                    ToolTip = 'Specifies the value of the Disable Person Reduction field.';
                    ApplicationArea = All;
                }
                field("Remote Area Deduction"; Rec."Remote Area Deduction")
                {
                    ToolTip = 'Specifies the value of the Remote Area Deduction field.';
                    ApplicationArea = All;
                }
                field("Life Insurance Premium"; Rec."Life Insurance Premium")
                {
                    ToolTip = 'Specifies the value of the Life Insurance Premium field.';
                    ApplicationArea = All;
                }
                field("Health Insurance Premium"; Rec."Health Insurance Premium")
                {
                    ToolTip = 'Specifies the value of the Health Insurance Premium field.';
                    ApplicationArea = All;
                }
                field("Property Insurance Premium"; Rec."Property Insurance Premium")
                {
                    ToolTip = 'Specifies the value of the Property Insurance Premium field.';
                    ApplicationArea = All;
                }
                field("Balance Taxable Income"; Rec."Balance Taxable Income")
                {
                    ToolTip = 'Specifies the value of the Balance Taxable Income field.';
                    ApplicationArea = All;
                }
                field("Social Security Tax(Annual)"; Rec."Social Security Tax(Annual)")
                {
                    ToolTip = 'Specifies the value of the Social Security Tax(Annual) field.';
                    ApplicationArea = All;
                }
                field("Tax on Remuneration(Annual)"; Rec."Tax on Remuneration(Annual)")
                {
                    ToolTip = 'Specifies the value of the Tax on Remuneration(Annual) field.';
                    ApplicationArea = All;
                }
                field("Total Tax Liability"; Rec."Total Tax Liability")
                {
                    ToolTip = 'Specifies the value of the Total Tax Liability field.';
                    ApplicationArea = All;
                }
                field("Female Tax Credit"; Rec."Female Tax Credit")
                {
                    ToolTip = 'Specifies the value of the Female Tax Credit field.';
                    ApplicationArea = All;
                }
                field("Payable Tax Liability"; Rec."Payable Tax Liability")
                {
                    ToolTip = 'Specifies the value of the Payable Tax Liability field.';
                    ApplicationArea = All;
                }
                field("Total Tax Paid"; Rec."Total Tax Paid")
                {
                    ToolTip = 'Specifies the value of the Total Tax Paid field.';
                    ApplicationArea = All;
                }
                field("Net Tax Liability"; Rec."Net Tax Liability")
                {
                    ToolTip = 'Specifies the value of the Net Tax Liability field.';
                    ApplicationArea = All;
                }
                field("Current Deduction"; Rec."Current Deduction")
                {
                    ToolTip = 'Specifies the value of the Current Deduction field.';
                    ApplicationArea = All;
                }
                field("Net Pay"; Rec."Net Pay")
                {
                    ToolTip = 'Specifies the value of the Net Pay field.';
                    ApplicationArea = All;
                }
                field("Total Employer Contribution"; Rec."Total Employer Contribution")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Total Employer Contribution field.';
                    ApplicationArea = All;
                }
                field("Total Tax Credit"; Rec."Total Tax Credit")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Total Tax Credit field.';
                    ApplicationArea = All;
                }
                field("1% Slab"; Rec."1% Slab")
                {
                    ToolTip = 'Specifies the value of the 1% Slab field.';
                    ApplicationArea = All;
                }
                field("10% Slab"; Rec."10% Slab")
                {
                    ToolTip = 'Specifies the value of the 10% Slab field.';
                    ApplicationArea = All;
                }
                field("20% Slab"; Rec."20% Slab")
                {
                    ToolTip = 'Specifies the value of the 20% Slab field.';
                    ApplicationArea = All;
                }
                field("30% Slab"; Rec."30% Slab")
                {
                    ToolTip = 'Specifies the value of the 30% Slab field.';
                    ApplicationArea = All;
                }
                field("36% Slab"; Rec."36% Slab")
                {
                    ToolTip = 'Specifies the value of the 36% Slab field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Payroll Attributes Usage")
            {
                Image = PaymentDays;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Payroll Attributes Usage";
                RunPageLink = "Employee Code" = field("Employee No.");
                ToolTip = 'Executes the Payroll Attributes Usage action.';
                ApplicationArea = All;
            }
            action(Dimensions)
            {
                AccessByPermission = tabledata Dimension = R;
                Caption = 'Dimensions';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;
                ShortcutKey = 'Shift+Ctrl+D';
                ToolTip = 'Executes the Dimensions action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.ShowDimensions;
                    CurrPage.SaveRecord;
                end;
            }
            action(Attendance)
            {
                Image = DepositLines;
                Promoted = true;
                Visible = (not HourCalculationVisible);
                ToolTip = 'Executes the Attendance action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.GetAttendance;
                end;
            }
            action("Timesheet Summary")
            {
                Image = Timeline;
                Promoted = true;
                PromotedCategory = "Report";
                Visible = TimeSheetVisible;
                ToolTip = 'Executes the Timesheet Summary action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //GetTimeSheet;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PayrollHeader.Get(Rec."Document No.");
        if PayrollHeader.Type = PayrollHeader.Type::Resignation then
            SettlementVisible := true;
    end;

    trigger OnOpenPage()
    begin
        InitColumnVisibility;
        SetCurrentKey("Employee No.");
    end;

    var
        PayrollEngine: Codeunit "Payroll Engine";
        Field50490Visible: Boolean;
        Field50491Visible: Boolean;
        Field50492Visible: Boolean;
        Field50493Visible: Boolean;
        Field50494Visible: Boolean;
        Field50495Visible: Boolean;
        Field50496Visible: Boolean;
        Field50497Visible: Boolean;
        Field50498Visible: Boolean;
        Field50499Visible: Boolean;
        Field50500Visible: Boolean;
        Field50501Visible: Boolean;
        Field50502Visible: Boolean;
        Field50503Visible: Boolean;
        Field50504Visible: Boolean;
        Field50505Visible: Boolean;
        Field50506Visible: Boolean;
        Field50507Visible: Boolean;
        Field50508Visible: Boolean;
        Field50509Visible: Boolean;
        Field50510Visible: Boolean;
        Field50511Visible: Boolean;
        Field50512Visible: Boolean;
        Field50513Visible: Boolean;
        Field50514Visible: Boolean;
        Field50515Visible: Boolean;
        Field50516Visible: Boolean;
        Field50517Visible: Boolean;
        Field50518Visible: Boolean;
        Field50519Visible: Boolean;
        Field50520Visible: Boolean;
        Field50521Visible: Boolean;
        Field50522Visible: Boolean;
        Field50523Visible: Boolean;
        Field50524Visible: Boolean;
        Field50525Visible: Boolean;
        Field50526Visible: Boolean;
        Field50527Visible: Boolean;
        Field50528Visible: Boolean;
        Field50529Visible: Boolean;
        Field50530Visible: Boolean;
        Field50531Visible: Boolean;
        Field50532Visible: Boolean;
        Field50533Visible: Boolean;
        Field50534Visible: Boolean;
        Field50535Visible: Boolean;
        Field50536Visible: Boolean;
        Field50537Visible: Boolean;
        Field50538Visible: Boolean;
        Field50539Visible: Boolean;
        Field50540Visible: Boolean;
        Field50489Visible: Boolean;
        Field50487Visible: Boolean;
        Field50488Visible: Boolean;
        [InDataSet]
        HourCalculationVisible: Boolean;
        [InDataSet]
        TimeSheetVisible: Boolean;
        [InDataSet]
        SettlementVisible: Boolean;
        PayrollHeader: Record "Payroll Header";

    local procedure InitColumnVisibility()
    begin
        Field50490Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50490"));
        Field50491Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50491"));
        Field50492Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50492"));
        Field50493Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50493"));
        Field50494Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50494"));
        Field50495Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50495"));
        Field50496Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50496"));
        Field50497Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50497"));
        Field50498Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50498"));
        Field50499Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50499"));
        Field50500Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50500"));
        Field50501Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50501"));
        Field50502Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50502"));
        Field50503Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50503"));
        Field50504Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50504"));
        Field50505Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50505"));
        Field50506Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50506"));
        Field50507Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50507"));
        Field50508Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50508"));
        Field50509Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50509"));
        Field50510Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50510"));
        Field50511Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50511"));
        Field50512Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50512"));
        Field50513Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50513"));
        Field50514Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50514"));
        Field50515Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50515"));
        Field50516Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50516"));
        Field50517Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50517"));
        Field50518Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50518"));
        Field50519Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50519"));
        Field50520Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50520"));
        Field50521Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50521"));
        Field50522Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50522"));
        Field50523Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50523"));
        Field50524Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50524"));
        Field50525Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50525"));
        Field50526Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50526"));
        Field50527Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50527"));
        Field50528Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50528"));
        Field50529Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50529"));
        Field50530Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50530"));
        Field50531Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50531"));
        Field50532Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50532"));
        Field50533Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50533"));
        Field50534Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50534"));
        Field50535Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50535"));
        Field50536Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50536"));
        Field50537Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50537"));
        Field50538Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50538"));
        Field50539Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50539"));
        Field50540Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50540"));
        Field50489Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50489")); //Min 9.15.2022
        Field50487Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50487")); //Min 12.09.2022
        Field50488Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", Rec.FieldNo("Variable Field 50488")); //Min 9.15.2022
        HourCalculationVisible := PayrollEngine.IsHourCalculation;
        TimeSheetVisible := PayrollEngine.IsTimeSheetEnabled;
    end;
}
