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
<li id="active"><a href="adminLogin.jsp" id="current">&#20462;&#25913;&#23494;&#30908;</a></li>
</ul>
</div>

</div>
<div class='featurebox_center'>
<%@ include file="/include/right_side.jsp" %>

<div id="content">
 <p>&nbsp;</p>
<%
String oldPW="";
if (checkFristLogin.fristLogin()){
	oldPW="nutchuser";
	out.println("首次登入，請先修改密碼！");
	out.println("預設密碼為 \"nutchuser\"");
}
%>
  <form name="login" method="post" action="changePW.jsp">
  <table width="460" border="0">
      <tr>
        <td width="194">請輸入舊密碼：</td>
        <td width="158"><label>
          <input name="oldPasswd" type="password" id="oldPasswd" value="<%out.println(oldPW); %>" size="20" />
        </label></td>
        </tr>
    <tr>
      <td>&#35531;&#36664;&#20837;&#27442;&#26356;&#25913;&#30340;&#26032;&#23494;&#30908;&#65306;</td>
      <td><label>
        <input name="newPasswd" type="password" id="newPasswd" size="20" />
      </label></td>
      </tr>
    <tr>
      <td>&#35531;&#20877;&#36664;&#20837;&#19968;&#27425;&#26032;&#23494;&#30908;&#65306;</td>
      <td><label>
        <input name="checkNewPassword" type="password" id="checkNewPassword" size="20" />
      </label></td>
      </tr>
    </table>
       <p>
         <label>
           <input type="submit" name="login" id="login" value="&#36865;&#20986;" />
         </label>
         <label>
        <input type="reset" name="cancel" id="cancel" value="&#37325;&#35373;" />
        </label>
      </p>
  </form>
  <p>&nbsp;</p>
</div>
<p>&nbsp;</p>
</div>

<%@ include file="/include/foot.jsp" %>