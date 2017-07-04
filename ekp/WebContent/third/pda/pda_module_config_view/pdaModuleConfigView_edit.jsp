<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("jquery.js|doclist.js|dialog.js|json2.js");
</script>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message bundle="third-pda" key="pdaModuleConfigView.fdName"/>
		</td><td>
			<input type="hidden" style="width:90%;" class="inputSgl" name="fdModelName" readonly="readonly" onchange="loadDictPropertyData();"/>
			<input type="text" style="width:90%;" class="inputSgl" name="fdName"/>
			<a onclick="selectDictModel();return false;" href=""><bean:message key="dialog.selectOther" /></a>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.selectMode"/>
		</td>
		<td>
			<label>
				<input type="checkbox" name="fdShowModel" checked value="more" disabled/>
				<bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.more"/>
			</label>
			<label>
				<input type="checkbox" name="fdShowModel" value="simple"/>
				<bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.simple"/><bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.simple.summary"/>
			</label>
		</td>
	</tr>
	<tr>
		<td width="100%" colspan="2">
			 <b><bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.more"/><bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.config.bak"/></b>
		</td>
	</tr>
	<tr>
		<td colspan="2" style="padding: 0px;margin: 0px;border: 0px !important;">
			<!-- 文档设置 -->
			<table  class="tb_normal" width="100%" id="TABLE_DocList">
				<tr>
					<td KMSS_IsRowIndex="1" width="20%" class="td_normal_title"><bean:message key="page.serial" /></td>
					<td align="center" class="td_normal_title" ><bean:message bundle="third-pda" key="pdaModuleLabelView.fdName"/></td>
					<td align="center" class="td_normal_title"  align="center"  width="120px;">
						<img src="${KMSS_Parameter_StylePath}icons/add.gif"
							style="cursor:pointer" onclick="refreshLastIndex();addDocLabel();">
					</td>
				</tr>
				<!--基准行-->
				<tr KMSS_IsReferRow="1" style="display:none">
					<td KMSS_IsRowIndex="1">${index+1}
					</td>
					<td>
						<input type="hidden" name="fdItems[!{index}].fdId" />
						<input type="hidden" name="fdItems[!{index}].fdOrder" />
						<input type="hidden" name="fdItems[!{index}].fdCfgViewId"/>
						<input type="hidden" name="fdItems[!{index}].fdExtendUrl" />
						<input type="hidden" name="fdItems[!{index}].fdCfgInfo" />
						<input name="fdItems[!{index}].fdName" class="inputsgl" style="width: 85%" />
					</td>
					<td align="center">
						<input type="hidden" name="!{index}"> 
						<a href="javascript:void(0);" onclick="refreshLastIndex();editDocLabel(this);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/edit.gif" border="0" /></a>
						<a href="javascript:void(0);" onclick="refreshLastIndex();DocList_MoveRow(-1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/up.gif" border="0" /></a>
						<a href="javascript:void(0);" onclick="refreshLastIndex();DocList_MoveRow(1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/down.gif" border="0" /></a>
						<a href="javascript:void(0);" onclick="refreshLastIndex();DocList_DeleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/delete.gif" border="0" /></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr id="newsReadingModelTitle">
		<td width="100%" colspan="2">
			<b><bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.simple"/><bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.config.bak"/></b>
		</td>
	</tr>
	<tr id="newsReadingModel">
		<td colspan="2" style="padding: 0px;margin: 0px;border: 0px !important;">
			<table class="tb_simple" width="100%">
				<%--状态--%>
				<tr style="display: none;">
					<td class="td_normal_title" width="20%">
						<bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.docStatus"/>
					</td>
					<td>
						<select id="status"></select><br>
						<bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.tip"/>
						<font color=red><bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.note"/></font>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">
						<bean:message bundle="third-pda" key="pdaModuleConfigView.newsReadingMode.subject"/>
					</td>
					<td>
						<select id="subject"></select>
					</td>
				</tr>
				<%--简要信息 --%>
				<tr>
					<td class="td_normal_title">
						<bean:message bundle="third-pda" key="pdaModuleConfigView.newsReadingMode.summary"/>
					</td>
					<td>
						<table class="tb_normal" width="100%">
							<tr class="tr_normal_title">
								<td width="45%">
									<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.optionBox"/>
								</td>
								<td width="45%">
									<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.selectedBox"/>
								</td>
								<td width="10%"><bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.operation"/></td>
							</tr>
							<tr>
								<td valign="top">
									<select id="summaryOptional" multiple ondblclick="listTolist('summaryOptional','summarySelected',false);" size="8" style="width: 170px;"></select>
								</td>
								<td>
									<select id="summarySelected" multiple ondblclick="listTolist('summarySelected','summaryOptional',false);" size="8" style="width: 170px;"></select>
								</td>
								<td>
									<center>
										<input type=button class="btnopt" value='<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.move"/>' onclick="removeOption('summarySelected',1);">
										<br><br>
										<input type=button class="btnopt" value='<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.down"/>' onclick="removeOption('summarySelected',-1);">
									</center>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<%--内容 --%>
				<tr>
					<td class="td_normal_title">
						<bean:message bundle="third-pda" key="pdaModuleConfigView.newsReadingMode.content"/>
					</td>
					<td>
						<table class="tb_normal" width="100%">
							<tr class="tr_normal_title">
								<td width="45%">
									<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.optionBox"/>
								</td>
								<td width="45%">
									<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.selectedBox"/>
								</td>
								<td width="10%"><bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.operation"/></td>
							</tr>
							<tr>
								<td valign="top">
									<select id="contentOptional" multiple ondblclick="listTolist('contentOptional','contentSelected',false);" size="6" style="width: 170px;"></select>
								</td>
								<td>
									<select id="contentSelected" multiple ondblclick="listTolist('contentSelected','contentOptional',false);" size="6" style="width: 170px;"></select>
								</td>
								<td>
									<center>
										<input type=button class="btnopt" value='<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.move"/>' onclick="removeOption('contentSelected',1);">
										<br><br>
										<input type=button class="btnopt" value='<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.down"/>' onclick="removeOption('contentSelected',-1);">
									</center>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<%--附件 --%>
				<tr>
					<td class="td_normal_title">
						<bean:message bundle="third-pda" key="pdaModuleConfigView.attachment"/>
					</td>
					<td>
						<table class="tb_normal" width="100%">
							<tr class="tr_normal_title">
								<td width="45%">
									<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.optionBox"/>
								</td>
								<td width="45%">
									<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.selectedBox"/>
								</td>
								<td width="10%"><bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.operation"/></td>
							</tr>
							<tr>
								<td valign="top">
									<select id="attachmentOptional" multiple ondblclick="listTolist('attachmentOptional','attachmentSelected',false);" size="4" style="width: 170px;"></select>
								</td>
								<td>
									<select id="attachmentSelected" multiple ondblclick="listTolist('attachmentSelected','attachmentOptional',false);" size="4" style="width: 170px;"></select>
								</td>
								<td>
									<center>
										<input type=button class="btnopt" value='<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.move"/>' onclick="removeOption('attachmentSelected',1);">
										<br><br>
										<input type=button class="btnopt" value='<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.down"/>' onclick="removeOption('attachmentSelected',-1);">
									</center>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<%--其他配置 --%>
				<tr>
					<td class="td_normal_title">
						<bean:message bundle="third-pda" key="pdaModuleConfigView.others"/>
					</td>
					<td>
						<table class="tb_normal" width="100%">
							<tr class="tr_normal_title">
								<td width="45%">
									<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.optionBox"/>
								</td>
								<td width="45%">
									<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.selectedBox"/>
								</td>
								<td width="10%"><bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.operation"/></td>
							</tr>
							<tr>
								<td valign="top">
									<select id="othersOptional" multiple ondblclick="listTolist('othersOptional','othersSelected',false);" size="4" style="width: 170px;"></select>
								</td>
								<td>
									<select id="othersSelected" multiple ondblclick="listTolist('othersSelected','othersOptional',false);" size="4" style="width: 170px;"></select>
								</td>
								<td>
									<center>
										<input type=button class="btnopt" value='<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.move"/>' onclick="removeOption('othersSelected',1);">
										<br><br>
										<input type=button class="btnopt" value='<bean:message bundle="third-pda" key="pdaModuleConfigView.docDisplayCfg.down"/>' onclick="removeOption('othersSelected',-1);">
									</center>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center" colspan="2">
			<a href=javascript:void(0);" onclick="save();"><input class="btnopt" type="button" value="<bean:message key="button.save"/>"></a>
			&nbsp;&nbsp;
			<a href=javascript:void(0);" onclick="window.close();"><input class="btnopt" type="button" value="<bean:message key="button.close"/>"></a>
		</td>
	</tr>
</table>
</center>
<script>
$(document).ready(function(){ 
	var obj = window.dialogArguments;
	$('input[name="fdName"]').val(obj.fdName);
	$('input[name="fdModelName"]').val(obj.fdModelName);
	if(obj.fdItems != null && obj.fdItems != ""){
		for(var key in obj.fdItems){
			var conten = new Array();
			var content = '<tr>';
			content += '<td>'+(parseInt(key)+1)+'</td>';
			content += '<td>';
			content += '<input type="hidden" name="fdItems['+key+'].fdId" value="'+obj.fdItems[key].fdId+'" />';
			content += '<input type="hidden" name="fdItems['+key+'].fdOrder" value="'+obj.fdItems[key].fdOrder+'" />';
			content += '<input type="hidden" name="fdItems['+key+'].fdCfgViewId" value="'+obj.fdItems[key].fdCfgViewId+'" />';
			content += '<input type="hidden" name="fdItems['+key+'].fdCfgInfo" />';
			content += '<input type="hidden" name="fdItems['+key+'].fdExtendUrl" value="'+obj.fdItems[key].fdExtendUrl+'"/>';
			content += '<input class="inputsgl" name="fdItems['+key+'].fdName" value="'+obj.fdItems[key].fdName+'"  style="width: 85%" />';
			content += '</td>';
			content += '<td align="center">';
			content += '<input type="hidden" name="'+key+'">';
			content += '<a href="javascript:void(0);" onclick="refreshLastIndex();editDocLabel(this);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/edit.gif" border="0" /></a>';
			content += '<a href="javascript:void(0);" onclick="refreshLastIndex();DocList_MoveRow(-1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/up.gif" border="0" /></a>';
			content += '<a href="javascript:void(0);" onclick="refreshLastIndex();DocList_MoveRow(1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/down.gif" border="0" /></a>';
			content += '<a href="javascript:void(0);" onclick="refreshLastIndex();DocList_DeleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/delete.gif" border="0" /></a>';
			content += '</td>';
			content += '</tr>';
			$('#TABLE_DocList').append(content);
			$('input[name="fdItems['+key+'].fdCfgInfo"]').val(obj.fdItems[key].fdCfgInfo);
		}
	}
	if(obj.fdReadingModel == "1"){//文档阅读模式
		$('input:checkbox[name="fdShowModel"]').each(function(){
			if($(this).val()=="simple")
				$(this).attr('checked','checked');
			});
		loadDictPropertyData();
		$('#newsReadingModel').show();
		$('#newsReadingModelTitle').show();
	}else{
		$('#newsReadingModel').hide();
		$('#newsReadingModelTitle').hide();
	}
	$('input:checkbox[name="fdShowModel"]').click(function (){
		var showModelDom = $(this);
		resetFdShowModel(showModelDom);
	});
});
function resetFdShowModel(showModelDom){
	if(showModelDom.is(":checked")){
		if($('input[name="fdModelName"]').val() == '' || $('input[name="fdModelName"]').val() == null){
			alert('<bean:message bundle="third-pda" key="pdaModuleConfigView.validate.notNull.fdName"/>');
			showModelDom.removeAttr("checked");
			return;
		}
	}
	if(showModelDom.is(":checked")){
		loadDictPropertyData();
		$('#newsReadingModel').show();
		$('#newsReadingModelTitle').show();
	}else{
		$('#newsReadingModel').hide();
		$('#newsReadingModelTitle').hide();
	}
}
//加载数据字典里面属性数据
function loadDictPropertyData(){
	var modelName = $('input[name="fdModelName"]').val();
	if(modelName == null && modelName == "")
		return;
	var data = new KMSSData();
	var url="pdaDictPropertySelectList&modelName="+modelName;
	data.SendToBean(url,changeSelectListVal);
}
function changeSelectListVal(rtnData){
	var hasSysStatus=false;
	if(!isSimpleModel())
		return;
	var obj = window.dialogArguments;
	var status = $('#status');
	var subject = $('#subject');
	var summaryOptional = $('#summaryOptional');
	var summarySelected = $('#summarySelected');
	var contentOptional = $('#contentOptional');
	var contentSelected = $('#contentSelected');
	var attachmentOptional = $('#attachmentOptional');
	var attachmentSelected = $('#attachmentSelected');
	var othersOptional = $('#othersOptional');
	var othersSelected = $('#othersSelected');
	var isNew=true;
	status.text("");
	subject.text("");
	summaryOptional.text("");
	summarySelected.text("");
	contentOptional.text("");
	contentSelected.text("");
	attachmentSelected.text("");
	attachmentSelected.text("");
	othersOptional.text("");
	othersSelected.text("");
	
	var pleaseVar=$('<option value="">==<bean:message bundle="third-pda" key="pdaModuleConfigView.pleaseSelect"/>==</option>');
	pleaseVar.appendTo(status);
	pleaseVar.appendTo(subject);
	var newsModelCfgInfo = obj.fdNewsModelCfgInfo;
	if(newsModelCfgInfo != null && newsModelCfgInfo != ""){
		//编辑,初始已选设置项
		for(var key in newsModelCfgInfo.summary){
			$("<option value='"+JSON.stringify(newsModelCfgInfo.summary[key])+"' >"+newsModelCfgInfo.summary[key].propertyText+"</option>").appendTo(summarySelected);
		}
		for(var key2 in newsModelCfgInfo.contents){
			$("<option value='"+JSON.stringify(newsModelCfgInfo.contents[key2])+"' >"+newsModelCfgInfo.contents[key2].propertyText+"</option>").appendTo(contentSelected);
		}
		for(var key3 in newsModelCfgInfo.attachments){
			$("<option value='"+JSON.stringify(newsModelCfgInfo.attachments[key3])+"' >"+newsModelCfgInfo.attachments[key3].propertyText+"</option>").appendTo(attachmentSelected);
		}
		for(var key4 in newsModelCfgInfo.others){
			$("<option value='"+JSON.stringify(newsModelCfgInfo.others[key4])+"' >"+newsModelCfgInfo.others[key4].propertyText+"</option>").appendTo(othersSelected);
		}
		isNew=false;
	}
	if(rtnData){
		//备选框数据初始化,以及单选框初始化
		for(var i=0; i<rtnData.GetHashMapArray().length; i++){
			var obj = rtnData.GetHashMapArray()[i];
			var propertyText = obj['propertyText'];
			var propertyObj = { 'propertyName':obj['propertyName'],
								'propertyType':obj['propertyType'],
								'propertyText':obj['propertyText'],
								'messageKey':obj['messageKey'],
								'enumType':obj['enumType'],
								'displayProp':obj['displayProp'],
								'modelName':obj['modelName'],//以下属性只有流程机制propertyName为“flowDef”时才有值
								'templateModelName':obj['templateModelName'],
								'key':obj['key'],
								'templatePropertyName':obj['templatePropertyName'],
								'moduleMessageKey':obj['moduleMessageKey'],
								'template':obj['template'],
								'type':obj['type']
							  };
			 var selectedStatus = "";
			 var selectedSubject = "";
			 var isSel_summary = false;
			 var isSel_content = false;
			 var isSel_attachment = false;
			 var isSel_others = false;
			if(!isNew){
				if(newsModelCfgInfo.status != null && newsModelCfgInfo.status != "" && newsModelCfgInfo.status.propertyName == obj['propertyName']){
					selectedStatus = "selected";
				}
				
				if(newsModelCfgInfo.subject != null && newsModelCfgInfo.subject != "" && newsModelCfgInfo.subject.propertyName == obj['propertyName']){
					selectedSubject = "selected";
				}
				for(var key in newsModelCfgInfo.summary){
					if(newsModelCfgInfo.summary[key].propertyName == obj['propertyName']){
						isSel_summary = true;
						continue;
					}
				}
				for(var key2 in newsModelCfgInfo.contents){
					if(newsModelCfgInfo.contents[key2].propertyName == obj['propertyName']){
						isSel_content = true;
						continue;
					}
				}
				for(var key3 in newsModelCfgInfo.attachments){
					if(newsModelCfgInfo.attachments[key3].propertyName == obj['propertyName']){
						isSel_attachment = true;
						continue;
					}
				}
				
				for(var key4 in newsModelCfgInfo.others){
					if(newsModelCfgInfo.others[key4].propertyName == obj['propertyName']){
						isSel_others = true;
						continue;
					}
				}
			}
			if(propertyObj.propertyType != "xform" && propertyObj.propertyType != "flowDef" && 
					propertyObj.propertyType != "property" && propertyObj.propertyType != "subflow" && propertyObj.propertyType != "flowlog"){
				if(propertyObj.propertyType == "attachment"){
					if(!isSel_attachment)
						$("<option value='"+JSON.stringify(propertyObj)+"' >"+propertyText+"</option>").appendTo(attachmentOptional);
					
					if(!isSel_content){
						$("<option value='"+JSON.stringify(propertyObj)+"' >"+propertyText+"</option>").appendTo(contentOptional);
					}
					continue;
				}
				if(propertyObj.propertyType=="evaluation" ||propertyObj.propertyType=="relation"||propertyObj.propertyType=="introduce"){
					if(!isSel_others)
						$("<option value='"+JSON.stringify(propertyObj)+"' >"+propertyText+"</option>").appendTo(othersOptional);
					continue;
				}
				if(propertyObj.propertyType.toLowerCase()=="rtf"){
					if(!isSel_content)
						$("<option value='"+JSON.stringify(propertyObj)+"' >"+propertyText+"</option>").appendTo(contentOptional);
					continue;
				}
				
				if(!isSel_summary){
					$("<option value='"+JSON.stringify(propertyObj)+"' >"+propertyText+"</option>").appendTo(summaryOptional);
				}
				
				if(!isSel_content){
					$("<option value='"+JSON.stringify(propertyObj)+"' >"+propertyText+"</option>").appendTo(contentOptional);
				}
				
				if(propertyObj.propertyName.toLowerCase()=="docstatus"){
					hasSysStatus=true;
					if(selectedStatus=="")
						selectedStatus="selected";
				}
				$("<option value='"+JSON.stringify(propertyObj)+"' "+selectedStatus+">"+propertyText+"</option>").appendTo(status);
				$("<option value='"+JSON.stringify(propertyObj)+"' "+selectedSubject+">"+propertyText+"</option>").appendTo(subject);
			}
		}
	}
	if(hasSysStatus == false){
		alert('<bean:message key="pdaModuleConfigView.readingModel.status.summary" bundle="third-pda"/>');
		$('input:checkbox[name="fdShowModel"]').each(function(){
				var thisModelObj = $(this);
				if(thisModelObj.val()=='simple'){
					thisModelObj.removeAttr("checked");
					thisModelObj.attr("disabled","disabled");
					resetFdShowModel(thisModelObj);
				}
			});
	}else{
		$('input:checkbox[name="fdShowModel"]').each(function(){
			var thisModelObj = $(this);
			if(thisModelObj.val()=='simple'){
				thisModelObj.removeAttr("disabled");
			}
		});
	}
}
//选择数据字典模型
function selectDictModel(){
	var obj = window.dialogArguments;
	var urlPrefix = obj.fdUrlPrefix;
	Dialog_List(false, "fdModelName", "fdName", null, "pdaDictModelSelectDialog&urlPrefix="+urlPrefix,null,null,null,null,"<bean:message bundle='third-pda' key='pdaModuleConfigView.docSelectDilog'/>");
	$('input:checkbox[name="fdShowModel"]').each(function(){
		var thisModelObj = $(this);
		if(thisModelObj.val()=='simple'){
			thisModelObj.removeAttr("disabled");
		}
	});
	loadDictPropertyData();
}
//添加文档页签
function addDocLabel(){
	if($('input[name="fdModelName"]').val() == '' || $('input[name="fdModelName"]').val() == null){
		alert('<bean:message bundle="third-pda" key="pdaModuleConfigView.validate.notNull.fdName"/>');
		return;
	}
	var tbInfo = DocList_TableInfo['TABLE_DocList'];
	var index = tbInfo.lastIndex - tbInfo.firstIndex;
	var obj = {'fdId':$('input[name="fdItems['+index+'].fdId"]').val(),
			   'fdName':$('input[name="fdItems['+index+'].fdName"]').val(),
			   'fdOrder':$('input[name="fdItems['+index+'].fdOrder"]').val(),
			   'fdCfgInfo':$('input[name="fdItems['+index+'].fdCfgInfo"]').val(),
			   'fdExtendUrl':$('input[name="fdItems['+index+'].fdExtendUrl"]').val(),
			   'fdCfgViewId':$('input[name="fdItems['+index+'].fdCfgViewId"]').val(),
			   'modelName':$('input[name="fdModelName"]').val()
			};
	var style = "dialogWidth:600px; dialogHeight:450px; status:0;scroll:1; help:0; resizable:1";
	var rtnVal = window.showModalDialog(Com_Parameter.ContextPath+"third/pda/pda_module_label_view/pdaModuleLabelView_edit.jsp", obj, style);
	if(obj != null){
		if(obj.fdName && obj.fdName != ""){
			DocList_AddRow();
			setDocLabelValue(obj,index);
		}
	}
}
//编辑文档页签
function editDocLabel(_this)
{
	if($('input[name="fdModelName"]').val() == '' || $('input[name="fdModelName"]').val() == null){
		alert('<bean:message bundle="third-pda" key="pdaModuleConfigView.validate.notNull.fdName"/>');
		return;
	}
	var index = $(_this).prev().attr('name');
	var cfgInfo = null;
	if($('input[name="fdItems['+index+'].fdCfgInfo"]').val() != null && $('input[name="fdItems['+index+'].fdCfgInfo"]').val() != "")
		cfgInfo = JSON.parse($('input[name="fdItems['+index+'].fdCfgInfo"]').val());
	var obj = {'fdId':$('input[name="fdItems['+index+'].fdId"]').val(),
			   'fdName':$('input[name="fdItems['+index+'].fdName"]').val(),
			   'fdOrder':$('input[name="fdItems['+index+'].fdOrder"]').val(),
			   'fdCfgInfo':cfgInfo,
			   'fdExtendUrl':$('input[name="fdItems['+index+'].fdExtendUrl"]').val(),
			   'fdCfgViewId':$('input[name="fdItems['+index+'].fdCfgViewId"]').val(),
			   'modelName':$('input[name="fdModelName"]').val()
			};
	var style = "dialogWidth:600px; dialogHeight:450px; status:0;scroll:1; help:0; resizable:1";
	var rtnVal = window.showModalDialog(Com_Parameter.ContextPath+"third/pda/pda_module_label_view/pdaModuleLabelView_edit.jsp", obj, style);
	if(obj != null){
		setDocLabelValue(obj,index);
	}
}
//设置动态行里面文档标签配置的值
function setDocLabelValue(obj,index){
	$('input[name="fdItems['+index+'].fdId"]').val(obj.fdId);
	$('input[name="fdItems['+index+'].fdName"]').val(obj.fdName);
	$('input[name="fdItems['+index+'].fdOrder"]').val(obj.fdOrder);
	$('input[name="fdItems['+index+'].fdExtendUrl"]').val(obj.fdExtendUrl);
	$('input[name="fdItems['+index+'].fdCfgInfo"]').val(JSON.stringify(obj.fdCfgInfo));
	$('input[name="fdItems['+index+'].fdCfgViewId"]').val(obj.fdCfgViewId);
}
function save(){
	var index = $("#TABLE_DocList tr").length -1;
	if(!validate())
		return;
	var obj = window.dialogArguments;
	obj.fdName = $('input[name="fdName"]').val();
	obj.fdModelName = $('input[name="fdModelName"]').val();
	var fdItems = new Array();
	for(var i=0;i<index;i++){
		var item = {'fdId':$('input[name="fdItems['+i+'].fdId"]').val(),
					'fdName':$('input[name="fdItems['+i+'].fdName"]').val(),
					'fdOrder':$('input[name="fdItems['+i+'].fdOrder"]').val(),
					'fdCfgInfo':$('input[name="fdItems['+i+'].fdCfgInfo"]').val(),
					'fdExtendUrl':$('input[name="fdItems['+i+'].fdExtendUrl"]').val(),
					'fdCfgViewId':$('input[name="fdItems['+i+'].fdCfgViewId"]').val()
				   };
		fdItems.push(item);
	}
	obj.fdItems = fdItems;
	if(isSimpleModel()){//文档阅读模块
		obj.fdReadingModel = 1;
		var status = null;
		if($('#status').val() != null && $('#status').val() != ""){
			status = JSON.parse($('#status').val())
		}
		var subject = null;
		if($('#subject').val() != null && $('#subject').val() != ""){
			subject = JSON.parse($('#subject').val())
		}
		var summary = new Array();
		$('#summarySelected option').each(function (){
			summary.push(JSON.parse($(this).val()));
		});
		var contents = new Array();
		$('#contentSelected option').each(function (){
			contents.push(JSON.parse($(this).val()));
		});
		var attachments = new Array();
		$('#attachmentSelected option').each(function (){
			attachments.push(JSON.parse($(this).val()));
		});
		var others = new Array();
		$('#othersSelected option').each(function (){
			others.push(JSON.parse($(this).val()));
		});
		var newsModelCfgInfo = {'status':status,
								'subject':subject,
								'summary':summary,
								'contents':contents,
								'attachments':attachments,
								'others':others
							    };
		obj.fdNewsModelCfgInfo = newsModelCfgInfo;
	}else{
		obj.fdReadingModel = 0;
	}
	window.close();
}
function isSimpleModel(){
	var isSimple = false;
	var showModeList = $('input:checkbox[name="fdShowModel"]:checked');
	for(var m=0;m<showModeList.length;m++){
		if(showModeList.get(m).value=="simple")
			isSimple = true;
	}
	return isSimple;
}
function validate(){
	var errorMsg = "";
	var canSave = true;
	if($('input[name="fdName"]').val() == ""){
		errorMsg += '<bean:message bundle="third-pda" key="pdaModuleConfigView.fdName"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
		canSave = false; 
	}
	if(!$('input[name="fdItems[0].fdName"]').val() || $('input[name="fdItems[0].fdName"]').val() == ""){
		errorMsg += '<bean:message bundle="third-pda" key="pdaModuleConfigView.label"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
		canSave = false; 
	}
	if(isSimpleModel()){
		if($('#status').val() == ""){
			errorMsg += '<bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.docStatus"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
			canSave = false; 
		}
		if($('#subject').val() == ""){
			errorMsg += '<bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.docSubject"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
			canSave = false; 
		}
		if($('#summarySelected option').length <= 0){
			errorMsg += '<bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.summary"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
			canSave = false; 
		}
		if($('#contentSelected option').length <= 0){
			errorMsg += '<bean:message bundle="third-pda" key="pdaModuleConfigView.readingModel.content"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
			canSave = false; 
		}
	}
	if(canSave == false)
		alert(errorMsg);
	return canSave;
}
function refreshLastIndex(){
	var tbInfo = DocList_TableInfo["TABLE_DocList"];
	tbInfo.lastIndex = $("#TABLE_DocList tr").length;
}
/*******************************************
功能:两个select中的option的移动
参数:
	fromid:源list的id.  
	toid:目标list的id.  
	isAll参数(true或者false):是否全部移动或添加  
*********************************************/
function listTolist(fromid,toid,isAll) {
	var toSelect = $("#"+toid);
	var selectList = null;
    if(isAll == true) { //全部移动 
    	selectList = $("#"+fromid+" option");
    }else{
    	selectList = $("#"+fromid+" option:selected")
    }  
    selectList.each(function() {   
        var option = $(this);
        var hasVal = false;
        var options = toSelect.find("option");
        for(var i=0; i<options.length;i++){
            if(option.val() == $(options).val()){
            	hasVal = true;
            	break;
            }
        }
        if(!hasVal)
        	option.appendTo(toSelect); 
    });    
}
/*******************************************
功能:select中的option上下移动
参数:
	selectId:必选，list的id.  
	direct：必选，-1：下移动，1上移动
*********************************************/
function removeOption(selectId,direct){
	$("#"+selectId+" option:selected").each(function() {
		if(direct > 0)   
			$(this).prev().before($(this));
		else if(direct < 0)   
			$(this).next().after($(this));   
		
    });   
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>