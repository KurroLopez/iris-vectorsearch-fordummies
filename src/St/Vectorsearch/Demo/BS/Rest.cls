Class St.Vectorsearch.Demo.BS.Rest Extends (%CSP.REST, Ens.BusinessService)
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="(?i)/feeling" Method="POST" Call="FeelingPost"/>
    <Route Url="(?i)/movies" Method="GET" Call="MovieGet"/>
    <Route Url="(?i)/movies/:id" Method="GET" Call="InfoMovieGet"/>
</Routes>
}

Property BPClass As %String(MAXLEN = "");
Property BPClassMovies As %String(MAXLEN = "");

Parameter CLASSBS = "St.Vectorsearch.Demo.BS.Rest";

Parameter SETTINGS = "BPClass:Basic:selector?Select=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}, BPClassMovies:Basic:selector?Select=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

ClassMethod FeelingPost() As %Status
{
    set tSC = $$$OK
    do ##class(Ens.Director).CreateBusinessService(..#CLASSBS, .service)

    Try {
        set %response.CharSet = "utf-8"
        set %response.ContentType="application/json"
        set dynamic = ##class(%Library.DynamicObject).%FromJSON(%request.Content)
        set pRequest = ##class(Ens.StringRequest).%New($zconvert(dynamic.text,"L"))

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

ClassMethod MovieGet() As %Status
{
    set tSC = $$$OK
    do ##class(Ens.Director).CreateBusinessService(..#CLASSBS, .service)

    Try {
        set %response.CharSet = "utf-8"
        set %response.ContentType="application/json"
        set pRequest = ##class(St.Vectorsearch.Demo.Msg.Movies.AllMoviesRequest).%New()

        set tSC = service.SendRequestSync(service.BPClassMovies, pRequest, .pResponse)
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

ClassMethod InfoMovieGet(id as %Integer) As %Status
{
    set tSC = $$$OK
    do ##class(Ens.Director).CreateBusinessService(..#CLASSBS, .service)

    Try {
        set %response.CharSet = "utf-8"
        set %response.ContentType="application/json"
        set pRequest = ##class(St.Vectorsearch.Demo.Msg.Movies.InfoMovieRequest).%New()
        set pRequest.Id = id

        set tSC = service.SendRequestSync(service.BPClassMovies, pRequest, .pResponse)
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