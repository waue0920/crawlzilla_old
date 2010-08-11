<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0"
	prefix="i18n"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>

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
	<li><a href="nutch_DB.jsp"><i18n:message key="title_DbManage" /></a></li>
	<li><a href="sysinfo.jsp" id="current"><i18n:message
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<script type="text/javascript">
	function _refresh() {//alert('test');
		window.location.reload();
	}
	var timer = window.setTimeout(_refresh, 15 * 1000);
</script>

<h3><i18n:message key="title_SysInfo" /></h3>
<div class='featurebox_center'><jsp:useBean id="nutchDBNum"
	class="org.nchc.crawlzilla.NutchDBNumBean" scope="session" /> <jsp:useBean
	id="nutchDBStatus" class="org.nchc.crawlzilla.NutchDBStatusBean"
	scope="session" /> <%
 	nutchDBStatus.setFiles("/home/crawler/crawlzilla/.tmp/");
 		File statusName[] = nutchDBStatus.getFiles();

 		nutchDBNum.setNum("/home/crawler/crawlzilla/.tmp/");
 		int statusNum = nutchDBNum.getNum();
 %> <i18n:message key="sysinfo_DbStatus" /><br>


<table>
	<tr>
		<th><i18n:message key="sysinfo_DbName" /></th>
		<th><i18n:message key="sysinfo_CrawlStatus" /></th>
		<th><i18n:message key="sysinfo_Delete" /></th>
	</tr>
	<%
		for (int j = 0; j < statusNum; j++) {
				out.print("<form method=\"get\" name=\"dbstatusForm\" >");
				out.print("<tr>");
				out.print("<td>");
				out
						.print("<a href=\"../" + statusName[j].getName()
								+ "\">");
				out
						.print("<input type=\"hidden\" name=\"fileName\" value=\""
								+ statusName[j].getName() + " \" >");
				out.print(statusName[j].getName() + "</a>");
				out.print("</td>");
				out.print("<td>");

				FileReader fr = new FileReader(statusName[j]);
				BufferedReader br = new BufferedReader(fr);
				out.print(br.readLine());
				br.close();
				fr.close();

				out.print("</td>");

				out.print("<td>");
				out
						.print("<input type=\"submit\" name=\"Delete\" value=\"Delete\" onclick=\"deleteDBStatus("
								+ j + ")\" />");
				out.print("</td>");

				out.print("</form>");

				out.print("</tr>");
			}
	%>
</table>
<body onload="window.scrollTo(0,0);">

<br />
<i18n:message key="sysinfo_JtStatus" />
(
<a target="_new" href=<%out.print("http://" + sIPAddress + ":50030");%>>New
Window</a>
)
<br>
<br>
<iframe id=JobTracker height="350" width="100%" marginheight="0"
	marginwidth="0" scrolling="auto"
	src=<%out.print("http://" + sIPAddress
						+ ":50030/jobtracker.jsp#running_jobs");%>></iframe>
<br>
<br>
<br>
<i18n:message key="sysinfo_NnStatus" />
(
<a target="_new" href=<%out.print("http://" + sIPAddress + ":50070");%>>New
Window</a>
)
<br>
<br>
<iframe height="350" width="100%" marginheight="0" marginwidth="0"
	scrolling="auto" src=<%out.print("http://" + sIPAddress + ":50070");%>></iframe>
<br>
</div>
<%
	} else {
		response.setHeader("Refresh", "0; URL=" + loginFormURL);
	}
%>
<p>&nbsp;</p>
<p>&nbsp;</p>
</div>

<%@ include file="/include/foot.jsp"%>