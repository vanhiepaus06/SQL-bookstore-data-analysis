--===== Run this code to insert 1 table --=====
BULK INSERT Customers
FROM 'D:\JungTalents\Basic Data\SQL\MID_TEST\Data\customers.csv'
WITH (
    FIELDTERMINATOR = ',',  -- CSV field delimiter
    ROWTERMINATOR = '\n',   -- CSV row delimiter
    FIRSTROW = 2            -- If your CSV contains column headers, set this to 2 so it skips the headers
);

--===== Run this code in PowerShell to insert all table --=====

# Define the path to the CSV files
$csvFolderPath = "D:\JungTalents\Basic Data\SQL\MID_TEST\Data\"

# Get a list of CSV files in the folder
$csvFiles = Get-ChildItem -Path $csvFolderPath -Filter *.csv

# Loop through each file and import it into SQL Server
foreach ($file in $csvFiles) {
    $tableName = $file.BaseName  # Assumes the table name matches the file name
    $filePath = $file.FullName
    
    # Define the BULK INSERT query
    $query = @"
BULK INSERT $tableName
FROM '$filePath'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0a',   
    FIRSTROW = 2,
    CODEPAGE = '65001'  -- UTF-8 encoding
);
"@

    # Execute the query using Invoke-Sqlcmd
    Invoke-Sqlcmd -Query $query -ServerInstance "LAPTOP-GA5EUQJE" -Database "gravity_books"
}

