joined = LOAD '/user/hive/warehouse/testing1.db/joined_data/000000_0 ' USING PigStorage(',') 
AS (School_Name:chararray,Num_Educators_to_be_Evaluated:chararray,Num_Evaluated:chararray,Percent_Evaluated:chararray,Percent_Exemplary:chararray,Percent_Proficient:chararray,Percent_Needs_Improvement:chararray,Percent_Unsatisfactory:chararray,
African_American:double,Asian:double,Hispanic:double,White:double,Native_American:double,Native_Hawaiian_Pacific_Islander:double,MultiRace_NonHispanic:double,Males:double,Females:double,
School_Code:int,High_School_Graduates_Num:int,Attending_College_Num:int,Attending_College_Percent:double,Private_TwoYear_Percent:double,Private_FourYear_Percent:double,Public_TwoYear_Percent:double,Public_FourYear_Percent:double,MA_Community_College_Percent:double,MA_State_University_Percent:double,Univof_Mass_Percent:double,
Num_in_Cohort:int,Percent_Graduated:double,Percent_Still_in_School:double,Percent_NonGrad_Completers:double,Percent_GED:double,Percent_Dropped_Out:double,Percent_Permanently_Excluded:double,
Retention_Num:chararray,Retention_Rate:double,Attendance_Rate:double, Average_Num_Absences:double,Absent_10_or_more_days:double,Chronically_Absent_10_percent_or_more:double,Unexcused_9_days:double);

cleansed = FOREACH joined GENERATE (
    School_Name,Num_Educators_to_be_Evaluated,Num_Evaluated,Percent_Evaluated,Percent_Exemplary,Percent_Proficient,Percent_Needs_Improvement,Percent_Unsatisfactory,
    African_American,Asian,Hispanic,White,Native_American,Native_Hawaiian_Pacific_Islander,MultiRace_NonHispanic,Males,Females,
    School_Code,High_School_Graduates_Num,Attending_College_Num,Attending_College_Percent,Private_TwoYear_Percent,Private_FourYear_Percent,Public_TwoYear_Percent,Public_FourYear_Percent,MA_Community_College_Percent,MA_State_University_Percent,Univof_Mass_Percent,
    Num_in_Cohort,Percent_Graduated,Percent_Still_in_School,Percent_NonGrad_Completers,Percent_GED,Percent_Dropped_Out,Percent_Permanently_Excluded,
    Retention_Num,Retention_Rate,Attendance_Rate, Average_Num_Absences,Absent_10_or_more_days,Chronically_Absent_10_percent_or_more,Unexcused_9_days), REPLACE(Total_Num_Classes, '"', ''), REPLACE(Retention_Num,'"',''), REPLACE(Num_Evaluated,'NA|-|NI',''),REPLACE(Num_Educators_to_be_Evaluated,'NA',''),REPLACE(Percent_Evaluated,'NA',''),REPLACE(Percent_Exemplary,'NA|-|NI',''),REPLACE(Percent_Proficient,'NA|-|NI',''),REPLACE(Percent_Needs_Improvement,'NA|-|NI',''),REPLACE(Percent_Unsatisfactory,'NA|-|NI',''),REPLACE(Private_TwoYear_Percent,'0','0.0'), REPLACE(Percent_Permanently_Excluded,'0','0.0'), REPLACE(School_Name, '"', '');





/*
*classSize = LOAD '/user/cloudera/testing1/data/raw-zone/prepped-raw-data/classsizebygenderpopulation/classsizebygenderpopulation-stripped.csv' USING PigStorage(',') AS (SCHOOL:int,Org_Code:int,Total_Num_Classes:chararray,Average_Class_Size:int,Num_Students:chararray,Female_Percent:double,Male_Percent:double,Limited_English_Proficient_Percent:int,Special_Education_Percent:double,Economically_Disadvantaged_Percent:double);
*cs_prep = FOREACH classSize GENERATE (SCHOOL,Org_Code,Total_Num_Classes,Average_Class_Size,Num_Students,Female_Percent,Male_Percent,Limited_English_Proficient_Percent,Special_Education_Percent,Economically_Disadvantaged_Percent),REPLACE(Num_Students,'"',''),REPLACE(Total_Num_Classes, '"', '');
*
*enrollment= LOAD '/user/cloudera/testing1/data/raw-zone/prepped-raw-data/enrollmentbyracegender/enrollmentbyracegender-stripped.csv' AS (SCHOOL:chararray,ORG_CODE:int,African_American:double,Asian:double,Hispanic:double,White:double,Native_American:double,Native_Hawaiian_Pacific_Islander:double,MultiRace_NonHispanic:double,Males:double,Females:double);
*
*indicators= LOAD '/user/cloudera/testing1/data/raw-zone/prepped-raw-data/indicators/indicators-stripped.csv' AS (School_Name:chararray,School_Code:chararray,Retention_Num:chararray,Retention_Rate:double,Attendance_Rate:double, Average_Num_Absences:double,Absent_10_or_more_days:double,Chronically_Absent_10_percent_or_more:double,Unexcused_9_days:double);
*ind_prep = FOREACH indicators GENERATE (School_Name,School_Code,Retention_Num,Retention_Rate,Attendance_Rate,Average_Num_Absences,Absent_10_or_more_days,Chronically_Absent_10_percent_or_more,Unexcused_9_days),REPLACE(Retention_Num,'"','');
*
*evaluation= LOAD '/user/cloudera/testing1/data/raw-zone/prepped-raw-data/EducatorEvalPerf/EducatorEvalPerf-stripped.csv' AS (School_Name:chararray,Org_Code:int,Num_Educators_to_be_Evaluated:chararray,Num_Evaluated:chararray,Percent_Evaluated:chararray,Percent_Exemplary:chararray,Percent_Proficient:chararray,Percent_Needs_Improvement:chararray,Percent_Unsatisfactory:chararray);
*eval_prep = FOREACH classSize GENERATE (School_Name,Org_Code,Num_Educators_to_be_Evaluated,Num_Evaluated,Percent_Evaluated,Percent_Exemplary,Percent_Proficient,Percent_Needs_Improvement,Percent_Unsatisfactory),REPLACE(Num_Evaluated,'NA|-|NI',''),REPLACE(Num_Educators_to_be_Evaluated,'NA',''),REPLACE(Percent_Evaluated,'NA',''),REPLACE(Percent_Exemplary,'NA|-|NI',''),REPLACE(Percent_Proficient,'NA|-|NI',''),REPLACE(Percent_Needs_Improvement,'NA|-|NI',''),REPLACE(Percent_Unsatisfactory,'NA|-|NI','');

*College = LOAD '/user/cloudera/testing1/data/raw-zone/prepped-raw-data/Gradsattendingcollege/Gradsattendingcollege-stripped.csv' AS (School_Name:chararray,School_Code:int,High_School_Graduates_Num:int,Attending_College_Num:int,Attending_College_Percent:double,Private_TwoYear_Percent:double,Private_FourYear_Percent:double,Public_TwoYear_Percent:double,Public_FourYear_Percent:double,MA_Community_College_Percent:double,MA_State_University_Percent:double,Univof_Mass_Percent:double);
*col_prep = FOREACH classSize GENERATE (School_Name,School_Code,High_School_Graduates_Num,Attending_College_Num,Attending_College_Percent,Private_TwoYear_Percent,Private_FourYear_Percent,Public_TwoYear_Percent,Public_FourYear_Percent,MA_Community_College_Percent,MA_State_University_Percent,Univof_Mass_Percent),REPLACE(Private_TwoYear_Percent,'0','0.0');
*
*graduates = LOAD '/user/cloudera/testing1/data/raw-zone/prepped-raw-data/graduates/graduates-stripped.csv' AS (Org_Name:chararray,OrgCode:int,Num_in_Cohort:int,Percent_Graduated:double,Percent_Still_in_School:double,Percent_NonGrad_Completers:double,Percent_GED:double,Percent_Dropped_Out:double,Percent_Permanently_Excluded:double);
*grads_prep = FOREACH classSize GENERATE (Org_Name,OrgCode,Num_in_Cohort,Percent_Graduated,Percent_Still_in_School,Percent_NonGrad_Completers,Percent_GED,Percent_Dropped_Out,Percent_Permanently_Excluded),REPLACE(Percent_Permanently_Excluded,'0','0.0');
*
*/