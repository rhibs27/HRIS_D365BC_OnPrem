table 50076 Candidate
{
    Caption = 'Candidate';
    DataCaptionFields = "No.", "First Name", "Middle Name", "Last Name";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    HumanResSetup.Get;
                    NoSeriesMgt.TestManual(HumanResSetup."Candidate Nos.");
                    "No. Series" := '';
                end;
                // HRMgt.InsertAttachmentLines("No.", 'CV');
            end;
        }
        field(2; "First Name"; Text[30])
        {
            Caption = 'First Name';

            trigger OnValidate()
            begin
                TestField("First Name");
                ValidateCandidateName;
            end;
        }
        field(3; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';

            trigger OnLookup()
            begin
                ValidateCandidateName;
            end;
        }
        field(4; "Last Name"; Text[30])
        {
            Caption = 'Last Name';

            trigger OnValidate()
            begin
                TestField("First Name");
                TestField("Last Name");
                ValidateCandidateName;
            end;
        }
        field(5; Initials; Text[30])
        {
            Caption = 'Initials';
        }
        field(6; "Job Title"; Text[30])
        {
            Caption = 'Job Title';
        }
        field(7; "Permanent Address"; Text[200])
        {
            Caption = 'Address';
        }
        field(8; "Address 2"; Text[200])
        {
            Caption = 'Address 2';
        }
        field(9; County; Text[30])
        {
            Caption = 'County';
        }
        field(10; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(11; "Mobile No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(12; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(13; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
        }
        field(14; Gender; Enum "Employee Gender")
        {
            Caption = 'Gender';
        }
        field(15; Status; Enum "Candidate Status")
        {
            Caption = 'Status';
            trigger OnValidate()
            begin
                /*EmployeeQualification.SETRANGE("Employee No.","No.");
                EmployeeQualification.MODIFYALL("Employee Status",Status);
                MODIFY;
                */
            end;
        }
        field(16; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                /*ValidateShortcutDimCode(1,"Global Dimension 1 Code");*/
            end;
        }
        field(17; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                /*ValidateShortcutDimCode(2,"Global Dimension 2 Code");*/
            end;
        }
        field(18; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(19; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(20; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(21; "Cause of Absence Filter"; Code[10])
        {
            Caption = 'Cause of Absence Filter';
            FieldClass = FlowFilter;
            TableRelation = "Cause of Absence";
        }
        field(22; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(23; "Salary Grade"; Code[20])
        {
            TableRelation = "Salary Grade";
        }
        field(24; "Full Name"; Text[40]) { }
        field(25; "G/L Account Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "G/L Account"."No.";
        }
        field(26; "User Id"; Code[50])
        {
        }
        field(27; "Third Party Payroll Emp Code"; Code[10])
        {
        }
        field(28; "Job Position Type"; Enum "Job Position Type")
        {

        }
        field(29; "Recruitement Status"; Enum "Recruitement Status")
        {

        }
        field(30; "Applied Salary Level"; Code[20])
        {
            TableRelation = "Vacancy Line"."Salary Level" where("Vacancy No." = field("Vacancy Code"));
        }
        field(31; Age; Decimal) { }
        field(32; "Commercial Banking Experience"; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Total Experience", "Commercial Banking Experience" + "Development Banking Experience");
            end;
        }
        field(33; "Offer Letter Printed"; Boolean) { }
        field(34; "Application Letter Printed"; Boolean) { }
        field(35; "Personal Title"; Text[10])
        {
            Description = 'refered to as Mr.,Mrs.';
        }
        field(36; "Vacancy Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Vacancy Header"."No." where(Posted = const(true));

            trigger OnValidate()
            begin
                if VacancyHeader.Get("Vacancy Code") then begin
                    VacancyHeader.TestField("Vacancy Expiry Date");
                    VacancyHeader.TestField(Type);
                    Validate("Vacancy Type", VacancyHeader.Type);
                    Validate("Vacancy Expiry Date", VacancyHeader."Vacancy Expiry Date");
                    Validate("Vacancy Description", VacancyHeader.Description);
                end;
            end;
        }
        field(37; "Education Qualification"; Code[20])
        {
            TableRelation = Qualification where(Rank = filter(<> 0));
        }
        field(38; "Shortlisted Process"; Boolean)
        {
        }
        field(39; "Converted to Emp. Date"; Date)
        {
        }
        field(40; "Converted to Employee"; Boolean)
        {
        }
        field(41; "Avg. Inverview Score"; Decimal)
        {
        }
        field(42; Type; Enum "Candidate Type")
        {

        }
        field(43; "Interview Date"; Date) { }
        field(44; "Interview Time"; Time) { }
        field(45; "Qualification Code"; Code[20])
        {
            TableRelation = Qualification.Code where(Type = const(Education));

            trigger OnValidate()
            begin
                if Qualification.Get("Qualification Code") then
                    Validate(Rank, Qualification.Rank)
                else
                    Clear(Rank);
            end;
        }
        field(46; Rank; Integer)
        {
            Editable = false;
        }
        field(47; "Development Banking Experience"; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Total Experience", "Commercial Banking Experience" + "Development Banking Experience");
            end;
        }
        field(48; "Applied Branch"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                              Blocked = const(false));
        }
        field(49; "Preferred Province"; Code[20])
        {
            TableRelation = Province;
        }
        field(50; "Written Score"; Decimal)
        {
            trigger OnValidate()
            begin
                //TESTFIELD(Status, Status::"Manual Shortlist"); //Min Commented -- Not Required
                if FunctionalTitle.Get("Functional Title") then
                    if FunctionalTitle."Written Exam" and FunctionalTitle."Group Discussion" then begin
                        EvaluationAttributes.Reset;
                        EvaluationAttributes.SetFilter("Attribute Type", '%1|%2', EvaluationAttributes."Attribute Type"::"Written Exam");//,
                                                                                                                                         //EvaluationAttributes."Attribute Type"::"Group Discussion");
                        if EvaluationAttributes.FindFirst then
                            if EvaluationAttributes.PassMarks <= "Written Score" then
                                Validate(Status, Status::"Written/GD Passed");//AT
                    end;
            end;
        }
        field(51; "Total Marks"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TestField(Status, Status::"Interview Scheduled");
                Validate(Status, Status::Interviewed);//AT
            end;
        }
        field(52;
        Venue;
        Text[20])
        { }
        field(53; "Interviewed Date"; Date) { }
        field(54; "Functional Title"; Code[20])
        {
            TableRelation = "Vacancy Line"."Functional Title" where("Vacancy No." = field("Vacancy Code"));
        }
        field(55; "Offer Date"; Date)
        {
        }
        field(56; "Employment Type"; enum "Employee Type")
        {
        }
        field(57; "Offer No."; Code[20])
        {
        }
        field(58; "Fathers Name"; Text[100])
        {
        }
        field(59; "Mothers Name"; Text[100])
        {
        }
        field(60; "Citizenship Id"; Text[20])
        {
        }
        field(61; "Marital Status"; Enum "Marital Status")
        {

        }
        field(62; "Masters Degree Received"; Boolean) { }
        field(63; "Possess Masters transcript"; Boolean) { }
        field(64; "Bachelors Degree Received"; Boolean) { }
        field(65; "Total Experience"; Decimal)
        {
            Editable = false;
        }
        field(66; "Job Grade in Present Company"; Text[30])
        {
        }
        field(67; "Reference Full Name"; Text[100])
        {
        }
        field(68; "Reference Full Address"; Text[50])
        {
        }
        field(69; "Reference Relation"; Text[30])
        {
        }
        field(70; "Tel/Mob. No."; Text[20])
        {
        }
        field(71; "Refernce Name Of Organization"; Text[30])
        {
        }
        field(72; "Candidate Type"; Enum InternalExternal)
        {
        }
        field(73; "Supervisor Code"; Code[20]) { }
        field(74; Salary; Decimal) { }
        field(75; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(76; "Recommender Code"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Recommender Code") then
                    Validate("Recommender Name", Employee."Full Name")
                else
                    Clear("Recommender Name");
            end;
        }
        field(77; "Recommender Name"; Text[50])
        {
            Editable = false;
        }
        field(78; "Vacancy Type"; Enum InternalExternal)
        {
            Editable = false;

        }
        field(79; "Vacancy Expiry Date"; Date)
        {
            Editable = false;
        }
        field(80; "Deputation On"; Enum "Deputation Type")
        {

        }
        field(81; "Deputation code"; Code[20]) { }
        field(82; "Deputation Value"; Text[100]) { }
        field(83; "Recommender Remarks"; Text[250]) { }
        field(84; "Candidate Remarks"; Text[250]) { }
        field(85; "Vacancy Description"; Text[100]) { }
        field(86; "Interviewer 1"; Text[50]) { }
        field(87; "Interviewer 2"; Text[50]) { }
        field(88; "Interviewer 3"; Text[50]) { }
        field(89; "Interviewer Count"; Integer) { }
        field(90; "Interview By"; Text[150])
        {
            trigger OnLookup()
            begin
                Validate("Interview By", HRMgt.ReturnSelectedEmployeeCode("Interview By"));
            end;
        }
        field(91; "Interviewer 4"; Text[50]) { }
        field(92; "Interviewer 5"; Text[50]) { }
        field(93; "Current Job Position"; Text[150]) { }
        field(94; "Current Functional Title"; Text[150]) { }
        field(95; "Interviewer 1 Remarks"; Text[50]) { }
        field(96; "Interviewer 2 Remarks"; Text[50]) { }
        field(97; "Interviewer 3 Remarks"; Text[50]) { }
        field(98; "Non-Banking Experience"; Integer) { }
        field(99; "Total Banking Experience"; Integer) { }
        field(100; "Interviewer 4 Remarks"; Text[50]) { }
        field(101; "Interviewer 5 Remarks"; Text[50]) { }
    }

    keys
    {
        key(Key1; "No.", "Vacancy Code") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        IncomingDocument.Reset;
        IncomingDocument.SetRange("No.", Candidate."No.");
        if IncomingDocument.FindFirst then begin
            AttachmentMgt.DeleteAttachment(IncomingDocument);
            // IncomingDocument.DELETE;
        end;
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Candidate Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Candidate Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
        /*
        IF Res.READPERMISSION THEN
          EmployeeResUpdate.HumanResToRes(xRec,Rec);
        IF SalespersonPurchaser.READPERMISSION THEN
          EmployeeSalespersonUpdate.HumanResToSalesPerson(xRec,Rec);
          */
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        EmployeeQualification: Record "Employee Qualification";
        Relative: Record "Employee Relative";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        Text000: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        Candidate: Record Candidate;
        Qualification: Record Qualification;
        HRMgt: Codeunit "HR Mgt.";
        IncomingDocument: Record "Incoming Document";
        // LoanMgt: Codeunit "Loan Mgt.";
        AttachmentMgt: Codeunit "Attachment Mgt.";
        FunctionalTitle: Record "Functional Title";
        EvaluationAttributes: Record "Evaluation Attribute";
        ServiceHistory: Record "Employee Service History";
        VacancyHeader: Record "Vacancy Header";

    procedure AssistEdit(OldCandidate: Record Candidate): Boolean
    begin
        Candidate := Rec;
        HumanResSetup.Get;
        HumanResSetup.TestField("Candidate Nos."); /* candidate nos not present in HRsetup table*/
        if NoSeriesMgt.SelectSeries(HumanResSetup."Candidate Nos.", OldCandidate."No. Series", Candidate."No. Series") then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Candidate Nos.");
            NoSeriesMgt.SetSeries(Candidate."No.");
            Rec := Candidate;
            exit(true);
        end;
    end;

    procedure FullName(): Text[100]
    begin
        if "Middle Name" = '' then
            exit("First Name" + ' ' + "Last Name");

        exit("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::Candidate, "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;

    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if MapPoint.FindFirst then
            MapMgt.MakeSelection(Database::Candidate, GetPosition)
        else
            Message(Text000);
    end;

    local procedure CreateDimension()
    begin
        //IME19.00 Begin
        /*
        GLSetup.GET;
        GLSetup.TESTFIELD("Employee Dimension");
        DimName := FullName;
        DimValue.SETRANGE("Dimension Code",GLSetup."Employee Dimension");
        DimValue.SETRANGE(Code,"No.");
        IF NOT DimValue.FINDFIRST THEN BEGIN
          DimValue.INIT;
          DimValue.VALIDATE("Dimension Code",GLSetup."Employee Dimension");
          DimValue.VALIDATE(Code,"No.");
          DimValue.VALIDATE(Name,DimName);
          DimValue.INSERT(TRUE);
          CLEAR(DefaultDimension);
          DefaultDimension.INIT;
          DefaultDimension.VALIDATE("Table ID",DATABASE::Employee);
          DefaultDimension.VALIDATE("No.","No.");
          DefaultDimension.VALIDATE("Dimension Code",GLSetup."Employee Dimension");
          DefaultDimension.VALIDATE("Dimension Value Code","No.");
          DefaultDimension.VALIDATE("Value Posting",DefaultDimension."Value Posting"::"Same Code");
          DefaultDimension.INSERT(TRUE);
        END ELSE BEGIN
          IF DimValue.Name <> DimName THEN BEGIN
            DimValue.VALIDATE(Name,DimName);
            DimValue.MODIFY;
          END;
        END;

        */
        //IME19.00 End
    end;

    procedure ConvertToEmployee()
    var
        Employee: Record Employee;
        NoEvaluationEntry: Label 'Interview evaluation entry not found. Do you want to continue?';
        EmployeeCreated: Label 'Employee - %1 has been created.';
        ConfirmConvert: Label 'Are you sure you want to convert to employee?';
        EmpQualification: Record "Employee Qualification";
        EmpRelative: Record "Employee Relative";
    begin
        TestField("Converted to Employee", false);
        TestField(Status, Status::"Appointment Letter Sent");
        if not Confirm(ConfirmConvert, false) then
            exit;
        Rec.TestField("Job Title");
        Rec.TestField("Functional Title");
        Rec.TestField("Marital Status");
        Rec.TestField(Gender);
        Rec.TestField("Salary Grade");
        Rec.TestField("Employment Type");
        //EvaluationEntry.RESET;
        //EvaluationEntry.SETRANGE( "No.", "No.");
        //EvaluationEntry.CALCSUMS("Interviewer Code", "Interviewer Name", Marks);
        //IF EvaluationEntry."Interviewer Code" + EvaluationEntry."Interviewer Name" + EvaluationEntry.Marks =0 THEN
        // if not Confirm(NoEvaluationEntry, false) then
        //     exit;

        "Converted to Employee" := true;
        //"Vacancy Code" := WORKDATE;
        Modify;

        Clear(Employee);
        Employee.Init;
        Employee.TransferFields(Rec);
        Employee."No." := '';
        Employee."Employment Type" := Rec."Employment Type";
        Employee."Employment Date" := Today;

        if Rec."Employment Type" = Rec."Employment Type"::Permanent then
            Employee."Confirmation Date" := Today;

        Employee.Validate("Salary Level", Rec."Job Title");
        Employee.Validate("Functional Title", Rec."Functional Title");
        Employee.Validate("Marital Status", Rec."Marital Status");
        Employee.Validate(Gender, Rec.Gender);
        Employee.Validate("Salary Grade", Rec."Salary Grade");
        Employee."Converted To Emp. Date" := Today;
        Employee.Insert(true);
        HRMgt.AddToServiceHistoryAppointment(Rec."No.", ServiceHistory."Service Event"::Appointment, 'Appointed', Employee."Employment Date", Rec."Vacancy Code", Employee."No.");

        EmpQualification.Reset;
        EmpQualification.SetRange("Employee No.", "No.");
        if EmpQualification.FindFirst then
            repeat
                EmployeeQualification.Reset;
                EmployeeQualification.Init;
                EmployeeQualification.TransferFields(EmpQualification);
                EmployeeQualification."Master Type" := EmployeeQualification."Master Type"::Employee;
                EmployeeQualification.Validate("Employee No.", Employee."No.");
                EmployeeQualification.Insert(true);
            until EmpQualification.Next = 0;

        EmpRelative.Reset;
        EmpRelative.SetRange("Employee No.", "No.");
        if EmpRelative.FindFirst then
            repeat
                Relative.Reset;
                Relative.Init;
                Relative.TransferFields(EmpRelative);
                Relative.Validate("Employee No.", Employee."No.");
                Relative."Master Type" := Relative."Master Type"::Employee;
                Relative.Insert();
            until EmpRelative.Next = 0;
        Message(EmployeeCreated, Employee."No.");
        Page.Run(Page::"Employee Card", Employee);
    end;

    local procedure ValidateCandidateName()
    begin
        if "Middle Name" = '' then
            Validate("Full Name", "First Name" + ' ' + "Last Name")
        else
            Validate("Full Name", "First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
    end;
}
