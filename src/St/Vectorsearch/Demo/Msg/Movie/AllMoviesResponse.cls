Class St.Vectorsearch.Demo.Msg.Movie.AllMoviesResponse Extends (Ens.Response, %JSON.Adaptor)
{
    /// List of movies
    Property Movies As List of St.Vectorsearch.Demo.Msg.Movie.Movie;
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
