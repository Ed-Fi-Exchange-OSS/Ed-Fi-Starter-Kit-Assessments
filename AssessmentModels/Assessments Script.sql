IF NOT EXISTS (
SELECT  schema_name
FROM    information_schema.schemata
WHERE   schema_name = 'BI' )

BEGIN
EXEC sp_executesql N'CREATE SCHEMA [BI] AUTHORIZATION [dbo]'
END
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER VIEW [BI].[asmt.School]
AS SELECT
          SchoolKey,
          SchoolName,
          LocalEducationAgencyKey,
          LocalEducationAgencyName
   FROM
        analytics.SchoolDim;
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER VIEW [BI].[asmt.Student]
AS SELECT
          StudentSchoolDim.GradeLevel AS [CurrentGradeLevel],
          StudentSchoolDim.SchoolKey AS [CurrentSchoolKey],
          COALESCE(DemographicsEconomicDisadvantaged.IsEconomicDisadvantaged, 0) AS IsEconomicDisadvantaged,
          COALESCE(Demographics.DemographicLabel, '') AS FederalRace,
          StudentSchoolDim.StudentFirstName AS FirstName,
          StudentSchoolDim.IsHispanic AS HispanicLatinoEthnicity,
          StudentSchoolDim.StudentLastName AS LastSurname,
          StudentSchoolDim.StudentMiddleName AS MiddleName,
          StudentSchoolDim.Sex AS SexType,
          StudentSchoolDim.StudentSchoolKey AS StudentUniqueId,
          StudentSchoolDim.StudentSchoolKey AS StudentSchoolKey,
          CAST(StudentSchoolDim.[EnrollmentDateKey] AS DATE) AS EntryDate,
          StudentSchoolDim.[SchoolKey]
   FROM
        [analytics].[StudentSchoolDim]
   OUTER APPLY
        ( SELECT TOP 1
                 DemographicLabel,
                 StudentSchoolDemographicsBridge.StudentSchoolKey
          FROM
               [analytics].[StudentSchoolDemographicsBridge]
          INNER JOIN
              [analytics].[DemographicDim] ON
                  DemographicDim.[DemographicKey] = StudentSchoolDemographicsBridge.[DemographicKey]
          WHERE
                  DemographicParentKey = 'Race'
                  AND
                  StudentSchoolDemographicsBridge.StudentSchoolKey = StudentSchoolDim.StudentSchoolKey
        ) AS Demographics
   OUTER APPLY
       ( SELECT TOP 1
                1 AS IsEconomicDisadvantaged
         FROM
              [analytics].[StudentSchoolDemographicsBridge]
         INNER JOIN
             [analytics].[DemographicDim] ON
                 DemographicDim.[DemographicKey] = StudentSchoolDemographicsBridge.[DemographicKey]
         WHERE
                 DemographicDim.DemographicKey = 'StudentCharacteristic:Economic Disadvantaged'
                 AND
                 StudentSchoolDemographicsBridge.StudentSchoolKey = StudentSchoolDim.StudentSchoolKey
       ) AS DemographicsEconomicDisadvantaged;
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER VIEW [BI].[asmt.Grade]
AS SELECT
          COALESCE(BeginDate.Date, CAST(GradingPeriodDim.GradingPeriodBeginDateKey AS DATETIME)) AS BeginDate,
          ews_StudentSectionGradeFact.NumericGradeEarned AS GradeEarned,
          ews_StudentSectionGradeFact.GradeType AS GradeType,
          GradingPeriodDim.GradingPeriodDescription AS GradingPeriod,
          COALESCE(BeginDate.Date, CAST(GradingPeriodDim.GradingPeriodBeginDateKey AS DATETIME)) AS GradingPeriodBeginDate,
          StudentSectionDim.SectionKey AS SectionKey,
          StudentSectionDim.LocalCourseCode AS LocalCourseCode,
          SchoolDim.LocalEducationAgencyKey AS LocalEducationAgencyId,
          SchoolDim.SchoolKey AS SchoolKey,
          StudentSectionDim.SchoolYear AS SchoolYear,
          COALESCE(StudentSectionStartDate.Date, CAST(StudentSectionDim.StudentSectionStartDateKey AS DATETIME)) AS SectionBeginDate,
          COALESCE(StudentSectionEndDate.Date, CAST(StudentSectionDim.StudentSectionEndDateKey AS DATETIME)) AS SectionEndDate,
          CONCAT(StudentSectionDim.StudentKey, '-', SchoolDim.SchoolKey) AS StudentSchoolKey,
          StudentSectionDim.Subject AS AcademicSubject,
          ews_StudentSectionGradeFact.GradingPeriodKey,
          StudentSectionDim.StudentSectionKey
   FROM
        analytics.ews_StudentSectionGradeFact
   INNER JOIN
       analytics.StudentSectionDim ON
           analytics.ews_StudentSectionGradeFact.StudentSectionKey = analytics.StudentSectionDim.StudentSectionKey
           AND
           analytics.ews_StudentSectionGradeFact.SchoolKey = analytics.StudentSectionDim.SchoolKey
           AND
           analytics.ews_StudentSectionGradeFact.StudentKey = analytics.StudentSectionDim.StudentKey
           AND
           analytics.ews_StudentSectionGradeFact.SectionKey = analytics.StudentSectionDim.SectionKey
   INNER JOIN
       analytics.SchoolDim ON
           analytics.StudentSectionDim.SchoolKey = analytics.SchoolDim.SchoolKey
   LEFT JOIN
       analytics.DateDim StudentSectionStartDate ON
           StudentSectionDim.StudentSectionStartDateKey = StudentSectionStartDate.DateKey
   LEFT JOIN
       analytics.DateDim StudentSectionEndDate ON
           StudentSectionDim.StudentSectionEndDateKey = StudentSectionEndDate.DateKey
   LEFT JOIN
       analytics.GradingPeriodDim ON
           analytics.ews_StudentSectionGradeFact.GradingPeriodKey = analytics.GradingPeriodDim.GradingPeriodKey
   LEFT JOIN
       analytics.DateDim BeginDate ON
           GradingPeriodDim.GradingPeriodBeginDateKey = BeginDate.DateKey;
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER VIEW [BI].[asmt.StaffSection]
AS

SELECT s.UserKey
    ,s.StaffSectionKey
    ,s.SectionKey
    ,s.PersonalTitlePrefix
    ,s.StaffFirstName AS FirstName
    ,s.StaffMiddleName AS MiddleName
    ,s.StaffLastName AS LastSurname
    ,s.BirthDate
    ,s.Race AS RaceType
    ,s.HispanicLatinoEthnicity
    ,s.YearsOfPriorProfessionalExperience
    ,s.YearsOfPriorTeachingExperience
    ,s.HighlyQualifiedTeacher
    ,s.LoginId
FROM analytics.StaffSectionDim s;
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER VIEW [BI].[asmt.Assessment]
AS SELECT DISTINCT
           [AssessmentKey],
           CONCAT_WS('-', [AssessmentKey], IdentificationCode, LearningStandard) AS [AssessmentIdentificationCodeKey],
           [AssessmentIdentifier],
           [Namespace],
           [Title],
           [Version],
           [Category],
           [AssessedGradeLevel],
           [AcademicSubject],
           LearningStandard
    FROM
         [analytics].[asmt_AssessmentFact];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER VIEW [BI].[asmt.StudentAssessmentScoreResult]
AS SELECT DISTINCT
          aaf.AssessmentKey,
		  CONCAT_WS('-', aaf.[AssessmentKey], aaf.IdentificationCode, aaf.LearningStandard) AS [AssessmentIdentificationCodeKey],
          aaf.AssessmentIdentifier,
          sa.StudentAssessmentKey,
          sa.StudentAssessmentIdentifier,
          sa.StudentSchoolKey,
          CAST(sa.AdministrationDate AS DATE) AS AdministrationDate,
          aaf.AssessedGradeLevel AS GradeLevel,
          aaf.AcademicSubject AS AcademicSubject,
          sa.ReportingMethod AS ReportingMethod,
          aaf.Title AS AssessmentTitle,
          sa.StudentScore AS Result,
          sa.Namespace AS Namespace,
          aaf.Version AS Version,
          sa.PerformanceResult
   FROM
        analytics.asmt_StudentAssessmentFact sa
   INNER JOIN
       analytics.asmt_AssessmentFact aaf ON
           sa.AssessmentKey = aaf.AssessmentKey
           AND
           sa.ObjectiveAssessmentKey = aaf.ObjectiveAssessmentKey
           AND
           sa.AssessedGradeLevel = aaf.AssessedGradeLevel
           AND
           sa.ReportingMethod = aaf.ReportingMethod
   WHERE sa.ReportingMethod IN('Raw Score');
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER VIEW [BI].[asmt.Section]
AS SELECT DISTINCT
          SchoolKey,
          SectionKey,
		  SectionName,
		  SessionName,
          LocalCourseCode,
          SchoolYear,
          EducationalEnvironmentDescriptor,
          LocalEducationAgencyId
   FROM
        analytics.SectionDim
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER VIEW [BI].[asmt.StudentSchoolDemographics]
AS SELECT DISTINCT
        StudentSchoolDemographicBridgeKey,
        StudentSchoolKey,
        StudentSchoolDemographicsBridge.DemographicKey,
        DemographicParentKey,
        DemographicLabel
    FROM
        analytics.StudentSchoolDemographicsBridge
    INNER JOIN
        analytics.DemographicDim ON
            StudentSchoolDemographicsBridge.DemographicKey = DemographicDim.DemographicKey
    WHERE DemographicParentKey in ('Disability', 'Race', 'StudentCharacteristic');
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER VIEW [BI].[asmt.StudentProgramAssociation]
AS SELECT
        StudentSchoolKey,
        ProgramName,
        MAX([BeginDate]) AS BeginDate
    FROM
        analytics.StudentProgramDim
    GROUP BY
        StudentSchoolKey, ProgramName;
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER VIEW [BI].[asmt.StudentSectionAssociation]
AS SELECT
          CONCAT(StudentSectionDim.[StudentKey], '-', StudentSectionDim.[SchoolKey]) AS StudentSchoolKey,
          StudentSectionDim.StudentSectionKey,
          StudentSectionDim.SchoolKey AS SchoolKey,
          StudentSectionDim.SectionKey,
          StudentSectionDim.LocalCourseCode AS LocalCourseCode,
          StudentSectionDim.SchoolYear AS SchoolYear,
          CAST(StudentSectionDim.StudentSectionStartDateKey AS DATE) AS BeginDate,
          CAST(StudentSectionDim.StudentSectionEndDateKey AS DATE) AS EndDate,
          SchoolDim.LocalEducationAgencyKey AS LocalEducationAgencyId
   FROM
        analytics.StudentSectionDim
   INNER JOIN
       analytics.SchoolDim ON
           StudentSectionDim.SchoolKey = SchoolDim.SchoolKey;
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
