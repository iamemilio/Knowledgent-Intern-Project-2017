USE testing1;
CREATE TABLE Joined_Data 
STORED AS TEXTFILE
AS
SELECT educatorevalperf.School_Name,educatorevalperf.Num_Educators_to_be_Evaluated,educatorevalperf.Num_Evaluated,educatorevalperf.Percent_Evaluated,educatorevalperf.Percent_Exemplary,educatorevalperf.Percent_Proficient,educatorevalperf.Percent_Needs_Improvement,educatorevalperf.Percent_Unsatisfactory,
enrollmentbyracegender.African_American ,enrollmentbyracegender.Asian ,enrollmentbyracegender.Hispanic ,enrollmentbyracegender.White ,enrollmentbyracegender.Native_American ,enrollmentbyracegender.Native_Hawaiian_Pacific_Islander ,enrollmentbyracegender.MultiRace_NonHispanic ,enrollmentbyracegender.Males ,enrollmentbyracegender.Females,
gradsattendingcollege.School_Code ,gradsattendingcollege.High_School_Graduates_Num ,gradsattendingcollege.Attending_College_Num ,gradsattendingcollege.Attending_College_Percent ,gradsattendingcollege.Private_TwoYear_Percent ,gradsattendingcollege.Private_FourYear_Percent ,gradsattendingcollege.Public_TwoYear_Percent ,gradsattendingcollege.Public_FourYear_Percent ,gradsattendingcollege.MA_Community_College_Percent ,gradsattendingcollege.MA_State_University_Percent ,gradsattendingcollege.Univof_Mass_Percent,
graduates.Num_in_Cohort ,graduates.Percent_Graduated ,graduates.Percent_Still_in_School ,graduates.Percent_NonGrad_Completers ,graduates.Percent_GED ,graduates.Percent_Dropped_Out ,graduates.Percent_Permanently_Excluded,
indicators.Retention_Num ,indicators.Retention_Rate ,indicators.Attendance_Rate ,indicators.Average_Num_Absences ,indicators.Absent_10_or_more_days ,indicators.Chronically_Absent_10_percent_or_more ,indicators.Unexcused_9_days,
classsizebygenderpopulation.Total_Num_Classes,classsizebygenderpopulation.Average_Class_Size,classsizebygenderpopulation.Num_Students,classsizebygenderpopulation.Female_Percent,classsizebygenderpopulation.Male_Percent,classsizebygenderpopulation.Limited_English_Proficient_Percent,classsizebygenderpopulation.Special_Education_Percent,classsizebygenderpopulation.Economically_Disadvantaged_Percent
FROM educatorevalperf
JOIN enrollmentbyracegender ON (educatorevalperf.org_code = enrollmentbyracegender.org_code)
JOIN gradsattendingcollege ON (gradsattendingcollege.school_code = enrollmentbyracegender.org_code)
JOIN graduates ON (graduates.orgcode = gradsattendingcollege.school_code)
JOIN indicators ON (indicators.school_code = graduates.orgcode);

CREATE TABLE joined_data_cleansed STORED AS TEXTFILE AS 
SELECT 
REPLACE(School_Name, '"', ''),
substr(trim(REPLACE(School_Name, '"', '')), 1, instr(code,'-')-1) as id, 
substr(trim(REPLACE(School_Name, '"', '')), instr(code,'-')+1) as per
REPLACE(Num_Educators_to_be_Evaluated,'NA',''),REPLACE(Num_Evaluated,'NA|-|NI',''),REPLACE(Percent_Evaluated,'NA',''),REPLACE(Percent_Exemplary,'NA|-|NI',''),REPLACE(Percent_Proficient,'NA|-|NI',''),REPLACE(Percent_Needs_Improvement,'NA|-|NI',''),REPLACE(Percent_Unsatisfactory,'NA|-|NI',''),
African_American ,Asian ,Hispanic ,White ,Native_American ,Native_Hawaiian_Pacific_Islander ,MultiRace_NonHispanic ,Males ,Females,
School_Code ,High_School_Graduates_Num ,Attending_College_Num ,Attending_College_Percent ,Private_TwoYear_Percent ,Private_FourYear_Percent ,Public_TwoYear_Percent ,Public_FourYear_Percent ,MA_Community_College_Percent ,MA_State_University_Percent ,Univof_Mass_Percent,
Num_in_Cohort ,Percent_Graduated ,Percent_Still_in_School ,Percent_NonGrad_Completers ,Percent_GED ,Percent_Dropped_Out ,Percent_Permanently_Excluded,
REPLACE(Retention_Num,'"','') ,Retention_Rate ,Attendance_Rate ,Average_Num_Absences ,Absent_10_or_more_days ,Chronically_Absent_10_percent_or_more ,Unexcused_9_days,
REPLACE(Total_Num_Classes, '"', ''),Average_Class_Size,Num_Students,Female_Percent,Male_Percent,Limited_English_Proficient_Percent,Special_Education_Percent,Economically_Disadvantaged_Percent
FROM Joined_Data
