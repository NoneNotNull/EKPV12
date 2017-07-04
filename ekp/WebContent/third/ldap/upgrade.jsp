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
<title>升级LDAP导入速度</title>
</head>
<BODY> 
<br><br>
<table align=center >
	<tr>
		<td><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
		<td>
			<table align="center" width="80%" border=0 cellspacing=1 cellpadding=0 bgcolor=#000033>
				<tr> 
					<td height=18 class=barmsg>升级LDAP导入速度</td>
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
		if (action.equals("createindex")) {
			DataSet ds = new DataSet();
			try {
				ds.beginTran();
				ds
						.executeUpdate("create index oms_import_info_i on sys_org_element(fd_import_info)");
				ds
						.executeUpdate("create index oms_keyword_i on sys_org_element(fd_keyword)");
				ds
						.executeUpdate("create index oms_number_i on sys_org_element(fd_no)");
				ds
				.executeUpdate("create index oms_ldap_dn_i on sys_org_element(fd_ldap_dn)");
				ds
				.executeUpdate("create index oms_keyword_type_i on sys_org_element(fd_keyword,fd_org_type)");
				ds
				.executeUpdate("create index oms_number_type_i on sys_org_element(fd_no,fd_org_type)");
				ds
				.executeUpdate("create index oms_ldap_dn_type_i on sys_org_element(fd_ldap_dn,fd_org_type)"); 
				ds.commit();
				message = "【升级LDAP导入速度】操作已成功执行";
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
			onclick="location.href='?action=createindex'">升级LDAP导入速度</a></td>
		<td style="padding: 20px;">&nbsp;&nbsp;&nbsp;&nbsp;点击左边的连接将提升LDAP的导入速度,如果您是从旧的LDAP集成模块升级过来的版本请运行此工具，该工具的功能是在数据库创建一些索引提升导入性能。<br/>
		如果是初始化安装可以不用执行这个升级工具，因为初始化安装Sql脚本已经包含这个索引创建功能。<br>
		&nbsp;&nbsp;&nbsp;&nbsp;<font color="red"><b>如果你是DBA数据库管理员，也可以手动在数据库运行如下脚本</b></font>
		<pre>
create index oms_import_info_i on sys_org_element(fd_import_info);
create index oms_keyword_i on sys_org_element(fd_keyword);
create index oms_number_i on sys_org_element(fd_no);
create index oms_ldap_dn_i on sys_org_element(fd_ldap_dn);

create index oms_keyword_type_i on sys_org_element(fd_keyword,fd_org_type);
create index oms_number_type_i on sys_org_element(fd_no,fd_org_type);
create index oms_ldap_dn_type_i on sys_org_element(fd_ldap_dn,fd_org_type);</pre></td>
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