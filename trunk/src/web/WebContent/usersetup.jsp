<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n" %>
<%@ include file="/include/header.jsp" %>
<%@page import="java.util.*" %>


<div id="navcontainer">
<ul id="navlist">
	<li><a href="index.jsp">HOME</a></li>
	<li><a href="crawl.jsp">Crawl</a></li>
	<li id="active"><a href="nutch_DB.jsp">&#36039;&#26009;&#24235;&#31649;&#29702;</a></li>
	<li id="active"><a href="sysinfo.jsp">&#31995;&#32113;&#29376;&#24907;</a></li>
	<li id="active"><a href="usersetup.jsp" id="current">&#x4F7F;&#x7528;&#x8005;&#x8A2D;&#x5B9A;</a></li>
	<%
		if (session.getAttribute("confirm") == "true") {
	%>
	<li><a href="logout.jsp">&#30331;&#20986;&#31995;&#32113;</a></li>
	<%
		} else {
	%>
	<li><a href="adminLogin.jsp">&#31649;&#29702;&#32773;&#30331;&#20837;</a></li>
	<%
		}
	%>
</ul>
</div>
</div>
<%@ include file="/include/right_side.jsp" %>

<div id="content">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<h3>&#x4F7F;&#x7528;&#x8005;&#x8A2D;&#x5B9A;</h3>
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
			out.print("set language = " + language + "<BR>");
			session.setAttribute("lang", language);
		}
		
     	String lang = (String) session.getAttribute("lang"); 
     	if (lang == null) {
     		lang = pageContext.getResponse().getLocale().toString();
     		session.setAttribute("lang", lang);
     	}
     	Locale locale =new Locale(lang,"");

		out.print("this session's lang" + lang +"<br>");
%>

 <i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang" locale="<%=locale%>" id="bundle" />
<form action="usersetup.jsp"><i18n:message
	key="usersetup_EngineName" /><br>
<textarea rows="1" cols="10" name=enginename></textarea><br>
<i18n:message key="usersetup_AdminEmail" /><br>
<textarea rows="1" cols="10" name=email></textarea><br>

<i18n:message key="usersetup_Language" /><br>
<select name="language">
	<option value="1">English</option>
	<option value="2">中文</option>
</select> <input type="submit" value="submit"></input></form>
<%
	} else {
		response.setHeader("Refresh", "0; URL=" + loginFormURL);
%>
<div class='featurebox_center'>&#31995;&#32113;&#31649;&#29702;&#21729;&#23578;&#26410;&#30331;&#20837;&#65292;&#31995;&#32113;&#23559;&#26044;3&#31186;&#24460;&#36339;&#36681;&#33267;&#30331;&#20837;&#38913;&#38754;(<a
	href="adminLogin.jsp">&#33509;&#28961;&#36339;&#36681;&#35531;&#25353;&#27492;</a>)</div>
<%
	}
%>
<p>&nbsp;</p>
<p>&nbsp;</p>
</div>

<%@ include file="/include/foot.jsp"%>