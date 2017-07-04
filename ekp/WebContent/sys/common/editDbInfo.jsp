<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@page import="com.landray.kmss.sys.config.design.SysConfigs"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.landray.kmss.sys.config.design.SysCfgModule"%>
<%@page import="com.landray.kmss.sys.config.design.SysCfgModuleInfo"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="java.util.Locale"%>
<%@page import="com.landray.kmss.common.actions.RequestContext"%>
<title>查看数据字典</title>
<script>
function List_CheckSelect(){
	var obj = document.getElementsByName("key");
	for(var i=0; i<obj.length; i++)
		if(obj[i].checked)
			return true;
	alert("你没有选择要查看的模块，请选择后再点击查看");
	return false;
}
</script>
<% 
		SysConfigs configs = SysConfigs.getInstance();
		List modules = configs.getModuleInfoList();
		HashMap moduleMap = new HashMap();
		for (int i = 0; i < modules.size(); i++) {
			SysCfgModule module = configs.getModule(((SysCfgModuleInfo) modules
					.get(i)).getUrlPrefix());
			String text = module.getMessageKey();
			if (StringUtil.isNull(text))
				continue;
			text = ResourceUtil.getString(text, Locale.getDefault());
			if (StringUtil.isNull(text)){
				text = module.getMessageKey();
			}
			String path = module.getUrlPrefix().replace("/", ".");
			moduleMap.put(path, text);
		}
		request.setAttribute("moduleMap", moduleMap);
%>

<form action="viewDbInfo.jsp" method="POST">
<div id="optBarDiv">	
	<input type="button" value="查看" onclick="if(!List_CheckSelect())return;submit();">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
	<center>
	<p class="txttitle">请选择要查看的模块</p>
	<table class="tb_normal" width=60%>
		
		<% 
			int i=1;
			for (Object key : moduleMap.keySet()) {
			String module = moduleMap.get(key).toString();
		%>
		<% 
		if(i==1){
		%>
			<tr>			
		<%		
			}
		%>
		<td width="25%">
			<label>
				<input type="checkbox" name="key" value="<%=key%>"/><%=module%>
				<% i++; %>
			</label>
		</td>
		<% 
		if(i==5){
			i=1;
		%>
			</tr>			
		<%		
			}
		%>
		<%
		} 
		%>
	</table>
	</center>
</form>
<%@ include file="/resource/jsp/edit_down.jsp"%>