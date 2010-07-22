<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<!--
Copyright: Darren Hester 2006, http://www.designsbydarren.com
License: Released Under the "Creative Commons License", 
http://creativecommons.org/licenses/by-nc/2.5/
-->

<head>

<!-- Meta Data -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="description" content="NutchEz Management" />
<meta name="keywords" content="nutch, nutchEz, cloud computing, Hadoop, search engine" />
<meta name="author" content="Waue(waue@nchc.org.tw), Shunfa(shunfa@nchc.org.tw) , Rock(rock@nchc.org.tw)" />


<!-- Site Title -->
<title>NutchEZ&#32178;&#38913;&#31649;&#29702;&#31995;&#32113;</title>

<!-- Link to Style External Sheet -->
<!-- CSS -->
<link href="css/style.css" type="text/css" rel="stylesheet" />
<link rel=stylesheet type="text/css" href="css/Crawl.css" /> 
<!-- javaScript -->
<script type="text/javascript" src="crawl.js"></script>
</head>

<body>

<div id="page_wrapper">

<div id="header_wrapper">

<div id="header">

<h1>NutchEZ&#32178;&#38913;&#31649;&#29702;&#20171;&#38754;</h1>


</div>

<div id="navcontainer">
<ul id="navlist">
<li><a href="index.jsp">HOME</a></li>
<li id="active"><a href="crawl.jsp" id="current">Crawl</a></li>
<li id="active"><a href="nutch_DB.jsp" >&#36039;&#26009;&#24235;&#31649;&#29702;</a></li>
<li><a href="Statistics.do">&#36039;&#26009;&#24235;&#32113;&#35336;</a></li>
<li><a href="sysinfo.jsp">&#31995;&#32113;&#29376;&#24907;</a></li>
<% if(session.getAttribute("confirm") == "true") { %>
<li><a href="logout.jsp">&#30331;&#20986;&#31995;&#32113;</a></li>
<%} else { %>	
<li><a href="adminLogin.jsp">&#31649;&#29702;&#32773;&#30331;&#20837;</a></li>
<% } %>


</ul>
</div>

</div>
<div id="right_side">
  <h3>&#30456;&#38364;&#36039;&#28304;</h3>
  <p>* NutchEZ&#23560;&#26696;&#32178;&#22336;</p>
  <p>* &#32218;&#19978;&#25903;&#25588;</p>
</div>
<div id="content">
<h3>Crawl</h3>
<% 
    String loginFormURL = 
               "adminLogin.jsp";  
    if(session.getAttribute("confirm") == "true") { %>
<div class='featurebox_center'>
	<form method="post" action="Crawl.do">
		<fieldset onmousemove="nuHiddlen()" onmouseout="hiddlen()">
		<legend>How To Use ?</legend>
		<ol id="how_to" class="hiddlen">
			<li><span class="redfont">Input DataBase Name</span></li>
			<li><span class="redfont">Input URLs (see below example)</span><br /> <img src="img/crawl_file.png" alt="crawl_file.png" /></li>
			<li><span class="redfont">Choose Depth, then Submit !</span></li>
		</ol>
		</fieldset>
		<br />
	
		<fieldset>
		<legend>DataBase Name</legend>
		<label for="id_crawl_db">Input DataBase Name of this Crawl: </label>
		<input type="text" class="haha" id="id_crawl_db" name="name_crawl_db"></input>
		</fieldset>
		<br />
	
		<fieldset>
		<legend>Crawl URL Setup</legend>
		<label for="id_crawl_url">Input Crawl URLs: </label>
		<textarea class="haha" id="id_crawl_url" name="name_crawl_url" rows="7" cols="50"></textarea>
		</fieldset>
		<br />
		
		<fieldset title="Crawl Depth Setup">
		<legend>Crawl Depth Setup</legend>
			<label for="id_crawl_depth">Choose Crawl Depth </label>
			<select size="1" id="id_crawl_depth" name="name_crawl_depth">
				<option>1</option>
				<option>2</option>
				<option>3</option>
				<option>4</option>
				<option>5</option>
				<option>6</option>
				<option>7</option>
				<option>8</option>
				<option>9</option>
				<option>10</option>
			</select><br />
		</fieldset>
		<input type="submit" value="Submit" name="Submit" onmouseover="check_null()">
		<input type="reset" value="Reset" name="Rset">
	</form>

        
    <% } 
    else {
		response.setHeader("Refresh", "3; URL=" + loginFormURL); %>
        <div class='featurebox_center'>&#31995;&#32113;&#31649;&#29702;&#21729;&#23578;&#26410;&#30331;&#20837;&#65292;&#31995;&#32113;&#23559;&#26044;3&#31186;&#24460;&#36339;&#36681;&#33267;&#30331;&#20837;&#38913;&#38754;(<a href="adminLogin.jsp">&#33509;&#28961;&#36339;&#36681;&#35531;&#25353;&#27492;</a>)</div>        
    	<% } %>
	
<!-- //logout 
//session.invalidate(); --> 
</div>
<!-- <div class='featurebox_center'>some information here...</div> -->
<p>&nbsp;</p>
<p>&nbsp;</p>
</div>

<div id="footer">
copyright &copy; 2010 Free Software Lab@NCHC 
<br />
Template provided by: 
<a href="http://www.designsbydarren.com" target="_blank">DesignsByDarren.com</a>
</div>

</div>

</body>

</html>