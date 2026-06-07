Class St.Vectorsearch.Demo.BS.Rest Extends (%CSP.REST, Ens.BusinessService)
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="(?i)/feeling" Method="POST" Call="FeelingPost"/>
</Routes>
}

Property BPClass As %String(MAXLEN = "");

Parameter CLASSBS = "St.Vectorsearch.Demo.BS.Rest";

Parameter SETTINGS = "BPClass:Basic:selector?Select=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

ClassMethod FeelingPost() As %Status
{
    set tSC = $$$OK
    do ##class(Ens.Director).CreateBusinessService(..#CLASSBS, .service)

    Try {
        set %response.CharSet = "utf-8"
        set %response.ContentType="application/json"
        set dynamic = ##class(%Library.DynamicObject).%FromJSON(%request.Content)
        set pRequest = ##class(Ens.StringRequest).%New(dynamic.text)

        set tSC = service.SendRequestSync(service.BPClass, pRequest, .pResponse)
        If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
        set %response.Status= ..#HTTP200OK
        set %response.CharSet = "utf-8"
        set %response.ContentType = "application/json"
        do pResponse.%JSONExportToStream(.tStream)
        do tStream.OutputToDevice()
    }
    Catch ex {
        Set tSC=ex.AsStatus()
		set errorCode = $system.Status.GetErrorCodes(tSC)
        Set msgError = $System.Status.GetOneStatusText(tSC,1)
        set pError = ##class(%Library.DynamicObject).%New()
        set %response.Status= ..#HTTP200OK
        set %response.CharSet = "utf-8"
        set %response.ContentType = "application/json"
        set pError.code = errorCode
        Set pError.message = msgError
        write pError.%ToJSON()
    }

    quit $$$OK
}

}
