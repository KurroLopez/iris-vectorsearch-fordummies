Class St.Vectorsearch.Demo.Deploy Extends (St.Tools.Deploy, %Projection.AbstractProjection) [ DependsOn = St.Vectorsearch.Demo.Production ]
{

Parameter PRODUCTION = "St.Vectorsearch.Demo.Production";

Parameter NAMESPACE = "USER";

Projection Reference As St.Vectorsearch.Demo.Deploy;

/// This method is called by the Class Compiler whenever an associated 
/// class has finished compiling. <var>classname</var> contains the name of 
/// the associated class while <var>parameters</var> contains an array of the 
/// projection parameters subscripted by parameter name. Also the special parameter value
/// parameters("%qstruct") contains a merge of the qstruct array this projection is being
/// compiled with. The <var>modified</var> is always blank.<br>
/// Any errors reported by this method are reported by the Class Compiler but
/// do not effect class compilation in any way.
ClassMethod CreateProjection(classname As %String, ByRef parameters As %String, modified As %String, qstruct) As %Status
{
   
    do ..AddItem(, "St.Vectorsearch.Demo.BS.Rest", "St.Vectorsearch.Demo.BS.Rest")
    do ..AddItem(, "St.Vectorsearch.Demo.BP.Feeling", "St.Vectorsearch.Demo.BP.Feeling")
    do ..AddItem(, "St.Vectorsearch.Demo.BP.Movies", "St.Vectorsearch.Demo.BP.Movies")
    do ..AddItem(, "St.Vectorsearch.Demo.BO.Feeling", "St.Vectorsearch.Demo.BO.Feeling")
    do ..AddItem(, "St.Vectorsearch.Demo.BO.Movies", "St.Vectorsearch.Demo.BO.Movies")

    // Add default parameters
    do ..AddDefaultSetting(,,"St.Vectorsearch.Demo.BS.Rest","BPClass","St.Vectorsearch.Demo.BP.Feeling")
    do ..AddDefaultSetting(,,"St.Vectorsearch.Demo.BS.Rest","BPClassMovies","St.Vectorsearch.Demo.BP.Movies")

    // Add API Services
    do ..RegisterWebApplication(..#NAMESPACE, "/vector/api","St.Vectorsearch.Demo.BS.Rest")

    /// Check if the production is running
    if '##class(Ens.Director).IsProductionRunning(..#PRODUCTION)
    {
        write !,"Running production"
        do ##class(Ens.Director).StartProduction(..#PRODUCTION)
        do ##class(Ens.Director).SetAutoStart(..#PRODUCTION, 0)
    }
    else
    {
        write !,"Restart production"
        do ##class(Ens.Director).RestartProduction(0,1)
    }

    Quit $$$OK

}

}
