<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<center>
<table class="tb_normal" width="100%" style="margin-top: -14px;">
	<tr class="tr_normal_title"><td colspan="5" align="center"><bean:message bundle="third-pda" key="table.pdaHomePagePortlet"/></td></tr>
	<tr>
		<!-- 序号 -->
		<td class="tr_normal_title" width="5%"> 
			<bean:message key="page.serial" />
		</td>
		
		<!-- 类型-->
		<td class="td_normal_title" width="20%">
			<bean:message bundle="third-pda" key="pdaHomePagePortlet.fdType"/>
		</td>
		
		<!-- 所属模块-->
		<td class="td_normal_title" width="20%">
			<bean:message bundle="third-pda" key="pdaHomePagePortlet.fdOpration"/>
		</td>
		
		<!-- 页签名称 -->
		<td class="td_normal_title" width="20%">
			<bean:message bundle="third-pda" key="pdaHomePagePortlet.fdName"/>
		</td>
		
		<!-- 内容 -->
		<td class="td_normal_title" width="35%">
			<bean:message bundle="third-pda" key="pdaHomePagePortlet.fdDataContent"/>
		</td>
	</tr>
	<c:forEach items="${pdaHomePageConfigForm.fdPortlets}"
			var="pdaHomePagePortletForm" varStatus="vstatus">
		<tr>
			<td>${vstatus.index+1}</td>
			<td><c:if test="${pdaHomePagePortletForm.fdType=='list'}">
					<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdType.list"/>
				</c:if>
				<c:if test="${pdaHomePagePortletForm.fdType=='pic'}">
					<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdType.pic"/>
				</c:if>
			</td>
			<td><c:out value="${pdaHomePagePortletForm.fdModuleName}" /></td>
			<td><c:out value="${pdaHomePagePortletForm.fdName}" /></td>
			<td><c:out value="${pdaHomePagePortletForm.fdContent}" /></td>
		</tr>
	</c:forEach>
	</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>