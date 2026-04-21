Class St.Vectorsearch.Demo.Msg.FeelingResponse Extends (Ens.Response, %JSON.Adaptor)
{

/// List of feelings
Property Feelings As list Of St.Vectorsearch.Demo.Msg.Feeling;

Storage Default
{
<Data name="FeelingResponseDefaultData">
<Subscript>"FeelingResponse"</Subscript>
<Value name="1">
<Value>Feelings</Value>
</Value>
</Data>
<DefaultData>FeelingResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
