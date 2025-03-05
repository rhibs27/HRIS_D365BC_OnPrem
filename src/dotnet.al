
dotnet
{
    // assembly("System.Data")
    // {
    //     type(System.Data.DataSet; SQLDataSet) { }

    // }

    assembly("Microsoft.Data.SqlClient")
    {
        type("Microsoft.Data.SqlClient.SqlConnection"; SQLConnection) { }
        type("Microsoft.Data.SqlClient.SqlCommand"; SQLCommand) { }
        type("Microsoft.Data.SqlClient.SqlParameter"; SQLParameter) { }
        type("Microsoft.Data.SqlClient.SqlDataReader"; SQLDataReader) { }
        type("Microsoft.Data.SqlClient.SqlInfoMessageEventArgs"; SqlInfoMessageEventArgs) { }
    }

    // assembly(mscorlib)
    // {
    //     type(System.Reflection.Assembly; AssemblyVar) { }
    //     type(System.Type; TypeVar) { }
    //     type(System.Object; ObjectVar) { }
    //     type(System.Array; ArrayVar) { }
    //     //type(System.Collections.Generic.Tlist){ }
    //     type(System.Collections.IList; ListVar) { }
    //     type(System.Collections.IList; LineVar) { }
    //     type(System.Reflection.PropertyInfo; PropertyInfoVar) { }
    //     type(System.Activator; ActivatorVar) { }
    //     type(System.Reflection.MethodInfo; MethodInfoVar) { }
    //     type(System.IO.Stream; IOStreamVar) { }
    //     type(System.IO.StringWriter; StringWriterVar) { }
    //     type(System.Globalization.CultureInfo; CultureInfoVar) { }
    //     type(System.String; StringVar) { }
    //     type(System.Reflection.ParameterInfo; ParameterInfoVar) { }
    //     type(System.Enum; EnumVar) { }
    // }
    // assembly(System)
    // {
    //     type(System.Net.WebRequest; WebrequestVar) { }
    //     type(System.CodeDom.CodeNamespace; CodeNameSpaceVar) { }
    //     type(System.CodeDom.CodeCompileUnit; CodeCompileUnitVar) { }
    //     type(System.CodeDom.Compiler.CodeGeneratorOptions; CodeGeneratorOptioVar) { }
    //     type(System.CodeDom.Compiler.CompilerParameters; CompilerParamvar) { }
    //     type(System.CodeDom.Compiler.CompilerResults; CompilerResultVar) { }
    //     type(Microsoft.CSharp.CSharpCodeProvider; CsharpProviderVar) { }
    //     type(System.Net.NetworkCredential; NetworkCredintialVar) { }
    //     // type(System.Data.SqlClient.SqlConnection; SqlConnectionVar) { }
    // }
}