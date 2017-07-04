<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<script src="${LUI_ContextPath }/kms/common/pda/script/lib/zepto.min.js"></script>
<script src="${LUI_ContextPath }/kms/common/pda/script/lib/fx.js"></script>
<script src="${LUI_ContextPath }/kms/common/pda/script/lib/selector.js"></script>
<!-- 
 <script src="${LUI_ContextPath }/resource/js/jquery.src.js"></script> -->
<script src="${LUI_ContextPath }/kms/common/pda/script/lib/simple-inheritance.min.js"></script>
<script src="${LUI_ContextPath }/resource/js/kms_tmpl.js"></script>
<script src="${LUI_ContextPath }/kms/common/pda/script/lib/pda.min.js"></script>
<link href="${LUI_ContextPath }/kms/common/pda/css/style/pda.min.css" rel="stylesheet" type="text/css" />
<!-- 
<script src="http://192.168.5.136:8081/target/target-script-min.js#anonymous" type="text/javascript">
</script>
--> 
<script type="text/javascript">
var Com_Parameter = {
	ContextPath:"${KMSS_Parameter_ContextPath}",
	ResPath:"${KMSS_Parameter_ResPath}",
	Style:"${KMSS_Parameter_Style}",
	JsFileList:new Array,
	StylePath:"${KMSS_Parameter_StylePath}",
	Lang:"<%= ResourceUtil.getLocaleStringByUser(request) %>",
	CurrentUserId:"${KMSS_Parameter_CurrentUserId}"
};
</script>
