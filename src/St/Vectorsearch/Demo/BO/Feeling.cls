Class St.Vectorsearch.Demo.BO.Feeling Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method SearchFeeling(pRequest As St.Vectorsearch.Demo.Msg.Feeling.FeelingRequest, Output pResponse As St.Vectorsearch.Demo.Msg.Feeling.FeelingResponse) As %Status
{
    set tSC = $$$OK
    set pResponse = ##class(St.Vectorsearch.Demo.Msg.Feeling.FeelingResponse).%New()
    set vector = pRequest.Message
    set tStatement = ##class(%SQL.Statement).%New()
    set sql($INCREMENT(i)) = " SELECT TOP 5 Text, Value, ROUND(VECTOR_DOT_PRODUCT(Vector, TO_VECTOR(?, float)) * 100, 4) AS Percentage, D.Description "
    set sql($INCREMENT(i)) = " FROM St_Vectorsearch.Feeling "
    set sql($INCREMENT(i)) = " LEFT JOIN St_Vectorsearch.DescFeeling AS D ON Feeling.Value = D.Id "
    set sql($INCREMENT(i)) = " ORDER BY VECTOR_DOT_PRODUCT(Vector, TO_VECTOR(?, float)) DESC"
    set sql = i
    set tSC = tStatement.%Prepare(.sql)
    If $$$ISERR(tSC) { Return tSC }
    set tResultSet = tStatement.%Execute(vector, vector)
    set tSC = tResultSet.%SQLCODE
    If tSC<0 { Return $$$ERROR($$$GeneralError, "Error executing vector search query") }

    while tResultSet.%Next() {
        set node = ##class(St.Vectorsearch.Demo.Msg.Feeling.Feeling).%New()
        set node.Text = tResultSet.%Get("Text")
        set node.Value = tResultSet.%Get("Value")
        set node.Percentage = tResultSet.%Get("Percentage")
        set node.Description = tResultSet.%Get("Description")
        do pResponse.Feelings.Insert(node)
    }
    Return $$$OK
}

Method GetEmbedding(pRequest As Ens.StringRequest, Output pResponse As Ens.StringRequest) As %Status
{
    Set tSC = $$$OK
    Try {
        Set pResponse = ##class(Ens.StringRequest).%New()
        
        // Aquí se realiza la llamada pesada
        Set vector = ##class(St.Vectorsearch.Vector).Embedding(pRequest.StringValue)
        
        Set pResponse.StringValue = vector
    }
    Catch ex {
        Set tSC = ex.AsStatus()
    }
    Quit tSC
}

Method OnInit() As %Status
{
    // Forzamos al proceso actual a cargar el modelo en memoria antes de recibir peticiones
    Job ##class(St.Vectorsearch.Vector).Embedding("Warm up query")
    Quit $$$OK
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="Ens.StringRequest">
        <Method>GetEmbedding</Method>
    </MapItem>
	<MapItem MessageType="St.Vectorsearch.Demo.Msg.Feeling.FeelingRequest">
		<Method>SearchFeeling</Method>
	</MapItem>
</MapItems>
}

}
