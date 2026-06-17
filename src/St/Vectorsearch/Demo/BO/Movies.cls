Class St.Vectorsearch.Demo.BO.Movies Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method AllMovies(pRequest As St.Vectorsearch.Demo.Msg.Movies.AllMoviesRequest, Output pResponse As St.Vectorsearch.Demo.Msg.Movies.AllMoviesResponse) As %Status
{
    set tSC = $$$OK
    set pResponse = ##class(St.Vectorsearch.Demo.Msg.Movies.AllMoviesResponse).%New()
    set tStatement = ##class(%SQL.Statement).%New()
    set sql($INCREMENT(i)) = " SELECT ID, Title, Year "
    set sql($INCREMENT(i)) = " FROM St_Vectorsearch.Movie "
    set sql($INCREMENT(i)) = " ORDER BY Title ASC "
    set sql = i
    set tSC = tStatement.%Prepare(.sql)
    If $$$ISERR(tSC) { Return tSC }
    set tResultSet = tStatement.%Execute()
    set tSC = tResultSet.%SQLCODE
    If tSC<0 { Return $$$ERROR($$$GeneralError, "Error executing query") }
    kill sql, i
    while tResultSet.%Next() {
        set node = ##class(St.Vectorsearch.Demo.Msg.Movies.Movies).%New()
        set node.Id = tResultSet.%Get("ID")
        set node.Title = tResultSet.%Get("Title")
        set node.Year = tResultSet.%Get("Year")
        do pResponse.Movies.Insert(node)
    }

    Return $$$OK
}

Method SearchMovies(pRequest As St.Vectorsearch.Demo.Msg.Movies.SearchMoviesRequest, Output pResponse As St.Vectorsearch.Demo.Msg.Movies.SearchMoviesResponse) As %Status
{
    set tSC = $$$OK
    set title = ""
    set vector = ""

    ; search the movie
    set sql($INCREMENT(i)) = " SELECT Title, Vector "
    set sql($INCREMENT(i)) = " FROM St_Vectorsearch.Movie "
    set sql($INCREMENT(i)) = " WHERE ID = ? "
    set sql = i
    set tStatement = ##class(%SQL.Statement).%New()
    set tSC = tStatement.%Prepare(.sql)
    If $$$ISERR(tSC) { Return tSC }
    set tResultSet = tStatement.%Execute(pRequest.Id)
    set tSC = tResultSet.%SQLCODE
    If tSC<0 { Return $$$ERROR($$$GeneralError, "Error executing vector search query") }
    If tResultSet.%Next() {
        set title = tResultSet.%Get("Title")
        set vector = tResultSet.%Get("Vector")
    } Else {
        Return $$$ERROR($$$GeneralError, "Movie not found")
    }
    kill sql, i

    set pResponse = ##class(St.Vectorsearch.Demo.Msg.Movies.SearchMoviesResponse).%New()
    set tStatement = ##class(%SQL.Statement).%New()
    set sql($INCREMENT(i)) = " SELECT TOP 5 ID, Link, Title, Year, ROUND(VECTOR_COSINE(Vector, TO_VECTOR(?, float)) * 100, 4) AS Percentage "
    set sql($INCREMENT(i)) = " FROM St_Vectorsearch.Movie "
    set sql($INCREMENT(i)) = " WHERE Title <> ? "
    set sql($INCREMENT(i)) = " ORDER BY VECTOR_COSINE(Vector, TO_VECTOR(?, float)) DESC"
    set sql = i
    set tSC = tStatement.%Prepare(.sql)
    If $$$ISERR(tSC) { Return tSC }
    set tResultSet = tStatement.%Execute(vector, title, vector)
    set tSC = tResultSet.%SQLCODE
    If tSC<0 { Return $$$ERROR($$$GeneralError, "Error executing vector search query") }
    kill sql, i

    while tResultSet.%Next() {
        set node = ##class(St.Vectorsearch.Demo.Msg.Movies.Movies).%New()
        set node.Id = tResultSet.%Get("ID")
        set node.Title = tResultSet.%Get("Title")
        set node.Year = tResultSet.%Get("Year")
        set node.Percentage = tResultSet.%Get("Percentage")
        do pResponse.InfoMovies.Insert(node)
    }
    Return $$$OK
}

Method InfoMovie(pRequest As St.Vectorsearch.Demo.Msg.Movies.InfoMovieRequest, Output pResponse As St.Vectorsearch.Demo.Msg.Movies.InfoMovieResponse) As %Status
{
    set tSC = $$$OK
    set pResponse = ##class(St.Vectorsearch.Demo.Msg.Movies.InfoMovieResponse).%New()
    set tStatement = ##class(%SQL.Statement).%New()
    set sql($INCREMENT(i)) = " SELECT ID, Link, Title, Year, Certificate, "
    set sql($INCREMENT(i)) = " Runtime, Genre, Rating, Overview, Director, "
    set sql($INCREMENT(i)) = " Star1, Star2, Star3, Star4 "
    set sql($INCREMENT(i)) = " FROM St_Vectorsearch.Movie "
    set sql($INCREMENT(i)) = " WHERE ID = ? "
    set sql = i
    set tSC = tStatement.%Prepare(.sql)
    If $$$ISERR(tSC) { Return tSC }
    set tResultSet = tStatement.%Execute(pRequest.Id)
    set tSC = tResultSet.%SQLCODE
    If tSC<0 { Return $$$ERROR($$$GeneralError, "Error executing query") }
    kill sql, i
    If tResultSet.%Next() {
        set node = ##class(St.Vectorsearch.Demo.Msg.Movies.Movies).%New()
        set node.Id = tResultSet.%Get("ID")
        set node.Link = tResultSet.%Get("Link")
        set node.Title = tResultSet.%Get("Title")
        set node.Year = tResultSet.%Get("Year")
        set node.Certificate = tResultSet.%Get("Certificate")
        set node.Runtime = tResultSet.%Get("Runtime")
        set node.Genre = tResultSet.%Get("Genre")
        set node.Rating = tResultSet.%Get("Rating")
        set node.Overview = tResultSet.%Get("Overview")
        set node.Director = tResultSet.%Get("Director")
        set node.Star1 = tResultSet.%Get("Star1")
        set node.Star2 = tResultSet.%Get("Star2")
        set node.Star3 = tResultSet.%Get("Star3")
        set node.Star4 = tResultSet.%Get("Star4")
        set pResponse.InfoMovie = node
    } Else {
        Return $$$ERROR($$$GeneralError, "Movie not found")
    }

    Return $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="St.Vectorsearch.Demo.Msg.Movies.AllMoviesRequest">
		<Method>AllMovies</Method>
	</MapItem>
	<MapItem MessageType="St.Vectorsearch.Demo.Msg.Movies.InfoMovieRequest">
		<Method>InfoMovie</Method>
	</MapItem>
    <MapItem MessageType="St.Vectorsearch.Demo.Msg.Movies.SearchMoviesRequest">
        <Method>SearchMovies</Method>
    </MapItem>
</MapItems>
}

}
