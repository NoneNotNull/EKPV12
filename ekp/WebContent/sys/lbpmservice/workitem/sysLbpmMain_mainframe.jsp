<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<!doctype html>
<html>
	<head>
		<meta http-equiv="x-ua-compatible" content="IE=5"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><bean:message key="lbpmNode.processingNode.changeProcessor.title" bundle="sys-lbpmservice"/></title>
	</head>

<script type="text/javascript">
<%
	String KMSS_Parameter_Style = request.getParameter("s_css");
	if(KMSS_Parameter_Style==null || KMSS_Parameter_Style.equals("")){
		Cookie[] cookies = request.getCookies();
		if (cookies != null && cookies.length > 0)
			for (int i = 0; i < cookies.length; i++)
				if ("KMSS_Style".equals(cookies[i].getName())) {
					KMSS_Parameter_Style = cookies[i].getValue();
					break;
				}
	}
	if(KMSS_Parameter_Style==null || KMSS_Parameter_Style.equals(""))
		KMSS_Parameter_Style="default";
	pageContext.setAttribute("KMSS_Parameter_Style", KMSS_Parameter_Style);
	String KMSS_Parameter_ContextPath = request.getContextPath()+"/";
	pageContext.setAttribute("KMSS_Parameter_ContextPath", KMSS_Parameter_ContextPath);
	String KMSS_Parameter_ResPath = KMSS_Parameter_ContextPath+"resource/";
	pageContext.setAttribute("KMSS_Parameter_ResPath", KMSS_Parameter_ResPath);
	String KMSS_Parameter_StylePath = KMSS_Parameter_ResPath + "style/"+KMSS_Parameter_Style+"/";
	pageContext.setAttribute("KMSS_Parameter_StylePath", KMSS_Parameter_StylePath);
%>
var lbpm = new Object();
lbpm.globals = new Object();
var Com_Parameter = {
	ContextPath:"${KMSS_Parameter_ContextPath}",
	ResPath:"${KMSS_Parameter_ResPath}",
	Style:"${KMSS_Parameter_Style}",
	JsFileList:new Array,
	StylePath:"${KMSS_Parameter_StylePath}",
	CurrentUserId:"${KMSS_Parameter_CurrentUserId}"
}; 
</script>
<script type="text/javascript" src="${KMSS_Parameter_ResPath}js/common.js"></script>
<script src="<c:url value="/sys/lbpm/flowchart/js/workflow.js"/>"></script>
<script type="text/javascript"><!--
Com_IncludeFile("dialog.js");
	var dialogObject=window.dialogArguments?window.dialogArguments:opener.Com_Parameter.Dialog;
	//获取父窗口的window对象#作者：曹映辉#日期：2011年10月28日 
	var win = dialogObject.win;
	// 修正跨域问题，不可在子iframe中访问win
	var lbpm = win.lbpm;
	var nodeId = '${param.nodeId}';
	var handlerIdentity = '${param.handlerIdentity}';
	function WorkFlow_PassValue(topframe){
		if(nodeId != null && nodeId != ''){
			if(topframe.contentWindow.document.getElementsByName("nodeId")[0] != null){
				topframe.contentWindow.document.getElementsByName("nodeId")[0].value=nodeId;
			}
		}
		if(handlerIdentity != null && handlerIdentity != ''){
			if(topframe.contentWindow.document.getElementsByName("handlerIdentity")[0] != null){
				topframe.contentWindow.document.getElementsByName("handlerIdentity")[0].value=handlerIdentity;
			}
		}
		topframe.contentWindow.FormFieldList = dialogObject.FormFieldList;
	}
	function WorkFlow_InitialWindow(topframe){
		var throughtNodes = dialogObject.throughtNodes;
		var win = dialogObject.win;
		//流程经过的节点id串 如“N1,N2,N5” @作者：曹映辉 @日期：2011年10月28日 
	
			var throughNodesStr = win.lbpm.globals.getIdsByNodes(throughtNodes);
			var workflowNodeTB = topframe.contentWindow.document.getElementById("workflowNodeTB");
			var currentNode = win.lbpm.globals.getNodeObj(nodeId);
			var nextNodeArray = WorkFlow_GetAllNodeArray(win);
			for(var i = 0; i < nextNodeArray.length; i++){
				if(!(lbpm.globals.judgeIsNecessaryAlert(nextNodeArray[i]))) continue ;
				var nextNodeId = nextNodeArray[i].id;
				if(lbpm_checkModifyNodeAuthorization(currentNode, nextNodeArray[i].id,throughNodesStr)){
					var tr = topframe.contentWindow.document.createElement("tr");
					var td1 = topframe.contentWindow.document.createElement("td");
					td1.innerHTML = "<center>" + nextNodeArray[i].id + "." + nextNodeArray[i].name + "</center>"; //j
					//td1.style.cssText="td_normal_title"
					tr.appendChild(td1);
					var handlerIds, handlerNames, isFormulaType = (nextNodeArray[i].handlerSelectType == 'formula');
					handlerIds = (nextNodeArray[i].handlerIds == null) ? "" : nextNodeArray[i].handlerIds;
					handlerNames = (nextNodeArray[i].handlerNames == null) ? "" : nextNodeArray[i].handlerNames;
					
					var html = '<input flowcontent="true" type="hidden" name="handlerIds_' + nextNodeId + '" value="' + Com_HtmlEscape(handlerIds) + '" ' + (isFormulaType ? 'isFormula="true"' : 'isFormula="false"') + '>';
					html += '<input flowcontent="true" type="text" name="handlerNames_' + nextNodeId + '" value="' + Com_HtmlEscape(handlerNames) + '" readonly class="inputSgl" style="width:95%;"><br>';
					var optHandlerIds = nextNodeArray[i].optHandlerIds==null?"":nextNodeArray[i].optHandlerIds;
					var optHandlerSelectType = nextNodeArray[i].optHandlerSelectType == null?"org":nextNodeArray[i].optHandlerSelectType;
					var defaultOptionBean = "lbpmOptHandlerTreeService&optHandlerIds=" + encodeURIComponent(optHandlerIds) 
						+ "&currentIds=" + ((isFormulaType) ? "" : encodeURIComponent(handlerIds)) 
						+ "&handlerIdentity=" + handlerIdentity
						+ "&optHandlerSelectType=" + optHandlerSelectType
						+ "&fdModelName=" + win.lbpm.modelName
						+ "&fdModelId=" + win.lbpm.modelId;
					//增加搜索条 add by limh 2010年11月4日
					var searchBean = defaultOptionBean + "&keyword=!{keyword}";
					var hrefObj = "<a class=\"com_btn_link\" style=\"margin-left: 8px;\" href=\"javascript:void(0);\"";
					hrefObj+=" onclick=\"WorkFlow_ClearValueForFurtureHandler('"+nextNodeId+"','false');Dialog_List(true, 'handlerIds_" + nextNodeId + "','handlerNames_" + nextNodeId + "', ';', '"+defaultOptionBean+"', function(rtv){lbpm.globals.setFurtureHandlerInfoes(rtv,'false');}, '"+searchBean+"', null, null, '<bean:message key='lbpmNode.processingNode.changeProcessor.select' bundle='sys-lbpmservice'/>');\"";
					hrefObj+=">" + '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.changeProcessor.select.alternative" /></a>';
					if(nextNodeArray[i].useOptHandlerOnly == "true"){
						html += hrefObj;
					}else{ 
						var selectType = win.lbpm.constant.ADDRESS_SELECT_POSTPERSONROLE;
						if (win.lbpm.globals.checkNodeType(win.lbpm.constant.NODETYPE_SEND,nextNodeArray[i])) {
							selectType = win.lbpm.constant.ADDRESS_SELECT_ALLROLE;
						}
						html += '<a class="com_btn_link" style="margin-left: 8px;" href="#" onclick="WorkFlow_ClearValueForFurtureHandler(\''+nextNodeId+'\',\'false\');Dialog_Address(true, \'handlerIds_' + nextNodeId + '\',\'handlerNames_' + nextNodeId + '\', \';\', '+selectType;
						html += ',function(rtv){lbpm.globals.setFurtureHandlerInfoes(rtv,\'false\');});"><bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.changeProcessor.select.organization" /></a>';
						html += hrefObj;
						var hrefObj_formula = "<a class=\"com_btn_link\" style=\"margin-left: 8px;\" href=\"javascript:void(0)\"";
						hrefObj_formula +=" onclick=\"WorkFlow_ClearValueForFurtureHandler('"+nextNodeId+"','true');lbpm.globals.setHandlerFormulaDialog_('handlerIds_" + nextNodeId + "', 'handlerNames_" + nextNodeId + "', '${param.fdModelName}',function(rtv){lbpm.globals.setFurtureHandlerInfoes(rtv,'true');});\"";
						hrefObj_formula+=">" + "<bean:message bundle='sys-lbpmservice' key='lbpmSupport.selectFormList'/></a>";
						html += hrefObj_formula;
					}
					
					var td2 = topframe.contentWindow.document.createElement("td");
					td2.innerHTML = html;
					tr.appendChild(td2);
					var td3 = topframe.contentWindow.document.createElement("td");
					var nodeDesc=nextNodeArray[i].description == null?"":nextNodeArray[i].description;
					nodeDesc=nodeDesc.replace(/(<pre>)|(<\/pre>)/ig,"");
					td3.innerHTML =nodeDesc;
					tr.appendChild(td3);
					workflowNodeTB.appendChild(tr);
				}
			} 

	}
	

	function lbpm_checkModifyNodeAuthorization(nodeObj, allowModifyNodeId,throughNodesStr){
		var index, nodeIds;
		throughNodesStr+=",";
		//如果要修改的节点不在当前计算后应该出现的节点中（及自动决策将流向的分支）这不出现在待修改列表中
		if(throughNodesStr.indexOf(allowModifyNodeId+",") == -1){
			
			return false;
		}
		if(nodeObj.canModifyHandlerNodeIds != null && nodeObj.canModifyHandlerNodeIds != ""){
			nodeIds = nodeObj.canModifyHandlerNodeIds + ";";
			index = nodeIds.indexOf(allowModifyNodeId + ";");
			if(index != -1){
				return true;
			}
		}
		if(nodeObj.mustModifyHandlerNodeIds != null && nodeObj.mustModifyHandlerNodeIds != ""){
			nodeIds = nodeObj.mustModifyHandlerNodeIds + ";";
			index = nodeIds.indexOf(allowModifyNodeId + ";");
			if(index != -1){
				return true;
			}
		}
	
		return false;
	}
	
	function WorkFlow_GetAllNodeArray(win){
		var rtnNodeArray = new Array();
		(win.$).each(win.lbpm.nodes, function(index, node) {
			if(!win.lbpm.globals.checkNodeType(win.lbpm.constant.NODETYPE_START,node) && !win.lbpm.globals.checkNodeType(win.lbpm.constant.NODETYPE_END,node) && !win.lbpm.globals.checkNodeType(win.lbpm.constant.NODETYPE_MANUALBRANCH,node)){
				rtnNodeArray.push(node);
			}
		});
		rtnNodeArray.sort(win.lbpm.globals.getNodeSorter());
		return rtnNodeArray;
	};
--></script>
<frameset framespacing=1 bordercolor=#003048 frameborder=1 rows="*">
	<frame frameborder="0" noresize scrolling="yes" id="topFrame"
		src="<c:url value="/sys/lbpmservice/workitem/sysLbpmMain_changeProcessor_edit.jsp"/>" onload="WorkFlow_PassValue(this);WorkFlow_InitialWindow(this);">
</frameset>
</html>

