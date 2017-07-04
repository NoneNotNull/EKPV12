<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%@page import="java.util.Date"%>
<script type="text/javascript" src='<c:url value="/third/pda/resource/script/mechansm.js"/>'></script>
<script language="JavaScript">
	Com_IncludeFile("jquery.js");
</script>
<c:set var="s_mainForm" value="${requestScope[param.formName]}" />
<c:if test="${s_mainForm.evaluationForm.fdIsShow=='true'}">
	<c:set var="s_fdModelName" value="${s_mainForm.evaluationForm.fdModelName}"/>
	<c:set var="s_fdModelId" value="${s_mainForm.evaluationForm.fdModelId}"/>
	<c:set var="s_requestUrl"
		value="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=add&fdModelName=${s_fdModelName}&fdModelId=${s_fdModelId}&fdIsNewVersion=${sysEvaluationForm.evaluationForm.fdIsNewVersion}&notifyOtherName=${param.notifyOther}&bundel=${param.bundel}&key=${param.key}" />
	<c:if test="${param.showFold==true }">
		<tr class="tr_extendTitle">
			<td class="td_title">
				<bean:message key="table.sysEvaluationMain" bundle="sys-evaluation" />
			</td><td>&nbsp;</td></tr>
			<tr><td colspan="2" class="td_common">
	</c:if>
	<div id="div_evaluation" class="div_operatePanel">
		<kmss:auth requestURL="${s_requestUrl}" requestMethod="GET">
			<html:form method="POST" action="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=save" 
				onsubmit="return submitMechansmForm(this,eval_beforeSubmit,eval_afterSubmitForm);">
				<html:hidden property="fdId" />
				<html:hidden property="fdEvaluatorName" value="${KMSS_Parameter_CurrentUserName}"/>
				<html:hidden property="fdEvaluationTime"/>
				<html:hidden property="method_GET" value="post"/>
				<html:hidden property="fdKey" value="${param.key}"/>
				<html:hidden property="fdModelId" value="${s_fdModelId}"/>
				<html:hidden property="fdModelName" value="${s_fdModelName}"/>
				<html:hidden property="fdEvaluationScore" value="1"/>
				<html:hidden property="isNotify" value="true"/>
				<div style="display: none"><kmss:editNotifyType property="fdNotifyType"/></div>
				<div>
					<table class="tab_editElva">
						<tr>
							<td width="30%"><h2><bean:message key="sysEvaluation.title" bundle="sys-evaluation" /></h2></td>
							<td width="40%">
								<ul id="ul_star" class="star_rating">
									<li id="stars_1" class="starGood" onclick="selectStar(this);"></li>
									<li id="stars_2" class="starGood" onclick="selectStar(this);"></li>
									<li id="stars_3" class="starGood" onclick="selectStar(this);"></li>
									<li id="stars_4" class="starGood" onclick="selectStar(this);"></li>
									<li id="stars_5" class="starBad" onclick="selectStar(this);"></li>
								</ul>
							</td>
							<td id="evScoreTd" width="30%" class="evScoreGood">
								<bean:message key="sysEvaluationMain.evaluationScore.good" bundle="sys-evaluation" />
							</td>
						</tr>
						<tr>
							<td colspan="3">
								<html:textarea rows="3" style="width: 99%;border: 1px solid black;color: gray;" property="fdEvaluationContent" 
									value='<%=ResourceUtil.getString("sysEvaluation.fourStar.showText","sys-evaluation") %>' 
									onfocus="onValueChg_eval(this,true);" onkeyup="onValueChg_eval(this,true);"/>
								
							</td>
						</tr>
						<tr>
							<td colspan="2" align="left">
								<div id="div_prompt_eval"></div>
							</td>
							<td>
								<input id="btn_submit_eval" type="submit" value='<bean:message key="table.sysEvaluationMain" bundle="sys-evaluation"/>'/>
							</td>
						</tr>
					</table>
				</div>
			</html:form>
		</kmss:auth>
		<div class="div_listArea" id="div_listEval">
			<div style='margin: 10px 0px;'><bean:message key="sysEvaluation.list.loading" bundle="sys-evaluation"/></div>
		</div>
	</div>
	<c:if test="${param.showFold==true }">
		</td></tr>
	</c:if>
	<script type="text/javascript">
	    window.S_OnWriting=false;
		function onValueChg_eval(thisObj,changeBtn){
			if(thisObj.style.color!=''){
				thisObj.value='';
				thisObj.style.color='';
				window.S_OnWriting=false;
			}else{
				if(thisObj.value.trim()!='')
					window.S_OnWriting=true;
				else
				  	window.S_OnWriting=false;
			}
			var evalStr=thisObj.value.split("");
			var promptVar=document.getElementById("div_prompt_eval");
			var submitVar=document.getElementById("btn_submit_eval");
			var l = 0;
			for (var i = 0; i < evalStr.length; i++) {				
				if (evalStr[i].charCodeAt(0) < 299) {
					l++;
				} else {
					l += 2;
				}
			}
			if(l<=280){
				promptVar.innerHTML='<bean:message key="sysEvaluation.pda.alert1" bundle="sys-evaluation"/>'+Math.abs(parseInt((280-l) / 2))+'<bean:message key="sysEvaluation.pda.alert3" bundle="sys-evaluation"/>';
				promptVar.style.color="";
				if(changeBtn)
					submitVar.disabled = false;
			}else{
				promptVar.innerHTML='<bean:message key="sysEvaluation.pda.alert2" bundle="sys-evaluation"/>'+Math.abs(parseInt((l-280) / 2))+'<bean:message key="sysEvaluation.pda.alert3" bundle="sys-evaluation"/>';
				promptVar.style.color="red";
				if(changeBtn)
					submitVar.disabled = true;
			}	
		}
		function selectStar(thisObj){
			var objId=thisObj.getAttribute("id");
			if(objId.indexOf("_")>-1){
				var indexVar=parseInt(objId.substr(objId.indexOf("_")+1), 10);
				var scoreTd=document.getElementById("evScoreTd");
				var scoreVal=document.getElementsByName("fdEvaluationScore")[0];
				var contentVar=document.getElementsByName("fdEvaluationContent")[0];
				scoreVal.value=5-indexVar;
				thisObj.setAttribute("class", "starGood");
				if(window.S_OnWriting==false )
					contentVar.style.color="gray";
				for( var i= 1; i<= 5; i++) {
					if(i<indexVar)
						document.getElementById("stars_"+i).setAttribute("class", "starGood");
					if(i>indexVar)
						document.getElementById("stars_"+i).setAttribute("class", "starBad");
				}
				switch(indexVar){
					case 1:{
						Com_SetInnerText(scoreTd, '<bean:message key="sysEvaluationMain.evaluationScore.bad" bundle="sys-evaluation"/>');
						scoreTd.setAttribute("class","evScoreBad");
						if(window.S_OnWriting==false )
							contentVar.value='<bean:message key="sysEvaluation.oneStar.showText" bundle="sys-evaluation"/>';
						break;
					}
					case 2:{
						Com_SetInnerText(scoreTd, '<bean:message key="sysEvaluationMain.evaluationScore.normal" bundle="sys-evaluation"/>');
						scoreTd.setAttribute("class","evScoreBad");
						if(window.S_OnWriting==false)
							contentVar.value='<bean:message key="sysEvaluation.twoStar.showText" bundle="sys-evaluation"/>';
						break;
					}
					case 3:{
						Com_SetInnerText(scoreTd, '<bean:message key="sysEvaluationMain.evaluationScore.good" bundle="sys-evaluation"/>');
						scoreTd.setAttribute("class","evScoreGood");
						if(window.S_OnWriting==false)
							contentVar.value='<bean:message key="sysEvaluation.threeStar.showText" bundle="sys-evaluation"/>';
						break;
					}
					case 4:{
						Com_SetInnerText(scoreTd, '<bean:message key="sysEvaluationMain.evaluationScore.better" bundle="sys-evaluation" />');
						scoreTd.setAttribute("class","evScoreGood");
						if(window.S_OnWriting==false)
							contentVar.value='<bean:message key="sysEvaluation.fourStar.showText" bundle="sys-evaluation" />';
						break;
					}
					case 5:{
						Com_SetInnerText(scoreTd, '<bean:message key="sysEvaluationMain.evaluationScore.best" bundle="sys-evaluation"/>');
						scoreTd.setAttribute("class","evScoreGood");
						if(window.S_OnWriting==false)
							contentVar.value='<bean:message key="sysEvaluation.oneStar.fiveText" bundle="sys-evaluation" />';
						break;
					}
				}		
			}
		}
		function eval_beforeSubmit(){
			var todayVar=new Date();
			document.getElementsByName("fdEvaluationTime")[0].value=todayVar.getFullYear()+"-"+(todayVar.getMonth()+1)+
					"-"+todayVar.getDate()+" "+todayVar.getHours()+":"+todayVar.getMinutes();
			//5秒后才能再次使用
			var submitVar = document.getElementById("btn_submit_eval");
			submitVar.setAttribute("disabled","disabled");
			setTimeout("document.getElementById('btn_submit_eval').removeAttribute('disabled');", 5000);
			return true;
		}
		
		function eval_afterSubmitForm(){
			var viewList=document.getElementById("ul_viewEvalList");
			var htmlVar="<div style='padding-bottom:3px;'>";
			var contentVar=document.getElementsByName("fdEvaluationContent")[0];
			htmlVar+=Com_HtmlEscape(contentVar.value);
			htmlVar+='</div>';
			htmlVar+='<div class="evScoreList">';
			htmlVar+='<ul>';
			for(var j=0;j<=4;j++){
				htmlVar+='<li class="'+((j<5-parseInt(document.getElementsByName("fdEvaluationScore")[0].value,10))?'selected':'')+'"></li>';
			}
			htmlVar+='</ul>';
			htmlVar+="</div>";
			htmlVar+="<p class='list_summary'>"+document.getElementsByName("fdEvaluatorName")[0].value+" | "+document.getElementsByName("fdEvaluationTime")[0].value;
			htmlVar+="</p>";
			if(viewList==null){
				viewList=document.createElement("ul");
				viewList.className="viewList";
				viewList.setAttribute("id", "ul_viewEvalList");
				viewList.innerHTML="<li class='leftShort'>"+htmlVar+"</li>";
				document.getElementById("div_listEval").innerHTML=viewList.outerHTML;
			}else{
				var liObj=document.createElement("li");
				liObj.setAttribute("class","leftShort");
				liObj.innerHTML=htmlVar;
				viewList.insertBefore(liObj, viewList.firstChild);
			}
			//重置
			document.getElementsByName("fdEvaluationContent")[0].value='';
			onValueChg_eval(contentVar,false);
			selectStar(document.getElementById("stars_4"));
			
		}
		function eval_getViewHtml(docs){
			var html="";
			/**数据**/
			html+="<ul class='viewList' id='ul_viewEvalList'>";
			for ( var i = 0; i < docs.length; i++) {
				html+="<li class='leftShort'><div style='padding-bottom:3px;'>";
				html+=Com_HtmlEscape(docs[i]["subject"]);
				html+='</div>';
				html+='<div class="evScoreList">';
				html+='<ul>';
				for(var j=0;j<=4;j++){
					html+='<li class="'+((j<5-parseInt(docs[i]["url"],10))?'selected':'')+'"></li>';
				}
				html+='</ul>';
				html+="</div>";
				html+="<p class='list_summary'>"+Com_HtmlEscape(docs[i]["summary"]);
				html+="</p>";
				html+="</li>";
			}
			html+="</ul>";
			return html;
		}
		var tmpConfig={
			"listUrl":'<c:url value="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do"/>?method=list',
			"parameter":"&rowsize=10&forward=list4Doc&fdModelId=${s_fdModelId}&fdModelName=${s_fdModelName}",
			"contentDiv":"div_evaluation",
			"listDiv":"div_listEval",
			"getViewHtml":eval_getViewHtml,
			"needPage":"true"};
		if(window.addMechansmInfo){
			addMechansmInfo("evaluation",tmpConfig);
		}else{
			if(window.S_MechansmMap!=null){
				S_MechansmMap.put("evaluation",tmpConfig);
			}
		}
		S_PageLan={"prePage":'<bean:message key="page.thePrev"/>',
				"nextPage":'<bean:message key="page.theNext"/>'};
	</script>
</c:if>
