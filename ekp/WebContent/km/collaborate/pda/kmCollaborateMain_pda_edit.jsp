<%@page import="com.landray.kmss.third.pda.forms.PdaModuleConfigMainForm"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/km/collaborate/pda/js/kmCollaborateMain_pda_public_js.jsp" %>
<html>
<head>
<title><bean:message bundle="km-collaborate" key="kmCollaborateMain.pda.edit.title"/></title>
<meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no">
<script src="${KMSS_Parameter_ContextPath}km/collaborate/pda/js/jquery.endless-scroll.js"></script>
<script src="${KMSS_Parameter_ContextPath}third/pda/resource/script/address.js" type="text/javascript"></script>
<script src='${ KMSS_Parameter_ContextPath }sys/mobile/js/mui/device/device.js'></script>

<script type="text/javascript">
Com_IncludeFile("validator.jsp|validation.js|validation.jsp|xform.js|plugin.js", null, "js");
</script>
<!--border-style:none 去掉验证时分类多出来的||  -->
<style>
body{
	min-height:100%;
}
.validation-failed {
    border-color: #FF3300;
    border-style:none;
    border-width: 1px;
    color: #FF3300;
}
.txtstrong {
	color: #ff0000;
	font-size: 12px;
}

.notNull{
	padding-left:10px;
	border:solid #DFA387 1px;
	padding-top:8px;
	padding-bottom:8px;
	background:#FFF6D9;
	color:#C30409;
	margin-top:3px;
	font-size:12px;
}

.inputsgl_pda {
    border-color: #999999;
    border-style: solid;
    border-width: 0 0 1px;
    color: #0066FF;
    background:none;
}
.ui-body-c, .ui-overlay-c{
	text-shadow:none;
}
.div_attGroup>div a{
	font-weight:normal !important;
}

</style>
</head>
<body>
	<html:form action="/km/collaborate/km_collaborate_main/kmCollaborateMain.do">
		<c:if test="${KMSS_PDA_ISAPP!='1'}">
			<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
					<c:param name="fdNeedHome" value="true"/>
			</c:import>
		</c:if>
		<div data-role="page">
			<div data-role="content" style="padding: 0px;">
				<c:if test="${KMSS_PDA_ISAPP!='1'}">
					<br><br>
				</c:if>
				<table class="docView">
					<html:hidden property="fdId" />
					<html:hidden property="docStatus" />
					<input type="hidden" name="fdPdaType"/>
					<script type="text/javascript">
						var fdPdaType = device.getClientType();
						document.getElementsByName("fdPdaType")[0].value=fdPdaType;
					</script>
					<tr>
						<td class="td_title">
							<bean:message bundle="km-collaborate" key="kmCollaborateMain.docSubject"/>
						</td>
						<td class="td_common">
							<xform:text property="docSubject" style="width:80%" isLoadDataDict="true" htmlElementProperties="data-role='none'" />
						</td>
					</tr>
					<tr>
						<td class="td_title">
							<bean:message bundle="km-collaborate" key="kmCollaborateMain.highPriority"/>
						</td>
						<td class="td_common">
							<input type="hidden" name="fdIsPriority" <c:if test="${kmCollaborateMainForm.fdIsPriority !='true'}"> value="false" </c:if> <c:if test="${kmCollaborateMainForm.fdIsPriority=='true'}"> value="true" </c:if> />
							<c:if test="${kmCollaborateMainForm.fdIsPriority=='true'}">
								<input type="checkbox" name="fdIsPriorityBOX" id="checkbox-1a" checked="checked" class="custom" value="1" />
							</c:if>
							<c:if test="${kmCollaborateMainForm.fdIsPriority!='true'}">
								<input type="checkbox" name="fdIsPriorityBOX" id="checkbox-1a" class="custom" value="1" />
							</c:if>
							<label for="checkbox-1a" >
								<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdIsPriority"/>
							</label>
						</td>
					</tr>
					<tr>
						<td class="td_title">
							<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdCategory"/>
						</td>
						<td class="td_common">
							<select name="fdCategoryId" validate="required" 
							        subject="<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdCategory"/>"
							        data-role="none">
								<option value="" >
									<bean:message bundle="km-collaborate" key="kmCollaborateMain.pda.edit.selected"/>
								</option>
							</select>
							<span class="txtstrong">*</span>
						</td>
					</tr>
					
					<tr class="tr_extendTitle">
						<td class="td_title">
							<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdContent"/>
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" class="td_extend">
							<div id="doc_contentDiv">
								<div class="div_overflowArea">
									${kmCollaborateMainForm.fdContent}
								</div>
							</div>
							<textarea name="fdTempContent" rows="6" style="width:90%" data-role="none"></textarea>
							<input type="hidden" name = "fdContent">
						</td>
					</tr>
					<tr>
						<td class="td_title">
							<bean:message bundle="km-collaborate" key="kmCollaborateMain.participant"/>
						</td>
						<td class="td_common">
							<div class="noEdit">
								<input type="hidden" name="participantIds"
									   value="${kmCollaborateMainForm.participantIds}"
									   subject="<bean:message bundle="km-collaborate" key="kmCollaborateMain.participant"/>"> 
								<input type="hidden" name="participantNames"
									   value="${kmCollaborateMainForm.participantNames}" 
									   validate="required" subject="<bean:message bundle="km-collaborate" key="kmCollaborateMain.participant"/>">
								<input class="selectStyle" type="button" value="" data-role="none" onclick="Pda_Address('participantIds', 'participantNames', true, ';', ORG_TYPE_ALL);">
								<span class="txtstrong">*</span>
							</div>
						</td>
					</tr>
					<c:import url="/sys/attachment/pda/sysAttMain_view.jsp" charEncoding="UTF-8">
						<c:param name="fdKey" value="attachment" />
						<c:param name="formBeanName" value="kmCollaborateMainForm"/>   
						<c:param name="msgkey" value="${msgkey}"/>
						<c:param name="useTab" value="true"/>
					</c:import>
				</table>
				<center><u>    
	                <a href="#" onclick="showMore();" id="showMoreLink" ><img  src="../img/downarrow.png">&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.pda.more"/></a>
	                <a href="#" onclick="showLess();" id="showLessLink" ><img  src="../img/uparrow.png">&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.pda.less"/></a>
                </u></center>
                <div id = "showMore">
	                <table class="docView">
	                	<tr>
							<td class="td_title">
								<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdNotifyType" />
							</td>
							<td class="td_common" >
								<div class="noEdit" id="notifyType">
									<kmss:editNotifyType property="fdNotifyType" />
		                			<div class="notNull" id="fdNotifyType"><span class="validation-advice-img" valign="top">×</span>&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.choose.notifytype"/></div>
								</div>
							</td>
							
						</tr>
						<tr>
							<td class="td_title">
								<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdIsReminders"/>
							</td>
							<td class="td_common" >
								<div class="noEdit" >
									<xform:radio property="fdIsReminders" onValueChange="doReminderOp(this);" value="${kmCollaborateMainForm.fdIsReminders!=null ? kmCollaborateMainForm.fdIsReminders : 'false' }" >
										<xform:enumsDataSource enumsType="common_yesno" />
									</xform:radio>
						             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<span id="todoDays" class="txtstrong" <c:if test="${!kmCollaborateMainForm.fdIsReminders}">style="display:none"</c:if>>
										<input type="hidden" value="${fdRemindersDay}" name="fdRemindersDay_hidden" id="fdRemindersDay_hidden"/> 
										(<xform:text property="fdRemindersDay" style="width:20px" validators="digits" className="inputsgl_pda"/>
										<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdReceiveHint" />)
									</span>
								</div>
							</td>
							
						</tr>
						<tr>
							<td class="td_title">
								<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdPartnerOperating.pda"/>
							</td>
							<td class="td_common" >
								<input type="checkbox" value="true" <c:if test="${kmCollaborateMainForm.fdPartnerOperating eq 'true' }" >checked=""</c:if> name="fdPartnerOperatingBOX">
								<input type="hidden" <c:if test="${kmCollaborateMainForm.fdPartnerOperating eq 'true' }" >value="true" </c:if> <c:if test="${kmCollaborateMainForm.fdPartnerOperating != 'true' }" >value="false" </c:if> name="fdPartnerOperating" >
								<bean:message bundle="km-collaborate" key="kmCollaborateMain.allow.append.partnerInfo"/>
								<br>
								<input type="checkbox" value="true" <c:if test="${kmCollaborateMainForm.fdEditAtt eq 'true' }" >checked=""</c:if> name="fdEditAttBOX">
								<input type="hidden" <c:if test="${kmCollaborateMainForm.fdEditAtt eq 'true' }" >value="true" </c:if> <c:if test="${kmCollaborateMainForm.fdEditAtt != 'true' }" >value="false" </c:if> name="fdEditAtt" >
								<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdEditAtt"/>
							</td>
						</tr>
	                </table>
                </div>
				<div class="ui-grid-a">
					<div class="ui-block-a">
						<button type="button" data-theme="d" onclick="rebackList()">
								<bean:message bundle="km-collaborate" key="kmCollaborateMain.pda.cancel"/>
						</button>
					</div>
					<div class="ui-block-b " id="submitButton">
						<button type="button" data-theme="a" onclick="submitForm()" >
								<bean:message bundle="km-collaborate" key="kmCollaborateMain.pda.submit"/>
						</button>
					</div>
				</div>
			</div>
			<input type = "hidden" name="attachmentIds">
			<!-- /content -->
		</div>
		<!-- /page -->
	</html:form>
<script language="JavaScript">
		$KMSSValidation(document.forms['kmCollaborateMainForm']);
</script>
</body>

<script>
   function gotoUrl(url){ 
	  location=url;
   }
	/*编辑框去jqeruy mobile 增强效果*/
	$("input[type='checkbox']").attr("data-role","none");
	$("input[name='fdIsReminders']").attr("data-role","none");
	$("input[name='fdRemindersDay']").attr("data-role","none");
	$("input[name='fdPartnerOperatingBOX']").attr("data-role","none");
	$("input[name='fdEditAttBOX']").attr("data-role","none");
	/*参与者是否可转发判断*/
	$("input[name='fdPartnerOperatingBOX']").change(function(){
		$("input[name='fdPartnerOperating']").attr("value",$("input[name='fdPartnerOperatingBOX']").prop("checked"));
	});
	
	/*参与者是否可转发判断*/
	$("input[name='fdEditAttBOX']").change(function(){
		$("input[name='fdEditAtt']").attr("value",$("input[name='fdEditAttBOX']").prop("checked"));
	});
	/*判断优先级*/
	$("input[name='fdIsPriorityBOX']").change(function(){
		$("input[name='fdIsPriority']").attr("value",$("input[name='fdIsPriorityBOX']").prop("checked"));
	});
	$('#showMore').css("display","none");
	$('#showLessLink').css("display","none");
	/*显示更多*/
	function showMore(){
		$('#showMoreLink').attr("style","display:none;");
		$('#showLessLink').attr("style","display:block;");
		$('#showMore').attr("style","display:block;");
	}
	/*显示更少*/
	function showLess(){
		$('#showMore').css("display","none");
		$('#showMoreLink').css("display","block");
		$('#showLessLink').css("display","none");
	}
	/*催办天数事件*/
	function doReminderOp(el){
		var todoD = document.getElementById("todoDays");
		if(el.value=="true"){
			todoD.style.display = "inline";
		}else{
			var fdDay = document.getElementsByName("fdRemindersDay")[0];
			document.getElementsByName("fdRemindersDay")[0].value= document.getElementsByName("fdRemindersDay")[0].value=="" ? document.getElementsByName("fdRemindersDay_hidden")[0].value :document.getElementsByName("fdRemindersDay")[0].value;
			/* var advice = $KMSSValidation_GetAdvice(fdDay);
			if (advice) advice.style.display = "none"; */
			todoD.style.display = "none";
		}
	}
 	/* 生成label标签方法 */
	function _formatDisNames(ids, names, idStr, nameStr, splitStr, isEdit) {
		var namesArr = names.split(splitStr);
		var idArr = ids.split(splitStr);
		var htmlVar = "";
		for ( var i = 0; i < idArr.length; i++) {
			htmlVar += (htmlVar == "" ? "<div style='display:inline;'>" : "&nbsp;&nbsp;<div style='display:inline;'>");
			htmlVar	+= "<label ";
			htmlVar +=" class='_DisNameDiv'";
			if(isEdit != false)
				htmlVar +=	" onclick=\"_Delete_Address_dialog_data('"
					+ idStr + "','" + nameStr + "','" + idArr[i] + "','"+ namesArr[i] + "','" + splitStr + "');\"";
			htmlVar+= ">" ;
			htmlVar+= namesArr[i];
			if(isEdit != false)
				htmlVar += "<img src='" + Com_Parameter.ContextPath
					+ "third/pda/resource/images/ico_delpeople.png'/>";
			htmlVar +="</label></div>";
		}
		return htmlVar;
	}
	/**
	 * reback list页面
	 */
	function rebackList() {
		var url = '<c:url value="/km/collaborate/pda/index.jsp"/>';
		window.open(url, "_self");
	}
	
	//提交校验
	function submitForm(){
	   //参与者人数校验
	   var participantIds=document.getElementsByName("participantIds")[0];
	   var url="${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=checkIfMore&personIds="+participantIds.value; 
	   $.post(url,function(data){
	   	  if(data.indexOf("true")>-1){		    		 
	   		  alert("<bean:message key='kmCollaborate.jsp.morethan.comNum' bundle='km-collaborate' />");
	   		  return false;
	   	  } else{
	   		var method = '${kmCollaborateMainForm.method_GET}';
			//提交拼接内容
			document.getElementsByName("fdContent")[0].value = $(".div_overflowArea").html()+document.getElementsByName("fdTempContent")[0].value;
			if(method == 'add'){
				Com_Submit(document.forms[0],'save');
			}else if(method == 'edit'){
				Com_Submit(document.forms[0],'updateContent');
			}
	   	  }  	  		    		   		    	
	   });	
	}
	
	/*
	 * 加载分类数据源 
	 */
	var domContent;
	$(function(){
		var domOption = '';
		domContent = eval('${categorys}');
		if (domContent != null && domContent.length > 0) {
			for ( var i = 0; i < domContent.length; i++) {
				if (domContent[i].fdId == "${kmCollaborateMainForm.fdCategoryId}") {
					domOption += '<option value="'+domContent[i].fdId+'" selected="selected">'
							+ domContent[i].fdName + '</option>';
					index = i + 1;
				} else {
					domOption += '<option value="'+domContent[i].fdId+'">'
							+ domContent[i].fdName + '</option>';
				}
			}
		}
		var $myselect = $('select[name="fdCategoryId"]');
		$myselect.append(domOption);
		//$myselect.selectmenu("refresh");
		
		//通知方式必填校验相关信息初始化
		$("#fdNotifyType").hide();
		$("input[name^='__notify_type_']").click(function() {
			checkNotifyType();
		});
		
		//编辑事件某些字段无法修改控制
		var method = "${kmCollaborateMainForm.method_GET}";
		if(method == 'edit'){
			$(".noEdit").addClass("ui-disabled");
		}
		
		//初始化附件Ids
		initAttachmentIds();
	});
	//初始化 人员选择器
	Pda_init('participantIds', 'participantNames', ';', true);
	
	//初始化附件Ids
function initAttachmentIds(){
	var attachmentIds = "";
	<c:forEach var="sysAttMain" items="${kmCollaborateMainForm.attachmentForms['attachment'].attachments}" varStatus="vsStatus">
		attachmentIds+="${sysAttMain.fdId}"+";";
	</c:forEach>
	if(attachmentIds != "" && attachmentIds != null){
		document.getElementsByName("attachmentIds")[0].value = attachmentIds.substring(0, attachmentIds.length-1);
	}
}
</script>

<script>
Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function() {
	if(checkNotifyType()){
		//提交成功置灰提交按钮，避免重复提交
		$("#submitButton").addClass("ui-disabled");
		 return true ;
	}else{
		return false ;
	} 
}

// 通知方式校验
function checkNotifyType() {
	var fdNotifyType = document.getElementsByName("fdNotifyType")[0].value;
	if(null == fdNotifyType || fdNotifyType==""){
		$("#fdNotifyType").show();
		$("#notifyType input[type='checkbox']").focus();
		return false;
	}else{
		$("#fdNotifyType").hide();
		return true;
	}
}

//重写放开hidden类型校验
function Element_IsEnable() {
	if (this.element == null) return false;
	return !(this.element.disabled) ;//&& this.isVisible();
};

//校验失败样式调整
/*
function Reminder_Show() {
	var advice = this._getAdvice();
	if (advice) {
		// 避免重复设置
		if (advice.style.display != 'none') return;
		// 按照设置的样式更新提示信息
		if (/\{Msg\}/ig.test(this._msgStyle))
			this.msg = this._msgStyle.replace(/\{Msg\}/ig, this.msg);
		// 替换{name}为字段描述名
		var _subject = this.element.getAttribute('subject') || '';
		this.msg = this.msg.replace(/\{name\}/ig, _subject);
		// 替换相应参数
		var rep = new RegExp(), pValue, pType;
		for (var param in this._params) {
			pValue = this._params[param];
			// 类型不是对象或不是未定义，则匹配参数
			pType = typeof(pValue);
			if (pType != 'object' && pType != 'function' && pType != 'undefined') {
				rep.compile('\\{' + param + '\\}', 'ig');
				this.msg = this.msg.replace(rep, pValue);
			}
		}
		// 输出显示信息
		advice.innerHTML = this.options.layout.replace(/\{ShowMsg\}/ig, this.msg);
		// 显示style
		if (!advice.className || advice.className == '') advice.className = 'validation-advice';
		// 显示提示信息
		advice.style.display = '';
		// 字段设置为校验未通过的样式
		advice.setAttribute('ocn', this.element.className);
		var type = this.element.type.toLowerCase();
		if (type == 'checkbox' || type == 'radio') {
			var elems = document.getElementsByName(this.element.name);
			for (var i = elems.length - 1; i >= 0; i --) {
				//elems[i].className = 'validation-failed';
			}
		} else {
			//this.element.className = 'validation-failed';
		}
	}
};
*/

</script>
</html>