table 50172 "Appraisal Weightage Setup"
{
    Caption = 'Appraisal Weightage Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Fiscal Year"; Code[20])
        {
            Caption = 'Fiscal Year';
            TableRelation = "Pay Cycle Term".Term;
            DataClassification = CustomerContent;
        }
        field(3; "KRA Master"; Code[20])
        {
            Caption = 'KRA Master';
            TableRelation = "Appraisal KRA Master".Code where(Type = filter("KRA Master"));
            DataClassification = CustomerContent;
        }
        field(4; "Appraisal Type"; Enum "Appraisal Type")
        {
            Caption = 'Appraisal Type';
            DataClassification = CustomerContent;
        }
        field(5; "Self Score"; Decimal)
        {
            Caption = 'Self Score %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                ValidateTotalWeightage();
            end;
        }
        field(6; "Immediate Supervisor"; Decimal)
        {
            Caption = 'Immediate Supervisor %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                ValidateTotalWeightage();
            end;
        }
        field(7; "Reviewer"; Decimal)
        {
            Caption = 'Reviewer %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                ValidateTotalWeightage();
            end;
        }
        field(8; "Group Performance"; Decimal)
        {
            Caption = 'Group Performance %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                ValidateTotalWeightage();
            end;
        }
        field(9; "HR Committee"; Decimal)
        {
            Caption = 'HR Committee %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                ValidateTotalWeightage();
            end;
        }
        field(10; "Total Weightage"; Decimal)
        {
            Caption = 'Total Weightage %';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        ValidateTotalWeightage();
    end;

    trigger OnModify()
    begin
        ValidateTotalWeightage();
    end;

    local procedure ValidateTotalWeightage()
    var
        TotalPercentage: Decimal;
    begin
        TotalPercentage := "Self Score" + "Immediate Supervisor" + "Reviewer" +
                          "Group Performance" + "HR Committee";
        "Total Weightage" := TotalPercentage;
    end;
}