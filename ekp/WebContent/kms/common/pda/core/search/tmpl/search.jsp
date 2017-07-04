<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page
	import="com.landray.kmss.sys.ftsearch.expand.service.ISysFtsearchHotwordService"%>
<%@page import="java.util.List"%>
<template:include file="/kms/common/pda/template/core.jsp">
	<template:replace name="header">
		<header class="lui-header lui-core-header">
			<ul class="clearfloat lui-search-bar">
				<li class="lui-back">
					<a data-lui-role="button"> 
						<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-back-icon'
						}
						</script>
					</a>
				</li>
				<li class="lui-search lui-search-right">
					<input placeholder="请输入搜索关键字" name="__keyword__" type="text">
					<input type="search" class="__lui-search-submit__ lui-search-submit lui-icon-s" onclick="__searchByVal()">
				</li>
			</ul>
		</header>
	</template:replace>
	<template:replace name="content">
		<section class="lui-search-content">
			<c:if test="${ param.hasKeyWord == false }">
				<article class="lui-search-article lui-search-hotwords">
					<h4>${lfn:message('sys-ftsearch-db:search.ftsearch.current.hot.search')}</h4>
					<%
						ISysFtsearchHotwordService service = (ISysFtsearchHotwordService) SpringBeanUtil
											.getBean("sysFtsearchHotwordService");
									List list = service.getHotword();
									request.setAttribute("hotWords", list);
					%>
					<ul>
						<c:forEach items="${ hotWords}" var="item">
							<li><span class="lui-search-hotword"
								onclick="__hotWords(this)">${item }</span></li>
						</c:forEach>
					</ul>
				</article>
				<script>
					function __hotWords(self) {
						$('[name="__keyword__"]').val($(self).text());
						__searchByVal();
					}
				</script>
			</c:if>
			<article data-lui-role="column" id="search_list" class="lui-content">
				<script type="text/config">
						{
							source : {
								url : '${LUI_ContextPath}/sys/ftsearch/searchBuilder.do?method=search&newLUI=true&modelName=${param.modelName}&queryString=${param.queryString}',
								type : 'ajaxJson'
							},
							render : {
								templateId : '#search_tmpl'
							},
							lazy : ${param.hasKeyWord == false}						
						}
					</script>
			</article>
		</section>
	</template:replace>

	<template:replace name="footer">
		<script id="search_tmpl" type="text/template">
			{$
				<ul class="lui-column-table">
			$}
			for(var i=0;i<data.length;i++){
				{$
					<li>
						<h3 class="textEllipsis"><a href="${LUI_ContextPath}{% data[i]['fdUrl'] %}">{% data[i]['docSubject'] %}</a></h3>
						<ul class="lui-grid-a clearfloat">
							<li><p>{% data[i]['docCreator'] %}</p></li>
							<li><p>{% data[i]['docCreateTime'] %}</p></li>
						</ul>
					</li>
				$}
			}
			{$
				</ul>
			$}
		</script>

		<script>
			function __searchByVal() {
				var val = $('[name="__keyword__"]').val();
				if (!val)
					return;
				if ($('.lui-search-hotwords').length > 0)
					$('.lui-search-hotwords').hide();
				var modelName = "${param.modelName}";
				Pda.Element('search_list').url = '${LUI_ContextPath}/sys/ftsearch/searchBuilder.do?method=search&modelName='
						+ modelName
						+ '&newLUI=true&queryString='
						+ encodeURIComponent(val);
				Pda.Element('search_list').reDraw();
			}
		</script>
	</template:replace>
</template:include>
