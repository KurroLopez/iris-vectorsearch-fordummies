Class St.Vectorsearch.Demo.Msg.Movies.InfoMovieRequest Extends St.Vectorsearch.Demo.Msg.Movies.MoviesRequestBase
{

    /// Id of the movie
    Property Id As %Integer;

Storage Default
{
<Data name="InfoMovieRequestDefaultData">
<Subscript>"InfoMovieRequest"</Subscript>
<Value name="1">
<Value>Id</Value>
</Value>
</Data>
<DefaultData>InfoMovieRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
