<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="com.landray.kmss.km.collaborate.forms.KmCollaborateMainForm"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ page import="com.landray.kmss.third.pda.service.IPdaDataShowService"%>
<%@ page import="com.landray.kmss.km.collaborate.model.KmCollaborateConfig" %> 
<%@ page import="com.landray.kmss.third.pda.model.PdaRowsPerPageConfig" %>
<%@ include file="/km/collaborate/pda/js/kmCollaborateMain_pda_public_js.jsp" %>
<%@ include file="/km/collaborate/pda/js/kmCollaborateMain_pda_view_js.jsp" %>
<link href="${KMSS_Parameter_ContextPath }km/collaborate/pda/js/kmCollaborateMain_pda_view.css" rel="stylesheet" type="text/css" />
<script src='${KMSS_Parameter_ContextPath }sys/mobile/js/mui/device/device.js'></script>
<title>${kmCollaborateMainForm.docSubject}</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<%
	//查看信息配置相关项
	IPdaDataShowService showService=(IPdaDataShowService)SpringBeanUtil.getBean("pdaDataShowService");
	showService.setViewLabelInfo(request);
	//默认回复语设置
	KmCollaborateConfig collConfig = new KmCollaborateConfig();
	String defaultReply = collConfig.getDefaultReply();
	request.setAttribute("defaultReply",defaultReply);
	//获取默认加载条数
	PdaRowsPerPageConfig rowConfig = new PdaRowsPerPageConfig();
	 	if (StringUtil.isNotNull(rowConfig.getFdRowsNumber()))
	 	{
			request.setAttribute("fdRowsNumber", rowConfig.getFdRowsNumber());
	 	}
	 	else
	 	{
			request.setAttribute("fdRowsNumber", "6");
	 	}
%>
<body>
<!-- Home -->
<div data-role="page" id="page1" >
	<div data-role="footer" id="footer" data-position="fixed" align="center" data-theme="a" data-tap-toggle="false" >
			<div data-role="controlgroup" data-type="horizontal" id="narBarId">
				<p><span id="loadMsg"></span></p>
				<c:if test="${kmCollaborateMainForm.docStatus!='40'}">
					<kmss:auth requestURL="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=saveReply&fdCommunicationMainId=${kmCollaborateMainForm.fdId}">
					    <script type="text/javascript" >
							$(document).ready( function (){
								$("#reply").removeClass();
								$("#reply").addClass("ui-btn ui-shadow ui-btn-corner-all ui-btn-inline ui-btn-up-b ui-first-child ");
	
								//回帖仅作者可见隐藏回复所有人按钮
								var fdIsOnlyView = "${kmCollaborateMainForm.fdIsOnlyView}";
								if(fdIsOnlyView == "true"){
									$("#replyAll").hide();
								}
							});
					   </script>
					</kmss:auth>
				</c:if>
				<a href="#" id="reply" data-theme="b"  class="ui-disabled"  data-role="button" data-inline="true"  onclick="openReplayText(1)" style="font-size: 12px;"><bean:message bundle="km-collaborate" key="kmCollaborateMain.docReplyCount"/></a>
				<a href="#" id="readd"  class="ui-disabled"  data-theme="b" data-role="button" data-inline="true" data-mini="true" onclick="reAdd()" style="font-size: 12px;"><bean:message bundle="km-collaborate" key="kmCollaborate.pda.readd"/></a>
				<a href="#" data-theme="b" id="cancleAttention" data-role="button" data-inline="true"  onclick="follow('cancleAttention')" style="font-size: 12px;"><!-- 取消关注 --><bean:message bundle="km-collaborate" key="kmCollaborate.jsp.calcelAtt"/></a>
				<a href="#" data-theme="b" class="ui-disabled" id="attention" data-role="button" data-inline="true"  onclick="follow('attention')" style="font-size: 12px;"><!-- 关注 --><bean:message bundle="km-collaborate" key="kmCollaborateMain.attention"/></a>
				<a href="#" data-theme="b" id="ending" class="ui-disabled" data-role="button" data-inline="true"  onclick="endIng()" style="font-size: 12px;"><!-- 结束 --><bean:message bundle="km-collaborate" key="kmCollaborate.pda.ending"/></a>
				<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=conclude&fdId=${kmCollaborateMainForm.fdId}" >
				<script type="text/javascript">
				$("#ending").attr("class","");
				</script>
				</kmss:auth>
				<c:if test="${kmCollaborateMainForm.docStatus=='40'}"> 
				<script type="text/javascript">
				$("#ending").attr("class","ui-disabled");
				</script>
				</c:if> 
				<a href="#" data-theme="b" data-role="button" data-inline="true"  onclick="window.open('../pda/index.jsp','_self')" style="font-size: 12px;"><!-- 返回 --><bean:message bundle="km-collaborate" key="kmCollaborate.pda.return"/></a>
			</div>
	</div>
	
	<!--可以阅读所有文档但不是创建者和参与者仍然没有权限关注  -->
	<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=mark&fdId=${kmCollaborateMainForm.fdId}">
				<script type="text/javascript" >
						$("#attention").attr("class","");
				</script>
	</kmss:auth>
	<div class="div_detailModel"  >
		<c:set var="viewLabels" value="${pda_configView.fdItems}" />
		<%-- 文档内容(String/rtf/表单/附件) --%>
		<div id="doc_contentDiv">
			<c:forEach var="filed"	items="${pda_filedList}" varStatus="vStatus" >
				<div style="overflow:hidden" class="ui-li ui-li-divider ui-bar-b ui-li-has-count ui-first-child" data-role="list-divider" onclick="expandDiv('${viewLabels[vStatus.index].fdId}');">
	 				<div style="float:left;sfont-family:Helvetica,​Arial,​sans-serif;font-weight:700;">${viewLabels[vStatus.index].fdName}</div>
	 				<div style="float:right;margin-right:-8mm;" class="ui-icon ui-icon-shadow ui-icon-minus" id="status_${viewLabels[vStatus.index].fdId}"></div>  
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
												<td>&nbsp;</td>
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
									<%--附件信息显示 --%>
									<c:when test="${valMap['dataType']=='attachment'}">
										<c:import url="/sys/attachment/pda/sysAttMain_view.jsp" charEncoding="UTF-8">
											<c:param name="fdKey" value="${valMap['value'] }" />
											<c:param name="formBeanName" value="${pda_formName}"/>
											<c:param name="msgkey" value="${valMap['msgKey']}"/>
											<c:param name="useTab" value="true"/>
										</c:import>
									</c:when>
									<%--附件图片缩略图  --%> <%-- 缩略图显示报错 --%>
									<c:when test="${valMap['dataType']=='thumb'}">
										
									</c:when>
									<%--普通字段信息显示 --%>
									<c:otherwise>
										<tr>
											<td class="td_title">${valMap["msgKey"]}</td>
											<td class="td_common">
											   <c:choose>
													<c:when test="${valMap['propertyName']=='participant'}">
													 ${participant}
													</c:when>
													<c:otherwise>
													 ${valMap["value"]}
													</c:otherwise>
												</c:choose>
											</td>
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
	</div>
	
    <div data-role="content">
         <html:form action="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do">
            <kmss:auth requestURL="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=saveReply&fdCommunicationMainId=${kmCollaborateMainForm.fdId}">
            <c:if test="${kmCollaborateMainForm.docStatus!='40'}">
	           <center>
	            <a href="javascript:openReplayText()" data-role="button" data-inline="true" data-direction="reverse"
	               data-transition="none" data-theme="e" data-icon="arrow-d"
	               data-iconpos="left" id="replyOne">
	               	 <bean:message bundle="km-collaborate" key="kmCollaborate.jsp.reply"/>
	            </a>
	            <a href="javascript:openReplayTextAll()" data-role="button"
	               data-inline="true" data-transition="slide" data-theme="e" data-icon="arrow-d" data-iconpos="left" id="replyAll">
	              	   <bean:message bundle="km-collaborate" key="kmCollaborate.jsp.replyAll"/>
	            </a>
	            </center>
            </c:if>
            <input type="hidden" id="defaultReply" value="${defaultReply}" />
            <!-- 回复 -->
            <div data-role="fieldcontain" id="replyText" >
                <div data-role="fieldcontain" >
	                <label for="fdContentMain">
	                   	 <bean:message bundle="km-collaborate" key="kmCollaborateMainReply.fdContent"/>:
	                </label>
               	 	<input type="hidden" id="hid" value="0" />
                	<textarea name="" id="fdContentMain" placeholder="<bean:message bundle='km-collaborate' key='kmCollaborateMainReply.fdContent'/>" >${defaultReply}</textarea>
                	<div class="notNull" id="repMsg"><span class="validation-advice-img" valign="top">×</span>&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborate.fdContent.notNull"/></div>
                	<div style="border-radius:6px;background: #fff7c6;line-height: 27px;border:1px #e8e8e8 solid;padding-left: 5px">
						<img src="../pda/images/tip_bulb.png" style="top:3px;position: relative;"/>
						<c:if test="${kmCollaborateMainForm.fdIsOnlyView!=true}">
						       <bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdIsOnlyView.tipsPublic" />
						</c:if> 
						<c:if test="${kmCollaborateMainForm.fdIsOnlyView==true}">
						       <bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdIsOnlyView.tipsSecre" />
						</c:if>
                	</div>
                	<br>
                 	<label class="ui-input-text" >
               		 	<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdNotifyType" />:
               		</label>
               		<div style="display:inline;font-size:16px">
                	<kmss:editNotifyType property="fdNotifyType" value="${kmCollaborateConfig.defaultNotifyType }" />
                    <div class="notNull" id="notifyType"><span class="validation-advice-img" valign="top">×</span>&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.choose.notifytype"/></div>
                     </div>
                      <p style="text-align: center">
		                  <a href="#" data-role="button" data-inline="true" data-direction="reverse"
		                     data-transition="none" onclick="submitF(1)">
		                       	<bean:message bundle="km-collaborate" key="kmCollaborateMain.pda.submit"/>
		                  </a>
                      </p>
                </div>
            </div>
            <!-- 回复全部 -->
            <div data-role="fieldcontain" id="replyTextAll" >
                <div data-role="fieldcontain" >
                <label for="fdContentMain">
                   	  <bean:message bundle="km-collaborate" key="kmCollaborateMain.pda.view.replyTextAll"/>:
                </label>
                <input type="hidden" id="hidAll" value="0" />
                <textarea name="" id="fdContentMainAll" placeholder="<bean:message bundle='km-collaborate' key='kmCollaborateMainReply.fdContent'/>" >${defaultReply}</textarea>
                <div class="notNull" id="repMsgAll"><span class="validation-advice-img" valign="top">×</span>&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborate.fdContent.notNull"/></div>
                
                <div style="border-radius:6px;background: #fff7c6;line-height: 27px;border:1px #e8e8e8 solid;padding-left: 5px">
						<img src="../pda/images/tip_bulb.png" style="top:3px;position: relative;"/>
						<c:if test="${kmCollaborateMainForm.fdIsOnlyView!=true}">
						       <bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdIsOnlyView.tipsPublic" />
						</c:if> 
                	</div>
                <br>
                <label class="ui-input-text" >
                <bean:message bundle="km-collaborate" key="kmCollaborateMain.fdNotifyType" />:
                </label>
                <div style="display:inline;font-size:16px">
                <kmss:editNotifyType property="fdNotifyType" value="${kmCollaborateConfig.defaultNotifyType }" />
      		    <div class="notNull" id="replyAllNotifyType"><span class="validation-advice-img" valign="top">×</span>&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.choose.notifytype"/></div>
      			</div>
                     <p style="text-align: center">
                   		<a href="#" data-role="button" data-inline="true" data-direction="reverse"
                     		   data-transition="none" onclick="submitF(2)">
                        	<bean:message bundle="km-collaborate" key="kmCollaborateMain.pda.submit"/>
                  		</a>
                     </p>
                </div>
            </div>
           </kmss:auth>
        </html:form>
    </div>
<iframe name="win" id="win" src="${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=replyList&mainId=${param.fdId}&pageno=1&rowsize=${fdRowsNumber}&sortType=asc&fdIsOnlyView=${kmCollaborateMainForm.fdIsOnlyView}&docCreatorId=${kmCollaborateMainForm.docCreatorId}&flag=pda" 
					width="100%"  frameborder=0 scrolling=no>
</iframe>          
</div>
</body>
</html>