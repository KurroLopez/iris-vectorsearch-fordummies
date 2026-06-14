/// 
Class St.Vectorsearch.Demo.BP.Feeling Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.StringRequest' response='St.Vectorsearch.Demo.Msg.Feeling.FeelingResponse' height='2000' width='2000' >
<context>
<property name='Vector' type='St.Vectorsearch.Demo.Msg.Feeling.FeelingRequest' instantiate='0' deletewithcontext='0' />
</context>
<sequence xend='200' yend='650' >
<call name='Calculate Embedding' target='St.Vectorsearch.Demo.BO.Feeling' async='1' xpos='200' ypos='250' >
<request type='Ens.StringRequest' >
<assign property="callrequest.StringValue" value="request.StringValue" action="set" />
</request>
<response type='Ens.StringRequest' >
<assign property="context.Vector.Message" value="callresponse.StringValue" action="set" />
</response>
</call>
<sync name='Wait calculate' calls='Calculate Embedding' type='all' xpos='200' ypos='350' />
<call name='call search feeling' target='St.Vectorsearch.Demo.BO.Feeling' async='1' xpos='200' ypos='450' >
<request type='St.Vectorsearch.Demo.Msg.Feeling.FeelingRequest' >
<assign property="callrequest" value="context.Vector" action="set" />
</request>
<response type='St.Vectorsearch.Demo.Msg.Feeling.FeelingResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
<sync name='wait get feelings' calls='call search feeling' type='all' xpos='200' ypos='550' />
</sequence>
</process>
}

}
