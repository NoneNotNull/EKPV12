<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="com.landray.kmss.framework.plugin.core.config.IExtension"%>
<%@page import="com.landray.kmss.framework.service.plugin.Plugin"%>
<%@page import="com.landray.kmss.sys.ftsearch.util.ResultModelName" %>
<%@page import="com.landray.kmss.util.StringUtil" %>
<html>
<head>
<script type="text/javascript">
	function _submitForm(){
		Com_Submit(document.displayAreaForm, "save");
	};
</script>

<div id="optBarDiv">
	<input type="button" class="btnopt" value="保存" onclick="_submitForm();" />
</div>
</head>
<body>
	<html:form action="/sys/ftsearch/expand/customDisplayAreaConfig.do?method=save">
		<p class="txttitle">
			人名搜索展示模块配置
		</p>
		<center>
			<table class="tb_normal" width=100% id="displayAreaForm">
				<tr>
					<td class="td_normal_title" width="20%">人名搜索模块配置</td>
					<td>
						<xform:checkbox  property="value(kmss.ftsearch.person.config.module)" showStatus="edit" dataType="String" value="${displayAreaForm.map['kmss.ftsearch.person.config.module']}" >
							<%
								IExtension[] extensions = Plugin.getExtensions("com.landray.kmss.sys.ftsearch.personNameSearch","*","personSearchs");
								if(extensions != null){
									for(IExtension extension : extensions){
										String module = Plugin.getParamValueString(extension,"module");
										String value = ResultModelName.getModelName((String) Plugin.getParamValue(extension, "module"));
										String outSystem=(String) Plugin.getParamValue(extension, "outSystem");
										if(StringUtil.isNotNull(outSystem)){
											module=outSystem+"@"+module;
										}
										request.setAttribute("id",module);
										request.setAttribute("value",value);
							%>
								<xform:simpleDataSource value="${id}">${value}</xform:simpleDataSource>
							<%}}%>
						</xform:checkbox>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">显示条数</td>
					<td>
						<xform:select property="value(kmss.ftsearch.person.config.num)" showStatus="edit" value="${displayAreaForm.map['kmss.ftsearch.person.config.num']}" showPleaseSelect="false">
							<xform:simpleDataSource value="1">1</xform:simpleDataSource>
							<xform:simpleDataSource value="2">2</xform:simpleDataSource>
							<xform:simpleDataSource value="3">3</xform:simpleDataSource>
							<xform:simpleDataSource value="4">4</xform:simpleDataSource>
							<xform:simpleDataSource value="5">5</xform:simpleDataSource>
							<xform:simpleDataSource value="6">6</xform:simpleDataSource>
							<xform:simpleDataSource value="7">7</xform:simpleDataSource>
							<xform:simpleDataSource value="8">8</xform:simpleDataSource>
							<xform:simpleDataSource value="9">9</xform:simpleDataSource>
							<xform:simpleDataSource value="10">10</xform:simpleDataSource>
						</xform:select>
					</td>
				</tr>
			</table>
		</center>
	</html:form>
</body>
</html>
