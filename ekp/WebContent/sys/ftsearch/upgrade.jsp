<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%@ page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page import="com.landray.kmss.util.StringUtil"%>
<%@ page import="com.landray.kmss.component.dbop.ds.DataSet"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script>
Com_IncludeFile("msg.js", "style/"+Com_Parameter.Style+"/msg/");
Com_IncludeFile("docutil.js"); 
</script>
<title>Office 2007 Support</title>
</head>
<BODY> 
<br><br>
<table align=center >
	<tr>
		<td><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
		<td>
			<table align="center" width="80%" border=0 cellspacing=1 cellpadding=0 bgcolor=#000033>
				<tr> 
					<td height=18 class=barmsg>Office 2007 Support</td>
				</tr>
				<tr>
					<td>
						<table bgcolor="#FFFFFF" border=0 cellspacing=0 cellpadding=0 width=100%>
							<tr>
								<td width=20><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
								<td> 
	<!-- ///////////////////////////////////// -->
<%
	String action = request.getParameter("action");
	String message = "";
	if (StringUtil.isNotNull(action)) {
		//将数据库附件表里面的Office2007文档修改成指定的ContentType
		if (action.equals("office2007")) {
			DataSet ds = new DataSet();
			try {
				ds.beginTran();
				ds
						.executeUpdate("update sys_att_main set fd_content_type='application/msword'  where lower(fd_file_name) like '%.docx'");
				ds
						.executeUpdate("update sys_att_main set fd_content_type='application/vnd.ms-excel'  where lower(fd_file_name) like '%.xlsx'");
				ds
						.executeUpdate("update sys_att_main set fd_content_type='application/vnd.ms-powerpoint'  where lower(fd_file_name) like '%.pptx'");
				ds.commit();
				message = "【开启Office2007的支持】操作已成功执行";
			} catch (Exception ex) {
				ds.rollback();
				message = "执行失败：原因[" + ex.getMessage() + "]";
			} finally {
				ds.close();
			}
		}
		//清楚索引，和数据库的最后索引时间
		if (action.equals("clearindex")) {
			DataSet ds = new DataSet();
			try {
				String indexDir = ResourceUtil.KMSS_RESOURCE_PATH
						+ File.separator + "index";
				File dir = new File(indexDir);
				FileUtils.deleteDirectory(dir); 
				dir.mkdirs();
				ds.beginTran();
				ds
						.executeUpdate("delete from sys_app_config where fd_key = 'com.landray.kmss.sys.ftsearch.db.SearchConfig'");
				ds.commit();
				message = "【清除所有已创建的索引】 操作已成功执行";
			} catch (Exception ex) {
				ds.rollback();
				message = "执行失败：原因[" + ex.getMessage() + "]";
			} finally {
				ds.close();
			}
		}
	}
%>
<%
	if (StringUtil.isNull(message)) {
%><br><br>
<table width="800" align="center" border="1" cellpadding="0" cellspacing="0">
	<tr>
		<td width="200" align="center"><a href="javascript:voie(0)"
			onclick="location.href='?action=office2007'">开启Office2007的支持</a></td>
		<td style="padding: 20px;">&nbsp;&nbsp;&nbsp;&nbsp;点击左边的连接将开启Office2007的支持，之前附件表的ContentType字段没有记录Office2007文件正确的MimeType，该操作是将数据库的Office2007文档的ContentType更正。<br>&nbsp;&nbsp;&nbsp;&nbsp;注意：之前上传的Office2007文档需要创建索引需要使用下面的【清除已经创建的索引】连接。</td>
	</tr>
	<tr>
		<td align="center"><a href="javascript:voie(0)"
			onclick="location.href='?action=clearindex'">清除所有已创建的索引</a></td>
		<td style="padding: 20px;">&nbsp;&nbsp;&nbsp;&nbsp;点击左边的连接可以清除已经创建的全文索引，该操作之后全文索引的功能将搜索不到内容，等到下次全文索引定时任务执行之后就可以搜索到内容了，全文索引的定时任务一般每天执行一次。<br>&nbsp;&nbsp;&nbsp;&nbsp;清除索引的目的是因为开启Office2007支持之后，之前上传的Office2007文档格式重新创建索引。</td>
	</tr>
</table><br><br>
<%
	} else {
%>
<table align="center" width=400 border="0">
	<tr>
		<td style="padding: 20px;"  align="center">
		<DIV class=msgtitle> 
		<%
			out.print(message);
		%>
		</DIV>
		</td>
	</tr>
	<!-- 
	<tr>
		<td style="padding: 20px;" align="center"><a href="javascript:voie(0)"
			onclick="location.href='?'">返回</a>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:voie(0)"
			onclick="window.close()">关闭</a></td>
	</tr>
	-->
</table> 
<div align=center>
					<INPUT class=btnmsg onclick="location.href='?'" value=返回 type=button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<INPUT class=btnmsg onclick="window.close()" value=关闭 type=button> 
	</div>
	<br style="font-size:10px">
<%
	}
%>
<!-- ///////////////////////////////////// --> </td>
								<td width=20><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
	</tr>
</table>
<br><br>
</body>
</html>