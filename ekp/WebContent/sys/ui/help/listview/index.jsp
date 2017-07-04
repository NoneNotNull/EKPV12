<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@page import="org.dom4j.*,org.dom4j.io.*" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="defaultLayoutHelp" value="/sys/ui/help/listview/listview-layout-help.jsp" scope="request"/>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list" %>
<template:include file="/sys/ui/help/assembly-help.jsp">
	<%
		List<SysUiRender> columnRender = new ArrayList<SysUiRender>();
		List<SysUiRender> rowRender = new ArrayList<SysUiRender>();
		List<SysUiRender> gridRender = new ArrayList<SysUiRender>();
		Map<String, SysUiRender> renders = SysUiPluginUtil.getRenders();
		Collection<SysUiRender> all = renders.values();
		Iterator<SysUiRender> iter = all.iterator();
		while (iter.hasNext()) {
			SysUiRender render = iter.next();
			if ("listview.rowtable".equals(render.getFdFor())) {
				rowRender.add(render);
			}
			if ("listview.gridtable".equals(render.getFdFor())) {
				gridRender.add(render);
			}
			if ("listview.columntable".equals(render.getFdFor())) {
				columnRender.add(render);
			}
		}
		request.setAttribute("columnRender",columnRender);
		request.setAttribute("rowRender",rowRender);
		request.setAttribute("gridRender",gridRender);
	%>
	
	<%
		List<SysUiLayout> columnLayout = new ArrayList<SysUiLayout>();
		List<SysUiLayout> rowLayout = new ArrayList<SysUiLayout>();
		List<SysUiLayout> gridLayout = new ArrayList<SysUiLayout>();
		Map<String, SysUiLayout> layouts = SysUiPluginUtil.getLayouts();
		Collection<SysUiLayout> __all = layouts.values();
		Iterator<SysUiLayout> __iter = __all.iterator();
		while (__iter.hasNext()) {
			SysUiLayout layout = __iter.next();
			if ("listview.rowtable".equals(layout.getFdFor())) {
				rowLayout.add(layout);
			}
			if ("listview.gridtable".equals(layout.getFdFor())) {
				gridLayout.add(layout);
			}
			if ("listview.columntable".equals(layout.getFdFor())) {
				columnLayout.add(layout);
			}
		}
		request.setAttribute("columnLayout",columnLayout);
		request.setAttribute("rowLayout",rowLayout);
		request.setAttribute("gridLayout",gridLayout);
	%>
	<template:replace name="elements">
	<script>Com_IncludeFile('jquery.js');</script>
		<ui:content title="类型">
			<table class="tb_normal" width="100%">
				<tr class="tr_normal_title">
					 <td width="5%">序号</td>
					 <td width="30%">标签</td>
					 <td width="30%">名称</td>
				</tr>
				<tr height="30px"
						onmouseover="this.style.backgroundColor='#F6F6F6';"
						onmouseout="this.style.backgroundColor='#FFFFFF';"
						onclick="LUI('___listview___').switchType('rowtable');"
						style="cursor:pointer" data-tag-btn="rowtable">
						<td><center>1</center></td>
						<td>&lt;list:rowTable&gt;</td>
						<td>摘要视图</td>
				</tr>
				<tr data-tag-attr="rowtable" style="display: none">
					<td colspan="3">
						<table class="tb_normal" width="100%">
							<tr class="tr_normal_title"><td colspan="3" >系统注册layout</td></tr>
							<tr class="tr_normal_title">
								 <td width="25px">序号</td>
								 <td width="100px">ID</td>
								 <td width="50px">名称</td>
							</tr>
							<c:forEach items="${rowLayout }" var="row" varStatus="status">
								<tr>
									 <td ><center>${status.index+1 }</center></td>
									 <td >${row.fdId }</td>
									 <td >${row.fdName }</td>
								</tr>
							</c:forEach>
							
							<tr class="tr_normal_title"><td colspan="3" >系统注册template</td></tr>
							<tr class="tr_normal_title">
								 <td width="25px">序号</td>
								 <td width="100px">ID</td>
								 <td width="50px">名称</td>
							</tr>
							<c:forEach items="${rowRender }" var="row" varStatus="status">
								<tr>
									 <td ><center>${status.index+1 }</center></td>
									 <td >${row.fdId }</td>
									 <td >${row.fdName }</td>
								</tr>
							</c:forEach>
						</table>
					</td>
				</tr>
				<tr height="30px"
						onmouseover="this.style.backgroundColor='#F6F6F6';"
						onmouseout="this.style.backgroundColor='#FFFFFF';"
						onclick="LUI('___listview___').switchType('gridtable');"
						style="cursor:pointer" data-tag-btn="gridtable">
						<td><center>2</center></td>
						<td>&lt;list:gridTable&gt;</td>
						<td>格子视图</td>
				</tr>
				
				<tr data-tag-attr="gridtable" style="display: none">
					<td colspan="3">
						<table class="tb_normal" width="100%">
							<tr class="tr_normal_title"><td colspan="3" >系统注册layout</td></tr>
							<tr class="tr_normal_title">
								 <td width="25px">序号</td>
								 <td width="100px">ID</td>
								 <td width="50px">名称</td>
							</tr>
							<c:forEach items="${gridLayout }" var="grid" varStatus="status">
								<tr>
									 <td ><center>${status.index+1 }</center></td>
									 <td >${grid.fdId }</td>
									 <td >${grid.fdName }</td>
								</tr>
							</c:forEach>
							
							<tr class="tr_normal_title"><td colspan="3" >系统注册template</td></tr>
							<tr class="tr_normal_title">
								 <td width="25px">序号</td>
								 <td width="100px">ID</td>
								 <td width="50px">名称</td>
							</tr>
							<c:forEach items="${gridRender }" var="grid" varStatus="status">
								<tr>
									 <td ><center>${status.index+1 }</center></td>
									 <td >${grid.fdId }</td>
									 <td >${grid.fdName }</td>
								</tr>
							</c:forEach>
						</table>
					</td>
				</tr>
				
				<tr height="30px"
						onmouseover="this.style.backgroundColor='#F6F6F6';"
						onmouseout="this.style.backgroundColor='#FFFFFF';"
						onclick="LUI('___listview___').switchType('columntable');"
						style="cursor:pointer" data-tag-btn="columntable">
						<td><center>3</center></td>
						<td>&lt;list:colTable&gt;</td>
						<td>列表视图</td>
				</tr>
				<tr data-tag-attr="columntable" style="display: none">
					<td colspan="3">
						<table class="tb_normal" width="100%">
							<tr class="tr_normal_title"><td colspan="3" >系统注册layout</td></tr>
							<tr class="tr_normal_title">
								 <td width="25px">序号</td>
								 <td width="100px">ID</td>
								 <td width="50px">名称</td>
							</tr>
							<c:forEach items="${columnLayout }" var="column" varStatus="status">
								<tr>
									 <td ><center>${status.index+1 }</center></td>
									 <td >${column.fdId }</td>
									 <td >${column.fdName }</td>
								</tr>
							</c:forEach>
						</table>
					</td>
				</tr>
			</table>
		</ui:content>
		
		<script>
		$(document).ready(function() {
			$("tr[data-tag-btn]").click(function() {
				var tag = $(this);
				$('[data-tag-attr="' + tag.attr('data-tag-btn') + '"]').each(function() {
					var attr = $(this);
					if (attr.is(":visible")) {
						attr.hide();
					} else {
						attr.show();
					}
				});
			});
		});
		</script>
	</template:replace>
	<template:replace name="detail">
		<textarea style="width: 100%;height: 580px;display: none" data-tag-attr="rowtable">
			<c:import url="./rowtable-example.txt" charEncoding="utf-8"></c:import>
		</textarea>
		<textarea style="width: 100%;height: 580px;display: none" data-tag-attr="columntable">
			<c:import url="./columntable-example.txt" charEncoding="utf-8"></c:import>
		</textarea>
		<textarea style="width: 100%;height: 580px;display: none" data-tag-attr="gridtable">
			<c:import url="./gridtable-example.txt" charEncoding="utf-8"></c:import>
		</textarea>
	</template:replace>
	<template:replace name="more">
		<ui:content title="效果预览">
			<list:listview id="___listview___" cfg-criteriaInit="true">
				<ui:source type="AjaxJson">
					{"url":"/sys/ui/help/listview/listdata-example.jsp"}
				</ui:source>
				
				<list:colTable layout="sys.ui.listview.columntable" name="columntable">
					<list:col-checkbox name="List_Selected" style="width:5%"></list:col-checkbox>
					<list:col-serial title="序号" headerStyle="width:5%"></list:col-serial>
					<list:col-auto props="docSubject;docAuthor.fdName;docDept.fdName;docReadCount;docScore;docPublishTime"></list:col-auto>
				</list:colTable>
				
				<list:gridTable name="gridtable" columnNum="4" gridHref="">
					<list:row-template ref="sys.ui.listview.gridtable" >
					</list:row-template>
				</list:gridTable>
				
				<list:rowTable
					name="rowtable" onRowClick="" 
					style="" target="_blank"> 
					<list:row-template>
					</list:row-template>
				</list:rowTable>
			</list:listview>
			<list:paging></list:paging>	
		
		</ui:content>
	</template:replace>
</template:include>