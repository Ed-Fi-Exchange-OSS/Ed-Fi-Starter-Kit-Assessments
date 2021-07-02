# Assessment View

## Purpose

This view is for reporting on assessment data broken down by Subject

## SQL Object Name

`BI.asmt.Assessment`

## Data Definition and Sources

Column | Data Type | Source | Description
-------------|---------------|--------------|--------------
Academic Subject | nvarchar(1024), null | analytics.asmt_AssessmentFact | The subject associated with the assessment, such as Mathematics, Reading, English
AssessedGradeLevel | nvarchar(1024), null | analytics.asmt_AssessmentFact | The grade level(s) for which an assessment is designed. The semantics of null is assumed to mean that the assessment is not associated with any grade level.
AssessmentIdentifier | nvarchar(60), not null | analytics.asmt_AssessmentFact | A unique number or alphanumeric code assigned to an assessment
AssessmentKey | nvarchar(316), not null | analytics.asmt_AssessmentFact | A combination of AssessmentIdentifier + "-" + Namespace
Category | nvarchar(1024), null | analytics.asmt_AssessmentFact | The category of an assessment based on format and content. For example: Achievement test, Advanced placement test, Alternate assessment/grade-level standards, Attitudinal test, Cognitive and perceptual skills test
Namespace | nvarchar(255), not null | analytics.asmt_AssessmentFact | Namespace for the assessment, for example uri://ed-fi.org/Assessment/Assessment.xml
Title | nvarchar(100), not null | analytics.asmt_AssessmentFact | The title or name of the Assessment
Version | int, null | analytics.asmt_AssessmentFact | The version identifier for the assessment