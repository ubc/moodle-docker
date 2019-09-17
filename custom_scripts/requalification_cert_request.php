<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<!--
UBC Web Common Look and Feel v. 6.0
UBC Public Affairs
t: 604.822.2130
e: web.admin@ubc.ca
w: www.webcommunications.ubc.ca
-->
<head>
<title>RMS Course System</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link href="/_ubc_clf/css/clf-required-fixedwidth.css" type="text/css" media="screen" rel="Stylesheet" />
<link href="/_ubc_clf/css/clf-typography.css" type="text/css" media="screen" rel="Stylesheet" />
<link rel="stylesheet" type="text/css" href="tank_styles.css">
<!--[if lte IE 7]>
<link href="/_ubc_clf/css/ie.css" type="text/css" media="screen" rel="Stylesheet" />
<![endif]-->
<script src="/_ubc_clf/js/jquery-1.3.2.min.js" type="text/javascript"></script>
<!--
<script type="text/javascript" src="http://www.google.com/jsapi?key=ABQIAAAAoRs91XgpKw60K4liNrOHoBStNMhZCa0lqZKLUDgzjZGRsKl38xSnSmVmaulnWVdBLItzW4KsddHCzA"></script>
-->
<script src="/_ubc_clf/js/config.js" type="text/javascript"></script>
<script src="/_ubc_clf/js/main.js" type="text/javascript"></script>
<link rel="icon" type="image/vnd.microsoft.icon" href="/_ubc_clf/img/favicon.ico" />

<script>
window.onload = function()
	{
		//alert("An email has been sent to the instructor of the course, they will verify that you have indeed completed this course in the past. Once they have done this, they will release your certificate which will become available at the bottom of this course's page. They will email you when the certificate has been released.");

	};
</script>


</head>
<body>

<!-- BEGIN: UBC CLF CONTENT SPACE -->

<div id="UbcContent" class="UbcContainer">

<script type="text/javascript" src="sha512.js"></script>
<script type="text/javascript" src="forms.js"></script>

<?php
require_once('config.php');
require_once('lib/moodlelib.php');

$course_id = $_GET['course_id'];
$full_name = $_GET['full_name'];
$email = $_GET['email'];
$user_id = $_GET['user_id'];
$course_name = $_GET['course_name'];
$course_shortname = $_GET['course_shortname'];

$PAGE->set_context(context_course::instance($course_id));
?>

<h2 class="UbcHeadline"><?php echo($course_name . " Requalification Certificate Request")?></h2>
An email has been sent to the instructor of the course, they will verify that you have indeed completed this course in the past. Once they have done this, they will release your certificate which will become available at the bottom of this course's page. They will email you when the certificate has been released.<br><br>

<?php

echo "<a target='_parent' href='/course/view.php?id=" . $course_id . "'>Click here to return to the " . $course_name . " page</a>.";

$mapping = array(
    'RadSafety' => array('to' => 'safety.training@ubc.ca', 'subject' => 'Radiation Safety Completion Certificate'),
    'Old ChemSafety' => array('to' => 'safety.training@ubc.ca', 'subject' => 'Chemical Safety Completion Certificate'),
    'Chemsafe' => array('to' => 'safety.training@ubc.ca', 'subject' => 'Chemical Safety Completion Certificate'),
    'OldBioSafety' => array('to' => 'safety.training@ubc.ca', 'subject' => 'Biological Safety Completion Certificate'),
    'BioSafety' => array('to' => 'safety.training@ubc.ca', 'subject' => 'Biological Safety Completion Certificate'),
);

if (array_key_exists($course_shortname, $mapping)) {
    $to = $mapping[$course_shortname]['to'];
    $subject = $mapping[$course_shortname]['subject'];
}else{
    $to = "rms.training@ubc.ca";
    $subject= $course_name . " Completion Certificate";
}

$message="A student has completed the " . $course_name . " and has indicated that they have completed this course before. Please check your records for their name to ensure they have actually completed this course before. If they have completed the course in the past, give them a grade of 100% in the requalification column of the gradebook on Moodle - this will release their certificate at the bottom of the course page. Please email the student to let them know how to obtain their certificate.\r\n\r\nYou can find the records from Vista here: S:\Occupational and Research Safety\Shared\Courses\Vista Student Data Backup \r\n\r\n";
$message.="Student's Name: " . $full_name . "\r\n";
$message.="Student's Email: " . $email . "\r\n\r\n";
$message.="EXAMPLE EMAIL TO STUDENT\r\n";
$message.="Hi " . $full_name . ",\r\n\r\n";
$message.="This email is to inform you that your certificate for the " . $course_name . " has been released, you can access it by logging into the RMS course system (https://www.hse2.ubc.ca/). The certificate will be available at the bottom of the course page.\r\n\r\n";
$message.="Thanks,\r\n\r\n\r\n";
$message.="The RMS Team";

//$headers .= "Content-type: text/html\r\n"; //Only used if html
#mail($to,$subject,$message,$headers);

$toUser = new stdClass();
$toUser->id = 99999;
$toUser->firstname = '';
$toUser->lastname = '';
$toUser->username = 'admin';
$toUser->email = $to;
$toUser->maildisplay = 2;
$toUser->alternatename = "";
$toUser->firstnamephonetic = "";
$toUser->lastnamephonetic = "";
$toUser->middlename = "";

$noreplyUser = new stdClass();
$noreplyUser->id = 99999;
$noreplyUser->firstname = 'RMS Moodle';
$noreplyUser->lastname = 'Administrator';
$noreplyUser->username = 'admin';
$noreplyUser->email = 'moodle_no_reply@ubc.ca';
$noreplyUser->maildisplay = 2;
$noreplyUser->alternatename = "";
$noreplyUser->firstnamephonetic = "";
$noreplyUser->lastnamephonetic = "";
$noreplyUser->middlename = "";

$success = email_to_user($toUser, $noreplyUser, $subject, $message);

?>

<br /><br /><span style="font-size: 10px">message sent: <?php echo $success; ?></span>


</div><!-- End UbcContent UbcContainer -->

<!-- END: UBC CLF CONTENT SPACE -->

</body>
</html>

