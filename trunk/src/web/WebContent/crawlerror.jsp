<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>

<div id="navcontainer">
<ul id="navlist">
<li><a href="index.jsp">HOME</a></li>
<li id="active"><a href="crawl.jsp" id="current">Crawl</a></li>
<li id="active"><a href="nutch_DB.jsp" >&#36039;&#26009;&#24235;&#31649;&#29702;</a></li>
<li><a href="sysinfo.jsp">&#31995;&#32113;&#29376;&#24907;</a></li>
<% if(session.getAttribute("confirm") == "true") { %>
<li><a href="logout.jsp">&#30331;&#20986;&#31995;&#32113;</a></li>
<%} else { %>	
<li><a href="adminLogin.jsp">&#31649;&#29702;&#32773;&#30331;&#20837;</a></li>
<% } %>


</ul>
</div>

</div>
<%@ include file="/include/right_side.jsp" %>

<h3>Crawl Status</h3>
<% 
    String loginFormURL = 
               "adminLogin.jsp";  
    if(session.getAttribute("confirm") == "true") { %>
<div class='featurebox_center'>

Error: Can't find /home/crawler/crawlzilla/system/go.sh<br />
	
	    <% } 
    else {
		response.setHeader("Refresh", "3; URL=" + loginFormURL);  } %>
	
</div>
<!-- //logout 
//session.invalidate(); --> 
</div>
<!-- <div class='featurebox_center'>some information here...</div> -->

<%@ include file="/include/foot.jsp" %>