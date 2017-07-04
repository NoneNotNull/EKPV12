<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/third/pda/pda_module_config_main/pdaModuleConfigMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('pdaModuleConfigMain.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/third/pda/pda_module_config_main/pdaModuleConfigMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('pdaModuleConfigMain.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="third-pda" key="table.pdaModuleConfigMain"/></p>

<center>
<table id="Label_Tabel" width=95%>
 <tr LKS_LabelName="基本信息">
	<td>
<table class="tb_normal" width=95%>

    <%--  选择类型 begin--%>
	<tr>
		<td class="td_normal_title" width="15%">
			<b><bean:message bundle="third-pda" key="pdaModuleConfigView.selectViewModel"/></b>
		</td>
		<td width="85%" colspan="3">
			<img src="<c:url value='/third/pda/resource/images/${pdaModuleConfigMainForm.fdSubMenuType}.jpg'/>" 
			 title='<bean:message bundle="third-pda" key="pdaModuleConfigMain.setting.${pdaModuleConfigMainForm.fdSubMenuType}"/>'/>
		</td>
	</tr>
	<%--  选择类型 end--%>
	
	<%--  主页信息 begin--%>
	<tr>
		<td width="100%" colspan="4">
			<b><bean:message bundle="third-pda" key="pdaModuleConfigView.moduleBase"/></b>
		</td>
	</tr>
	<tr>
		<%-- 基本信息展示 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15% rowspan="5">
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdIconUrl"/>
		</td><td width="35%"  rowspan="4">
			<img src="<c:url value="${pdaModuleConfigMainForm.fdIconUrl}" />">
		</td>
	</tr>
	<tr>
		<%-- 模块前缀 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdUrlPrefix"/>
		</td><td width="35%">
			<xform:text property="fdUrlPrefix" style="width:85%" />
		</td>
	</tr>
	<tr>
		<%-- 模块分类 --%>
		<td class="td_normal_title" width=15%>
			<bean:message key="pdaModuleConfigMain.fdModuleCate" bundle="third-pda"/>
		</td>
		<td width="35%">
		    <xform:text property="fdModuleCateName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<%-- 排序号--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	<tr>
		<%-- 状态--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdStatus"/>
		</td><td width="35%">
			<xform:select property="fdStatus">
				<xform:enumsDataSource enumsType="pda_module_config_status" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.docCreator"/>
		</td><td width="35%">
			<c:out value="${pdaModuleConfigMainForm.docCreatorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="fdCreateTime" />
		</td>
	</tr>
	<c:if test="${!empty pdaModuleConfigMainForm.docAlterorName}">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="third-pda" key="pdaModuleConfigMain.docAlteror"/>
			</td><td width="35%">
				<c:out value="${pdaModuleConfigMainForm.docAlterorName}" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="third-pda" key="pdaModuleConfigMain.docAlterTime"/>
			</td><td width="35%">
				<xform:datetime property="docAlterTime" />
			</td>
		</tr>
	</c:if>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdDescription"/>
		</td>
		<td width="85%" colspan="3">
			<kmss:showText value="${pdaModuleConfigMainForm.fdDescription}" />
		</td>
	</tr>
	<%--  主页信息 end--%>
	
	<%--链接信息 begin --%>
	<c:if test="${fn:toLowerCase(pdaModuleConfigMainForm.fdSubMenuType)=='listtab'}">
		<tr id="tr_linkerArea">
			<td class="td_normal_title" width="15%">
				<bean:message bundle="third-pda" key="pdaModuleConfigMain.linkerType"/>
			</td>
			<td width="85%" colspan="3">
			    <c:if test="${pdaModuleConfigMainForm.fdLinkerType=='0' || pdaModuleConfigMainForm.fdLinkerType==null}">
			       <bean:message bundle="third-pda" key="pdaModuleConfigMain.innerLinker"/>
			    </c:if>
				<c:if test="${pdaModuleConfigMainForm.fdLinkerType=='1'}">
			       <bean:message bundle="third-pda" key="pdaModuleConfigMain.outerLinker"/>
			    </c:if>
			</td>
		</tr>
	</c:if>
	<%--链接信息 end --%>
	
	<c:if test="${fn:toLowerCase(pdaModuleConfigMainForm.fdSubMenuType)=='module'}">
		<tr>
			<%-- 模块设置 --%>
			<%--类型为module --%>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdSubModule"/>
			</td>
			<td width="85%" colspan="3">
				<c:out value="${pdaModuleConfigMainForm.fdSubModuleNames}" />
			</td>
		</tr>
	</c:if>
	
	<%--列表信息 begin --%>
	<c:if test="${fn:toLowerCase(pdaModuleConfigMainForm.fdSubMenuType)=='listtab' && pdaModuleConfigMainForm.fdLinkerType!='1'}">
		<tr>
			<td width="100%" colspan="4">
				<b><bean:message bundle="third-pda" key="pdaModuleConfigView.moduleListInfo"/></b>
			</td>
		</tr>
		<tr>
			<td colspan="4">
			    <bean:message bundle="third-pda" key="table.pdaModuleLabelList"/><br/>
				<c:import url="/third/pda/pda_module_label_list/pdaModuleLabelList_view.jsp" charEncoding="UTF-8">
				</c:import>
				<br/>
				<bean:message bundle="third-pda" key="pdaModuleLabelList.fdDataUrl.summary"/>
			</td>
		</tr>
	</c:if>
	<%--列表信息 end --%>
	
	<c:if test="${fn:toLowerCase(pdaModuleConfigMainForm.fdSubMenuType)=='doc' || (fn:toLowerCase(pdaModuleConfigMainForm.fdSubMenuType)=='listtab' && pdaModuleConfigMainForm.fdLinkerType!='1')}">
		<tr>
			<td width="100%" colspan="4">
				<b><bean:message bundle="third-pda" key="pdaModuleConfigView.moduleDocInfo"/></b>
			</td>
		</tr>
	</c:if>
	<c:if test="${fn:toLowerCase(pdaModuleConfigMainForm.fdSubMenuType)=='doc'}">
		<tr>
			<%--类型为doc--%>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdSubDoc"/>
			</td>
			<td width="85%" colspan="3">
				<c:out value="${pdaModuleConfigMainForm.fdSubDocLink}" />
			</td>
		</tr>
	</c:if>
	<c:if test="${fn:toLowerCase(pdaModuleConfigMainForm.fdSubMenuType)=='app'}">
		<tr id="tr_appAreaTitle" >
			<td width="100%" colspan="4">
				<b><bean:message bundle="third-pda" key="pdaModuleConfigMain.appSetting"/></b>
			</td>
		</tr>
		<tr id="tr_appArea" >
			<td class="td_normal_title" width=15%>
				<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdAppType"/>
			</td>
			<td width="85%" colspan="3">
				<xform:radio property="fdAppType"  showStatus="view">
					<xform:enumsDataSource enumsType="pda_app_type_enums" />
				</xform:radio>
			</td>
		</tr>
		<tr id="tr_appArea">
			<td class="td_normal_title" width=15%>
				<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdUrlScheme"/>
			</td>
			<td width="85%" colspan="3">
				<xform:text property="fdUrlScheme" style="width:85%" showStatus="view"/>
			</td>
		</tr>
		<tr id="tr_appArea">
			<td class="td_normal_title" width=15%>
				<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdUrlDownLoad"/>
			</td>
			<td width="85%" colspan="3">
				<xform:text property="fdUrlDownLoad" style="width:85%" showStatus="view"/>
			</td>
		</tr>
	</c:if>
	<c:if test="${fn:toLowerCase(pdaModuleConfigMainForm.fdSubMenuType)=='listtab' && pdaModuleConfigMainForm.fdLinkerType=='1'}">
	    <tr id="tr_ekpAreaTitle" >
			<td width="100%" colspan="4">
				<b><bean:message bundle="third-pda" key="pdaModuleConfigMain.ekpSetting"/></b>
			</td>
		</tr>
		<tr id="tr_ekpArea" >
			<td class="td_normal_title" width=15%>
				<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdEkpModuleUrl"/>
			</td>
			<td width="85%" colspan="3">
			  <xform:text property="fdEkpModuleUrl" style="width:85%"/><br/>
			  <bean:message bundle="third-pda" key="pdaModuleConfigMain.fdEkpUrlScheme.summary"/>
		    </td>
		</tr>
	</c:if>
	<c:if test="${fn:toLowerCase(pdaModuleConfigMainForm.fdSubMenuType)=='doc' || (fn:toLowerCase(pdaModuleConfigMainForm.fdSubMenuType)=='listtab' && pdaModuleConfigMainForm.fdLinkerType!='1')}">
		<tr>
			<%-- 文档类型列表 --%>
			<td colspan="4">
				<c:import url="/third/pda/pda_module_config_view/pdaModuleConfigView_view.jsp"
					charEncoding="UTF-8">
				</c:import>
			</td>
		</tr>
	</c:if>
</table>
</td>
</tr>
<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
		<td>
		<table
			class="tb_normal"
			width=100%>
			<c:import
				url="/sys/right/right_view.jsp"
				charEncoding="UTF-8">
				<c:param
						name="formName"
						value="pdaModuleConfigMainForm" />
				<c:param
						name="moduleModelName"
						value="com.landray.kmss.third.pda.model.PdaModuleConfigMain" />
			</c:import>
		</table>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>