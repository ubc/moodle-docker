<?php

// This file is part of the Certificate module for Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * A4_embedded certificate type
 *
 * @package    mod
 * @subpackage certificate
 * @copyright  Mark Nelson <markn@moodle.com>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

if (!defined('MOODLE_INTERNAL')) {
    die('Direct access to this script is forbidden.'); // It must be included from view.php
}

$pdf = new PDF($certificate->orientation, 'mm', 'A4', true, 'UTF-8', false);

$pdf->SetTitle($certificate->name);
$pdf->SetProtection(array('modify'));
$pdf->setPrintHeader(false);
$pdf->setPrintFooter(false);
$pdf->SetAutoPageBreak(false, 0);
$pdf->AddPage();

// Define variables
// Landscape
if ($certificate->orientation == 'L') {
    $x = 30;
    $y = 5;
    $sealx = 33;
    $sealy = 103;
    $sigx = 45;
    $sigy = 127;
    $custx = 47;
    $custy = 155;
    $wmarkx = 40;
    $wmarky = 31;
    $wmarkw = 212;
    $wmarkh = 148;
    $brdrx = 0;
    $brdry = 0;
    $brdrw = 297;
    $brdrh = 210;
    $codey = 195;
} else { // Portrait
    $x = 10;
    $y = 40;
    $sealx = 150;
    $sealy = 220;
    $sigx = 30;
    $sigy = 230;
    $custx = 30;
    $custy = 230;
    $wmarkx = 26;
    $wmarky = 58;
    $wmarkw = 158;
    $wmarkh = 170;
    $brdrx = 0;
    $brdry = 0;
    $brdrw = 210;
    $brdrh = 297;
    $codey = 250;
}

//Determine which signatures belong on this certificate
//	if InStr(LCase(coursename), "radionuclide safety") > 0 OR InStr(LCase(coursename), "radiation safety") > 0 then
//		$certitype = "RA"
//		$coursename = "Radionuclide Safety and Methodology"
//		$coursedetailmsg = "Including Receiving Class 7 Dangerous Goods"
//		$coursecompletionmsg = "has successfully completed the Canadian Nuclear Safety Commission requirements in"
//		$instructor_name = "Ted Sedgwick"
//		$second_name = "Rosemary Redfield"
//	elseif InStr(LCase(coursename), "receiving class 7") > 0 OR InStr(LCase(coursename), "receiving") > 0 then
//		$certitype = "RC7"
//		$coursename = "Receiving Class 7 Dangerous Goods"
//		$coursecompletionmsg = "has completed the Transport Canada and Canadian Nuclear Safety Commission requirements in"
//		$instructor_name = "Ted Sedgwick"
//		$second_name = "Rosemary Redfield"
//	elseif InStr(LCase(coursename), "biological safety") > 0 OR InStr(LCase(coursename), "biosafety") > 0 then
//		$certitype = "LB"
//		$coursename = "RMS Laboratory Biological Safety Course"
//		$coursecompletionmsg = "has successfully completed"
//		$instructor_name = "Stephanie Thomson"
//		$second_name = "Bruce Anderson"
//	elseif InStr(LCase(coursename), "chemical safety") > 0 OR InStr(LCase(coursename), "chemsafety") > 0 then
//		$certitype = "CS"
//		$coursename = "RMS Laboratory Chemical Safety Course"
//		$coursedetailmsg = "Including WHMIS"
//		$coursecompletionmsg = "has successfully completed"
//		$instructor_name = "Sonny Dhasi"
//		$second_name = "Bruce Anderson"
//	elseif InStr(LCase(coursename), "floor warden") > 0 then
//		$certitype = "FW"
//		$coursename = "RMS Floor Warden Training Course"
//		$coursecompletionmsg = "has successfully completed the"
//		$instructor_name = "Paul Nakagawa"
//		$second_name = "Bruce Anderson"
//	else
//		$coursecompletionmsg = "has successfully completed"
//	end if
//
//	//Now assign job titles and signatures to the professors and second names
//	If instructor_name = "Ted Sedgwick" Then
//		$instructorsign = "TedSedgwick.jpg"
//		$instructortitle = "RMS Radiation Safety Advisor"
//	End If
//
//	If second_name = "Rosemary Redfield" Then
//		$second_name_sign = "RosemaryRedfield.gif"
//		$second_name_title = "Chair, Advisory Committee on Radioisotopes and Radiation Hazards"
//	End If
//
//	If instructor_name = "Stephanie Thomson" Then
//		$instructorsign = "Thomson.jpg"
//		$instructortitle = "RMS Biosafety Advisor"
//	End If

//	If second_name = "Bruce Anderson" Then
//		$second_name_sign = "BruceAnderson.gif"
//		$second_name_title = "Director, Occupational and Research Safety"
//	End If

//	If instructor_name = "Sonny Dhasi" Then
//		$instructorsign = "SonnyDhasi.gif"
//		$instructortitle = "Occupational Hygiene Associate"
//	End If

//	If instructor_name = "Paul Nakagawa" Then
//		$instructorsign = "Nakagawa2.jpg"
//		$instructortitle = "Safety Program Advisor"
//	End If

//	If instructor_name = "Calvin Cheung" Then
//		$instructorsign = "CalvinCheung.gif"
//		$instructortitle = "Emergency and Continuity Planner"
//	End If

//	If second_name = "Paul Nakagawa" Then
//		$second_name_sign = "Nakagawa.jpg"
//		$second_name_title = "Safety Program Advisor"
//	End If

//	If second_name = "Calvin Cheung" Then
//		$second_name_sign = "CalvinCheung.gif"
//		$second_name_title = "Emergency and Continuity Planner"
//	End If

//If ($instructor_name == "Paul Nakagawa") {
//	$instructorsign = "Nakagawa2.jpg";
//	$instructortitle = "Safety Program Advisor";
//}

// Add images and lines
certificate_print_image($pdf, $certificate, CERT_IMAGE_BORDER, $brdrx, $brdry, $brdrw, $brdrh);
certificate_draw_frame($pdf, $certificate);
// Set alpha to semi-transparency
$pdf->SetAlpha(0.2);
certificate_print_image($pdf, $certificate, CERT_IMAGE_WATERMARK, $wmarkx, $wmarky, $wmarkw, $wmarkh);
$pdf->SetAlpha(1);
certificate_print_image($pdf, $certificate, CERT_IMAGE_SEAL, $sealx, $sealy, '', '');
certificate_print_image($pdf, $certificate, CERT_IMAGE_SIGNATURE, $sigx, $sigy, '', '');

// Add text
$pdf->SetTextColor(0, 0, 120);
//certificate_print_text($pdf, $x, $y, 'C', 'freesans', '', 30, get_string('title', 'certificate'));
$pdf->SetTextColor(0, 51, 104);

certificate_print_text($pdf, $x, $y + 20, 'C', 'freesans', 'B', 40, $course->fullname);

#certificate_print_text($pdf, $x, $y + 20, 'C', 'freeserif', '', 20, get_string('certify', 'certificate'));
certificate_print_text($pdf, $x + 5, $y + 60, 'L', 'freesans', '', 24, "Name: " . fullname($USER));
certificate_print_text($pdf, $x + 5, $y + 72, 'L', 'freesans', '', 24, "Employer Address: ___________________________________ ");
certificate_print_text($pdf, $x + 5, $y + 86, 'L', 'freesans', '', 18, "This person has sound knowledge of the following topics: ");


certificate_print_text($pdf, $x + 18, $y + 140, 'L', 'freesans', '', 18, "____________________________");
certificate_print_text($pdf, $x + 36, $y + 150, 'L', 'freesans', '', 18, "Employee's Signature");

certificate_print_text($pdf, $x + 143, $y + 140, 'L', 'freesans', '', 18, "____________________________");
certificate_print_text($pdf, $x + 163, $y + 150, 'L', 'freesans', '', 18, "Employer's Signature");

//certificate_print_text($pdf, $x, $y + 40, 'C', 'freesans', '', 20, get_string('statement', 'certificate'));

$completion_date = certificate_get_date($certificate, $certrecord, $course);
$expiry_date_ground = date('F j, Y', strtotime('+3 year', strtotime($completion_date)) );
$expiry_date_air = date('F j, Y', strtotime('+2 year', strtotime($completion_date)) );

certificate_print_text($pdf, 35, $y + 170, 'L', 'freesans', '', 18,  "Course Completion Date: " . certificate_get_date($certificate, $certrecord, $course));
certificate_print_text($pdf, 35, $y + 180, 'L', 'freesans', '', 18,  "Expires on (ground): " . $expiry_date_ground);
certificate_print_text($pdf, 35, $y + 190, 'L', 'freesans', '', 18,  "Expires on (air): " . $expiry_date_air);

/*
certificate_print_text($pdf, 45, $y + 160, 'L', 'freesans', '', 14,  "Certificate ID: " . $certificate_code_additional . certificate_get_code($certificate, $certrecord));
certificate_print_text($pdf, $x, $y + 102, 'C', 'freeserif', '', 10, certificate_get_grade($certificate, $course));
certificate_print_text($pdf, $x, $y + 112, 'C', 'freeserif', '', 10, certificate_get_outcome($certificate, $course));
*/

if ($certificate->printhours) {
    certificate_print_text($pdf, $x, $y + 122, 'C', 'freeserif', '', 10, get_string('credithours', 'certificate') . ': ' . $certificate->printhours);
}
$i = 0;
if ($certificate->printteacher) {
    $context = context_module::instance($cm->id);
    if ($teachers = get_users_by_capability($context, 'mod/certificate:printteacher', '', $sort = 'u.lastname ASC', '', '', '', '', false)) {
        foreach ($teachers as $teacher) {
            $i++;
            certificate_print_text($pdf, $sigx, $sigy + ($i * 4), 'L', 'freeserif', '', 12, fullname($teacher));
        }
    }
}

//certificate_print_text($pdf, $custx, $custy, 'L', null, null, null, $certificate->customtext);
?>
