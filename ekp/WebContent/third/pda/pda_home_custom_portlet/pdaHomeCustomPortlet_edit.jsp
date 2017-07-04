<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
	Com_IncludeFile("dialog.js");
</script>
<html:form action="/third/pda/pda_custon_page_portlet/pdaHomeCustomPortlet.do">
<div id="optBarDiv">
	<c:if test="${pdaHomeCustomPortletForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(validate())Com_Submit(document.pdaHomeCustomPortletForm, 'update');"/>
	</c:if>
	<c:if test="${pdaHomeCustomPortletForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(validate())Com_Submit(document.pdaHomeCustomPortletForm, 'save');"/>
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();"/>
</div>

<p class="txttitle"><bean:message bundle="third-pda" key="table.pdaHomeCustomPortlet"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:35%"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdType"/>
		</td>
		<td width="35%">
			<xform:select property="fdType" showPleaseSelect="false">
				<xform:simpleDataSource value="list" textKey="pdaHomeCustomPortlet.fdType.list" bundle="third-pda"/>
				<xform:simpleDataSource value="pic" textKey="pdaHomeCustomPortlet.fdType.pic" bundle="third-pda"/>
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdModuleName"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdModuleId" showStatus="noShow"/>
			<xform:text property="fdModuleName" style="width:15%" showStatus="readOnly"/>
			<a href="javascript:void(0);" onclick="Dialog_List(false, 'fdModuleId','fdModuleName', ';', 'moduleSelectBean',afterSelectModule);">
					<bean:message key="button.select"/>
			</a>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdDataUrl"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdDataUrl" style="width:70%"/> 
			<a href="javascript:void(0);" onclick="selectDataUrl();">
					<bean:message key="button.select"/>
			</a><br/>
			<span><bean:message key="pdaHomeCustomPortlet.setting.summary" bundle="third-pda"/></span>
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdTemplateClass"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdTemplateClass" style="width:70%"/> <br/>
			<span><bean:message key="pdaHomeCustomPortlet.fdTemplateClass.summary" bundle="third-pda"/></span>
		</td>
	</tr>
</table>
</center>
<script>
		function validate(){
			var htmlObj=document.getElementsByName("fdName")[0];
			if(htmlObj.value==""){
				alert('<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdName"/><bean:message bundle="third-pda" key="validate.notNull"/>');
				return false;
			}
			htmlObj=document.getElementsByName("fdModuleId")[0];
			if(htmlObj.value==""){
				alert('<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdModuleName"/><bean:message bundle="third-pda" key="validate.notNull"/>');
				return false;
			}
			htmlObj=document.getElementsByName("fdDataUrl")[0];
			if(htmlObj.value==""){
				alert('<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdDataUrl"/><bean:message bundle="third-pda" key="validate.notNull"/>');
				return false;
			}
			if(htmlObj.value.indexOf("!{cateid}")>-1){
				htmlObj=document.getElementsByName("fdTemplateClass")[0];
				if(htmlObj.value==""){
					alert('<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdTemplateClass.alert"/>');
					return false;
				}
			}
			return true;
		}
		
		function afterSelectModule(dataObj){
			if(dataObj==null)
				return ;
			var rtnData=dataObj.GetHashMapArray();
			if(rtnData[0]==null)
				return;
			var tmpObj=document.getElementsByName('fdTemplateClass')[0];
			tmpObj.value="";
			tmpObj=document.getElementsByName('fdDataUrl')[0];
			tmpObj.value="";
		}
		
		function selectDataUrl(_this){
			var moduleObj=document.getElementsByName("fdModuleId")[0];
			if(moduleObj.value==""){
				alert('<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdModuleName"/><bean:message bundle="third-pda" key="validate.notNull"/>');
				return;
			}
			Dialog_List(false,null,null, ';', 'pdaSysConfigDialog&moduleId='+ moduleObj.value,afterLabelSelectFun);
		}
		
		function afterLabelSelectFun(dataObj){
			if(dataObj==null)
				return ;
			var rtnData=dataObj.GetHashMapArray();
			if(rtnData[0]==null)
				return;
			var fdNameObj=document.getElementsByName("fdName")[0];
			fdNameObj.value=rtnData[0]["name"];
			document.getElementsByName("fdDataUrl")[0].value=rtnData[0]["url"];
			document.getElementsByName("fdTemplateClass")[0].value=rtnData[0]["tmpClass"];
			var fdTypeObj=document.getElementsByName("fdType")[0];
			for(var i=0;i<fdTypeObj.options.length;i++){
				if(fdTypeObj.options[i].value==rtnData[0]["type"])
					fdTypeObj.options[i].selected=true;
				else
					fdTypeObj.options[i].selected=false;
			}
			
		}
</script>
<html:hidden property="fdId"/>
<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>