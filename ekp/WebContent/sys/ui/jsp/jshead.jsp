<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.util.*"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" pageEncoding="UTF-8" %>
<script type="text/javascript">
var Com_Parameter = {
	ContextPath:"${KMSS_Parameter_ContextPath}",
	ResPath:"${KMSS_Parameter_ResPath}",
	Style:"${KMSS_Parameter_Style}",
	JsFileList:new Array,
	StylePath:"${KMSS_Parameter_StylePath}",
	Lang:"<%= ResourceUtil.getLocaleStringByUser(request) %>",
	CurrentUserId:"${KMSS_Parameter_CurrentUserId}",
	Cache:${ LUI_Cache }
};
</script>
<script type="text/javascript" src='${LUI_ContextPath}/resource/js/domain.js?s_cache=${ LUI_Cache }'></script>
<script type="text/javascript" src='${LUI_ContextPath}/sys/ui/js/LUI.js?s_cache=${ LUI_Cache }'></script>
<script type="text/javascript" src="${LUI_ContextPath}/resource/js/common.js?s_cache=${ LUI_Cache }"></script>
<script type="text/javascript" src="${LUI_ContextPath}/resource/js/sea.js?s_cache=${ LUI_Cache }"></script>
<script type="text/javascript">
seajs.config({
	themes : <%=SysUiPluginUtil.getThemes(request)%>,
	paths: {
		'lui': 'sys/ui/js'
	},
	alias: {
		'lui/jquery': 'resource/js/jquery',
		'lui/jquery-ui': 'resource/js/jquery-ui/jquery.ui'
	},
	preload: ['${LUI_ContextPath}/resource/js/plugin-theme.js','${LUI_ContextPath}/resource/js/plugin-lang.js'],
	debug: true,
 	base: '${LUI_ContextPath}',
 	env : {
 	 	contextPath: '${LUI_ContextPath}',
 		now : '<%= DateUtil.convertDateToString(new Date(), DateUtil.TYPE_DATETIME, request.getLocale()) %>',
 		pattern : {
 			date : '<%= ResourceUtil.getString("date.format.date", request.getLocale()) %>',
 			datetime : '<%= ResourceUtil.getString("date.format.datetime", request.getLocale()) %>',
 			time : '<%= ResourceUtil.getString("date.format.time", request.getLocale()) %>'
 		},
 		locale : "<%= ResourceUtil.getLocaleStringByUser(request) %>",
 		config : <%= JSONObject.fromObject(ResourceUtil.getKmssUiConfig()).toString() %>,
 		cache : ${LUI_Cache}
 	}
});
seajs.use([ 'lui/parser', 'lui/jquery', 'theme!common', 'theme!icon' ],
	function(parser, $) {
		$(document).ready(function() {
			parser.parse();
		});
	}); 
</script>