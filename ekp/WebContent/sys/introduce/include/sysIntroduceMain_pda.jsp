<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%@page import="java.util.Date"%>
<script type="text/javascript" src='<c:url value="/third/pda/resource/script/mechansm.js"/>'></script>

<c:set var="s_mainForm" value="${requestScope[param.formName]}" />
<c:if test="${s_mainForm.introduceForm.fdIsShow=='true'}">
	<c:set var="s_fdModelName" value="${s_mainForm.introduceForm.fdModelName}"/>
	<c:set var="s_fdModelId" value="${s_mainForm.introduceForm.fdModelId}"/>
	<c:set var="s_requestUrl"
		value="/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=add&fdModelName=${s_fdModelName}&fdModelId=${s_fdModelId}" />
	<c:if test="${param.showFold==true }">
		<tr class="tr_extendTitle">
			<td class="td_title">
				<bean:message key="sysIntroduceMain.button.introduce" bundle="sys-introduce"/>
			</td><td>&nbsp;</td></tr>
			<tr><td colspan="2" class="td_common">
	</c:if>
	<div id="div_introduce" class="div_operatePanel">
		<kmss:auth requestURL="${s_requestUrl}" requestMethod="GET">
			<html:form method="POST" action="/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=save" 
				onsubmit="return submitMechansmForm(this,intr_beforeSubmit,intr_afterSubmitForm);">
				<html:hidden property="fdIntroduceToPerson" value="1"/>
				<html:hidden property="fdIntroduceTime" />
				<html:hidden property="fdModelName" value="${s_fdModelName}" />
				<html:hidden property="fdModelId" value="${s_fdModelId}"/>
				<html:hidden property="fdIntroducerName" value="${KMSS_Parameter_CurrentUserName}"/>
				<div style="display: none"><kmss:editNotifyType property="fdNotifyType"/></div>
				<div>
					<table class="tab_editIntr">
						<tr>
							<td width="25%"><h2><bean:message key="sysIntroduceMain.fdIntroduceGrade" bundle="sys-introduce" /></h2></td>
							<td width="75%">
								<sunbor:enums property="fdIntroduceGrade" enumsType="sysIntroduce_Grade" elementType="select" />
							</td>
						</tr>
						<tr>
							<td><h2><bean:message key="sysIntroduceMain.fdIntroduceReason" bundle="sys-introduce" /></h2></td>
							<td>
								<html:textarea property="fdIntroduceReason" style="width: 95%;" 
									onfocus="onValueChg_intr(this,true);"  onkeyup="onValueChg_intr(this,true);"/>
								<div id="div_prompt_intr"></div>
							</td>
						</tr>
						<tr>
							<td><h2><bean:message key="sysIntroduceMain.fdIntroduceTo" bundle="sys-introduce" /></h2></td>
							<td>
								<script type="text/javascript" src="<c:url value="/third/pda/resource/script/address.js"/>"></script>
								<html:hidden property="fdIntroduceGoalIds" />
								<html:hidden property="fdIntroduceGoalNames" />
								<input type="button" class="selectStyle" onclick="Pda_Address('fdIntroduceGoalIds', 'fdIntroduceGoalNames', true, ';', ORG_TYPE_ALL);" 
								 value=''/>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<input id="btn_submit_intr" type="submit" value='<bean:message key="sysIntroduceMain.button.introduce" bundle="sys-introduce"/>'/>
							</td>
						</tr>
					</table>
				</div>
			</html:form>
		</kmss:auth>
		<div class="div_listArea" id="div_listIntro">
			<div style='margin: 10px 0px;'><bean:message key="sysIntroduceMain.list.loading" bundle="sys-introduce"/></div>
		</div>
	</div>
	<c:if test="${param.showFold==true }">
		</td></tr>
	</c:if>
	<script type="text/javascript">
		function onValueChg_intr(thisObj,changeBtn){
			var introStr=thisObj.value.split("");
			var promptVar=document.getElementById("div_prompt_intr");
			var submitVar=document.getElementById("btn_submit_intr");
			var l = 0;
			for (var i = 0; i < evalStr.length; i++) {				
				if (introStr[i].charCodeAt(0) < 299) {
					l++;
				} else {
					l += 2;
				}
			}
			if(l<=280){
				promptVar.innerHTML='<bean:message key="sysIntroduceMain.pda.alert1" bundle="sys-introduce"/>'+Math.abs(parseInt((280-l) / 2))+'<bean:message key="sysIntroduceMain.pda.alert3" bundle="sys-introduce"/>';
				promptVar.style.color="";
				if(changeBtn)
					submitVar.disabled=false;
			}else{
				promptVar.innerHTML='<bean:message key="sysIntroduceMain.pda.alert2" bundle="sys-introduce"/>'+Math.abs(parseInt((l-280) / 2))+'<bean:message key="sysIntroduceMain.pda.alert3" bundle="sys-introduce"/>';
				promptVar.style.color="red";
				if(changeBtn)
					submitVar.disabled=true;
			}	
		}
		function intr_beforeSubmit(){
			var todayVar=new Date();
			if(document.getElementsByName("fdIntroduceGoalNames")[0].value==""){
				alert('<bean:message key="sysIntroduceMain.fdIntroduceTo.error.showMessage" bundle="sys-introduce"/>');
				return false;
			}
			var cententVar=document.getElementsByName("fdIntroduceReason")[0].value;
			if(cententVar!="" && cententVar.lenght>700){
				alert('<bean:message key="sysIntroduceMain.pda.alert" bundle="sys-introduce"/>');
				return false;
			}
			document.getElementsByName("fdIntroduceTime")[0].value=todayVar.getFullYear()+"-"+(todayVar.getMonth()+1)+
					"-"+todayVar.getDate()+" "+todayVar.getHours()+":"+todayVar.getMinutes();
			//5秒后才能再次使用
			var submitVar=document.getElementById("btn_submit_intr");
			submitVar.disabled=true;
			setTimeout("document.getElementById('btn_submit_intr').disabled=false;", 5000);
			return true;
		}
		
		function intr_afterSubmitForm(){
			var viewList=document.getElementById("ul_viewIntrList");
			var htmlVar="<div style='padding-bottom:3px;'>";
			var cententVar=document.getElementsByName("fdIntroduceReason")[0];
			htmlVar+=Com_HtmlEscape(cententVar.value);
			htmlVar+='</div>';
			var fdIntroduceGrade=document.getElementsByName("fdIntroduceGrade")[0];
			htmlVar+="<p class='list_summary'>" + document.getElementsByName("fdIntroducerName")[0].value + " | "
					+ document.getElementsByName("fdIntroduceTime")[0].value + " | "
					+ fdIntroduceGrade.options[fdIntroduceGrade.selectedIndex].text + " | "
					+ '<bean:message key="sysIntroduceMain.introduce.show.type.person" bundle="sys-introduce"/>'
					+ "(" + document.getElementsByName("fdIntroduceGoalNames")[0].value + ")";
			htmlVar+="</p>";
			if(viewList==null){
				viewList=document.createElement("ul");
				viewList.className="viewList";
				viewList.setAttribute("id", "ul_viewIntrList");
				viewList.innerHTML="<li class='leftShort'>"+htmlVar+"</li>";
				document.getElementById("div_listIntro").innerHTML=viewList.outerHTML;
			}else{
				var liObj=document.createElement("li");
				liObj.setAttribute("class","leftShort");
				liObj.innerHTML=htmlVar;
				viewList.insertBefore(liObj, viewList.firstChild);
			}
			//重置
			cententVar.value='';
			fdIntroduceGrade.selectedIndex=0;
			onValueChg_intr(cententVar,false);
			Pda_clear("fdIntroduceGoalIds","fdIntroduceGoalNames");
		}
		function intr_getViewHtml(docs){
			var html="";
			html+="<ul class='viewList' id='ul_viewIntrList'>";
			for ( var i = 0; i < docs.length; i++) {
				html+="<li class='leftShort'><div style='padding-bottom:3px;'>";
				html+=Com_HtmlEscape(docs[i]["subject"]);
				html+='</div>';
				html+="<p class='list_summary'>"+docs[i]["summary"];
				html+="</p>";
				html+="</li>";
			}
			html+="</ul>";
			return html;
		}
		var tmpConfig = {
				"listUrl":'<c:url value="/sys/introduce/sys_introduce_main/sysIntroduceMain.do"/>?method=viewAll',
				"parameter":"&rowsize=10&fdModelId=${s_fdModelId}&fdModelName=${s_fdModelName}",
				"contentDiv":"div_introduce",
				"listDiv":"div_listIntro",
				"getViewHtml":intr_getViewHtml,
				"needPage":"true"};
		if(window.addMechansmInfo){
			addMechansmInfo("introduce",tmpConfig);
		}else{
			if(window.S_MechansmMap!=null){
				S_MechansmMap.put("introduce",tmpConfig);
			}
		}
		
		
		S_PageLan={"prePage":'<bean:message key="page.thePrev"/>',
				"nextPage":'<bean:message key="page.theNext"/>'};
	</script>
</c:if>
