<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"%>
<%@ page import="java.util.List"%>
<%@ include file="/kms/common/resource/jsp/include_kms_top.jsp" %>
<%@ include file="kmsMultidocKnowledge_info_view_script.jsp"%>
<link href="../resource/css/default/mainDoc.css" rel="stylesheet" type="text/css"/>
<title><c:out value="${kmsMultidocKnowledgeForm.docSubject}" /></title>
</head>
<body style="text-align:center">
<br/><br/> 
<div id="wrapper">
	 
	<div id="main" class="box c">
		<div class="content3">
			<div class="location" style="text-align:left"><a href="javascript:void(0)" onclick="gotoIndex()" class="home" title="首页"><bean:message	bundle="kms-multidoc" key="kmsMultidoc.homepage" />${Kms_Base_Path}</a>&gt;
			<a href="javascript:void(0)" onclick='gotoMultidocCenter()' title="知识中心"><bean:message	bundle="kms-multidoc" key="kmsMultidoc.center" /></a>&gt;
			<c:out value="${kmsMultidocKnowledgeForm.fdDocTemplateName}"/></div>
			<div class="btns_box btns_box2 c">
			</div>
			<div class="clear"></div>
			<div class="doc_box">
				<h2 class="h2_5"><c:out value="${kmsMultidocKnowledgeForm.docSubject}" /></h2>
				<!-- 文件作者 -->
				<div class="page_inf" ><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.docAuthor" /><strong id='author'></strong>
				<span><c:out value="${kmsMultidocKnowledgeForm.docPublishTime}" /></span>
				<!--点评--><span><a href="#evaluation" onclick="showTrByTagName('<bean:message bundle="sys-evaluation" key="sysEvaluationMain.tab.evaluation.label" />')"><bean:message bundle="sys-evaluation" key="sysEvaluationMain.tab.evaluation.label" /></a><font id='evaluationNum'></font></span>
				<!--推荐--><span><a href="#introduce" onclick="showTrByTagName('<bean:message bundle="sys-introduce" key="sysIntroduceMain.tab.introduce.label" />')"><bean:message bundle="sys-introduce" key="sysIntroduceMain.tab.introduce.label" /></a><font id='introduceNum'></font></span>
				<!--阅读--><span><a href="#readlog" onclick="showTrByTagName('<bean:message bundle="sys-readlog" key="sysReadLog.tab.readlog.label" />')"><bean:message bundle="sys-readlog" key="sysReadLog.tab.readlog.label" /></a>(<c:out value="${kmsMultidocKnowledgeForm.docReadCount+1}" />)</span>
              </div>   
              <c:if test="${not empty kmsMultidocKnowledgeForm.extendFilePath}">
              <table id='sysPropertyTemplateTable' border="0" cellpadding="0" align="center" width=100% style="display: none">
				 <tr><td colspan="4"><br></td></tr> 
				 <tr>
				  <td width="9%" align='left'><!--文档属性-->
						<nobr><strong><bean:message bundle="kms-multidoc"	key="kmsMultidoc.docProperty" /></strong><a href="javascript:void(0)" id="aWordShow" onclick="showPropertyList()">
					    <!--收起--><font id='wordShow' color="blue"><bean:message bundle="kms-multidoc" key="kmsMultidoc.button.close" /></font></a>
					    <a href="javascript:void(0)" id="aWordShow" onclick="showPropertyList()"><img id='imgShow' src="${kmsResourcePath }/img/ic_coop.gif" /></nobr></a></td>
					<td colspan="3" width="91%" align="right" >
					    <div align="right"> </div>
					</td>
				  </tr>
				   <!-- 属性 -->
				   <tbody id="propertyList" class="PropertyListView">
				   <c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmsMultidocKnowledgeForm" />
						<c:param name="fdDocTemplateId" value="${kmsMultidocKnowledgeForm.fdDocTemplateId}" />
					 </c:import>
				  </tbody>
				 <tr><td colspan="4"><br></td></tr>
				 </table>
				 </c:if> 
				 
				 <div class="content_view">
				 		<!-- 摘要-->
				 	 <p class="summary" style="margin-right: 1px;margin-top: 0px;"><strong><bean:message
							bundle="kms-multidoc"
							key="kmsMultidoc.docBrief" /></strong> <c:out value="${kmsMultidocKnowledgeForm.fdDescription}"/></p>
					
					<c:if test="${not empty kmsMultidocKnowledgeForm.docContent }">		
						<span class="cnt"><strong>文档内容</strong><a class="cnt_pack" id="cnt_a" href="javascript:void(0)">收起</a></span>
							<div class="p_con" id="contentInfo" style="text-align:left;">
					 		<c:out value="${kmsMultidocKnowledgeForm.docContent}" escapeXml="false" />  
						</div><!-- end p_con -->
					</c:if>
					<c:if test="${openSwf==true }">
						<div id="swfDiv">
							
							<object id="att_swf_viewer" style="height: 500px" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" style="cursor:pointer;width:100%">
								<param name="wmode" value="opaque">
								<param name="allowFullScreen" value="true">
				 				<param name="movie" value="${KMSS_Parameter_ContextPath }sys/attachment/swf/viewer.swf">
								<param name="flashVars" value="docurl=${swfDocUrl }&pagecount=${swfPageCount}&pageType=swf">
								<param name="quality" value="high">
								<embed	
									flashVars="docurl=${swfDocUrl }&pagecount=${swfPageCount}&pageType=swf" 
									id="att_swf_viewer" 
									src="${KMSS_Parameter_ContextPath }sys/attachment/swf/viewer.swf" 
									wmode="opaque" quality="high" 
									pluginspage="http://www.macromedia.com/go/getflashplayer" 
									type="application/x-shockwave-flash" 
									style="width:100%;height: 500px;"
									allowFullScreen=true
									wmode="window">
								 </embed>
							</object>
						</div>
					</c:if>	
				 </div>
				 
				
			
<div class="left">
					<!-- 图片附件 -->
					<div id="imgInfo">
						<!-- 图片浏览器展现 -->
						<table id='imgBrowser' style="display:none;border-collapse:collapse;width:90%;margin-left:5%"  >
							<tr>
								<td colspan="3" id='bigImg'></td>
							</tr>
							<tr>
								<td class='left' ><a href="javascript:void(0)" onclick="moveLeft()">
									<img src="<%=request.getContextPath()%>/kms/multidoc/resource/img/scroll_left.gif" width="13" height="54" border="0" alt=""></a>
								</td>
								<td>
									<div id='smallImg' class='picList'>
									   <ul id='picListItem'>
									   </ul>
									</div>
							    </td>
								<td class='right'><a href="javascript:void(0)" onclick="moveRight()">
							    	<img src="<%=request.getContextPath()%>/kms/multidoc/resource/img/scroll_right.gif" width="13" height="54" border="0" alt=""></a>
								</td>
							</tr>
						</table>
						<div id="attachImg"></div>
					</div>
					<div id="attachFile" style="width:350px;display:none">
						<b style="padding-left:3px;font-size: 14px;"><STRONG>附件</STRONG></b>
						<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
							<c:param name="fdMulti" value="true" />
							<c:param name="formBeanName" value="kmsMultidocKnowledgeForm" />
							<c:param name="fdKey" value="attachment" />
							<c:param name="drawFunction" value="Attachment_ShowList" />
							<c:param name="fdModelName" value="kmsMultidocKnowledge" />
							<c:param name="fdModelId" value="${param.fdId}" />
						</c:import>
					</div>
				</div>
	<div class="con con2 con2_3 m_t10">
					<div class="title4">
						<ul id="tags" class="c">
						</ul>
					</div>
				</div>	

				<div>
					 <table id="Label_Tabels" width="100%" border="0" cellspacing="0" cellpadding="0" class="t_d">
					   <!-- 点评 -->   
						<c:import url="/kms/common/resource/ui/sysEvaluationMain_view.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm" />
						</c:import>
					   
					    <!-- 推荐 -->
						<c:import url="/kms/common/resource/ui/sysIntroduceMain_view.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm" />
							<c:param name="fdKey" value="mainDoc" />
							<c:param name="toEssence" value="true" />
							<c:param name="toNews" value="true" />
							<c:param name="docCreatorName" value="${kmsMultidocKnowledgeForm.docCreatorName}" />
						</c:import>
						
					    <!-- 阅读 -->
					    <c:if test="${kmsMultidocKnowledgeForm.docStatus==30 }">
					    <c:import url="/sys/readlog/include/sysReadLog_view.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm" />
						</c:import>
						</c:if>
						<!-- 版本 -->
						 <c:import url="/kms/common/resource/ui/sysEditionMain_view.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm" />
						</c:import>
					   	<!--   权限        -->
					   <tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />" style="display:none"  >
							<td>
							<table border="0" cellspacing="0" width="99%" cellpadding="0" class="t_i">
							   <c:import url="/sys/right/right_view.jsp" charEncoding="UTF-8">
								 <c:param  name="formName" value="kmsMultidocKnowledgeForm" />
								 <c:param  name="moduleModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
							   </c:import>
							</table>
							</td>
						</tr>											
					   <!-- 流程机制 -->
					   <c:import url="/sys/workflow/include/sysWfProcess_view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm" />
				      </c:import>	  
					</table>
					 
				</div>
			</div>
		</div><!-- end content3 -->	


		<div class="rightbar">
			<div class="box3 m_t10"> 
				<div class="title1"><h2 ><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.docInfo" /></h2>
				</div>
				<div class="box2">
				<ul class="l_i m_t10" style="text-align:left">
					<li><em id='fen'><c:out value="${kmsMultidocKnowledgeForm.docScore}" />分</em><span id='xing'></script></span></li>
					<input type=hidden id="docScore"  value="${kmsMultidocKnowledgeForm.docScore}" />
					<li><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.inputUser" />：<c:out value="${kmsMultidocKnowledgeForm.docCreatorName}" /></li>
					<li><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.form.main.docDeptId" />：<c:out value="${kmsMultidocKnowledgeForm.docDeptName}" /></li>
					<li><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.kmsMultidocKnowledge.docStatus" />： <sunbor:enumsShow value="${kmsMultidocKnowledgeForm.docStatus}"   enumsType="common_status"  /></li>
					<li><strong><bean:message 
						bundle="sys-edition" 
						key="sysEditionMain.tab.label" />：V<c:out value="${kmsMultidocKnowledgeForm.docMainVersion}" />.<c:out value="${kmsMultidocKnowledgeForm.docAuxiVersion}" /></strong>
					<kmss:auth requestURL="/kms/common/resource/ui/kmsSysEditionMain.do?method=newVersion&mainVersion=${kmsMultidocKnowledgeForm.docMainVersion}&auxiVersion=${kmsMultidocKnowledgeForm.docAuxiVersion}&fdModelName=com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge&fdModelId=${kmsMultidocKnowledgeForm.fdId}" requestMethod="GET">
						<div class="btn_e" id="newEdtionButtonDiv">  
						<a href="#"  onclick="showNewEdtion(this)" id="newEdtionButton"  ><span><bean:message key="sysEditionMain.button.newedition" bundle="sys-edition"/></span></a></div>
					</kmss:auth>
						<div class="clear"></div>
					</li>
					<li><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.lastUpdateUser" />：<span><c:out value="${kmsMultidocKnowledgeForm.docAlterorName}" /></span></li>
					<li><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.lastUpdateTime" />：<c:out value="${kmsMultidocKnowledgeForm.docAlterTime}" /></li>
				</ul>
				</div>
			</div>
			
			<div class="box3 m_t10" style="" >
				<div class="title1">
					<h2>
						<bean:message
							bundle="kms-multidoc"
							key="kmsMultidoc.kmsMultidocKnowledge.docTag" />
					</h2>
				</div>
				<div class="box2">
				    <c:import url="/kms/common/resource/ui/sysTagMain_view.jsp"
						charEncoding="UTF-8">
						<c:param name="formName" value="kmsMultidocKnowledgeForm" />
						<c:param name="fdKey" value="mainDoc" /> 
						<c:param name="modelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
						<c:param name="fdQueryCondition" value="fdDocTemplateId;docDeptId" /> 
					</c:import>
				</div>
			</div><!-- end box3 -->
 			 
			<div class="box3 m_t10" id="docRelation" style="display:none;text-align:left" >
				<div class="title1">
					<h2>
						<bean:message bundle="sys-relation" key="sysRelationMain.tab.label" />
					</h2>
				</div>
			    <!-- 关联机制 /sys/relation/include/sysRelationMain_doc_view.jsp -->
				<c:import url="/sys/relation/include/sysRelationMain_doc_view.jsp"
					charEncoding="UTF-8">
					<c:param name="mainModelForm" value="kmsMultidocKnowledgeForm"   />
					<c:param name="currModelId" value="${kmsMultidocKnowledgeForm.fdId}"   />
					<c:param name="currModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"   />
				</c:import>
					
			</div><!-- end box3 -->
			
			<kms:portlet id="viewOnline" title="在线预览" cssClass="box3 m_t10" template="portlet_view_online_tmpl" dataBean="kmsDocKnowledgeAttOnlinePortlet" dataType="Bean" beanParm="{fdModelId:\"${kmsMultidocKnowledgeForm.fdId }\"}"></kms:portlet>
			
			<div class="box3 m_t10">
				<div class="title1">
					<h2>
						附件
					</h2>
				</div>
				 <!-- 附件--> 
				<div class="box2">
					<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
						<c:param name="fdMulti" value="true" />
						<c:param name="formBeanName" value="kmsMultidocKnowledgeForm" />
						<c:param name="fdKey" value="attachment" />
					</c:import>
				</div>
			</div>
		</div><!-- end  rightbar-->
	</div><!-- main end -->
</div>
<div id="successTag" style="border-width:1px;border-style:solid;position:absolute;display:none;top:40%;left:40%;background:#f8f8f8;width:200px;height:50px;"   align="center"> 
<br><font size="4"><bean:message bundle="" key="return.optSuccess" /></font> 
</div>
<div id="buttonBarDiv" class="btns_box" >
                 <!-- 编辑属性-->
                 <c:if test="${not empty kmsMultidocKnowledgeForm.extendFilePath}">
				  <kmss:auth
						requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=editProperty&fdId=${param.fdId}"
						requestMethod="GET">
				    <div class="btn_a" style= "float:right">
				 	 <a href='javascript:void(0)' onclick="editProperty();return false;"> <span><bean:message bundle="kms-multidoc" key="kmsMultidoc.button.editProperty" /></span></a>
				 	</div>
			 	 </kmss:auth>
			 	</c:if>
			 	 <c:set var="validateAuthEditTag" value="false" />
			    <kmss:auth
						requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=editTag&fdId=${param.fdId}"
						requestMethod="GET">
						<c:set var="validateAuthEditTag" value="true" />
			    </kmss:auth>
			 
  				<!-- 编辑标签-->
  				 <div class="btn_a" style= "float:right">
									<c:choose>
					                   <c:when test="${validateAuthEditTag=='true'}">
											 <a href='javascript:void(0)' onclick="addTags(2);return false;"> <span><bean:message bundle="kms-multidoc" key="kmsMultidoc.button.editTag" /></span></a>
					                   </c:when>
					                   <c:otherwise> <!-- 添加标签-->
					                   		 <kmss:auth  requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=addTag" requestMethod="GET">
							                	 <a href='javascript:void(0)' onclick="addTags(3);return false;"> <span><bean:message bundle="kms-multidoc" key="kmsMultidoc.button.addTag" /></span></a>        
							           		 </kmss:auth>
							            </c:otherwise>
							        </c:choose>			 						
			     </div>
				<!-- 编辑--> 
				<c:if test="${kmsMultidocKnowledgeForm.docStatusFirstDigit > '0' }">
				    <kmss:auth
						requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=edit&fdId=${param.fdId}"
						requestMethod="GET">
					 <div class="btn_a" style= "float:right">
						<a href="javascript:void(0)" onclick="Com_OpenWindow('kmsMultidocKnowledge.do?method=edit&fdId=${param.fdId}','_self');return false;" title="编辑">
						 <span><bean:message key="button.edit"/></span></a>
					 </div>	 
					</kmss:auth> 
				</c:if>
			
				<div class="btn_a" style= "float:right">
				<!-- 收藏--> 
				<c:import url="/kms/common/resource/ui/bookmark_bar.jsp"
					charEncoding="UTF-8">
					<c:param name="fdSubject" value="${kmsMultidocKnowledgeForm.docSubject}" />
					<c:param name="fdModelId" value="${kmsMultidocKnowledgeForm.fdId}" />
					<c:param name="fdModelName"
						value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
				</c:import>
				</div>
				<!-- 删除--> 
				 <kmss:auth
						requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=delete&fdId=${param.fdId}"
						requestMethod="GET">
					 <div class="btn_a" style= "float:right">
						<a href="javascript:void(0)" onclick=" checkDelete() " title="删除">
						 <span><bean:message key="button.delete"/></span></a>
					 </div>
				 </kmss:auth> 
				 <!-- 分类转移-->   
				 <kmss:auth 
					 requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=templateChange&fdId=${param.fdId}"
								requestMethod="GET">
				  <div class="btn_a" style= "float:right">				
									 <a href="javascript:void(0)" onclick="checkChange();" title="分类转移">
						 <span><bean:message key="sysSimpleCategory.chg.button" bundle="sys-simplecategory"/></span></a>
				  </div>
				  </kmss:auth>	
				 <!-- 权限变更--> 
				 <kmss:auth
							requestURL="/sys/right/rightDocChange.do?method=docRightEdit&modelName=com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge&categoryId=${kmsMultidocKnowledgeForm.fdDocTemplateId}"
							requestMethod="GET">
				 <div class="btn_a" style= "float:right">			
				 <a href="javascript:void(0)" onclick="changeRight() " title="权限变更">
						 <span><bean:message bundle="kms-multidoc" key="kmsMultidoc.button.changeRight" /></span></a>
				 </div>		 
				</kmss:auth>	
				
				  
 </div>
 <br/>
 
<!--[if IE 6]>
<script src="${kmsResourcePath }/js/DD_belatedPNG.js"></script>
<script>
    DD_belatedPNG.fix('span'); /* EXAMPLE */
    /* string argument can be any CSS selector */
    /* using .png_bg example is unnecessary */
    /* change it to what suits you! */
</script>
<![endif]--> 
<%@ include file="/kms/common/resource/jsp/include_kms_down.jsp" %>