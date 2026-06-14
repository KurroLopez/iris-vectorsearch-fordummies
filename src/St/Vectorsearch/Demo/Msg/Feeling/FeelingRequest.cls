Class St.Vectorsearch.Demo.Msg.Feeling.FeelingRequest Extends (Ens.Request, %JSON.Adaptor)
{
    Property Message AS %String(MAXLEN="");
Storage Default
{
<Data name="FeelingRequestDefaultData">
<Subscript>"FeelingRequest"</Subscript>
<Value name="1">
<Value>Message</Value>
</Value>
</Data>
<DefaultData>FeelingRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
