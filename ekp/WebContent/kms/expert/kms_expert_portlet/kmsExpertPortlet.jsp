<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:ajaxtext>
	<script src="${LUI_ContextPath}/kms/expert/resource/js/kmsExpert_util.js"></script>
	<script>
		seajs.use("kms/expert/kms_expert_portlet/style/portlet.css");
		//向专家提问
		function askToExpert(fdId) {
			window.open('<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdPosterTypeListId=' + fdId);
		}
	</script>
	
	<c:set var="expert_url" value="/kms/expert/kms_expert_portlet/kmsExpertPortlet.do?method=getIntroedExpert&areaIds=${param.areaIds}&type=${param.type}&rowsize=${param.rowsize}&categoryIds=${param.categoryIds}&dataType=col">
	</c:set>
	<c:if test="${param.type == 'self'}">
		<c:set var="expert_url"
			 value="/kms/expert/kms_expert_portlet/kmsExpertPortlet.do?method=getSelfExpert&fdIds=${param.fdIds}">
		</c:set>
	</c:if>
	<ui:dataview>
		<ui:source type="AjaxJson">
			{url:'${expert_url}'}
		</ui:source>
		<ui:render type="Template">
			if(data.length > 0) {
				{$<div class="clearfloat">$}
				   for(var i=0; i<data.length; i++) {
						{$
							<div class="lui_expert_box_2" $} if(i == data.length-1) { {$ style="border-bottom: none;padding-bottom:0px;margin-bottom:0px;" $} } {$>
								<a class="lui_expert_img" target="_blank" href="${LUI_ContextPath }/kms/expert/kms_expert_info/kmsExpertInfo.do?method=view&fdExpertId={%data[i]['fdId']%}"> 
									<img  src="{% data[i]['imgUrl']%}" onload="javascript:drawImage(this,this.parentNode)">
								</a>
								<div style="position:absolute;left:118px;right:0">
								<ul  class="textEllipsis">
									<li>${lfn:message('kms-expert:kmsExpert.label') }
										<a  class="com_author" target="_blank" href="${LUI_ContextPath }/kms/expert/kms_expert_info/kmsExpertInfo.do?method=view&fdExpertId={%data[i]['fdId']%}"> 
											{% data[i]['fdPersonName'] %}
										</a>
									</li>
									<li title="{% data[i]['depName']%}">${lfn:message('kms-expert:kmsExpert.department')}{% data[i]['depNameShort'] %}</li>
									<li title="{% data[i]['postName']%}">${lfn:message('kms-expert:kmsExpert.position')}{% data[i]['postNameShort'] %}</li>
									<li title="{% data[i]['area']%}">${lfn:message('kms-expert:kmsExpert.areas')}{% data[i]['area']%}</li>
						$}
								if(data[i]['askTo']==true)  {
									{$  
										<li>
											<a href="javascript:void(0)" class="lui_expert_askBtn_2"  onclick="askToExpert('{% data[i]['fdId']%}')">
											<span>${lfn:message('kms-expert:table.kmsExpertInfo.askTohim')}</span>
											</a>
										</li>
								 	$}
								}
						{$
							    </ul>
							    </div>			
							</div>
							 
						$}
					}
				{$</div>$}
			 } else { 
			 	{$ 没有推荐专家 $}
			 }
		</ui:render>
	</ui:dataview>
</ui:ajaxtext>