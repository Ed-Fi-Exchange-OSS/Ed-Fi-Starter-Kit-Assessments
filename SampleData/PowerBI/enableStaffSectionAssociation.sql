-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.
-- Set Last StaffSectionAssociation.EndDate=null for each Staff-Section.
MERGE EdFi_Ods.edfi.StaffSectionAssociation AS target
USING (
	SELECT ID
	FROM EdFi_Ods.edfi.StaffSectionAssociation a
	WHERE ID IN (
			SELECT TOP 1 id
			FROM EdFi_Ods.edfi.StaffSectionAssociation b
			WHERE a.StaffUSI = b.StaffUSI
				AND a.LocalCourseCode = b.LocalCourseCode
				AND a.SchoolId = b.SchoolId
				AND a.SchoolYear = b.SchoolYear
				AND a.SectionIdentifier = b.SectionIdentifier
				AND a.SessionName = b.SessionName
			ORDER BY ISNULL(EndDate, getdate()) DESC
			)
	) AS source
	ON target.ID = source.ID
WHEN MATCHED
	THEN
		UPDATE
		SET target.EndDate = NULL;

---