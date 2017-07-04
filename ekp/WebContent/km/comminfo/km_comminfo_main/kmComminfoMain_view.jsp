<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>

<!-- 收藏机制 -->
	<c:import
		url="/sys/bookmark/include/bookmark_bar.jsp"
		charEncoding="UTF-8">
		<c:param name="fdSubject" value="${kmComminfoMainForm.docSubject}" />	
		<c:param name="fdModelId" value="${kmComminfoMainForm.fdId}" />		
		<c:param name="fdModelName"  value="com.landray.kmss.km.comminfo.model.KmComminfoMain" />		
	</c:import>
<!-- 收藏机制 -->
<!-- 显示和隐藏点评  -->
<script language="JavaScript" type="text/javascript">
	function showHide(){
		if(oreview.style.display=="none"){
			oreview.style.display="block";
		}else{
			oreview.style.display="none";
		}	
	}
</script>
<!-- 显示和隐藏点评  -->
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
		<kmss:auth requestURL="/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('kmComminfoMain.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('kmComminfoMain.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="km-comminfo" key="table.kmComminfoMain"/></p>
<center>
<TITLE> <bean:message  bundle="km-comminfo" key="kmComminfoMain.view"/> </TITLE>
<table class="tb_normal" width=95%>
	<tr>
		<%-- 主题 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoMain.docSubject"/>
		</td>
		<td width=35%>
			<c:out value="${kmComminfoMainForm.docSubject}" />
		</td>
		<%-- 类别 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-comminfo" key="table.kmComminfoCategory"/>
		</td>
		<td width=35%>
			<c:out value="${kmComminfoMainForm.docCategoryName}" />
		</td>
	</tr>
	<tr>
		<%-- 提交者 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoMain.docCreatorId"/>
		</td>
		<td width=35%>
			<c:out value="${kmComminfoMainForm.docCreatorName}" />
		</td>
		<%-- 提交时间 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoMain.docCreateTime"/>
		</td>
		<td width=35%>
			<c:out value="${kmComminfoMainForm.docCreateTime}" />
		</td>
	</tr>
	<tr>
		<!-- 排序号 -->
		<td class="td_normal_title" width=15%><bean:message
			bundle="km-comminfo" key="kmComminfoMain.fdOrder" /></td>
		<td width=35% colspan="3"><c:out
			value="${kmComminfoMainForm.fdOrder}" /></td>
	</tr>
	<%-- 文档内容 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoMain.docContent"/>
		</td>
		<td colspan="3">
			<c:out value="${kmComminfoMainForm.docContent}" escapeXml="false" />
		</td>
	</tr>
	<%-- 文档附件 --%>
	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message bundle="km-comminfo" key="kmComminfo.documentEnclosure" />
		</td>
		<td width="85%" colspan="3">
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
				<c:param name="fdKey" value="attachment"/>
				<c:param name="formBeanName" value="kmComminfoMainForm"/>
			</c:import>
		</td>
	</tr>
	
	<c:if test="${kmComminfoMainForm.docAlterTime != null}">
	<%-- 最后修改人  --%>
	<%--
	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message bundle="km-comminfo" key="kmComminfoMain.lastDocAlterorId" />
		</td>
		<td width=35%>
			<c:out value="${kmComminfoMainForm.docAlterorName}" />
		</td>
		<td width="15%" class="td_normal_title">
			<bean:message bundle="km-comminfo" key="kmComminfoMain.lastDocAlterTime" />
		</td>
		<td width=35%>
			<c:out value="${kmComminfoMainForm.docAlterTime}" />
		</td>
	</tr>
	--%>
	<%-- 所有修改信息 --%>
	
	<tr>
		<td width="15%" class="td_normal_title">			
			<a onclick="showHide(); return false;" href="">
				<bean:message bundle="km-comminfo" key="kmComminfo.alterInfo" />
			</a>			
		</td>
		<td width="85%" colspan="3">	<div style="display:none" id="oreview">		
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><bean:message bundle="km-comminfo" key="kmComminfoMain.docAlterorId" /></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<b><bean:message bundle="km-comminfo" key="kmComminfoMain.docAlterTime" /></b><br>	
				<c:forEach var="altInfo"  items="${comminfoAltInfolist}" >					
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<c:out value="${altInfo.docAlteror.fdName}"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
							<kmss:showDate value="${altInfo.docAlterTime}" type="datetime" /><br>
											
				</c:forEach></div>
		
		</td>
	</tr>
	
	</c:if>
	
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>