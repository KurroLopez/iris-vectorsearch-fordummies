Class St.Vectorsearch.Demo.BO.Movies Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method AllMovies(pRequest As St.Vectorsearch.Demo.Msg.Movie.AllMoviesRequest, Output pResponse As St.Vectorsearch.Demo.Msg.Movie.AllMoviesResponse) As %Status
{
    set tSC = $$$OK
    set pResponse = ##class(St.Vectorsearch.Demo.Msg.Movie.AllMoviesResponse).%New()
    set tStatement = ##class(%SQL.Statement).%New()
    set sql($INCREMENT(i)) = " SELECT ID, Title, Year "
    set sql($INCREMENT(i)) = " FROM St_Vectorsearch.Movie "
    set sql = i
    set tSC = tStatement.%Prepare(.sql)
    If $$$ISERR(tSC) { Return tSC }
    set tResultSet = tStatement.%Execute()
    set tSC = tResultSet.%SQLCODE
    If tSC<0 { Return $$$ERROR($$$GeneralError, "Error executing query") }
    while tResultSet.%Next() {
        set node = ##class(St.Vectorsearch.Demo.Msg.Movie.Movie).%New()
        set node.Id = tResultSet.%Get("ID")
        set node.Title = tResultSet.%Get("Title")
        set node.Year = tResultSet.%Get("Year")
        do pResponse.Movies.Insert(node)
    }

    Return $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="St.Vectorsearch.Demo.Msg.Movie.AllMoviesRequest">
		<Method>AllMovies</Method>
	</MapItem>
</MapItems>
}

}
