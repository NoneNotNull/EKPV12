<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<center>
<table class="tb_normal" width="100%" style="margin-top: -14px;TABLE-LAYOUT: fixed;	WORD-BREAK: break-all;">
	<tr>
		<!-- 序号 -->
		<td class="tr_normal_title" width="25px;"> 
			<bean:message key="page.serial" />
		</td>
		<td width="8%" class="td_normal_title">
			<bean:message bundle="third-pda" key="pdaModuleLabelList.fdIsLink" />
		</td>
		<!-- 页签名称 -->
		<td class="td_normal_title" width="20%">
			<bean:message bundle="third-pda" key="pdaModuleLabelList.fdName"/>
		</td>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="third-pda" key="pdaModuleLabelList.fdNameExap"/>
		</td>
		<!-- 数据源 -->
		<td class="td_normal_title" width="50%">
			<bean:message bundle="third-pda" key="pdaModuleLabelList.fdDataUrl"/>
		</td>
	</tr>
	<c:forEach items="${pdaModuleConfigMainForm.fdLabelList}"
			var="pdaModuleLabelListForm" varStatus="vstatus">
		<tr>
			<td>${vstatus.index+1}</td>
			<td width="4%">
				<c:if test="${pdaModuleLabelListForm.fdIsLink=='1'}"><bean:message key="message.yes" /></c:if>
				<c:if test="${pdaModuleLabelListForm.fdIsLink!='1'}"><bean:message key="message.no" /></c:if>
			</td>
			<td><c:out value="${pdaModuleLabelListForm.fdName}" /></td>
			<td>${pdaModuleLabelListForm.fdName}<c:if test="${pdaModuleLabelListForm.fdCountUrl!=null && pdaModuleLabelListForm.fdCountUrl!=''}">(10)</c:if></td>
			<td><c:out value="${pdaModuleLabelListForm.fdDataUrl}" /></td>
		</tr>
	</c:forEach>
	</table>
</center>
