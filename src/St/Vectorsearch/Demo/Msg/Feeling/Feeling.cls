Class St.Vectorsearch.Demo.Msg.Feeling.Feeling Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

/// Text
Property Text As %String(MAXLEN = "");

/// Id of the feeling
Property Value As %Integer;

Property Percentage As %Decimal(SCALE = 2);

Property Description As %String(MAXLEN = 1024);

/// Percentage
Storage Default
{
<Data name="FeelingState">
<Value name="1">
<Value>Text</Value>
</Value>
<Value name="2">
<Value>Value</Value>
</Value>
<Value name="3">
<Value>Percentage</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
</Data>
<Description>
<![CDATA[Percentage]]></Description>
<State>FeelingState</State>
<StreamLocation>^St.Vectorsearch.Dem39A.FeelingS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
