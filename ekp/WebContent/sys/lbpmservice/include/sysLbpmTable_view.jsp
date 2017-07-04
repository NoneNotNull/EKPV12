<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("jquery.js|formula.js|dialog.js|data.js");
</script>
<script>
var qdomain = Com_GetUrlParameter(location.href, "domain");
if (qdomain != null && qdomain != '') {
	document.domain = qdomain;
}
function initialPage(){
	try {
		var arguObj = document.getElementById("flowTable");
		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			var height = arguObj.offsetHeight + 0;
			if(height>0)
				window.frameElement.style.height = height + "px";
		}
		setTimeout(initialPage, 200);
	} catch(e) {
	}
}
Com_AddEventListener(window,'load',function()  {
	setTimeout(initialPage, 200);
});
</script>
<script>
Com_IncludeFile("syslbpmtable.js","${KMSS_Parameter_ContextPath}sys/lbpmservice/include/","js",true);
</script>

</head>
<body style="margin:0px" onload="FlowTable_Initialize();" >
<div id="fieldDiv" style="display:none" >
</div>

<table class="tb_normal" width="100%"  id="flowTable">
	<tr class="tr_normal_title">
		<td colspan="6" align="left">
			<label>
			<input type="checkbox" name="isShowAllRows" id="isShowAllRows" onclick="FlowTable_IsShowAllRows(this)" />
			<bean:message key = "lbpmProcessTable.showAllRow" bundle="sys-lbpmservice" />
			</label>
			<label>
			<input type="checkbox" name="isFilterRow" id="isFilterRow" onclick="FlowTable_IsFilterRow(this)" />
			<bean:message key = "lbpmProcessTable.filterRow" bundle="sys-lbpmservice" />
			</label>
		</td>
	</tr>
	<tr class="tr_normal_title">
		<td  width="5%"><bean:message key = "lbpmProcessTable.nodeId" bundle="sys-lbpmservice" />
		</td>
		<td  width="20%"><bean:message key = "lbpmProcessTable.nodeName" bundle="sys-lbpmservice" />
		</td>
		<td  width="30%"><bean:message key = "lbpmProcessTable.nodeHandler" bundle="sys-lbpmservice" />
		</td>
		<td  width="15%"><bean:message key = "lbpmProcessTable.nodeHandMethod" bundle="sys-lbpmservice" />
		</td>
		<td  width="20%"><bean:message key = "lbpmProcessTable.nodeFlowTo" bundle="sys-lbpmservice" />
		</td>
		<td ><bean:message key = "lbpmProcessTable.nodeDescribe" bundle="sys-lbpmservice" />
		</td>
	</tr>
	<tbody id="flowTableTr" >
	</tbody>
</table>

</body>
</html>