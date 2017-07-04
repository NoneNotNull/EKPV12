<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple" sidebar="no" >
	<template:replace name="body"> 
	<META HTTP-EQUIV="pragma" CONTENT="no-cache">
	<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<link type="text/css" rel="stylesheet" href="${LUI_ContextPath}/sys/ui/extend/theme/default/style/portal.css"/>
<link type="text/css" rel="stylesheet" href="${LUI_ContextPath}/sys/notify/resource/css/notify.css?v=1.7"/>
<script src="${KMSS_Parameter_ResPath}js/domain.js"></script>
<script type="text/javascript">
Com_IncludeFile("jquery.js");
</script>

<c:set var="totalrows" value="${queryPage.totalrows}" />
<c:if test="${param.isShowBtLable!=0}">
	<div id='buttonDiv'>
		<nobr>
			<%-- “待审”和“暂挂” --%>
			<input type="button" value='<bean:message bundle="sys-notify" key="sysNotifyTodo.type.toDo" />(${toDoCount})'
				class='<c:choose><c:when test="${param.fdType == 1 || empty param.fdType && empty param.finish}">labelbg1</c:when><c:otherwise>labelbg2</c:otherwise></c:choose>'
				onclick='window.open("<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=list&home=1&rowsize=10&forKK=${param.forKK}" />","_self");'>
			<input type="button" id="notifyBtn2" value='<bean:message bundle="sys-notify" key="sysNotifyTodo.type.toView" />(${toViewCount})'
				class='<c:if test="${param.fdType == 2}">labelbg1</c:if><c:if test="${param.fdType != 2}">labelbg2</c:if>'
				onclick='window.open("<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=list&fdType=2&rowsize=10&home=1&forKK=${param.forKK}" />","_self");'>
			<c:if test='${empty param.forKK }'>
			<input type="button" value='<bean:message bundle="sys-notify" key="sysNotifyTodo.type.done" />'
				class='<c:if test="${param.finish == 1}">labelbg1</c:if><c:if test="${param.finish != 1}">labelbg2</c:if>'
				onclick='window.open("<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=list&finish=1&rowsize=10&home=1" />","_self");'>
			</c:if>
		</nobr>
	<div style='font-size:8px'>&nbsp;</div>
	</div>
</c:if>
	<div class="lui_dataview_classic" >
			<!-- 如果是被KK集成，则显示最后登录时间和IP 苏轶 2010年6月28日 -->
			<c:if test="${param.forKK == 'true' }">
				<div class="lui_dataview_classic_row clearfloat">
					<div class="lui_dataview_classic_textArea clearfloat">
						<bean:message bundle="sys-notify" key="sysNotifyTodo.last.login.time" />
						<span style='color:#ff3300'>
							<kmss:showDate value="${lastLoginInfo.fdCreateTime }" type="datetime"></kmss:showDate>
						</span>
						<br>
						<bean:message bundle="sys-notify" key="sysNotifyTodo.last.login.IP" />
						<span style='color:#ff3300'>
							${lastLoginInfo.fdIp }
						</span>
					</div>
				</div>
			</c:if>
			<!-- 如果是被KK集成，则显示最后登录时间和IP 苏轶 2010年6月28日 END -->
			<!-- 如果没有查到数据则提示没有代办，提示文字区分代审和待阅。 苏轶 2010年7月30日-->
	
			<!-- 如果没有查到数据则提示没有代办，提示文字区分代审和待阅。 苏轶 2010年7月30日 END-->
			<!-- 待办或邮件提示 -->
			<c:if test="${portletType!='category' }">
				<div class="lui_dataview_classic_row clearfloat" style="padding-left:8px;background:#fefbe8;line-height: 35px;font-weight:normal;color:#333;">
				<span id="lui_notify_todo_tip" class="lui_dataview_classic_icon" style=""></span>
				<div class="lui_dataview_classic_textArea clearfloat" style="padding-left: 44px;font-size:14px;">
	
					<span style="" class="lui_dataview_classic_link">
							<c:if test="${totalrows==0}">
								<bean:message bundle="sys-notify" key="sysNotifyTodo.home.you" />
								<b style="color:#FF6600"><bean:message bundle="sys-notify" key="sysNotifyTodo.home.notHave" /></b>
							</c:if>
							<c:if test="${totalrows>0}">
								<bean:message bundle="sys-notify" key="sysNotifyTodo.home.youHave" />
								<b style="font-size:16px;color:#FF6600">${totalrows}</b> <bean:message bundle="sys-notify" key="sysNotifyTodo.home.count" />
							</c:if>
						
						<a href="${LUI_ContextPath }/sys/notify?dataType=${dataType}<c:choose>
							<c:when test="${dataType=='todo' }">#cri.status1.q=fdType:13</c:when>
							<c:when test="${dataType=='toview' }">#cri.status1.q=fdType:2</c:when>
							<c:when test="${param.dataType=='tododone' }">#cri.status2.q=fdType:13</c:when>
							<c:when test="${param.dataType=='toviewdone' }">#cri.status2.q=fdType:2</c:when>
							</c:choose>" target="_blank" style="text-decoration: underline;font-size:14px;">
							<c:choose>
							<c:when test="${portletType=='graphic'}">
								<% 
									java.util.List dataTypeList = (java.util.List)request.getAttribute("dataTypeList");
									String infoTip = "sysNotifyTodo.todo.notify";
									if(dataTypeList.contains("todo") && !dataTypeList.contains("toview")){
										infoTip = "sysNotifyTodo.toDo.info";
									}else if(!dataTypeList.contains("todo") && dataTypeList.contains("toview")){
										infoTip = "sysNotifyTodo.toView.info";
									}else if(!dataTypeList.contains("tododone") && dataTypeList.contains("toviewdone")){
										infoTip = "sysNotifyTodo.done.toViewDone";
									}else if(dataTypeList.contains("done") || dataTypeList.contains("tododone")){
										infoTip = "sysNotifyTodo.done.label.2";
									}
								%>
								<bean:message bundle="sys-notify" key="<%=infoTip %>" />
							</c:when>
							<c:otherwise>
								<c:if test="${param.fdType == 1 || empty param.fdType && empty param.finish}">
									<bean:message bundle="sys-notify" key="sysNotifyTodo.toDo.info" />
								</c:if>
								<c:if test="${param.fdType == 2}">
									<bean:message bundle="sys-notify" key="sysNotifyTodo.toView.info" />
								</c:if>
								<c:if test="${param.fdType == 3}">
									<bean:message bundle="sys-notify" key="sysNotifyTodo.suspend.info" />
								</c:if>
								<c:if test="${param.finish == 1}">
									<c:if test="${param.dataType=='toviewdone' }">
										<bean:message bundle="sys-notify" key="sysNotifyTodo.done.toViewDone" />
									</c:if>
									<c:if test="${param.dataType!='toviewdone' }">
										<bean:message bundle="sys-notify" key="sysNotifyTodo.done.label.2" />
									</c:if>
								</c:if>
							</c:otherwise>
						</c:choose>
						</a>
					</span>
					<!-- 显示 邮件数量 -->
					<c:if test="${!empty importMailNumJsp}">
						<span id="lui_notify_todo_line" class="lui_dataview_classic_link"></span>
						<span class="lui_dataview_classic_link lui_notify_email_link">
							<c:import url="/sys/notify/sys_notify_todo/sysMail_home_mid.jsp" charEncoding="UTF-8"/>
						 </span>
					</c:if>
				</div>
				
			</div>
			</c:if>
	
			<!-- 待办显示类型:列表、图文、分类 -->
			<c:choose>
				<c:when test="${portletType=='graphic' }">
					<c:forEach var="model" items="${queryPage.list}">
					 	<div class="lui_notify_graphic">
							<div class="lui_notify_graphic_person">
								<c:set var="doc_creator_id" value="<%=new java.util.Date().getTime() %>"></c:set>
								<c:set var="personImgSrc" value="${KMSS_Parameter_ContextPath}sys/notify/resource/images/gear.png"></c:set>
								<c:if test="${not empty model.docCreator.fdId}">
									<c:set var="doc_creator_id" value="${model.docCreator.fdId}"></c:set>
									<c:set var="personImgSrc" value="${KMSS_Parameter_ContextPath}sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${doc_creator_id}&t=<%=new java.util.Date().getTime() %>"></c:set>
								</c:if>
								<img style="border: 1px solid #e2e2e2;height: 40px;width: 40px;" src="${ personImgSrc}"/>
							 </div>
				           <div id="lui_notify_title" style="padding-top: 2px;padding-left:50px;">
					                <a target="_blank" class="lui_notify_graphic_todo_title" 
					                	<c:if test="${dataType=='done' && not empty model.fdLink}">
					                		href="<c:url value="${model.fdLink}" />"
					                	</c:if>
					                	<c:if test="${dataType!='done'}">
					                		onclick="onNotifyClick(this,'${model.fdType}')"
					                		<c:if test="${not empty model.fdLink}"> 
												href="<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=view&fdId=${model.fdId}" />"
											</c:if>
					                	</c:if>
										>
					               		<c:if test="${model.fdLevel==1&&model.fdType!=3}"><span class="lui_notify_level">${lfn:message('sys-notify:sysNotifyTodo.level.title.1')}</span></c:if>
									    <c:if test="${model.fdLevel==2&&model.fdType!=3}"><span class="lui_notify_level">${lfn:message('sys-notify:sysNotifyTodo.level.title.2')}</span></c:if>
									    <c:if test="${model.fdType==3}"><span class="lui_notify_pending"></span></c:if>
									    <c:out value="${model.subject4View}"/> 
					                 </a>
				               
				               <div class="lui_notify_graphic_todo_subhead">
				               	 <c:if test="${not empty model.docCreator.fdName}">
				               		<span>${model.docCreator.fdName}</span>
				               	 </c:if>
				               	 <span> <kmss:showDate value="${model.fdCreateTime}" type="datetime"></kmss:showDate></span>
				                 <span> ${lfn:message('sys-notify:sysNotifyTodo.moduleName')}：${model.modelNameText }</span>
				                 
			                 	<c:forEach var="map" items="${model.extendContents }">
			                 		<c:if test="${map['key']=='lbpmCurrNode' }">
			                 			<span> ${map['titleMsgKey']}：${map['titleMsgValue'] }</span>
			                 		</c:if>
			                 		<c:if test="${map['key']=='docFinishedTime' }">
				                 			<span> ${lfn:message('sys-notify:sysNotifyTodo.kmPindagateMain.docEndTime')}：${map['titleMsgValue'] }</span>
				                 	</c:if>
			                 	</c:forEach>
				               </div>
				           </div>
				        <div style="clear: both;"></div>
					 	</div>
					 	
					</c:forEach>
			
				</c:when>
				
				<c:when test="${portletType=='category'}">
					<c:if test="${cateListTotal==0 }">
						<bean:message bundle="sys-notify" key="sysNotifyTodo.cate.noRecord" />
					</c:if>
					<c:if test="${cateListTotal>0 }">
						<c:choose>
						<c:when test="${displayMode=='widthData'}">
							<ui:tabpanel layout="sys.ui.tabpanel.light" style="" id="catetab" scroll="false" >
								<c:forEach var="cate" items="${cateList}">
									<ui:content title="${cate.fdName} <span id='cateCount_${cate.fdId }' style='color:red;'>${cate.cateCount}</span> ${lfn:message('sys-notify:sysNotifyTodo.cate.number')}">
										<ui:ajaxtext>
										<ui:dataview>
											<ui:source type="AjaxJson">
												{"url":"/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=listDatasByCate&home=${param.home}&finish=${param.finish}&rowsize=${param.rowsize}&cateFdId=${cate.fdId}&dataType=${param.dataType}&LUIID=${param.LUIID}&sortType=${param.sortType}&displayMode=${param.displayMode}"}
											</ui:source>
											<ui:render type="Template">
												{$ <div class="lui_dataview_classic"> $}
													var dataType = "${param.dataType}";
													if(data.length==0){
														{$
															<div class="lui_dataview_classic_row clearfloat">
				 												<div class="clearfloat">
																	<bean:message bundle="sys-notify" key="sysNotifyTodo.home.you" />&nbsp;<font style="color:#FF6600;"><b>
																		<bean:message bundle="sys-notify" key="sysNotifyTodo.home.notHave" /></b></font>&nbsp;
														$}
														if(dataType=="todo"){
															{$<bean:message bundle="sys-notify" key="sysNotifyTodo.toDo.info" />$}
														}else if(dataType=="toview"){
															{$<bean:message bundle="sys-notify" key="sysNotifyTodo.toView.info" />$}
														}else if(dataType=="tododone" || dataType=='done' || dataType=='tododone;toviewdone'){
															{$<bean:message bundle="sys-notify" key="sysNotifyTodo.done.label.2" />$}
														}else if(dataType=="toviewdone"){
															{$<bean:message bundle="sys-notify" key="sysNotifyTodo.done.toViewDone" />$}
														}else{
															{$<bean:message bundle="sys-notify" key="sysNotifyTodo.todo.notify" />$}
														}
														{$
																</div>
															</div>
														$}
													}
													
													for(var i = 0;i<data.length;i++){
														{$	
															<div class="lui_dataview_classic_row clearfloat">
																<span class="lui_notify_title_icon lui_notify_content_{%data[i].fdType%}"></span>
				 												<div class="lui_dataview_classic_textArea clearfloat">
														$}
															if(dataType=='done'){
																{$ <a class="lui_dataview_classic_link" target="_blank" $}
																if(data[i].fdLink){
																	{$ href="${LUI_ContextPath}<c:url value='{%data[i].fdLink%}'/>" $}
																}
																{$ > $}
															}else{
																{$ <a class="lui_dataview_classic_link" target="_blank" href="${LUI_ContextPath}/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=view&fdId={%data[i].fdId%}" onclick="onNotifyClick(this,'{%data[i].fdType%}');onNotifyCountClick('${cate.fdId }','{%data[i].fdType%}')"> $}
															}
															
															
															  if(data[i].fdLevel==1 && data[i].fdType!=3){
															  	{$<span class="lui_notify_level">${lfn:message('sys-notify:sysNotifyTodo.level.title.1')}</span>$}
															  }
															  if(data[i].fdLevel==2 && data[i].fdType!=3){
															  	{$<span class="lui_notify_level">${lfn:message('sys-notify:sysNotifyTodo.level.title.2')}</span>$}
															  }
															  if(data[i].fdType==3){
															  	{$<span class="lui_notify_pending"></span>$}
															  }
															{$	{%data[i].subject4View%}
														 			</a>
														 		</div>
														 	</div>
														$}
													}
												{$
													</div>
												
												$}
											</ui:render>
										</ui:dataview>
										</ui:ajaxtext>
									</ui:content>
								</c:forEach>
							</ui:tabpanel>
						</c:when>
						
						<c:otherwise>
							<div style="padding:10px;">
							<ul class="lui_toolbar_db_list">
								<c:forEach var="cate" items="${cateList}">
									<li><span><a target="_blank" href="${LUI_ContextPath}/sys/notify?dataType=${param.dataType }<c:choose>
										<c:when test="${param.dataType=='done'}">&fdCateId=${cate.fdId}</c:when>
										<c:when test="${param.dataType=='todo'}">&fdCateId=${cate.fdId}#cri.status1.q=fdType:13</c:when>
										<c:when test="${param.dataType=='toview'}">&fdCateId=${cate.fdId}#cri.status1.q=fdType:2</c:when>
										<c:when test="${param.dataType=='tododone'}">&fdCateId=${cate.fdId}#cri.status2.q=fdType:13</c:when>
										<c:when test="${param.dataType=='toviewdone'}">&fdCateId=${cate.fdId}#cri.status2.q=fdType:2</c:when>
										<c:when test="${param.dataType=='tododone;toviewdone'}">&fdCateId=${cate.fdId}#cri.status2.q=fdType:2</c:when>
										<c:otherwise>&fdCateId=${cate.fdId}</c:otherwise>
										</c:choose>
									" ><em>${cate.cateCount}</em>${cate.fdName}</a></span></li>
									       
								</c:forEach>
							</ul>
							<div style="clear: both;"></div>
							</div>
						</c:otherwise>
					  </c:choose>
					</c:if>
					
					
				</c:when>
				<c:otherwise>
					<c:forEach var="model" items="${queryPage.list}">
						<div class="lui_dataview_classic_row clearfloat lui_notify_todo">
							<span class="lui_notify_title_icon lui_notify_content_<c:choose><c:when test="${param.finish == 1 }">${model.todo.fdType}</c:when><c:otherwise>${model.fdType}</c:otherwise></c:choose>"></span>
				 			<div class="lui_dataview_classic_textArea clearfloat">
							<c:choose>
								<c:when test="${param.finish == 1}">
									<span id="lui_notify_title">
										<a class="lui_dataview_classic_link" target="_blank"<c:if test="${not empty model.todo.fdLink}"> href="<c:url value="${model.todo.fdLink}"/>"</c:if>>
											<c:if test="${showAppHome==1}">
												<c:set var="appName" value="${model.todo.fdAppName}"/>
												<c:if test="${appName!=null && appName!='' }">
													<bean:message bundle="sys-notify" key="sysNotifyTodo.todo.appTitle.left" /><c:out value="${appName}"/><bean:message bundle="sys-notify" key="sysNotifyTodo.todo.appTitle.right" />
												</c:if>
											</c:if>
											<c:if test="${model.todo.fdLevel==1&&model.todo.fdType!=3}"><span class="lui_notify_level">${lfn:message('sys-notify:sysNotifyTodo.level.title.1')}</span></c:if>
											<c:if test="${model.todo.fdLevel==2&&model.todo.fdType!=3}"><span class="lui_notify_level">${lfn:message('sys-notify:sysNotifyTodo.level.title.2')}</span></c:if>
											<c:if test="${model.todo.fdType==3}"><span class="lui_notify_pending"></span></c:if>
											<c:out value="${model.todo.subject4View}"/> 
									 	</a>
								 	</span>
								</c:when>
								<c:otherwise>
									<a class="lui_dataview_classic_link" target="_blank" onclick="onNotifyClick(this,'${param.fdType}')"
										<c:if test="${not empty model.fdLink}"> href="<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=view&fdId=${model.fdId}" />"</c:if>>
										<c:if test="${showAppHome==1}">
											<c:set var="appName" value="${model.fdAppName}"/>
											<c:if test="${appName!=null && appName!='' }">
												<bean:message bundle="sys-notify" key="sysNotifyTodo.todo.appTitle.left" /><c:out value="${appName}"/><bean:message bundle="sys-notify" key="sysNotifyTodo.todo.appTitle.right" />
											</c:if>
										</c:if>
										<c:if test="${model.fdLevel==1&&model.fdType!=3}"><span class="lui_notify_level">${lfn:message('sys-notify:sysNotifyTodo.level.title.1')}</span></c:if>
										<c:if test="${model.fdLevel==2&&model.fdType!=3}"><span class="lui_notify_level">${lfn:message('sys-notify:sysNotifyTodo.level.title.2')}</span></c:if>
										<c:if test="${model.fdType==3}"><span class="lui_notify_pending"></span></c:if>
										<c:out value="${model.subject4View}"/> 
								 	</a>
								</c:otherwise>
							</c:choose>
							</div>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>

	</div>
	<script type="text/javascript">
	domain.autoResize();
	</script>

<script language='javascript'>
	function onNotifyClick(hrefObj,notifyType){
		//待阅点击后及时消失
		if(notifyType=='2'){
			//当前行顶级节点
			var p = $(hrefObj)[0].parentNode.parentNode;
			p.style.display="none";
			var countObj=document.getElementById("notifyCount2");
			var btnObj=document.getElementById("notifyBtn2");
			if(countObj!=null){
				if(!isNaN(countObj.innerText)){
					var countInt=parseInt(countObj.innerText,10);
					if(countInt>0)
						$(countObj).text(countInt-1);
				}
			}
			if(btnObj!=null){
				var oldBtnVal=btnObj.value;
				if(oldBtnVal.indexOf("(")>-1){
					var labelName=oldBtnVal.substring(0,oldBtnVal.indexOf("("));
					var countVar=oldBtnVal.substring(oldBtnVal.indexOf("(")+1,oldBtnVal.length-1);
					if(!isNaN(countVar)){
						var count=parseInt(countVar,10);
						if(count>0){
							btnObj.value=labelName+"("+(count-1)+")";
						}
					}
				}
			}	
		}	
	}
	//分类数量
	function onNotifyCountClick(cateId,notifyType){
		//待阅点击后及时消失
		if(notifyType=='2'){
			var $cateCount = $('#cateCount_' + cateId);
			var newCateCount = parseInt($cateCount.html())-1;
			newCateCount = newCateCount >=0 ? newCateCount:0;
			$cateCount.html(newCateCount);
		}
	}
	seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic) {
		//审批等操作完成后，自动刷新列表
		topic.subscribe('successReloadPage', function() {
			location.reload();
		});
		//css调整
		var contentLuiId = "${LUI_ID}";
		var content = parent.LUI(contentLuiId).parent;
		var id = content.id;
		$('#' + id,parent.document).css('padding','0px 0px 8px 0px');
		
		var p = content.contentInside;
		p.css('padding','0px');
	})
	
</script>
</template:replace>
</template:include>