<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
	<script language="JavaScript">
		Com_IncludeFile("dialog.js|jquery.js");
		function onValueChg_intr(thisObj){
			var introStr=thisObj.value.split("");
			var promptVar=document.getElementById("div_prompt_intr");
			var l = 0;
			for (var i = 0; i < introStr.length; i++) {				
				if (introStr[i].charCodeAt(0) < 299) {
					l++;
				} else {
					l += 2;
				}
			}
			if(l<=280){
				promptVar.innerHTML='<bean:message key="sysIntroduceMain.pda.alert1" bundle="sys-introduce"/>'+Math.abs(parseInt((280-l) / 2))+'<bean:message key="sysIntroduceMain.pda.alert3" bundle="sys-introduce"/>';
				promptVar.style.color="";
			}else{
				promptVar.innerHTML='<bean:message key="sysIntroduceMain.pda.alert2" bundle="sys-introduce"/>'+Math.abs(parseInt((l-280) / 2))+'<bean:message key="sysIntroduceMain.pda.alert3" bundle="sys-introduce"/>';
				promptVar.style.color="red";
			}	
		}

	function Intro_Submit(){
			var promptVar=document.getElementById("div_prompt_intr");
			if(promptVar.style.color=="red"){
		      alert("推荐字数不能超过140字");
			}else{			
				commitForm();
			
			}
		}
</script>
<html:form action="/sys/introduce/sys_introduce_main/sysIntroduceMain.do" onsubmit="return validateSysIntroduceMainForm(this);">
	<div id="optBarDiv">
		<c:if test="${sysIntroduceMainForm.method_GET=='add'}">
			<input type=button value="<bean:message key="button.submit"/>" onclick="Intro_Submit();">
		</c:if>
		<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
	</div>
	<%@ include file="sysIntroduceMain_script.jsp"%>
	<html:hidden property="fdId" />
	<center>
		<table class="tb_normal" width="95%" id="TB_MainTable">
			<tr>
				<td width="15%" valign="center" class="td_normal_title">
					<bean:message key="sysIntroduceMain.introduce.type" bundle="sys-introduce" />
				</td>
				<td colspan="3" valign="center">
					<c:if test="${param.toEssence == 'true'}">
						<label>
							<input type="checkbox" name="fdIntroduceToEssence" value="1" />
							<bean:message key="sysIntroduceMain.introduce.type.essence" bundle="sys-introduce"/>
						</label>
					</c:if>
					<c:if test="${param.toNews == 'true'}">
						<label>
							<input type="checkbox" name="fdIntroduceToNews" value="1" onclick="refreshTypeDisplay();"/>
							<bean:message key="sysIntroduceMain.introduce.type.news" bundle="sys-introduce" />
						</label>
					</c:if>
					<label>
						<input type="checkbox" name="fdIntroduceToPerson" value="1" onclick="refreshTypeDisplay();" checked="checked"/>
						<bean:message key="sysIntroduceMain.introduce.type.person" bundle="sys-introduce" />
					</label>
				</td>
			</tr>
			<tr>
				<td valign="center" class="td_normal_title">
					<bean:message key="sysIntroduceMain.fdIntroducer" bundle="sys-introduce" />
				</td>
				<td width="35%" valign="center">
					<html:text property="fdIntroducerName" style="width:90%;" readonly="true" />
				</td>
				<td width="15%" valign="center" class="td_normal_title">
					<bean:message key="sysIntroduceMain.fdIntroduceTime" bundle="sys-introduce" />
				</td>
				<td width="35%" valign="center">
					<html:text property="fdIntroduceTime" style="width:90%;" readonly="true" />
				</td>
			</tr>
			<tr KMSS_RowType="IntroduceToNews" style="display: none">
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="sys-introduce" key="sysIntroduceMain.fdNewsCategory"/>
				</td>
				<td width=35%>			
					<html:hidden property="fdNewsCategoryId"/>			
					<html:text property="fdNewsCategoryName" readonly="true" styleClass="inputsgl"/> 		
				     <a href="#"
						onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.sys.news.model.SysNewsTemplate','fdNewsCategoryId::fdNewsCategoryName',false,true,null);">
						<bean:message key="dialog.selectOther" /></a>
					<span class="txtstrong">*</span>	
				 </td>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="sys-introduce" key="sysIntroduceMain.fdNewsImportance"/>
				</td>
				<td width=35%> 
					<sunbor:enums  property="fdNewsImportance" elementType="radio"  enumsType="sysNewsMain_fdImportance" bundle="sys-news"/>
			  	</td> 
			</tr>
			<tr KMSS_RowType="IntroduceToNews" style="display: none">
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="sys-introduce" key="sysIntroduceMain.fdNewsTitle"/>
				</td>
				<td width=35% colspan=3>
					<html:hidden property="fdOriginalAuthorName" value="${param.docCreatorName}"/>
					<html:hidden property="fdOriginalDocSubject" value="${param.docSubject}"/>
					<html:text property="fdNewsTitle" styleClass="inputsgl" style="width:85%" value="${param.docSubject}"/> 		
					<span class="txtstrong">*</span>	
				</td> 
			</tr>
			<tr>
				<td valign="center" class="td_normal_title">
					<bean:message key="sysIntroduceMain.fdIntroduceGrade" bundle="sys-introduce" />
				</td>
				<td colspan="3" valign="center">
					<sunbor:enums property="fdIntroduceGrade" enumsType="sysIntroduce_Grade" elementType="radio"/>
				</td>
			</tr>
			<tr>
				<td valign="center" class="td_normal_title">
					<bean:message key="sysIntroduceMain.fdIntroduceReason" bundle="sys-introduce" />
				</td>
				<td colspan="3" valign="center">
					<html:textarea property="fdIntroduceReason" style="width:95%;height:120pt;" 
					onfocus="onValueChg_intr(this);"  onkeyup="onValueChg_intr(this);"/>
					<div id="div_prompt_intr"></div>
				</td>
			</tr>

			<tr KMSS_RowType="IntroduceToPerson">
				<td valign="center" class="td_normal_title">
					<bean:message key="sysIntroduceMain.fdIntroduceTo" bundle="sys-introduce" />
				</td>
				<td colspan="3" valign="center">
					<html:hidden property="fdIntroduceGoalIds" />
					<html:text property="fdIntroduceGoalNames" readonly="true" styleClass="inputsgl" style="width:90%;" />
					<span class="txtstrong">*</span> <a href="#" onclick="Dialog_Address(true, 'fdIntroduceGoalIds','fdIntroduceGoalNames', ';', ORG_TYPE_ALL);"> <bean:message key="dialog.selectOrg" /> </a>
				</td>
			</tr>
			<tr KMSS_RowType="IntroduceToPerson">
				<td class="td_normal_title">
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
	<html:hidden property="fdModelId" />
	<html:hidden property="fdModelName" />
	<html:hidden property="fdIsNewVersion" />
</html:form>
<html:javascript formName="sysIntroduceMainForm" cdata="false" dynamicJavascript="true" staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
