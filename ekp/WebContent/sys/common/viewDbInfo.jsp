<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@page import="com.landray.kmss.sys.config.dict.SysDictCommonProperty"%>
<%@page import="com.landray.kmss.sys.config.dict.SysDictModel"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.landray.kmss.sys.config.dict.SysDataDict"%>
<%@page import="com.landray.kmss.sys.config.design.SysConfigs"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.landray.kmss.sys.config.design.SysCfgModule"%>
<%@page import="com.landray.kmss.sys.config.design.SysCfgModuleInfo"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.sys.config.dict.SysDictComplexProperty"%>

<%@page import="com.landray.kmss.sys.config.dict.SysDictListProperty"%>
<%@page import="com.landray.kmss.sys.config.dict.SysDictSimpleProperty"%><title>查看数据字典</title>
<div id="optBarDiv">	
	<input type="button" value="返回" onclick="Com_OpenWindow('editDbInfo.jsp','_self');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
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
		String path = module.getUrlPrefix().replace("/", ".");
		moduleMap.put(path, text);
	}
	String[] key = request.getParameterValues("key");
	for(int i=0;i<key.length;i++){
	String module = moduleMap.get(key[i]).toString();
%>
<div style="width:980px; margin:0px auto; line-height: 30px; font-weight: bold;">模块：<%=module%></div>
<%
		List ftsearches = SysDataDict.getInstance().getModelInfoList();
		for (int j = 0; j < ftsearches.size(); j++) {
			if (ftsearches.get(j).toString().contains(key[i])) {
					%>
				<table class="tb_normal" width="980px">
					<%
				String modelName = ftsearches.get(j).toString();
				SysDictModel dictModel = SysDataDict.getInstance()
						.getModel(ftsearches.get(j).toString());
				if (StringUtil.isNotNull(dictModel.getMessageKey())) {
					%>
					<tr>
						<td colspan="5" class="td_normal_title">
							<%
								String name = ResourceUtil.getString(dictModel.getMessageKey(), Locale.getDefault());
								if(StringUtil.isNotNull(name)){
							%>
							<%=name %>
							<% 
								}else{
							%>
							<%=dictModel.getTable()%>
							<%
								}
							%>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<%="表名称"+"："+dictModel.getTable()%>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<%="对象名称"+"："+ dictModel.getModelName()%>
						</td>
					</tr>
					<%
				} else {
					%>
					<tr>
						<td colspan="5" class="td_normal_title">
							<%= dictModel.getTable() %>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<%="表名称"+"："+dictModel.getTable()%>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<%="对象名称"+"："+ dictModel.getModelName()%>
						</td>
					</tr>
					<%
				}
				List propertyList = dictModel.getPropertyList();
					%>
						<tr class="tr_normal_title">
							<td width="17%" >
								列名
							</td>
							<td width="17%">
								描述
							</td>
							<td width="17%">
								非空
							</td>
							<td width="17%">
								长度
							</td>
							<td width="32%">
								类型
							</td>
						</tr>
					<%
				boolean existListProperty = false;
				for (int k = 0; k < propertyList.size(); k++) {
					SysDictCommonProperty property = (SysDictCommonProperty) propertyList
							.get(k);
					if(property instanceof SysDictComplexProperty){
						continue;
					}
					if(property instanceof SysDictListProperty){
						SysDictListProperty listProperty = (SysDictListProperty) property;
						if(StringUtil.isNotNull(listProperty.getTable()) &&
								StringUtil.isNotNull(listProperty.getColumn()) &&
								StringUtil.isNotNull(listProperty.getElementColumn())){
							existListProperty = true;
						}
						continue;
					}
					%>
						<tr>
							<td>
								<%=property.getColumn()%>
							</td>
							<td>
								<%=ResourceUtil.getString(property.getMessageKey(), Locale.getDefault())%>
							</td>
							<td>
								<%=property.isNotNull()%>
							</td>
							<td>
								<%
									if(property instanceof SysDictSimpleProperty){
										int length = ((SysDictSimpleProperty)property).getLength();
										if(length>0){
											out.write(String.valueOf(length));
										}
									}
								%>
							</td>
							<td>
								<%
									String type = property.getType();
									String name = null;
									if(type!=null){
										if(type.startsWith("com.landray.kmss")){
											SysDictModel model = SysDataDict.getInstance().getModel(type);
											if(model!=null){
												name = ResourceUtil.getString(model.getMessageKey());
												if(StringUtil.isNotNull(name)){
													name = "外键关联："+name+" [ "+(StringUtil.isNull(model.getTable())?type:model.getTable())+" ]";
												}
											}
											if(StringUtil.isNull(name)){
												out.write("外键关联："+type);
											}else{
												out.write(name);
											}
										}else{
											out.write(type);
										}
									}
								%>
							</td>
						</tr>
					<%
				}
				if(existListProperty){
					%>
					<tr>
						<td colspan="5" class="td_normal_title">
							多对多子表
						</td>
					</tr>
					<tr class="tr_normal_title">
						<td width="17%" >
							表名
						</td>
						<td width="17%">
							外键（主表）
						</td>
						<td width="17%">
							外键（目标表）
						</td>
						<td width="17%">
							描述
						</td>
						<td width="32%">
							类型
						</td>
					</tr>
					<%
					for (int k = 0; k < propertyList.size(); k++) {
						SysDictCommonProperty property = (SysDictCommonProperty) propertyList.get(k);
						if(!(property instanceof SysDictListProperty)){
							continue;
						}
						SysDictListProperty listProperty = (SysDictListProperty)property;
						if(StringUtil.isNull(listProperty.getTable()) ||
								StringUtil.isNull(listProperty.getColumn()) ||
								StringUtil.isNull(listProperty.getElementColumn())){
							continue;
						}
						%>
						<tr>
							<td>
								<%=listProperty.getTable()%>
							</td>
							<td>
								<%=listProperty.getColumn()%>
							</td>
							<td>
								<%=listProperty.getElementColumn()%>
							</td>
							<td>
								<%=ResourceUtil.getString(property.getMessageKey(), Locale.getDefault())%>
							</td>
							<td>
								<%
									String type = property.getType();
									String name = null;
									if(type!=null){
										if(type.startsWith("com.landray.kmss")){
											SysDictModel model = SysDataDict.getInstance().getModel(type);
											if(model!=null){
												name = ResourceUtil.getString(model.getMessageKey());
												if(StringUtil.isNotNull(name)){
													name = name+" [ "+(StringUtil.isNull(model.getTable())?type:model.getTable())+" ]";
												}
											}
											if(StringUtil.isNull(name)){
												out.write(type);
											}else{
												out.write(name);
											}
										}else{
											out.write(type);
										}
									}
								%>
							</td>
						</tr>
						<%
					}
				}
				%>
				</table>
				<br>
<%		
			}
		}
	}
%>
<%@ include file="/resource/jsp/edit_down.jsp"%>
