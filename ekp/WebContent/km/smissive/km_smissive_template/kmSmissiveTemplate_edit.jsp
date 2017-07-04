<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<kmss:windowTitle
	subjectKey="km-smissive:table.kmSmissiveTemplate"
	moduleKey="km-smissive:table.kmSmissiveMain" />
<script language="JavaScript">
	Com_IncludeFile("dialog.js|ajax.js|jquery.js");

	var callBackreturnValue=true;
	
	function fn_checkUniqueCodePre() {
	     createXmlHttpRequest();
	     if (xmlHttpRequest) {
	       	xmlHttpRequest.onreadystatechange = ajaxCallBack;
	       	var url = "kmSmissiveTemplate.do?method=checkUniqueCodePre&fdId=${kmSmissiveTemplateForm.fdId}";
	       	//url = url + "&fdCodePre=" + encodeURIComponent(document.getElementsByName("fdCodePre")[0].value);
	       	url = url + "&fdCodePre=" + document.getElementsByName("fdCodePre")[0].value;
	       	url = encodeURI(url);
	       	url = encodeURI(url);
	        //alert(url);
	        xmlHttpRequest.open("GET", url, true);
	        xmlHttpRequest.setRequestHeader("Content-Type", "text/html;charset=UTF-8" );
	        xmlHttpRequest.send();
	      }
	}
	
	function ajaxCallBack(){
		if (xmlHttpRequest.readyState == 4) { // Complete
		     if (xmlHttpRequest.status == 200) { // OK response
				var responseText = xmlHttpRequest.responseText;
				if(responseText == 'false'){
					alert('<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdCodePre.check"/>');
					document.getElementsByName("fdCodePre")[0].select();
					callBackreturnValue=false;
				}
		     } else {
		       alert("Problem with server response:\n " + xmlHttpRequest.statusText);
		     }
	    }
	}
	function showBaseLabel(){
		setTimeout("Doc_SetCurrentLabel('Label_Tabel', 1, true);", 300);
			// 添加标签切换事件
			var table = document.getElementById("Label_Tabel");
			if(table != null && window.Doc_AddLabelSwitchEvent){
				Doc_AddLabelSwitchEvent(table, "aaa");
			}
	}
	function aaa(tableName, index){
		var trs = document.getElementById(tableName).rows;
		if(trs[index].id =="tr_content"){
			$("#missiveButtonDiv").show();
			$("#content").css({
				left:'34px',
				top:'135px',
				width:'95%',
				height:'550px'

			});
		}else{
			$("#missiveButtonDiv").hide();
			$("#content").css({
				left:'0px',
				top:'0px',
				width:'0px',
				height:'0px'

			});
		}
	}
	function validateSubmitForm(){
		//检查编号规则是否已经定义过；
		
	}
	Com_AddEventListener(window,"load",showBaseLabel);
</script>

<html:form action="/km/smissive/km_smissive_template/kmSmissiveTemplate.do" onsubmit="return validateKmSmissiveTemplateForm(this);">

		<%--简单分类按钮 --%>
		<c:import url="/sys/simplecategory/sys_simple_category/sysCategoryMain_edit_button.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveTemplateForm" />
		</c:import>

<p class="txttitle"><bean:message  bundle="km-smissive" key="table.kmSmissiveTemplate"/></p>

<center>
<html:hidden property="fdId"/>

						<div id="content" style="position:absolute;height: 0px;width: 0px">
						<%
							// 金格启用模式
							if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()) {
								pageContext.setAttribute("sysAttMainUrl", "/sys/attachment/sys_att_main/jg/sysAttMain_edit.jsp");
							} else {
								pageContext.setAttribute("sysAttMainUrl", "/sys/attachment/sys_att_main/sysAttMain_edit.jsp");
							}
						%>
						<c:import url="${sysAttMainUrl}" charEncoding="UTF-8">
							<c:param
								name="fdKey"
								value="mainContent" />
							<c:param
								name="fdAttType"
								value="office" />
							<c:param
								name="fdModelId"
								value="${kmSmissiveTemplateForm.fdId}" />
							<c:param
								name="buttonDiv"
								value="missiveButtonDiv" />
							<c:param 
								name="isTemplate"
								value="true"/>
							<c:param
								name="fdModelName"
								value="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" />
						</c:import>
						</div>

<table id="Label_Tabel" width="95%" LKS_LabelDefaultIndex="3">
	<%-- 类别 --%>
	<c:import url="/sys/simplecategory/include/sysCategoryMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveTemplateForm" />
			<c:param name="requestURL" value="/km/smissive/km_smissive_template/kmSmissiveTemplate.do?method=add" />
			<c:param name="fdModelName" value="${param.fdModelName}" />
	</c:import>
	
	<tr LKS_LabelName="<bean:message bundle="km-smissive" key="kmSmissiveTemplate.label.baseinfo" />"><td>
	
		<table class="tb_normal" width=100%>
			<% if(!com.landray.kmss.sys.number.util.NumberResourceUtil.isModuleNumberEnable("com.landray.kmss.km.smissive.model.KmSmissiveMain")){ %>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdCodePre"/>
				</td><td width=85% colspan="3">
					<html:text property="fdCodePre" style="width:90%" onblur="fn_checkUniqueCodePre();"/>
					<span class="txtstrong">*</span>
					<br>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdCodePre.describeone"/>
					<br>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdCodePre.describetwo"/>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdYear"/>
				</td><td width=35%>
					<html:text property="fdYear"/>
					<span class="txtstrong">*</span>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdYear.describetwo"/>
				</td>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdCurNo"/>
				</td><td width=35%>
					<html:text property="fdCurNo"/>
					<span class="txtstrong">*</span>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdCurNo.describetwo"/>
				</td>
			</tr>
			<%} %>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpTitle"/>
				</td><td width=85% colspan="3">
					<html:text property="fdTmpTitle" style="width:90%"/>
					<span class="txtstrong">*</span>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpUrgency"/>
				</td><td width=35%>
					<sunbor:enums property="fdTmpUrgency"
								enumsType="km_smissive_urgency" elementType="select"
								bundle="km-smissive" />
				</td>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpSecret"/>
				</td><td width=35%>
					<sunbor:enums property="fdTmpSecret"
								enumsType="km_smissive_secret" elementType="select"
								bundle="km-smissive" />
				</td>
			</tr>
			
			
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpMainDept"/>
				</td><td width=35%>
					<html:hidden property="fdTmpMainDeptId" />
					<html:text property="fdTmpMainDeptName" styleClass="inputsgl" readonly="true" />
					<a href="javascript:void(0)"
					onclick="Dialog_Address(false, 'fdTmpMainDeptId','fdTmpMainDeptName', ';', ORG_TYPE_ORGORDEPT);"><bean:message key="dialog.selectOrg" /></a>
				</td>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpIssuer"/>
				</td><td width=35%>
					<html:hidden property="fdTmpIssuerId" />
					<html:text property="fdTmpIssuerName"	styleClass="inputsgl" readonly="true" />
					<a href="javascript:void(0)"
						onclick="Dialog_Address(false, 'fdTmpIssuerId','fdTmpIssuerName', ';', ORG_TYPE_PERSON);">
					<bean:message key="dialog.selectOrg" />
					</a>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpSendDept"/>
				</td><td colspan="3" width=35%>
					<html:hidden property="fdTmpSendDeptIds" />
					<html:textarea property="fdTmpSendDeptNames" readonly="true" style="width:90%;height:90px" styleClass="inputmul" /> 					
					
					<a href="javascript:void(0)"
					onclick="Dialog_Address(true, 'fdTmpSendDeptIds','fdTmpSendDeptNames', ';', ORG_TYPE_ORGORDEPT);"><bean:message key="dialog.selectOrg" /></a>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpCopyDept"/>
				</td><td colspan="3" width=35%>
					<html:hidden property="fdTmpCopyDeptIds" />
					<html:textarea property="fdTmpCopyDeptNames" readonly="true" style="width:90%;height:90px" styleClass="inputmul" /> 
					
					<a href="javascript:void(0)"
					onclick="Dialog_Address(true, 'fdTmpCopyDeptIds','fdTmpCopyDeptNames', ';', ORG_TYPE_ORGORDEPT);"><bean:message key="dialog.selectOrg" /></a>
				</td>
				
			</tr>
			
			
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpFlowFlag"/>
				</td><td width=85% colspan="3">
					<html:checkbox name="kmSmissiveTemplateForm" property="fdTmpFlowFlag">
						<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.radio.true"/>
					</html:checkbox>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.radio.describe"/>
				</td>
			</tr>
			
			<!-- 标签机制 -->
			<c:import url="/sys/tag/include/sysTagTemplate_edit.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="kmSmissiveTemplateForm" />
				<c:param name="fdKey" value="smissiveDoc" /> 
			</c:import>
			<!-- 标签机制 -->
		</table>
	</td></tr>
	
	<!-- 加入机制 -->
	<%-- 以下代码为在线编辑的代码 --%>
	<tr id="tr_content" LKS_LabelName="<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.label.content"/>">
		<td id="td_content">
		   <div>
                        <div id="missiveButtonDiv" style="text-align:right">
							&nbsp;
						   <a href="javascript:void(0);" class="attbook" onclick="Com_OpenWindow(Com_Parameter.ContextPath+'km/smissive/bookMarks.jsp','_blank');">
					        <bean:message key="kmSmissiveMain.bookMarks.title" bundle="km-smissive"/> 
					       </a>
						</div>
			</div>
		  
		</td>
		
	</tr>
	<%-- 以上代码为在线编辑的代码 --%>
		
	<%-- 以下代码为嵌入流程模板标签的代码 --%>
	<c:import url="/sys/workflow/include/sysWfTemplate_edit.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveTemplateForm" />
		<c:param name="fdKey" value="smissiveDoc" />
		<c:param name="fdModelName"
			value="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" />
		<c:param name="messageKey" value="km-smissive:kmSmissive.label.flow" />
	</c:import>
	<%-- 以上代码为嵌入流程模板标签的代码 --%>
	
	<%-- 以下代码为嵌入默认权限模板标签的代码 --%>
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />"><td>
		<table class="tb_normal" width=100%>
			<c:import url="/sys/right/tmp_right_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmSmissiveTemplateForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" />
			</c:import>
		</table>
	</td></tr>
	<%-- 以上代码为嵌入默认权限模板标签的代码 --%>
	
	<%----发布机制开始--%>
	<c:import url="/sys/news/include/sysNewsPublishCategory_edit.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveTemplateForm" />
		<c:param name="fdKey" value="smissiveDoc" /> 
		<c:param name="messageKey" value="km-smissive:kmSmissiveTemplate.label.publish" />
	</c:import>
	<%----发布机制结束--%>
	
	<%-- 以下代码为嵌入关联机制的代码 --%>
	<tr	LKS_LabelName="<bean:message bundle="sys-relation" key="sysRelationMain.tab.label" />">
		<c:set var="mainModelForm" value="${kmSmissiveTemplateForm}" scope="request" />
		<c:set var="currModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" scope="request"/>
		<td>
			<%@ include	file="/sys/relation/include/sysRelationMain_edit.jsp"%>
		</td>
	</tr>
	<%-- 以上代码为嵌入关联机制的代码 --%>
	
	<%----编号机制开始--%>
	<% if(com.landray.kmss.sys.number.util.NumberResourceUtil.isModuleNumberEnable("com.landray.kmss.km.smissive.model.KmSmissiveMain")){ %>
	<c:import url="/sys/number/include/sysNumberMappTemplate_edit.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveTemplateForm" />
		<c:param name="modelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain"/>
	</c:import>
	<%} %>
	<%----编号机制结束--%>

</table>

</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="kmSmissiveTemplateForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>

<script language="javascript" for="window" event="onload">
	//var obj = document.getElementsByName("mainContent_bookmark");	//公司产品JS库有问题，其中生成的按钮没有ID属性，导致ie6不能够用该语句查找
	//obj[0].style.display = "none";
	var tt = document.getElementsByTagName("INPUT");
	for(var i=0;i<tt.length;i++){
		
		if(tt[i].name == "mainContent_showRevisions"){
			tt[i].style.display = "none";
		}
		if(tt[i].name == "mainContent_printPreview"){
			tt[i].style.display = "none";
		}
	}

	Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function(){
		var fdCodePre=document.getElementsByName("fdCodePre")[0];
		var fdYear=document.getElementsByName("fdYear")[0];
		var fdCurNo=document.getElementsByName("fdCurNo")[0];
		if(fdCodePre!=null)
		{
			var txt=fdCodePre.value;
			if(txt.length==0)
			{
				alert('编号规则不能为空！');
				return false;
			}
			else if(txt.indexOf('%年号%')==-1 || txt.indexOf('%流水号%')==-1)
			{
				alert('编号规则不规范，请参考示例：蓝凌[%年号%]%流水号%号  进行调整');
				return false;
			}
			else
			{
				fn_checkUniqueCodePre();
				if(!callBackreturnValue)
				{
					return false;
				}
			}
		}

		if(fdYear!=null)
		{
			var txt2=fdYear.value;
			if(isNotNumFour(txt2))
			{
				alert('当前年号数据格式不正确，请输入四位数字');
				return false;
			}
			
		}

		if(fdCurNo!=null)
		{
			var txt3=fdCurNo.value;
			if(isNotNumOne(txt3))
			{
				alert('当前流水号数据格式不正确，请输入数字');
				return false;
			}
			
		}
		
		return true;
	};
	function isNotNumFour(str) {
		var patrn=/^[0-9]{4}$/; 
		if (!patrn.exec(str)) return true ;
		else
			return false ;
	}
	function isNotNumOne(str) {
		var patrn=/^[0-9]{1,}$/; 
		if (!patrn.exec(str)) return true ;
		else
			return false ;
	}
	
</script>