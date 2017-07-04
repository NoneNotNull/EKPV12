var lbpm = parent.lbpm;
var location_href = location.href;
var IdPre = Com_GetUrlParameter(location_href,"IdPre");
var NODESTYLE_STATUSCOLOR = new Array("#E1F0FD", "#FFFFEE", "#E4FEEF", "#FED6D6");

/*
 * 流程表格页面初始化
 * 
 */
function FlowTable_Initialize(){
	FlowTable_DrawTable();
	var isShowAllRows = document.getElementById("isShowAllRows");
	FlowTable_IsShowAllRows(isShowAllRows);
}

/*
*重新绘制流程表格 
*
*/
function FlowTable_ReDrawTable(){
	var obj_tbody = document.getElementById("flowTableTr");	
	var childRows1 = obj_tbody.childNodes;
	for(var i=childRows1.length - 1;i>-1;i--){
		obj_tbody.removeChild(childRows1[i]);
	}
	var obj_fieldDiv = document.getElementById("fieldDiv");	
	var	childRows2 = obj_fieldDiv.childNodes;
	for(var j=childRows2.length - 1;j>-1;j--){
		obj_fieldDiv.removeChild(childRows2[j]);
	}
	FlowTable_Initialize();
}

/*
 *绘制流程表格 
 *
 */
function FlowTable_DrawTable() {
	var changeProcessorDIV = parent.document
			.getElementById("changeProcessorDIV");
	var fieldDiv = document.getElementById("fieldDiv");
	var canChangeProcessor = false; // 是否有权限修改处理人；
	if (changeProcessorDIV && changeProcessorDIV.style.display != "none") {
		canChangeProcessor = true;
	}

	// 每个节点绘制一行表格
	var nodes = [];
	for (var n in lbpm.nodes) {
		nodes.push(lbpm.nodes[n]);
	}
	// 照搬老流程排序方案
	nodes.sort(lbpm.globals.getNodeSorter());
	var obj_tb = document.getElementById("flowTable");
	$.each(nodes, function(index, nodeData) {
		var obj_tr = obj_tb.insertRow(-1);
		
		var isHandlerNode=lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_HANDLER,nodeData);
		var isDraftNode=lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_DRAFT,nodeData);
		if(!isHandlerNode || isDraftNode){
			obj_tr.setAttribute("canHideRow", "yes");
			obj_tr.style.display = "none";
		}
		//节点
		var obj_td = obj_tr.insertCell(-1);
		obj_tr.setAttribute("nodeId", nodeData.id);
		obj_td.innerHTML = nodeData.id;
		obj_td = obj_tr.insertCell(-1);
		// 节点名
		obj_td.innerHTML = nodeData.name;
		// 处理人
		obj_td = obj_tr.insertCell(-1);
		
		var handlerLabel = "<label id='handlerLabel_" + nodeData.id + "'>";
		if(isHandlerNode && nodeData.handlerIds){
			if (nodeData.handlerSelectType == "formula") {
				( function(lbpm, nodeId) {
					lbpm.globals.formulaNextNodeHandler(nodeData.handlerIds, false, lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,nodeData),function(data) {
						var handler = "";
						var handlerArray = data.GetHashMapArray();
						if (handlerArray.length > 0) {
							for ( var j = 0; j < handlerArray.length; j++) {
								handler += ";"
										+ lbpm.globals.htmlUnEscape(handlerArray[j].name);
							}
							handler = handler.substring(1);
						};
						$("#handlerLabel_"+nodeId).html(handler);
						});
					}
				)(lbpm, nodeData.id);
			} else {
				( function(lbpm, nodeId) {
					lbpm.globals.parseNextNodeHandler(nodeData.handlerIds, false, lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,nodeData),function(data) {
						var handler = "";
						var handlerArray = data.GetHashMapArray();
						if (handlerArray.length > 0) {
							for ( var j = 0; j < handlerArray.length; j++) {
								handler += ";"
										+ lbpm.globals.htmlUnEscape(handlerArray[j].name);
							}
							handler = handler.substring(1);
						};
						$("#handlerLabel_"+nodeId).html(handler);
						});
					}
				)(lbpm, nodeData.id);
			}
			handlerLabel += lbpm.constant.LOADINGMSG;
		} else if(isDraftNode){
			handler = lbpm.draftorName;
			handlerLabel += handler;
		}
		handlerLabel += "</label>";
		var processHtml = handlerLabel;
		//是人工操作类节点
		if (isHandlerNode) {
			//有权限的情况下，增加处理人修改链接
			if (canChangeProcessor
					&& lbpm.globals.checkModifyNextNodeAuthorization(nodeData.id)) {
				// 非驳回返回本节点
				var toRefuseThisNodeId=lbpm.globals.getOperationParameterJson("toRefuseThisNodeId");
				if (!toRefuseThisNodeId) {
					processHtml += "<SPAN modifyNode='"+nodeData.id+"'>"+FlowTable_CreateDialog(nodeData)+"</SPAN>";
				}
			}
		}
		obj_td.innerHTML = processHtml;

		// 节点类型及审批方式
		var processMethod = "";
		if (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_REVIEW,nodeData)) {
			processMethod += lbpm.constant.REVIEWPOINT;
		} else if (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SIGN,nodeData)) {
			processMethod += lbpm.constant.SIGNPOINT;
		};
		switch (nodeData.processType) {
		case "0":
			processMethod += lbpm.constant.PROCESSTYPE_0;
			break;
		case "1":
			processMethod += lbpm.constant.PROCESSTYPE_1;
			break;
		case "2":
			processMethod += (!lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SIGN,nodeData)) ? lbpm.constant.PROCESSTYPE_20
					: lbpm.constant.PROCESSTYPE_21;
			break;
		}
		obj_td = obj_tr.insertCell(-1);
		obj_td.innerHTML = processMethod;

		// 流向
		var nodeObjs = nodeData.endLines;
		var nextObjs = "";
		if (nodeObjs && nodeObjs.length > 0) {
			for ( var j = 0; j < nodeObjs.length; j++) {
				nextObjs += ";" + (nodeObjs[j].endNode).id + "."
						+ (nodeObjs[j].endNode).name;
			}
			nextObjs = nextObjs.substring(1);
			nextObjs = nextObjs.replace(/;/gi, "\r");
		}

		obj_td = obj_tr.insertCell(-1);
		if (nextObjs) {
			obj_td.innerHTML = nextObjs;
		}

		//备注
		obj_td = obj_tr.insertCell(-1);
		switch (nodeData.Status){
		case lbpm.constant.STATUS_UNINIT:
			obj_td.innerHTML="";
			break;
		case lbpm.constant.STATUS_NORMAL:
			obj_td.innerHTML=lbpm.constant.STATUS_NORMAL_MSG;
			break;
		case lbpm.constant.STATUS_PASSED:
			obj_td.innerHTML=lbpm.constant.STATUS_PASSED_MSG;
			break;
		case lbpm.constant.STATUS_RUNNING:
			obj_td.innerHTML=lbpm.constant.STATUS_RUNNING_MSG;
			break;
		}
		// 行状态颜色标注

		obj_tr.style.backgroundColor = NODESTYLE_STATUSCOLOR[nodeData.Status];

		var handlerIdsObj;
		var handlerNamesObj;
		if (nodeData.handlerIds) {
			handlerIdsObj = $("<input type='hidden' name='handlerIds_"
							+ nodeData.id
							+ "' value='"
							+ nodeData.handlerIds + "' />");
			handlerNamesObj = $("<input type='hidden' name='handlerNames_"
							+ nodeData.id
							+ "' value='"
							+ Com_HtmlEscape(nodeData.handlerNames) + "' />");
		} else {
			handlerIdsObj = $("<input type='hidden' name='handlerIds_"
							+ nodeData.id + "' value='' />");
			handlerNamesObj = $("<input type='hidden' name='handlerNames_"
							+ nodeData.id + "' value='' />");
		}
		$(fieldDiv).append(handlerIdsObj);
		$(fieldDiv).append(handlerNamesObj);
	});
}
 
 /*
  * 重新设置父窗口Iframe的大小
  * 
  */
function FlowTable_ResizeIframe(){
	if(document.body.scrollHeight<20){
 		setTimeout("FlowTable_ResizeIframe();", 100);
 		return;
 	}
 	var ifm= parent.document.getElementById(IdPre+"WF_TableIFrame"); 
 	var subWeb = parent.document.frames ? parent.document.frames[IdPre+"WF_TableIFrame"].document : ifm.contentDocument; 
 	if(ifm != null && subWeb != null) { 		
 		ifm.height = subWeb.body.scrollHeight; 
 	} 
}
function FlowTable_IsFilterRow(obj,fromEvent){
 	var rows = document.getElementsByTagName("tr");
 	if(rows.length <= 0){
 		return ;	
 	}
 	var IndicatorDiv;
 	// 过滤掉流程自动决策分支不经过的节点，获取正确的节点
 	lbpm.globals.getThroughNodes(function(throughtNodes){
 		var str = lbpm.globals.getIdsByNodes(throughtNodes) + ",";
 		if(obj.checked){
 			for(var i=0;i<rows.length;i++){
 				if(rows[i].getAttribute("nodeId") && str.indexOf(rows[i].getAttribute("nodeId")+",")==-1){
 					rows[i].style.display="none";
 				}
 			}
 		}
 		else{
 			if(document.getElementById("isShowAllRows").checked){
 				for(var i=0;i<rows.length;i++){
 					rows[i].style.display="";
 				}
 			}
 			else{
 				for(var i=0;i<rows.length;i++){
 					if(rows[i].getAttribute("canHideRow")=="yes"){
 						rows[i].style.display="none";
 					}
 					else{
 						rows[i].style.display="";
 					}
 				}	
 			}
 		}
 		FlowTable_ResizeIframe();
 	},
 	//请求前处理函数
	function(){
		IndicatorDiv = lbpm.globals.openIndicatorDiv(this);
	},
	//请求完成后处理函数
	function(){
		lbpm.globals.clearIndicatorDiv(IndicatorDiv,this);
	});
}

function FlowTable_IsShowAllRows(obj){
 	var rows = document.getElementsByTagName("tr");
 	if(rows.length > 0){
 		document.getElementById("isFilterRow").checked=false;
 		if(obj.checked){
 			for(var i=0;i<rows.length;i++){
 					rows[i].style.display="";
 			}
 		}
 		else{
 			for(var i=0;i<rows.length;i++){
 				if(rows[i].getAttribute("canHideRow")=="yes"){
 					rows[i].style.display="none";
 				}
 				else{
 					rows[i].style.display="";
 				}
 			}
 		}
 		FlowTable_ResizeIframe();
 	}
}

/*
 * 生成选择对话框链接相关html代码
 * 
 */
function FlowTable_CreateDialog(nodeData){
 	var html="";
 	var nextNodeHandlerIds = "";
 	var nextNodeHandlerNames = "";
 	if(nodeData.handlerIds != null){
 		nextNodeHandlerIds = nodeData.handlerIds;
 		nextNodeHandlerNames = nodeData.handlerNames;
 	}
	var handlerIdentity = "";
	var rolesSelectObj = parent.document.getElementsByName("rolesSelectObj")[0];
	if(rolesSelectObj != null && rolesSelectObj.selectedIndex > -1){
		handlerIdentity = rolesSelectObj.options[rolesSelectObj.selectedIndex].value;
	}else{
		var handlerIdentityIdsObj = parent.document.getElementById("sysWfBusinessForm.fdHandlerRoleInfoIds");
		var rolesIdsArray = handlerIdentityIdsObj.value.split(";");
		handlerIdentity = rolesIdsArray[0];
	}
	var optHandlerIds = nodeData.optHandlerIds == null?"":nodeData.optHandlerIds;
	var optHandlerSelectType = nodeData.optHandlerSelectType == null?"org":nodeData.optHandlerSelectType;
	var handlerSelectType = nodeData.handlerSelectType == null?"org":nodeData.handlerSelectType;
	var defaultOptionBean = "lbpmOptHandlerTreeService&optHandlerIds=" + encodeURIComponent(optHandlerIds) 
		+ "&currentIds=" + ((handlerSelectType=="formula") ? "" : encodeURIComponent(nextNodeHandlerIds)) 
		+ "&handlerIdentity=" + handlerIdentity
		+ "&optHandlerSelectType=" + optHandlerSelectType
		+ "&fdModelName=" + lbpm.modelName
		+ "&fdModelId=" + lbpm.modelId;
	var searchBean = defaultOptionBean + "&keyword=!{keyword}";
	var modelName = lbpm.ModelName;
	var hrefObj = "<a href=\"javascript:void(0);\"";
	if(nodeData.useOptHandlerOnly == "true"){
		if(optHandlerSelectType=="formula"){
	   		hrefObj += " onclick='Dialog_List(true,null,null, \";\", \"" + defaultOptionBean + "\",function(rtv){FlowTable_AfterChangeHandler(rtv,\""+nodeData.id+"\",lbpm.constant.ADDRESS_SELECT_ORG)}, \""+searchBean+"\", null, null,lbpm.workitem.constant.COMMONCHANGEPROCESSORSELECT);'";
		}
		else{
			hrefObj += " onclick='Dialog_List(true, \"handlerIds_"+nodeData.id+"\",\"handlerNames_"+nodeData.id+"\", \";\", \"" + defaultOptionBean + "\",function(rtv){FlowTable_AfterChangeHandler(rtv,\""+nodeData.id+"\",lbpm.constant.ADDRESS_SELECT_ORG)}, \""+searchBean+"\", null, null,lbpm.workitem.constant.COMMONCHANGEPROCESSORSELECT);'";
		}
		hrefObj += ">" + lbpm.workitem.constant.COMMONSELECTALTERNATIVE + "</a>";
		html += '&nbsp;&nbsp;' + hrefObj;
	}else{
		var hrefObj_formula = "<a href=\"javascript:void(0);\"";
		var optHrefObj = hrefObj;
		if(handlerSelectType=="formula"){
			var selectType = (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,nodeData)) ? 'ORG_TYPE_ALL | ORG_TYPE_ROLE' : 'ORG_TYPE_POSTORPERSON | ORG_TYPE_ROLE';
			hrefObj += " onclick='FlowTable_Dialog_Address(true, null,null, \";\", "+selectType+",function(rtv){FlowTable_AfterChangeHandler(rtv,\""+nodeData.id+"\",lbpm.constant.ADDRESS_SELECT_ORG)}, null, null, null, null, null, null, \"" + nodeData.id + "\",\""+defaultOptionBean+"\");'";
			hrefObj_formula += " onclick='FlowTable_HandlerFormulaDialog(\"handlerIds_"+nodeData.id+"\", \"handlerNames_"+nodeData.id+"\", \""+modelName+"\", function(rtv){FlowTable_setBackFormulaValue(rtv,\"handlerIds_"+nodeData.id+"\",\"handlerNames_"+nodeData.id+"\",\""+nodeData.id+"\");})'";
			optHrefObj += " onclick='Dialog_List(true,null,null, \";\", \"" + defaultOptionBean + "\",function(rtv){FlowTable_AfterChangeHandler(rtv,\""+nodeData.id+"\",lbpm.constant.ADDRESS_SELECT_ORG)}, \""+searchBean+"\", null, null, lbpm.workitem.constant.COMMONCHANGEPROCESSORSELECT);'";
		}
		else{
			var selectType = (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,nodeData)) ? 'ORG_TYPE_ALL | ORG_TYPE_ROLE' : 'ORG_TYPE_POSTORPERSON | ORG_TYPE_ROLE';
			hrefObj += " onclick='FlowTable_Dialog_Address(true, \"handlerIds_"+nodeData.id+"\",\"handlerNames_"+nodeData.id+"\", \";\", "+selectType+",function(rtv){FlowTable_AfterChangeHandler(rtv,\""+nodeData.id+"\",lbpm.constant.ADDRESS_SELECT_ORG)}, null, null, null, null, null, null, \"" + nodeData.id + "\",\""+defaultOptionBean+"\");'";			
			hrefObj_formula += " onclick='FlowTable_HandlerFormulaDialog(null, null, \""+modelName+"\", function(rtv){FlowTable_setBackFormulaValue(rtv,\"handlerIds_"+nodeData.id+"\",\"handlerNames_"+nodeData.id+"\",\""+nodeData.id+"\");})'";
			optHrefObj += " onclick='Dialog_List(true, \"handlerIds_"+nodeData.id+"\",\"handlerNames_"+nodeData.id+"\", \";\", \"" + defaultOptionBean + "\",function(rtv){FlowTable_AfterChangeHandler(rtv,\""+nodeData.id+"\",lbpm.constant.ADDRESS_SELECT_ORG)}, \""+searchBean+"\", null, null, lbpm.workitem.constant.COMMONCHANGEPROCESSORSELECT);'";
		}
		hrefObj += " class=\"com_btn_link\">" + lbpm.workitem.constant.COMMONSELECTADDRESS + "</a>";
		hrefObj_formula += " class=\"com_btn_link\">" + lbpm.workitem.constant.COMMONSELECTFORMLIST + "</a>";
		optHrefObj += " class=\"com_btn_link\">" + lbpm.workitem.constant.COMMONSELECTALTERNATIVE + "</a>";
		html += '&nbsp;' + hrefObj;	
		html += '&nbsp;' + optHrefObj;	
		html += '&nbsp;' + hrefObj_formula;	
	}
 	return html;
}
  
/*
 * 改变处理人后调用该函数，刷新处理人显示并同步调用父窗口相关方法。
 *
 */
function FlowTable_AfterChangeHandler(rtv,nodeId,handlerSelectType){
	var handlerLabel = document.getElementById("handlerLabel_"+nodeId);	
  	if(rtv){
  		if(rtv.GetHashMapArray()){
  			
  			var handlersArray = rtv.GetHashMapArray();
  			var handlerIds="";
  			var handlerNames="";
  			if(handlersArray.length > 0) {
	  			for(var i=0;i<handlersArray.length;i++){
	  				handlerIds+=";"+handlersArray[i].id;
	  				handlerNames+=";"+handlersArray[i].name;
	  			}
	  			handlerIds = handlerIds.substring("1");
	  			handlerNames = handlerNames.substring("1");
  			}
  			var nextNode = lbpm.nodes[nodeId];
  			// 直接计算公式
  			var dataNextNodeHandler;
			if(handlerSelectType=="formula"){
				dataNextNodeHandler=lbpm.globals.formulaNextNodeHandler(handlerIds,true,lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,nextNode));
			}else{
				dataNextNodeHandler=lbpm.globals.parseNextNodeHandler(handlerIds,true,lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,nextNode));
			}
			var nextNodeHandlerNames4View=""
			for(var j=0;j<dataNextNodeHandler.length;j++){
				if(nextNodeHandlerNames4View==""){
					nextNodeHandlerNames4View=dataNextNodeHandler[j].name;
				}else{
					nextNodeHandlerNames4View+=";"+dataNextNodeHandler[j].name;
				}						
			}
  			if(handlerIds==""||handlerIds==null){
  				handlerLabel.innerHTML=lbpm.constant.COMMONNODEHANDLERORGEMPTY;
  			}
  			else{
  				handlerLabel.innerHTML = nextNodeHandlerNames4View;
  			};	
  			// 返回json对象
  			var rtnNodesMapJSON= new Array();
  			rtnNodesMapJSON.push({
  				id:nodeId,
  				handlerSelectType:handlerSelectType,
  				handlerIds:handlerIds,
  				handlerNames:handlerNames
  			});
  		    var param={};
  		    param.sourceObj=location_href;
  		    param.nodeInfos=rtnNodesMapJSON;
  		    lbpm.events.fireListener(lbpm.constant.EVENT_MODIFYNODEATTRIBUTE,param);
  		    FlowTable_ResizeIframe();
  		}
  	}
}

  //公式域修改处理人后回写及设置即将流向 add by limh 2011年1月12日
function FlowTable_setBackFormulaValue(rtv,idField,nameField,nodeId){
  	if("string" == typeof(idField)){
  		idField = document.getElementsByName(idField)[0];
  	}
  	if("string" == typeof(nameField)){
  		nameField = document.getElementsByName(nameField)[0];
  	}
  	if(rtv){
  		var rtvArray = rtv.GetHashMapArray();
  		if(rtvArray){
  			if(rtvArray[0]){
  				var idValue = "";
  				var nameValue = "";			
  				for(var i=0;i<rtvArray.length;i++){
  					idValue += ";"+rtvArray[i]["id"];
  					nameValue += ";"+rtvArray[i]["name"];
  				}
  				idField.value = idValue.substring(1);
  				nameField.value =  nameValue.substring(1);
  				FlowTable_AfterChangeHandler(rtv,nodeId,lbpm.constant.ADDRESS_SELECT_FORMULA);
  			}
  		}
  	}
  }

  //从组织架构中选择并添加默认的备选列表
function FlowTable_Dialog_Address(mulSelect, idField, nameField, splitStr, selectType, action, startWith, isMulField, notNull, winTitle, treeTitle, exceptValue, nodeId, defaultOptionBean){
  	var dialog = new KMSSDialog(mulSelect);
  	dialog.winTitle = winTitle;
  	dialog.treeTitle = treeTitle;
  	dialog.addressBookParameter = new Array();
  	
  	if(selectType==null || selectType==0)
  		selectType = ORG_TYPE_ALL;
  	dialog.addressBookParameter.exceptValue = exceptValue;
  	dialog.addressBookParameter.selectType = selectType;
  	dialog.addressBookParameter.startWith = startWith;
  	dialog.BindingField(idField, nameField, splitStr, isMulField);
  	dialog.SetAfterShow(action);
  	dialog.AddDefaultOptionBeanData(defaultOptionBean);
  	if(notNull!=null)
  		dialog.notNull = notNull;
  	dialog.URL = Com_Parameter.ResPath + "jsp/address_main.jsp";
  	dialog.Show(640, 480);
}

function FlowTable_HandlerFormulaDialog(idField, nameField, modelName, action) {
  	var formList = [];
  	if (lbpm.globals.getFormFieldList) {
  		formList = lbpm.globals.getFormFieldList();
  	} else {
  		formList = Formula_GetVarInfoByModelName(modelName);
  	}
  	Formula_Dialog(idField,
  			nameField,
  			formList, 
  			"com.landray.kmss.sys.organization.model.SysOrgElement[]",
  			action,
  			"com.landray.kmss.sys.lbpm.engine.formula.LbpmFunction",
  			modelName);
}

function modifyHandlerListener(param){
	if(location_href==param.sourceObj){
  		var changeProcessorDIV = parent.document.getElementById("changeProcessorDIV");
  		var canChangeProcessor = false; // 是否有权限修改处理人；
  		if (changeProcessorDIV && changeProcessorDIV.style.display != "none") {
  			canChangeProcessor = true;
  		}
  		var obj=param.nodeInfos;
  		var html="";
  		if (canChangeProcessor
				&& lbpm.globals.checkModifyNextNodeAuthorization(obj[0].id)) {
  			html= FlowTable_CreateDialog(lbpm.nodes[obj[0].id]);
  			var span=$("span[modifyNode='"+obj[0].id+"']")[0];
  	  		span.innerHTML=html;
  	  		document.getElementsByName("handlerIds_"+obj[0].id)[0].value=obj[0].handlerIds;
	  		document.getElementsByName("handlerNames_"+obj[0].id)[0].value=obj[0].handlerNames;
		}
  	}else{
  		FlowTable_ReDrawTable();
  	}
}
  
function selectedManualListener(param){
	if(document.getElementById("isFilterRow").checked){
		//要单击两次才正确
		document.getElementById("isFilterRow").click();
		document.getElementById("isFilterRow").click();
	}
}
lbpm.events.addListener(lbpm.constant.EVENT_MODIFYNODEATTRIBUTE,modifyHandlerListener);
lbpm.events.addListener(lbpm.constant.EVENT_SELECTEDMANUAL,selectedManualListener);
lbpm.events.addListener(lbpm.constant.EVENT_SELECTEDFUTURENODE,selectedManualListener);
  