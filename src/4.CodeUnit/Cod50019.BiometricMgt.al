codeunit 50019 "Biometric Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        AttendanceSetup: Record "Attendance Setup";

    local procedure GetJsonValue(jObj: JsonObject; jKeyName: Text; var jValue: JsonValue): Boolean
    var
        j_token: JsonToken;
    begin
        if not jObj.Get(jKeyName, j_token) then
            exit;
        jValue := j_token.AsValue();
        if jValue.IsNull then
            exit(false);
        if jValue.IsUndefined then
            exit(false);
        exit(true);
    end;

    //attendance Log
    procedure SyncAttendance(fromDate: Date; toDate: Date; DeviceId: Integer)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Request: HttpRequestMessage;
        Headers: HttpHeaders;
        Username, Password, AuthHeader, APIUrl, JsonText : Text;
        Content: HttpContent;
        JsonObj, AttendanceObject : JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
    begin
        AttendanceSetup.Get();

        if DeviceId = 0 then begin
            if fromDate = 0D then
                APIUrl := AttendanceSetup."Base URL" + 'AttendanceLogsOdata'
            else begin
                if toDate = 0D then
                    APIUrl := AttendanceSetup."Base URL" + 'AttendanceLogsOdata?$filter=InputDate gt ' + Format(fromDate, 0, '<Year4>-<Month,2>-<Day,2>')
                else
                    APIUrl := AttendanceSetup."Base URL" + 'AttendanceLogsOdata?$filter=InputDate gt ' + Format(fromDate, 0, '<Year4>-<Month,2>-<Day,2>') + ' and InputDate lt ' + Format(toDate, 0, '<Year4>-<Month,2>-<Day,2>');
            end;
        end
        else begin
            if fromDate = 0D then
                APIUrl := AttendanceSetup."Base URL" + 'AttendanceLogsOdata?$filter=DeviceId eq ' + Format(DeviceId)
            else begin
                if toDate = 0D then
                    APIUrl := AttendanceSetup."Base URL" + 'AttendanceLogsOdata?$filter=DeviceId eq ' + Format(DeviceId) + ' and InputDate gt ' + Format(fromDate, 0, '<Year4>-<Month,2>-<Day,2>')
                else
                    APIUrl := AttendanceSetup."Base URL" + 'AttendanceLogsOdata?$filter=DeviceId eq ' + Format(DeviceId) + ' and InputDate gt ' + Format(fromDate, 0, '<Year4>-<Month,2>-<Day,2>') + ' and InputDate lt ' + Format(toDate, 0, '<Year4>-<Month,2>-<Day,2>');
            end;
        end;

        Username := AttendanceSetup."User Name";
        Password := AttendanceSetup.Password;
        AuthHeader := 'Basic ' + EncodeBase64(Username + ':' + Password);

        Request.Method := 'GET';
        Request.SetRequestUri(APIUrl);
        Request.GetHeaders(Headers);
        Headers.Add('Authorization', AuthHeader);
        Headers.Add('Accept', 'application/json');

        if not Client.Send(Request, Response) then
            Error('Failed to send HTTP request.');

        if not Response.IsSuccessStatusCode() then
            Error('Request failed: %1 - %2', Response.HttpStatusCode(), Response.ReasonPhrase());

        Content := Response.Content();
        Content.ReadAs(JsonText);

        if not JsonToken.ReadFrom(JsonText) then
            Error('Invalid JSON document.');

        if not JsonToken.IsObject() then
            Error('Expected a JSON object.');

        JsonObj := JsonToken.AsObject();

        if JsonObj.Get('value', JsonToken) then begin

            if not JsonToken.IsArray() then
                Error('invalid json array');

            JsonArray := JsonToken.AsArray();

            foreach JsonToken in JsonArray do begin
                if JsonToken.IsObject() then begin
                    AttendanceObject := JsonToken.AsObject();
                    DownloadAttendanceData(AttendanceObject);
                end
            end;
        end;
    end;

    procedure DownloadAttendanceData(AttendanceObject: JsonObject)
    var
        json_value: JsonValue;
        AttendanceLog: Record "Attendance Log";
        deviceId: Integer;
        BiometricConfig: Record "Biometric Device Config.";
    begin
        deviceId := 0;
        AttendanceLog.Init();
        if GetJsonValue(AttendanceObject, 'EnrollNumber', json_value) then
            AttendanceLog.Validate("Machine Emp. Code", json_value.AsText());
        if GetJsonValue(AttendanceObject, 'InputDate', json_value) then
            AttendanceLog."Date Time Log" := json_value.AsDateTime();
        AttendanceLog.Date := DT2Date(AttendanceLog."Date Time Log");
        AttendanceLog."Log Time" := DT2Time(AttendanceLog."Date Time Log");
        AttendanceLog."Emp DateTime" := Format(AttendanceLog."Machine Emp. Code") + Format(Attendancelog.Date, 0, '<Year4>-<Month,2>-<Day,2>') + ' ' + Format(AttendanceLog."Log Time", 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>');

        if GetJsonValue(AttendanceObject, 'DeviceId', json_value) then begin
            deviceId := json_value.AsInteger();
            BiometricConfig.SetRange(Id, deviceId);
            if BiometricConfig.FindFirst() then
                AttendanceLog."Device IP" := BiometricConfig.IP;
        end;

        if AttendanceLog.Insert(true) then;
    end;

    procedure SyncDeviceConfig()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Request: HttpRequestMessage;
        Headers: HttpHeaders;
        Username, Password, AuthHeader, APIUrl, JsonText : Text;
        Content: HttpContent;
        DeviceObject : JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
    begin
        AttendanceSetup.Get();

        APIUrl := AttendanceSetup."Base URL" + 'GetDeviceConfig';
        Username := AttendanceSetup."User Name";
        Password := AttendanceSetup.Password;
        AuthHeader := 'Basic ' + EncodeBase64(Username + ':' + Password);

        Request.Method := 'GET';
        Request.SetRequestUri(APIUrl);
        Request.GetHeaders(Headers);
        Headers.Add('Authorization', AuthHeader);
        Headers.Add('Accept', 'application/json');

        if not Client.Send(Request, Response) then
            Error('Failed to send HTTP request.');

        if not Response.IsSuccessStatusCode() then
            Error('Request failed: %1 - %2', Response.HttpStatusCode(), Response.ReasonPhrase());

        Content := Response.Content();
        Content.ReadAs(JsonText);

        if not JsonArray.ReadFrom(JsonText) then
            Error('Failed to parse JSON array.');

        foreach JsonToken in JsonArray do begin
            if JsonToken.IsObject() then begin
                DeviceObject := JsonToken.AsObject();
                InsertDeviceConfig(DeviceObject);
            end
        end;
    end;

    procedure InsertDeviceConfig(DeviceObject: JsonObject)
    var
        DeviceConfigSetup, DeviceConfigSetup1 : Record "Biometric Device Config.";
        json_value: JsonValue;
    begin
        DeviceConfigSetup.Init();
        if GetJsonValue(DeviceObject, 'id', json_value) then
            DeviceConfigSetup.Id := json_value.AsInteger();
        if GetJsonValue(DeviceObject, 'name', json_value) then
            DeviceConfigSetup.Name := json_value.astext();
        if GetJsonValue(DeviceObject, 'ipaddress', json_value) then
            DeviceConfigSetup.IP := json_value.AsText();
        if GetJsonValue(DeviceObject, 'isActive', json_value) then
            DeviceConfigSetup."Is Active" := json_value.AsBoolean();
        if GetJsonValue(DeviceObject, 'lastSyncDate', json_value) then
            DeviceConfigSetup."Last Sync Date" := json_value.AsDateTime();
        if GetJsonValue(DeviceObject, 'serialNumber', json_value) then
            DeviceConfigSetup.SN := json_value.astext();

        if DeviceConfigSetup1.Get(DeviceConfigSetup.SN) then begin
            DeviceConfigSetup1.IP := DeviceConfigSetup.IP;
            DeviceConfigSetup1.Name := DeviceConfigSetup.Name;
            DeviceConfigSetup1."Last Sync Date" := DeviceConfigSetup."Last Sync Date";
            DeviceConfigSetup1."Is Active" := DeviceConfigSetup."Is Active";
            DeviceConfigSetup1.Modify();
        end
        else
            DeviceConfigSetup.Insert();
    end;

    procedure DeletelogFromDevice(sn: text[100])
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        Jtoken: JsonToken;

    begin
        AttendanceSetup.Get();
        AttendanceSetup.TestField("Base URL");
        AttendanceSetup.Get();

        Client.Get(StrSubstNo('%1ClearAttLogFromDevice?sn=%2', AttendanceSetup."Base URL", sn), ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        Message('Device Log cleared sucessfully!');
    end;

    procedure DeleteUserFromDevice(UserPin: Integer; BranchCode: code[20])
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        Jtoken: JsonToken;

    begin
        AttendanceSetup.Get();
        AttendanceSetup.TestField("Base URL");
        AttendanceSetup.Get();

        Client.Get(StrSubstNo('%1DeleteUserDev?userPin=%2&branchCode=%3', AttendanceSetup."Base URL", UserPin, BranchCode), ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        Message('user is deleted sucessfully from the device!');
    end;

    procedure DeleteUserFaceFromDevice(UserPin: Integer; BranchCode: code[20])
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        Jtoken: JsonToken;

    begin
        AttendanceSetup.Get();
        AttendanceSetup.TestField("Base URL");
        AttendanceSetup.Get();

        Client.Get(StrSubstNo('%1deleteUserFaceDev?userPin=%2&branchCode=%3', AttendanceSetup."Base URL", UserPin, BranchCode), ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        Message('user face is deleted sucessfully from the device!');
    end;

    procedure DeleteUserFingerprintFromDevice(UserPin: Integer; BranchCode: code[20])
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        Jtoken: JsonToken;

    begin
        AttendanceSetup.Get();
        AttendanceSetup.TestField("Base URL");
        AttendanceSetup.Get();

        Client.Get(StrSubstNo('%1DeleteUserFpDev?userPin=%2&branchCode=%3', AttendanceSetup."Base URL", UserPin, BranchCode), ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        Message('user finger print is deleted sucessfully from the device!');
    end;

    procedure DeleteUserPictureFromDevice(UserPin: Integer; BranchCode: code[20])
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        Jtoken: JsonToken;

    begin
        AttendanceSetup.Get();
        AttendanceSetup.TestField("Base URL");
        AttendanceSetup.Get();

        Client.Get(StrSubstNo('%1DeleteUserPicDev?userPin=%2&branchCode=%3', AttendanceSetup."Base URL", UserPin, BranchCode), ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');
    end;

    procedure SendEmployeeDatatoNewDevice(UserPin: Integer; deviceSN: code[20])
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        Jtoken: JsonToken;

    begin
        AttendanceSetup.Get();
        AttendanceSetup.TestField("Base URL");
        AttendanceSetup.Get();

        Client.Get(StrSubstNo('%1toNewDevice?userPin=%2&destSn=%3', AttendanceSetup."Base URL", UserPin, deviceSN), ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        Message('User %1 is sucessfully sent to the device!', UserPin);
    end;

    local procedure EncodeBase64(InputText: Text): Text
    var
        InStream: InStream;
        OutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        EncodedText: Text;
    begin
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(InputText);
        TempBlob.CreateInStream(InStream);
        EncodedText := Base64Convert.ToBase64(InStream);
        exit(EncodedText);
    end;

    procedure ExecuteStoredProcedure(StoredProcName: Text)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Request: HttpRequestMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        Username: Text;
        Password: Text;
        AuthHeader: Text;
        APIUrl: Text;
        JsonText: Text;
        ErrorText: Text;
        PayloadObj: JsonObject;
    begin
        AttendanceSetup.Get();

        if not AttendanceSetup."Base URL".StartsWith('http') then
            Error('Invalid API URL configured');

        APIUrl := AttendanceSetup."Base URL" + 'ExecuteSP';
        Username := AttendanceSetup."User Name";
        Password := AttendanceSetup.Password;
        AuthHeader := 'Basic ' + EncodeBase64_new(Username + ':' + Password);

        // Build JSON payload
        PayloadObj.Add('spName', StoredProcName);
        PayloadObj.WriteTo(JsonText);

        Content.WriteFrom(JsonText);
        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');

        Request.Method := 'POST';
        Request.SetRequestUri(APIUrl);
        Request.Content := Content;

        Request.GetHeaders(Headers);
        Headers.Add('Authorization', AuthHeader);
        Headers.Add('Accept', 'application/json');

        if not Client.Send(Request, Response) then
            Error('Failed to send HTTP request: %1', GetLastErrorText());

        if not Response.IsSuccessStatusCode() then begin
            Response.Content.ReadAs(ErrorText);
            Error('API request failed with status %1: %2\\URL: %3',
                  Response.HttpStatusCode(),
                  Response.ReasonPhrase(),
                  APIUrl);
        end;

        ProcessResponse(Response);
    end;

    local procedure EncodeBase64_new(InputText: Text): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
    begin
        exit(Base64Convert.ToBase64(InputText));
    end;

    local procedure ProcessResponse(Response: HttpResponseMessage)
    var
        ResponseText: Text;
    begin
        Response.Content.ReadAs(ResponseText);
        if ResponseText <> '' then begin
            Message('Stored procedure executed successfully: %1', ResponseText);
        end;
    end;
}
