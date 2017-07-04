<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/zone/zone.tld"
	prefix="zone"%>
<%@ page import="com.landray.kmss.sys.person.interfaces.PersonInfoServiceGetter" %>
<%@ page import="com.landray.kmss.sys.person.interfaces.PersonImageService" %>
<%@ page import="com.landray.kmss.util.StringUtil" %>
<template:include file="/sys/zone/sys_zone_personInfo/template_view/default/zonePersonTemplate.jsp">
	<template:replace name="title">
		<bean:message bundle="sys-zone" key="sysZonePerson.personInfoTitle" />
	</template:replace>
	<template:replace name="photo">
		<div class="lui_zone_imgbox">
			<c:if test="${sysOrgPerson.fdId == KMSS_Parameter_CurrentUserId}">
				<%
					PersonImageService service = PersonInfoServiceGetter.getPersonImageService();
					String changeUrl = service.getHeadimageChangeUrl();
					if(StringUtil.isNull(changeUrl)) {
						changeUrl = "/sys/person/setting.do?setting=sys_zone_person_photo";
					}
				%>
				<a  title="${lfn:message('sys-zone:sysZonePersonInfo.changeMyPic')}" 
					target="_blank" 
					href="${ LUI_ContextPath }<%=changeUrl%>">
					<img  id="personPhoto" 
						src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${sysZonePersonInfoForm.personId}&size=b">
				</a>
			</c:if>
			<c:if test="${sysOrgPerson.fdId != KMSS_Parameter_CurrentUserId }">
				<img  id="personPhoto" 
					src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${sysZonePersonInfoForm.personId}&size=b">
			</c:if>
		</div>
		<div id="contactBar" class="lui_zone_contact_view"
			 data-person-role="contact"
			 data-person-param="&fdId=${sysZonePersonInfoForm.personId}&fdName=${sysZonePersonInfoForm.personName}&fdLoginName=${ sysOrgPerson.fdLoginName}&fdEmail=${sysZonePersonInfoForm.email}&fdMobileNo=${sysZonePersonInfoForm.mobilPhone }">	
		</div>
		<%@ include file="/sys/zone/sys_zone_personInfo/sysZonePersonContact_include.jsp"%>
		<script>
			seajs.use(['lui/jquery'], function($) {
				var datas = [];
				$(function() {
					$("[data-person-role='contact']").each(function() {
						var $this = $(this), personParam = $this.attr("data-person-param");
						datas.push({
							elementId : $this.attr("id"),
							personId: Com_GetUrlParameter(personParam, "fdId"),
							personName:Com_GetUrlParameter(personParam, "fdName"),
							loginName :Com_GetUrlParameter(personParam, "fdLoginName"),
							email:Com_GetUrlParameter(personParam, "fdEmail"),
							mobileNo:Com_GetUrlParameter(personParam, "fdMobileNo"),
							isSelf : ("${KMSS_Parameter_CurrentUserId}" == Com_GetUrlParameter(personParam, "fdId"))
						});
					});
	
					onRender(datas);
				});
			});
			
		</script>
		
	</template:replace>
	<template:replace name="fans">
		<ul class="lui_zone_fans_follow">
			<li>
				<a class="lui_zone_ff_box" id="sys_fans_attent_num" href="javascript:void(0);">
					<strong class="lui_zone_follow_num textEllipsis">
						${empty attentNum ? '0': attentNum}
					</strong>
					<span class="lui_zone_ff_txt">
						${lfn:message('sys-zone:sysZonePerson.fdAttention') }
					</span>
				</a>
			</li>
			<li>
				<a class="lui_zone_ff_box" id="sys_fans_fans_num" href="javascript:void(0);">
					<strong class="lui_zone_fans_num textEllipsis">
						${empty fansNum ? '0' : fansNum }</strong>
					<span class="lui_zone_ff_txt">
						${lfn:message('sys-zone:sysZonePerson.fdFans') }
					</span>
				</a>
			</li>
		</ul>
	</template:replace>
	<template:replace name="medal">
		<zone:personinfo infoId="medalInfo" 
				personId="${empty param.fdId ? param.userId : param.fdId  }">
		</zone:personinfo>
	</template:replace>
	<template:replace name="signature">
		<div class="lui_zone_item_header">
			<span class="name"> 
			 	<c:out value="${sysZonePersonInfoForm.personName}"/>
			</span>
			
				<ul class="lui_zone_btn_group">
					<li style="min-width: 54px;min-height: 24px;" >
						<c:import url="/sys/fans/sys_fans_main/sysFansMain_view.jsp" charEncoding="UTF-8">
							<c:param name="userId" value="${sysZonePersonInfoForm.personId}"></c:param>
							<c:param name="attentModelName" value="com.landray.kmss.sns.ispace.model.SnsIspacePublicAccount"></c:param>
							<c:param name="fansModelName" value="com.landray.kmss.sys.zone.model.SysZonePersonInfo"></c:param>
							<c:param name="isFollowPerson" value="true"></c:param>
							<c:param name="fdAttentionNum" value="${empty attentNum ? '0': attentNum}"></c:param>
							<c:param name="fdFansNum" value="${empty fansNum ? '0': attentNum}"></c:param>
							<c:param name="attentLocalId" value="sys_fans_attent_num"></c:param>
							<c:param name="fansLocalId" value="sys_fans_fans_num"></c:param>
							<c:param name="showFollowList" value="iframe_body"></c:param>
						</c:import>
						<!-- 
						<ui:dataview id="lui_follow">
							<ui:source type="AjaxJson">
								{url:"/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=loadRlation&orgId1=${KMSS_Parameter_CurrentUserId}&orgId2=${sysOrgPerson.fdId}"}
							</ui:source>
							<ui:render type="Template">
								<%@ include file="/sys/zone/sys_zone_personInfo/template_view/default/sys_zone_follow_tmpl.jsp"%>
							</ui:render>
							<ui:event event="load">
								function followcallBack() {
									LUI('lui_follow').refresh();
								}
								$('[data-action-type]').bind("click", function(evt) {
									var $this = $(this);
									seajs.use(['sys/zone/resource/zone_follow'], function(follow) {
										var type = $this.attr("data-action-type");
										if(type) {
											var orgId = $this.attr("data-action-id");
											follow.cared(orgId , type, "lui_follow", followcallBack);
										}
									});
								});
							</ui:event>
						</ui:dataview>
						 -->
					</li>
					<c:if test="${personResumeId != null }">
						<li>
							<a class="lui_zone_btn_resume_l" 
								title="${lfn:message('sys-zone:sysZonePerson.resume.download') }"
								href="${LUI_ContextPath}/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${personResumeId }">
									<span class="lui_zone_btn_resume_r"> 
										<span class="lui_zone_btn_resume_c"> 
											<span>
												<bean:message
													bundle="sys-zone" key="sysZonePerson.resume" />
											</span>
									</span>
								</span>
							</a>
						</li>
					</c:if>
					
				</ul>
		</div>
		<div class="lui_zone_msex">
			<%--男class为lui_zone_msex_M， 女为lui_zone_msex_F --%>
			<div class="lui_zone_msex_${sysZonePersonInfoForm.fdSex}"></div>
		</div>
		<p class="msg show-msg" id="fdSignatureP">
			<c:out value="${sysZonePersonInfoForm.fdSignature}"/>
		</p>
	</template:replace>

	<template:replace name="Position">
		<ul class="list">
			<li class="towCol">
				<span class="title">
					<bean:message	bundle="sys-zone" key="sysZonePerson.organization" />：</span> 
				<span class="txt" title="${organization}">
					<c:out value="${organization}"/>
				</span>
			</li>
			<li class="towCol">
				<span class="title">
					<bean:message
						bundle="sys-zone" key="sysZonePerson.workPhone" />：</span> 
				<span
				class="txt" title="${sysZonePersonInfoForm.fdCompanyPhone}">			
						<c:out value="${sysZonePersonInfoForm.fdCompanyPhone}"/>
			</span></li>
			<li class="towCol">
				<span class="title">
					<bean:message
						bundle="sys-zone" 
						key="sysZonePerson.dept" />：
				</span> 
				<span class="txt" title="${fdDeptNames}">
						<c:out value="${sysZonePersonInfoForm.dep}"/></span>
			</li>
			<li class="towCol">
				<span class="title">
					<bean:message
						bundle="sys-zone" key="sysZonePerson.mobilePhone" />：</span> 
				<span	class="txt" title="${sysZonePersonInfoForm.mobilPhone }">
					<c:out value="${sysZonePersonInfoForm.mobilPhone }"/>
				</span>
			</li>
			<li class="towCol">
				<span class="title">
					<bean:message
						bundle="sys-zone" key="sysZonePerson.post" />：</span> 
				<span class="txt" title="${postNames}">
						${sysZonePersonInfoForm.post } 
				</span>
			</li>
			<li class="towCol">
				<span class="title">
					<bean:message	bundle="sys-zone" key="sysZonePerson.email" />：</span>
			    <span class="txt" title="${sysZonePersonInfoForm.email }">
					<c:out value="${sysZonePersonInfoForm.email }"/>
				</span>
			</li>
		</ul>
	</template:replace>
	<%--显示专家领域  --%>
	<template:replace name="field">
		 <zone:personinfo  personId="${empty param.fdId ? param.userId : param.fdId  }" 
		 			infoId="expertArea" >
		 </zone:personinfo>
	</template:replace>
	
	<%--添加标签  --%>
	<template:replace name="tag">
		<dt>
			<bean:message bundle="sys-zone" key="sysZonePerson.tags" />：
		</dt>
		
		<c:import url="/sys/zone/import/sysTagMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="sysZonePersonInfoForm" />
			<c:param name="fdKey" value="zonePersonInfoDoc" />
			<c:param name="modelName"
				value="com.landray.kmss.sys.zone.model.SysZonePersonInfo" />
			<c:param name="fdQueryCondition" 
				value="${sysZonePersonInfoForm.fdId};${sysZonePersonInfoForm.personName}" />
			<c:param name="method" value="${ isSelf == true ? 'edit':'view' }"/>
		</c:import>
		
	</template:replace>
	<template:replace name="navBar">
		<ui:dataview>
			<ui:source type="Static">
				[<ui:trim>
					<c:forEach items="${navLinks}" var="link">
						{
							id: "${link.fdId }",
							text: "<c:out value="${link.fdName }" />",
							serverPath : "${link.serverPath}",
							target: "${link.fdTarget }",
							href : "${ link.fdUrl}",
							key : "${link.fdServerKey}"
						},
					</c:forEach>
					</ui:trim>]
			</ui:source>
			<ui:render type="Javascript">
				<%@ include file="/sys/zone/sys_zone_personInfo/template_view/default/sys_zone_nav_render.jsp"%>
			</ui:render>
		</ui:dataview>
	</template:replace>
	<template:replace name="bodyL">
		<div id="iframeDiv" class="lui_zone_mbody_conetnt" >
			<iframe id="iframe_body" name="iframe_body" src="" value=""
				width=100%; height=100%; border="0" marginwidth="0" marginheight="0"
				frameborder="0" scrolling=no> </iframe>
		</div>
	</template:replace>
	<template:replace name="mbodyR">
		<!--团队关系 Starts-->
		<div class="lui_zone_relation_box">
			<ui:tabpanel layout="sys.ui.tabpanel.default" id="zonePanel">
				<ui:content
					title="${lfn:message('sys-zone:sysZonePerson.leaders') }">
					<ui:dataview>
						<ui:source type="AjaxJson">
							{url:"/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=getTeam&orgId=${sysZonePersonInfoForm.fdId}&type=chain"}
						</ui:source>
						<ui:render type="Template">
							<%@ include file="/sys/zone/sys_zone_personInfo/template_view/default/sys_zone_chain_tmpl.jsp"%>
						</ui:render>
					</ui:dataview>
				</ui:content>
				<ui:content
					title="${lfn:message(lfn:concat('sys-zone:sysZonePerson.team.', zone_TA))}"
					style="width:100%">
					<ui:dataview>
						<ui:source type="AjaxJson">
							{url:"/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=getTeam&orgId=${sysZonePersonInfoForm.fdId}&type=team"}
						</ui:source>
						<ui:render type="Template">
							<%@ include file="/sys/zone/sys_zone_personInfo/template_view/default/sys_zone_team_tmpl.jsp"%>
						</ui:render>
					</ui:dataview>
				</ui:content>
			</ui:tabpanel>
		</div>
		<!--团队关系 Ends-->
		<!--标签相似 Starts-->
		<div class="lui_zone_staffYpage_similartag">
			<div style="float:right;">
				<list:paging channel="similarTags">
					<ui:layout type="Template">
						<%@ include file="/sys/zone/sys_zone_personInfo/template_view/default/sys_zone_tag_paging_tmpl.jsp"%>
					</ui:layout>		
				</list:paging>
			</div>
		<ui:panel channel="similarTags" toggle="false">
				<ui:content
					title="${lfn:message('sys-zone:sysZonePerson.similarTags') }"> 
					<list:listview channel="similarTags">
						<list:gridTable name="gridtable" columnNum="1" gridHref=""
							layout="sys.ui.listview.gridtable" cfg-norecodeLayout="none"
							target="">
							<ui:source type="AjaxJson">
								{url:'/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=getDatasByTags&personId=${sysZonePersonInfoForm.fdId}&rowsize=5'}
							</ui:source>
							<list:row-template>
							<%@ include file="/sys/zone/sys_zone_personInfo/template_view/default/sys_zone_tag_row_tmpl.jsp"%>
							</list:row-template>
						</list:gridTable>
						<ui:event event="load" >
							seajs.use('sys/fans/sys_fans_main/style/listView.css');
							var personIds = [];
							$("[data-fans-sign='sys_fans']").each(function() {
								var $this = $(this), personId = $this.attr("data-action-id");
								personIds.push(personId);
							});
							seajs.use(['sys/fans/resource/sys_fans'], function(follow){
								follow.changeFansStatus(personIds,".fans_follow_btn",
										{"extend" : "tag",
										 "caredText" : "${lfn:message('sys-zone:sysZonePerson.cared') }"  ,
										 "cancelText" :  "${lfn:message('sys-zone:sysZonePerson.cancelCared1') }",
										 "eachText" : "${lfn:message('sys-zone:sysZonePerson.follow.each') }",
										 "dialogEle" : ".lui_zone_staffYpage_similartag"
										 
										});
								follow.bindButton(".lui_zone_btn_tag", null, null, 
										{"extend" : "tag",
										 "caredText" : "${lfn:message('sys-zone:sysZonePerson.cared') }"  ,
										 "cancelText" :  "${lfn:message('sys-zone:sysZonePerson.cancelCared1') }",
										 "eachText" : "${lfn:message('sys-zone:sysZonePerson.follow.each') }",
										 "dialogEle" : ".lui_zone_staffYpage_similartag"
										 
										});
							});
						</ui:event>
					</list:listview>
				</ui:content>
			</ui:panel>
		<!--标签相似 Ends-->
		</div>
		<script>
			Com_IncludeFile("data.js|dialog.js|xform.js");
		</script>
		<%@ include file="/sys/zone/sys_zone_personInfo/template_view/default/sysZonePersonInfo_view_js.jsp"%>
	</template:replace>
</template:include>