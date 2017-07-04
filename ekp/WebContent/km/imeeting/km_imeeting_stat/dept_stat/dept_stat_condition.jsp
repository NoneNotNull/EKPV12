<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div id="div_condtionSection">
	<table class="tb_simple" width="100%">
		<%--统计名称 --%>
		<tr>
			<td width="20%" class="td_normal_title">
				<bean:message key="kmImeetingStat.fdName" bundle="km-imeeting"/>
			</td>
			<td width="80%">
				<xform:text property="fdName" style="width:80%" showStatus="edit"
				  	required="true" subject="${lfn:message('km-imeeting:kmImeetingStat.fdName')}">
				</xform:text>
				<input type="hidden" name="fdType" value="${fdType}"/>
			</td>
		</tr>
		<%--组织范围 --%>
		<tr>
			<td class="td_normal_title">
				<bean:message key="kmImeetingStat.deptScope" bundle="km-imeeting"/>
			</td>
			<td>
				<xform:address propertyId="queryCondIds" propertyName="queryCondNames" style="width:80%" mulSelect="true" 
					subject="${lfn:message('km-imeeting:kmImeetingMain.docDept')}" showStatus="edit"
			        orgType="ORG_TYPE_ORGORDEPT"  textarea="false" required="true"></xform:address>
			</td>
		</tr>
		<%--会议类型 --%>
		<tr>
			<td class="td_normal_title">
				<bean:message key="kmImeetingMain.fdTemplate" bundle="km-imeeting"/>
			</td>
			<td>
				<xform:dialog propertyId="fdTemplateId" propertyName="fdTemplateName" style="width:80%" showStatus="edit"
					 className="inputsgl" subject="${lfn:message('km-imeeting:kmImeetingMain.fdTemplate') }">
				  seajs.use(['sys/ui/js/dialog'], function(dialog) {
					dialog.category('com.landray.kmss.km.imeeting.model.KmImeetingTemplate','fdTemplateId','fdTemplateName',true,null,null,null,null,null,false);
				  });
				</xform:dialog>
			</td>
		</tr>
		<%--阅读者 --%>
		<tr>
			<td class="td_normal_title"><bean:message bundle="sys-right" key="right.read.authReaders" /></td>
			<td>
				<xform:address textarea="false" mulSelect="true" showStatus="edit"
					propertyId="authReaderIds" propertyName="authReaderNames" style="width:80%;">
				</xform:address>
			</td>
		</tr>
		<c:import url="/km/imeeting/km_imeeting_stat/common/kmImeetingStat_timeArea.jsp">
			<c:param name="formName" value="${param.formName }"/>
		</c:import>
	</table>
	<input name="rowsize" type="hidden"/>
	<input name="pageno" type="hidden"/>
</div>