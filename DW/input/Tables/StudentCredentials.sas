/* -------------------------------------------------------------------------- *
 | Name        : UpdatePersonTable.sas
 | Description : Import All Terms Informer data and store in DataMart
 | Author      : David Onder
 |
 | Create Date   (YYYYMMDD): 20170123
 | Change Date   (YYYYMMDD): 20170123
 |
 | Macros Used   : LOG, DBG
 |
 | Special Notes
 | -------------
 | N/A
 |
 | Change History
 | Date       Author  Chg  Description
 | --------    ---    ---  ---------------------------------------------------
 | 20170123    DMO    NEW  Initial version
 |
 * -------------------------------------------------------------------------- */
%GLOBAL DW_Macros;
%LET DW_Macros=L:\TISS\RIE\SAS\Macros\DW;

%INCLUDE "&DW_Macros\DW.sas";

%MACRO Update_StudentCredentials;
	%LET DataName=StudentCredentials;
	%LET DataLIB=D_INPUT;

	%LET FileRoot=&RIE_Data_Informer\&DataName;
	%FileList(&FileRoot);

	/* *
    data FileList;
        array files[1000] $ 256 _temporary_;
        dnum = 0;
        trunc = 0;
        call dir_entries("&FileRoot", files, dnum, trunc,0);
        if trunc then put 'ERROR: Not enough result array entries. Increase array size.';
        do i = 1 to dnum;
            files[i] = tranwrd(files[i],"&FileRoot\","");
            put files[i];

            if LENGTH(files[i])>=16 then do;
                Filename = STRIP(files[i]);
                OUTPUT;
            end;
        end;
        KEEP Filename;
    run;
	/* */ 

    DATA WORK.SourceIN (DROP=Filename myfilename);
        LENGTH myfilename $100;
        LENGTH 
            CampusID                     $ 7
            'First Name IGNORE'n         $ 20
            'Middle Name IGNORE'n        $ 20
            'Last Name IGNORE'n          $ 20
            'Suffix IGNORE'n             $ 5
            Birthdate                      8
            'Address Lines IGNORE'n      $ 200
            'City'n                      $ 100
            'State Code'n                $ 3
            'Zip Code'n                  $ 5
            'Phone Numbers(s) IGNORE'n   $ 50
            'E-mail Address(es) IGNORE'n $ 200
            'Program Code'n              $ 10
            'Program Name'n              $ 50
            'Major Code'n                $ 7
            'Major CIP'n                 $ 7
            'Honors'n                    $ 20
            'Academic Location'n         $ 20
            'Term Code'n                 $ 7
            'Start Date'n                  8
            'End Date'n                    8
            'Award Date'n                  8
            ;
        FORMAT
            CampusID                     $CHAR7.
            'First Name IGNORE'n         $CHAR20.
            'Middle Name IGNORE'n        $CHAR20.
            'Last Name IGNORE'n          $CHAR20.
            'Suffix IGNORE'n             $CHAR5.
            Birthdate                    YYMMDD10.
            'Address Lines IGNORE'n      $CHAR200.
            'City'n                      $CHAR100.
            'State Code'n                $CHAR3.
            'Zip Code'n                  $CHAR5.
            'Phone Numbers(s) IGNORE'n   $CHAR50.
            'E-mail Address(es) IGNORE'n $CHAR200.
            'Program Code'n              $CHAR10.
            'Program Name'n              $CHAR50.
            'Major Code'n                $CHAR7.
            'Major CIP'n                 $CHAR7.
            'Honors'n                    $CHAR20.
            'Academic Location'n         $CHAR20.
            'Term Code'n                 $CHAR7.
            'Start Date'n                YYMMDD10.
            'End Date'n                  YYMMDD10.
            'Award Date'n                YYMMDD10.
            ;
        INFORMAT
            CampusID                     $CHAR7.
            'First Name IGNORE'n         $CHAR20.
            'Middle Name IGNORE'n        $CHAR20.
            'Last Name IGNORE'n          $CHAR20.
            'Suffix IGNORE'n             $CHAR5.
            Birthdate                    YYMMDD10.
            'Address Lines IGNORE'n      $CHAR200.
            'City'n                      $CHAR100.
            'State Code'n                $CHAR3.
            'Zip Code'n                  $CHAR5.
            'Phone Numbers(s) IGNORE'n   $CHAR50.
            'E-mail Address(es) IGNORE'n $CHAR200.
            'Program Code'n              $CHAR10.
            'Program Name'n              $CHAR50.
            'Major Code'n                $CHAR7.
            'Major CIP'n                 $CHAR7.
            'Honors'n                    $CHAR20.
            'Academic Location'n         $CHAR20.
            'Term Code'n                 $CHAR7.
            'Start Date'n                YYMMDD10.
            'End Date'n                  YYMMDD10.
            'Award Date'n                YYMMDD10.
            ;

        SET FILELIST;

        filepath = "&FileRoot\"||Filename;

        INFILE DUMMY FILEVAR=filepath FIRSTOBS=2 ENCODING="WLATIN1" DLM='2c'x LENGTH=reclen END=done MISSOVER DSD;

        DO WHILE(NOT DONE);
            myfilename = filepath;
            INPUT
				CampusID                     : $CHAR7.
				'First Name IGNORE'n         : $CHAR20.
				'Middle Name IGNORE'n        : $CHAR20.
				'Last Name IGNORE'n          : $CHAR20.
				'Suffix IGNORE'n             : $CHAR5.
				Birthdate                    : YYMMDD10.
				'Address Lines IGNORE'n      : $CHAR200.
				'City'n                      : $CHAR100.
				'State Code'n                : $CHAR3.
				'Zip Code'n                  : $CHAR5.
				'Phone Numbers(s) IGNORE'n   : $CHAR50.
				'E-mail Address(es) IGNORE'n : $CHAR200.
				'Program Code'n              : $CHAR10.
				'Program Name'n              : $CHAR50.
				'Major Code'n                : $CHAR7.
				'Major CIP'n                 : $CHAR7.
				'Honors'n                    : $CHAR20.
				'Academic Location'n         : $CHAR20.
				'Term Code'n                 : $CHAR7.
				'Start Date'n                : YYMMDD10.
				'End Date'n                  : YYMMDD10.
				'Award Date'n                : YYMMDD10.
                ;
            OUTPUT;
        END;
    RUN;

    /* *
    DATA WORK.SourceIN;
        SET WORK.SourceIN;
        FORMAT 'VAR'n $CHAR60.
               Var $CHAR60.
        ;
        'VAR'n = STUFF;
        Var = STUFF;
    RUN;
    * */

    PROC SQL NOPRINT; 
        CREATE TABLE WORK.SOURCE_DM AS
        SELECT s.*
          FROM &DataLIB..&DataName s
         WHERE s.CampusID IN (SELECT DISTINCT CampusID FROM WORK.SourceIN s1 WHERE s1.'Award Date'n=s.'Award Date'n)
        ;
    QUIT; RUN;

    PROC SQL NOPRINT;
       CREATE TABLE WORK.Source(label="WORK.Source") AS 
       SELECT s.StudentCredentialsId,
              p.PersonID,
              s_in.CampusID,
              p.'First Name'n,
              p.'Middle Name'n,
              p.'Last Name'n,
              floor( (intck('month', p.Birthday, t.'Term Start Date'n) - ( day(t.'Term Start Date'n) < day(p.Birthday) )) / 12) AS Age,
              p.'Gender Code'n,
              p.Gender,
              p.'Race Code'n,
              p.Race,

              s_in.City,
              s_in.State AS 'State Code'n,
              s_in.'Zip Code'n,

              s_in.'Program Code'n,
              s_in.'Program Name'n,
              pr.'Credential'n,
              pr.'Credential Type'n,
              pp.Catalog,
              s_in.'Major CIP'n,
              s_in.Honors,
              s_in.'Award Date'n,

              t.'Term Code'n,
              t.Term
          FROM WORK.SourceIN s_in
               LEFT JOIN WORK.TERMS_DM t ON (t.'Term Code'n=s_in.'Term Code'n)
               LEFT JOIN WORK.PROGRAMS_DM pr ON (pr.'Program Code'n=s_in.'Program Code'n)
               LEFT JOIN WORK.PERSON_DM p ON (p.CampusID=s_in.CampusID)
               LEFT JOIN WORK.SOURCE_DM s
                    ON (s.CampusID=s_in.CampusID
                        AND s.'Program Code'n=s_in.'Program Code'n
                        AND s.'Term Code'n=s_in.'Term Code'n
                       )
        ;
    QUIT; RUN;

    /* *
    PROC DATASETS LIBRARY=WORK NODETAILS NOLIST NOWARN;
        DELETE SourceIN;
    RUN;
    /* */

    * % GetRecordVariableNames(WORK.StudentCourses);
    * % InsertHashRecord(WORK.StudentCourses,RECORD_HASH2,ExcludeVars=PersonID::Campus_ID::CURRENT_RECORD_HASH);
/*
    %LOG("Get changed records and update in database");
    PROC SQL NOPRINT;
        CREATE TABLE WORK.CHANGED_RECORDS AS 
        SELECT s.*
          FROM WORK.Source s
         WHERE s.&DataName.Id IS NOT NULL
           AND s.RECORD_HASH~=s.CURRENT_RECORD_HASH
        ;

        SELECT COUNT(*) INTO :ChangedRecords FROM WORK.CHANGED_RECORDS;
    QUIT; RUN;

    %MACRO Get_Changed_Value(field);
        &field=(SELECT &field FROM CHANGED_RECORDS u WHERE u.&DataName.Id=sc.&DataName.Id)
    %MEND;

    %IF &ChangedRecords<0 %THEN %DO;
        %LOG( "Updating &ChangedRecords records in database" );

        PROC SQL NOPRINT;
            UPDATE D_HCC.Person p
               SET %Get_Changed_Value('Term Code'n),
                   %Get_Changed_Value(Subject),
                   %Get_Changed_Value(Course),
                   %Get_Changed_Value(Section),
                   %Get_Changed_Value(Title),
                   %Get_Changed_Value(Instructor),
                   %Get_Changed_Value('First Name'n),
                   %Get_Changed_Value('Last Name'n),
                   %Get_Changed_Value('Gender Code'n),
                   %Get_Changed_Value(Gender),
                   %Get_Changed_Value('Residence State'n),
                   %Get_Changed_Value(Ethnicity),
                   %Get_Changed_Value(Birthdate),
                   %Get_Changed_Value('Student Status'n),
                   %Get_Changed_Value(Grade),
                   %Get_Changed_Value(RECORD_HASH)
             WHERE PersonID IN (SELECT PersonID FROM CHANGED_RECORDS u)
            ;
        QUIT; RUN;
    %END;
    %ELSE %DO;
        %LOG( "No records to update in database" );
    %END;
*/
    %LOG("Get new records and insert into database");

    PROC SQL NOPRINT;
        /* Process NEW records */
        CREATE TABLE WORK.NEW_RECORDS AS 
        SELECT s.*
          FROM WORK.Source s
         WHERE s.&DataName.Id IS NULL
        ;

        SELECT COUNT(*) INTO :NewRecords FROM WORK.NEW_RECORDS;
    QUIT; RUN;

    DATA WORK.NEW_RECORDS;
        SET WORK.NEW_RECORDS;
        DROP &DataName.Id; * CURRENT_RECORD_HASH RECORD_HASH;
    RUN;

    %IF &NewRecords>0 %THEN %DO;
        %LOG( "Inserting &NewRecords new records into database" );

        PROC SQL NOPRINT;
            SELECT DISTINCT CAT("'",TRIM(NAME),"'n")
              INTO :Var_Names SEPARATED BY ','
              FROM SASHELP.VCOLUMN
             WHERE UPCASE(LIBNAME) = "WORK"
               AND UPCASE(MEMNAME) = UPCASE("NEW_RECORDS")
             ORDER BY VARNUM
            ;   

            DELETE * FROM &DataLIB..&DataName;

            %LOG("&Var_Names");
            INSERT INTO &DataLIB..&DataName
                (&Var_Names)
                SELECT &Var_Names
                FROM WORK.NEW_RECORDS
            ;
        QUIT; RUN;
    %END;
    %ELSE %DO;
        %LOG( "No new records to insert into database" );
    %END;

%MEND;
%Update_StudentCredentials;
