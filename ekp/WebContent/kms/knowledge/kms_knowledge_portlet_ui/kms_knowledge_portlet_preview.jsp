<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:ajaxtext>
	<script>
		seajs.use("kms/knowledge/kms_knowledge_portlet_ui/style/portlet.css");
		
	</script>
	<ui:dataview>
		<ui:render type="Template"> 
			for (var i = 0,  l = data.length; i<l; i++) {
			{$
				<dl class="lui_knowledge_preview_dl_a"> 
					<dt>
						<a target="_blank"
							href="${LUI_ContextPath}/kms/knowledge/?categoryId={% data[i].id %}" 
							title="{%data[i].text%}">{%data[i].text%}
							<span>
					$} 
					if(data[i].docAmount!=null){
						{$
							({%data[i].docAmount%}) 
						$} 
					}
					{$
							</span>
						</a>
					</dt>
					<dd <c:if test="i==data.length+1">style="border-bottom:0px"</c:if>>
					$}
					
					for (var j = 0,ln = data[i].children.length; j<ln; j++) {
						{$
							<a target="_blank" href="${LUI_ContextPath}/kms/knowledge/?categoryId={%data[i].children[j].id%}" 
								title="{%data[i].children[j].text%}" >{%data[i].children[j].text%}
								<span>
						$} 
						if(data[i].children[j].docAmount!=null){
							{$
								({%data[i].children[j].docAmount%})
							$} 
						}
						{$
						</span>
							</a>
						$}
					}
				{$
								
					</dd>
				</dl>
				$} 
			}
			{$<div> </div>$} 
		</ui:render>
		<ui:source type="AjaxJson">
			{url:'/sys/sc/categoryPreivew.do?method=getContent&service=kmsKnowledgeCategoryPreManagerService&currid=${param.currid}'}
		</ui:source>
	</ui:dataview>
</ui:ajaxtext>
