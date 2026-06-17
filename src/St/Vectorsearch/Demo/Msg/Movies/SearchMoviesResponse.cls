Class St.Vectorsearch.Demo.Msg.Movies.SearchMoviesResponse Extends St.Vectorsearch.Demo.Msg.Movies.MoviesResponseBase
{
property InfoMovies As list of St.Vectorsearch.Demo.Msg.Movies.Movies;
Storage Default
{
<Data name="SearchMoviesResponseDefaultData">
<Subscript>"SearchMoviesResponse"</Subscript>
<Value name="1">
<Value>InfoMovies</Value>
</Value>
</Data>
<DefaultData>SearchMoviesResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
