<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:criteria id="kmsAskCriteria" expand="true" channel="ask">	 	
			<c:set var="TA" value="${empty param.TA ? 'ta' : param.TA }"/>
			<%--与TA相关--%>
			<list:cri-criterion title="${lfn:message(lfn:concat('kms-ask:kmsAsk.zone.', TA))}" key="myknow">
				<list:box-select>
					<list:item-select cfg-defaultValue="myanswer" cfg-required="true">
						<ui:source type="Static">
							[{text:'${lfn:message(lfn:concat('kms-ask:kmsAsk.zone.answer.', TA))}',value:'myanswer'},
							 {text:'${lfn:message(lfn:concat('kms-ask:kmsAsk.zone.ask.', TA))}', value:'myask'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<%--TA的问答状态--%>
			<list:cri-criterion title="${lfn:message('kms-ask:kmsAskTopic.fdStatus') }" key="status">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							 [
								 {text:'${ lfn:message('kms-ask:kmsAskTopic.fdWait') }', value:'waitSolve'},
								 {text:'${ lfn:message('kms-ask:kmsAskTopic.fdSolve') }',value:'solve'},
								 {text:'${ lfn:message('kms-ask:kmsAskTopic.fdBest') }',value:'best'},
								 {text:'${ lfn:message('kms-ask:kmsAskTopic.fdHighScore') }',value:'highscore'}
							 ]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria>
	    <div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td style='color: #979797;width: 39px;'>
						${ lfn:message('kms-ask:kmsAskTopic.list.orderType') }：
					</td>
					<%--排序按钮  --%>
					<td>
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="5" >
							<list:sort property="kmsAskTopic.docCreateTime" text="${lfn:message('kms-ask:kmsAskTopic.fdAskTime') }"  group="sort.list"></list:sort>
							<list:sort property="kmsAskTopic.fdLastPostTime" text="${lfn:message('kms-ask:kmsAskTopic.fdLastPostTime') }"  group="sort.list"></list:sort>
							<list:sort property="kmsAskTopic.fdStatus" text="${lfn:message('kms-ask:kmsAskTopic.fdAskStatus') }" group="sort.list"></list:sort>
							<list:sort property="kmsAskTopic.fdScore" text="${lfn:message('kms-ask:kmsAskTopic.fdScores') }" group="sort.list"></list:sort>
							<list:sort property="kmsAskTopic.fdReplyCount" text="${lfn:message('kms-ask:kmsAskTopic.replyCount')}" group="sort.list"></list:sort>
						</ui:toolbar>
					</td>
				</tr> 
			</table>
		</div>
			
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<%--list视图--%>
		<list:listview id="listview1" channel="ask">
						<ui:source type="AjaxJson">
							{url:'/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=index&fdOrgId=${param.userId}'}
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