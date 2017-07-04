<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
	function List_CheckSelect(){
		var obj = document.getElementsByName("List_Selected");
		var totalSelect=0;
		for(var i=0; i<obj.length; i++)
			if(obj[i].checked)
				totalSelect++;
		if(totalSelect==0){
			alert('<bean:message key="page.noSelect"/>');
		}
		return totalSelect;
	}
	function List_ConfirmDel(flagStr){
		var confirmDialog="";
		if(flagStr=="delete"){
			confirmDialog = '<bean:message key="page.comfirmDelete"/>';
			return List_CheckSelect()>0 && confirm(confirmDialog);
		}else{
			confirmDialog ='<bean:message key="sysAttCatalog.update.confirm" bundle="sys-attachment" />';
			var tmpInt = List_CheckSelect();
			if(tmpInt>0){
				if(tmpInt=1){
					return confirm(confirmDialog);
				}else{
					alert('<bean:message key="sysAttCatalog.update.alert" bundle="sys-attachment" />');
					return false;
				}
			}else return false;
		}
	}
</script>
<html:form action="/sys/attachment/sys_att_catalog/sysAttCatalog.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/attachment/sys_att_catalog/sysAttCatalog.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/attachment/sys_att_catalog/sysAttCatalog.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/attachment/sys_att_catalog/sysAttCatalog.do?method=update">
			<input type="button" value="<bean:message key="sysAttCatalog.setCurrent"  bundle="sys-attachment"/>"
				onclick="if(!List_ConfirmDel('update'))return;Com_Submit(document.sysAttCatalogForm, 'updateCurrent');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/attachment/sys_att_catalog/sysAttCatalog.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel('delete'))return;Com_Submit(document.sysAttCatalogForm, 'deleteall');">
		</kmss:auth>
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="sysAttCatalog.fdName">
					<bean:message bundle="sys-attachment" key="sysAttCatalog.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysAttCatalog.fdPath">
					<bean:message bundle="sys-attachment" key="sysAttCatalog.fdPath"/>
				</sunbor:column>
				<sunbor:column property="sysAttCatalog.fdIsCurrent">
					<bean:message bundle="sys-attachment" key="sysAttCatalog.fdIsCurrent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysAttCatalog" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/attachment/sys_att_catalog/sysAttCatalog.do" />?method=view&fdId=${sysAttCatalog.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysAttCatalog.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysAttCatalog.fdName}" />
				</td>
				<td>
					<c:out value="${sysAttCatalog.fdPath}" />
				</td>
				<td>
					<c:if test="${sysAttCatalog.fdIsCurrent==true}">
						<bean:message key="message.yes"/>
					</c:if>
					<c:if test="${sysAttCatalog.fdIsCurrent!=true}">
						<bean:message key="message.no"/>
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>