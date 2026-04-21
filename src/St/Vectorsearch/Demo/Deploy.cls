Class St.Vectorsearch.Demo.Deploy Extends St.Tools.Deploy
{

ClassMethod Deploy()
{
    set production = "St.Vectorsearch.Demo.Production"
    set currentNamespace = $Namespace
    
    do ..AddItem(production, "St.Vectorsearch.Demo.BS.Rest", "St.Vectorsearch.Demo.BS.Rest")
    do ..AddItem(production, "St.Vectorsearch.Demo.BP.Feeling", "St.Vectorsearch.Demo.BP.Feeling")
    do ..AddItem(production, "St.Vectorsearch.Demo.BP.Vector", "St.Vectorsearch.Demo.BP.Vector")
    do ..AddItem(production, "St.Vectorsearch.Demo.BO.Feeling", "St.Vectorsearch.Demo.BO.Feeling")

    // Add default parameters
    do ..AddDefaultSetting(production,,"St.Vectorsearch.Demo.BS.Rest","BPClass","St.Vectorsearch.Demo.BO.Feeling")

    // Add API Services
    do ..RegisterWebApplication(currentNamespace, "/api","St.Vectorsearch.Demo.BS.Rest")
}

}
