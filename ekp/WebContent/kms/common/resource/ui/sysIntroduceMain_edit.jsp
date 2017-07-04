<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/include_kms_top.jsp" %>
<html:form action="/kms/common/resource/ui/kmsSysIntroduceMain.do"   >
	
	<%@ include file="sysIntroduceMain_script.jsp"%>
	<html:hidden property="fdId" />
	<center> 
		<table class="t_d" border=0 width="100%" id="TB_MainTable">
			<tr class='t_d_a'>
				<td width="15%" valign="center" >
					<bean:message key="sysIntroduceMain.introduce.type" bundle="sys-introduce" />
				</td>
				<td colspan="3" valign="center">
					<c:if test="${param.toEssence == 'true'}">
						<label>
						<input type="checkbox" name="fdIntroduceToEssence" value="1" id="fdIntroduceToEssence"/>
							<bean:message key="sysIntroduceMain.introduce.type.essence" bundle="sys-introduce"/>
						</label>
					</c:if>
					<c:if test="${param.toNews == 'true'}">
						<label>
							<input type="hidden" id="fdIntroduceToNews"  name="fdIntroduceToNews" value="" onclick="refreshTypeDisplay();"/>
						</label>
					</c:if>
					<label>
						<input type="checkbox" name="fdIntroduceToPerson"  id="fdIntroduceToPerson" value="1" onclick="refreshTypeDisplay();" checked="checked"/>
						<bean:message key="sysIntroduceMain.introduce.type.person" bundle="sys-introduce" />
					</label>
				</td>
			</tr>
			<tr class='t_d_b'>
				<td valign="center" >
					<bean:message key="sysIntroduceMain.fdIntroducer" bundle="sys-introduce" />
				</td>
				<td width="35%" valign="center">
					<html:hidden property="fdIntroducerName"  />
					<c:out value="${sysIntroduceMainForm.fdIntroducerName}"/> 
				</td>
				<td width="15%" valign="center"  >
					<bean:message key="sysIntroduceMain.fdIntroduceTime" bundle="sys-introduce" />
				</td>
				<td width="35%" valign="center">
					<html:hidden property="fdIntroduceTime"  />
					<c:out value="${sysIntroduceMainForm.fdIntroduceTime}"/> 
				</td>
			</tr>
			<tr KMSS_RowType="IntroduceToNews" style="display: none">
				<td   width=15%>
					<bean:message  bundle="sys-introduce" key="sysIntroduceMain.fdNewsCategory"/>
				</td>
				<td width=35%>			
					<html:hidden property="fdNewsCategoryId" styleId="fdNewsCategoryId"/>			
					<html:text property="fdNewsCategoryName" readonly="true" styleClass="inputsgl"/> 		
				     <a href="#"
						onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.sys.news.model.SysNewsTemplate','fdNewsCategoryId::fdNewsCategoryName',false,true,null);">
						<bean:message key="dialog.selectOther" /></a>
					<span class="txtstrong">*</span>	
				 </td>
				<td   width=15%>
					<bean:message  bundle="sys-introduce" key="sysIntroduceMain.fdNewsImportance"/>
				</td>
				<td width=35%> 
					<sunbor:enums  property="fdNewsImportance" elementType="radio"  enumsType="sysNewsMain_fdImportance" bundle="sys-news"/>
			  	</td> 
			</tr>
			<tr KMSS_RowType="IntroduceToNews" style="display: none">
				<td   width=15%>
					<bean:message  bundle="sys-introduce" key="sysIntroduceMain.fdNewsTitle"/>
				</td>
				<td width=35% colspan=3>
					<html:hidden property="fdOriginalAuthorName" value="${param.docCreatorName}"/>
					<html:hidden property="fdOriginalDocSubject" value="${param.docSubject}"/>
					<html:text property="fdNewsTitle" styleClass="inputsgl" style="width:85%" value="${param.docSubject}"/> 		
					<span class="txtstrong">*</span>	
				</td> 
			</tr>
			<tr class='t_d_a'>
				<td valign="center"  >
					<bean:message key="sysIntroduceMain.fdIntroduceGrade" bundle="sys-introduce" />
				</td>
				<td colspan="3" valign="center">
					<sunbor:enums property="fdIntroduceGrade" enumsType="sysIntroduce_Grade" elementType="radio"/>
				</td>
			</tr>
			
			<tr class='t_d_b'>
				<td valign="center"  >
					<bean:message key="sysIntroduceMain.fdIntroduceReason" bundle="sys-introduce" />
				</td>
				<td colspan="3" valign="center">
					<html:textarea property="fdIntroduceReason"  styleId="fdIntroduceReason" style="width:100%;height:80pt;" />
				</td>
			</tr>

			<tr KMSS_RowType="IntroduceToPerson" class='t_d_a'>
				<td valign="center" >
					<bean:message key="sysIntroduceMain.fdIntroduceTo" bundle="sys-introduce" />
				</td>
				<td colspan="3" valign="center">
					<html:hidden property="fdIntroduceGoalIds" styleId="fdIntroduceGoalIds"/>
					<html:text property="fdIntroduceGoalNames" readonly="true" styleClass="inputsgl" style="width:90%;" />
					<span class="txtstrong">*</span> <a href="#" onclick="Dialog_Address(true, 'fdIntroduceGoalIds','fdIntroduceGoalNames', ';', ORG_TYPE_ALL);"> <bean:message key="dialog.selectOrg" /> </a>
				</td>
			</tr>
			<tr KMSS_RowType="IntroduceToPerson" class='t_d_b'>
				<td  >
					<bean:message key="sysNotifySetting.fdNotifyType" bundle="sys-notify" />
				</td>
				<td colspan="3">
					<kmss:editNotifyType property="fdNotifyType" />
				</td>
			</tr>
		</table>
	</center>
	<html:hidden property="method_GET" />
	<html:hidden property="fdKey" />
	 
    <html:hidden property="fdModelId"  value='${param.fdModelId}'/>
	<html:hidden property="fdModelName" value='${param.fdModelName}'/>
	<html:hidden property="fdIsNewVersion" />
</html:form><div align="right">
<input type=button id='submintIntroduceButton' value="推 荐" onclick="commitForms();"></div>
<div id="success" style="border-width:1px;border-style:solid;position:absolute;display:none;top:35%;left:40%;background:#f8f8f8;width:200px;height:50px;" align="center"> 
<br><font size="4"><bean:message bundle="" key="return.optSuccess" /></font> 
</div>
<html:javascript formName="sysIntroduceMainForm" cdata="false" dynamicJavascript="true" staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
