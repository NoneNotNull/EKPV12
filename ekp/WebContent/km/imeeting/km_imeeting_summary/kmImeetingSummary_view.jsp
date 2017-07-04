<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<%-- 页签名--%>
	<template:replace name="title">
		<c:out value="${kmImeetingSummaryForm.fdName} - ${ lfn:message('km-imeeting:module.km.imeeting') }"></c:out>
	</template:replace>
	
	<%-- 按钮栏--%>
	<template:replace name="toolbar">
	  <ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="3">
		<%-- 编辑 --%> 
		<kmss:auth requestURL="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<c:if test="${kmImeetingSummaryForm.docStatus!='00'}">
			    <ui:button order="2" text="${ lfn:message('button.edit') }"  onclick="Com_OpenWindow('kmImeetingSummary.do?method=edit&fdId=${param.fdId}','_self');">
				</ui:button>
			</c:if>
		</kmss:auth> 
		<%-- 删除 --%> 
		<kmss:auth requestURL="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<ui:button order="4" text="${ lfn:message('button.delete') }"  onclick="docDel();">
			</ui:button>
		</kmss:auth> 
		<ui:button text="${ lfn:message('button.close') }" order="5" onclick="Com_CloseWindow();">
		</ui:button>
		</ui:toolbar>
	</template:replace>
	
	<%-- 路径导航 --%> 
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
				<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
				</ui:menu-item>
				<ui:menu-item text="${ lfn:message('km-imeeting:module.km.imeeting') }" href="/km/imeeting/" target="_self">
				</ui:menu-item>
				<ui:menu-item text="${ lfn:message('km-imeeting:table.kmImeetingSummary') }" href="/km/imeeting/km_imeeting_summary/index.jsp" target="_self">
				</ui:menu-item>
				<ui:menu-source autoFetch="false" 
						target="_self" 
						href="/km/imeeting/km_imeeting_summary/index.jsp?categoryId=${kmImeetingSummaryForm.fdTemplateId}">
					<ui:source type="AjaxJson">
						{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=path&modelName=com.landray.kmss.km.imeeting.model.KmImeetingTemplate&categoryId=${kmImeetingSummaryForm.fdTemplateId}"} 
					</ui:source>
				</ui:menu-source>
		</ui:menu>
	</template:replace>
	
	<template:replace name="content">
		<script>
			seajs.use(['lui/dialog','lui/jquery','km/imeeting/resource/js/dateUtil'],function(dialog,$,dateUtil){
				//删除
				window.docDel=function(){
					dialog.confirm("${lfn:message('page.comfirmDelete')}",function(flag){
				    	if(flag==true){
				    		Com_OpenWindow('kmImeetingSummary.do?method=delete&fdId=${param.fdId}','_self');
				    	}else{
				    		return false;
					    }
				    },"warn");
				};
				
				 //图片压缩函数
				window.doZipImage=function(){
					$('.lui_form_content_frame').find('img').each(function(){
						this.style.cssText="";
						var pt;
						if(this.height && this.height!="" && this.width && this.width != "")
							pt = parseInt(this.height)/parseInt(this.width);//高宽比
						if(this.width>700){
							this.width = 700;
							if(pt)
								this.height = 700 * pt;
						}
					});
				};
				
				//初始化会议历时
				if('${kmImeetingSummaryForm.fdHoldDuration}'){
					//将小时分解成时分
					var timeObj=dateUtil.splitTime({"ms":"${kmImeetingSummaryForm.fdHoldDuration}"});
					$('#fdHoldDurationHour').html(timeObj.hour);
					$('#fdHoldDurationMin').html(timeObj.minute);
					if(timeObj.minute){
						$('#fdHoldDurationMinSpan').show();
					}else{
						$('#fdHoldDurationMinSpan').hide();
					}
				}
				
			});
			function setFrameSize(){
				var frame = document.getElementById("IFrame_Content");
				if(frame){//金格控件
					// 金格控件中图片居中兼容
					var ___imgs = frame.contentWindow.document.getElementsByTagName('img');
					for(var j=0;j<___imgs.length;j++){
						___imgs[j].style.display='block';
						___imgs[j].style.margin='0 auto';
					}
					//获取所有a元素
					var elems = frame.contentWindow.document.getElementsByTagName("a");
					for(var i = 0;i<elems.length;i++){
						elems[i].setAttribute("target","_top");
					}
						var IFrame_Content = document.getElementById("IFrame_Content");
						var chs = IFrame_Content.contentWindow.document.body.childNodes;
						var bh = 0;
						for(var i=0;i<chs.length;i++){
							var tbh = chs[i].offsetTop + chs[i].offsetHeight;
							if(tbh > bh){
								bh = tbh;
							}
						}
						document.getElementById("contentDiv").style.height = bh+"px";
				 }else{//rtf输出文本
					 // xform输出默认设置最大宽度
					// doZipImage();
				 }
			};
		</script>
		<div class="lui_form_content_frame" style="padding-top:20px">
		<html:form action="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do" > 
			<p class="txttitle">
				<bean:message bundle="km-imeeting" key="table.kmImeetingSummary" />
			</p>
			<table class="tb_normal" width=100% id="Table_Main">
				<tr>
					<%-- 会议名称--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdName"/>
					</td>
					<td width="35%">
						<xform:text property="fdName" style="width:80%" />
					</td>
					<%-- 会议类型--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdTemplate"/>
					</td>
					<td width="35%">
						<c:out value="${kmImeetingSummaryForm.fdTemplateName}"></c:out>
					</td>
				</tr>
				<tr>
					<%-- 主持人--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdHost"/>
					</td>
					<td width="35%">
						<c:out value="${kmImeetingSummaryForm.fdHostName} ${kmImeetingSummaryForm.fdOtherHostPerson}"></c:out>
					</td>
					<%-- 会议地点--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdPlace"/>
					</td>
					<td width="35%">
						<c:out value="${kmImeetingSummaryForm.fdPlaceName} ${kmImeetingSummaryForm.fdOtherPlace}"></c:out>
					</td>
				</tr>
				<tr>
					<%-- 会议时间--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingMain.fdDate"/>
					</td>
					<td width="35%">
						<xform:datetime property="fdHoldDate" dateTimeType="datetime" style="width:36%" ></xform:datetime>~
						<xform:datetime property="fdFinishDate" dateTimeType="datetime" style="width:36%" ></xform:datetime>
					</td>
					<%--会议历时--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingMain.fdHoldDuration"/>
					</td>			
					<td width="35%" >
						<span id ="fdHoldDurationHour" ></span><bean:message key="date.interval.hour"/>
						<span id="fdHoldDurationMinSpan"><span id ="fdHoldDurationMin" ></span><bean:message key="date.interval.minute"/></span>
					</td>
				</tr>
				<tr>
					<%-- 计划参加人员--%>
					<td class="td_normal_title" width=15%>
				   		<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdPlanAttendPersons" />
					</td>
					<td width="85%"  colspan="3" style="word-break:break-all">
						<c:if test="${ not empty kmImeetingSummaryForm.fdPlanAttendPersonNames }">
							<div>
								<img src="${LUI_ContextPath}/km/imeeting/resource/images/inner_person.png" />
								<span style="vertical-align: top;">
									<bean:message bundle="km-imeeting" key="kmImeetingMain.fdInnerPerson"/>：<c:out value="${kmImeetingSummaryForm.fdPlanAttendPersonNames }"></c:out>
								</span>
							</div>
						</c:if>
						<%--外部计划参与人员--%>
						<c:if test="${ not empty kmImeetingSummaryForm.fdPlanOtherAttendPerson }">
							<div>
								<img src="${LUI_ContextPath}/km/imeeting/resource/images/other_person.png" />
								<span style="vertical-align: top;">
									<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>：<c:out value="${kmImeetingSummaryForm.fdPlanOtherAttendPerson }"></c:out>
								</span>
							</div>
						</c:if>
					</td>
				</tr>
				<tr>
					<%-- 计划列席人员--%>
					<td class="td_normal_title" width=15%>
				   		<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdPlanParticipantPersons" />
					</td>
					<td width="85%"  colspan="3" style="word-break:break-all">
						<c:if test="${ not empty kmImeetingSummaryForm.fdPlanParticipantPersonNames }">
							<div>
								<img src="${LUI_ContextPath}/km/imeeting/resource/images/inner_person.png" />
								<span style="vertical-align: top;">
									<bean:message bundle="km-imeeting" key="kmImeetingMain.fdInnerPerson"/>：<c:out value="${kmImeetingSummaryForm.fdPlanParticipantPersonNames }"></c:out>
								</span>
							</div>
						</c:if>
						<%--外部参加人员--%>
						<c:if test="${ not empty kmImeetingSummaryForm.fdPlanOtherParticipantPersons }">
							<div>
								<img src="${LUI_ContextPath}/km/imeeting/resource/images/other_person.png" />
								<span style="vertical-align: top;">
									<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>：<c:out value="${kmImeetingSummaryForm.fdPlanOtherParticipantPersons }"></c:out>
								</span>
							</div>
						</c:if>
					</td>
				</tr>
				<tr>
					<!-- 实际与会人员 -->
					<td class="td_normal_title" width=15%>
					   <bean:message bundle="km-imeeting" key="kmImeetingSummary.fdActualAttendPersons" />
					</td>
					<td width="85%"  colspan="3" style="word-break:break-all">
						<c:if test="${ not empty kmImeetingSummaryForm.fdActualAttendPersonNames }">
							<div>
								<img src="${LUI_ContextPath}/km/imeeting/resource/images/inner_person.png" />
								<span style="vertical-align: top;">
									<bean:message bundle="km-imeeting" key="kmImeetingMain.fdInnerPerson"/>：<c:out value="${kmImeetingSummaryForm.fdActualAttendPersonNames }"></c:out>
								</span>
							</div>
						</c:if>
						<%--外部与会人员--%>
						<c:if test="${ not empty kmImeetingSummaryForm.fdActualOtherAttendPersons }">
							<div>
								<img src="${LUI_ContextPath}/km/imeeting/resource/images/other_person.png" />
								<span style="vertical-align: top;">
									<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>：<c:out value="${kmImeetingSummaryForm.fdActualOtherAttendPersons }"></c:out>
								</span>
							</div>
						</c:if>
					</td>
				</tr>
				<tr>
					<%-- 抄送人员--%>
					<td class="td_normal_title" width=15%>
				   		<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdCopyToPersons" />
					</td>
					<td colspan="3">
						<xform:address propertyName="fdCopyToPersonNames" propertyId="fdCopyToPersonIds" style="width:92%;" textarea="true"></xform:address>
					</td>
				</tr>
				<tr>
					<%-- 编辑内容--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingSummary.docContent" />
					</td>
					<td width=85% colspan="3" id="contentDiv">
						<c:if test="${kmImeetingSummaryForm.fdContentType=='rtf'}">
							<xform:rtf property="docContent"></xform:rtf>
						</c:if>
						<c:if test="${kmImeetingSummaryForm.fdContentType=='word'}">
							<%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()){
								if (com.landray.kmss.sys.attachment.util.JgWebOffice.isExistFile(request)){%>
								<iframe onload="javascript:setFrameSize();" id="IFrame_Content" 
									src="<c:url value="/sys/attachment/sys_att_main/jg/sysAttMain_html_forward.jsp?fdId=${param.fdId}"/>" width=100% height=100% frameborder=0 scrolling=no>
								</iframe>
							<%  }
								else{%>
									${kmImeetingSummaryForm.fdHtmlContent}
								<% }
							  } else { %>
									${kmImeetingSummaryForm.fdHtmlContent}
							<%} %>
						</c:if>
					</td>
				</tr>
				<tr>
					<%--相关资料--%>
			 		<td class="td_normal_title" width=15%>
			 			<bean:message bundle="sys-attachment" key="table.sysAttMain"/>
			 		</td>
					<td width="85%" colspan="3" >
						<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
							<c:param name="formBeanName" value="KmImeetingSummaryForm" />
							<c:param name="fdKey" value="attachment" />
							<c:param name="fdModelId" value="${param.fdId }" />
							<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingSummary" />
						</c:import>
					</td>
				</tr>
				<tr>
			 		<%--会议组织人--%>
			 		<td class="td_normal_title" width=15%>
			 			<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdEmcee"/>
			 		</td>
			 		<td width="35%" >
			 			<c:out value="${kmImeetingSummaryForm.fdEmceeName}"></c:out>
					</td>
					<%--组织部门--%>
			 		<td class="td_normal_title" width=15%>
			 			<bean:message bundle="km-imeeting" key="kmImeetingSummary.docDept"/>
			 		</td>
			 		<td width="35%" >
			 			<c:out value="${kmImeetingSummaryForm.docDeptName}"></c:out>
					</td>
			 	</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdNotifyType" />
					</td>
					<td colspan="3">
							<kmss:editNotifyType property="fdNotifyType"/>
					</td>
				</tr>
				<tr>
					<%-- 纪要录入人--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingSummary.docCreator"/>
					</td>
					<td width="35%">
						<html:hidden property="docCreatorId"/><html:hidden property="docCreatorName"/>
						<c:out value="${kmImeetingSummaryForm.docCreatorName }"></c:out>
					</td>
					<%-- 录入时间--%>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-imeeting" key="kmImeetingSummary.docCreateTime"/>
					</td>
					<td width="35%">
						<html:hidden property="docCreateTime"/>
						<c:out value="${kmImeetingSummaryForm.docCreateTime }"></c:out>
					</td>
				</tr>
			</table>
			</html:form>
		</div>
		<ui:tabpage expand="false">
			<c:import url="/sys/bookmark/import/bookmark_bar.jsp" charEncoding="UTF-8">
				<c:param name="fdSubject" value="${kmImeetingSummaryForm.fdName}" />
				<c:param name="fdModelId" value="${kmImeetingSummaryForm.fdId}" />
				<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingSummary" />
			</c:import>
			
			<%-- 阅读纪录 --%>
			<c:import url="/sys/readlog/import/sysReadLog_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmImeetingSummaryForm" />
			</c:import>
			
			<%-- 传阅 --%>
			<c:import url="/sys/circulation/import/sysCirculationMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmImeetingSummaryForm" />
			</c:import>
			
			<%-- 权限--%>
			<c:import url="/sys/right/import/right_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmImeetingSummaryForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingSummary"/>
			</c:import>
			
			<c:import url="/sys/workflow/import/sysWfProcess_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmImeetingSummaryForm" />
				<c:param name="fdKey" value="ImeetingSummary" />
			</c:import>
			
			<c:if test="${kmImeetingSummaryForm.docStatus=='30'}">
				<kmss:ifModuleExist  path = "/sys/task/">
					<c:import url="/sys/task/import/sysTaskMain_view.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmImeetingSummaryForm" />
						<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingSummary" />
					</c:import>
				</kmss:ifModuleExist>
    		</c:if>
		
		</ui:tabpage>
		
	</template:replace>

</template:include>