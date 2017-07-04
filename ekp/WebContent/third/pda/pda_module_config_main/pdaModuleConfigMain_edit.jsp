<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
	Com_IncludeFile("calendar.js|dialog.js|doclist.js|jquery.js|json2.js");
</script>
<html:form action="/third/pda/pda_module_config_main/pdaModuleConfigMain.do">
<div id="optBarDiv">
	<c:if test="${pdaModuleConfigMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(validate())Com_Submit(document.pdaModuleConfigMainForm, 'update');">
	</c:if>
	<c:if test="${pdaModuleConfigMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(validate())Com_Submit(document.pdaModuleConfigMainForm, 'save');">
		<%--
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if(validate())Com_Submit(document.pdaModuleConfigMainForm, 'saveadd');">
			 --%>
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="third-pda" key="table.pdaModuleConfigMain"/></p>

<center>
<table id="Label_Tabel" width=95%>
 <tr LKS_LabelName="基本信息">
	<td>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width="15%">
			<b><bean:message bundle="third-pda" key="pdaModuleConfigView.selectViewModel"/></b>
		</td>
		<%--模块类型--%>
		<td width="85%" colspan="3">
			<xform:text property="fdSubMenuType" showStatus="noShow" value="${pdaModuleConfigMainForm.fdSubMenuType}"/>
			<nobr>
				<label title='<bean:message bundle="third-pda" key="pdaModuleConfigMain.setting.listTab"/>'>
					<input type="radio" name="_fdSubMenuType" ${pdaModuleConfigMainForm.fdSubMenuType=='listTab'?'checked':''} value="listTab" onclick="onCommonTypeChange();"/>
					<img src="<c:url value='/third/pda/resource/images/listTab.jpg'/>" title='<bean:message bundle="third-pda" key="pdaModuleConfigMain.setting.listTab"/>'/>
				</label>&nbsp;&nbsp;&nbsp;&nbsp;
				<label title='<bean:message bundle="third-pda" key="pdaModuleConfigMain.setting.doc"/>'>
					<input type="radio" name="_fdSubMenuType" ${pdaModuleConfigMainForm.fdSubMenuType=='doc'?'checked':''} value="doc" onclick="onCommonTypeChange();"/>
					<img src="<c:url value='/third/pda/resource/images/doc.jpg'/>" title='<bean:message bundle="third-pda" key="pdaModuleConfigMain.setting.doc"/>'/>
				</label>&nbsp;&nbsp;&nbsp;&nbsp;
				<label title='<bean:message bundle="third-pda" key="pdaModuleConfigMain.setting.app"/>'>
					<input type="radio" name="_fdSubMenuType" ${pdaModuleConfigMainForm.fdSubMenuType=='app'?'checked':''} value="app" onclick="onCommonTypeChange();"/>
					<img src="<c:url value='/third/pda/resource/images/app.jpg'/>" title='<bean:message bundle="third-pda" key="pdaModuleConfigMain.setting.app"/>'/>
				</label>&nbsp;&nbsp;&nbsp;&nbsp;
			</nobr>
		</td>
	</tr>
	<tr>
		<td width="100%" colspan="4">
			<b><bean:message bundle="third-pda" key="pdaModuleConfigView.moduleBase"/></b>
		</td>
	</tr>
	<tr>
		<%-- 模块名称设置 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%"/>
			<a onclick="selectModule();return false;" href=""><bean:message key="dialog.selectOther" /></a>
		</td>
		<td class="td_normal_title" width=15%  rowspan="5">
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdIconUrl"/>
		</td>
		<td width="35%" rowspan="4">
			<input type="hidden" name="fdIconUrl" value="${pdaModuleConfigMainForm.fdIconUrl}">
			<img style="cursor:hand" width=57 height=58 onclick="selectIcon('module',document.getElementsByName('fdIconUrl')[0],this);" src="<c:url value="${pdaModuleConfigMainForm.fdIconUrl}" />" ></img>
		</td>
	</tr>
	<tr>
		<%-- 模块前缀,可为空 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdUrlPrefix"/>
		</td>
		<td width="35%">
			<xform:text property="fdCountUrl" showStatus="noShow"/>
			<xform:text property="fdUrlPrefix" style="width:35%" showStatus="readOnly"/>
		</td>
	</tr>
	<tr>
		<%-- 模块分类 --%>
		<td class="td_normal_title" width=15%>
			<bean:message key="pdaModuleConfigMain.fdModuleCate" bundle="third-pda"/>
		</td>
		<td width="35%">
			<html:hidden property="fdModuleCateId"/>
			<html:text styleClass="inputsgl" readonly="true" property="fdModuleCateName"/>
			<a href="#"
						onclick="Dialog_Tree(false, 
				 'fdModuleCateId', 
				 'fdModuleCateName', 
				 ',', 
				 'pdaModuleCateTreeService', 
				 '<bean:message key="pdaModuleConfigMain.fdModuleCate" bundle="third-pda"/>',
				  null, null,
				   null, null, null,
				   '<bean:message key="phone.button.template" bundle="third-pda"/>')"><bean:message key="button.select"/> </a>
		</td>
	</tr>
	<tr>
		<%-- 模块排序号,可为空 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdOrder"/>
		</td>
		<td width="35%">
			<xform:text property="fdOrder" style="width:35%" />
		</td>
	</tr>
	<tr>
		<%-- 模块状态,可为空 ,暂不用--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdStatus"/>
		</td><td width="35%">
			<xform:radio property="fdStatus">
				<xform:enumsDataSource enumsType="pda_module_config_status" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<%--模块描述 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdDescription"/>
		</td>
		<td width="85%" colspan="3">
			<xform:textarea property="fdDescription" style="width:85%"/>
		</td>
	</tr>
	
	<%--模块类型 区域  --%>
	<tr id="tr_linkerArea">
		<td class="td_normal_title" width="15%">
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.linkerType"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdLinkerType" showStatus="noShow" value="${pdaModuleConfigMainForm.fdLinkerType}"/>
			<nobr>
				<label> 
				    <input type="radio" name="_fdLinkerType" ${pdaModuleConfigMainForm.fdLinkerType=='0' || pdaModuleConfigMainForm.fdLinkerType==null ? 'checked':''} value="0" onclick="onCommonTypeChange();"/>
				    <bean:message bundle="third-pda" key="pdaModuleConfigMain.innerLinker"/>
				</label>&nbsp;&nbsp;&nbsp;&nbsp;
				<label>
					<input type="radio" name="_fdLinkerType" ${pdaModuleConfigMainForm.fdLinkerType=='1'?'checked':''} value="1" onclick="onCommonTypeChange();"/>
					<bean:message bundle="third-pda" key="pdaModuleConfigMain.outerLinker"/>
				</label>&nbsp;&nbsp;&nbsp;&nbsp;
			</nobr>
		</td>
	</tr>
	
	<%--类型为module --%>
	<tr id="tr_moduleArea">
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdSubModule"/>
		</td>
		<td width="85%" colspan="3">
				<html:hidden property="fdSubModuleIds" /> 
				<html:textarea	property="fdSubModuleNames" readonly="true" style="width:85%;height:90px" styleClass="inputmul" /> 
				<a href="javascript:void(0);" onclick="selectModuleFromPda();">
				<bean:message key="dialog.selectOrg" /></a>
		</td>
	</tr>
	
	<%--类型为listTab--%>
	<tr id="tr_listAreaTitle">
		<td width="100%" colspan="4">
			<b><bean:message bundle="third-pda" key="pdaModuleConfigView.moduleListInfo"/></b>
		</td>
	</tr>
	<tr id="tr_listArea">
		<td colspan="4" width=100%>
			<bean:message bundle="third-pda" key="table.pdaModuleLabelList"/><br/>
			<c:import url="/third/pda/pda_module_label_list/pdaModuleLabelList_edit.jsp"
				charEncoding="UTF-8">
			</c:import>
			<br/>
			<bean:message bundle="third-pda" key="pdaModuleLabelList.fdDataUrl.summary"/>
		</td>
	</tr>
	
	<%--类型为doc--%>
	<tr id="tr_docAreaTitle" >
		<td width="100%" colspan="4">
			<b><bean:message bundle="third-pda" key="pdaModuleConfigView.moduleDocInfo"/></b>
		</td>
	</tr>
	<tr id="tr_docArea">
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdSubDoc"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdSubDocLink" style="width:85%"/>
			<a href="javascript:void(0);" onclick="selectDataUrl();">
					<bean:message key="button.select"/>
			</a>
		</td>
	</tr>
	
	<%--类型为app--%>
	<tr id="tr_appAreaTitle" >
		<td width="100%" colspan="4">
			<b><bean:message bundle="third-pda" key="pdaModuleConfigMain.appSetting"/></b>
		</td>
	</tr>
	<tr id="tr_appArea">
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdAppType"/>
		</td>
		<td width="85%" colspan="3">
			<xform:radio property="fdAppType">
				<xform:enumsDataSource enumsType="pda_app_type_enums" />
			</xform:radio>
		</td>
	</tr>
	<tr id="tr_appArea">
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdUrlScheme"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdUrlScheme" style="width:85%"/><br>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdUrlScheme.summary"/>
		</td>
	</tr>
	<tr id="tr_appArea">
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdUrlDownLoad"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdUrlDownLoad" style="width:85%"/>
		</td>
	</tr>
	
	<%--类型为ekp集成--%>
	<tr id="tr_ekpArea">
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdEkpModuleUrl"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdEkpModuleUrl" style="width:85%"/><br/>
			<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdEkpUrlScheme.summary"/>
		</td>
	</tr>
	
	<%-- 文档页签列表设置 --%>
	<tr id="tr_docLabelArea">
		<td colspan="4" width=100%>
			<bean:message bundle="third-pda" key="table.pdaModuleLabelView"/><br/>
			<table  class="tb_normal" width="100%" id="TABLE_DocList_Next">
				<tr>
					<td width="20%" class="td_normal_title"><bean:message key="page.serial" /></td>
					<td class="td_normal_title"><bean:message bundle="third-pda" key="pdaModuleConfigView.fdName"/></td>
					<td class="td_normal_title" width="120px;"  align="center">
						<img src="${KMSS_Parameter_StylePath}icons/add.gif"
							style="cursor:pointer" onclick="addDocCfgRow('TABLE_DocList_Next');"  title="<bean:message key="button.insert"/>">
					</td>
				</tr>
				<!--基准行-->
				<tr KMSS_IsReferRow="1" style="display:none">
					<td KMSS_IsRowIndex="1">${index+1}</td>
					<td>
						<input type="hidden" name="fdViewItems[!{index}].fdId" />
						<input type="hidden" name="fdViewItems[!{index}].fdOrder" />
						<input type="hidden" name="fdViewItems[!{index}].fdItemsVal" />
						<input type="hidden" name="fdViewItems[!{index}].fdKeyword"/>
						<input type="hidden" name="fdViewItems[!{index}].fdModelName" />
						<input type="hidden" name="fdViewItems[!{index}].fdModuleId" value="${pdaModuleConfigMainForm.fdId}"/>
						<input type="hidden" name="fdViewItems[!{index}].fdReadingModel" />
						<input type="hidden" name="fdViewItems[!{index}].fdNewsModelCfgInfo" />
						<input name="fdViewItems[!{index}].fdName" class="inputsgl" style="width: 90%" />
						<div name="docCfgDiv"></div>
					</td>
					<td align="center">
						<input type="hidden" name="!{index}"> 
						<a href="javascript:void(0);" onclick="editDocCfgRow(this);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/edit.gif" border="0" border="0" title="<bean:message key="button.edit"/>" /></a>
						<a href="javascript:void(0);" onclick="deleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/delete.gif" border="0" border="0" title="<bean:message key="button.delete"/>" /></a>
						<a href="javascript:void(0);" onclick="moveRow(-1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/up.gif" border="0" title="<bean:message key="button.moveup"/>" /></a>
						<a href="javascript:void(0);" onclick="moveRow(1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/down.gif" border="0" title="<bean:message key="button.movedown"/>" /></a>
					</td>
				</tr>
				<!--内容行-->
				<c:forEach items="${pdaModuleConfigMainForm.fdViewItems}" varStatus="vstatus" var="pdaModuleConfigViewForm">
					<tr KMSS_IsContentRow="1">
						<td KMSS_IsRowIndex="1">${vstatus.index+1}</td>
						<td>
							<input type="hidden" name="fdViewItems[${vstatus.index}].fdId" value="${pdaModuleConfigViewForm.fdId}"/>
							<input type="hidden" name="fdViewItems[${vstatus.index}].fdOrder" value="${pdaModuleConfigViewForm.fdOrder}"/>
							<input type="hidden" name="fdViewItems[${vstatus.index}].fdItemsVal" />
							<input type="hidden" name="fdViewItems[${vstatus.index}].fdKeyword" value="${pdaModuleConfigViewForm.fdKeyword}" />
							<input type="hidden" name="fdViewItems[${vstatus.index}].fdModelName" value="${pdaModuleConfigViewForm.fdModelName}" />
							<input type="hidden" name="fdViewItems[${vstatus.index}].fdModuleId" value="${pdaModuleConfigMainForm.fdId}" />
							<input type="hidden" name="fdViewItems[${vstatus.index}].fdReadingModel" value="${pdaModuleConfigViewForm.fdReadingModel}" />
							<input type='hidden' name='fdViewItems[${vstatus.index}].fdNewsModelCfgInfo' value='${pdaModuleConfigViewForm.fdNewsModelCfgInfo}' />
							<input name="fdViewItems[${vstatus.index}].fdName" class="inputsgl" style="width: 90%" value="${pdaModuleConfigViewForm.fdName}" />
							<div name="docCfgDiv">
								<script>
									var fdItems = new Array();
									function addDocCfg(fdId,fdName,fdOrder,fdCfgInfo,fdCfgViewId,fdExtendUrl,index){
										var docCfg = {"fdId":fdId,
													  "fdName":fdName,
													  "fdOrder":fdOrder,
													  "fdExtendUrl":fdExtendUrl,
													  "fdCfgInfo":fdCfgInfo,
													  "fdCfgViewId":fdCfgViewId
													 };
										fdItems.push(docCfg);
										$('input[name="fdViewItems['+index+'].fdItemsVal"]').val(JSON.stringify(fdItems));
									}
								</script>
								<c:forEach items="${pdaModuleConfigViewForm.fdItems}" varStatus="vstatus2" var="pdaModuleLabelViewForm">
									<input type="hidden" name="fdViewItems[${vstatus.index}].fdItems[${vstatus2.index}].fdId" value="${pdaModuleLabelViewForm.fdId}"/>
									<input type="hidden" name="fdViewItems[${vstatus.index}].fdItems[${vstatus2.index}].fdName" value="${pdaModuleLabelViewForm.fdName}"/>
									<input type="hidden" name="fdViewItems[${vstatus.index}].fdItems[${vstatus2.index}].fdOrder" value="${pdaModuleLabelViewForm.fdOrder}"/>
									<input type="hidden" name="fdViewItems[${vstatus.index}].fdItems[${vstatus2.index}].fdExtendUrl" value="${pdaModuleLabelViewForm.fdExtendUrl}"/>
									<input type='hidden' name='fdViewItems[${vstatus.index}].fdItems[${vstatus2.index}].fdCfgInfo' value='${pdaModuleLabelViewForm.fdCfgInfo}'/>
									<input type="hidden" name="fdViewItems[${vstatus.index}].fdItems[${vstatus2.index}].fdCfgViewId" value="${pdaModuleLabelViewForm.fdCfgViewId}"/>
									<script>
										addDocCfg('${pdaModuleLabelViewForm.fdId}','${pdaModuleLabelViewForm.fdName}','${pdaModuleLabelViewForm.fdOrder}','${pdaModuleLabelViewForm.fdCfgInfo}','${pdaModuleLabelViewForm.fdCfgViewId}','${pdaModuleLabelViewForm.fdExtendUrl}','${vstatus.index}');
									</script>
								</c:forEach>
							</div>
						</td>
						<td align="center">
							<input type="hidden" name="${vstatus.index}"> 
							<a href="javascript:void(0);" onclick="editDocCfgRow(this);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/edit.gif" border="0" title="<bean:message key="button.edit"/>" /></a>
							<a href="javascript:void(0);" onclick="deleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/delete.gif" border="0" title="<bean:message key="button.delete"/>" /></a>
							<a href="javascript:void(0);" onclick="moveRow(-1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/up.gif" border="0" title="<bean:message key="button.moveup"/>" /></a>
							<a href="javascript:void(0);" onclick="moveRow(1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/down.gif" border="0" title="<bean:message key="button.movedown"/>" /></a>
						</td>
					</tr>
				</c:forEach>
			</table>
		</td>
	</tr>
</table>
</td>
</tr>
<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
			<td>
			<table
				class="tb_normal"
				width=100%>
				<c:import
					url="/sys/right/right_edit.jsp"
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
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
$(document).ready(function (){
	//初始化动态表格
	DocList_Info.push("TABLE_DocList_Next"); 
	var fdIconUrl = $('input[name="fdIconUrl"]');
	if(fdIconUrl.val() == null || fdIconUrl.val() == ""){
		fdIconUrl.val("/third/pda/resource/images/icon/module_default.png");
		fdIconUrl.next().attr('src','<c:url value="/third/pda/resource/images/icon/module_default.png " />');
	}
});
//选择图标
function selectIcon(type,obj,_this){
	var style = "dialogWidth:600px; dialogHeight:460px; status:0;scroll:1; help:0; resizable:1";
	var rtnVal = window.showModalDialog(Com_Parameter.ContextPath+"third/pda/pda_module_config_main/pdaModuleConfigMain.do?method=selectIcon&type="+type, obj, style);
	var iconSrc = obj.value;
	if(iconSrc && iconSrc.substring(0,1) == "/"){
		iconSrc = iconSrc.substring(1,iconSrc.length);
	}else if(iconSrc==null || iconSrc==''){
		iconSrc = "third/pda/resource/images/icon/module_default.png";
	}
	_this.src = Com_Parameter.ContextPath + iconSrc;
}
//选择模块
function selectModule(){
	Dialog_List(false, "fdUrlPrefix", "fdName", null, "pdaModuleSelectDialog",afterModuleSelect,null,null,null,
			"<bean:message bundle='third-pda' key='pdaModuleConfigMain.moduleSelectDilog'/>");
}
function afterModuleSelect(dataObj){
	if(dataObj==null)
		return ;
	var rtnData = dataObj.GetHashMapArray();
	if(rtnData[0]==null)
		return;
	if(rtnData[0]["countUrl"]!=null)
		$('input[name="fdCountUrl"]').val(rtnData[0]["countUrl"]);
	else
		$('input[name="fdCountUrl"]').val('');
}
//从已添加模块中选择模块
function selectModuleFromPda(){
	var fdid=$('input[name="fdId"]').val();
	Dialog_List(true, 'fdSubModuleIds','fdSubModuleNames', ';', 'moduleSelectBean&curid='+fdid);
}
//子菜单类型更改时
//内外部链接类型更改时触发事件
function onCommonTypeChange(){

	//获取模块类型
	var menuObj=document.getElementsByName("_fdSubMenuType");
	var menu=$('input[name="fdSubMenuType"]');

	//获取链接类型
	var _fdLinkerTypeObj=document.getElementsByName("_fdLinkerType");
	var fdLinkerType=$('input[name="fdLinkerType"]');

	//获取相应的块对象
	var linkerTitle = $('tr[id="tr_linkerTitle"]');
	var linkerArea  = $('tr[id="tr_linkerArea"]');
	var moduleArea=$('tr[id="tr_moduleArea"]');
	var listArea=$('tr[id="tr_listArea"]');
	var listAreaTitle=$('tr[id="tr_listAreaTitle"]');
	var docArea=$('tr[id="tr_docArea"]');
	var docAreaTitle=$('tr[id="tr_docAreaTitle"]');
	var appTitle=$('tr[id="tr_appAreaTitle"]');
	var appArea=$('tr[id="tr_appArea"]');
	var ekpAraeTitle = $('tr[id="tr_ekpAreaTitle"]');
	var ekpArea  = $('tr[id="tr_ekpArea"]');
	var docLabelArea=$('tr[id="tr_docLabelArea"]');

	//初始化隐藏块
	initCommonHide(linkerTitle,linkerArea,moduleArea,listArea,listAreaTitle,docArea,
			docAreaTitle,appTitle,appArea,ekpAraeTitle,ekpArea,docLabelArea);

	//模块类型（listTab：“模块->列表->文档”模式  doc：“模块->链接”模式 app: 调用第三方应用 缺省值为listTab：“模块->列表->文档”模式）
	var menuObjValue = getValueFromObjArray(menuObj,'listTab',menu);

	//链接类型（0：内部链接 1：外部链接 缺省值为0：内部链接）
	var _fdLinkerTypeObjValue = getValueFromObjArray(_fdLinkerTypeObj,'0',fdLinkerType);
	
	//页面块显示逻辑
	displayBlockLogic(menuObjValue,_fdLinkerTypeObjValue,moduleArea,linkerTitle,linkerArea,listArea,listAreaTitle,
			docArea,docAreaTitle,docLabelArea,ekpAraeTitle,ekpArea,appTitle,appArea);
}

//初始化隐藏块
function initCommonHide(linkerTitle,linkerArea,moduleArea,listArea,listAreaTitle,docArea,
		docAreaTitle,appTitle,appArea,ekpAraeTitle,ekpArea,docLabelArea){
	linkerTitle.hide();
    linkerArea.hide();
	moduleArea.hide();
	listArea.hide();
	listAreaTitle.hide();
	docArea.hide();
	docAreaTitle.hide();
	appTitle.hide();
	appArea.hide();
	ekpAraeTitle.hide();
	ekpArea.hide();
	docLabelArea.hide();
}

//从数组对象获取值，并给目标字段赋值
function getValueFromObjArray(arrayObj,defaultValue,targetObj){
	var defaultObjValue = defaultValue;
	for(var i=0;i<arrayObj.length;i++){
	  if(arrayObj[i].checked==true){
		  defaultObjValue=arrayObj[i].value;
		  break;
	  }
	}
	targetObj.val(defaultObjValue);
	return defaultObjValue;
}

//页面块显示逻辑
function displayBlockLogic(menuObjValue,_fdLinkerTypeObjValue,moduleArea,linkerTitle,linkerArea,listArea,listAreaTitle,
		docArea,docAreaTitle,docLabelArea,ekpAraeTitle,ekpArea,appTitle,appArea){
	if(menuObjValue.toLowerCase()=='module'){
		moduleArea.show();
	}else if(menuObjValue.toLowerCase()=='listtab'){
		if(_fdLinkerTypeObjValue=='0'){//内部链接
			linkerTitle.show();
		    linkerArea.show();
			listArea.show();
			listAreaTitle.show();
			docAreaTitle.show();
			docLabelArea.show();
		}else if(_fdLinkerTypeObjValue=='1'){//外部链接
			linkerTitle.show();
		    linkerArea.show();
			ekpAraeTitle.show();
			ekpArea.show();
		}
	}else if(menuObjValue.toLowerCase()=='doc'){
		docArea.show();
		docAreaTitle.show();
		docLabelArea.show();
	}else if(menuObjValue.toLowerCase()=='app'){
		appTitle.show();
		appArea.show();
	}
}

//添加一个文档配置行
function addDocCfgRow(tableId){
	var fdUrlPrefix = $('input[name="fdUrlPrefix"]').val();
	if(fdUrlPrefix == "" || fdUrlPrefix == null){
		alert('<bean:message bundle="third-pda" key="pdaModuleConfigMain.validate.notNull.fdName"/>');
		return;
	}
	var tbInfo = DocList_TableInfo[tableId];
	var index = tbInfo.lastIndex - tbInfo.firstIndex;
	$('input[name="fdViewItems['+index+'].fdCfgViewId"]').next().html();
	var fdItems = null;
	if($('input[name="fdViewItems['+index+'].fdItemsVal"]').val() != null && $('input[name="fdViewItems['+index+'].fdItemsVal"]').val() != "")
		fdItems = JSON.parse($('input[name="fdViewItems['+index+'].fdItemsVal"]').val());
	var obj = {'fdId':$('input[name="fdViewItems['+index+'].fdId"]').val(),
			   'fdName':$('input[name="fdViewItems['+index+'].fdName"]').val(),
			   'fdOrder':$('input[name="fdViewItems['+index+'].fdOrder"]').val(),
			   'fdKeyword':fdUrlPrefix,
			   'fdModuleId':$('input[name="fdViewItems['+index+'].fdModuleId"]').val(),
			   'fdModelName':$('input[name="fdViewItems['+index+'].fdModelName"]').val(),
			   'fdReadingModel':$('input[name="fdViewItems['+index+'].fdReadingModel"]').val(),
			   'fdNewsModelCfgInfo':$('input[name="fdViewItems['+index+'].fdNewsModelCfgInfo"]').val(),
			   'fdItems':fdItems,
			   "fdUrlPrefix":fdUrlPrefix
			};
	var style = "dialogWidth:600px; dialogHeight:450px; status:0;scroll:1; help:0; resizable:1";
	var rtnVal = window.showModalDialog(Com_Parameter.ContextPath+"third/pda/pda_module_config_view/pdaModuleConfigView_edit.jsp", obj, style);
	if(obj != null){
		if(obj.fdName && obj.fdName != ""){
			DocList_AddRow(tableId);
			afterOpenModalDialog(obj,index);
		}
	}
}

function afterOpenModalDialog(obj,index){
	var docCfgDiv = $('input[name="fdViewItems['+index+'].fdName"]').next();
	$('input[name="fdViewItems['+index+'].fdName"]').val(obj.fdName);
	$('input[name="fdViewItems['+index+'].fdOrder"]').val(obj.fdOrder);
	$('input[name="fdViewItems['+index+'].fdKeyword"]').val(obj.fdKeyword);
	$('input[name="fdViewItems['+index+'].fdModelName"]').val(obj.fdModelName);
	if(obj.fdItems != null){
		for(var key in obj.fdItems){
			$('<input type="hidden" name="fdViewItems['+index+'].fdItems['+key+'].fdId" value="'+obj.fdItems[key].fdId+'" />').appendTo(docCfgDiv);
			$('<input type="hidden" name="fdViewItems['+index+'].fdItems['+key+'].fdName" value="'+obj.fdItems[key].fdName+'" />').appendTo(docCfgDiv);
			$('<input type="hidden" name="fdViewItems['+index+'].fdItems['+key+'].fdOrder" value="'+obj.fdItems[key].fdOrder+'" />').appendTo(docCfgDiv);
			$('<input type="hidden" name="fdViewItems['+index+'].fdItems['+key+'].fdExtendUrl" value="'+obj.fdItems[key].fdExtendUrl+'" />').appendTo(docCfgDiv);
			$('<input type="hidden" name="fdViewItems['+index+'].fdItems['+key+'].fdCfgInfo" />').val(obj.fdItems[key].fdCfgInfo == null ? "":obj.fdItems[key].fdCfgInfo).appendTo(docCfgDiv);
			$('<input type="hidden" name="fdViewItems['+index+'].fdItems['+key+'].fdCfgViewId" value="'+obj.fdItems[key].fdCfgViewId+'" />').appendTo(docCfgDiv);
		}
		$('input[name="fdViewItems['+index+'].fdItemsVal"]').val(JSON.stringify(obj.fdItems));
	}
	$('input[name="fdViewItems['+index+'].fdReadingModel"]').val(obj.fdReadingModel);
	if(obj.fdReadingModel == "1"){
		$('input[name="fdViewItems['+index+'].fdNewsModelCfgInfo"]').val(JSON.stringify(obj.fdNewsModelCfgInfo));
	}
}
//编辑一个文档配置
function editDocCfgRow(_this){
	var fdUrlPrefix = $('input[name="fdUrlPrefix"]').val();
	if(fdUrlPrefix == "" || fdUrlPrefix == null){
		alert('<bean:message bundle="third-pda" key="pdaModuleConfigMain.validate.notNull.fdName"/>');
		return;
	}
	var index = $(_this).prev().attr('name');
	var fdItems = null;
	if($('input[name="fdViewItems['+index+'].fdItemsVal"]').val() != null && $('input[name="fdViewItems['+index+'].fdItemsVal"]').val() != "")
		fdItems = JSON.parse($('input[name="fdViewItems['+index+'].fdItemsVal"]').val());
	var newsModelCfgInfo = null;
	if($('input[name="fdViewItems['+index+'].fdNewsModelCfgInfo"]').val() != null && $('input[name="fdViewItems['+index+'].fdNewsModelCfgInfo"]').val() != "")
		newsModelCfgInfo = JSON.parse($('input[name="fdViewItems['+index+'].fdNewsModelCfgInfo"]').val());
	var obj = {'fdId':$('input[name="fdViewItems['+index+'].fdId"]').val(),
		   'fdName':$('input[name="fdViewItems['+index+'].fdName"]').val(),
		   'fdOrder':$('input[name="fdViewItems['+index+'].fdOrder"]').val(),
		   'fdKeyword':fdUrlPrefix,
		   'fdModuleId':$('input[name="fdViewItems['+index+'].fdModuleId"]').val(),
		   'fdModelName':$('input[name="fdViewItems['+index+'].fdModelName"]').val(),
		   'fdReadingModel':$('input[name="fdViewItems['+index+'].fdReadingModel"]').val(),
		   'fdNewsModelCfgInfo':newsModelCfgInfo,
		   'fdItems':fdItems,
		   "fdUrlPrefix":fdUrlPrefix
		};
	var style = "dialogWidth:600px; dialogHeight:450px; status:0;scroll:1; help:0; resizable:1";
	var rtnVal = window.showModalDialog(Com_Parameter.ContextPath+"third/pda/pda_module_config_view/pdaModuleConfigView_edit.jsp", obj, style);
	$('input[name="fdViewItems['+index+'].fdName"]').next().html("");
	var docCfgDiv = $('input[name="fdViewItems['+index+'].fdName"]').next();
	if(obj != null){
		if(obj != null){
			afterOpenModalDialog(obj,index);
		}
	}
}
function validate(){
	var errorMsg = "";
	var canSave = true;
	var menuType=$('input[name="fdSubMenuType"]').val();
	var moduleName=$('input[name="fdName"]').val();
	if(moduleName==""){
		alert('<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdName"/><bean:message bundle="third-pda" key="validate.notNull"/>');
		return false;
	}
	if(menuType.toLowerCase()=="listtab"){ 
		var fdLinkerType = $('input[name="fdLinkerType"]');
		var _fdLinkerTypeObj=document.getElementsByName("_fdLinkerType");
		var _fdLinkerTypeObjValue = getValueFromObjArray(_fdLinkerTypeObj,'0',fdLinkerType);
		if(_fdLinkerTypeObjValue=='0'){
			var tbInfo = DocList_TableInfo["TABLE_DocList"];
			if(tbInfo.lastIndex <= 1){
				errorMsg += '<bean:message bundle="third-pda" key="table.pdaModuleLabelList"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
				canSave = false;
			}
			for(var i=0;i<tbInfo.lastIndex-1;i++){
				if(i==0 && $('input[name="fdLabelList['+i+'].fdIsLink"]').val()=='1'){
					errorMsg += '<bean:message bundle="third-pda" key="pdaModuleLabelList.errorInfo"/>';
					canSave = false;
				}
				if($('input[name="fdLabelList['+i+'].fdName"]').val() == ""){
					errorMsg += '<bean:message bundle="third-pda" key="pdaModuleLabelList.the"/>'+(i+1)+'<bean:message bundle="third-pda" key="pdaModuleLabelList.row"/><bean:message bundle="third-pda" key="pdaModuleLabelList.fdName"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
					canSave = false;
				}
				if($('input[name="fdLabelList['+i+'].fdDataUrl"]').val() == ""){
					errorMsg += '<bean:message bundle="third-pda" key="pdaModuleLabelList.the"/>'+(i+1)+'<bean:message bundle="third-pda" key="pdaModuleLabelList.row"/><bean:message bundle="third-pda" key="pdaModuleLabelList.fdDataUrl"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
					canSave = false;
				}
			}
		}
	}else if(menuType.toLowerCase()=="mudule"){
		var moduleInput=$('textarea[name="fdSubModuleNames"]').val();
		if(moduleInput==""){
			errorMsg+='<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdSubModule"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
			canSave = false;
		}
	}else if(menuType.toLowerCase()=="doc"){
		var docInput=$('input[name="fdSubDocLink"]').val();
		if(docInput==""){
			errorMsg+='<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdSubDoc"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
			canSave = false;
		}
	}else if(menuType.toLowerCase()=="app"){
		var fdUrlScheme=$('input[name="fdUrlScheme"]').val();
		var fdUrlDownLoad=$('input[name="fdUrlDownLoad"]').val();
		if(fdUrlScheme==""){
			errorMsg+='<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdUrlScheme"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
			canSave = false;
		}
		if(fdUrlDownLoad==""){
			errorMsg+='<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdUrlDownLoad"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
			canSave = false;
		}
	}else{
		if(menuType==""){
			errorMsg+='<bean:message bundle="third-pda" key="pdaModuleConfigMain.fdSubMenuType"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
			canSave = false;
		}
	}
	if(!canSave)
		alert(errorMsg);
	return canSave;
}
Com_AddEventListener(window,"load",onCommonTypeChange);
function moveRow(direct, optTR){
	if(optTR==null)
		optTR = DocListFunc_GetParentByTagName("TR");
	var optTB = DocListFunc_GetParentByTagName("TABLE", optTR);
	var tbInfo = DocList_TableInfo[optTB.id];
	var rowIndex = Com_ArrayGetIndex(optTB.rows, optTR);
	var tagIndex = rowIndex + direct;
	if(direct==1){
		if(tagIndex>=tbInfo.lastIndex)
			return;
		optTB.rows[rowIndex].parentNode.insertBefore(optTB.rows[tagIndex], optTB.rows[rowIndex]);
	}else{
		if(tagIndex<tbInfo.firstIndex)
			return;
		optTB.rows[rowIndex].parentNode.insertBefore(optTB.rows[rowIndex], optTB.rows[tagIndex]);
	}
	refreshIndex(tbInfo, rowIndex);
	refreshIndex(tbInfo, tagIndex);
}
function deleteRow(optTR){
	if(optTR==null)
		optTR = DocListFunc_GetParentByTagName("TR");
	var optTB = DocListFunc_GetParentByTagName("TABLE", optTR);
	var tbInfo = DocList_TableInfo[optTB.id];
	var rowIndex = Com_ArrayGetIndex(optTB.rows, optTR);
	optTB.deleteRow(rowIndex);
	tbInfo.lastIndex--;
	for(var i = rowIndex; i<tbInfo.lastIndex; i++)
		refreshIndex(tbInfo, i);
}
function refreshIndex(tbInfo, index){
	for (var n = 0; n < tbInfo.cells.length; n ++) {
		if (tbInfo.cells[n].isIndex) {
			tbInfo.DOMElement.rows[index].cells[n].innerHTML = index;
		}
	}
	refreshFieldIndex(tbInfo, index, "INPUT");
	refreshFieldIndex(tbInfo, index, "TEXTAREA");
	refreshFieldIndex(tbInfo, index, "SELECT");
}
function refreshFieldIndex(tbInfo, index, tagName){
	var optTR = tbInfo.DOMElement.rows[index];
	var fields = optTR.getElementsByTagName(tagName);
	for(var i=0; i<fields.length; i++){
		var fieldName = fields[i].name.replace(/\d/, index-tbInfo.firstIndex);
		if(document.getElementById(fields[i].name)!=null){
			Com_SetOuterHTML(fields[i],fields[i].outerHTML.replace(/\d/, index-tbInfo.firstIndex));
		}else{
			fields[i].setAttribute("name",fieldName);
		}
	}
}
function selectDataUrl(index){
	var fdUrlPrefix = document.getElementsByName("fdUrlPrefix")[0];
	if(fdUrlPrefix.value==""){
		alert('<bean:message bundle="third-pda" key="pdaModuleConfigMain.validate.notNull.fdName"/>');
		return;
	}
	var linkType = "doc";
	if(index!= null){
		window._S_fdLabel_Index = index;
		linkType = "list";
	}
	Dialog_List(false,null,null, ';', 'pdaSysConfigDialog&urlPrefix='+ fdUrlPrefix.value+'&type='+linkType,afterSelectFun);
}
function afterSelectFun(dataObj){
	if(dataObj==null)
		return ;
	var rtnData=dataObj.GetHashMapArray();
	if(rtnData[0]==null)
		return;
	if(window._S_fdLabel_Index!=null){
		var index =	window._S_fdLabel_Index;
		$('input[name="fdLabelList[' + index + '].fdName"]').val(rtnData[0]["name"]==null?"":rtnData[0]["name"]);
		$('input[name="fdLabelList[' + index + '].fdDataUrl"]').val(rtnData[0]["url"]==null?"":rtnData[0]["url"].replace(/!{cateid}/,''));
		$('input[name="fdLabelList[' + index + '].fdCountUrl"]').val(rtnData[0]["countUrl"]==null?"":rtnData[0]["countUrl"]);
		var tmpHtml = "";
		if(rtnData[0]["name"]!=null){
			tmpHtml = rtnData[0]["name"] + (rtnData[0]["url"]!=null?"(10)":"");
		}
		$('span[name="fdLabelList[' + index + '].fdNameExap"]').html(tmpHtml);
	}else{
		$('input[name="fdSubDocLink"]').val(rtnData[0]["url"]==null?"":rtnData[0]["url"].replace(/!{cateid}/,''));
	}	
}
function clearLabelInfo(index,thisObj){
	$('input[name="fdLabelList[' + index + '].fdCountUrl"]').val("");
	var fdName = $('input[name="fdLabelList[' + index + '].fdName"]').val();
	if(fdName == null || fdName==''){
		$('span[name="fdLabelList[' + index + '].fdNameExap"]').html("");
	}else{
		$('span[name="fdLabelList[' + index + '].fdNameExap"]').html(fdName);
	}
	if(thisObj!=null){
		if(thisObj.checked){
			$('input[name="fdLabelList[' + index + '].fdIsLink"]').val("1");
		}else{
			$('input[name="fdLabelList[' + index + '].fdIsLink"]').val("0");
		}
	}
}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>