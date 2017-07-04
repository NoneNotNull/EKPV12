<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<title>${lfn:message('sys-simplecategory:menu.sysSimpleCategory.overview') }</title>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/sys/simplecategory/category_preview/Kanvas.js"></script>
</head>
<body>
	<div id="previewContent"></div>
</body>
<script type="text/javascript">	
            var kvs = new KPlayer({id: 'previewContent', width: '100%', height: '650px'},'<%=request.getContextPath()%>/sys/simplecategory/category_preview/KPlayer.swf');
            kvs.onReady( function() {
				kvs.loadDataFromServer('${LUI_ContextPath}/sys/sc/categoryPreivew.do?method=getXMLContent&service=${service}&currid=${currid}');
			});
</script>
</html>