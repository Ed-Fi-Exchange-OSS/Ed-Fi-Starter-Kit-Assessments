# StudentAssessmentScoreResult View

## Purpose

This view is for reporting on assessment data, broken down by Student, Subject,
School, and Staff

## SQL Object Name

`BI.asmt.Assessment`

## Data Definition and Sources

Column | Data Type | Source | Description
-------------|---------------|--------------|--------------
AcademicSubject | nvarchar(1024), null | analytics.asmt_AssessmentFact | The subject associated with the assessment, such as Mathematics, Reading, English
AdministrationDate | date, null | analytics.asmt_StudentAssessmentFact | The date of the assessment (MM/DD/YYYY format)
AssessmentIdentifier | nvarchar(60), not null | analytics.asmt_AssessmentFact | A unique number or alphanumeric code assigned to an assessment
AssessmentKey | nvarchar(316), not null | analytics.asmt_AssessmentFact | A combination of AssessmentIdentifier + "-" + Namespace
AssessmentTitle | nvarchar(100), not null | analytics.asmt_AssessmentFact.Title | The title or name of the Assessment
GradeLevel | nvarchar(1024), null | analytics.asmt_AssessmentFact.AssessedGradeLevel | The grade level(s) for which an assessment is designed. The semantics of null is assumed to mean that the assessment is not associated with any grade level.
Namespace | nvarchar(255), not null | analytics.asmt_StudentAssessmentFact | Namespace for the assessment, for example uri://ed-fi.org/Assessment/Assessment.xml
PerformanceResult | nvarchar(1024), null | analytics.asmt_StudentAssessmentFact | The PerformanceLevel that lines up with the score, based on what is defined in edfi.AssessmentPerformanceLevel
ReportingMethod | nvarchar(1024), null | analytics.asmt_StudentAssessmentFact | The method that the instructor of the classes uses to report the performance and achievement of all students. It may be a qualitative method such as individualized teacher comments or a quantitative method such as a letter or a numerical grade.
Result | nvarchar(35), null | analytics.asmt_StudentAssessmentFact.StudentScore | The value of a meaningful raw score or statistical expression of the performance of an individual. The results can be expressed as a number, percentile, range, level, etc.
StudentAssessmentKey | nvarchar(390), not null | analytics.asmt_StudentAssessmentFact | A combination of AssessmentIdentifier + "-" + Namespace + "-" + StudentAssessmentIdentifier + "-" + StudentUSI
StudentAssessmentIdentifier | nvarchar(60), not null | analytics.asmt_StudentAssessmentFact | A unique number or alphanumeric code assigned to an assessment administered to a student
StudentSchoolKey | nvarchar(45), not null | analytics.asmt_StudentAssessmentFact | For linking to BI.asmt.Student. A combination of StudentUniqueId + "-" + SchoolId
Version | int, null | analytics.asmt_AssessmentFact | The version identifier for the assessment