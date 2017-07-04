<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.third.pda.service.IPdaDataShowService"%>
<%@page import="com.landray.kmss.third.pda.util.PdaFlagUtil"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<%@page import="org.apache.commons.beanutils.PropertyUtils"%>
<c:catch var="catchException">
<%
	IPdaDataShowService showService=(IPdaDataShowService)SpringBeanUtil.getBean("pdaDataShowService");
	showService.setViewLabelInfo(request);
%>
<c:set var="s_mainForm" value="${requestScope[pda_formName]}" scope="request" />
<script type="text/javascript">
<% 
	Object obj = (Object)request.getAttribute("s_mainForm");
	if(PropertyUtils.isReadable(obj, "docStatus")){
%>
	<c:if test="${requestScope[pda_formName].docStatus< 30}">
		//加此代码，避免手机返回键操作后，仍然返回代码执行URL（action地址），继而导致界面报错
		//TODO 后续可以通过异步数据提交的方式，避免页面跳转结果界面的做法。
		var ___reloaded =  Com_GetUrlParameter(location.href,'_reload');
		if(___reloaded == '1'){
			location.replace(Com_SetUrlParameter(location.href,'_reload',null));
		}
	</c:if>
<%}%>	
	function expandDiv(id){
		var divObj = document.getElementById("label_"+id);
		var statusObj = document.getElementById("status_"+id);
		if(divObj!=null){
			var isExpand = divObj.getAttribute("isExpand");
			if(isExpand==null || isExpand=='1'){
				divObj.setAttribute("isExpand","0");
				divObj.style.display="none";
				statusObj.className="docLabelCell";
			}else{
				divObj.setAttribute("isExpand","1");
				divObj.style.display="";
				statusObj.className="docLabelExpand";
			}
		}
	}
	function memshineShow(memchineFlag){
		if(window.S_MechansmMap==null ||window.S_MechansmMap.isEmpty())
			return ;
		if( window.showMechansmInfo)
			window.showMechansmInfo(null,memchineFlag);
	}
	function refreshImg(eventType){
		var banner=document.getElementById("div_banner");
		var bannerWidth = null;
		if(banner!=null)
			bannerWidth=getObjectWidth(banner);
		else
			bannerWidth=getObjectWidth(document.body);

		if(parseInt(bannerWidth, 10)<=0) return;
		//精简、完整阅读等按钮的居中
		var extendDiv=document.getElementById("div_extendGroup");
		if(extendDiv!=null){
			var optBut = document.getElementById("div_OptButton");
			var oldDivArr = extendDiv.getElementsByTagName("div");
			var arrLength = oldDivArr.length;
			if(optBut != null){
				var divArr = optBut.getElementsByTagName("div");
				arrLength  = arrLength + divArr.length;
				var i = 0;
				var oldLen = divArr.length;
				while(divArr.length > 0){
					var tmpDomObj = divArr[i];
					if(tmpDomObj!=null){
						if(oldDivArr.length>0)
							extendDiv.insertBefore(tmpDomObj, oldDivArr[0]);
						else
							extendDiv.appendChild(tmpDomObj);
						//处理vpn情况下appendChild、insertBefore不会删除原Dom元素的情况.
						if(divArr.length == oldLen)
							i++;
					}else break;
				}
			}
			var extendWidth = arrLength * 90 ;
			extendDiv.style.width = extendWidth + "px";
			extendDiv.style.left = (bannerWidth-extendWidth)/2 + "px";
			
		}

		//图片预加载、溢出问题。。
		var contentObj= document.getElementById("doc_contentDiv");
		if(contentObj!=null) {
			var imgArr = contentObj.getElementsByTagName("img");
			if(imgArr!=null && imgArr.length>0){
				for(var i=0;i<imgArr.length;i++){
					var oldsrc=imgArr[i].getAttribute("oldsrc");
					if(oldsrc!=null){
						imgArr[i].style.maxWidth=""+(bannerWidth*0.80)+"px";
						imgArr[i].setAttribute("src",oldsrc);
						//避免移动端在预览图片时, 横屏竖屏切换在时候, 重复请求服务器,加载图片.
						if(eventType=='load'){
							Com_AddEventListener(imgArr[i],"load",function(){});
						}
					}else continue;
				}
			}
			
			//andriod2.3等版本下不支持scroll，故通过加事件来处理溢出滑动问题
			var clientInfo =  navigator.userAgent.toLowerCase().match(/android [\d.]+;/gi);
			if(clientInfo!=null){
				clientInfo = clientInfo.toString().replace(/[^0-9.]/ig,'');
				if(clientInfo==null)
					return;
				var ver = parseInt(clientInfo);
				if(ver < 3){//初定andriod3以下版本使用事件滑动
					var divArr = null;
					if(contentObj.querySelectorAll)
						divArr = contentObj.querySelectorAll(".div_overflowArea");
					else
						divArr = contentObj.getElementsByTagName("div");
					if(divArr!=null && divArr.length>0){
						for(var i =0; i<divArr.length; i++){
							var divObj = divArr[i];
							if(divObj.className=='div_overflowArea'){
								touchScroll(divObj);
							}
						}
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
		window.scrollStartPosX = -1;
		idObj.addEventListener("touchstart", function(event) {
			window.scrollStartPosX = this.scrollLeft + event.touches[0].pageX;
			event.stopPropagation();
		},false);

		idObj.addEventListener("touchmove", function(event) {
			if(window.scrollStartPosX != -1){
				var pos=(window.scrollStartPosX - event.touches[0].pageX);
				this.scrollLeft = pos;
			}
			event.stopPropagation();
		},false);
	}

	function refreshImgLoad(){
		refreshImg('load');
	}

	function refreshImgResize(){
		refreshImg('resize');
	}
	
	Com_AddEventListener(window,"load",refreshImgLoad);
	Com_AddEventListener(window,"resize",refreshImgResize);
</script>
<title>
<% 
	if(PropertyUtils.isReadable(obj, "docSubject")){
%>
<c:out value="${s_mainForm.docSubject}"></c:out>
<% } else if(PropertyUtils.isReadable(obj, "fdName")){%>
	<c:out value="${s_mainForm.fdName}"></c:out>
<% } %>
</title>
</head>
<body>
<c:if test="${KMSS_PDA_ISAPP!='1'}">
	<%-- 微信直接进入三级页面的情况--%>
	<c:set var="curModule" value="${sessionScope['S_CurModule']}"/>
	<c:if test="${param['_clear']=='1'}">
		<c:set var="curModule" value=""/>
	</c:if>
	<c:choose>
	<c:when test="${curModule!=null && curModule!=''}">
		<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
			<c:param name="fdNeedReturn" value="true"/>
			<c:param name="fdModuleName" value="${sessionScope['S_CurModuleName']}"/>
			<c:param name="fdModuleId" value="${sessionScope['S_CurModule']}"/>
		</c:import>
	</c:when>
	<c:otherwise>
		<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
			<c:param name="fdNeedReturn" value="true"/>
			<c:param name="fdModuleName" value="${pda_configView.fdModule.fdName}"/>
			<c:param name="fdModuleId" value="${pda_configView.fdModule.fdId}"/>
		</c:import>
	</c:otherwise>
	</c:choose>
</c:if>
<c:if test="${pda_configView!=null}">
	<c:if test="${not empty requestScope.pdaViewSubmitAction }">
		<script>Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js", null, "js");</script>
		<form action="<c:url value="${requestScope.pdaViewSubmitAction }" />" method="POST" autocomplete="off" target="">
		<html:hidden name="${pda_formName}" property="fdId" />
		<html:hidden name="${pda_formName}" property="method_GET" />
	</c:if>
	<center>
		<%--  精简阅读页面 --%>
		<c:if test="${pda_isDocView=='1'}">
		<div class="div_docModel">
			<div class="div_doctitle">${pda_docViewInfo["subject"]}</div>
			<hr class="hr_content"/>
			<div class="list_summary">${pda_docViewInfo["summary"]}</div>
			<%-- 文档内容(string/rtf/流程/表单/附件)--%>
			<div class="div_doctext" id="doc_contentDiv">
				<c:forEach var="content" items="${pda_docViewInfo['contents']}">
					<c:if test="${content!=null}">
						<c:choose>
							<c:when test="${content['dataType']=='attachment'}">
								<c:import url="/sys/attachment/pda/sysAttMain_view.jsp" charEncoding="UTF-8">
									<c:param name="fdKey" value="${content['value']}" />
									<c:param name="formBeanName" value="${pda_formName}"/>
									<c:param name="msgkey" value="${content['msgKey']}"/>
									<%-- 金格启用模式下 支持附件显示图片 begin--%>
								    <c:param name="formName" value="${pda_formName}"/>
				                    <c:param name="fdModelId" value="${fdModelId}"/>
				                    <%-- 金格启用模式下 支持附件显示图片 end--%>
								</c:import>
							</c:when>
							<c:when test="${content['dataType']=='flowdef'}">
								<c:if test="${not empty requestScope.pdaViewSubmitAction }">
								<c:set var="onClickSubmitButton" value="Com_Submit(document.forms[0]);" scope="page" />
								</c:if>
								<c:import url="/sys/workflow/include/sysWfProcess_pda.jsp"
									charEncoding="UTF-8">
									<c:param name="formName" value="${pda_formName}" />
									<c:param name="fdKey" value="${content['key']}" />
									<c:param name="onClickSubmitButton" value="${onClickSubmitButton }" />
								</c:import>
							</c:when>
							<c:when test="${content['dataType']=='xform'}">
								<c:import url="/sys/xform/include/sysForm_pda.jsp"
									charEncoding="UTF-8">
									<c:param name="formName" value="${pda_formName}"/>
									<c:param name="fdKey" value="${content['key']}" />
									<c:param name="useTab" value="false" />
								</c:import>
							</c:when>
							<c:otherwise>
								<div class="div_overflowArea">
							 		${content["value"]}
							 	</div>
							</c:otherwise>
						</c:choose>
						<br/>
					</c:if>
				</c:forEach>
				<%-- 相关附件显示 --%>
				<c:set var="msgKeyStr" value='<%=ResourceUtil.getString(request.getSession(),"third-pda","phone.view.attachment")%>'/>
				<c:forEach var="attachment" items="${pda_docViewInfo['attachments']}" varStatus="vs">
					<c:if test="${attachment!=null }">
						<c:if test="${vs.index==0}"><c:set var="msgKey" value="${msgKeyStr}"/></c:if>
						<c:import url="/sys/attachment/pda/sysAttMain_view.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="${attachment['value']}" />
								<c:param name="formBeanName" value="${pda_formName}"/>
								<c:param name="msgkey" value="${msgKey}"/>
						</c:import>
					</c:if>
				</c:forEach>
			</div>
			<hr class="hr_content"/>
			<%--点评,推荐,关联机制--%>
			<c:if test="${pda_docViewInfo['others']!=null }">
				<div class="div_Mechansm">
					<c:set var="otherSize" value="${fn:length(pda_docViewInfo['others'])}"/>
					<c:forEach var="otherObj" items="${pda_docViewInfo['others']}" varStatus="vsStatus">
						<c:choose>
							<c:when test="${otherObj['dataType']=='evaluation'}">
								<a name="href_mechansm" onclick="showMechansmInfo(this,'evaluation');">
									<bean:message key="phone.mechansm.evaluation" bundle="third-pda"/>
									${requestScope[pda_formName].evaluationForm.fdEvaluateCount}
								</a>
							</c:when>
							<c:when test="${otherObj['dataType']=='introduce'}">
								<a name="href_mechansm" onclick="showMechansmInfo(this,'introduce');">
								<bean:message key="phone.mechansm.introduce" bundle="third-pda"/>
								${requestScope[pda_formName].introduceForm.fdIntroduceCount}
								</a>
							</c:when>
							<c:when test="${otherObj['dataType']=='relation'}">
								<a name="href_mechansm" onclick="showMechansmInfo(this,'relation');">
								<bean:message key="phone.mechansm.relation" bundle="third-pda"/>
								</a>
							</c:when>
						</c:choose>
						<c:if test="${vsStatus.index >= 0 && (vsStatus.index+1)< otherSize}">|</c:if>
					</c:forEach>
					<c:forEach var="otherObj" items="${pda_docViewInfo['others']}">
						<c:choose>
							<c:when test="${otherObj['dataType']=='evaluation'}">
								<c:import url="/sys/evaluation/include/sysEvaluationMain_pda.jsp" charEncoding="UTF-8">
									<c:param name="formName" value="${pda_formName}"/>
								</c:import>
							</c:when>
							<c:when test="${otherObj['dataType']=='introduce'}">
								<c:import url="/sys/introduce/include/sysIntroduceMain_pda.jsp" charEncoding="UTF-8">
									<c:param name="formName" value="${pda_formName}"/>
								</c:import>
							</c:when>
							<c:when test="${otherObj['dataType']=='relation'}">	
								<c:import url="/sys/relation/include/sysRelationMain_pda.jsp" charEncoding="UTF-8">
									<c:param name="formName" value="${pda_formName}"/>
								</c:import>
							</c:when>
						</c:choose>
					</c:forEach>
				</div>
			</c:if>
			<%-- 切换文档阅读界面--%>
			<div class="div_extendGroup" id="div_extendGroup">
				<div class="div_more" onclick="location='<c:url value="${sessionScope.S_DocLink}"/>&isforce=0';">
					<bean:message key="phone.view.more" bundle="third-pda"/>
				</div>
			</div>
			<c:if test="${pda_extendJsp!=null &&pda_extendJsp!=''}">
					<c:import url="${pda_extendJsp}" charEncoding="UTF-8">
					<c:param name="formName" value="${pda_formName}"/>
					</c:import>
			</c:if>
		</div>
		</c:if>
		
		<%--完整阅读页面 --%>
		<c:if test="${pda_isDocView=='0'}">
			<%-- label部分 --%>
			<div class="div_detailModel">
				<c:set var="viewLabels" value="${pda_configView.fdItems}" />
				<%-- 文档内容(String/rtf/流程/表单/附件) --%>
				<div id="doc_contentDiv">
					<c:forEach var="filed"	items="${pda_filedList}" varStatus="vStatus" >
						<div class="docLabel" onclick="expandDiv('${viewLabels[vStatus.index].fdId}');">
							<div id="status_${viewLabels[vStatus.index].fdId}"  class="docLabelExpand"></div>
							${viewLabels[vStatus.index].fdName}
						</div>
						<div id="label_${viewLabels[vStatus.index].fdId}">
						<c:set var="var_lableInfo" value="${filed}"/>
						<c:set var="var_labelTypeString" value='<%=pageContext.getAttribute("var_lableInfo") instanceof String%>'/>
						<c:choose>
							<c:when test="${var_labelTypeString==true}">
								<c:import url="${var_lableInfo}">
									<c:param name="formName" value="${pda_formName}"/>
								</c:import>
							</c:when>
							<c:otherwise>
								<table class="docView">
									<c:forEach var="valMap" items="${var_lableInfo}">
										<c:choose>
											<%--RTF信息显示 --%>
											<c:when test="${valMap['dataType']=='rtf'}">
												<c:if test="${valMap['value']!=null && valMap['value']!=''}">
													<tr class="tr_extendTitle">
														<td class="td_title">
															${valMap["msgKey"]}
														</td>
														<td>
															&nbsp;
														</td>
													</tr>
													<tr>
														<td colspan="2" class="td_common">
															<div class="div_overflowArea">
																${valMap["value"]}
															</div>
														</td>
													</tr>
												</c:if>
											</c:when>
											<%--流程信息显示 --%>
											<c:when test="${valMap['dataType']=='flowdef'}">
												<tr>
													<td colspan="2" class="td_extend" id="doc_flowDiv">
														<c:if test="${not empty requestScope.pdaViewSubmitAction }">
														<c:set var="onClickSubmitButton" value="Com_Submit(document.forms[0]);" scope="page" />
														</c:if>
														<c:import url="/sys/workflow/include/sysWfProcess_pda.jsp"
															charEncoding="UTF-8">
															<c:param name="formName" value="${pda_formName}" />
															<c:param name="fdKey" value="${valMap['key']}" />
															<c:param name="showlog" value="false"/>
															<c:param name="onClickSubmitButton" value="${onClickSubmitButton }" />
														</c:import>
													</td>
												</tr>
											</c:when>
											<c:when test="${valMap['dataType']=='flowlog'}">
												<tr>
													<td colspan="2" class="td_extend" id="doc_flowDiv">
													<c:import url="/sys/workflow/include/sysWfProcess_pda_log.jsp"
														charEncoding="UTF-8">
														<c:param name="formName" value="${pda_formName}" />
														<c:param name="fdKey" value="${valMap['key']}" />
													</c:import>
													</td>
												</tr>
											</c:when>
											<%--自定义表单显示 --%>
											<c:when test="${valMap['dataType']=='xform'}">
												<tr>
													<td colspan="2" class="td_extend">
														<div class="div_overflowArea">
															<c:import url="/sys/xform/include/sysForm_pda.jsp"
																charEncoding="UTF-8">
																<c:param name="formName" value="${pda_formName}"/>
																<c:param name="fdKey" value="${valMap['key']}" />
																<c:param name="useTab" value="false" />
															</c:import>
														</div>
													</td>
												</tr>
											</c:when>
											<%--附件信息显示 --%>
											<c:when test="${valMap['dataType']=='attachment'}">
												<c:import url="/sys/attachment/pda/sysAttMain_view.jsp" charEncoding="UTF-8">
													<c:param name="fdKey" value="${valMap['value'] }" />
													<c:param name="formBeanName" value="${pda_formName}"/>
													<c:param name="msgkey" value="${valMap['msgKey']}"/>
													<c:param name="useTab" value="true"/>
													<%-- 金格启用模式下 支持附件显示图片 begin--%>
													<%-- 完整阅读无法区分 正文附件和其他附件 这里注释 统一采用word文档展示--%>
													<%--
													<c:param name="formName" value="${pda_formName}"/>
						                            <c:param name="fdModelId" value="${fdModelId}"/>
						                            --%>
						                            <%-- 金格启用模式下 支持附件显示图片 end--%>
												</c:import>
											</c:when>
											<%--附件图片缩略图 --%>
											<c:when test="${valMap['dataType']=='thumb'}">
												<c:import url="/sys/attachment/pda/sysAttMain_thumb_view.jsp" charEncoding="UTF-8">
													<c:param name="fdKey" value="${valMap['value'] }" />
													<c:param name="formBeanName" value="${pda_formName}"/>
													<c:param name="msgkey" value="${valMap['msgKey']}"/>
													<c:param name="useTab" value="true"/>
												</c:import>
											</c:when>
											<%--点评信息显示 --%>
											<c:when test="${valMap['dataType']=='evaluation'}">
												<c:import url="/sys/evaluation/include/sysEvaluationMain_pda.jsp" charEncoding="UTF-8">
													<c:param name="formName" value="${pda_formName}"/>
													<c:param name="showFold" value="true"/>
												</c:import>
												<script type="text/javascript">
													Com_AddEventListener(window,"load",function(){
														memshineShow('evaluation');
													});</script>
											</c:when>
											<%--推荐信息显示 --%>
											<c:when test="${valMap['dataType']=='introduce'}">
												<c:import url="/sys/introduce/include/sysIntroduceMain_pda.jsp" charEncoding="UTF-8">
													<c:param name="formName" value="${pda_formName}"/>
													<c:param name="showFold" value="true"/>
												</c:import>
												<script type="text/javascript">
													Com_AddEventListener(window,"load",function(){
														memshineShow('introduce');
													});</script>
											</c:when>
											<%--关联信息显示 --%>
											<c:when test="${valMap['dataType']=='relation'}">
												<c:import url="/sys/relation/include/sysRelationMain_pda.jsp" charEncoding="UTF-8">
													<c:param name="formName" value="${pda_formName}"/>
													<c:param name="showFold" value="true"/>
												</c:import>
												<script type="text/javascript">
													Com_AddEventListener(window,"load",function(){
														memshineShow('relation');
													});</script>
											</c:when>
											<%--自定义属性信息显示 --%>
											<c:when test="${valMap['dataType']=='property'}">
												<c:import url="/sys/property/include/sysProperty_pda.jsp" charEncoding="UTF-8">
													<c:param name="formName" value="${pda_formName}" />
													<c:param name="isPda" value="true" />
												 </c:import>
											</c:when>
											<%--子流程信息显示 --%>
											<c:when test="${valMap['dataType']=='subflow'}">
												<xform:isExistRelationProcesses relationType="parent">
												<tr>
													<td class="td_title">
														<bean:message bundle="third-pda" key="pdaModuleConfigView.subflow.sup" />
													</td>
													<td class="td_common"><xform:showParentProcesse /></td>
												</tr>
												</xform:isExistRelationProcesses>
												<xform:isExistRelationProcesses relationType="subs">
												<tr>
													<td class="td_title">
														<bean:message bundle="third-pda" key="pdaModuleConfigView.subflow.sub" />
													</td>
													<td class="td_common"><xform:showSubProcesses/></td>
												</tr>
												</xform:isExistRelationProcesses>
											</c:when>
											<%--普通字段信息显示 --%>
											<c:otherwise>
												<tr>
													<td class="td_title">${valMap["msgKey"]}</td>
													<td class="td_common">${valMap["value"]}</td>
												</tr>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</table>
							</c:otherwise>
						</c:choose>
						</div>
					</c:forEach>
				</div>
				<%-- 切换阅读界面--%>
				<br/>
				<div class="div_extendGroup" id="div_extendGroup">
					<c:if test="${param['isforce']=='0'}">
						<div class="div_more" onclick="location='<c:url value="${sessionScope.S_DocLink}"/>';">
							<bean:message key="phone.view.read" bundle="third-pda"/>
						</div>
					</c:if>
				</div>
				<c:if test="${pda_extendJsp!=null && pda_extendJsp!=''}">
					<c:import url="${pda_extendJsp}" charEncoding="UTF-8">
					<c:param name="formName" value="${pda_formName}"/>
					</c:import>
				</c:if>
			</div>
		</c:if>
	</center>
	<c:if test="${not empty requestScope.pdaViewSubmitAction }">
	</form>
	<script>
	$KMSSValidation(document.forms[0]);
	</script>
	</c:if>
</c:if>
</c:catch>
<c:if test = "${catchException != null}">
   <p>The exception is : ${catchException} <br />
   There is an exception: ${catchException.message}</p>
   <pre style="text-align: left;">
   <c:forEach items="${catchException.stackTrace}" var="line">
   	${line }
   </c:forEach></pre>
</c:if>
</body>
</html>