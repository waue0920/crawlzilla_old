<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n" %>
<%@ include file="/include/header.jsp" %>
<%@page import="java.io.File" %>
<%@page import="java.util.*" %>
<%@page import="java.io.FileReader" %>
<%@page import="java.io.BufferedReader" %>
<div id="navcontainer">
<ul id="navlist">
<li><a href="index.jsp">HOME</a></li>
<li><a href="crawl.jsp">Crawl</a></li>
<li id="active"><a href="nutch_DB.jsp" >&#36039;&#26009;&#24235;&#31649;&#29702;</a></li>
<li id="active"><a href="sysinfo.jsp" id="current">&#31995;&#32113;&#29376;&#24907;</a></li>
<li id="active"><a href="usersetup.jsp">&#x4F7F;&#x7528;&#x8005;&#x8A2D;&#x5B9A;</a></li>
<% if(session.getAttribute("confirm") == "true") { %>
<li><a href="logout.jsp">&#30331;&#20986;&#31995;&#32113;</a></li>
<%} else { %>	
<li><a href="adminLogin.jsp">&#31649;&#29702;&#32773;&#30331;&#20837;</a></li>
<% } %>
</ul>
</div>

</div>
<%@ include file="/include/right_side.jsp" %>

<div id="content">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<script type="text/javascript">
function _refresh(){//alert('test');
window.location.reload();
}
var timer = window.setTimeout(_refresh,15*1000);
</script> 


<h3>&#31995;&#32113;&#29376;&#24907;</h3>
<% 
    String loginFormURL = 
               "adminLogin.jsp"; 
    String user = (String) session.getAttribute("user"); 
    if(session.getAttribute("confirm") == "true") { 
    	String sIPAddress = request.getServerName();


 	String lang = (String) session.getAttribute("lang"); 
 	if (lang == null) {
 		lang = pageContext.getResponse().getLocale().toString();
 		session.setAttribute("lang", lang);
 	}
 	Locale local =new Locale(lang,"");

 %>
 <i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang" locale="<%=local%>" id="bundle"/>
 
    	<div class='featurebox_center'>
		<jsp:useBean id="nutchDBNum" class="org.nchc.crawlzilla.NutchDBNumBean" scope="session" />
		<jsp:useBean id="nutchDBStatus" class="org.nchc.crawlzilla.NutchDBStatusBean" scope="session" />
		
		<%
		nutchDBNum.setFiles("/home/crawler/crawlzilla/archieve/");
    	nutchDBNum.setNum("/home/crawler/crawlzilla/archieve/");    	
		File files[] = nutchDBNum.getFiles();
		int num=nutchDBNum.getNum();
		
    	nutchDBStatus.setFiles("/home/crawler/crawlzilla/.tmp/");
    	File statusName[] = nutchDBStatus.getFiles();
    	
    	nutchDBNum.setNum("/home/crawler/crawlzilla/.tmp/"); 
    	int statusNum=nutchDBNum.getNum();
		%>
		
		 <i18n:message key="sysinfo_DbStatus"/><br>
    	
    	
    	<table>
  		<tr>
  		<th><i18n:message key="sysinfo_DbName"/></th>
  		<th><i18n:message key="sysinfo_CrawlStatus"/></th>
		</tr>
		<%
		for (int i=0 ; i<num ;i++){
		out.print("<tr>");
		out.print("<td>");
		out.print("<a href=\""+files[i].getName()+"\">");
		out.print(files[i].getName()+"</a>");
				out.print("</td>");
		
		out.print("<td>");
		
		for (int j=0 ; j<statusNum ; j++)
			if (statusName[j].getName().equalsIgnoreCase(files[i].getName())){
				FileReader fr = new FileReader(statusName[j]);
				BufferedReader br = new BufferedReader(fr); 
				out.print(br.readLine());
				br.close();
				fr.close();
			} 
		out.print("</td>");
		out.print("</tr>");
		}
		%>
    	</table>
    	<body onload="window.scrollTo(0,0);">
 	
    	<br />
    	<i18n:message key="sysinfo_JtStatus"/>(<a target ="_new" href=<% out.print("http://" + sIPAddress + ":50030"); %>>New Window</a>) <br>
    	<br>
    	<iframe id=JobTracker height= "350"  width="100%" marginheight="0" marginwidth="0" scrolling="auto" src=<% out.print("http://" + sIPAddress + ":50030/jobtracker.jsp#running_jobs"); %>></iframe><br>
    	<br>
    	<br>
    	<i18n:message key="sysinfo_NnStatus"/> (<a target ="_new" href=<% out.print("http://" + sIPAddress + ":50070"); %>>New Window</a>)<br>
    	<br>
    	<iframe height= "350" width="100%" marginheight="0" marginwidth="0" scrolling="auto" src=<% out.print("http://" + sIPAddress + ":50070"); %>></iframe><br>
    	
    	
    	</div>
<% } 
    else {
		response.setHeader("Refresh", "0; URL=" + loginFormURL); %>
        <div class='featurebox_center'>&#31995;&#32113;&#31649;&#29702;&#21729;&#23578;&#26410;&#30331;&#20837;&#65292;&#31995;&#32113;&#23559;&#26044;3&#31186;&#24460;&#36339;&#36681;&#33267;&#30331;&#20837;&#38913;&#38754;(<a href="adminLogin.jsp">&#33509;&#28961;&#36339;&#36681;&#35531;&#25353;&#27492;</a>)</div>        
    	<% } %>
<p>&nbsp;</p>
<p>&nbsp;</p>
</div>

<%@ include file="/include/foot.jsp" %>