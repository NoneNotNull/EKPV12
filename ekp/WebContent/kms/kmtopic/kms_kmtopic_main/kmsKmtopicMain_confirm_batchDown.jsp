<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js");
</script>
<script>

/****************************************
 * 获取域名
 ***************************************/
function getHost(){
	var host = location.protocol.toLowerCase()+"//" + location.hostname;
	if(location.port!='' && location.port!='80'){
		host = host+ ":" + location.port;
	}
	return host;
}

/****************************************
 * 功能函数，获取URL地址，传入参数method和文档fdId
 ***************************************/
function getUrl(method, docId) {
	return getHost() + Com_Parameter.ContextPath
			+ "sys/attachment/sys_att_main/sysAttMain.do?method=" + method
			+ "&fdId=" + docId;
};

function downAtt(){
	var url = getUrl("download", '${param.attIds}');
	window.open(url, "_blank");
	$dialog.hide();
}
</script>
<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/kmtopic/kms_kmtopic_main/style/edit.css" />

	<div style="padding:30px 30px 0px;">
		<div style="font-size: 14px;">${ lfn:message('kms-kmtopic:kmsKmtopicMain.noright.tip') }</div>
		<center>
			<div style="font-size: 13px;padding:10px 20px 20px;">${param.unAuthModelNames}</div>
			<ui:button text="${ lfn:message('button.ok')}" onclick="downAtt()"></ui:button>
			<ui:button text="${ lfn:message('button.cancel')}" styleClass="lui_toolbar_btn_gray" onclick="javascript:$dialog.hide();"></ui:button>
		</center>
	</div>
