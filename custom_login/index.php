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
 * http://brand.ubc.ca/clf
 */
-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta charset="utf-8">
<title>Safety and Risk Services | The University of British Columbia</title>
<meta name="viewport" content="width=device-width">
<meta name="description" content="">
<meta name="author" content="">
<link href="https://cdn.ubc.ca/clf/7.0.4/css/ubc-clf-full.min.css" rel="stylesheet">
<!-- Stylesheets -->
<link rel="stylesheet" href="./files/styles.css?v=1.1">
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
                    <form class="form-search" method="get" action="http://www.ubc.ca/search/refine/" role="search">
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
                    <a href="http://www.ubc.ca">The University of British Columbia</a>
                </div>
            </div>
            <div class="span2">
                <div id="ubc7-apom">
                    <a href="//cdn.ubc.ca/clf/ref/aplaceofmind">UBC - A Place of Mind</a>
                </div>
            </div>
            <div class="span9" id="ubc7-wordmark-block">
                <div id="ubc7-wordmark">
                    <a href="http://www.ubc.ca">The University of British Columbia</a>
                </div>
                <div id="ubc7-global-utility">
                    <button type="button" data-toggle="collapse" data-target="#ubc7-global-menu"><span>UBC Search</span></button>
                    <noscript><a id="ubc7-global-utility-no-script" href="http://www.ubc.ca/">UBC Search</a></noscript>
                </div>
            </div>
        </header>
        <!-- End of UBC Header -->
        <!-- UBC Unit Identifier -->
        <div id="ubc7-unit" class="row-fluid expand">
            <div class="span12">
                <!-- Mobile Menu Icon -->
				<div id="ubc7-unit-name" class="ubc7-single-element"><a href="https://rms.ubc.ca/" title="Risk Management Service"><span id="ubc7-unit-faculty">Safety and Risk Services</span><span id="ubc7-unit-identifier">Safety and Risk Services</span></a></div>
            </div>
        </div>
        <!-- End of UBC Unit Identifier -->


        <!-- Content Area -->
        <div class="content expand" role="main">
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
							<h4>Non-UBC users with an account:</h4>
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
							<div class="center l">
								<h4>Create non-CWL account</h4>
							</div>
							<div class="center howtotext">
								<p>Hi! For full access to courses you'll need to take a minute to create a new account for yourself on this web site. Here are the steps:</p>
								<ol>
									<li>Fill out the New Account form with your details.</li>
									<li>An email will be immediately sent to your email address.</li>
									<li>Read your email, and click on the web link it contains.</li>
									<li>Your account will be confirmed and you will be logged in.</li>
									<li>Now, select the course you want to participate in.</li>
								<li>If you are prompted for an "enrolment key" - use the one that your teacher has given you. This will "enrol" you in the course.</li>
								<li>You can now access the full course. From now on you will only need to enter your personal username and password (in the form on this page) to log in and access any course you have enrolled in.</li>
								</ol>
								<div class="center l">
									<input id="crateAccount" type="button" onclick="location.href='/login/signup.php'" value="Create new (non-CWL) account">
								</div>
						</div>
					</div>
				</div>
			</div>
		</div>

        <!-- End of Footer Area Unit Menu -->
        <footer id="ubc7-footer" class="expand" role="contentinfo">
            <div class="row-fluid expand" id="ubc7-unit-footer">
                <div class="span10" id="ubc7-unit-address">
                    <div id="ubc7-address-unit-name">Risk Management Services</div>
                    <div id="ubc7-address-campus">Donald Rix Building (TEF 2)</div>
                    <div id="ubc7-address-street">#336 – 2389 Health Sciences Mall</div>
                    <div id="ubc7-address-location">
                        <span id="ubc7-address-city">Vancouver</span>, <span id="ubc7-address-province">BC</span> <span id="ubc7-address-country">Canada</span> <span id="ubc7-address-postal">V6T 1Z3</span>
                    </div>
                    <div id="ubc7-address-phone">Tel 604 822 2029</div>
                    <div id="ubc7-address-email">E-mail <a href="mailto:rms.training@ubc.ca">rms.training@ubc.ca</a></div>
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
                <div class="span5" id="ubc7-signature"><a href="http://www.ubc.ca/">The University of British Columbia</a></div>
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
