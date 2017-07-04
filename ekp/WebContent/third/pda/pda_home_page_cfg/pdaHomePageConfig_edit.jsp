<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
	Com_IncludeFile("doclist.js|dialog.js");
</script>
<html:form action="/third/pda/pda_home_page_cfg/pdaHomePageConfig.do">
<div id="optBarDiv">
	<c:if test="${pdaHomePageConfigForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(validate())Com_Submit(document.pdaHomePageConfigForm, 'update');"/>
	</c:if>
	<c:if test="${pdaHomePageConfigForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(validate())Com_Submit(document.pdaHomePageConfigForm, 'save');"/>
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();"/>
</div>

<p class="txttitle"><bean:message bundle="third-pda" key="table.pdaHomePageConfig"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<%-- 主页名称 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomePageConfig.fdName"/>
		</td><td width="85%">
			<xform:text property="fdName" style="width:35%"/>
		</td>
	</tr>
	<tr>
		<%-- 是否启用 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomePageConfig.fdIsDefault"/>
		</td>
		<td width="85%">
			<xform:checkbox property="fdIsDefault">
				<xform:simpleDataSource value="1" textKey="message.yes"></xform:simpleDataSource>
			</xform:checkbox>
			<br>
			<span><bean:message bundle="third-pda" key="pdaHomePageConfig.warnning.useFlag"/>
			</span>
		</td>
	</tr>
	<tr>
		<%-- 主页窗口显示条目数--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomePageConfig.fdRowsize"/>
		</td>
		<td width="85%">
			<xform:text property="fdRowsize" style="width:15%" />
		</td>
	</tr>
	<tr>
		<%-- 排序号,可为空 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomePageConfig.fdOrder"/>
		</td>
		<td width="85%">
			<xform:text property="fdOrder" style="width:15%" />
		</td>
	</tr>
	<tr>
		<%--窗口设置--%>
		<td class="td_normal_title"  width=15%>
		<bean:message bundle="third-pda" key="table.pdaHomePagePortlet"/>
		</td>
		<td colspan="3"  width=85%>
			<c:import url="/third/pda/pda_home_page_portlet/pdaHomePagePortlet_edit.jsp"
				charEncoding="UTF-8">
			</c:import>
		</td>
	</tr>
	
</table>
</center>
<script>
		function validate(){
			var fdNameObj=document.getElementsByName("fdName")[0];
			if(fdNameObj.value==""){
				alert('<bean:message bundle="third-pda" key="pdaHomePageConfig.fdName"/><bean:message bundle="third-pda" key="validate.notNull"/>');
				return false;
			}
			var tbInfo =DocList_TableInfo["TABLE_DocList"];
			if(tbInfo.lastIndex <= 1){
				alert('<bean:message bundle="third-pda" key="table.pdaHomePagePortlet"/><bean:message bundle="third-pda" key="validate.notNull"/>');
				return false;
			}
			var errorMsg="";
			for(var i=0;i<tbInfo.lastIndex-1;i++){
				var oneRowStr="";
				var moduleName=document.getElementsByName("fdPortlets["+i+"].fdModuleName")[0].value;
				if(moduleName=="")
					oneRowStr += ',"'+'<bean:message bundle="third-pda" key="pdaHomePagePortlet.fdModuleName"/>'+'"';
				var portletName=document.getElementsByName("fdPortlets["+i+"].fdName")[0].value;
				if(portletName=="")
					oneRowStr += ',"'+'<bean:message bundle="third-pda" key="pdaHomePagePortlet.fdName"/>'+'"';
				var dataUrl=document.getElementsByName("fdPortlets["+i+"].fdDataUrl")[0].value;
				if(dataUrl=="")
					oneRowStr += ',"'+'<bean:message bundle="third-pda" key="pdaHomePagePortlet.fdDataUrl"/>'+'"';
				if(oneRowStr!=""){
					errorMsg+='<bean:message bundle="third-pda" key="pdaModuleLabelList.the"/>'+(i+1)
								+'<bean:message bundle="third-pda" key="pdaModuleLabelList.row"/>'+ oneRowStr.substring(1)
								+'<bean:message bundle="third-pda" key="validate.notNull"/>\r\n';
				}
			}
			if(errorMsg!=""){
				alert(errorMsg);
				return false;
			}
			return true;
		}
</script>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>