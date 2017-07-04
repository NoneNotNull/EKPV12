<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/list_top.jsp"%>

<script>Com_IncludeFile("jquery.js");</script>
<script src="<c:url value="/sys/person/resource/utils.js" />"></script>
<html:form action="/sys/zone/sys_zone_navigation/sysZoneNavigation.do">
	<div id="optBarDiv">
			<input type="button" onclick="updateZoneNavStatus(2);" value="启用">
			<input type="button" onclick="PersonOnUpdateStatus(1);" value="禁用">
			<input
				type="button"
				value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/zone/sys_zone_navigation/sysZoneNavigation.do?method=add" />', '_blank');">
			<input type="button" onclick="PersonOnDeleteAll();" value="<bean:message key="button.delete"/>">
	</div>
<%
	if (((java.util.List) request.getAttribute("list")).isEmpty()) {
%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
<%
	} else {
%>
	<table id="List_ViewTable">
		<tr>
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial" /></td>
				<td>
					名称
				</td>
				<td>
					状态
				</td>
				<td>
					所属设备
				</td>
				<td>
					创建人
				</td>
				<td>
					创建时间
				</td>
				<td>
					最后修改者
				</td>
				<td>
					最后修改时间
				</td>
		</tr>
		<c:forEach items="${list}" var="sysZoneNavigation"
			varStatus="vstatus">
			<tr kmss_href="<c:url value="/sys/zone/sys_zone_navigation/sysZoneNavigation.do" />?method=edit&fdId=${sysZoneNavigation.fdId}"
				data-status="${sysZoneNavigation.fdStatus}">
			<td style="width:5px"><input type="checkbox" name="List_Selected" value="${sysZoneNavigation.fdId}">
								<input type="hidden" name="showType_${sysZoneNavigation.fdId}" value="${sysZoneNavigation.fdShowType}"></td>
			<td style="width:5px">${vstatus.index+1}</td>
			<td style="width:30%"><c:out value="${sysZoneNavigation.fdName}" /></td>
			<td style="width:10%"><sunbor:enumsShow enumsType="sysPerson_fdStatus" value="${sysZoneNavigation.fdStatus}" /></td>
			<td style="width:10%"><c:out value="${sysZoneNavigation.fdShowType}" /></td>
			<td style="width:10%"><c:out value="${sysZoneNavigation.docCreator.fdName}" /></td>
			<td style="width:10%"><kmss:showDate value="${sysZoneNavigation.docCreateTime}" type="date"/></td>
			<td style="width:10%"><c:out value="${sysZoneNavigation.docAlteror.fdName}" /></td>
			<td style="width:20%"><kmss:showDate value="${sysZoneNavigation.docAlterTime}" type="datetime"/></td>
		</tr>
		</c:forEach>
	</table>
	<%
	}
	%>
</html:form>
<script>
		function updateZoneNavStatus(status) {
			if (!PersonCheckSelect()) {
				return;
			}
			var selects = []; 
			var showType = "";
			$("input[name='List_Selected']:checked").each(
				function(index, item) {
					var _type = $("[name='showType_" + item.value + "']")[0].value;
					showType += ";" + _type;
					selects.push({"value" : item.value , "showType" : _type})
				});
			if(selects.length > 2 || 
					(selects.length == 2 && selects[0].showType == selects[1].showType)) {
				alert("同一设备类型只能有一个导航启用！");
				return;
			} else {
				$('<input type="hidden" name="changeShowType" value="' + showType +'">').appendTo(document.forms[0]);
			}
			PersonOnUpdateStatus(status);
		}
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>
