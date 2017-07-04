<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="/kms/common/resource/jsp/tags.jsp"%>
<!doctype html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/kms/common/resource/jsp/include_ekp.jsp" %>
<%@ include file="/kms/common/resource/jsp/include_kms.jsp" %>
<link rel="shortcut icon" href="${kmsResourcePath }/favicon.ico">
<script type="text/javascript" src="<%=request.getContextPath()%>/resource/js/common.js"></script>
<script src="${kmsResourcePath }/js/lib/jquery.js"></script>
<link href="${kmsThemePath }/public.css" rel="stylesheet" type="text/css" />
<title>${model.title}</title>
<script type="text/javascript">
	Com_IncludeFile("data.js|kms_tmpl.js", null, "js");
</script>

<script src="${kmsResourcePath }/js/lib/json2.js"></script>
<script src="${kmsResourcePath }/js/lib/jquery.form.js"></script>
<script src="${kmsResourcePath }/js/lib/kms.js"></script>
<script src="${kmsResourcePath }/js/artdialog/artdialog.js?skin=blue"></script>
<script src="${kmsResourcePath }/js/artdialog/artdialog.iframe.js"></script>
<script src="${kmsResourcePath }/js/template.js"></script>

<script src="${kmsResourcePath }/js/kms_portlet.js"></script>

<script src="${kmsResourcePath }/js/kms_common.js"></script>
<script src="${kmsResourcePath }/js/kms_utils.js"></script>
</head>
<c:import url="/kms/common/resource/theme/default/template.jsp" charEncoding="UTf-8"></c:import>
<body oncontextmenu="self.event.returnValue=false">
<div id="wrapper">
<script>


	( function() {
		if ($('#userInfoTips').length > 0
				&& $('#topBanner_info_tmpl').length > 0) {
			$
					.ajax( {
						url : '${kmsResourcePath}/jsp/get_json_feed.jsp?s_bean=kmsCommonPortlet&s_method=getUserToolTips',
						cache : false,
						success : function(data) {
							var tmpl = $('#topBanner_info_tmpl').html();
						if ($.getTemplate(tmpl)) {
							var html = $.getTemplate(tmpl).render(data);
							$('#userInfoTips').html(html);
						}
					}
					});

		}

	}());
</script>