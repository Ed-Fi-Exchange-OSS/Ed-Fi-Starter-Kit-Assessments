# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

$ServerInstance = 'localhost'
$DatabaseName = 'EdFi_Ods'

Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -InputFile ".\learningStandards.sql"
Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -InputFile ".\enableStaffSectionAssociation.sql"
Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -InputFile ".\data.sql"
Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -InputFile ".\data_Assessments_1.sql"
Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -InputFile ".\data_Assessments_2.sql"
Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -InputFile ".\data_Assessments_3.sql"
Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -InputFile ".\data_Assessments_4.sql"


