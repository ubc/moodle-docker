<?php
require('../config.php');
require_once('../login/lib.php');
$login_token = \core\session\manager::get_login_token();
?>

<!DOCTYPE html>
<!--[if IEMobile 7]><html class="iem7 oldie" lang="en"><![endif]-->
<!--[if (IE 7)&!(IEMobile)]><html class="ie7 oldie" lang="en"><![endif]-->
<!--[if (IE 8)&!(IEMobile)]><html class="ie8 oldie" lang="en"><![endif]-->
<!--[if (IE 9)&!(IEMobile)]><html class="ie9" lang="en"><![endif]-->
<!--[[if (gt IE 9)|(gt IEMobile 7)]><!--><html lang="en"><!--<![endif]-->
<!--
 * UBC CLF (Common Look and Feel) v7.0.4
 * Copyright 2012-2013 The University of British Columbia
 * UBC Communications and Marketing
 * https://brand.ubc.ca/clf
 */
-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta charset="utf-8">
<title>Safety & Risk Services | The University of British Columbia</title>
<meta name="viewport" content="width=device-width">
<meta name="description" content="">
<meta name="author" content="">
<link href="https://cdn.ubc.ca/clf/7.0.4/css/ubc-clf-full.min.css" rel="stylesheet">
<!-- Stylesheets -->
<link rel="stylesheet" href="./files/styles.css?v=1.2">
<link rel="icon" href="./files/favicon.png" sizes="16x16" type="image/png">
<!--[if lte IE 7]>
<link href="//cdn.ubc.ca/clf/7.0.4/css/font-awesome-ie7.css" rel="stylesheet">
<![endif]-->
<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
  <script src="//cdn.ubc.ca/clf/html5shiv.min.js"></script>
<![endif]-->

<!-- Fav and touch icons -->
<link rel="shortcut icon" href="https://cdn.ubc.ca/clf/7.0.4/img/favicon.ico">
<link rel="apple-touch-icon-precomposed" sizes="144x144" href="https://cdn.ubc.ca/clf/7.0.4/img/apple-touch-icon-144-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="https://cdn.ubc.ca/clf/7.0.4/img/apple-touch-icon-114-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="https://cdn.ubc.ca/clf/7.0.4/img/apple-touch-icon-72-precomposed.png">
<link rel="apple-touch-icon-precomposed" href="https://cdn.ubc.ca/clf/7.0.4/img/apple-touch-icon-57-precomposed.png">

<script>
function login() {
    document.forms["myForm"].submit();
}
var input = document.getElementById("myInput");
input.addEventListener("keyup", function(event) {
  if (event.keyCode === 13) {
   event.preventDefault();
   document.getElementById("myBtn").click();
  }
});
</script>

</head>
<body>
    <div class="container">
        <!-- UBC Global Utility Menu -->
        <div class="collapse expand" id="ubc7-global-menu">
            <div id="ubc7-search" class="expand">
                <div id="ubc7-search-box">
                    <form class="form-search" method="get" action="https://www.ubc.ca/search/refine/" role="search">
                        <input type="text" name="q" placeholder="Search this website" class="input-xlarge search-query">
                        <input type="hidden" name="label" value="Search UBC" />
                        <input type="hidden" name="site" value="*.ubc.ca" />
                        <button type="submit" class="btn">Search</button>
                    </form>
                </div>
            </div>
            <div id="ubc7-global-header" class="expand">
                <!-- Global Utility Header from CDN -->
            </div>
        </div>
        <!-- End of UBC Global Utility Menu -->
        <!-- UBC Header -->
        <header id="ubc7-header" class="row-fluid expand" role="banner">
            <div class="span1">
                <div id="ubc7-logo">
                    <a href="https://www.ubc.ca">The University of British Columbia</a>
                </div>
            </div>
            <div class="span2">
                <div id="ubc7-apom">
                    <a href="//cdn.ubc.ca/clf/ref/aplaceofmind">UBC - A Place of Mind</a>
                </div>
            </div>
            <div class="span9" id="ubc7-wordmark-block">
                <div id="ubc7-wordmark">
                    <a href="https://www.ubc.ca">The University of British Columbia</a>
                </div>
                <div id="ubc7-global-utility">
                    <button type="button" data-toggle="collapse" data-target="#ubc7-global-menu"><span>UBC Search</span></button>
                    <noscript><a id="ubc7-global-utility-no-script" href="https://www.ubc.ca/">UBC Search</a></noscript>
                </div>
            </div>
        </header>
        <!-- End of UBC Header -->
        <!-- UBC Unit Identifier -->
        <div id="ubc7-unit" class="row-fluid expand">
            <div class="span12">
                <!-- Mobile Menu Icon -->
				<div id="ubc7-unit-name" class="ubc7-single-element"><a href="https://rms.ubc.ca/" title="Risk Management Service"><span id="ubc7-unit-faculty">Risk Management Services</span><span id="ubc7-unit-identifier">Safety & Risk Services</span></a></div>
            </div>
        </div>
        <!-- End of UBC Unit Identifier -->



		<div class="content expand" >
			<div class="expectedTitle">
				<h2>ATTENTION!</h2>
				<br>
				<h4> We are transitioning our learning platform from Moodle to the Workplace Learning Ecosystem.
				<br>Please read carefully below and choose the best option for you.</h4>
				<br>
				<h6 class="supportEmail">If you have questions or need additional support, please contact us at: <a href="mailto:wpl.support@ubc.ca?subject=Support%20SRS%20Course" target="_top">wpl.support@ubc.ca</a></h6>
			</div>
			<div class="expectedContent">
				<div class="e1">
					<a href="#moodleanchor">
					<img src="./files/Moodle.png" alt="Moodle">
					<p>Click here if</p>
					<div class="description">
						<ul>
							<li>You enrolled in a course before April 15th, 2020, and have not yet completed it, or</li>
							<li>You would like to access a course completion record (certificate) for a course you completed prior to April 15th, 2020</li>
						</ul>
					</div>
					</a>
				</div>
				<div class="e2">
					<a href="https://wpl.ubc.ca/">
					<img src="./files/WPL.png" alt="Workplace Learning Ecosystem">
					<p>Click here if</p>
					<div class="description">
						<ul>
							<li>You are a UBC employee, student or contractor with a CWL and,</li>
							<li>You want to enroll in a course or,</li>
							<li>You enrolled in a course on or after April 15th, 2020, or,</li>
							<li>You would like to access a course completion record (certificate) for a course you completed on or after April 15th, 2020</li>
						</ul>
					</div>
					</a>
				</div>
				<div class="e3">
					<a href="https://courses.cpe.ubc.ca/browse/wpl/srs-external">
					<img src="./files/Non-UBC.png" alt="Non-UBC">
					<p>Click here if</p>
					<div class="description">
						<ul>
							<li>You are not a UBC employee, student or contractor and</li>
							<li>You want to enroll in a course or,</li>
							<li>You enrolled in a course on or after April 15th, 2020, or,</li>
							<li>You would like to access a course completion record (certificate) for a course you 	completed on or after April 15th, 2020</li>
						</ul>
					</div>
				</div>
					</a>
			</div>
			<br>
			<br>
			<br>
			<br>
			<br>
		</div>


        <!-- Content Area -->
        <div class="content expand" role="main" id="moodleanchor">
			<div class="maintable container">
				<div class="center" style="width:100%; padding-top:20px; padding-bottom:20px;">
					<div class="col rightborder">
						<div class="center l">
							<img src="./files/ubc-logo-2018-crest-blue-rgb300.png" alt="" width="100" height="136" />
						</div>
						<div class="center l">
							UBC faculty, staff, and students with a CWL:
						</div>
						<div class="center">
							<a href="/auth/shibboleth/index.php">
								<img src="./files/cwl_login.png" alt="" width="83" height="35" />
							</a>
						</div>
					</div>
					<div class="col">
						<div class="center l">
							<h4>Login for Existing Non-CWL Moodle Account Users:</h4>
						</div>
						<?php
						if (optional_param('errorcode', 0, PARAM_INT) == 3) {
							echo '<div class="error_msg">The Username and/or Password entered is invalid, please try again.</div></br>';}
						?>
						<div class="center l" style=" line-height:2.5;">
							<table class="center l" border="0">
								<form name="myForm" action="/login/index.php" method="post">
								<input type="hidden" name="logintoken" value="<?php echo $login_token;?>" />
								<tr><td>Username:</td><td><input type="text" name="username"></td></tr>
								<tr><td>Password:</td><td><input id="passwordBox" type="password" name="password"></td></tr>
							</table>
							<div><input id="loginButton" type="button" onclick="login()" value="Login"></div>
							<div><a href="/login/forgot_password.php">Forgotten your username or password?</a></div>
							<div style="height:60px; vertical-align:middle;">
								Cookies must be enabled in your browser
							</div>
							<div class="center howtotext">
								<div class="center l">
									<h4>Create Moodle Account for non-CWL Users:</h4>
									<input id="crateAccount" type="button" onclick="location.href='/login/signup.php'" value="Create Moodle Account (non-CWL)">
								</div>
								<p>You will need to confirm your account by clicking on the link sent to your email address</p>
						</div>
					</div>
				</div>
			</div>
		</div>

        <!-- End of Footer Area Unit Menu -->
        <footer id="ubc7-footer" class="expand" role="contentinfo">
            <div class="row-fluid expand" id="ubc7-unit-footer">
                <div class="span10" id="ubc7-unit-address">
                    <div id="ubc7-address-unit-name">Safety & Risk Services</div>
                    <div id="ubc7-address-campus">Donald Rix Building (TEF 2)</div>
                    <div id="ubc7-address-street">#336 – 2389 Health Sciences Mall</div>
                    <div id="ubc7-address-location">
                        <span id="ubc7-address-city">Vancouver</span>, <span id="ubc7-address-province">BC</span> <span id="ubc7-address-country">Canada</span> <span id="ubc7-address-postal">V6T 1Z3</span>
                    </div>
                    <div id="ubc7-address-phone">Tel 604 822 2029</div>
                    <div id="ubc7-address-email">E-mail <a href="mailto:safety.training@ubc.ca">safety.training@ubc.ca</a></div>
                </div>
                <div class="span2">
                </div>
            </div>
            <div class="row-fluid expand ubc7-back-to-top">
                <div class="span2">
                    <a href="#">Back to top <div class="ubc7-arrow up-arrow grey"></div></a>
                </div>
            </div>
            <div class="row-fluid expand" id="ubc7-global-footer">
                <div class="span5" id="ubc7-signature"><a href="https://www.ubc.ca/">The University of British Columbia</a></div>
                <div class="span7" id="ubc7-footer-menu">
                </div>
            </div>
            <div class="row-fluid expand" id="ubc7-minimal-footer">
                <div class="span12">
                    <ul>
                        <li><a href="//cdn.ubc.ca/clf/ref/emergency">Emergency Procedures</a> <span class="divider">|</span></li>
                        <li><a href="//cdn.ubc.ca/clf/ref/terms">Terms of Use</a> <span class="divider">|</span></li>
                        <li><a href="//cdn.ubc.ca/clf/ref/copyright">Copyright</a> <span class="divider">|</span></li>
                        <li><a href="//cdn.ubc.ca/clf/ref/accessibility">Accessibility</a></li>
                    </ul>
                </div>
            </div>
        </footer>
    </div> <!-- /container -->
    <!-- Placed javascript at the end for faster loading -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
	<script src="https://cdn.ubc.ca/clf/7.0.4/js/ubc-clf.min.js"></script>
	<script>
		var input = document.getElementById("passwordBox");
		input.addEventListener("keyup", function(event) {
		  if (event.keyCode === 13) {
		   event.preventDefault();
		   document.getElementById("loginButton").click();
		  }
		});
	</script>
	</body>
</html>