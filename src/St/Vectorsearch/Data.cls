Class St.Vectorsearch.Data Extends %RegisteredObject
{

ClassMethod Init() As %Status
{
    set tStatement = ##class(%SQL.Statement).%New()
    set tSC = tStatement.%Prepare("CREATE TABLE St_Vectorsearch.Feeling ( Id INT PRIMARY KEY AUTO_INCREMENT, Text VARCHAR(1024), Value INT, Vector VECTOR(float, 384) )")
    If $$$ISERR(tSC) { Return tSC }
    set tResultSet = tStatement.%Execute()
    set tSC = tStatement.%Prepare("CREATE INDEX IDX_Feeling_Vector ON St_Vectorsearch.Feeling(Vector)")
    If $$$ISERR(tSC) { Return tSC }
    set tResultSet = tStatement.%Execute()

    return $$$OK
}

/// Populate from default file
ClassMethod Populate(truncate As %Boolean = 1) As %Status
{
    return ..PopulateFromFile(truncate, "training.csv")
}

/// Populate from full file
ClassMethod PopulateFull(truncate As %Boolean = 1) As %Status
{
    return ..PopulateFromFile(truncate, "training-full.csv")
}

/// Populate from file
ClassMethod PopulateFromFile(truncate As %Boolean = 1, fileName As %String) As %Status
{
    set total = 0
    set pos = 0
    if (truncate)
    {
        Set tStatement = ##class(%SQL.Statement).%New()
        Set tSC = tStatement.%Prepare("TRUNCATE TABLE St_Vectorsearch.Feeling")
        write "Truncating table St_Vectorsearch.Feeling",!
        If $$$ISERR(tSC) { Return tSC }
        Set tResult = tStatement.%Execute()

        Set tStatement = ##class(%SQL.Statement).%New()
        write "Preparing to load data from file ",fileName,!
        IF fileName="training.csv" {
            Set tSC = tStatement.%Prepare("LOAD DATA FROM FILE '/opt/irisbuild/data/training.csv' INTO St_Vectorsearch.Feeling(Text, Value)")
            If $$$ISERR(tSC) { Return tSC }
        }
        IF fileName="training-full.csv" {
            Set tSC = tStatement.%Prepare("LOAD DATA FROM FILE '/opt/irisbuild/data/training-full.csv' INTO St_Vectorsearch.Feeling(Text, Value)")
            If $$$ISERR(tSC) { Return tSC }
        }
        write "Loading data from file ",fileName,!
        Set tResult = tStatement.%Execute()
    }

    &sql(SELECT COUNT(1) INTO :total FROM St_Vectorsearch.Feeling)

    write "Total records loaded: ",total,!
    // Now calculate vectors
    Set tStatement = ##class(%SQL.Statement).%New()
    Set tSC = tStatement.%Prepare("SELECT * FROM St_Vectorsearch.Feeling")
    If $$$ISERR(tSC) { Return tSC }

    Set tResultSet = tStatement.%Execute()
    write "Calculating vectors for records...",!
    While tResultSet.%Next() {
        write "Processing ",pos," of ",total,!,/CUU(1)
        // Access the columns of the record
        if (tResultSet.Vector="") {
            do ..UpdateVector(tResultSet.Id, tResultSet.Text)
            }
        Set pos = pos + 1
    }

    Return $$$OK
}

ClassMethod UpdateVector(id As %Integer, text As %String) As %Status
{
    Set statement = ##class(%SQL.Statement).%New(1)
    set vector = ##class(St.Vectorsearch.Vector).Embedding(text)
    Set sql = " update St_Vectorsearch.Feeling Set Vector =TO_VECTOR(?,double) where id =? "
    Set qStatus = statement.%Prepare(sql)
    set tResult = statement.%Execute(vector,id)
    Return $$$OK
}

}
