<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- Meta Data -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="description" content="Crawlzilla Management" />
<meta name="keywords" content="nutch, crawlzilla, cloud computing, Hadoop, search engine" />
<meta name="author" content="Waue(waue@nchc.org.tw), Shunfa(shunfa@nchc.org.tw) , Rock(rock@nchc.org.tw)" />

<title>使用者登入</title>
</head>
<body>

<jsp:useBean id="loginBean" class="org.nchc.crawlzilla.LoginBean" /> 
<jsp:setProperty name="loginBean" property="*" /> 


<%
String indexURL = "index.jsp"; 
String loginFormURL = "adminLogin.jsp"; 

if (loginBean.getConfirm()){
	session.setAttribute("confirm", Boolean.toString(loginBean.getConfirm())); 
	session.setAttribute("changePasswdFlag", Boolean.toString(loginBean.getChangePasswdFlag()));
    response.setHeader("Refresh", "0; URL=" + indexURL); 
}

else { 
    response.setHeader("Refresh", "3; URL=" + loginFormURL); 
    out.println("使用者或密碼錯誤，請重新登入（3秒後回到登入頁面）");
} 
%>

</body>
</html>