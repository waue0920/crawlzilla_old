<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="description" content="Crawlzilla Management" />
<meta name="keywords" content="nutch, crawlzilla, cloud computing, Hadoop, search engine" />
<meta name="author" content="Waue(waue@nchc.org.tw), Shunfa(shunfa@nchc.org.tw) , Rock(rock@nchc.org.tw)" />
<title>Insert title here</title>
</head>
<body>
<% 
session.invalidate(); 
response.setHeader("Refresh", "0; URL=" + "index.jsp");
%>
</body>
</html>