Class St.Vectorsearch.Demo.Msg.Movies.AllMoviesResponse Extends St.Vectorsearch.Demo.Msg.Movies.MoviesResponseBase
{
    /// List of movies
    Property Movies As List of St.Vectorsearch.Demo.Msg.Movies.Movies;

Storage Default
{
<Data name="AllMoviesResponseDefaultData">
<Subscript>"AllMoviesResponse"</Subscript>
<Value name="1">
<Value>Movies</Value>
</Value>
</Data>
<DefaultData>AllMoviesResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
