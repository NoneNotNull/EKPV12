<%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ page import="com.landray.kmss.sys.authorization.interfaces.SysAuthAreaUtils"%>
<%
   String modelName = request.getParameter("modelName");
%>
<script type="text/javascript">
<!-- 
function changeAreaCheckSelect() {
	//var values="";
	var selected;
	var select = document.getElementsByName("List_Selected");
	for(var i=0;i<select.length;i++) {
		if(select[i].checked){
			//values+=select[i].value;
			//values+=",";
			selected=true;
		}
	}
	if(selected) {
		//values = values.substring(0,values.length-1);
		var url="<c:url value="/sys/authorization/areaChgAction.do"/>";
		url+="?method=areaChgEdit&modelName=${param.modelName}&mainModelName=${param.mainModelName}&docFkName=${param.docFkName}&templateName=${param.templateName}&categoryName=${param.categoryName}";
		var left = document.body.clientWidth/3;
		var top = document.body.clientHeight/3;
		Com_OpenWindow(url,'_blank','left='+left+',top='+top+',height=300px, width=800px, toolbar=0, menubar=0, scrollbars=0, resizable=1, status=1');
	} else {
		alert("<bean:message key="page.noSelect"/>");
	}
}
// -->
</script>
<% if(ISysAuthConstant.IS_AREA_ENABLED && UserUtil.getKMSSUser().isAdmin() && SysAuthAreaUtils.getAuthAreaDictModel(modelName) != null) { %>
<div
	id="cateAreaChg"
	style="display:none;">
	<input
			type="button"
			value="<bean:message key="sysAuthArea.chg.button" bundle="sys-authorization"/>"
			onclick="changeAreaCheckSelect();">
	</div>
<script>OptBar_AddOptBar("cateAreaChg");</script>
<% } %>
