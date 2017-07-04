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
		<%--会议室范围 --%>
		<tr>
			<td class="td_normal_title">
				<bean:message key="kmImeetingStat.resourceScope" bundle="km-imeeting"/>
			</td>
			<td>
				<xform:dialog propertyId="queryCondIds" propertyName="queryCondNames" style="width:80%" 
					subject="${lfn:message('km-imeeting:kmImeetingStat.resourceScope')}" required="true" showStatus="edit" textarea="false">
					selectResource();
				</xform:dialog>
			</td>
		</tr>
		<%--会议类型 --%>
		<tr>
			<td class="td_normal_title">
				<bean:message key="kmImeetingMain.fdTemplate" bundle="km-imeeting"/>
			</td>
			<td>
				<xform:dialog propertyId="fdTemplateId" propertyName="fdTemplateName" style="width:80%" showStatus="edit" className="inputsgl" subject="${lfn:message('km-imeeting:kmImeetingMain.fdTemplate') }">
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
				<xform:address textarea="false" mulSelect="true" propertyId="authReaderIds" propertyName="authReaderNames" style="width:80%;" showStatus="edit">
				</xform:address>
			</td>
		</tr>
		<c:import url="/km/imeeting/km_imeeting_stat/common/kmImeetingStat_timeArea.jsp">
			<c:param name="formName" value="${param.formName }"/>
			<c:param name="selfDefine" value="false"></c:param>
		</c:import>
	</table>
	<input name="rowsize" type="hidden"/>
	<input name="pageno" type="hidden"/>
</div>
<script>
seajs.use(['lui/jquery','lui/dialog'], function($,dialog){

	//选择会议地点
	window.selectResource=function(){
		var fdResourceId=$('[name="queryCondIds"]').val();//地点ID
		var fdResourceName=$('[name="queryCondNames"]').val();//地点Name
		var url="/km/imeeting/km_imeeting_res/kmImeetingRes_showAllResDialog.jsp?"+"&resId="+fdResourceId+"&resName="+fdResourceName+"&multiSelect=true";
		dialog.iframe(url,'会议室选择',function(arg){
			if(arg){
				$('[name="queryCondIds"]').val(arg.resId);
				$('[name="queryCondNames"]').val(arg.resName);
			}
			statValidation.validate();
		},{width:800,height:500});
	};
	
	
});

</script>