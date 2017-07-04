<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link href="${kmsContextPath }kms/ask/kms_ask_kk/resource/css/kk2ask.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/resource/js/common.js"></script>
<script>
Com_IncludeFile('kms_tmpl.js',null,'js');
Com_IncludeFile('jquery.js',"${kmsResourcePath }/js/lib/","js",true);
</script>
<script>
// kmsJS
Com_IncludeFile('json2.js|kms.js',"${kmsResourcePath }/js/lib/","js",true);
Com_IncludeFile('kms_portlet.js',"${kmsResourcePath }/js/","js",true);
</script>
<script type="text/javascript" src="${kmsResourcePath }/js/artdialog/artdialog.js?skin=blue"></script>
<script type="text/javascript" src="${kmsResourcePath }/js/artdialog/artdialog.iframe.js"></script>
<script>
	// 搜索按钮绑定
	$(function() {
		$('.search_btn').bind('click', function(event) {
				var portlet = $('#' + ['portlet', 'kk2askPortlet'].join('_')), param = KMS_JSON(portlet
						.attr("parameters")), beanParm = KMS_JSON(param.kms.beanParm);
				$.extend(beanParm, {
							'fdKeyWord' : $('.search_input').val()
						});
				param.kms.beanParm = JSON.stringify(beanParm);
				portlet.attr("parameters", JSON.stringify(param)).attr("load",
						false);
				eval(" " + param.kms.renderer + "('" + param.kms.id + "');");
		});
		$(".search_input").bind('keydown', function(event) {
					if (event.keyCode == 13) {
						$(".search_btn").click();
					}
				});
	})
</script>

<!-- 模板文件 -->
<script type="text/template" id="portlet_kk2ask_tmpl">
{$
	<ul class="ul_a">
$}
		for(var i=0;i< data.length;i++){
			var topic = data[i];
			{$
				<li style="padding: 5px;" >
					<a href="landray://im?u={%topic.fdLoginName%}&t=0"> <img src="http://kk.landray.com.cn:8081/kkonline/?p=0:{%topic.fdLoginName%}" border="0" title="{%topic.fdName%}"/>{%topic.fdName%}</a><span>{% topic.fdReplyCount %}回答</span>
					<br/>
					<a title="{%topic.docSubject %}" href="{% topic.fdUrl %}" target="_blank">{% topic.docSubject %}</a>
				</li>
			$}
		}
{$
	</ul>
$}
</script>