<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>

<jsp:useBean id="checkFristLogin" class="org.nchc.nutchez.CheckFristLogin" /> 
<jsp:setProperty name="checkFristLogin" property="*" /> 

<div id="navcontainer">
<ul id="navlist">
<li><a href="index.jsp">HOME</a></li>
<li><a href="crawl.jsp">Crawl</a></li>
<li id="active"><a href="nutch_DB.jsp" >&#36039;&#26009;&#24235;&#31649;&#29702;</a></li>
<li><a href="sysinfo.jsp">&#31995;&#32113;&#29376;&#24907;</a></li>
<li id="active"><a href="adminLogin.jsp" id="current">&#31649;&#29702;&#32773;&#30331;&#20837;</a></li>
</ul>
</div>

</div>
<div class='featurebox_center'>
<%@ include file="/include/right_side.jsp" %>

<div id="content">

<h3>登入管理系統</h3>


<form name="login" method="post" action="login.jsp">
  <p>請輸入管理者密碼：</p>
    <p>
      <label>
         <input type="password" name="passWord" >
      </label>
  </p>
    <p>
      <label>
        <input type="submit" name="login" id="login" value="&#36865;&#20986;" />
        </label>
      <label>
        <input type="reset" name="cancel" id="cancel" value="&#37325;&#35373;" />
        </label>
      </p>
      <%
if (checkFristLogin.fristLogin()){
	String cgangePW = "change_PW.jsp"; 
	response.setHeader("Refresh", "0.5; URL=" + cgangePW); 
}
%>
  </form>
<%@ include file="/include/foot.jsp" %>