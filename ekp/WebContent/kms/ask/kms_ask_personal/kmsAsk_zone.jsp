<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="TA" value="${empty param.zone_TA ? 'ta' : param.zone_TA}"/>
<c:set var="userId" value="${empty param.userId ? KMSS_Parameter_CurrentUserId : param.userId}"/>
<template:include ref="zone.navlink">
	<template:replace name="head">
		<script>
			seajs.use(['kms/ask/kms_ask_ui/style/index.css']);
		</script>
	</template:replace>
	<template:replace name="title">
		<c:out value="${lfn:message(lfn:concat('kms-ask:kmsAsk.zone.', TA))}"></c:out>
	</template:replace>
	<template:replace name="content">
		<ui:tabpanel layout="sys.zone.tabpanel.default" >
                <ui:content title="${lfn:message(lfn:concat('kms-ask:kmsAsk.zone.answer.', TA))}" />
                <ui:content title="${lfn:message(lfn:concat('kms-ask:kmsAsk.zone.ask.', TA))}" />
                <ui:event event="indexChanged" args="data">
                	var selectValue;
                	switch(data.index.after) {
                		case 0 :  selectValue = "myanswer"; break;
                		case 1 :  selectValue = "myask"; break;
                		default : break;
                	}
                      seajs.use("lui/topic", function(topic) {
                           topic.channel( "ask").publish('criteria.changed' ,
                                       { criterions: [{key:"myanswer" , value:[selectValue]}]});
                     });

                </ui:event>
          </ui:tabpanel>
		<list:listview id="listview1" channel="ask">
						<ui:source type="AjaxJson">
							{url:'/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=index&fdOrgId=${param.userId}&rowsize=8'}
						</ui:source>
					
						<%-- 列表视图--%>
						<list:colTable layout="sys.ui.listview.columntable" name="columntable"
							rowHref="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=view&fdId=!{fdId}" sort="false" >
							<list:col-checkbox name="List_Selected" style="width:5%" ></list:col-checkbox>
							<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"></list:col-serial>
							<list:col-html title="${ lfn:message('kms-ask:kmsAskTopic.fdScores')}" >
								{$
									<span class="lui_ask_index_score">{%row['fdScore']%}</span>
								$}
							</list:col-html>
							<list:col-html title="${ lfn:message('kms-ask:kmsAskTopic.docSubject')}" headerStyle="width:36%" style="text-align:left;padding:0 8px" >
								{$
									<div style="color: #e17d27;display: block;float: left;">[{%row['fdKmsAskCategory.fdName']%}]</div><div style="color: #35A9DC;display: block;width: 300px;" >{%row['docSubject']%}</div>
								$}
							</list:col-html>
							<list:col-html title="${ lfn:message('kms-ask:kmsAskTopic.fdAskStatus')}" >
								if(row['fdStatus']==0){
									{$
										<span ><img src="${KMSS_Parameter_StylePath}answer/icn_time.gif" border="0"></span>
									$}
								}else{
									{$
										<span ><img src="${KMSS_Parameter_StylePath}answer/icn_ok.gif" border="0"></span>
									$}
								}
							</list:col-html>
							<list:col-auto props="fdReplyCount,docCreateTime,fdLastPostTime"></list:col-auto>
						</list:colTable>
					</list:listview>
	 	<list:paging channel="ask"></list:paging>
	</template:replace>

</template:include>
