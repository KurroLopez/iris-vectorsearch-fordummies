Class St.Vectorsearch.Demo.Msg.Movies.Movies Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

    /// Id of the movie
    Property Id As %Integer;

    /// Link to the image of the movie
    Property Link As %String(MAXLEN = 255);

    /// Title of the movie
    Property Title As %String(MAXLEN = 255);

    /// Year of release
    Property Year As %Integer;

    /// Certificate of the movie
    Property Certificate As %String(MAXLEN = 50);

    /// Runtime of the movie
    Property Runtime As %Integer;

    /// Genre of the movie
    Property Genre As %String(MAXLEN = 255);

    /// Rating IMDB of the movie
    Property Rating As %Decimal(SCALE = 2);

    /// Overview of the movie
    Property Overview As %String(MAXLEN = 1024);

    /// Director of the movie
    Property Director As %String(MAXLEN = 255);

    /// First star of the movie
    Property Star1 As %String(MAXLEN = 255);

    /// Second star of the movie
    Property Star2 As %String(MAXLEN = 255);

    /// Third star of the movie
    Property Star3 As %String(MAXLEN = 255);

    /// Fourth star of the movie
    Property Star4 As %String(MAXLEN = 255);

    /// Percentage of similarity with the search vector
    Property Percentage As %Decimal(SCALE = 4);

Storage Default
{
<Data name="MoviesState">
<Value name="1">
<Value>Id</Value>
</Value>
<Value name="2">
<Value>Link</Value>
</Value>
<Value name="3">
<Value>Title</Value>
</Value>
<Value name="4">
<Value>Year</Value>
</Value>
<Value name="5">
<Value>Certificate</Value>
</Value>
<Value name="6">
<Value>Runtime</Value>
</Value>
<Value name="7">
<Value>Genre</Value>
</Value>
<Value name="8">
<Value>Rating</Value>
</Value>
<Value name="9">
<Value>Overview</Value>
</Value>
<Value name="10">
<Value>Director</Value>
</Value>
<Value name="11">
<Value>Star1</Value>
</Value>
<Value name="12">
<Value>Star2</Value>
</Value>
<Value name="13">
<Value>Star3</Value>
</Value>
<Value name="14">
<Value>Star4</Value>
</Value>
<Value name="15">
<Value>Percentage</Value>
</Value>
</Data>
<State>MoviesState</State>
<StreamLocation>^St.Vectorsearch.DemoD8F.MoviesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
