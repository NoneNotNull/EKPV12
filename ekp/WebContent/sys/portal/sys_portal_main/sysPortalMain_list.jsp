<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
Com_IncludeFile("jquery.js");

function toggle (obj){
	var id = obj.id.replace("t_","d_");
	if($("#"+id).is(":visible")){
		$(obj).removeClass("collapse").addClass("expand");
		$("#"+id).hide();
	}else{
		$(obj).removeClass("expand").addClass("collapse");
		$("#"+id).show();
	}
}
function addPortal(){
	var checkAll = $("[name='List_Selected']:checked");
	if(checkAll.length>0){
		if(checkAll.length==1){
			Com_OpenWindow('<c:url value="/sys/portal/sys_portal_main/sysPortalMain.do" />?method=add&parentportal='+checkAll[0].value);
		}else{
			alert("只能选择一个门户进行新建，请重新选择");
			return false;
		}
	}else{
		Com_OpenWindow('<c:url value="/sys/portal/sys_portal_main/sysPortalMain.do" />?method=add');
	}
}
function deleteClick(id,type){
	if(confirm("${ lfn:message('sys-portal:sysPortalPage.msg.delete') }")){
		if(type=='portal')
			location.href = "${KMSS_Parameter_ContextPath}sys/portal/sys_portal_main/sysPortalMain.do?method=delete&fdId="+id;
		if(type=='page'||type=='url')
			location.href = "${KMSS_Parameter_ContextPath}sys/portal/sys_portal_page/sysPortalPage.do?method=delete&fdId="+id;
	}
}
function titleClick(id,type){
	if(type=='portal')
		window.open("${KMSS_Parameter_ContextPath}sys/portal/page.jsp?portalId=" + id);
	if(type=='page'||type=='url')
		window.open("${KMSS_Parameter_ContextPath}sys/portal/page.jsp?pageId="+id);
}

function configClick(id,type){
	if(type=='portal')
		window.open("${KMSS_Parameter_ContextPath}sys/portal/sys_portal_main/sysPortalMain.do?method=edit&fdId="+id);
	if(type=='page'||type=='url')
		window.open("${KMSS_Parameter_ContextPath}sys/portal/sys_portal_page/sysPortalPage.do?method=edit&fdId="+id);
}
</script>
<html:form action="/sys/portal/sys_portal_main/sysPortalMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/portal/sys_portal_main/sysPortalMain.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="addPortal()">
		</kmss:auth>
		<input type="button" value="<bean:message key="button.refresh"/>" onclick="location.reload();" />
	</div>  
	${ table } 
</html:form>
<style type="text/css">
	
	.xpage {
		margin: 10px 0 0;
		border-collapse: collapse;
	}
	.xpage table {	
		border-collapse: collapse;
	}
	.xpage td {
		height: 25px;
	} 
	.xpage .expand {
		cursor:pointer;
		background: url("${KMSS_Parameter_ContextPath}resource/style/default/icons/expand.gif") no-repeat center center;
	}
	.xpage .collapse {
		cursor:pointer;
		background: url("${KMSS_Parameter_ContextPath}resource/style/default/icons/collapse.gif") no-repeat center center;
	}
	.xpage .tr_listrow1 td, .xpage .tr_listrow2 td, .xpage .tr_listrowcur td {
		border-top: 3px solid #fff !important;
		border-bottom: 3px solid #fff !important;
	} 
	.tr_listrowo {
		background: #6fb2eb;
	}
</style>
<script>
//:not(:first)
$(".xpage tr[over='yes']").each(function(i){
	if(i % 2 == 0){
		$(this).attr("class","tr_listrow1");
	}else{
		$(this).attr("class","tr_listrow2");
	}
});

$(".xpage tr[over='yes']").hover(
	  function (evt) {
	    $(this).addClass("tr_listrowo");
	    evt.stopPropagation();
	  },
	  function (evt) {
	    $(this).removeClass("tr_listrowo");
	    evt.stopPropagation();
	  }
);
</script>
<script>
function selectalllportal(obj){
	var checkAll = document.getElementsByName('List_Selected');
	for (var i=0; i<checkAll.length; i++)
		 checkAll[i].checked = obj.checked;
}
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>