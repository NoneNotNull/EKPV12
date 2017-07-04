<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.landray.kmss.km.signature.util.iDBManager2000" %>
<%!
  iDBManager2000 ObjConnBean = new iDBManager2000();
%>
<html>
<head>
<title>iWebRevision 网页签批中间件</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<link REL="stylesheet" href="Test.css" type="text/css">
</head>
<body bgcolor="#ffffff">
<div align="center"><font size=4 color=ff0000>iWebRevision 网页签批中间件</font></div>
<!-- 控件引用 -->
<script src="iWebRevision.js"></script>
<br>
<hr size=1>
<div class=IptStyle>
注：网页签批演示版能直接在IE的页面里进行签名和印章。正式版可实现更强大的功能，如要正式版，请与公司联系。<br>
&nbsp;&nbsp;&nbsp;&nbsp;主要应用于B/S结构下各种流程的WEB审批单上进行电子签名，真迹保留。如要正确演示本示例，您必须：<br>
&nbsp;&nbsp;&nbsp;&nbsp;安装iWebRevision 插件，请你在打开本页面等待几秒钟后的弹出窗口时，选择[是]按钮，才能正常运行。<br>
&nbsp;&nbsp;&nbsp;&nbsp;如果不能正常自动安装iWebRevision 插件，<a href="InstallClient.zip">请你在这里下载本地安装程序</a>。<br>
&nbsp;&nbsp;&nbsp;&nbsp;开发和应用中遇到控件安装问题时请阅读该文档：《安装、升级和卸载详解》。<br>
<br>
</div>

<table Height="40" border=0  cellspacing='0' cellpadding='0' width=100% align=center class=TBStyle>
<tr>
  <td colspan=2 class="TDTitleStyle" nowrap align=center>
    <input type=button value="新建文档"  onclick="javascript:location.href='DocumentEdit.jsp?EditType=3&UserName='+username.value;">
    <input type=button value="印章管理"  onclick="javascript:location.href='Signature/SignatureList.jsp'">
    <input type=button value="查看版本"  onclick="alert('iWebRevision网页签批中间件 '+Consult.Version()+Consult.VersionEx())">
  </td>
  <td colspan=4 class="TDTitleStyle">用户名:<input type=text name=username size=8 value="演示人"></td>
</tr>

<tr>
  <td nowrap align=center class="TDTitleStyle" height="30">编号</td>
  <td nowrap align=center class="TDTitleStyle">主题</td>
  <td nowrap align=center class="TDTitleStyle">作者</td>
  <td nowrap align=center class="TDTitleStyle">打印份数</td>
  <td nowrap align=center class="TDTitleStyle">日期</td>
  <td nowrap align=center class="TDTitleStyle">操作</td>
</tr>

<%
  String strSql = "",strRecordID = "";
  if (ObjConnBean.OpenConnection()) {
    ResultSet rs = null;
    Statement stmt = null;

    try {
      strSql = "select  * from KmSignatureDocumentMain order by fdDocumentId desc";
      rs = ObjConnBean.ExecuteQuery(strSql);
      while (rs.next()){
        strRecordID = rs.getString("fdRecordId");
%>
<tr>
  <td nowrap align=center class="TDStyle" height="30"><%=strRecordID%></td>
  <td nowrap align=center class="TDStyle"><%=rs.getString("fdTitle")%></td>
  <td nowrap align=center class="TDStyle"><%=rs.getString("fdUserName")%></td>
  <td nowrap align=center class="TDStyle"><%=rs.getString("fdCopies")%></td>
  <td nowrap align=center class="TDStyle"><%=rs.getString("fdDateTime")%></td>
  <td class="TDStyle" nowrap align=center>
    <input type=button onclick="javascript:location.href='DocumentEdit.jsp?RecordID=<%=strRecordID%>&EditType=1&UserName='+username.value;" value="签发权限">
    <input type=button onclick="javascript:location.href='DocumentEdit.jsp?RecordID=<%=strRecordID%>&EditType=2&UserName='+username.value;" value="会签权限">
    <input type=button onclick="javascript:location.href='DocumentEdit.jsp?RecordID=<%=strRecordID%>&EditType=3&UserName='+username.value;" value="审核权限">
    <input type=button onclick="javascript:location.href='DocumentEdit.jsp?RecordID=<%=strRecordID%>&EditType=0&UserName='+username.value;" value="禁止修改">
  </td>
</tr>
<%
   }
  rs.close();
    }catch (SQLException e) {
      out.println(e.getMessage());
    }
    ObjConnBean.CloseConnection();
  }
%>
</table>
</body>
</html>