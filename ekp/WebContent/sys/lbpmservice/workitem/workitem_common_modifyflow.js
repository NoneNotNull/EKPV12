$(document).ready(function(){ 
	if(lbpm.nowProcessorInfoObj==null) return;
	lbpm.globals.initNotionPopedomTR();
}); 
//修改其他节点处理人
lbpm.globals.changeProcessorClick=function (){
	var operatorInfo = lbpm.globals.analysisProcessorInfoToObject();
	if(operatorInfo == null){
		return;
	}
	var handlerId = lbpm.globals.getRolesSelectObj();
	var url = Com_Parameter.ContextPath+"sys/lbpmservice/workitem/sysLbpmMain_mainframe.jsp?nodeId=" + lbpm.nowNodeId + "&handlerIdentity=" + handlerId + "&fdModelName="+lbpm.modelName+"&fdModelId="+lbpm.modelId;

	var IndicatorDiv;
	
	//var getFormFieldListFunc="lbpm.globals.getFormFieldList_"+lbpm.constant.FDKEY;
	//var fieldList = (new Function('return (' + getFormFieldListFunc + '());'))();
	var fieldList = lbpm.globals.getFormFieldList();
	lbpm.globals.getThroughNodes(function(throughtNodes){
		lbpm.globals.clearIndicatorDiv(IndicatorDiv);
		var param = {
		     FormFieldList:fieldList,
		     win:this,
		     throughtNodes:throughtNodes,
		     AfterShow:function(rtnVal){
		    	 if(rtnVal != null){
		    		this.win.lbpm.events.fireListener(lbpm.constant.EVENT_MODIFYNODEATTRIBUTE,rtnVal);		
		 		  }
				}
		    };
			try{
				lbpm.globals.popupWindow(url,720,400,param);
			}catch(e){
				if(window.console){
					console.error(e);
				}
			}
		},
		function (){
			IndicatorDiv = lbpm.globals.openIndicatorDiv(this);
		},
		function(){
			
		}
	);
}

//修改流程信息
lbpm.globals.modifyProcess=function(contentField, statusField){
	var fieldList = lbpm.globals.getFormFieldList();
	var param = {
		processData: lbpm.globals.getProcessXmlString(),
		statusData: document.getElementsByName(statusField)[0].value,
		Window:window,
		FormFieldList:fieldList,
		AfterShow:function(rtnVal){
			if(rtnVal!=null){
				var param={};
			    param.xml=rtnVal;
			    if(this.Window.lbpm && this.Window.lbpm.events)
			    	this.Window.lbpm.events.fireListener(lbpm.constant.EVENT_MODIFYPROCESS,param);
			    else
			    	this.Window.parent.lbpm.events.fireListener(lbpm.constant.EVENT_MODIFYPROCESS,param);
			}
		}
	};
	//TODO 这个字段暂时默认都为0
	var fdIsAllowSetupApprovalType="0";
	//var fdIsAllowSetupApprovalType = document.getElementById("sysWfBusinessForm.fdIsAllowSetupApprovalType").value;
	var fdTemplateModelName = document.getElementById("sysWfBusinessForm.fdTemplateModelName").value;
	var fdTemplateKey = document.getElementById("sysWfBusinessForm.fdTemplateKey").value;
	var modelName = lbpm.globals.getWfBusinessFormModelName();
	
	var url=Com_Parameter.ContextPath+'sys/lbpm/flowchart/page/panel.html?edit=true&extend=oa&template=false&modelName='+modelName+'&deployApproval=' + fdIsAllowSetupApprovalType + '&templateModel=' + fdTemplateModelName + '&templateKey=' + fdTemplateKey + "&modelId=" + lbpm.globals.getWfBusinessFormModelId();
	lbpm.globals.popupWindow(url,window.screen.width,window.screen.height,param);
}
//获取流程图XML
lbpm.globals.getProcessXmlString=function(){
	// 到服务器加载详细信息
	var processXml = document.getElementsByName("sysWfBusinessForm.fdFlowContent")[0].value;
	var data = new KMSSData();
	var fdIsModify=$("input[name='sysWfBusinessForm.fdIsModify']")[0];
	if(fdIsModify==null || fdIsModify.value!="1"){
		data.SendToUrl(Com_Parameter.ContextPath + "sys/lbpm/flowchart/page/detail.jsp?processId=" + lbpm.globals.getWfBusinessFormModelId(), function(req) {
			processXml = req.responseText;
		}, false);
	}
	var xmlObj = XML_CreateByContent(processXml);	
	var xmlNodes = XML_GetNodesByPath(xmlObj,"/*/nodes/*");
	if(xmlNodes && lbpm.modifys){
		$.each(lbpm.modifys, function(index, nodeData) {
			for(var i=0,l=xmlNodes.length;i <l;i++){
				if(xmlNodes[i].getAttribute("id") == nodeData.id){
					for(nodeField in nodeData){
						xmlNodes[i].setAttribute(nodeField,nodeData[nodeField]);
					}	
				}	
			}
		});	
	}	
	return (xmlObj.xml || new XMLSerializer().serializeToString(xmlObj));
};

//选择可查看当前节点的节点add by limh 2010年9月14日
lbpm.globals.selectNotionNodes=function(){
	var curNodeId = lbpm.nowNodeId;
	var data = new KMSSData();

	$.each(lbpm.nodes, function(index, node) {
		if(node.id != curNodeId)
			if(lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_HANDLER,node)) data.AddHashMap({id:node.id, name:node.id+"."+node.name});			
	});
	var dialog = new KMSSDialog(true, true);
	dialog.winTitle = "";
	dialog.AddDefaultOption(data);
	dialog.BindingField(document.getElementsByName("wf_nodeCanViewCurNodeIds")[0], document.getElementsByName("wf_nodeCanViewCurNodeNames")[0], ";");
	dialog.SetAfterShow(function myFunc(rtv){lbpm.globals.updateXml(rtv,"nodeCanViewCurNode");});
	dialog.Show();
}

//将其他可阅读者设定写回fdcontent域 add by limh 2010年9月24日
lbpm.globals.updateXml=function(rtv,type){
	var curNodeId = lbpm.nowNodeId;
	if(rtv){
		//返回json对象
		var rtnNodesMapJSON= new Array();
		var ids = lbpm.globals.arrayToStringByKey(rtv.GetHashMapArray(),"id");
		var names = lbpm.globals.arrayToStringByKey(rtv.GetHashMapArray(),"name");
		if(type=="otherCanViewCurNode"){
			rtnNodesMapJSON.push({
				id:curNodeId,
				otherCanViewCurNodeIds:ids,
				otherCanViewCurNodeNames:names,
				orgattr:"otherCanViewCurNodeIds:otherCanViewCurNodeNames"
			});
		}else if(type=="nodeCanViewCurNode"){
			rtnNodesMapJSON.push({
				id:curNodeId,
				nodeCanViewCurNodeIds:ids,
				nodeCanViewCurNodeNames:names
			});
		}	
		
		var param={};
		param.nodeInfos=rtnNodesMapJSON;
		lbpm.events.fireListener(lbpm.constant.EVENT_MODIFYNODEATTRIBUTE,param);
	}	
};

lbpm.globals.isRootWorkitemOperation = function() {
	if (!lbpm.nowProcessorInfoObj)
		return false;
	var isRootWorkitemOperation = false;
	$.each(lbpm.nowProcessorInfoObj.operations, function() {
		if (lbpm.operations[this.id] && lbpm.operations[this.id].isPassType) {
			isRootWorkitemOperation = true;
			return false;
		}
	});
	return isRootWorkitemOperation;
};

//初始化意见权限add by limh 2010年9月24日
lbpm.globals.initNotionPopedomTR=function(){
	
	var curNodeId = lbpm.nowProcessorInfoObj.nodeId;
	var wf_nodeCanViewCurNodeIds = document.getElementsByName("wf_nodeCanViewCurNodeIds")[0];
	if (wf_nodeCanViewCurNodeIds == null) {
		return;
	}
	var wf_nodeCanViewCurNodeNames = document.getElementsByName("wf_nodeCanViewCurNodeNames")[0];
	var wf_otherCanViewCurNodeIds = document.getElementsByName("wf_otherCanViewCurNodeIds")[0];
	var wf_otherCanViewCurNodeNames = document.getElementsByName("wf_otherCanViewCurNodeNames")[0];

	var nodeCanViewCurNodeTR = document.getElementById("nodeCanViewCurNodeTR");
	var otherCanViewCurNodeTR = document.getElementById("otherCanViewCurNodeTR");
	var curNodeInfoObj = lbpm.globals.getNodeObj(curNodeId);	

	if (!lbpm.globals.isRootWorkitemOperation()) {
		lbpm.globals.hiddenObject(nodeCanViewCurNodeTR, true);
		lbpm.globals.hiddenObject(otherCanViewCurNodeTR, true);
		return;
	}
	//如果是可修改意见权限
	if(curNodeInfoObj.canModifyNotionPopedom=="true"){
		lbpm.globals.hiddenObject(nodeCanViewCurNodeTR, false);
		lbpm.globals.hiddenObject(otherCanViewCurNodeTR, false);
		//为权限设置域赋值
		if(curNodeInfoObj.nodeCanViewCurNodeIds){
			wf_nodeCanViewCurNodeIds.value=curNodeInfoObj.nodeCanViewCurNodeIds;
		}
		if(curNodeInfoObj.nodeCanViewCurNodeNames){
			wf_nodeCanViewCurNodeNames.value=curNodeInfoObj.nodeCanViewCurNodeNames;
		}
		if(curNodeInfoObj.otherCanViewCurNodeIds){
			wf_otherCanViewCurNodeIds.value=curNodeInfoObj.otherCanViewCurNodeIds;
		}
		if(curNodeInfoObj.otherCanViewCurNodeNames){
			wf_otherCanViewCurNodeNames.value=curNodeInfoObj.otherCanViewCurNodeNames;
		}	
	}
	//如果是不可修改意见权限
	else{
		lbpm.globals.hiddenObject(nodeCanViewCurNodeTR, true);
		lbpm.globals.hiddenObject(otherCanViewCurNodeTR, true);
	}
};

//判断当前节点是否具有修改流程信息的权限
lbpm.globals.checkModifyAuthorization=function(currentNodeId){
	var currentNodeObj = lbpm.globals.getNodeObj(currentNodeId);
	var modifyFlowDIV = document.getElementById("modifyFlowDIV");
	var changeProcessorDIV = document.getElementById("changeProcessorDIV");
	var checkChangeFlowTR = document.getElementById("checkChangeFlowTR");
	
	if(lbpm.constant.ROLETYPE == ""){
		var hiddenRowFlag = 0;
		var showChangeFlowTR = lbpm.globals.isRootWorkitemOperation();
		if(currentNodeObj.canModifyFlow == "true"){
			if(modifyFlowDIV != null && showChangeFlowTR){
				lbpm.globals.hiddenObject(modifyFlowDIV, false);
			}
		}else{
			if(modifyFlowDIV != null){
				lbpm.globals.hiddenObject(modifyFlowDIV, true);
				hiddenRowFlag++;
			}
		}
		if(((currentNodeObj.canModifyHandlerNodeIds != null && currentNodeObj.canModifyHandlerNodeIds != "")
				|| (currentNodeObj.mustModifyHandlerNodeIds != null && currentNodeObj.mustModifyHandlerNodeIds != ""))){
			if(changeProcessorDIV != null && showChangeFlowTR){
				lbpm.globals.hiddenObject(changeProcessorDIV, false);
			}
		}else{
			if(changeProcessorDIV != null){
				lbpm.globals.hiddenObject(changeProcessorDIV, true);
				hiddenRowFlag++;
			}
		}
		if(hiddenRowFlag == 2){
			lbpm.globals.hiddenObject(checkChangeFlowTR, true);
		}else{
			var oprNames=lbpm.globals.getOperationParameterJson("operations");
			if(oprNames == null || oprNames.length==0){
				lbpm.globals.hiddenObject(checkChangeFlowTR, true);
			}else{
				if (showChangeFlowTR) lbpm.globals.hiddenObject(checkChangeFlowTR, false);
			}
		}
	}else{
		lbpm.globals.hiddenObject(modifyFlowDIV, true);
		lbpm.globals.hiddenObject(changeProcessorDIV, true);
		lbpm.globals.hiddenObject(checkChangeFlowTR, true);
	}
};
//设置可以修改节点处理人HTML
lbpm.globals.getModifyHandlerHTML=function(nodeObj,hrefIndex,defaultHide,afterChangeFunc,dialogAddsFunc,formulaDialogFunc,handlerIdObj,handlerNameObj){
	if(hrefIndex==null) var hasIndex=false; else var hasIndex=true;
	if(dialogAddsFunc==null) dialogAddsFunc="lbpm.globals.dialog_Address";
	if(formulaDialogFunc==null) formulaDialogFunc="lbpm.globals.setFutureHandlerFormulaDialog";
	var html="";
	var handlerIdentity = (function() {
		if (nodeObj.optHandlerCalType == null || nodeObj.optHandlerCalType == '2') {
			var rolesSelectObj = $("select[name='rolesSelectObj']");
			if (rolesSelectObj.length > 0 && rolesSelectObj[0].selectedIndex > -1) {
				return rolesSelectObj.val();
			}
			return $("input[name='sysWfBusinessForm.fdIdentityId']").val();
		}
 		var rolesIdsArray = $("input[name='sysWfBusinessForm.fdHandlerRoleInfoIds']").val().split(";");
		return rolesIdsArray[0];
	})();
	var optHandlerIds = nodeObj.optHandlerIds == null?"":nodeObj.optHandlerIds;
	var nodeHandlerIds = nodeObj.handlerIds == null?"":nodeObj.handlerIds;
	var optHandlerSelectType = nodeObj.optHandlerSelectType == null?"org":nodeObj.optHandlerSelectType;
	var handlerSelectType = nodeObj.handlerSelectType == null?"org":nodeObj.handlerSelectType;
	//备选公式化 
	var defaultOptionBean = "lbpmOptHandlerTreeService&optHandlerIds=" + encodeURIComponent(optHandlerIds) 
		+ "&currentIds=" + ((handlerSelectType=="formula") ? "" : encodeURIComponent(nodeHandlerIds)) 
		+ "&handlerIdentity=" + handlerIdentity
		+ "&optHandlerSelectType=" + optHandlerSelectType
		+ "&fdModelName=" + lbpm.modelName
		+ "&fdModelId=" + lbpm.modelId;
		//增加搜索条 add by limh 2010年11月4日
	var searchBean = defaultOptionBean + "&keyword=!{keyword}";
	var modelName = lbpm.modelName;
	var hrefObj = "<a href=\"javascript:void(0);\" index=\"" + (hasIndex?hrefIndex:0) + "\"";
	if(nodeObj.useOptHandlerOnly == "true"){
		if(handlerSelectType=="formula"){
			hrefObj += " onclick=\"{Dialog_List(true, null,null, ';', '" + defaultOptionBean + "',function(rtv){"+afterChangeFunc+"(rtv,'"+lbpm.constant.ADDRESS_SELECT_ORG+"','"+nodeObj.id+"')}, '"+searchBean+"', null, null, lbpm.workitem.constant.COMMONSELECTALTERNATIVE);}\"";
		}
		else{
			hrefObj += " onclick=\"{Dialog_List(true, '"+handlerIdObj+"','"+handlerNameObj+"', ';', '" + defaultOptionBean + "',function(rtv){"+afterChangeFunc+"(rtv,'"+lbpm.constant.ADDRESS_SELECT_ORG+"','"+nodeObj.id+"')}, '"+searchBean+"', null, null, lbpm.workitem.constant.COMMONSELECTALTERNATIVE);}\"";
			
		}
		hrefObj += " class='com_btn_link'>" + lbpm.workitem.constant.COMMONSELECTALTERNATIVE + "</a>";
		html += '　　<span style=\''+(defaultHide?"display:none":"")+';\'>' + hrefObj + '</span>';
	}
	else{
		var hrefObj_formula = hrefObj;
		var optHrefObj = hrefObj;
		if(handlerSelectType=="formula"){
			var selectType = (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,nodeObj)) ? 'ORG_TYPE_ALL | ORG_TYPE_ROLE' : 'ORG_TYPE_POSTORPERSON | ORG_TYPE_ROLE';
			hrefObj += " onclick=\"{"+dialogAddsFunc+"(true, null,null, ';', "+selectType+", function(rtv){"+afterChangeFunc+"(rtv,'"+lbpm.constant.ADDRESS_SELECT_ORG+"','"+nodeObj.id+"')}, null, null, null, null, null, null, '" + nodeObj.id + "','"+defaultOptionBean+"');}\"";
			optHrefObj += " onclick=\"{Dialog_List(true, null,null, ';', '" + defaultOptionBean + "',function(rtv){"+afterChangeFunc+"(rtv,'"+lbpm.constant.ADDRESS_SELECT_ORG+"','"+nodeObj.id+"')}, '"+searchBean+"', null, null, lbpm.workitem.constant.COMMONSELECTALTERNATIVE);}\"";
			hrefObj_formula += " onclick=\"{"+formulaDialogFunc+"('"+handlerIdObj+"','"+handlerNameObj+"', '"+modelName+"')}\"";
		}
		else{
			var selectType = (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,nodeObj)) ? 'ORG_TYPE_ALL | ORG_TYPE_ROLE' : 'ORG_TYPE_POSTORPERSON | ORG_TYPE_ROLE';
			hrefObj += " onclick=\"{"+dialogAddsFunc+"(true, '"+handlerIdObj+"','"+handlerNameObj+"', ';', "+selectType+", function(rtv){"+afterChangeFunc+"(rtv,'"+lbpm.constant.ADDRESS_SELECT_ORG+"','"+nodeObj.id+"')}, null, null, null, null, null, null, '" + nodeObj.id + "','"+defaultOptionBean+"');}\"";
			optHrefObj += " onclick=\"{Dialog_List(true, '"+handlerIdObj+"','"+handlerNameObj+"', ';', '" + defaultOptionBean + "',function(rtv){"+afterChangeFunc+"(rtv,'"+lbpm.constant.ADDRESS_SELECT_ORG+"','"+nodeObj.id+"')}, '"+searchBean+"', null, null, lbpm.workitem.constant.COMMONSELECTALTERNATIVE);}\"";
			hrefObj_formula += " onclick=\"{"+formulaDialogFunc+"(null, null, '"+modelName+"')}\"";							
		}
		hrefObj += " title='" + lbpm.workitem.constant.COMMONSELECTADDRESS + "'>" + lbpm.workitem.constant.COMMONSELECTADDRESS + "</a>";
		hrefObj_formula +=  " title='" + lbpm.workitem.constant.COMMONSELECTFORMLIST + "'>" + lbpm.workitem.constant.COMMONSELECTFORMLIST + "</a>";
		optHrefObj +=  " title='" + lbpm.workitem.constant.COMMONSELECTALTERNATIVE + "'>" + lbpm.workitem.constant.COMMONSELECTALTERNATIVE + "</a>";
		if (window.LUI) {
			html = lbpm.globals.getModifyHandlerHTML_LUI(defaultHide, lbpm.workitem.constant.COMMONSELECTADDRESS, [hrefObj, hrefObj_formula, optHrefObj], hrefIndex);
		} else {
			html += '　　<span style=\''+(defaultHide?"display:none":"")+';\'>' + hrefObj + '&nbsp;&nbsp;' + optHrefObj + '&nbsp;&nbsp;' + hrefObj_formula + '</span>';
		}
	}
	return html;
};
//新ued备选列表
lbpm.globals.getModifyHandlerHTML_LUI=function(defaultHide, displayText, actions, hrefIndex){
/*  <div id="divselect">
    <cite>请选择特效分类</cite>
    <ul>
       <li><a href="javascript:;" selectid="1">导航菜单</a></li>
       <li><a href="javascript:;" selectid="2">焦点幻灯片</a></li>
    </ul>
	</div> */
	var html = "<span style='"+(defaultHide?"display:none":"")+"' index='"+hrefIndex+"' class='divselect'><span class='cite' title='" + displayText + "'><a>"+displayText+"</a></span><ul>";
	for (var i = 0; i < actions.length; i ++) {
		var act = actions[i];
		html += "<li>" + act + "</li>";
	}
	html += "</ul></span>";
	return html;
};
$(document).ready(function() {
	$('#operationsTDContent, #nextNodeTD').delegate('.divselect .cite', 'click', function(event) {
		var ul = $(this).closest('.divselect').find('ul');
		if(ul.css("display") == "none" && event.target.tagName != 'A'){
			ul.slideDown("fast");
		}else{
			ul.slideUp("fast");
		}
		event.stopPropagation();
	});
	$('#operationsTDContent, #nextNodeTD').delegate('.divselect .cite a', 'click', function(event) {
		var label = $(this);
		var selectedText = label.text();
		label.closest('.divselect').find('ul li a').each(function() {
			var self = $(this);
			//console.info('a text:' + self.text() + '|' + selectedText);
			if (self.text() == selectedText) {
				self.click();
				return false;
			}
		});
		event.stopPropagation();
	});
	$('#operationsTDContent, #nextNodeTD').delegate(".divselect ul li a", 'click', function(event){
		var self = $(this);
		var txt = self.text();
		self.closest('.divselect').find('.cite a').html(txt);
		self.closest('.divselect').find('ul').hide();
		event.stopPropagation();
	});
	$('#operationsTDContent, #nextNodeTD').click(function(event) {
		var divselect = $(this).find('.divselect'), rtn = false;
		if (divselect.length > 0) {
			divselect.each(function() {
				if ($.contains(this, event.target)) {
					rtn = true;
					return false;
				}
			});
			if (rtn)
				return;
		}
		$(".divselect ul").hide();
	});
	$(document).click(function() {
		$(".divselect ul").hide();
	});
});

//判断是否需要弹出“必须修改该节点的提示” #作者：曹映辉 #日期：2012年7月4日 
lbpm.globals.judgeIsNecessaryAlert=function(nextNode){
	var unnecessaryAlert=false;
	if(lbpm.globals.getThroughNodesCache) {
		var throughNodesCache = lbpm.globals.getThroughNodesCache();
		if(throughNodesCache){
			var throughNodesStr= lbpm.globals.getIdsByNodes(throughNodesCache);
			throughNodesStr=throughNodesStr+","
			if(throughNodesStr.indexOf(nextNode.id+",") == -1)
			{
				//分支计算到不通过该节点时不需要弹出必须修改该节点的提示
				unnecessaryAlert=true;
			}
		}
	}
	return !unnecessaryAlert;
};