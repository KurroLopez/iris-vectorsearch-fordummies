Class St.Vectorsearch.Demo.Deploy Extends St.Tools.Deploy
{

ClassMethod Deploy()
{
    set production = "St.Vectorsearch.Demo.Production"
    set currentNamespace = $Namespace
    
    do ..AddItem(production, "St.Vectorsearch.Demo.BS.Rest", "St.Vectorsearch.Demo.BS.Rest")
    do ..AddItem(production, "St.Vectorsearch.Demo.BP.Feeling", "St.Vectorsearch.Demo.BP.Feeling")
    do ..AddItem(production, "St.Vectorsearch.Demo.BP.Movies", "St.Vectorsearch.Demo.BP.Movies")
    do ..AddItem(production, "St.Vectorsearch.Demo.BO.Feeling", "St.Vectorsearch.Demo.BO.Feeling")
    do ..AddItem(production, "St.Vectorsearch.Demo.BO.Movies", "St.Vectorsearch.Demo.BO.Movies")

    // Add default parameters
    do ..AddDefaultSetting(production,,"St.Vectorsearch.Demo.BS.Rest","BPClass","St.Vectorsearch.Demo.BP.Feeling")
    do ..AddDefaultSetting(production,,"St.Vectorsearch.Demo.BS.Rest","BPClassMovies","St.Vectorsearch.Demo.BP.Movies")

    // Add API Services
    do ..RegisterWebApplication(currentNamespace, "/vector/api","St.Vectorsearch.Demo.BS.Rest")
}

}
