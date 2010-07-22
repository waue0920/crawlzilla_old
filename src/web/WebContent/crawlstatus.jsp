<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- Meta Data -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="description" content="NutchEz Management" />
<meta name="keywords" content="nutch, nutchEz, cloud computing, Hadoop, search engine" />
<meta name="author" content="Waue(waue@nchc.org.tw), Shunfa(shunfa@nchc.org.tw) , Rock(rock@nchc.org.tw)" />

<link rel=stylesheet type="text/css" href="css/Crawl.css"> 
<link href="css/style.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="crawl.js"></script>

<title>NutchEZ&#32178;&#38913;&#31649;&#29702;&#31995;&#32113;</title>
</head>
<body onload="wait()">

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

<h3>Crawl Status</h3>
<% 
    String loginFormURL = 
               "adminLogin.jsp";  
    if(session.getAttribute("confirm") == "true") { %>
<div class='featurebox_center'>

<div class="crawl_status">

	<fieldset id="fieldset_crawl">
	<legend>Crawl Setup Status</legend>
	<b>URL: </b>
	<% 
	String crawl_url = request.getParameter("name_crawl_url");
	out.println(crawl_url);
	%>
	<br />
	
	<b>Depth: </b>${param.name_crawl_depth}<br />
	<br />
	<p><span class="crawl_status_p"></>Setup Success !!! But, it need time to crawl !!!</span></p>
	<div class="blackfont">
	(ex. 4URLs with 1 depth -> 10~20 minute<br />
	     4URLs with 2 depth -> 40~80 minute<br />
	     100URLs with 10 depth -> very very long)<br />
	     <br />
	</div>
	     <span class="redfont">The Crawl speed is depend on your system performance, URLs number, and depth.</span>
	</fieldset>
	<br />
	<br />
	<img id="wait_img" src="img/ajax-loader.gif"></br>
	<P id="wait_num"></P> 
	If you don't want to wait, click below link !!!<br />
	(1)<a href="sysinfo.jsp">Crawl operation page</a><br />
	(2)<a href="index.jsp">Mian page</a><br />
	    <% } 
    else {
		response.setHeader("Refresh", "3; URL=" + loginFormURL); %>
        <div class='featurebox_center'>&#31995;&#32113;&#31649;&#29702;&#21729;&#23578;&#26410;&#30331;&#20837;&#65292;&#31995;&#32113;&#23559;&#26044;3&#31186;&#24460;&#36339;&#36681;&#33267;&#30331;&#20837;&#38913;&#38754;(<a href="adminLogin.jsp">&#33509;&#28961;&#36339;&#36681;&#35531;&#25353;&#27492;</a>)</div>        
    	<% } %>

</div>

<!-- //logout 
//session.invalidate(); --> 
</div>

<!-- <div class='featurebox_center'>some information here...</div> -->
<p>&nbsp;</p>
<p>&nbsp;</p>


<div id="footer">
copyright &copy; 2010 Free Software Lab@NCHC 
<br />
Template provided by: 
<a href="http://www.designsbydarren.com" target="_blank">DesignsByDarren.com</a>
</div>

</div>
</body>
</html>