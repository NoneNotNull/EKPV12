<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<script type="text/javascript">
	function add_ask(__fdPosterTypeListId, __fdCategoryId){
		var url = '${LUI_ContextPath}/kms/ask/kms_ask_topic/kmsAskTopic.do?method=add' 
						+ (__fdPosterTypeListId ? "&fdPosterTypeListId=" + __fdPosterTypeListId : "") 
						+ (__fdCategoryId ? "&fdCategoryId="+ __fdCategoryId : "");
		window.open(url,'_self');
	}
</script>