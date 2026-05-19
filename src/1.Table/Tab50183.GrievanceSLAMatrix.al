table 50183 "Grievance SLA Matrix"
{
    Caption = 'Grievance SLA Matrix';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Priority; Enum "Grievance Priority")
        {
            Caption = 'Priority';
            NotBlank = true;
        }
        field(2; Severity; Enum "Grievance Severity")
        {
            Caption = 'Severity';
            NotBlank = true;
        }
        field(3; "Response Time (Hours)"; Decimal)
        {
            Caption = 'Response Time (Hours)';
            MinValue = 0;
            DecimalPlaces = 0 : 2;
            ToolTip = 'Specifies the maximum hours within which the grievance must be acknowledged.';
        }
        field(4; "Resolution Time (Hours)"; Decimal)
        {
            Caption = 'Resolution Time (Hours)';
            MinValue = 0;
            DecimalPlaces = 0 : 2;
            ToolTip = 'Specifies the maximum hours within which the grievance must be resolved.';
        }
        field(5; "Escalation Time (Hours)"; Decimal)
        {
            Caption = 'Escalation Time (Hours)';
            MinValue = 0;
            DecimalPlaces = 0 : 2;
            ToolTip = 'Specifies the hours after which an unresolved grievance is escalated.';
        }
        field(6; Description; Text[250])
        {
            Caption = 'Description';
            ToolTip = 'Specifies additional details about this SLA configuration.';
        }
    }

    keys
    {
        key(PK; Priority, Severity)
        {
            Clustered = true;
        }
    }
}
