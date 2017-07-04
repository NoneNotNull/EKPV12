<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="auto">
	<template:replace name="title">
		<c:out value="${sysNewsMainForm.docSubject} - ${ lfn:message('sys-news:news.moduleName') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="3">
			<c:if test="${sysNewsMainForm.docStatus!='00' }">
				<kmss:auth
					requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=edit&fdId=${param.fdId}"
					requestMethod="GET">
					<ui:button text="${lfn:message('button.edit')}" 
						onclick="Com_OpenWindow('sysNewsMain.do?method=edit&fdId=${param.fdId}','_self');" order="3">
				    </ui:button>
				</kmss:auth>
			</c:if>
			<kmss:auth
				requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=delete&fdId=${param.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}" 
						onclick="deleteDoc('sysNewsMain.do?method=delete&fdId=${param.fdId}');" order="3">
				</ui:button>
			</kmss:auth>
			<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	
	<template:replace name="path">
			<ui:combin ref="menu.path.simplecategory">
				<ui:varParams 
					moduleTitle="${ lfn:message('sys-news:news.moduleName') }" 
					modulePath="/sys/news/" 
					modelName="com.landray.kmss.sys.news.model.SysNewsTemplate" 
					autoFetch="false"
					href="/sys/news/"
					categoryId="${sysNewsMainForm.fdTemplateId}" />
			</ui:combin>
	</template:replace>	
	<template:replace name="content"> 
				<script>
					seajs.use(['lui/dialog','lui/jquery'],function(dialog,$){
						//删除事件
						window.deleteDoc = function(delUrl){
							dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(isOk){
								if(isOk){
									Com_OpenWindow(delUrl,'_self');
								}	
							});
							return;
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
									//var tmpHeight = (IFrame_Content.contentWindow.document.body.scrollHeight + 10 );
								document.getElementById("contentDiv").style.height = bh+"px";
						 }else{//rtf输出文本
							 // xform输出默认设置最大宽度
							// doZipImage();
						 }
					};
			   </script>
		<c:set var="sysDocBaseInfoForm" value="${sysNewsMainForm}" scope="request" />
		<!--标题-->
		<div class='lui_form_title_frame'>
			<div class='lui_form_subject'>
			    <c:if test="${sysNewsMainForm.fdIsTop==true}">
		           <img src="${LUI_ContextPath}/sys/news/images/zding.gif" border=0 title="<bean:message key="news.fdIsTop.true" bundle="sys-news"/>" />
		        </c:if>
				<bean:write	name="sysNewsMainForm" property="docSubject" />
			</div>
			<div class='lui_form_baseinfo'>
			    <!--发布日期-->
				<c:if test="${ not empty sysNewsMainForm.docPublishTime }">
					<span><bean:write name="sysNewsMainForm" property="docPublishTime" /></span>
				</c:if>
				<!--作者-->
				<bean:message bundle="sys-news" key="sysNewsMain.fdAuthorId" />：
				<c:if test="${sysNewsMainForm.fdIsWriter==false}">			
					      <span><ui:person personId="${sysNewsMainForm.fdAuthorId}" personName="${sysNewsMainForm.fdAuthorName}"></ui:person></span>
			    </c:if>
			    <c:if test="${sysNewsMainForm.fdIsWriter==true}">	
					      <c:out value="${sysNewsMainForm.fdWriter}"></c:out>
				 </c:if>
				 <%--新闻来源 --%>	
				<c:if test="${not empty sysNewsMainForm.fdNewsSource}">				
					<bean:message bundle="sys-news" key="sysNewsMain.fdNewsSourceOnly" />：<bean:write	name="sysNewsMainForm" property="fdNewsSource" />
				</c:if>
			</div>
		</div>
		<!--内容-->
		    <!-- 摘要 -->
		 <c:if test="${ not empty sysNewsMainForm.fdDescription }">
			<div class="lui_form_summary_frame">			
				<font color="#003048"><bean:write	name="sysNewsMainForm" property="fdDescription" /></font>
			</div>
		</c:if>
<div class="lui_form_content_frame clearfloat" id="lui_form_content_frame">		
	<div style="min-height: 150px;" id="contentDiv">
		     <c:choose>
						<c:when test="${not empty sysNewsMainForm.fdIsLink}">
						   <!--发布机制链接-->
							<bean:message bundle="sys-news" key="SysNewsMain.linkNews" />
							<a href='<c:url value="${sysNewsMainForm.fdLinkUrl}"/>' class="com_subject"/>
						                <c:out value="${sysNewsMainForm.docContent}"/>
							</a>
						</c:when>
						<c:otherwise>
							<c:if test="${sysNewsMainForm.fdContentType=='rtf'}">
								<xform:rtf property="docContent"></xform:rtf>
							</c:if>
							<c:if test="${sysNewsMainForm.fdContentType=='word'}">
							<%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()){
								if (com.landray.kmss.sys.attachment.util.JgWebOffice.isExistFile(request)){%>
								<iframe onload="javascript:setFrameSize();" id="IFrame_Content" 
									src="<c:url value="/sys/attachment/sys_att_main/jg/sysAttMain_html_forward.jsp?fdId=${param.fdId}"/>" width=100% height=100% frameborder=0 scrolling=no>
								</iframe>
							<%  }
								else{%>
									${sysNewsMainForm.fdHtmlContent}
								<% }
							  } else { %>
									${sysNewsMainForm.fdHtmlContent}
							<%} %>
							</c:if>
						</c:otherwise>
			</c:choose>
	</div>
			
			<!--附件-->    
			<c:if test="${not empty sysNewsMainForm.autoHashMap['fdAttachment'].attachments}">
			<div class="lui_form_spacing"> </div>
			<div>
				<div class="lui_form_subhead"><img src="${KMSS_Parameter_ContextPath}sys/attachment/view/img/attachment.png"> ${ lfn:message('sys-news:tip.news.download.attachment') }(${fn:length(sysNewsMainForm.attachmentForms['fdAttachment'].attachments)})</div>
				<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
							charEncoding="UTF-8">
					<c:param name="formBeanName" value="sysNewsMainForm" />
					<c:param name="fdKey" value="fdAttachment" />
					<c:param name="fdModelName" value="com.landray.kmss.sys.news.model.SysNewsMain" />
				</c:import>
			</div> 	
			</c:if> 
		<br>
	<div style="padding-left:5px">	
	   <!-- 标签机制 -->
				<c:import url="/sys/tag/import/sysTagMain_view.jsp" charEncoding="utf-8">
						<c:param name="formName" value="sysNewsMainForm" />
						<c:param name="useTab" value="false"></c:param>
				</c:import>		
   </div>  			
		</div>
		<ui:tabpage expand="false">
			<%--收藏机制 --%>
			<c:import url="/sys/bookmark/import/bookmark_bar.jsp" charEncoding="UTF-8">
				<c:param name="fdSubject" value="${sysNewsMainForm.docSubject}" />
				<c:param name="fdModelId" value="${sysNewsMainForm.fdId}" />
				<c:param name="fdModelName" value="com.landray.kmss.sys.news.model.SysNewsMain" />
			</c:import>
			
			<%--点评机制 --%>
			<c:import url="/sys/evaluation/import/sysEvaluationMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="sysNewsMainForm" />
			</c:import>
			
			<%--阅读机制 --%>
			<c:import url="/sys/readlog/import/sysReadLog_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="sysNewsMainForm" />
			</c:import>
			
			<%--权限机制 --%>
			<c:import url="/sys/right/import/right_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="sysNewsMainForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.sys.news.model.SysNewsMain" />
			</c:import>
		
			<%--流程机制 --%>
			<c:import url="/sys/workflow/import/sysWfProcess_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="sysNewsMainForm" />
				<c:param name="fdKey" value="newsMainDoc" />
			</c:import>		
		</ui:tabpage>
	</template:replace>
	<template:replace name="nav">
	 <c:if test="${sysNewsMainForm.docStatus ne 30 && sysNewsMainForm.docStatus ne 40}">
	  <div style="min-width:200px;"></div>
		<ui:accordionpanel style="min-width:200px;"> 
			<ui:content title="${lfn:message('sys-news:sysNewsMain.baseInfo')}" toggle="false">
				<ul class='lui_form_info'>
					<li><bean:message bundle="sys-news" key="sysNewsMain.fdAuthorId" />：
					<ui:person personId="${sysNewsMainForm.fdCreatorId}" personName="${sysNewsMainForm.fdCreatorName}"></ui:person></li>
					<li><bean:message bundle="sys-news" key="sysNewsMain.fdDepartmentId" />：<bean:write	 name="sysDocBaseInfoForm" property="fdDepartmentName" /></li>
					<li><bean:message bundle="sys-news" key="sysNewsPublishMain.fdImportance" />：<sunbor:enumsShow	value="${sysNewsMainForm.fdImportance}"	enumsType="sysNewsMain_fdImportance" /></li>
					<li><bean:message bundle="sys-news" key="sysNewsPublishMain.docStatus" />：<sunbor:enumsShow	value="${sysNewsMainForm.docStatus}"	enumsType="news_status" /></li>
				  <c:if test="${hasImage eq true}">  
				    <li>
				    <c:import
							url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
							charEncoding="UTF-8">
							<c:param name="fdKey" value="Attachment" />
							<c:param name="fdMulti" value="false" />
							<c:param name="fdAttType" value="pic" />
							<c:param name="fdImgHtmlProperty" value="width=120" />
							<c:param name="fdModelId" value="${sysNewsMainForm.fdId }" />
							<c:param name="fdModelName"
								value="com.landray.kmss.sys.news.model.SysNewsMain" />
							<%-- 图片设定大小 --%>
							<c:param name="picWidth" value="258" />
							<c:param name="picHeight" value="192" />
							<c:param name="proportion" value="false" />
							<c:param name="fdLayoutType" value="pic"/>
							<c:param name="fdPicContentWidth" value="258"/>
							<c:param name="fdPicContentHeight" value="192"/>
							<c:param name="fdViewType" value="pic_single"/>
							<c:param name="fdShowMsg">false</c:param>
					</c:import>
				    </li>
				</c:if>
				</ul>
			</ui:content>
		</ui:accordionpanel>
	</c:if>
		<%--关联机制 --%>
		<c:import url="/sys/relation/import/sysRelationMain_view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="sysNewsMainForm" />
		</c:import>
	</template:replace>
</template:include>