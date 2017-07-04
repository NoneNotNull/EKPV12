<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<title>版本信息</title>
<div id="optBarDiv">
	<input type="button" value="导出模块版本" onclick="Com_OpenWindow('admin.do?method=exportModuleVersion','_self');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<center>
<p class="txttitle">版本信息</p>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width="5%">
			<center>序号</center>
		</td>
		<td class="td_normal_title" width="10%">
			<center>组件名称</center>
		</td>
		<td class="td_normal_title" width="17%">
			<center>组件路径</center>
		</td>
		<td class="td_normal_title" width="10%">
			<center>平行版本</center>
		</td>		
		<td class="td_normal_title" width="14%">
			<center>当前版本</center>
		</td>
		<td class="td_normal_title" width="10%">
			<center>版本序列号</center>
		</td>		
		<td class="td_normal_title" width="14%">
			<center>版本标识</center>
		</td>
		<td class="td_normal_title" width="10%">
			<center>是否定制</center>
		</td>
		<td class="td_normal_title" width="10%">
			<center>是否临时版本</center>
		</td>
	</tr>
	<c:forEach items="${descriptionList}" var="description" varStatus="vstatus">
		<tr style="cursor:pointer;"
			onmouseover="this.style.backgroundColor='#F3F3F3'" onmouseout="this.style.backgroundColor='#FFFFFF'"
			onclick="Com_OpenWindow('<c:url value='/${description.module.modulePath}.version' />','_blank');">
			<td>
				<center>${vstatus.index+1}</center>
			</td>
			<td>
				<c:out value="${description.module.moduleName}" />
			</td>
			<td>
				<c:out value="${description.module.modulePath}" />
			</td>
			<td>
				<c:out value="${description.module.parallelVersion}" />
			</td>
			<td>
				<c:out value="${description.module.baseline}" />
			</td>
			<td>
				<c:out value="${description.module.serialNum}" />
			</td>			
			<td>
				<c:out value="${description.module.sourceMd5}" />
			</td>
			<td>
				<c:out value="${description.module.isCustom}" />
			</td>
			<td>
				<c:if test="${not empty description.module.tempVersion}">
					是（<c:out value="${description.module.tempVersion}" />）
				</c:if>
			</td>
		</tr>
	</c:forEach>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>