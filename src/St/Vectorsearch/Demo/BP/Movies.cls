/// 
Class St.Vectorsearch.Demo.BP.Movies Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='St.Vectorsearch.Demo.Msg.Movies.MoviesRequestBase' response='St.Vectorsearch.Demo.Msg.Movies.MoviesResponseBase' height='2000' width='2000' >
<sequence xend='200' yend='450' >
<call name='find movies' target='St.Vectorsearch.Demo.BO.Movies' async='1' xpos='200' ypos='250' >
<request type='St.Vectorsearch.Demo.Msg.Movies.MoviesRequestBase' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='St.Vectorsearch.Demo.Msg.Movies.MoviesResponseBase' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
<sync name='wait' calls='find movies' type='all' xpos='200' ypos='350' />
</sequence>
</process>
}

}
