<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
Com_IncludeFile("dialog.js");
function confirmDelete(msg){
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/property/sys_property_template/sysPropertyTemplate.do?method=add">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/property/sys_property_template/sysPropertyTemplate.do" />?method=add&fdModelName=com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge');">
	</kmss:auth>
</div>
<center>
	<table class="tb_normal" width="85%">
		<c:forEach items="${propertyList}" var="sysPropertyTemplate" varStatus="vstatusProp">
		<c:set var="flag" value="0" />
		<tr>
			<td class="td_normal_title">
				以下一级目录引用了模板：<c:out value="${sysPropertyTemplate.fdName}" />
				[<a href="javascript:void(0)" onclick="Com_OpenWindow('<c:url value="/sys/property/sys_property_template/sysPropertyTemplate.do" />?method=edit&fdId=${sysPropertyTemplate.fdId}','_black');">编辑模板</a>]
				[<a href="javascript:void(0)" onclick="if(!confirmDelete())return;Com_OpenWindow('<c:url value="/sys/property/sys_property_template/sysPropertyTemplate.do" />?method=delete&fdId=${sysPropertyTemplate.fdId}','_self');">删除模板</a>]
			</td>
		</tr>
		<tr>
			<td>
				<c:forEach items="${templateList}" var="kmsMultidocTemplate" varStatus="vstatusTemplate">
					<c:if test="${kmsMultidocTemplate.sysPropertyTemplate.fdId == sysPropertyTemplate.fdId}">
						<c:set var="flag" value="1" />
						<c:out value="${kmsMultidocTemplate.fdName}" />
						[<a href="javascript:void(0)" onclick="">移动</a>]
						<br />
					</c:if>
				</c:forEach>
				<c:if test="${flag =='0'}">
				还没有目录引用 
				</c:if>
			</td>
		</tr>
		</c:forEach>
	</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
