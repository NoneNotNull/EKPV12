<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysIntroduceForm" value="${requestScope[param.formName]}"/>
<c:if test="${sysIntroduceForm.introduceForm.fdIsShow=='true'}">
		<c:set var="intr_modelName" value="${sysIntroduceForm.introduceForm.fdModelName}"/>
		<c:set var="intr_modelId" value="${sysIntroduceForm.introduceForm.fdModelId}"/>
		<ui:content title="<div id='intr_label_title'  name='introviewnames'>${lfn:message('sys-introduce:sysIntroduceMain.tab.introduce.label')}${sysIntroduceForm.introduceForm.fdIntroduceCount}</div>">
			<script>
			var intr_lang = {
					'intr_star_2':'<bean:message key="sysIntroduceMain.fdIntroduceGrade.WorthLooking" bundle="sys-introduce" />',
					'intr_star_1':'<bean:message key="sysIntroduceMain.fdIntroduceGrade.KeyRecommendation" bundle="sys-introduce" />',
					'intr_star_0':'<bean:message key="sysIntroduceMain.fdIntroduceGrade.ForceRecommendation" bundle="sys-introduce" />',
					'intr_prompt_1':'<bean:message key="sysIntroduceMain.pda.alert1" bundle="sys-introduce"/>',
					'intr_prompt_2':'<bean:message key="sysIntroduceMain.pda.alert2" bundle="sys-introduce"/>',
					'intr_prompt_3':'<bean:message key="sysIntroduceMain.pda.alert3" bundle="sys-introduce"/>',
					'intr_prompt_sucess':'<bean:message key="sysIntroduceMain.save.msg.success" bundle="sys-introduce"/>',
					'intr_type_select':'<bean:message key="sysIntroduceMain.introduce.type.error.showMessage" bundle="sys-introduce"/>',
					'intr_select_person':'<bean:message key="sysIntroduceMain.fdIntroduceTo.error.showMessage" bundle="sys-introduce"/>',	
					'intr_repetition_message':'<bean:message key="sysIntroduceMain.fdIntroduceTo.repetition" bundle="sys-introduce"/>',	
					'intr_introfalse_message':'<bean:message key="sysIntroduceMain.error.introfalse" bundle="sys-introduce"/>',
					'intr_introcheckfalse_message':'<bean:message key="sysIntroduceMain.error.introcheckfalse" bundle="sys-introduce"/>'
					};
				seajs.use(['${KMSS_Parameter_ContextPath}sys/introduce/import/resource/intr.css']);
				Com_IncludeFile("intr.js","${KMSS_Parameter_ContextPath}sys/introduce/import/resource/","js",true);
			</script>
			<script>
				if(window.intr_opt==null){
					window.intr_opt = new IntroduceOpt("${intr_modelName}","${intr_modelId}","${param.fdKey}",intr_lang);
				}
			</script>
			<ui:event event="show">
				intr_opt.onload();
			</ui:event>
			<ui:event topic="introduce.submit.success" args="info">
				intr_opt.refreshNum(info);
			</ui:event>
			
			<kmss:auth requestURL="/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=add&fdModelName=${intr_modelName}&fdModelId=${intr_modelId}" requestMethod="GET">
				<c:import url="/sys/introduce/import/sysIntroduceMain_view_include.jsp" charEncoding="UTF-8">
				    <c:param name="fdCateModelName" value="${param['fdCateModelName']}" />
					<c:param name="fdModelName" value="${intr_modelName}"></c:param>
					<c:param name="fdModelId" value="${intr_modelId}"></c:param>
					<c:param name="fdKey" value="${param['fdKey']}"></c:param>
					<c:param name="toEssence" value="${param['toEssence']}" />
					<c:param name="toNews" value="${param['toNews']}" />
					<c:param name="toPerson" value="${param['toPerson']}" />
					<c:param name="docSubject" value="${param['docSubject']}" />
					<c:param name="docCreatorName" value="${param['docCreatorName']}" />
				</c:import>
			</kmss:auth>
			<div id="intr_viewMain">
				<div class="intr_title intr_title_color"><bean:message key="sysIntroduceMain.introduce.title" bundle="sys-introduce"/></div>
				<div id="introduceContent">
					<list:listview channel="intr_ch1">
						<ui:source type="AjaxJson">
							{"url":"/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=viewAll&forward=listUi&rowsize=10&fdModelId=${intr_modelId}&fdModelName=${intr_modelName}&rowsize=8"}
						</ui:source>
						<list:rowTable channel="rowtable" isDefault="true" target="_blank" cfg-norecodeLayout="simple">
							<ui:layout type="Template">
								{$<div class="intr_record" data-lui-mark='table.content.inside'>
								</div>$}
							</ui:layout>
							<list:row-template>
								{$
									<div class="intr_record_msg"><div class="intr_record_content intr_title_color">{%row['fdIntroduceReason']%}</div>
									<div class="intr_summary">
										<span class="intr_evaler">{%row['fdIntroducer.fdName']%}</span>
										<span class="intr_summary_color">|&nbsp;{%row['fdIntroduceTime']%}</span>
										<span><ul class="intr_summary_star">$}
											for(var m=0;m<3;m++){
												var flag = 2- parseInt(row['fdIntroduceGrade']);
												var className = 'lui_icon_s_bad'
												if(m <= flag){
													className = 'lui_icon_s_good';
												}
												{$<li class='{%className%}'></li>$}
											}
										{$</ul></span>
									</div>
									<div class="intr_summary_detail intr_summary_color">
										<span>{%row['introduceType']%}</span>
										<span>{%row['introduceGoalNames'].replace(/;/gi,' , ')%}</span>
									</div>
									</div>
								$}
							</list:row-template>
						</list:rowTable>	
						<ui:event topic="list.loaded"> 
							$("#intr_viewMain").css({height:"auto"});
						</ui:event>
					</list:listview>
					<list:paging channel="intr_ch1" layout="sys.ui.paging.simple"></list:paging>
				</div>
			</div>
		</ui:content>
		
		<script>
			seajs.use('lui/topic',function(topic){
				topic.channel('intr_ch1').subscribe('list.changed',function(evt){
				var num = evt.page.totalSize;
				var intro=document.getElementById('intr_label_title').innerText;
				var introcontent=document.getElementsByName("introviewnames");

				if(intro.indexOf("(")>0){
					var text=intro.substring(0,intro.indexOf("("));
					var introcontent=document.getElementsByName("introviewnames");
					for(var i=0;i<introcontent.length;i++){
						introcontent[i].innerHTml=text+"("+num+")";
						introcontent[i].innerText=text+"("+num+")";
					}
				}else{
					for(var i=0;i<introcontent.length;i++){
						introcontent[i].innerHTml=intro;
						introcontent[i].innerText=intro;
						}
				}
				});
			})
		</script>
</c:if>

