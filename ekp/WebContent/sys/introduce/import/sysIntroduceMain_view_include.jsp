<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<div id="intr_editMain" class="intr_editMain">
	<input type="hidden" name="fdKey" value="${param.fdKey}"/>
	<input type="hidden" name="fdModelId" value="${param.fdModelId}"/>
	<input type="hidden" name="fdModelName" value="${param.fdModelName}"/>
	<input type="hidden" name="docSubject" value="${param['docSubject']}"/>
	<input type="hidden" name="fdCateModelName" value="${param['fdCateModelName']}"/>
	<sunbor:enums property="fdIntroduceGrade" enumsType="sysIntroduce_Grade" elementType="select" elementClass="intr_hidden" value="0"/>
	<table class="tb_simple intr_opt_table" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td  width="80%" colspan="2" class="intr_oper">
					<span class="intr_title intr_title_color"><bean:message key="sysIntroduceMain.fdIntroduceGrade" bundle="sys-introduce" /></span>
					<span>
						<ul class="intr_star">
							<li id="intr_star_2" star="2"></li>
							<li id="intr_star_1" star="1"></li>
							<li id="intr_star_0" star="0"></li>
						</ul>
					</span>
					<span id="intr_level" class="intr_level"></span>
					<span id="intr_optarea" class="intr_optarea">
						<span class="intr_optType">
							<c:if test="${param.toEssence == 'true'}">
								<label>
									<input type="checkbox" name="fdIntroduceToEssence" value="0" subject="" validate="intr_select"/>
									<bean:message key="sysIntroduceMain.introduce.type.essence" bundle="sys-introduce"/>
								</label>
							</c:if>
							<c:if test="${param.toNews == 'true'}">
								<label style="display: none;">
									<input type="checkbox" name="fdIntroduceToNews" value="2"/>
									<bean:message key="sysIntroduceMain.introduce.type.news" bundle="sys-introduce"/>
								</label>
							</c:if>
							<c:if test="${'false' != param.toPerson }">
								<label>
									<input type="checkbox" name="fdIntroduceToPerson" value="1" checked="checked" validate="intr_select"/>
									<bean:message key="sysIntroduceMain.introduce.type.person" bundle="sys-introduce" />
								</label>
							</c:if>
						</span>
					</span>
				</td>
			</tr>
			<tr group="intr_person" valign="top">
				<td valign="top" width="85%" colspan="2">
					<div class="intr_peson_opt intr_bolder intr_title_color"><bean:message key="sysIntroduceMain.fdIntroduceTo" bundle="sys-introduce"/></div>
					<xform:address propertyId="fdIntroduceGoalIds" style="width:90%" propertyName="fdIntroduceGoalNames" subject="${lfn:message('sys-introduce:sysIntroduceMain.fdIntroduceTo') }" 
						required="true" validators="repetitionValidator(fdIntroduceGoalIds)" showStatus="edit" orgType="ORG_TYPE_ALL" mulSelect="true">
					</xform:address>
				</td>
			</tr>
			<tr>
				<td valign="top" width="85%">
					<textarea name="fdIntroduceReason" class="intr_content">
				 	</textarea>
				</td>
				<td align="center" valign="top">
					<input id="intr_button" class="intr_button" type=button value="<bean:message key="button.submit"/>"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<label class="intr_notify intr_summary_color">
						<input name="fdIsNotify" type="checkbox" value="1" checked="checked">
						<bean:message key="sysIntroduceMain.introduce.notify.auth" bundle="sys-introduce" />
					</label>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<label class="intr_notify intr_summary_color">
						<bean:message key="sysNotifySetting.fdNotifyType" bundle="sys-notify" />：<kmss:editNotifyType property="fdNotifyType" value=""/>
					</label>
					<span class="intr_prompt"></span>
				</td>
			</tr>
		</table>
</div>