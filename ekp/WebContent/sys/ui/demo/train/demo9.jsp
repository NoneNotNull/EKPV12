<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<template:include ref="default.simple">

	<template:replace name="body">	
	

<div data-lui-type="lui/base!Env" style="display: none;">
	<script type="text/config">
	{"contextPath": "http://ekp.lrtest.com.cn:8080/ekp"}
	</script>
	<div data-lui-type="lui/panel!Panel" style="display:none;">	
<script type="text/config">
{
    "height": "240",
    "scroll": "false",
    "expand": true,
    "toggle": false
}
</script>
<div data-lui-type="lui/view/layout!Template" style="display:none;">	
<script type="text/config">
{"kind": "panel"}
</script>
<script type='text/code' xsrc='/sys/ui/extend/panel/panel.tmpl?s_cache=1406530577775'>
</script>
</div>
 <div data-lui-type="lui/panel!Content" style="display:none;">	
<script type="text/config">
{
    "title": "自定义页面",
    "vars": {"fdId": "1477ae618d76923da1a174b494dbc636"}
}
</script>
<div data-lui-type="lui/view/layout!Template" style="display:none;">	
<script type="text/config">
{"kind": "content"}
</script>
<script type='text/code' xsrc='/sys/ui/extend/panel/content.tmpl?s_cache=1406530577775'>
</script>
</div>
  <div data-lui-type="lui/base!DataView" style="display:none;">	
<script type="text/config">
{"format": "sys.ui.iframe"}
</script>

   <div data-lui-type="lui/data/source!Static" style="display:none;">	
<script type='text/code'>
{"src":"/resource/jsp/widget.jsp?portletId=sys.portal.html&sourceOpt=%7B%22fdId%22%3A%221477ae618d76923da1a174b494dbc636%22%7D&renderId=sys.ui.html.default&renderOpt=%7B%7D"}
</script>
</div>
   <div data-lui-type="lui/view/render!Javascript" style="display:none;">	
<script type='text/code' xsrc='/sys/ui/extend/dataview/render/iframe.js?s_cache=1406530577775'>
</script>
</div>
  </div>
 </div>
</div>
	
      
	</template:replace>

</template:include>