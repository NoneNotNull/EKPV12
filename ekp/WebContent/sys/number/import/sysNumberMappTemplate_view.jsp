<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request"></c:set>
<c:set var="sysNumberMainMappForm" value="${mainModelForm.sysNumberMainMappForm}" scope="request"/>
<c:set var="sysNumberMainMappPrefix" value="sysNumberMainMappForm." scope="request"/>

<c:if test="${sysNumberMainMappForm!=null }">
	<script type="text/javascript">
		Com_IncludeFile("doclist.js");
	</script>
	<html:hidden property="${sysNumberMainMappPrefix}fdNumberId" value="1"/>
	<html:hidden property="${sysNumberMainMappPrefix}fdMainModelName" value="${param.modelName}"/>
	<html:hidden property="${sysNumberMainMappPrefix}fdContent" value=""/>
	<table class="tb_normal" width="100%">
		<tr>
			<td width="25%" class="td_normal_title" valign="top">
				<bean:message bundle="sys-number" key="sysNumberMainMapp.tab.inType" />
			</td>
			<td width="75%">
				<c:choose>
					<c:when test="${sysNumberMainMappForm.fdType=='0'}">
						<bean:message bundle="sys-number" key="sysNumberMainMapp.tab.inType0" /> 
					</c:when>
					<c:when test="${sysNumberMainMappForm.fdType=='1'}">
						<bean:message bundle="sys-number" key="sysNumberMainMapp.tab.inType1" />
					</c:when>
					<c:when test="${sysNumberMainMappForm.fdType=='2'}">
						<bean:message bundle="sys-number" key="sysNumberMainMapp.tab.inType2" /> 
					</c:when>
					<c:when test="${sysNumberMainMappForm.fdType=='3'}">
						<bean:message bundle="sys-number" key="sysNumberMainMapp.tab.inType3" /> 
					</c:when>
				</c:choose>
			</td>
		</tr>
		<c:if  test="${sysNumberMainMappForm.fdType=='1'}">
			<tr id="TR_ID_sysNumberMainMapp_numberId"> 
				<td width="25%" class="td_normal_title" valign="top">
					<bean:message bundle="sys-number" key="sysNumberMainMapp.tab.numberTemplateName" />
				</td>
				<td width="75%">
					<xform:select property="sysNumberMainMappNumberId" onValueChange="selectChange" 
						value="${sysNumberMainMappForm.fdNumberId}">
						<xform:beanDataSource serviceBean="sysNumberMainService"
							selectBlock="fdId,fdName" orderBy="fdOrder" 
							whereBlock="fdTemplateFlag='0' and fdModelName='${param.modelName}'" />
					</xform:select>
				</td>
			</tr>
		</c:if>
		<c:if  test="${sysNumberMainMappForm.fdType=='1' || sysNumberMainMappForm.fdType=='2'}">
			<tr id="TR_ID_sysNumberMainMapp_showNumber" >
				<td colspan="2" onresize="number_LoadIframe();">
					 <iframe src="" width="100%" height="100%" style="min-height:100px;" frameborder="0" scrolling="no">
					 </iframe>
				</td>
			</tr>
		</c:if>
	</table>
	<c:if  test="${sysNumberMainMappForm.fdType=='1' || sysNumberMainMappForm.fdType=='2'}">
	<script type="text/javascript">
		function number_LoadIframe(){
			Doc_LoadFrame("TR_ID_sysNumberMainMapp_showNumber", 
					'<c:url value="/sys/number/sys_number_main/sysNumberMain.do?method=view&isCustom=1&fdId=${sysNumberMainMappForm.fdNumberId}"/>');
		}
	</script>
	</c:if>
</c:if>