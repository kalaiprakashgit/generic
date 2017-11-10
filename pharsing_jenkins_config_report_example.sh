#!/bin/bash
#*******************************************************************************************
#This script is to collect the list of jenkins jobs and name of its authorization project
#Developed by Prakash kalaiarasu
#Last modified by Prakash
#Date
#*******************************************************************************************
#Initialization of variables

JENKINS_HOME=/opt/jenkins/jenhome
JOB_DIR=$JENKINS_HOME/jobs
JENKINS_URL="https://jenkins.net/jenkins/job"
FILENAME=/home/jenadmin/script/listfind.txt
TMP_FILE=$HOME/tmp1.txt
PROJ_MAP=$HOME/projid_mapping.csv
JOB_PROJ_REPORT_RAW=$HOME/prod_job_proj_report.csv
JOB_PROJ_NC_REPORT_RAW=$HOME/prod_job_proj_nc_report.csv
NCJOBREPORT=$HOME/ncauthjobreport_proddev.html
DATE=`date +"%x"`
MAIL_BODY=$HOME/body.txt
JENKINS_SERVER="https://jenkins.net"
SUBJECT="NON-COMPLIANCE JENKINS_PRODDEV AUTHORTIZATION REPORT_$DATE"
TO_ADDRESS="test@gmail.com"
FILENAME=/home/jenadmin/script/listfind.txt
FOLDER_LIST=$HOME/folderlist.txt

# FIle initialization
echo "" > $FOLDER_LIST
rm $FOLDER_LIST $JOB_PROJ_REPORT_RAW $JOB_PROJ_NC_REPORT_RAW
cd $JOB_DIR

# Generate config file list and initialize report
find . -name config.xml > $FILENAME

# separate Job configuration and Folder configuration
while IFS= read line
do
FOLDERFACT=`grep -c com.cloudbees.hudson.plugins.folder.Folder "$line"`

    echo $FOLDERFACT > folderfact.txt
    if [ $FOLDERFACT -eq 0 ]
     then
        grep projectId "$line" > $TMP_FILE
        sed 's/<[^>]*>//g' $TMP_FILE > $HOME/AUTH_PROJECT_ID
        sed -i -e 's/^[ \t]*//' -e 's/[ \t]*$//' $HOME/AUTH_PROJECT_ID
        PROJ_ID=`cat $HOME/AUTH_PROJECT_ID`
        JOB_NAME=`echo -n $line | rev | cut -d '/' -f2 | rev`  
        JOBPATH=`echo -n $line | sed 's/^.//'`
        JENKINS_JOBCONF=$JENKINS_URL$JOBPATH
        JENKINS_JOB_URL="${JENKINS_JOBCONF/config.xml/configure}"
        if [ -n "$PROJ_ID" ]
          then
           PROJ_ID=`grep $PROJ_ID $PROJ_MAP | cut -d ',' -f2`
           echo "$JOB_NAME,$PROJ_ID,$JENKINS_JOB_URL"
           echo "$JOB_NAME,$PROJ_ID,$JENKINS_JOB_URL" >> $JOB_PROJ_REPORT_RAW
          else
           PROJ_ID=NOT_EXISTS
           echo "$JOB_NAME,$PROJ_ID,$JENKINS_JOB_URL"
           echo "$JOB_NAME,$PROJ_ID,$JENKINS_JOB_URL" >> $JOB_PROJ_NC_REPORT_RAW
        fi
     else
        echo "the folder name is $line" >> $FOLDER_LIST
    fi
done < $FILENAME

#Archive and Notif the report as an attachement
cp $JOB_PROJ_REPORT_RAW $JOB_DIR/Jenkins_Project_Auth_Report/workspace
cp $JOB_PROJ_NC_REPORT_RAW $JOB_DIR/Jenkins_Project_Auth_Report/workspace


#REPORT GENERATE FOR NON_COMPLAIANCE
#echo "JOB_NAME,PROJECT_ID" > $JOB_PROJ_REPORT_RAW
echo "<html>" > $NCJOBREPORT
echo "<head>" >> $NCJOBREPORT
echo "<title> BUILD JOBS AUTHORIZATION REPORT </title>" >> $NCJOBREPORT
echo "<font size="2" face="arial" color="red" > " >> $NCJOBREPORT
echo "<h1 align='center'> <u><b>BUILD JOBS AUTHORIZATION REPORT - NON COMPLIANCE</b></u></h1> " >> $NCJOBREPORT
echo "</font> " >> $NCJOBREPORT
echo "</head>" >> $NCJOBREPORT
echo "<body text='#000000' bgcolor='#FAFAFA' link='#0000EE' vlink='#551A8B' alink='#FF0000' style='margin-left : 2em;'> " >> $NCJOBREPORT
echo "<h2> Server : <a href=""http://Jenkins.net"">http://Jenkins.net </a> </h2>"  >> $NCJOBREPORT
        echo "<h3> Date   : $DATE </h3> " >> $NCJOBREPORT
echo "<table border="1"> " >> $NCJOBREPORT
echo "<tr bgcolor='#FF0000' >" >> $NCJOBREPORT
echo "<th> BUILD JOB NAME </th> " >> $NCJOBREPORT
echo "<th>PROJECT_ID CONFIGURATION</th> " >> $NCJOBREPORT
echo "</tr> " >> $NCJOBREPORT
echo "<tr> " >> $NCJOBREPORT


#Generating the HTML report table

while read jobdetail
 do
   jobname=`echo $jobdetail | cut -d ',' -f1`
   url=`echo $jobdetail | cut -d ',' -f3` 
   prj=`echo $jobdetail | cut -d ',' -f2` 
   echo "<td><a href='$url'>$jobname</a></td> " >> $NCJOBREPORT
   echo "<td>$prj</td> " >> $NCJOBREPORT
   echo "</tr> " >> $NCJOBREPORT
done < $JOB_PROJ_NC_REPORT_RAW



# Closing the table
echo "</table> " >> $NCJOBREPORT
echo "<p>Please validate and configure with correct ProjectID for the above non-compliance.</p>

<p>Questions?  Concerns?  Please contact the Services Team (Tools Services).</p>
<p>Thank you</p>
<p>The Services Team</p> " >> $NCJOBREPORT
echo "</body></html>" >> $NCJOBREPORT
echo "</body></html>" >> $NCJOBREPORT

#Mail Report
MAILSTATUS=`grep td $NCJOBREPORT`
if [ -n "$MAILSTATUS" ]
   then
(
 echo "Subject: $SUBJECT"
 echo "MIME-Version: 1.0"
 echo "Content-Type: text/html"
 echo "Content-Disposition: inline"
 cat $NCJOBREPORT
) | /usr/sbin/sendmail -f test@gmail.com  $TO_ADDRESS
 cp $JOB_PROJ_NC_REPORT_RAW $JOB_DIR/Jenkins_Project_Auth_Report/workspace
   else
          echo "There is no  NC " ;
   fi


