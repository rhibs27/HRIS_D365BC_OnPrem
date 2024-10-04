tableextension 50002 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(33019800; "Posted Payroll Plan No."; Code[20])
        {
            TableRelation = "Posted Payroll Header";
            DataClassification = CustomerContent;
        }
        field(33019801; "Posted Payroll Plan Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(33019802; "Payroll Attribute Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(33019803; "Employee Code"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(33019804; Narration; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(33019805; "Shortcut Dimension 3 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(33019806; "Shortcut Dimension 4 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(33019807; "Shortcut Dimension 5 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(33019808; "Shortcut Dimension 6 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
            DataClassification = CustomerContent;
            CaptionClass = '1,2,6';
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(33019809; "Shortcut Dimension 7 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(33019810; "Shortcut Dimension 8 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(33019811; "Budget Name"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(33019812; Budget; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019813; "Fiscal Year"; Code[10])
        {
            DataClassification = CustomerContent;
        }
    }
}
