<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<template:replace name="head">
		<link rel="stylesheet" 
			  type="text/css" 
			  href="${ LUI_ContextPath}/kms/expert/kms_expert_info_ui/style/view.css">	
	</template:replace>
	<%-- 标题 --%>
	<template:replace name="title">
		<c:out value="${kmsExpertInfoForm.fdName } - ${ lfn:message('kms-expert:title.kms.expert') }"></c:out>
	</template:replace>
	<%-- 当前位置 --%>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams
				moduleTitle="${ lfn:message('kms-expert:search.kms.expert') }" 
				modulePath="/kms/expert/" 
				modelName="com.landray.kmss.kms.expert.model.KmsExpertType" 
				autoFetch="false"
				target="_blank"
				href="/kms/expert/"
				categoryId="${kmsExpertInfoForm.kmsExpertTypeId}" />
		</ui:combin>
	</template:replace>
	<%-- 中间主要内容--%>
	<template:replace name="content">
		<script src="${LUI_ContextPath}/kms/expert/resource/js/kmsExpert_util.js"></script>
		<%@ include file="/kms/expert/kms_expert_info_ui/kmsExpertInfo_view_js.jsp"%>
		<table class="lui_form_content" width="100%" style="min-width:980px;">
			<tr>
				<td  class="lui_expert_baseinfo_left" valign="top">
					<div class="lui_expert_img"  style="width: 125px;height:140px;">
						<img src="${expertImgUrl}" onload="javascript:drawImage(this,this.parentNode)">
					</div>
					<div class="lui_expert_contact" style="padding-top: 15px;">
						<ul>
							<li>
								<a class="lui_expert_contact_img lui_expert_contact_email"
									href="mailto:${kmsExpertInfoForm.fdEmail}">
								</a>
							</li>
							<li>
								<% 
									String KKConfig = "writeText :{textRule : \'<a href=\\\"!{kkLink}!{linkType}?u=!{orgs}&t=!{def_UType}\\\" class=\\\"lui_expert_contact_img lui_expert_contact_kk\\\"></a>\'}";
									request.setAttribute("KKConfig", KKConfig);
								%>
								 <c:import url="/sys/ims/sysIms_manage.jsp" charEncoding="UTF-8">  
									<c:param name="imName" value="KK" />  
									<c:param name="imParams" 
											 value="{orgs:'${kmsExpertInfoForm.fdLoginName}',menuCfg:{gravity:'n'},showMenu:false,refresh:false}" />  
								 </c:import>
							</li>
							
						</ul>
					</div>
					<%-- 
					<ui:dataview>
						<ui:source type="AjaxJson">
							{url:'/kms/expert/kms_expert_index/kmsExpertIndex.do?method=getScore&fdPersonId=${kmsExpertInfoForm.fdPersonId }'}
						</ui:source>
						<ui:render type="Template">
							{$
								<div class="lui_expert_experience">
									<ul>
									   <li>
									   		<span>${lfn:message('kms-expert:table.kmsExpertInfo.experience') }</span>
									   		<span class="lui_experience">{%data.fdTotalScore%}</span>/{%data.fdScoreRegionUp%}	
									   </li> 
									   <li>
									   		<span 
												class="{%calculatePcClass(data.fdTotalScore, data.fdScoreRegionUp, data.fdScoreRegionDown)%}" >
											</span>
									   </li>
									 </ul>
								 </div>					
							$}	
						</ui:render>
						<ui:event event="load" args="event">
							var grade = event.source.data.fdTotalGrade;
							if(grade) {
								LUI.$('#lui_expert_level_id')
									.html('<span class="lui_expert_level" >' + grade + '</span>');
							}
						</ui:event>
					</ui:dataview>
					 --%>
				</td>
				<td valign="top">
					<div class="lui_expert_top_info">
							<c:set var="sexClass" value="lui_fdSex_M"/>
							<c:if test='${kmsExpertInfoForm.fdSex == "F" }'>
								<c:set var="sexClass" value="lui_fdSex_F"/>
							</c:if>
							<span class="lui_expert_name">
								<c:out value="${kmsExpertInfoForm.fdName }"></c:out>
							</span>
							<span>
								<span class="${sexClass}" style="display:inline-block"></span>
							</span>
							<span id="lui_expert_level_id">
							</span>
							<c:if test="${isCurUser==false }">
								<span onclick="askToExpert('${kmsExpertInfoForm.fdId}')" class="lui_expert_ask_btn"  >
									<a href="javascript:void(0)" >
										${lfn:message('kms-expert:table.kmsExpertInfo.askTohim')}
									</a>
								</span>
							</c:if>
					</div>
					<table class="tb_simple lui_expert_info_tb" width="100%" style="border-bottom:3px solid #f7f6f6;">
						<%--领域 --%>
						<c:forEach items="${kmsExpertAreas}" var="kmsExpertArea" varStatus="vstatus">
							<c:import url="/kms/expert/kms_expert_area_ui/kmsExpertArea_view.jsp"
								charEncoding="UTF-8">
								<c:param name="areaMessage" value="${kmsExpertArea.areaMessageKey}" />
								<c:param name="index" value="${vstatus.index}" />
							</c:import>
						</c:forEach>
						<tr>
					    	<%--部门 --%>
							<td class="td_normal_title" width=10% >
								<bean:message bundle="kms-expert" key="view.kmsExpertInfo.fdDepartment" />：
							</td>
							<td >
								<c:out value="${ kmsExpertInfoForm.fdDeptName}"></c:out>
							</td>
						</tr>
						<tr>
						    <%--岗位 --%>
							<td class="td_normal_title" width=10%>
								<bean:message bundle="kms-expert" key="table.kmsExpertInfo.position" />：
							</td>
							<td>
								<c:out value="${ kmsExpertInfoForm.fdPostNames}"></c:out>
							</td>
						</tr>
						<tr>
							<%--办公电话 --%>
							<td class="td_normal_title" width=10% >
								<bean:message bundle="kms-expert" key="view.kmsExpertInfo.fdWorkPhone" />：
							</td>
							<td>
								<c:out value="${ kmsExpertInfoForm.fdWorkPhone}"></c:out>
							</td>
						</tr>
						<tr>
							<%--电子邮箱 --%>
							<td class="td_normal_title" width=10%>
								<bean:message bundle="kms-expert" key="view.kmsExpertInfo.fdEmail" />：
							</td>
							<td>
								<c:out value="${ kmsExpertInfoForm.fdEmail}"></c:out>
							</td>
						</tr>
						<tr>
							<%--手机号码 --%>
							<td class="td_normal_title" width=10% >
								<bean:message bundle="kms-expert" key="view.kmsExpertInfo.fdMobile" />：
							</td>
							<td>
								<c:out value="${ kmsExpertInfoForm.fdMobileNo}"></c:out>
							</td>
						</tr>
						<tr>
							<%--企业IM --%>
							<td class="td_normal_title" width=10%>
								<bean:message bundle="kms-expert" key="view.kmsExpertInfo.fdImNumber" />：
							</td>
							<td>
								<c:out value="${ kmsExpertInfoForm.fdImNumber}"></c:out>
							</td>
						</tr>
						<tr>
							<%--排序号 --%>
							<td class="td_normal_title" width=10%>
								<bean:message bundle="kms-expert" key="kmsExpertType.fdOrder" />：
							</td>
							<td>
								<c:out value="${ kmsExpertInfoForm.fdOrder}"></c:out>
							</td>
						</tr>
					</table>
					<div class="lui_expert_fdSignature">
						<img   src="${ LUI_ContextPath}/kms/expert/kms_expert_info_ui/style/img/Double_left.png"
							   style="vertical-align: -4px;">
							<xform:textarea property="fdSignature"></xform:textarea>
						<img   src="${ LUI_ContextPath}/kms/expert/kms_expert_info_ui/style/img/Double_right.png"
							   style="vertical-align: -4px;"> 
					</div>
				</td>
			</tr>
			
		</table>
		<div class="lui_form_body" style="height: 15px"></div>
		<table class="lui_form_content" width="100%">
			<tr>
				<td  valign="top" style="width:184px;background: #AEE1F9;">
					<div style="width: 176px;min-height:600px;" class="lui_expert_km_nav">
						<div class="lui_expert_km_selected lui_expert_myKmdetail">
							<span class="lui_expert_nav_span">
								<a style="display:block;"
								   href="javascript:;" 
								   class="lui_expert_nav_links"
								   onclick="myKmDetails('/kms/expert/kms_expert_info/kmsExpertInfo.do?method=info&fdId=${kmsExpertInfoForm.fdId }',this);">
									<img src="${LUI_ContextPath}/kms/expert/kms_expert_info_ui/style/img/icon_base_sel.png" 
											 style="vertical-align: -6px;"
											 class="lui_nav_img_sel"/>
									<img src="${LUI_ContextPath}/kms/expert/kms_expert_info_ui/style/img/icon_base_nor.png" 
									     style="vertical-align: -6px;"
									     class="lui_nav_img_nor"/>
									<c:if test="${isCurUser==true }">
										${lfn:message('kms-expert:nav.kmsExpertInfo.my')}${lfn:message('kms-expert:nav.kmsExpertInfo')}
									</c:if>
									<c:if test="${isCurUser==false }">
										${lfn:message('kms-expert:nav.kmsExpertInfo.his')}${lfn:message('kms-expert:nav.kmsExpertInfo')}
									</c:if>
									
								</a>
							</span><span class="lui_expert_nv_tri_right"></span>
							
						</div>
						<c:forEach var="kmsPersonal" items="${kmsPersonalList}">
							<div class="lui_expert_myKmdetail">
								<span class="lui_expert_nav_span ">
									<a href="javascript:;" 
									   onclick="myKmDetails('${kmsPersonal.personalUrl }',this);"
									    class="lui_expert_nav_links"
									    data-personal-model="${kmsPersonal.modelClass}">
										<img src="${LUI_ContextPath}/kms/expert/kms_expert_info_ui/style/img/${kmsPersonal.icon == null ? 'icon_base': kmsPersonal.icon}_sel.png" 
											 style="vertical-align: -6px;"
											 class="lui_nav_img_sel"/>
										<img src="${LUI_ContextPath}/kms/expert/kms_expert_info_ui/style/img/${kmsPersonal.icon == null ? 'icon_base': kmsPersonal.icon}_nor.png" 
										     style="vertical-align: -6px;"
										     class="lui_nav_img_nor"/>
										<c:if test="${isCurUser==true }">
											${lfn:message('kms-expert:nav.kmsExpertInfo.my')}${kmsPersonal.navMessage}
										</c:if>
										<c:if test="${isCurUser==false }">
											${lfn:message('kms-expert:nav.kmsExpertInfo.his')}${kmsPersonal.navMessage}
										</c:if>
									</a>
								</span><span class="lui_expert_nv_tri_right"></span>
							</div>
						</c:forEach>
						<%--推荐按钮 --%>
						<kmss:auth requestURL="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=introExpert" requestMethod="GET">
							<c:if test="${ kmsExpertInfoForm.docIsIntroduced != true}">
								<%--非推荐 --%>
								<c:set var="introStyle" value="display:block"></c:set>
								<c:set var="cancelStyle" value="display:none"></c:set>
							</c:if>
							<c:if test="${ kmsExpertInfoForm.docIsIntroduced == true}">
								<%--推荐 --%>
								<c:set var="introStyle" value="display:none"></c:set>
								<c:set var="cancelStyle" value="display:block"></c:set>
							</c:if>
							<div class="lui_expert_intro_btn" style="${introStyle}" id="intro" 
								onclick="introExpert('${kmsExpertInfoForm.fdId}','${kmsExpertInfoForm.fdName }','intro');">
								${lfn:message('kms-expert:table.kmsIntroExpert')}
							</div>
							<div class="lui_expert_intro_btn" style="${cancelStyle}" id="cancel" 
								onclick="introExpert('${kmsExpertInfoForm.fdId}','${kmsExpertInfoForm.fdName }','cancel');">
								${ lfn:message('sys-introduce:sysIntroduceMain.cancel.button') }
							</div>
						</kmss:auth>
					</div>
				</td>
				<td valign="top">
					<c:set value="${ LUI_ContextPath}/kms/expert/kms_expert_info/kmsExpertInfo.do?method=info&fdId=${kmsExpertInfoForm.fdId }" 
					       var="infourl"/>
					<c:if test="${not empty knowledgePerson}">
						<c:set  var="infourl" 
								value="${ LUI_ContextPath}${knowledgePerson.personalUrl}?fdOrgId=${fdOrgId}" />
						<script>
							seajs.use(['lui/jquery'], function($) {
								$(document).ready(function() {
									selectKnowledge("${knowledgePerson.modelClass}");
								});
							});
						</script>
					</c:if>
					<div>
						<iframe src="${infourl }" 
								scrolling="no" 
								class="lui_expert_iframe" 
								id="___content">
						</iframe>
					</div>
				</td>
			</tr>
		</table>
	</template:replace>
</template:include>

