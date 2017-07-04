<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/include_kms_top.jsp" %>
<%@ include file="/kms/wiki/kms_wiki_main/kmsWikiMain_view_js.jsp"%>
<%@ include file="/kms/wiki/kms_wiki_main/kmsWikiMain_view_css.jsp"%>
<title>${kmsWikiMainForm.docSubject}</title>
</head>
<c:set var="cardPicURL" value="${kmsResourcePath }/theme/default/img/header_r.gif" />
<c:set var="attForms" value="${kmsWikiMainForm.attachmentForms['spic'] }" />
<c:forEach var="sysAttMain" items="${attForms.attachments }" varStatus="vsStatus">
	<c:if test="${vsStatus.first }">
		<c:set var="fdAttId" value="${sysAttMain.fdId }" />
		<c:set var="cardPicURL" value="${pageContext.request.contextPath }/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}" />
	</c:if>
</c:forEach>
<body style="text-align:center" >
<br/><br/> 
<div id="wrapper">
	<div id="main" class="box c">
		<div class="content3" >
			<h1 class="title" >${kmsWikiMainForm.docSubject}<c:if test='${isLock }'><img alt="" src="${kmsThemePath }/img/lock.gif"></c:if></h1>
			
			<c:if test="${kmsWikiMainForm.fdLastEdition == '2' && fdHasNewVersion == 'false' }">
				<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=addVersion&fdId=${kmsWikiMainForm.fdId}&fdParentId=${kmsWikiMainForm.fdId}" requestMethod="GET">
					<span class="edit_citiao" onclick="Com_OpenWindow('kmsWikiMain.do?method=addVersion&fdParentId=${kmsWikiMainForm.fdId}','_blank');" ></span>
				</kmss:auth> 
			</c:if>
			
			<c:if test="${not empty kmsWikiMainForm.extendFilePath}">
			<table id='sysPropertyTemplateTable' border="0" cellpadding="0" align="center" width="100%" class="t_z">
				<tr><td colspan="4"><hr/><br></td></tr> 
				<tr>
					<td width="9%" align='left'><!--文档属性-->
						<nobr><strong><bean:message bundle="kms-wiki" key="kmsWikiMain.docProperty" />&nbsp;&nbsp;&nbsp;</strong><a href="javascript:void(0)" id="aWordShow" onclick="showPropertyList();return false;">
						<!--收起-->
						<font id='wordShow' color="blue">展开</font></a><img id='imgShow' src="${kmsResourcePath }/img/ic_cocl.gif" /></nobr></td>
					<td colspan="3" width="91%" align="right" >
						<div align="right"></div>
					</td>
				</tr>
				<!-- 属性 -->
				<tbody id="propertyList" >
					<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmsWikiMainForm" />
					</c:import>
				  </tbody>
				 <tr><td colspan="4"><br><hr/></td></tr>
			</table>
			</c:if>
			
			<c:if test="${not empty kmsWikiMainForm.docCardContent || not empty fdAttId}">
			<div class="edit_title">
				<h3>
					<kmss:authShow roles="ROLE_KMSWIKIMAIN_CARD_EDIT">
						<a href="javascript:void(0)" onclick="Com_OpenWindow('kmsWikiMain.do?method=addVersion&fdParentId=${kmsWikiMainForm.fdId}&catelogId=${kmsWikiCatelogForm.fdId}','_self');" class="wiki_card_edit"></a>
					</kmss:authShow>
					<a >词条名片</a>
				</h3>
			</div>
			<div class="summary" >
				<div class= "summary1" >
					<a title="" class="img_f" href="javascript:void(0)" >
						<img id="cardPic" src="${cardPicURL }" onload="javascript:drawImage(this,this.parentNode)">
					</a>
				</div>
				<div class="content9" >
					<p>${kmsWikiMainForm.docCardContent}</p>
				</div>
				<div class="clear"></div>
			</div>
			</c:if>
			<div class="clear"></div>
			<div class="dir_box">
					<h2 class="title" >目录</h2>
					<ul id="catalog_ul">
					</ul>
					<div class="catalog_holder" onclick="option_Catalog(this);" id="optionCatelogBtn">展开</div>
			</div><!-- end dir_box -->
			<div class="clear"></div>
 
			
            <div id="contentDiv">
				<c:forEach items="${kmsWikiMainForm.fdCatelogList}" var="kmsWikiCatelogForm">
				<!-- 头部占位置，增加高度，防止被遮盖 -->
				<a name="viewable_${kmsWikiCatelogForm.fdId}" ></a>
				<div class="con1" ></div>
					<div class="edit_box">
						<div class="edit_title">
							<span class="">
								<c:if test="${kmsWikiMainForm.fdLastEdition == '2' && fdHasNewVersion == 'false'}">
								<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=addVersion&fdId=${kmsWikiMainForm.fdId}&fdParentId=${kmsWikiMainForm.fdId}&catelogId=${kmsWikiCatelogForm.fdId}" requestMethod="GET">
									<a href="javascript:void(0)" onclick="Com_OpenWindow('kmsWikiMain.do?method=addVersion&fdParentId=${kmsWikiMainForm.fdId}&catelogId=${kmsWikiCatelogForm.fdId}','_self');" title="">编辑本段</a>
								</kmss:auth>
								</c:if>
							</span>
							<h2><a name="viewable_${kmsWikiCatelogForm.fdId}">${kmsWikiCatelogForm.fdName}</a></h2>
						</div>
						<div class="edit_page" valign="top" >
							<div name="${kmsWikiCatelogForm.fdId }">
								${kmsWikiCatelogForm.docContent}
							</div>
							<div class="spctrl"></div>
						</div>
					</div><!-- end edit_box -->
				</c:forEach>
				<div class="clear"></div>
				
			</div><!-- end p_con -->
				<div class="con con2 con2_3 m_t10">
					<div class="title4">
						<ul id="tags" class="c">
						</ul>
					</div>
				</div>	

				<div>
					 <table id="Label_Tabels" width="100%" border="0" cellspacing="0" cellpadding="0" class="t_d">
					 <c:if test="${kmsWikiMainForm.fdLastEdition == '2' && fdHasNewVersion == 'false' }">
						 <!-- 点评 -->   
						<c:import url="/kms/wiki/resource/jsp/sysEvaluationMain_view.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmsWikiMainForm" />
						</c:import>
					    <!-- 推荐 -->
						<c:import url="/kms/wiki/resource/jsp/sysIntroduceMain_view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsWikiMainForm" />
							<c:param name="fdKey" value="wikiMain" />
							<c:param name="toEssence" value="true" />
							<c:param name="toNews" value="false" />
							<c:param name="docSubject" value="${kmsWikiMainForm.docSubject}" />
							<c:param name="docCreatorName" value="${kmsWikiMainForm.docCreatorName}" />
						</c:import>
					    <!-- 阅读 -->
					    <c:import url="/sys/readlog/include/sysReadLog_view.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmsWikiMainForm" />
							<c:param name="isPublish" value="${kmsWikiMainForm.docStatus==30 }" />
						</c:import>
					</c:if>	
						
						<c:if test="${fdEnable=='1' }">
							<!-- 段落点评--批注 -->
							<c:import url="/kms/wiki/resource/jsp/sysWikiEvaluation_view.jsp"
								charEncoding="UTF-8">
								<c:param name="fdModelId" value="${param.fdId }" />
								<c:param name="fdFirstId" value="${param.id }" />
								<c:param name="fdCategoryId" value="${kmsWikiMainForm.fdCategoryId }" />
							</c:import>
						</c:if>
					   	<!--   权限        -->
					    <tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />"style="display: none"  >
							<td>
							<table border="0" cellspacing="0" width="99%" cellpadding="0" class="t_i">
							   <c:import url="/sys/right/right_view.jsp" charEncoding="UTF-8">
								 <c:param  name="formName" value="kmsWikiMainForm" />
								 <c:param  name="moduleModelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
							   </c:import>
							</table>
							</td>
						</tr>
					
					    <!-- 流程 -->	
					   	<c:import url="/sys/workflow/include/sysWfProcess_view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsWikiMainForm" />
							<c:param name="fdKey" value="wikiFlow" />
						</c:import>
					    
					</table>
					 
				</div>
			</div><!-- end content3 -->	
		
			<div class="rightbar">
				<div class="box3 m_t10" >
					<div class="title1"><h2>基本信息</h2></div>
					<div class="box2">
					<ul class="l_i m_t10">
					
						<li>作者：${fdAutherName}</li>
						<li>创建者：${firstCreator.fdName}</li>
						<li>创建时间：${kmsWikiMainForm.docCreateTime}</li>
						<li>版本号：V${kmsWikiMainForm.fdVersion}</li>
						<li>完善次数：${not empty editCount ? editCount : 0} 次 <a class="li_i_view0" onclick="viewAllVersion();">历史版本</a><c:if test="${not empty fdLastVersionId}"><a onclick="compareLastVersion('${fdLastVersionId}')" class="li_i_view0" >上一版本比较</a></c:if></li>
						<li>阅读次数：${kmsWikiMainForm.readLogForm.fdReadCount} 次</li>
						<li>推荐次数：${not empty introduceCount ? introduceCount : 0} 次</li>
						<li>最近更新：${kmsWikiMainForm.docAlterTime}</li>
						<li>合作编辑者：<c:forEach items="${editorList}" var="person" varStatus="varStatus">${person.fdName}<c:if test="${!varStatus.last }">；</c:if></c:forEach></li>
					</ul>
					</div>
				</div>
				<div class="box3 m_t10" >	
					<div class="title1"><h2>分类信息</h2></div>
					<div class="box2">
					<ul class="l_i m_t10">
						<!-- <li><c:forEach items="${categoryList}" var="kmsWikiCategory" varStatus="varStatus">${kmsWikiCategory.fdName}<c:if test="${!varStatus.last }">；</c:if></c:forEach></li> -->
						${kmsWikiMainForm.fdCategoryName}
					</ul>
					</div>
				</div>
				
				<div class="box3 m_t10" >	
					<div class="title1"><h2>铺分类信息</h2></div>
					<div class="box2">
					<ul class="l_i m_t10">
						<li><c:forEach items="${categoryList}" var="kmsWikiCategory" varStatus="varStatus">${kmsWikiCategory.fdName}<c:if test="${!varStatus.last }">；</c:if></c:forEach></li>
					</ul>
					</div>
				</div>
				
				<div class="box3 m_t10" >
					<div class="title1"><h2>标签信息</h2></div>
					<div class="box2">
					 <c:import url="/kms/common/resource/ui/sysTagMain_view.jsp"
						charEncoding="UTF-8">
						<c:param name="formName" value="kmsWikiMainForm" />
						<c:param name="fdKey" value="wikiMain" /> 
						<c:param name="modelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
						<c:param name="fdQueryCondition" value="fdCategoryId;docDeptId" />  
					</c:import>
					</div>
	 			</div>
				<div class="box3 m_t10"  id="docRelation">
					<div class="title1"><h2><bean:message bundle="sys-relation" key="sysRelationMain.tab.label" /></h2></div>
					<c:set var="currModelId" value="${kmsWikiMainForm.fdId}" scope="request" />
					<c:set var="mainModelForm" value="${kmsWikiMainForm}" scope="request" />
					<c:set var="currModelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain" scope="request" />
					<c:import url="/sys/relation/include/sysRelationMain_doc_view.jsp" charEncoding="UTF-8">
						<c:param name="mainModelForm" value="kmsWikiMainForm"   />
						<c:param name="currModelId" value="${kmsWikiMainForm.fdId}"   />
						<c:param name="currModelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain"   />
					</c:import>
				</div><!-- end box3 -->
				
				<div class="box3 m_t10">
					<div class="title1">
						<h2>
							<bean:message
								bundle="kms-wiki"
								key="kmsWiki.attachement" />
						</h2>
					</div>
					 <!-- 附件--> 
					<div class="box2">
						<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
							<c:param name="fdMulti" value="true" />
							<c:param name="formBeanName" value="kmsWikiMainForm" />
							<c:param name="fdKey" value="attachment" />
						</c:import>
					</div>
				</div>
			</div><!-- end  rightbar-->
		</div>
	</div><!-- main end -->
	<div id="successTag" align="center" > 
	<br><font size="4"><bean:message bundle="" key="return.optSuccess" /></font> 
	</div>
			<!--------------- 目录开始 ---------------->
			<div id="sideDiv" >
				<div id="sidecatalog"  >
					<div id="sidebar" class="sidebar" onclick="optionSideBar(this);"></div>
					<a id="gotop" href="#" class="gotop"></a>
				</div>
	
				<div id="side-catalog-content" >
					<div id="side-catalog-up" class="disable" onclick="upCatelog();"><div></div></div>
					<div id="side-lemma-title">目录</div>
					<div id="side-title-panel" >
						<div >
							<ul  id="side-title-list">
							</ul>
						</div>
					</div>
	
					<div id="side-catalog-down" class="" onclick="downCatelog();"><div></div></div>
				</div>
			</div>	
			<!--------------- 目录结束 ----------------->
			<div id="buttonBarDiv" class="btns_box" >
				
				<c:if test='${isLock}'>
					<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=toUnlock&categoryId=${kmsWikiMainForm.fdCategoryId}">
					 	<div class="btn_a">
							<a href='javascript:void(0)' onclick="unlockWiki();return false;"> <span><bean:message bundle="kms-wiki" key="kmsWikiMain.unlock"/></span></a>
						</div>
					</kmss:auth>
				</c:if>
				
			     <!-- 调整属性-->
                 <c:if test="${not empty kmsWikiMainForm.extendFilePath}">
				  <kmss:auth
						requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=editProperty&fdId=${kmsWikiMainForm.fdId}"
						requestMethod="GET">
				    <div class="btn_a">
				 	 <a href='javascript:void(0)' onclick="editProperty();return false;"> <span><bean:message bundle="kms-wiki" key="kmsWiki.button.editProperty" /></span></a>
				 	</div>
			 	 </kmss:auth>
			 	</c:if>
			 	
			 	  <!-- 添加标签-->
			 	   <kmss:auth
						requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=addTag&fdId=${kmsWikiMainForm.fdId}" requestMethod="GET">
						<div class="btn_a" ><a href='javascript:void(0)' onclick="addTags(3);return false;"> <span>添加标签</span></a> </div>     
				   </kmss:auth>
				<!-- 编辑标签-->
				<kmss:auth
						requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=updateTag&fdId=${kmsWikiMainForm.fdId}" requestMethod="GET">
					 <div class="btn_a" ><a href='javascript:void(0)' onclick="addTags(2);return false;"> <span>调整标签</span></a> </div>     
				 </kmss:auth>
			 	
                <c:if test="${kmsWikiMainForm.fdLastEdition != '1'}"> 
				<!-- 删除-->
				<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=delete&fdId=${kmsWikiMainForm.fdId}" requestMethod="GET">
					<div class="btn_a" ><a href="javascript:void(0)" onclick=" checkDelete() " title="删除"><span><bean:message key="button.delete"/></span></a></div>
				</kmss:auth>
				</c:if> 
				
			    <kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=edit&fdId=${kmsWikiMainForm.fdId}" requestMethod="GET">
					<div class="btn_a" ><a href="javascript:void(0)" onclick="Com_OpenWindow('kmsWikiMain.do?method=edit&fdId=${kmsWikiMainForm.fdId}','_self');" title="编辑"><span><bean:message key="button.edit"/></span></a></div>
				</kmss:auth> 
			
				<c:if test="${kmsWikiMainForm.fdLastEdition == '2'}"> 
				<!-- 收藏--> 
				<div class="btn_a" >
					<c:import url="/kms/common/resource/ui/bookmark_bar.jsp"
						charEncoding="UTF-8">
						<c:param name="fdSubject" value="${kmsWikiMainForm.docSubject}" />
						<c:param name="fdModelId" value="${kmsWikiMainForm.fdId}" />
						<c:param name="fdModelName"
							value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
					</c:import>
				</div>
				<!-- 分类转移-->
				<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=cateChgEdit&fdId=${kmsWikiMainForm.fdId}&categoryId=${kmsWikiMainForm.fdCategoryId}" requestMethod="GET">
					<div class="btn_a"><a href="javascript:void(0)" onclick="checkChange();" title="<bean:message key="sysSimpleCategory.chg.button" bundle="sys-simplecategory"/>"><span><bean:message key="sysSimpleCategory.chg.button" bundle="sys-simplecategory"/></span></a></div>
				</kmss:auth>
				<!-- 权限变更-->
				<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=rightDocChange&categoryId=${kmsWikiMainForm.fdCategoryId}" requestMethod="GET">	
					 <div class="btn_a" style= "float:right">			
						 <a href="javascript:void(0)" onclick="changeRight() " title="<bean:message bundle="kms-wiki" key="kmsWiki.button.changeRight" />">
							 <span><bean:message bundle="kms-wiki" key="kmsWiki.button.changeRight" /></span></a>
					 </div>	
				 </kmss:auth>
				</c:if>  
 	</div>
 		<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=addEvaluateSub&categoryId=${kmsWikiMainForm.fdCategoryId}" requestMethod="GET">	
 	<div id="share_div">
 		<ul>
 			<li>
 				<a id="sinaShare" href="javascript:void(0)">
 					<span>分享</span>
 				</a>
 			</li>
 			<li>
 				<a id="evaluationShare" href="javascript:void(0)">
 					<span>点评</span>
 				</a>
 			</li>
 			
 		</ul>
 	</div></kmss:auth>
<%@ include file="/kms/common/resource/jsp/include_kms_down.jsp" %>