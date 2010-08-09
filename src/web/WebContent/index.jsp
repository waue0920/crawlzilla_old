<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n" %>
<%@ include file="/include/header.jsp" %>
<%@page import="java.util.*" %>
<div id="navcontainer">
<ul id="navlist">
<li><a href="index.jsp" id="current">HOME</a></li>
<li><a href="crawl.jsp">Crawl</a></li>
<li><a href="nutch_DB.jsp" >&#36039;&#26009;&#24235;&#31649;&#29702;</a></li>
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
<% 
    String loginFormURL = 
               "adminLogin.jsp"; 
    String user = (String) session.getAttribute("user"); 
	String cgangePW = "change_PW.jsp"; 
    if((session.getAttribute("confirm") == "true") && (session.getAttribute("changePasswdFlag") == "true") ) { 
    	response.setHeader("Refresh", "0.5; URL=" + cgangePW); 
        out.println("系統偵測到目前密碼為預設密碼，請立即修改密碼！");
    }
    else if(session.getAttribute("confirm") == "true"){
    	
    	 String lang = (String) session.getAttribute("lang"); 
    	 if (lang == null) {
    		 lang = pageContext.getResponse().getLocale().toString();
    		 session.setAttribute("lang", lang);
    	 }
    	 Locale local =new Locale(lang,"");
    	
    	
%>
	

    	<div class='featurebox_center'>
    	<i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang" locale="<%=local%>" id="bundle"/>
    	  <h3><i18n:message key="index_Intro"/></h3>
    	  <p>* <a href="crawl.jsp"><i18n:message key="index_Crawl_h"/></a> : <i18n:message key="index_Crawl"/></p>
    	  <p>* <a href="nutch_DB.jsp"><i18n:message key="index_DbManage_h"/></a> : <i18n:message key="index_DbManage"/></p>
    	  <p>* <a href="sysinfo.jsp"><i18n:message key="index_SystemStatus_h"/></a> : <i18n:message key="index_SystemStatus"/></p>
    	  <p>* <a href="usersetup.jsp"><i18n:message key="index_UserSetup_h"/></a> : <i18n:message key="index_UserSetup"/></p>
    	  <p>* <a href="changePW.html"><i18n:message key="index_SetPasswd"/></a></p>
    	  <p>&nbsp; </p>
    	  <p>&nbsp;</p>
    	  <p>&nbsp;</p>
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