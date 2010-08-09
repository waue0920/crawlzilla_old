<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n" %>
<%@ include file="/include/header.jsp" %>
<%@page import="java.util.*" %>
<div id="navcontainer">
<ul id="navlist">
<li><a href="index.jsp">HOME</a></li>
<li id="active"><a href="crawl.jsp" id="current">Crawl</a></li>
<li id="active"><a href="nutch_DB.jsp" >&#36039;&#26009;&#24235;&#31649;&#29702;</a></li>
<li id="active"><a href="usersetup.jsp">&#x4F7F;&#x7528;&#x8005;&#x8A2D;&#x5B9A;</a></li>
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
<div id="content">
<h3>Crawl</h3>
<% 
    String loginFormURL = "adminLogin.jsp";  
    if(session.getAttribute("confirm") == "true") { 
     	String lang = (String) session.getAttribute("lang"); 
     	if (lang == null) {
     		lang = pageContext.getResponse().getLocale().toString();
     		session.setAttribute("lang", lang);
     	}
     	Locale local =new Locale(lang,"");
 %>
 <i18n:bundle baseName="org.nchc.nutchez.i18n.lang" locale="<%=local%>" id="bundle"/>    
    
    
<div class='featurebox_center'>
	<form method="post" action="Crawl.do">
		<fieldset onmousemove="nuHiddlen()" onmouseout="hiddlen()">
		<legend><i18n:message key="crawl_How"/></legend>
		<ol id="how_to" class="hiddlen">
			<li><span class="redfont"><i18n:message key="crawl_InputDbName"/></span></li>
			<li><span class="redfont"><i18n:message key="crawl_InputUrl"/></span><br /> <img src="img/crawl_file.png" alt="crawl_file.png" /></li>
			<li><span class="redfont"><i18n:message key="crawl_ChooseDepth"/></span></li>
		</ol>
		</fieldset>
		<br />
	
		<fieldset>
		<legend><i18n:message key="crawl_DbName"/></legend>
		<label for="id_crawl_db"><i18n:message key="crawl_CrawlUrlSetup"/></label>
		<input type="text" class="haha" id="id_crawl_db" name="name_crawl_db"></input>
		</fieldset>
		<br />
	
		<fieldset>
		<legend><i18n:message key="crawl_InputCrawlUrl"/></legend>
		<label for="id_crawl_url"><i18n:message key="crawl_InputCrawlUrl"/></label>
		<textarea class="haha" id="id_crawl_url" name="name_crawl_url" rows="7" cols="50"></textarea>
		</fieldset>
		<br />
		
		<fieldset title="Crawl Depth Setup">
		<legend><i18n:message key="crawl_CrawlDepthSetup"/></legend>
			<label for="id_crawl_depth"><i18n:message key="crawl_ChooseCrawlDepth"/></label>
			<select size="1" id="id_crawl_depth" name="name_crawl_depth">
				<option>1</option>
				<option>2</option>
				<option>3</option>
				<option>4</option>
				<option>5</option>
				<option>6</option>
				<option>7</option>
				<option>8</option>
				<option>9</option>
				<option>10</option>
			</select><br />
		</fieldset>
		<input type="submit" value="Submit" name="Submit" onmouseover="check_null()">
		<input type="reset" value="Reset" name="Rset">
	</form>

        
    <% } 
    else {
		response.setHeader("Refresh", "0; URL=" + loginFormURL); %>
        <div class='featurebox_center'>&#31995;&#32113;&#31649;&#29702;&#21729;&#23578;&#26410;&#30331;&#20837;&#65292;&#31995;&#32113;&#23559;&#26044;3&#31186;&#24460;&#36339;&#36681;&#33267;&#30331;&#20837;&#38913;&#38754;(<a href="adminLogin.jsp">&#33509;&#28961;&#36339;&#36681;&#35531;&#25353;&#27492;</a>)</div>        
    	<% } %>

<%@ include file="/include/foot.jsp" %>