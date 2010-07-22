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
<meta name="description" content="Nutch Management" />
<meta name="keywords" content="nutch, cloud computing, Hadoop, search engine" />
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
<li id="active"><a href="index.jsp" id="current">HOME</a></li>
<li><a href="crawl.jsp">Crawl</a></li>
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
<% 
    String loginFormURL = 
               "adminLogin.jsp"; 
    String user = (String) session.getAttribute("user"); 
	String cgangePW = "changePW.html"; 
    if((session.getAttribute("confirm") == "true") && (session.getAttribute("changePasswdFlag") == "true") ) { 
    	response.setHeader("Refresh", "5; URL=" + cgangePW); 
        out.println("&#31995;&#32113;&#20597;&#28204;&#21040;&#24744;&#30446;&#21069;&#30340;&#31649;&#29702;&#32773;&#23494;&#30908;&#28858;&#31995;&#32113;&#38928;&#35373;&#20043;&#23494;&#30908;&#65292;&#24314;&#35696;&#24744;&#31435;&#21363;&#20462;&#25913;&#23494;&#30908;");
    }
    else if(session.getAttribute("confirm") == "true"){
%>
        <h3>&#31649;&#29702;&#20171;&#38754;&#21151;&#33021;&#20171;&#32057;</h3>
    	<div class='featurebox_center'>
    	  <p>* <a href="crawl.jsp">Crawl</a>&#65306;&#36879;&#36942;&#32178;&#38913;&#20171;&#38754;&#24314;&#31435;&#25628;&#23563;&#24341;&#25806;&#32034;&#24341;</p>
    	  <p>* <a href="nutch_DB.jsp">DataBase Management</a>&#65306;Setup and delete the Nutch DataBase</p>
    	  <p>* <a href="Statistics.do">&#36039;&#26009;&#24235;&#32113;&#35336;</a>&#65306;&#26597;&#35426;&#25628;&#23563;&#24341;&#25806;&#32034;&#24341;</p>
    	  <p>* <a href="sysinfo.jsp">&#31995;&#32113;&#29376;&#24907;</a>&#65306;&#28687;&#35261;&#30446;&#21069;&#31995;&#32113;&#29376;&#24907;</p>
    	  <p>* <a href="changePW.html">&#20462;&#25913;&#23494;&#30908;</a></p>

    	  </p>
    	  <p>&nbsp; </p>
    	  <p>&nbsp;</p>
    	  <p>&nbsp;</p>
    	</div>
        
<% } 
    else {
		response.setHeader("Refresh", "3; URL=" + loginFormURL); 
%>
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