<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<script type="text/javascript">
	Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js", null, "js");
	function refreshImg(){
		if(document.forms[0]){
			var reviewForm = document.forms[0];
			if('autocomplete' in reviewForm)
				reviewForm.autocomplete = "off";
			else
				reviewForm.setAttribute("autocomplete","off");
		}
		var banner=document.getElementById("div_banner");
		var bannerWidth = null;
		if(banner!=null)
			bannerWidth=getObjectWidth(banner);
		else
			bannerWidth=getObjectWidth(document.body);

		if(parseInt(bannerWidth, 10)<=0) return;
		
		var xform = document.getElementById("_xfromTd");
		var divArr = null;
		if(xform!=null){
			if(xform.querySelectorAll)
				divArr = xform.querySelectorAll(".div_overflowArea");
			else
				divArr = xform.getElementsByTagName("div");
			if(divArr!=null && divArr.length>0){
				for(var i=0;i<divArr.length;i++){
					var divObj = divArr[i];
					if(divObj.className=='div_overflowArea'){
							//divObj.style.maxWidth = ""+ bannerWidth+"px";
						touchScroll(divObj);
					}
				}
			}
		}
	}
	
	function getObjectWidth(obj){
		var clientWidth=obj.offsetWidth;
		if(clientWidth==null || clientWidth==0)
			clientWidth=obj.clientWidth?obj.clientWidth:clientWidth;
		return clientWidth;
	}
	
	function touchScroll(idObj){
		var scrollStartPosY=0;
		var scrollStartPosX=0;

		idObj.addEventListener("touchstart", function(event) {
			scrollStartPosY=this.scrollTop + event.touches[0].pageY;
			scrollStartPosX=this.scrollLeft + event.touches[0].pageX;
		},false);

		idObj.addEventListener("touchmove", function(event) {
			if ((this.scrollTop < this.scrollHeight-this.offsetHeight &&
				this.scrollTop+event.touches[0].pageY < scrollStartPosY-5) ||
				(this.scrollTop != 0 && this.scrollTop+event.touches[0].pageY > scrollStartPosY+5))
					event.preventDefault();	
			if ((this.scrollLeft < this.scrollWidth-this.offsetWidth &&
				this.scrollLeft+event.touches[0].pageX < scrollStartPosX-5) ||
				(this.scrollLeft != 0 && this.scrollLeft+event.touches[0].pageX > scrollStartPosX+5))
					event.preventDefault();	
			this.scrollTop=scrollStartPosY-event.touches[0].pageY;
			this.scrollLeft=scrollStartPosX-event.touches[0].pageX;
		},false);
	}

	function review_Validate(){
		return true;
	}
	function review_submit(){
		if(review_Validate()){
			var status = document.getElementsByName("docStatus")[0];
			var method = Com_GetUrlParameter(location.href,'method');
			if(method=='add'){
				Com_Submit(document.forms[0],'save');
			}else{
				if(status.value=='11'){
					Com_Submit(document.forms[0],'publishDraft');
				}else{
					Com_Submit(document.forms[0],'update');
				}
			}
		}
	}
	var lang_Calender={
			"month":"<bean:message key='phone.calnder.month' bundle='third-pda'/>",
			"week":"<bean:message key='phone.calnder.week' bundle='third-pda'/>",
			"simWeek":"<bean:message key='phone.calnder.simp.week' bundle='third-pda'/>"
		};
	Com_AddEventListener(window,"load",refreshImg);
	Com_AddEventListener(window,"resize",refreshImg);
</script>
<title>
		<c:if test="${kmReviewMainForm.method_GET=='add'}">
			<bean:message key='kmReviewMain.opt.create' bundle='km-review'/>
		</c:if>
		<c:if test="${kmReviewMainForm.method_GET!='edit'}">
			${kmReviewMainForm.docSubject}
		</c:if>
</title>
</head>
  <%
  	session.setAttribute("S_DocLink","");
  %>
<body>
	<html:form action="/km/review/km_review_main/kmReviewMain.do?method=save&isAppflag=${param['isAppflag']}" >
		<!-- banner -->
		<c:if test="${KMSS_PDA_ISAPP!='1'}">
			<c:choose>
			<c:when test="${sessionScope['S_CurModule']!=null}">
				<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
					<c:param name="fdNeedReturn" value="true"/>
					<c:param name="fdModuleName" value="${sessionScope['S_CurModuleName']}"/>
					<c:param name="fdModuleId" value="${sessionScope['S_CurModule']}"/>
				</c:import>
			</c:when>
			<c:otherwise>
				<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
						<c:param name="fdNeedHome" value="true"/>
				</c:import>
			</c:otherwise>
			</c:choose>
		</c:if>
	
		<!-- 新建内容 -->
		<div style="width:100%">
			<table class="docView">
				<html:hidden property="fdId" />
				<html:hidden property="fdModelId" />
				<html:hidden property="fdModelName" />
				<html:hidden property="docStatus" />
				<tr>
					<td class="td_title">
						<bean:message
							bundle="km-review" key="kmReviewMain.docSubject" />
					</td>
					<td class="td_common">
						<xform:text property="docSubject" style="width:80%" />
					</td>
				</tr>
				<tr>
					<td class="td_title">
						<bean:message bundle="km-review" key="kmReviewTemplate.fdName" />
					</td>
					<td class="td_common"><html:hidden property="fdTemplateId" /> 
						<bean:write	name="kmReviewMainForm" property="fdTemplateName" />
					</td>
				</tr>
				<tr class="tr_extendTitle">
					<td class="td_title">
							<bean:message bundle="km-review" key="kmReviewDocumentLableName.reviewContent" />
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<c:if test="${kmReviewMainForm.fdUseForm == 'false'}">
						<td colspan="2" class="td_extend">
						    <xform:textarea property="docContent" style="width:90%;height:80px" value="${kmReviewMainForm.docContent}"/>
						</td>
					</c:if>
					<c:if test="${kmReviewMainForm.fdUseForm == 'true' || empty kmReviewMainForm.fdUseForm}">
						<td colspan="2" id="_xfromTd" class="td_extend">
							<div class="div_overflowArea">
								<c:import url="/sys/xform/include/sysForm_pda.jsp"	charEncoding="UTF-8">
									<c:param name="formName" value="kmReviewMainForm" />
									<c:param name="fdKey" value="reviewMainDoc" />
								</c:import>
							</div>
						</td>
					</c:if>
				</tr>
				<tr>
					<td colspan="2" id="doc_flowDiv" class="td_extend">
						<c:import url="/sys/workflow/include/sysWfProcess_pda_edit.jsp"
									charEncoding="UTF-8">
							<c:param name="formName" value="kmReviewMainForm" />
							<c:param name="fdKey" value="reviewMainDoc" />
						</c:import>
					</td>
				</tr>
			<c:import url="/sys/right/right_edit4pda.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewMainForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.km.review.model.KmReviewMain" />
			</c:import>
			</table>
			<br/>
			<center>
				<input type="button" id="btn_submit" value="<bean:message key="button.submit"/>" class="btnopt" onclick="review_submit();"/>
			</center>
			<br/>
		</div>
	</html:form>
	<script language="JavaScript">
		$KMSSValidation(document.forms['kmReviewMainForm']);
	</script>
</body>
</html>