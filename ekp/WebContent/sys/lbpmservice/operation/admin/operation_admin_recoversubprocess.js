lbpm.globals.adminOperationTypeRecoverBuildHtml=function() {
	var tableDiv = document.getElementById("subprocess_list_table_temp");
	var html = tableDiv.innerHTML;
	html = html.replace("_id_", "subprocess_list_table");
	html = html.replace("_recoverProcessIds_", "workflowRecoverProcessIds");
	html = html.replace("_key_", "key");
	return html;
};

lbpm.globals.adminOperationTypeRecover_AddNewSubprocessRows=function() {
	var url = Com_Parameter.ContextPath + "sys/lbpmservice/operation/admin/operation_admin_recover_frame.jsp";
	var fdFlowContent = document.getElementsByName("sysWfBusinessForm.fdFlowContent")[0];
	var param=WorkFlow_LoadXMLData(fdFlowContent.value);
	param.AfterShow=function(rtnVal){
		if(rtnVal!=null){
			var table = document.getElementById("subprocess_list_table");
			lbpm.globals.adminOperationTypeRecover_ClearSubprocessTable(table);
			lbpm.globals.setRecoverProcessIdsToWorkitemParemater();
			// ajax 获取节点下所有数据
			var modelId = document.getElementsByName("sysWfBusinessForm.fdModelId")[0];
			var ajaxurl = Com_Parameter.ContextPath + 'sys/lbpmservice/support/lbpm_process/lbpmProcess.do?method=getSubprocessAjax&fdId=';
			ajaxurl += modelId.value;
			if (rtnVal.scopeType == '1') {
				ajaxurl += "&nodeIds=" + rtnVal.nodeIds;
			}
			var kmssData = new KMSSData();
			kmssData.SendToUrl(ajaxurl, function(http_request) {
				var responseText = http_request.responseText;
				var json = eval("("+responseText+")");
				if (json.success == "true") {
					var rows = json.processes;
					for (var i = 0; i < rows.length; i ++) {
						lbpm.globals.adminOperationTypeRecover_AddSubprocessRow(
								document.getElementById("subprocess_list_table"), rows[i]);
					}
					lbpm.globals.setRecoverProcessIdsToWorkitemParemater();
				}
			});
		}
	};

	lbpm.globals.popupWindow(url, 600, 200, param);

};
lbpm.globals.adminOperationTypeRecover_ClearSubprocessTable=function(table) {
	for (var i = table.rows.length - 1; i > 0; i --) {
		table.deleteRow(i);
	}
};
lbpm.globals.adminOperationTypeRecover_AddSubprocessRow=function(table, rowData) {
	
	var row = table.insertRow(-1);
	var col1 = row.insertCell(-1);
	col1.innerHTML = document.getElementById("subprocess_list_table_col_1").innerHTML;
	var col2 = row.insertCell(-1);
	col2.innerHTML = document.getElementById("subprocess_list_table_col_2").innerHTML;

	lbpm.globals.adminOperationTypeRecover_EditProcessColHTML(row, col1, rowData);
};
lbpm.globals.adminOperationTypeRecover_EditProcessColHTML=function(row, col, rowData) {
	var span = col.getElementsByTagName("span")[0];
	var text = rowData.name + " (" + rowData.creator + ")";
	var html = '<a href="'+ rowData.url + '" target="_blank">' + Com_HtmlEscape(text) + '</a>';
	span.innerHTML = html;
	var processid = col.getElementsByTagName("input")[0];
	processid.value = rowData.id;
}
lbpm.globals.adminOperationTypeRecover_DeleteSubprocessRow=function(row) {
	row = row.parentNode.parentNode;
	row.parentNode.removeChild(row);
	lbpm.globals.setRecoverProcessIdsToWorkitemParemater();
};
lbpm.globals.setRecoverProcessIdsToWorkitemParemater=function() {
	var ids = lbpm.globals.buildRecoverProcessIds();
	var idsfield = document.getElementById("workflowRecoverProcessIds");
	idsfield.value = ids;
};
lbpm.globals.buildRecoverProcessIds=function() {
	var doms = document.getElementsByName("workflow_recover_subprocessid");
	var ids = [];
	if (doms.length > 0) {
		for (var i = 0; i < doms.length; i ++) {
			var dom = doms[i];
			if (dom.value != "") {
				ids.push(dom.value);
			}
		}
	}
	return ids.join(";");
};