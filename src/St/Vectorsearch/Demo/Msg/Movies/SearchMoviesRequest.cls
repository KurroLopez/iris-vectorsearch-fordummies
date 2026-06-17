Class St.Vectorsearch.Demo.Msg.Movies.SearchMoviesRequest Extends St.Vectorsearch.Demo.Msg.Movies.MoviesRequestBase
{
    
    /// Id of the movie
    Property Id As %Integer;

Storage Default
{
<Data name="SearchMoviesRequestDefaultData">
<Subscript>"SearchMoviesRequest"</Subscript>
<Value name="1">
<Value>Id</Value>
</Value>
</Data>
<DefaultData>SearchMoviesRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
