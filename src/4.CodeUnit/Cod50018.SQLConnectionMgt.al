
codeunit 50018 "SQL Connection Mgt"
{
    trigger OnRun()
    begin
    end;

    var
        NoServerInfoError: Label 'Either server or database information not found.';
        SQLUserID: Text;
        SQLPassword: Text;
        CompInfo: Record "Company Information";

    procedure SetupSQLConnection(var SQLConnection: DotNet SqlConnection)
    begin
        SQLConnection := SQLConnection.SqlConnection(GetConnectionString());
        SQLConnection.Open;
    end;

    procedure CloseSQLConnection(var SQLConnection: DotNet SqlConnection)
    begin
        SQLConnection.Close;
        // SQLConnection.Dispose;
    end;

    procedure GetConnectionString() ConnStr: Text[250]
    var
        ServerName: Text;
        DatabaseName: Text;
    begin
        GetServerInformation(ServerName, DatabaseName);
        if (ServerName = '') or (DatabaseName = '') then
            exit(NoServerInfoError);

        if not IsServiceTier then begin
            ConnStr := 'Provider=SQLOLEDB;' +
                'Initial Catalog=' + UpperCase(DatabaseName) +
                ';Data Source=' + UpperCase(ServerName) +
                //';Integrated Security=true' +
                //';Column Encryption Setting=enabled;' +
                ';User ID=' + SQLUserID + ';Password=' + SQLPassword;
        end else begin
            // ConnStr := 'Provider=SQLOLEDB;' +
            //             'Initial Catalog=' + UpperCase(DatabaseName) +
            //             ';Data Source=' + UpperCase(ServerName) +
            //             ';User ID=' + SQLUserID +
            //             ';Password=' + SQLPassword +
            //             ';Persist Security Info=True;';
            ConnStr :=
                'Server=' + ServerName + ';' +
                'Database=' + DatabaseName + ';' +
                'Integrated Security=' + 'false' + ';' +
                'Trusted_Connection =' + 'True' + ';' +
                'encrypt=' + 'false' + ';' +
                'MultipleActiveResultSets=' + 'True' + ';' +
                'User ID=' + SQLUserID + ';' +
                'Persist Security Info =' + ' True' + ';' +
                'password=' + SQLPassword + ';';
        end;

        exit(ConnStr);
    end;

    procedure GetServerInformation(var ServerName: Text; var DatabaseName: Text)
    var
        HRSetup: Record "Human Resources Setup";
    begin
        Clear(ServerName);
        Clear(DatabaseName);
        Clear(SQLUserID);
        Clear(SQLPassword);
        HRSetup.get();
        ServerName := HRSetup."Portal Server";
        DatabaseName := HRSetup."Portal Database";
        SQLUserID := HRSetup."Portal SQL User";
        SQLPassword := HRSetup."Portal SQL Password";
    end;

    procedure SetupSQLCommand(SQLConnection: DotNet SqlConnection; SQLCommand: DotNet SqlCommand; commandtext: Text; SQLCommandType: Option StoredProcedure,TableDirect,Text)
    begin
        SQLCommand := SQLConnection.CreateCommand();
        // SQLCommand.CommandText := commandtext;
        // SQLCommand.CommandTimeout := 15;
        // SQLCommand.CommandType := SQLCommandType;
    end;
}
