<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div id="right_side">
    <h3>搜尋引擎快速連結</h3>
      <p><a href="../default">CrawlZilla 搜尋引擎範例</a></p>
      <%@ include file="/include/DB_list.jsp" %>
    <% if(session.getAttribute("confirm") == "true") { %>
    <h3>系統功能</h3>
      <p><a href="change_PW.jsp">修改管理者密碼</a></p>
    <% } %>
    <h3>相關資源</h3>
      <p><a href="http://code.google.com/p/crawlzilla/">CrawlZilla@GoogleCode</a></p>
      
</div>
