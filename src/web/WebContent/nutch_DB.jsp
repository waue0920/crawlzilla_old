<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n" %>
<%@ include file="/include/header.jsp" %>
<%@page import="java.util.*" %>
<div id="navcontainer">
<ul id="navlist">
<li><a href="index.jsp">HOME</a></li>
<li id="active"><a href="crawl.jsp">Crawl</a></li>
<li id="active"><a href="nutch_DB.jsp" id="current">&#36039;&#26009;&#24235;&#31649;&#29702;</a></li>
<li><a href="sysinfo.jsp">&#31995;&#32113;&#29376;&#24907;</a></li>
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

<h3>DataBase Management</h3>
<% 
    String loginFormURL = 
               "adminLogin.jsp";  
    if(session.getAttribute("confirm") == "true") { 
    
 	String lang = (String) session.getAttribute("lang"); 
 	if (lang == null) {
 		lang = pageContext.getResponse().getLocale().toString();
 		session.setAttribute("lang", lang);
 	}
 	Locale local =new Locale(lang,"");
 %>
 <i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang" locale="<%=local%>" id="bundle"/>
<div class='featurebox_center'>

	
	<!-- CODECODECODE -->

<jsp:useBean id="nutchDBNum" class="org.nchc.crawlzilla.NutchDBNumBean" scope="session" />
<jsp:useBean id="dataInfo" class="org.nchc.crawlzilla.DataInfoBean" scope="session" />
<%
	nutchDBNum.setFiles("/home/crawler/crawlzilla/archieve/");
    nutchDBNum.setNum("/home/crawler/crawlzilla/archieve/");

	File files[] = nutchDBNum.getFiles();
	int num=nutchDBNum.getNum();

%>

<table>
  <tr>
  	<th><i18n:message key="nutchDB_Dbname"/></th>
  	<th><i18n:message key="nutchDB_CreateTime"/></th>
  	<th><i18n:message key="nutchDB_DelDb"/></th>
  	<th><i18n:message key="nutchDB_Preview"/><br><i18n:message key="nutchDB_Statistics"/></th>
  </tr>
<%
String InPreview = request.getParameter("inpreview");
for (int i=0 ; i<num ;i++){
	out.print("<form method=\"get\" name=\"dbForm\" action=\"NutchDBSetup.do\" >");
		
	out.print("<tr>");
	out.print("<td>");
	out.print("<a href=\"../"+files[i].getName()+"\">");
	out.print(files[i].getName()+"</a>");
	out.print("<input type=\"hidden\" name=\"fileName\" value=\""+files[i].getName()+" \" >");
	out.print("</td>");
	
	out.print("<td>");
	Date lastModified = new Date(files[i].lastModified());
	DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd_HH:mm:ss");
	out.print(dateFormat.format(lastModified));
	out.print("</td>");
	
	out.print("<td>");
	out.print("<input type=\"button\" name=\"Delete\" value=\"Delete\" onclick=\"deleteFun(" + i + ")\" />");
	out.print("</td>");
	out.print("<td>");
	out.print("<input type=\"hidden\" name=\"inpreview\" value=\""+String.valueOf(i)+"\" >");
	out.print("<input type=\"submit\" name=\"Preview\" value=\"Preview\" onclick=\"preview(" + i + ")\" />");
	out.print("</form>");
}

%>
</table>
<div class='featurebox_center'><i18n:message key="nutchDB_Overview"/> <b><br><br>
<table width="100%" border="0">
	<tr>
		<td width="20%"><i18n:message key="nutchDB_InitUrl"/></td>
		<td width="80%">${dataInfo.initURL}</td>
	</tr>
	<tr>
		<td><i18n:message key="nutchDB_LocalIndexPath"/></td>
		<td>${dataInfo.indexPath}</td>
	</tr>
</table>
<table width="100%" border="0">
	<tr>
		<td width="20%"><i18n:message key="nutchDB_TotalWordNum"/></td>
		<td width="30%">${dataInfo.numTerm}</td>
		<td width="20%"><i18n:message key="nutchDB_TotalFile"/></td>
		<td width="30%">${dataInfo.numDoc}</td>
	</tr>
	<tr>
		<td><i18n:message key="nutchDB_DbUpdateTime"/></td>
		<td>${dataInfo.lastModified}</td>
		<td><i18n:message key="nutchDB_UserName"/></td>
		<td>${dataInfo.userName}</td>
	</tr>
</table>

<i18n:message key="nutchDB_ParsedUrl"/>:<br>
<table width="100%" border="2">
<jsp:getProperty name="dataInfo" property="siteTopTerms" />
</table>
<br><br>

<i18n:message key="nutchDB_ParsedFileType"/>：<br>
<table width="100%" border="2">
<jsp:getProperty name="dataInfo" property="typeTopTerms" /></table>
<br><br>

<i18n:message key="nutchDB_Top50Word"/>：<br>
<table width="100%" border="2">
<jsp:getProperty name="dataInfo" property="contentTopTerms" /></table>
<br><br>

</div>

    <% } 
    else {
		response.setHeader("Refresh", "0; URL=" + loginFormURL); %>
        <div class='featurebox_center'>&#31995;&#32113;&#31649;&#29702;&#21729;&#23578;&#26410;&#30331;&#20837;&#65292;&#31995;&#32113;&#23559;&#26044;3&#31186;&#24460;&#36339;&#36681;&#33267;&#30331;&#20837;&#38913;&#38754;(<a href="adminLogin.jsp">&#33509;&#28961;&#36339;&#36681;&#35531;&#25353;&#27492;</a>)</div>        
    	<% } %>
	
<!-- //logout 
//session.invalidate(); --> 
</div>
<!-- <div class='featurebox_center'>some information here...</div> -->
<p>&nbsp;</p>
<p>&nbsp;</p>
</div>

<%@ include file="/include/foot.jsp" %>