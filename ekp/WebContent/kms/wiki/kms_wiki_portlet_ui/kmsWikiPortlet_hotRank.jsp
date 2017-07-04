<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:ajaxtext>
	<script>
		seajs.use("kms/wiki/kms_wiki_portlet_ui/style/hot.css");
	</script>
	<ui:dataview>
		<ui:source type="AjaxJson">
			{"url":"/kms/wiki/kms_wiki_portlet/kmsWikiPortlet.do?method=getWikiMain&rowsize=${param.rowsize}&type=${param.type}&categoryId=${param.cateid}&dataType=col"}
		</ui:source>
		<ui:render type="Template">
			{$<div style="width:100%">$}
			if(data && data.length > 0) {
				for(var i=0 ;i < data.length; i++) {
					{$
						<div class="lui_wiki_portlet_hot_row clearfloat lui_wiki_portlet_hot_no{%i+1%}"> 
							<span class="lui_wiki_portlet_hot_rank">{%i+1%}</span>
							<a class="lui_wiki_portlet_hot_text" href="${LUI_ContextPath}{%data[i]['href']%}" title="{%data[i]['text']%}" target="_blank">{%data[i]['text']%}</a> 
						</div>
					$}	
				}
			}
			{$</div>$}
		</ui:render>
	</ui:dataview>
</ui:ajaxtext>