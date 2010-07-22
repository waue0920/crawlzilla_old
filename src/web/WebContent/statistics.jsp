<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<!--
Copyright: Darren Hester 2006, http://www.designsbydarren.com
License: Released Under the "Creative Commons License", 
http://creativecommons.org/licenses/by-nc/2.5/
-->

<head>

<!-- Meta Data -->
<%@ page contentType="text/html; charset=UTF-8"%>
<meta http-equiv="Content-Type" content="text/html;  charset=UTF-8"/>
<meta name="description" content="NutchEz Management" />
<meta name="keywords" content="nutch, nutchEz, cloud computing, Hadoop, search engine" />
<meta name="author" content="Waue(waue@nchc.org.tw), Shunfa(shunfa@nchc.org.tw) , Rock(rock@nchc.org.tw)" />

<!-- Site Title -->
<title>NutchEZ&#32178;&#38913;&#31649;&#29702;&#31995;&#32113;</title>

<!-- Link to Style External Sheet -->
<link href="css/style.css" type="text/css" rel="stylesheet" />
<link rel=stylesheet type="text/css" href="css/Crawl.css" /> 
<!-- javaScript -->

<!-- JSP import -->
<%@page import="java.io.File" %>
<%@page import="java.util.Date" %>
<%@page import="java.text.DateFormat" %>
<%@page import="java.text.SimpleDateFormat" %>
<script type="text/javascript" src="crawl.js"></script>
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
<li id="active"><a href="crawl.jsp">Crawl</a></li>
<li id="active"><a href="nutch_DB.jsp">&#36039;&#26009;&#24235;&#31649;&#29702;</a></li>
<li><a href="Statistics.do" id="current">&#36039;&#26009;&#24235;&#32113;&#35336;</a></li>
<li><a href="sysinfo.jsp">&#31995;&#32113;&#29376;&#24907;</a></li>
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
<div id="right_side">
  <h3>&#30456;&#38364;&#36039;&#28304;</h3>
  <p>* NutchEZ&#23560;&#26696;&#32178;&#22336;</p>
  <p>* &#32218;&#19978;&#25903;&#25588;</p>
</div>

<h3>Nutch DataBase Statistics</h3>
<%
	String loginFormURL = "adminLogin.jsp";
	if (session.getAttribute("confirm") == "true") {
%>
<div class='featurebox_center'>

	
	<!-- CODECODECODE -->

<jsp:useBean id="nutchDBNum" class="org.nchc.nutchez.NutchDBNumBean" scope="session" />
<jsp:useBean id="nutchDBSearchDefaultLinkBean" class="org.nchc.nutchez.NutchDBSearchDefaultLinkBean" scope="session" />
<jsp:useBean id="dataInfo" class="org.nchc.nutchez.DataInfoBean" scope="session" />
<%
	nutchDBNum.setFiles("/home/nutchuser/nutchez/archieve/");
		nutchDBNum.setNum("/home/nutchuser/nutchez/archieve/");

		File files[] = nutchDBNum.getFiles();
		int num = nutchDBNum.getNum();

		nutchDBSearchDefaultLinkBean
				.setSearchLinkFile("/home/nutchuser/nutchez/search");
%>

<table>
  <tr>
  	<th>資料名稱</th>
  	<th>建立時間</th>
  	<th>目前搜尋引擎使用者</th>
  	<th>現正讀取的資料狀態</th>
  	<th></th>
  </tr>
<%
String InPreview = request.getParameter("inpreview");

	for (int i = 0; i < num; i++) {
			out.print("<form method=\"get\" name=\"dbForm\" action=\"Statistics.do\" >");
			String str_i = String.valueOf(i);
			out.print("<input type=\"hidden\" name=\"inpreview\" value=\""+str_i+"\" >");
			out.print("<tr>");
			out.print("<td>");
			out.print(files[i].getName());
			out.print("<input type=\"hidden\" name=\"fileName\" value=\""
							+ files[i].getName() + " \" >");
			out.print("</td>");
			out.print("<td>");
			Date lastModified = new Date(files[i].lastModified());
			DateFormat dateFormat = new SimpleDateFormat(
					"yyyy-MM-dd-ss");
			out.print(dateFormat.format(lastModified));
			out.print("</td>");

			out.print("<td>");
			if ( InPreview == null ){
				if (files[i].getName().equalsIgnoreCase(
						nutchDBSearchDefaultLinkBean.getSearchLinkFile())) {
					out.print("V</td><td>*</td><td>");
					out.print("<input type=\"hidden\" name=\"deafultLn\" value=\"yes\" >");
				}else{
					out.print("</td><td></td><td>");
				}
			}else{
				if (files[i].getName().equalsIgnoreCase(
						nutchDBSearchDefaultLinkBean.getSearchLinkFile())) {
					out.print("V");
					out.print("<input type=\"hidden\" name=\"deafultLn\" value=\"yes\" >");
				}
				out.print("</td><td>");
				if ( str_i.equals(InPreview)) {
					out.print("*");
				}
				out.print("</td><td>");

			}

			out.print("<input type=\"submit\" name=\"Preview\" value=\"Preview\" />");
			out.print("</td>");
			out.print("</tr>");

			out.print("</form>");

		}
%>
</table>
<div class='featurebox_center'> 資料總覽 <b><br>
<br>
<table width="100%" border="0">
	<tr>
		<td width="20%">使用者名稱</td>
		<td width="80%">${dataInfo.userName}</td>
	</tr>
	<tr>
		<td>總共文字數</td>
		<td>${dataInfo.numTerm}</td>
	</tr>
	<tr>
		<td>起始URL</td>
		<td>${dataInfo.initURL}</td>
	</tr>
	<tr>
		<td>本機索引路徑</td>
		<td>${dataInfo.indexPath}</td>
	</tr>
	<tr>
		<td>資料庫更新日期</td>
		<td>${dataInfo.lastModified}</td>
	</tr>
	<tr>
		<td>文件檔數量</td>
		<td>${dataInfo.numDoc}</td>
	</tr>
	<tr>
		<td>欄位數量</td>
		<td>${dataInfo.fieldsCount}</td>
	</tr>
	<tr>
		<td>欄位名稱</td>
		<td><jsp:getProperty name="dataInfo" property="fieldNames" /></td>
	</tr>
	<tr>
		<td>欄位的細部內容</td>
		<td></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
</table>

被搜尋分析到的網址:<br>
<table width="100%" border="2">
<jsp:getProperty name="dataInfo" property="siteTopTerms" />
</table>
<br><br>

分析的文件型態：<br>
<table width="100%" border="2">
<jsp:getProperty name="dataInfo" property="typeTopTerms" /></table>
<br><br>

出現次數前五十名的字符：<br>
<table width="100%" border="2">
<jsp:getProperty name="dataInfo" property="contentTopTerms" /></table>
<br><br>

</div>



    <%
    	} else {
    		response.setHeader("Refresh", "3; URL=" + loginFormURL);
    %>
        <div class='featurebox_center'>&#31995;&#32113;&#31649;&#29702;&#21729;&#23578;&#26410;&#30331;&#20837;&#65292;&#31995;&#32113;&#23559;&#26044;3&#31186;&#24460;&#36339;&#36681;&#33267;&#30331;&#20837;&#38913;&#38754;(<a href="adminLogin.jsp">&#33509;&#28961;&#36339;&#36681;&#35531;&#25353;&#27492;</a>)</div>        
    	<%
            		}
            	%>
	
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