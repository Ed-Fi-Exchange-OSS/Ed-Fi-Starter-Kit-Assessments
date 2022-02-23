# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

<#
        .SYNOPSIS
        Run the SQL files in the folder. Files are executed ordered by file name.

        .DESCRIPTION
        Run the SQL files in the folder. Files are executed ordered by file name. 
       
        .PARAMETER serverInstance
        Specifies server instance. Default: .\SQLEXPRESS

        .PARAMETER database
        Specifies the target database. Default: Edfi_Ods

        .PARAMETER scriptFolder
        Specifies the scripts folder.

        .PARAMETER username
        Specifies the database username (optional).

        .PARAMETER password
        Specifies the database user password (optional).

        .INPUTS
        None.

        .OUTPUTS
        None.
        
        .EXAMPLE
        PS> .\Add-SampleData.ps1
        Running 001_Script.sql
        ...
        .EXAMPLE
        PS>.\Add-SampleData.ps1 -username dbUser -password dbpassword
        Running 001_Script.sql
        ...
        .EXAMPLE
        PS> .\Add-SampleData.ps1 -serverinstance . -username dbUser -password dbpassword
        Running 001_Script.sql
        ...
        .EXAMPLE
        PS> .\Add-SampleData.ps1 -serverinstance . -database edfi_ods -username dbUser -password dbpassword
        Running 001_Script.sql
        ...
    #>
    param ( [string]$serverInstance=".\SQLEXPRESS",
    [string]$database="Edfi_Ods",
    [string]$scriptFolder=".",
    [string]$username,
    [string]$password
)
Push-Location
Set-Location "$scriptFolder"
#Get the list of SQL Scripts, ordered by name.
$sampleDataFiles = Get-ChildItem ".\*.sql" -include *.sql -name | Sort-Object
foreach ($file in $sampleDataFiles)
{
    Write-Host "Executing Database Server script $file" -ForegroundColor Cyan
    if($username){
        Invoke-Sqlcmd -ServerInstance "$serverInstance" -Database $database -username $username -password $password -InputFile "$file" 
    }
    else{
        Invoke-Sqlcmd -ServerInstance "$serverInstance" -Database $database -InputFile "$file" 
    }
}
Pop-Location