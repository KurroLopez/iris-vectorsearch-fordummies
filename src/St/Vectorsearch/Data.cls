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
    set tSC = tStatement.%Prepare("CREATE TABLE St_Vectorsearch.DescFeeling ( Id INT PRIMARY KEY, Description VARCHAR(1024) )")
    If $$$ISERR(tSC) { Return tSC }
    set tResultSet = tStatement.%Execute()

    Set tStatement = ##class(%SQL.Statement).%New()
    Set tSC = tStatement.%Prepare("TRUNCATE TABLE St_Vectorsearch.DescFeeling")
    write "Truncating table St_Vectorsearch.DescFeeling",!
    If $$$ISERR(tSC) { Return tSC }
    Set tResult = tStatement.%Execute()

    Set tSC = tStatement.%Prepare("LOAD DATA FROM FILE '/opt/irisbuild/data/descfeeling.csv' INTO St_Vectorsearch.DescFeeling(Id, Description)")
    If $$$ISERR(tSC) { Return tSC }
    Set tResult = tStatement.%Execute()

    return $$$OK
}

ClassMethod InitMovie() As %Status
{
    set tStatement = ##class(%SQL.Statement).%New()
    set query = "CREATE TABLE St_Vectorsearch.Movie ( ID INT PRIMARY KEY AUTO_INCREMENT, "
    set query = query_" Link VARCHAR(255), Title VARCHAR(255), "
    set query = query_" Year INT, Certificate VARCHAR(50), Runtime INT, "
    set query = query_" Genre VARCHAR(255), Rating DECIMAL(3,1), Overview VARCHAR(1024), "
    set query = query_" Director VARCHAR(255), Star1 VARCHAR(255), "
    set query = query_" Star2 VARCHAR(255), Star3 VARCHAR(255), Star4 VARCHAR(255), "
    set query = query_" Vector VECTOR(float, 384) )"

    set tSC = tStatement.%Prepare(query)
    If $$$ISERR(tSC) { Return tSC }
    set tResultSet = tStatement.%Execute()
    set tSC = tStatement.%Prepare("CREATE INDEX IDX_Movie_Vector ON St_Vectorsearch.Movie(Vector)")
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


/// Populate from default file
ClassMethod PopulateMovie(truncate As %Boolean = 1) As %Status
{
    set total = 0
    set pos = 0
    if (truncate)
    {
        Set tStatement = ##class(%SQL.Statement).%New()
        Set tSC = tStatement.%Prepare("TRUNCATE TABLE St_Vectorsearch.Movie")
        write "Truncating table St_Vectorsearch.Movie",!
        If $$$ISERR(tSC) { Return tSC }
        Set tResult = tStatement.%Execute()
    }
    Set tStatement = ##class(%SQL.Statement).%New()
    write "Preparing to load data from file imdb_top_1000.csv",!
    set query = "LOAD DATA FROM FILE '/opt/irisbuild/data/imdb_top_1000.csv' "
    set query = query_" INTO St_Vectorsearch.Movie(Link, Title, Year "
    set query = query_", Certificate, Runtime, Genre, Rating, Overview "
    set query = query_", Director, Star1, Star2, Star3, Star4)"
    Set tSC = tStatement.%Prepare(query)
    If $$$ISERR(tSC) { Return tSC }
    write "Loading data from file imdb_top_1000.csv",!
    Set tResult = tStatement.%Execute()

    &sql(SELECT COUNT(1) INTO :total FROM St_Vectorsearch.Movie)

    write "Total records loaded: ",total,!
    // Now calculate vectors
    Set tStatement = ##class(%SQL.Statement).%New()
    Set tSC = tStatement.%Prepare("SELECT * FROM St_Vectorsearch.Movie")
    If $$$ISERR(tSC) { Return tSC }

    Set tResultSet = tStatement.%Execute()
    write "Calculating vectors for records...",!
    While tResultSet.%Next() {
        write "Processing ",pos," of ",total,!,/CUU(1)
        // Access the columns of the record
        if (tResultSet.Vector="") {
            set text = "Movie year "_tResultSet.Year_" - Genre: "_tResultSet.Genre_" - Directed by "_tResultSet.Director_" - "
            set text = text_" and starring by "_tResultSet.Star1_", "_tResultSet.Star2_", "_tResultSet.Star3_" and "_tResultSet.Star4_" - "
            set text = text_" Sinopsis: "_tResultSet.Overview_". Ranking: "_tResultSet.Rating
            do ..UpdateVectorMovie(tResultSet.ID, text)
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

ClassMethod UpdateVectorMovie(id As %Integer, text As %String) As %Status
{
    Set statement = ##class(%SQL.Statement).%New(1)
    set vector = ##class(St.Vectorsearch.Vector).Embedding(text)
    Set sql = " update St_Vectorsearch.Movie Set Vector =TO_VECTOR(?,double) where id =? "
    Set qStatus = statement.%Prepare(sql)
    set tResult = statement.%Execute(vector,id)
    Return $$$OK
}

}
