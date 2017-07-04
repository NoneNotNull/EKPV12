<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<ui:ajaxtext>
	<script>
		seajs.use("kms/integral/kms_integral_portlet_ui/style/star.css");
	</script>
	<ui:dataview>
			<ui:source type="AjaxJson">
				{url:'/kms/integral/kms_integral_portlet_month/kmsIntegralPortletMonth.do?method=getStar&type=${param.type}&deptId=${param.deptId}&personId=${param.personId}'}
			</ui:source>
			<ui:render type="Template">
				{$
					<div class="lui_star_box clearfloat">
						<a  href="<person:zoneUrl personId='{%data.fdPersonId%}'/>" 
							class="lui_star_img_a" title="" target="_blank">
							<img src="${LUI_ContextPath}/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId={%data.fdPersonId%}">
						</a>
						<ul class="lui_star_ul">
							<c:set var="timeType" value="${param.type}"></c:set>
							<li>
								${lfn:message(lfn:concat('kms-integral:kmsIntegralCommon.this.',timeType))}知识之星：
								<ui:person personId="{%data.fdPersonId%}" personName="{%data.fdPersonName%}"></ui:person>
							</li>
							<li>${lfn:message(lfn:concat('kms-integral:kmsIntegralCommon.this.',timeType))}积分：
								<span>{%data.fdScore%}分</span>
							</li>
							<li><a title="" class="lui_grade_bg" href="javascript:void(0)">
								{%data.fdGrade%}</a>
								<span style="padding-left: 5px" class="com_number">
									{%data.fdLevel%}
								</span>
							</li>
						</ul>
					</div>
				$}
			</ui:render>
	</ui:dataview>
</ui:ajaxtext>