<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n" %>

<%@page import="java.util.*" %>

<%
	String loginFormURL = "adminLogin.jsp";
	String user = (String) session.getAttribute("user");
	if (session.getAttribute("confirm") == "true") {
		String sIPAddress = request.getServerName();

		
		String language = (String) request.getParameter("language");
		if (language != null ) {			
			int lan_int = Integer.parseInt(language);
			switch (lan_int) {
			case 1:
				language = "en";
				break;
			case 2:
				language = "zh_TW";
				break;
			}
			session.setAttribute("lang", language);
		}
		
     	String lang = (String) session.getAttribute("lang"); 
     	if (lang == null) {
     		lang = pageContext.getResponse().getLocale().toString();
     		session.setAttribute("lang", lang);
     	}
     	Locale locale =new Locale(lang,"");
%>

 <i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang" locale="<%=locale%>" id="bundle" />



<%@ include file="/include/header.jsp" %>
<div id="navcontainer">
<ul id="navlist">
	<li><a href="index.jsp"><i18n:message key="title_Home" /></a></li>
	<li><a href="crawl.jsp"><i18n:message key="title_Crawl" /></a></li>
	<li><a href="nutch_DB.jsp"><i18n:message key="title_DbManage" /></a></li>
	<li><a href="sysinfo.jsp"><i18n:message key="title_SysInfo" /></a></li>
	<li><a href="usersetup.jsp" id="current"><i18n:message key="title_UserSetup" /></a></li>
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
<%@ include file="/include/right_side.jsp" %>
<div id="content">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<h3><i18n:message key="title_UserSetup" /></h3>

<form action="usersetup.jsp"><i18n:message
	key="usersetup_EngineName" /><br>
<input type="text" class="haha" id="enginename" name="enginename"></input><br>
<i18n:message key="usersetup_AdminEmail" /><br>
<input type="text" class="haha" id="email" name="email"></input><br>

<i18n:message key="usersetup_Language" /><br>
<select name="language">
	<option value="1">English</option>
	<option value="2">中文</option>
</select> <BR><BR>
<input type="submit" value="<i18n:message key="button_submit" />"></input></form>
<%
	} else {
		response.setHeader("Refresh", "0; URL=" + loginFormURL);
%>

<%
	}
%>
<p>&nbsp;</p>
<p>&nbsp;</p>
</div>

<%@ include file="/include/foot.jsp"%>