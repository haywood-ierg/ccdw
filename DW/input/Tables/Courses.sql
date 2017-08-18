﻿CREATE TABLE [input].[Courses] (
    [CoursesID]                     INT            NOT NULL,
    [Campus Course ID]             NVARCHAR (60)  NULL,
    [Course]                       NVARCHAR (60)  NULL,
    [Subject Code]                 NVARCHAR (10)  NULL,
    [Course Number]                NVARCHAR (10)  NULL,
    [Section Number]               NVARCHAR (10)  NULL,
    [Course Title]                 NVARCHAR (255) NULL,
    [Course Short Title]           NVARCHAR (50)  NULL,
    [Credit Hours]                 DECIMAL (9, 2) NULL,
    [Contact Hours]                DECIMAL (9, 2) NULL,
    [Term Code]                    NVARCHAR (7)   NULL,
    [Term]                         NVARCHAR (20)  NULL,
    [Term Type]                    NVARCHAR (2)   NULL,
    [Term Abbreviation]            NVARCHAR (3)   NULL,
    [Academic Year]                NVARCHAR (9)   NULL,
    [Reporting Academic Year]      NVARCHAR (9)   NULL,
    [Year]                         INT            NULL,
    [Reporting Year]               INT            NULL,
    [Reporting Code]               INT            NULL,
    [Reporting Code Alternate]     INT            NULL,
    [Term Sort Order]              INT            NULL,
    [Instructor]                   NVARCHAR (255) NULL,
    [Department Name]              NVARCHAR (50)  NULL,
    [College Name]                 NVARCHAR (50)  NULL,
    [Course CIP]                   NVARCHAR (7)   NULL,
    [Course Type]                  NVARCHAR (25)  NULL,
    [Course Delivery Mode]         NVARCHAR (100) NULL,
    [Instructional Method]         NVARCHAR (100) NULL,
    [Campus]                       NVARCHAR (100) NULL,
    [Building]                     NVARCHAR (100) NULL,
    [Room]                         NVARCHAR (100) NULL,
    [Is Developmental Course]      NVARCHAR (3)   NULL,
    [Class Meeting Days]           NVARCHAR (60)  NULL,
    [Class Beginning Time]         TIME (7)       NULL,
    [Class Ending Time]            TIME (7)       NULL,
    [Time Day Identifier]          NVARCHAR (40)  NULL,
    [Total Enrollment]             INT            NULL,
    [Total Enrollment - First Day] INT            NULL,
    [Total Enrollment - Census]    INT            NULL,
    [RECORD_HASH]                  NVARCHAR (64)  NULL, 
    CONSTRAINT [PK_Courses] PRIMARY KEY ([CoursesID])
);
