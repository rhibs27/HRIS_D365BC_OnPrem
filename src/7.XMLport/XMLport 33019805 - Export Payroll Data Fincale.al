xmlport 33019805 "Export Payroll Data Fincale"
{
    Direction = Export;
    FieldDelimiter = '<None>';
    Format = VariableText;
    FormatEvaluate = Xml;

    schema
    {
        textelement(Root)
        {
            tableelement("Name/Value Buffer"; "Name/Value Buffer")
            {
                XmlName = 'NameValueBuffer';
                fieldelement(Data; "Name/Value Buffer".Name) { }
            }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }
}
