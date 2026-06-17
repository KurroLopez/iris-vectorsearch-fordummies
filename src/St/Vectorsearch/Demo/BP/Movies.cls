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
<sequence xend='200' yend='800' >
<switch name='type_request' xpos='200' ypos='250' xend='200' yend='700' >
<case condition='$classname(request)="St.Vectorsearch.Demo.Msg.Movies.AllMoviesRequest"' name='St.Vectorsearch.Demo.Msg.Movies.AllMoviesRequest' >
<trace name='get all movies' value='"Get all movies names"' xpos='335' ypos='400' />
<call name='get movies list' target='St.Vectorsearch.Demo.BO.Movies' async='1' xpos='335' ypos='500' >
<request type='St.Vectorsearch.Demo.Msg.Movies.AllMoviesRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='St.Vectorsearch.Demo.Msg.Movies.AllMoviesResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
<sync name='wait' calls='get movies list' type='all' xpos='335' ypos='600' />
</case>
<case condition='$classname(request)="St.Vectorsearch.Demo.Msg.Movies.InfoMovieRequest"' name='St.Vectorsearch.Demo.Msg.Movies.InfoMovieRequest' >
<trace name='get info movie' value='"Get info movie "_request.Id' xpos='605' ypos='400' />
<call name='get movie' target='St.Vectorsearch.Demo.BO.Movies' async='1' xpos='605' ypos='500' >
<request type='St.Vectorsearch.Demo.Msg.Movies.InfoMovieRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='St.Vectorsearch.Demo.Msg.Movies.InfoMovieResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
<sync name='wait' calls='get movie' type='all' xpos='605' ypos='600' />
</case>
<default name='default' />
</switch>
</sequence>
</process>
}

}
