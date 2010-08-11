<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n" %>
<%@page import="java.util.*" %>


<%
	String loginFormURL = "adminLogin.jsp";
	String user = (String) session.getAttribute("user");
	if (session.getAttribute("confirm") == "true") {
		String sIPAddress = request.getServerName();
		String lang = (String) session.getAttribute("lang");
		if (lang == null) {
			lang = pageContext.getResponse().getLocale().toString();
			session.setAttribute("lang", lang);
		}
		Locale locale = new Locale(lang, "");
%>
<i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang"
	locale="<%=locale%>" id="bundle" />

<%@ include file="/include/header.jsp"%>
<div id="navcontainer">
<ul id="navlist">
	<li><a href="index.jsp"><i18n:message key="title_Home" /></a></li>
	<li><a href="crawl.jsp"><i18n:message key="title_Crawl" /></a></li>
	<li><a href="nutch_DB.jsp" id="current"><i18n:message key="title_DbManage" /></a></li>
	<li><a href="sysinfo.jsp" ><i18n:message
		key="title_SysInfo" /></a></li>
	<li><a href="usersetup.jsp"><i18n:message
		key="title_UserSetup" /></a></li>
	<%
		if (session.getAttribute("confirm") == "true") {
	%>
	<li><a href="logout.jsp"><i18n:message key="title_Logout" /></a></li>
	<%
		} else {
	%>
	<li><a href="adminLogin.jsp"><i18n:message key="title_Login" /></a></li>
	<%
		}
	%>
</ul>
</div>
</div>
<%@ include file="/include/right_side.jsp"%>



<div id="content">

<h3><i18n:message key="title_DbManage" /></h3>
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
    	<% } %>
	
<!-- //logout 
//session.invalidate(); --> 
</div>
<!-- <div class='featurebox_center'>some information here...</div> -->
<p>&nbsp;</p>
<p>&nbsp;</p>
</div>

<%@ include file="/include/foot.jsp" %>