<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	window.onload = function(){
		loadDialogInfo(${replyDialogs});
	}
	var reply_lang = {
		'sysEvaluation.reply.ct':'<bean:message key="sysEvaluation.reply.ct" bundle="sys-evaluation" />',
		'reply_prompt_words_alert1':'<bean:message key="sysEvaluationNotes.alert1" bundle="sys-evaluation"/>',
		'reply_prompt_words_alert3':'<bean:message key="sysEvaluationNotes.alert3" bundle="sys-evaluation"/>',
		'reply_prompt_delete':'<bean:message key="sysEvaluation.eval.delete" bundle="sys-evaluation"/>',
		'reply_prompt_del_confirm':'<bean:message key="page.comfirmDelete"/>',
		'reply_prompt_sucess_del':'<bean:message key="return.optSuccess"/>',
		'reply_prompt_fail_del':'<bean:message key="return.optFailure"/>',
		'reply_prompt_icon_smile':'<bean:message key="sysEvaluation.reply.icon.smile" bundle="sys-evaluation"/>'
	}
	seajs.use(['${KMSS_Parameter_ContextPath}sys/evaluation/import/resource/replyDialog.css']);
	Com_IncludeFile("replyDialog.js","${KMSS_Parameter_ContextPath}sys/evaluation/import/resource/","js",true);
</script>
</head>
<body >
	<div id="reply_dialogs" style="padding: 20px 15px 20px;"></div>
</body>
</html>


