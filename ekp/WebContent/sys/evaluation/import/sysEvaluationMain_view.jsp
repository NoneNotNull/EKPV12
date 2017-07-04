<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.sys.evaluation.model.SysEvaluationNotesConfig"%>
<% 
	String notesAreaName = request.getParameter("areaName");
	String fdEnable = new SysEvaluationNotesConfig().getFdEnable();//是否启用段落点评
	if("1".equals(fdEnable) && StringUtil.isNotNull(notesAreaName)){
		request.setAttribute("showEvalNotes",true);
	}else{
		request.setAttribute("showEvalNotes",false);
	}
%>
<c:set var="sysEvaluationForm" value="${requestScope[param.formName]}" />
<c:if test="${sysEvaluationForm.evaluationForm.fdIsShow=='true'}">
	<script type="text/javascript">
		var eval_lang = {
			'eval_star_4':'<bean:message key="sysEvaluation.oneStar.showText" bundle="sys-evaluation" />',
			'eval_star_3':'<bean:message key="sysEvaluation.twoStar.showText" bundle="sys-evaluation" />',
			'eval_star_2':'<bean:message key="sysEvaluation.threeStar.showText" bundle="sys-evaluation" />',
			'eval_star_1':'<bean:message key="sysEvaluation.fourStar.showText" bundle="sys-evaluation" />',
			'eval_star_0':'<bean:message key="sysEvaluation.oneStar.fiveText" bundle="sys-evaluation" />',
			'eval_prompt_1':'<bean:message key="sysEvaluation.pda.alert1" bundle="sys-evaluation"/>',
			'eval_prompt_2':'<bean:message key="sysEvaluation.pda.alert2" bundle="sys-evaluation"/>',
			'eval_prompt_3':'<bean:message key="sysEvaluation.pda.alert3" bundle="sys-evaluation"/>',
			'eval_prompt_sucess_add':'<bean:message key="sysEvaluation.save.msg.success" bundle="sys-evaluation"/>',
			'eval_prompt_sucess_del':'<bean:message key="return.optSuccess"/>',
			'eval_prompt_fail_del':'<bean:message key="return.optFailure"/>',
			'eval_prompt_del_confirm':'<bean:message key="page.comfirmDelete"/>',
			'eval_prompt_btn_cancel':'<bean:message key="button.cancel"/>',
			'eval_prompt_icon_tip':'<bean:message key="sysEvaluation.reply.icon.tip" bundle="sys-evaluation"/>',
			'eval_prompt_icon_smile':'<bean:message key="sysEvaluation.reply.icon.smile" bundle="sys-evaluation"/>',
			'eval_prompt_reply_commment':'<bean:message key="sysEvaluation.reply.commment" bundle="sys-evaluation"/>',
			'eval_prompt_words_alert1':'<bean:message key="sysEvaluationNotes.alert1" bundle="sys-evaluation"/>',
			'eval_prompt_words_alert2':'<bean:message key="sysEvaluationNotes.alert2" bundle="sys-evaluation"/>',
			'eval_prompt_words_alert3':'<bean:message key="sysEvaluationNotes.alert3" bundle="sys-evaluation"/>',
			'eval_prompt_publish_from':'<bean:message key="sysEvaluation.publish.from" bundle="sys-evaluation"/>',
			'eval_prompt_eval_reply':'<bean:message key="sysEvaluation.reply.ct" bundle="sys-evaluation"/>',
			'eval_prompt_eval_reply2':'<bean:message key="sysEvaluation.reply.ct" bundle="sys-evaluation"/>',
			'eval_prompt_eval_delete':'<bean:message key="sysEvaluation.eval.delete" bundle="sys-evaluation"/>',
			'eval_prompt_read_dialog':'<bean:message key="sysEvaluation.read.dialog" bundle="sys-evaluation"/>',
			'eval_prompt_read_dialog2':'<bean:message key="sysEvaluation.read.dialog" bundle="sys-evaluation"/>',
			'eval_prompt_reply_tips':'<bean:message key="sysEvaluation.reply.tips" bundle="sys-evaluation"/>'
		};
		seajs.use(['${KMSS_Parameter_ContextPath}sys/evaluation/import/resource/eval.css']);
		Com_IncludeFile("eval.js|evalNotes.js","${KMSS_Parameter_ContextPath}sys/evaluation/import/resource/","js",true);
	</script>
	<c:set var="eval_modelName" value="${sysEvaluationForm.evaluationForm.fdModelName}"/>
	<c:set var="eval_modelId" value="${sysEvaluationForm.evaluationForm.fdModelId}"/>
	<c:set var="eval_addUrl"
		value="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=add&fdModelName=${eval_modelName}&fdModelId=${eval_modelId}&fdIsNewVersion=${sysEvaluationForm.evaluationForm.fdIsNewVersion}&notifyOtherName=${param.notifyOther}&bundel=${param.bundel}&key=${param.key}" />
	<script>
		if(window.eval_opt==null)
			window.eval_opt = new EvaluationOpt('${eval_modelName}','${eval_modelId}','${param.key}',eval_lang);
	</script>
	<kmss:auth requestURL="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=delete&fdModelName=${eval_modelName}&fdModelId=${eval_modelId}" requestMethod="GET">
		<c:set var="eval_validateAuth" value="true" />
	</kmss:auth>
	<ui:content expand="${sysEvaluationForm.docStatus==30?'true':'false'}" title="<div id='eval_label_title'>${lfn:message('sys-evaluation:sysEvaluationMain.tab.evaluation.label')}${sysEvaluationForm.evaluationForm.fdEvaluateCount}</div>">
		<ui:event event="show">
			eval_opt.onload();
		</ui:event>
		<ui:event topic="evaluation.submit.success" args="info">
			eval_opt.refreshNum(info);
		</ui:event>
		<kmss:auth requestURL="${eval_addUrl}" requestMethod="GET">
			<c:import url="/sys/evaluation/import/sysEvaluationMain_view_include.jsp" charEncoding="UTF-8">
				<c:param name="fdModelName" value="${eval_modelName }"></c:param>
				<c:param name="fdModelId" value="${eval_modelId }"></c:param>
			</c:import>
			<!-- 是否有段落点评权限 -->
			<input type="hidden" name="hasNotesRight" value="true"/>
		</kmss:auth>
		<!-- 是否有删除全文点评回复权限 -->
		<input type="hidden" name="delReplyRight" value="${eval_validateAuth=='true'}"/>
		<input type="hidden" name="showReplyInfo" value="${param.showReplyInfo}"/>
		<div id="eval_ViewMain">
			<c:choose>
				<c:when test="${!showEvalNotes}">
					<!-- 不开启段落点评  -->
					<div id="eval_main" >
						<div class="eval_title eval_title_color">
							<bean:message key="sysEvaluationMain.evaluation.title" bundle="sys-evaluation"/>
						</div>
						<c:import url="/sys/evaluation/import/tmpl/sysEvaluationMain_main_list_tmpl.jsp"
								charEncoding="UTF-8">
								<c:param name="eval_validateAuth" value="${eval_validateAuth=='true'}" />
						</c:import>
					</div>
				</c:when>
				<c:otherwise>
					<ui:tabpanel layout="sys.ui.tabpanel.light">
						<ui:content title="${lfn:message('sys-evaluation:table.sysEvaluationMain.all')}">
							<div id="eval_main" >
								<c:import url="/sys/evaluation/import/tmpl/sysEvaluationMain_main_list_tmpl.jsp"
										charEncoding="UTF-8">
									<c:param name="eval_validateAuth" value="${eval_validateAuth=='true'}" />
								</c:import>
							</div>
						</ui:content>
						<ui:content title="${lfn:message('sys-evaluation:table.sysEvaluationNotes')}" >
							<div id="eval_notes" >
								<!-- 点赞 -->
								<c:import
									url="/sys/evaluation/import/sysEvaluationMain_view_praise.jsp"
									charEncoding="UTF-8">
									<c:param name="praiseAreaName" value="eval_notes" />
									<c:param name="listChannel" value="eval_listview" />
								</c:import>
								<list:listview channel="eval_listview">
									<ui:source type="AjaxJson">
										{url:'/sys/evaluation/sys_evaluation_main/sysEvaluationNotes.do?method=listView&orderby=fdEvaluationTime&ordertype=down&fdModelId=${sysEvaluationForm.fdId}&fdModelName=${eval_modelName}&rowsize=10'}
									</ui:source>
									<list:rowTable channel="rowtable" isDefault="true" target="_blank" cfg-norecodeLayout="simple">
										<ui:layout type="Template">
											{$<div class="eval_record" data-lui-mark='table.content.inside'>
											</div>$}
										</ui:layout>
										<list:row-template>
											<c:import
												url="/sys/evaluation/import/sysEvaluationMain_view_tmpl.jsp"
												charEncoding="UTF-8">
												<c:param name="isViewMain" value="false" />
												<c:param name="fdModelName" value="com.landray.kmss.sys.evaluation.model.SysEvaluationNotes" />
												<c:param name="eval_validateAuth" value="${eval_validateAuth=='true'}" />
											</c:import>
										</list:row-template>
									</list:rowTable>
									<ui:event topic="list.loaded" args="vt"> 
										$("#eval_notes").css({height:"auto"});
										var showReplyInfo = $("input[name='showReplyInfo']")[0].value;
										if(showReplyInfo!='false'){
											var ids = vt.table.ids;
											if(ids){
												for(var i=0;i<ids.length;i++){
													eval_opt.listReply(ids[i]);
												}
												vt.table.ids = [];
											}
										}
									</ui:event>
								</list:listview>
								<list:paging layout="sys.ui.paging.simple" channel="eval_listview"></list:paging>
							</div>
						</ui:content>
					</ui:tabpanel>
				</c:otherwise>
			</c:choose>
			
		</div>
	</ui:content>
	<!-- 是否启用段落点评 -->
	<input type="hidden" name="notesEnable" value="<%=new SysEvaluationNotesConfig().getFdEnable()%>"/>
	<!-- 段落点评分享提示框 -->
	<div id="share_div" class="lui_eval_tooltip_share">
		<input type="hidden" name="notesModelId" value="${eval_modelId}"/>
		<input type="hidden" name="notesModelName" value="${eval_modelName}"/>
		<input type="hidden" name="notesAreaName" value="${param.areaName}"/>
		<a class="lui_eval_share_icon1" href="javascript:void(0);"
		   title="${lfn:message('sys-evaluation:sysEvaluationNotes.Share')}"
		    id="sinaShare">
	        ${lfn:message('sys-evaluation:sysEvaluationNotes.Share') } </a> 
	    <a class="lui_eval_share_icon2" href="javascript:void(0);"	title="${lfn:message('sys-evaluation:sysEvaluationNotes.Eva') }"
		    id="evaluationShare">
	       ${lfn:message('sys-evaluation:sysEvaluationNotes.Eva') } </a> 
	     <!--小三角 Starts-->
		<i class="lui_eval_mtrig lui_eval_btrig"></i> 
		<i class="lui_eval_mtrig lui_eval_cover"></i>
	</div>
</c:if>

