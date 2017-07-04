<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="kms.learn.view" width="100%" sidebar="no">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/multidoc/kms_multidoc_ui/style/view.css" />
		<%@ include file="/kms/multidoc/kms_multidoc_ui/kmsMultidocKnowledge_view_attscript.jsp"%>
		<script src="${LUI_ContextPath}/kms/common/resource/js/kms_utils.js"></script>
	</template:replace>
	<template:replace name="title">
		<c:out value="${ kmsMultidocKnowledgeForm.docSubject } - ${ lfn:message('kms-multidoc:table.kmdoc') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
	</template:replace>
	<template:replace name="path">
	</template:replace>	
	<template:replace name="content" > 
		<c:set
			var="sysDocBaseInfoForm"
			value="${kmsMultidocKnowledgeForm}"
			scope="request" />
		<div class='lui_form_title_frame' style="width: 90%" >
			<!-- 文档标题 -->
			<div class='lui_form_subject'>
				<bean:write	name="kmsMultidocKnowledgeForm" property="docSubject" />
				<c:if test="${kmsMultidocKnowledgeForm.docIsIntroduced==true}">
		  	 		 <img src="${LUI_ContextPath}/kms/knowledge/resource/img/jing.gif" 
		  	 		      border=0 
		  	 		      title="${lfn:message('kms-knowledge:kmsKnowledge.introduced')}" />
		    	</c:if>
		    	<c:if test="${isHasNewVersion=='true'}">
				     <span style="color:red">(<bean:message bundle="kms-multidoc" key="kmsMultidoc.kmsMultidocKnowledge.has" />
				     <a href="javascript:;" style="font-size:18px;color:red" onclick="Com_OpenWindow('kmsMultidocKnowledge.do?method=view&fdId=${kmsMultidocKnowledgeForm.docOriginDocId}','_self');">
					 <bean:message bundle="kms-multidoc" key="kmsMultidoc.kmsMultidocKnowledge.NewVersion" /></a>)</span>
		        </c:if>
			</div>
		</div>
		
		<!-- 文档摘要 -->
		<c:if test="${ not empty kmsMultidocKnowledgeForm.fdDescription }">
			<div style="height: 15px;"></div>
			<div class="lui_form_summary_frame" style="width: 90%" >			
				<bean:write	name="kmsMultidocKnowledgeForm" property="fdDescription" />
			</div>
		</c:if>
		 
		<!-- 文档内容 -->
		<c:if test="${not empty sysDocBaseInfoForm.docContent}">
			<div class="lui_form_content_frame" style="min-height: inherit;width: 90%" > 
				<div data-on="doc.content" style="display: block;">
					<div class="lui_tabpage_float_header_text">
						${lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.content') }
					</div>
					<xform:rtf property="docContent" imgReader="true" ></xform:rtf>
				</div>		
			</div>	
		</c:if>
        
        <!-- 多媒体阅读器 --> 
        <div id="imgInfo" style="width: 90%">
			<!-- 图片浏览器展现 -->
			<table class="lui_multidoc_showPic" id='imgBrowser' style="margin-left: auto;margin-right: auto;display:none;"  >
				<tr>
					<td colspan="3"  >
						<div style="position:relative;overflow:hidden;width:100%;height:565px;" >
							<div style="position:absolute;height;565px;left:0px;display:block;" id='imgDiv'> 
								<div id='bigImg1' style="float:left;"> </div> 
								<div id='bigImg2' style="float:left;">​</div>
								<div id='bigImg3' style="float:left;"></div>
							</div>
							<!-- 左箭头 -->
							<div><a  class="insignia_left"onclick="left()"></a></div>
							<!-- 右箭头 -->
							<div><a  class="insignia_right" onclick="right()"></a></div>
							<!-- loading -->
							<div >
								<center style="padding-top:35%">
									<img  src="${KMSS_Parameter_ContextPath}resource/style/common/images/loading.gif" border="0" />
								</center> 
								
							</div> 
						</div>
						
					</td>
					
				</tr>
				<tr>
					<td class="img_small_btnl">
					<div class="img_small_btnbar" id="play_pre">
                             &nbsp;<a href="javascript:void(0)" onclick="moveLeft()"><i  class="d_i_maintrig d_i_trigL"></i><i class="d_i_maintrig d_i_trig_coverL"></i></a></div>
                             </td>
					<td>
						<div id='smallImg' class='picList'>
						   <ul id='picListItem'>
						   </ul>
						</div>
				    </td>
					
					<td class="img_small_btnr">
                           <div class="img_small_btnbar" id="play_next">
                               &nbsp;
                            <a href="javascript:void(0)" onclick="moveRight()">   
                            <i class="d_i_maintrig d_i_trigR"></i><i class="d_i_maintrig d_i_trig_coverR"></i></a>
                            
                            </div>
                   	</td>
				</tr>
			</table>
			
			<div id="attachImg"></div>
		 </div>
            <div id="attachFile" style="width:350px;">
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
				<c:param name="fdMulti" value="true" />
				<c:param name="formBeanName" value="kmsMultidocKnowledgeForm" />
				<c:param name="fdKey" value="attachment" />
				<c:param name="drawFunction" value="Attachment_ShowList" />
				<c:param name="fdModelName" value="kmsMultidocKnowledge" />
				<c:param name="fdModelId" value="${param.fdId}" />
			</c:import>
	  	 </div>
	  	 <c:if test="${not empty kmsMultidocKnowledgeForm.attachmentForms['attachment'].attachments}">
				<table width="100%">
					<tr>
						<td
							width="15%"
							class="td_normal_title"
							valign="top"><bean:message
							bundle="kms-multidoc"
							key="kmsMultidoc.attachement" /></td>
						<td
							width="85%"
							colspan="3">
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
										charEncoding="UTF-8">
									<c:param
										name="formBeanName"
										value="sysDocBaseInfoForm" />
									<c:param
										name="fdKey"
										value="attachment" />
							</c:import>
						</td>
					</tr> 
				</table>
			</c:if>
	  	 <style>
	  	 .lui_form_content{width: 90% !impotrant}
	  	 </style>
	  	
	</template:replace>
</template:include>
<%@ include file="/kms/multidoc/kms_multidoc_ui/kmsMultidocKnowledge_view_script.jsp"%>