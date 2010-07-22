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
<link href="css/style.css" type="text/css" rel="stylesheet" />

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
<li><a href="crawl.jsp">Crawl</a></li>
<li id="active"><a href="nutch_DB.jsp" >&#36039;&#26009;&#24235;&#31649;&#29702;</a></li>
<li><a href="Statistics.do">&#36039;&#26009;&#24235;&#32113;&#35336;</a></li>
<li id="active"><a href="sysinfo.jsp" id="current">&#31995;&#32113;&#29376;&#24907;</a></li>
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

<h3>&#31995;&#32113;&#29376;&#24907;</h3>
<% 
    String loginFormURL = 
               "adminLogin.jsp"; 
    String user = (String) session.getAttribute("user"); 
    if(session.getAttribute("confirm") == "true") { 
    	String sIPAddress = request.getServerName();
    	
    %>
    	<div class='featurebox_center'>
    	Jobtracker Status(<a target ="_new" href=<% out.print("http://" + sIPAddress + ":50030"); %>>New Window</a>) <br>
    	<br>
    	<iframe height= "350" width="100%" marginheight="0" marginwidth="0" scrolling="auto" src=<% out.print("http://" + sIPAddress + ":50030"); %>></iframe><br>
    	<br>
    	<br>
    	Namenode Status (<a target ="_new" href=<% out.print("http://" + sIPAddress + ":50070"); %>>New Window</a>)<br>
    	<br>
    	<iframe height= "350" width="100%" marginheight="0" marginwidth="0" scrolling="auto" src=<% out.print("http://" + sIPAddress + ":50070"); %>></iframe><br>
    	
    	
    	</div>
        
    <% } 
    else {
		response.setHeader("Refresh", "3; URL=" + loginFormURL); %>
        <div class='featurebox_center'>&#31995;&#32113;&#31649;&#29702;&#21729;&#23578;&#26410;&#30331;&#20837;&#65292;&#31995;&#32113;&#23559;&#26044;3&#31186;&#24460;&#36339;&#36681;&#33267;&#30331;&#20837;&#38913;&#38754;(<a href="adminLogin.jsp">&#33509;&#28961;&#36339;&#36681;&#35531;&#25353;&#27492;</a>)</div>        
    	<% } %>
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