<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/include_kms_top.jsp" %>
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage" %>
<%@ include file="/kms/wiki/kms_wiki_main/kmsWikiMain_edit_js.jsp"%>
<%@ include file="/kms/wiki/kms_wiki_main/kmsWikiMain_edit_css.jsp"%>
<%@page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
</head>
<c:if test="${kmsWikiMainForm.method_GET=='add' }">
	<%@page import="com.landray.kmss.kms.wiki.model.KmsWikiCategory"%>
	<%@page import="com.landray.kmss.kms.wiki.service.IKmsWikiCategoryService"%>
	<%@page import="org.springframework.context.ApplicationContext"%>
	<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
	<%@page import="com.landray.kmss.kms.wiki.forms.KmsWikiCategoryForm"%>
	<%@page import="com.landray.kmss.common.actions.RequestContext"%>
	<%  
		String templateId = request.getParameter("fdCategoryId");
		ApplicationContext ctx = WebApplicationContextUtils
				.getRequiredWebApplicationContext(request.getSession()
				.getServletContext());
		IKmsWikiCategoryService templateService = (IKmsWikiCategoryService) ctx
				.getBean("kmsWikiCategoryService");
		if (templateId != null) {
			KmsWikiCategory template = (KmsWikiCategory) templateService
			.findByPrimaryKey(templateId);
			KmsWikiCategoryForm form = new KmsWikiCategoryForm();
			templateService.convertModelToForm(form, template,
			new RequestContext(request));
			request.setAttribute("kmsWikiCategoryForm", form);
		}
	%>
</c:if>

<% if(request.getAttribute("KMSS_RETURNPAGE")==null){ %>
<logic:messagesPresent>
	<table align=center><tr><td>
		<font class="txtstrong"><bean:message key="errors.header.vali"/></font>
		<bean:message key="errors.header.correct"/>
		<html:messages id="error">
			<br><img src='${KMSS_Parameter_StylePath}msg/dot.gif'>&nbsp;&nbsp;<bean:write name="error"/>
		</html:messages>
	</td></tr></table>
	 
</logic:messagesPresent>
<% }else{
	KmssMessageWriter msgWriter = new KmssMessageWriter(request, (KmssReturnPage)request.getAttribute("KMSS_RETURNPAGE"));
%>
<script>
Com_IncludeFile("msg.js", "style/"+Com_Parameter.Style+"/msg/");
function showMoreErrInfo(index, srcImg){
	var obj = document.getElementById("moreErrInfo"+index);
	if(obj!=null){
		if(obj.style.display=="none"){
			obj.style.display="block";
			srcImg.src = Com_Parameter.StylePath + "msg/minus.gif";
		}else{
			obj.style.display="none";
			srcImg.src = Com_Parameter.StylePath + "msg/plus.gif";
		}
	}
}
</script>
 <div id=div1 style="position:absolute;display:none;top:100px;left:100px;background:#FFF;width:100px;height:100px;">wait...
 <input type=button></div>
<% } %>
<c:set var="cardPicURL" value="${kmsResourcePath }/theme/default/img/header_r.gif" />
<c:set var="attForms" value="${kmsWikiMainForm.attachmentForms['spic'] }" />
<c:forEach var="sysAttMain" items="${attForms.attachments }" varStatus="vsStatus">
	<c:if test="${vsStatus.first }">
		<c:set var="attId" value="${sysAttMain.fdId}" />
		<c:set var="cardPicURL" value="${pageContext.request.contextPath }/kms/wiki/kms_wiki_att_main/kmsWikiAttMain.do?method=download&fdId=${sysAttMain.fdId}" />
	</c:if>
</c:forEach>
<body style="text-align:center">
<html:form action="/kms/wiki/kms_wiki_main/kmsWikiMain.do" onsubmit="return validateKmsWikiMainForm(this);">
<div id="wrapper">
	<div id="main" class="box c">
		<div class="content3">
			<c:if test="${kmsWikiMainForm.method_GET=='add' || kmsWikiMainForm.method_GET=='edit'}">
				<div class="location m_t20" style="text-align:left">
					<a href="javascript:void(0)" class="home" onclick="gotoIndex()" title="首页">首页</a>&gt;
					<a href="javascript:void(0)" onclick="gotoWikiCenter()" title="维基知识库"><bean:message	bundle="kms-wiki" key="module.kmsWikiMain" /></a>&gt;
					<span>
						<c:if test="${kmsWikiMainForm.method_GET=='add'}">新建词条</c:if> 
						<c:if test="${kmsWikiMainForm.method_GET=='edit'}">编辑词条</c:if>
					</span>
				</div>
			</c:if>
			<c:if test="${kmsWikiMainForm.method_GET=='addVersion'|| kmsWikiMainForm.method_GET == 'edit'}">
				<h1 class="title">${kmsWikiMainForm.docSubject}</h1>
				<p>
					<span class="baseInfo_holder" onclick="option_baseInfo(this);">展开</span>
					<span class="baseInfo_img" ><img id='baseInfo_img' src="${kmsResourcePath }/img/ic_cocl.gif" /></span>
				</p>
			</c:if> 
			<div class="share2_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_e m_t20">
					<%--词条名--%>
					<tr <c:if test="${kmsWikiMainForm.method_GET=='addVersion'|| kmsWikiMainForm.method_GET == 'edit'}">style="display:none"</c:if>>
						<th><span class="xing">*</span><bean:message bundle="kms-wiki" key="kmsWikiMain.docSubject" />：</th>
						<td colspan="3">
							<html:text property="docSubject" styleClass="i_c" styleId="docSubject" onblur="validateWiki(this)"/>
							<div id="validateInfo" class="validateInfo"></div>
						</td>
				  	</tr>
				  	<tbody id="baseInfos" <c:if test="${kmsWikiMainForm.method_GET=='addVersion'|| kmsWikiMainForm.method_GET == 'edit'}">style="display:none"</c:if>>
				  	<%--所属分类--%>
					<tr >
						<th><span class="xing">*</span><bean:message bundle="kms-wiki" key="kmsWikiMain.fdCategoryList" />：</th>
						<td colspan="3">
							<html:hidden property="fdCategoryId" />
							<c:if test="${kmsWikiMainForm.method_GET=='addVersion'|| kmsWikiMainForm.method_GET == 'edit'}">
								<c:out value="${kmsWikiMainForm.fdCategoryName }" />	
							</c:if>
							<c:if test="${kmsWikiMainForm.method_GET=='add'}">
								<html:text property="fdCategoryName" readonly="true" styleClass="i_c" /> 
								<span class="btn_g"><a title="选择" href="#" id="selectAreaNames" onclick="seclectCategory();"><span><bean:message key="dialog.selectOther" /></span></a></span>
							</c:if>
						</td>
					</tr>
					
					<%--所属模板
					<tr>
						<th><bean:message bundle="kms-wiki" key="kmsWikiMain.fdTemplate" />：</th>
						<td colspan="3">
							<c:if test="${kmsWikiMainForm.method_GET=='add'}">
							<html:text property="fdTemplateName" styleClass="i_c" /> 
							<span class="btn_g">
								<a href="#" title="选择" onclick="Dialog_List(false, 'fdTemplateId', 'fdTemplateName', null, 'KmsWikiTemplateTree&type=child',callBackTemplateAction ,'KmsWikiTemplateTree&type=search&key=!{keyword}', null, null, '<bean:message  bundle="kms-wiki" key="table.kmsWikiTemplate"/>');">
									<span><bean:message key="dialog.selectOther" /></span>
								</a>
							</span>
							</c:if>
							<c:if test="${kmsWikiMainForm.method_GET=='addVersion'|| kmsWikiMainForm.method_GET == 'edit'}">
								<c:out value="${kmsWikiMainForm.fdTemplateName }" />
							</c:if>
						</td>
					</tr>--%>
					<%-- 所属场所 --%>
				<% if(ISysAuthConstant.IS_AREA_ENABLED) { %> 
				<c:if test="${kmsWikiMainForm.method_GET=='add' }">
					<tr class="multidoctr">	
				    <th>
				        <bean:message key="sysAuthArea.authArea" bundle="sys-authorization" />：
					</th>
					<td colspan="3">
						<input type="hidden" name="authAreaId" value="${kmsWikiCategoryForm.authAreaId}"> 
						<xform:text property="authAreaName" showStatus="view" value="${kmsWikiCategoryForm.authAreaName}"/>	
					</td>	
				</tr >
				</c:if>
				<c:if test="${kmsWikiMainForm.method_GET=='edit' }">
					<tr class="multidoctr">	
				    <th>
				        <bean:message key="sysAuthArea.authArea" bundle="sys-authorization" />：
					</th>
					<td colspan="3">
						<input type="hidden" name="authAreaId" value="${kmsWikiMainForm.authAreaId}"> 
						<xform:text property="authAreaName" showStatus="view" />	
					</td>	
				</tr >
				</c:if>
			
				<% } %>
				 	<tr >
						<th>知识标签：</th>
						<td colspan="3">
							<c:import url="/kms/common/resource/ui/sysTagMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="formName" value="kmsWikiMainForm" />
								<c:param name="fdKey" value="wikiMain" />
								<c:param name="modelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
								<c:param name="fdQueryCondition" value="docSubject" />
							</c:import>
					 	</td>
					</tr>
					<c:if test="${kmsWikiMainForm.method_GET=='add'}">
					<tr>
							<th>作者类型：</th>
							<td>
								<sunbor:enums property="fdAutherType" bundle="kms-wiki" enumsType="kmsWikiMain.fdAuthorType" elementType="radio" value="${kmsWikiMainForm.fdAutherType}" htmlElementProperties="onclick='seclectAuthorType(this);'"/>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;作者：
								<html:hidden property="docAuthorId" />
								<html:text property="fdAutherName" style="width:35%" styleClass="i_c" readonly="true" />
								<span class="btn_g" id="authorSelect_span"><a title="选择" href="#" id="outerAuthor" onclick="Dialog_Address(false, 'docAuthorId','fdAutherName', ';',ORG_TYPE_PERSON);"><span><bean:message key="dialog.selectOther" /></span></a></span>
							</td>
					</tr>
					</c:if>
					<c:if test="${not empty kmsWikiMainForm.extendFilePath}">
				  	<tr>
				  		<th><strong><bean:message bundle="kms-wiki" key="kmsWikiMain.docProperty" />&nbsp;&nbsp;&nbsp;</strong></th> <!-- 文档属性 -->
						<td colspan="3">
						</td>                                                      
					</tr>
					<!-- 属性 -->
					<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmsWikiMainForm" />
					</c:import>
					<tr>
				    <td colspan="4" ><hr/></td>
					</tr>
					</c:if>
					</tbody>
					
					<c:if test="${kmsWikiMainForm.method_GET == 'add' || kmsWikiMainForm.method_GET == 'edit'}">
					<tr>
						<td colspan="4">
							<table width="100%">
								<tr >
									<td><h3>百科名片</h3></td>
								</tr>
								<tr>
									<td width="172px">
										<a title="" class="img_f" href="javascript:void(0)">
											<img id="cardPic" src="${cardPicURL }" fdAttId="${attId}" onload="javascript:drawImage(this,this.parentNode)">
										</a>
										<input id="file_upload" name="file_upload" type="file"/>
									</td>
									<td style="vertical-align: top;">
										<html:textarea property="docCardContent" styleClass="docCardContent" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
					</c:if>
					
					<c:if test="${kmsWikiMainForm.method_GET == 'addVersion' }">
					<kmss:authShow roles="ROLE_KMSWIKIMAIN_CARD_EDIT">
					<tr>
						<td colspan="4">
							<table width="100%">
								<tr>
									<td><h3>百科名片</h3></td>
								</tr>
								<tr>
									<td width="172px">
										<a title="" class="img_f" href="javascript:void(0)">
											<img id="cardPic" src="${cardPicURL }" fdAttId="${attId}" onload="javascript:drawImage(this,this.parentNode)">
										</a>
										<input id="file_upload" name="file_upload" type="file"/>
									</td>
									<td style="vertical-align: top;">
										<html:textarea property="docCardContent" styleClass="docCardContent" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
					</kmss:authShow>
					</c:if>
					
					
					<tr>
						<th colspan="4" height="15"></th>
					</tr>
					<c:if test="${kmsWikiMainForm.method_GET == 'add' || kmsWikiMainForm.method_GET == 'edit'}">
					<tr>
						<td colspan="4">
							<table width="100%" id="content_table">
								<c:forEach items="${kmsWikiMainForm.fdCatelogList}" var="kmsWikiCatelogForm" varStatus="varStatus">
								<tr class="editable_tr">
									<td style="width: 100%">
										<h2><a name="viewable_${kmsWikiCatelogForm.fdId}">${kmsWikiCatelogForm.fdName}</a></h2>
										<p class="editP" ><span onclick="openEdit(this);return false"><a class="editButton">编辑此段</a></span></p>
										<div class="clear"></div>
										<div class="editable" id="editable_${kmsWikiCatelogForm.fdId}" >
											${kmsWikiCatelogForm.docContent}
										</div>
									</td>
									<%--需要放在tr的内部，增删行的时候会随tr增删--%>
									<html:hidden property="fdCatelogList[${varStatus.index}].fdId" />
									<html:hidden property="fdCatelogList[${varStatus.index}].fdName" />
									<html:hidden property="fdCatelogList[${varStatus.index}].fdOrder" />
									<html:hidden property="fdCatelogList[${varStatus.index}].fdMainId"/>
									<html:hidden property="fdCatelogList[${varStatus.index}].fdParentId" />
									<html:hidden property="fdCatelogList[${varStatus.index}].docContent"/>
									<html:hidden property="fdCatelogList[${varStatus.index}].authEditorIds"/>
									<html:hidden property="fdCatelogList[${varStatus.index}].authEditorNames"/>
								</tr>
								</c:forEach>
							</table>
							
								
						</td>
					</tr>
					</c:if>
					
					<c:if test="${kmsWikiMainForm.method_GET == 'addVersion' }">
					<tr>
						<td colspan="4">
							<table width="100%" id="content_table">
								<c:forEach items="${kmsWikiMainForm.fdCatelogList}" var="kmsWikiCatelogForm" varStatus="varStatus">
									<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=addVersion&fdParentId=${kmsWikiMainForm.fdParentId}&catelogId=${kmsWikiCatelogForm.fdParentId}" requestMethod="GET">
									<tr class="editable_tr">
										<td style="width: 100%">
											<h2><a name="viewable_${kmsWikiCatelogForm.fdId}">${kmsWikiCatelogForm.fdName}</a></h2>
											<p class="editP"><span onclick="openEdit(this);return false"><a class="editButton" >编辑此段</a></span></p>
											<div class="clear"></div>
											<div class="editable" id="editable_${kmsWikiCatelogForm.fdId}" >
												${kmsWikiCatelogForm.docContent}
											</div>
										</td>
									</tr>
									</kmss:auth>
									<%--需要放在tr的外面--%>
									<html:hidden property="fdCatelogList[${varStatus.index}].fdId" />
									<html:hidden property="fdCatelogList[${varStatus.index}].fdName" />
									<html:hidden property="fdCatelogList[${varStatus.index}].fdOrder" />
									<html:hidden property="fdCatelogList[${varStatus.index}].fdParentId" />
									<html:hidden property="fdCatelogList[${varStatus.index}].fdMainId"/>
									<html:hidden property="fdCatelogList[${varStatus.index}].docContent"/>
									<html:hidden property="fdCatelogList[${varStatus.index}].authEditorIds"/>
									<html:hidden property="fdCatelogList[${varStatus.index}].authEditorNames"/>
								</c:forEach>
							</table>
						</td>
					</tr>
					</c:if>
					
					<tr>
						<th>
							<bean:message
								bundle="kms-wiki"
								key="kmsWiki.attachement" /> ：
						</th>
						<td colspan="3">
						    <c:import
								url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
								charEncoding="UTF-8">
								<c:param
									name="fdKey"
									value="attachment" />
							</c:import>
						</td>
				  	</tr>
				  	<c:if test="${kmsWikiMainForm.method_GET == 'addVersion' }">
					  	<tr></tr>
						<tr><td colspan="4" class="wiki_edit_reason"><h3>修改原因：(不超过200字)</h3></td></tr>
						<tr>
							<td colspan="4"><html:textarea property="fdReason" style="width:100%"/></td>
						</tr>
					</c:if>
				</table>
					
				<div class="con con2 con2_3 m_t20">
					<div class="title4">
						<ul id="tags" class="c">
						</ul>
					</div>
					<div id="tagContent">
						<div id="tagContent0" class="tagContent selectTag">
							<div class="km_list5">  
								<table id='Label_Tabels' width="99%" cellspacing="0" cellpadding="0" border="0" >
									<!--   关联机制 -->
									<tr LKS_LabelName="<bean:message bundle="sys-relation" key="sysRelationMain.tab.label" />" style="display:none"  align="center">
										<c:set
											var="mainModelForm"
											value="${kmsWikiMainForm}"
											scope="request" />
										<c:set
											var="currModelName"
											value="com.landray.kmss.kms.wiki.model.kmsWikiMain"
											scope="request" />
										<td width="100%"><%@ include file="/kms/wiki/resource/jsp/sysRelationMain_edit_include.jsp"%></td>
									</tr>	 
									<!-- 权限机制  -->
									<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />" style="display:none"  >
										<td>
											<table border="0" cellspacing="0" width="99%" cellpadding="0" class="t_i">
												<c:import url="/sys/right/right_edit.jsp" charEncoding="UTF-8">
													<c:param name="formName" value="kmsMultidocKnowledgeForm" />
													<c:param name="moduleModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
												</c:import>
											</table>
										</td>
									</tr>
									<!--   流程机制 -->
									<c:import url="/sys/workflow/include/sysWfProcess_edit.jsp"
										charEncoding="UTF-8">
										<c:param name="formName" value="kmsWikiMainForm" />
										<c:param name="fdKey" value="wikiFlow" />
									</c:import>	
								</table>
							</div>
						</div>
					</div><!-- end tagContent -->
				</div>
				<div class="btns_box btns_box2 c"></div>
				<div class="clear"></div>
			</div>
		</div><!-- end content3 -->	
		<br/>
		
		
		<div class="rightbar2">
			<div class="right_box">
				<div class="title4" style="background-image: none;">
					<ul id="right_tags" class="c">
						<li class="selectTag"><a onclick="selectTag('right_tagContent0',this)" href="javascript:void(0)">目录信息</a></li>
						<li class=""><a onclick="selectTag('right_tagContent1',this)" href="javascript:void(0)">编辑规范</a></li>
					</ul>
				</div>
			
				<div id="right_tagContent">
					<div id="right_tagContent0" class="right_tagContent selectTag" style="display: block;">
						<c:if test="${kmsWikiMainForm.method_GET == 'addVersion'}">
							<c:if test="${empty param.catelogId}">
							<!-- 编辑段落的时候，不能编辑目录 -->
							<ul class="l_i m_t10 f_l">
								<li ><div class="btn_e"><a href="javascript:void(0)"  onclick="editCatelog();"><span>编辑目录</span></a></div></li>
							</ul>
							<div class="clear"></div>
							</c:if>
							<ul class="m_t10" id="right_ul_catelog">
							<c:forEach items="${kmsWikiMainForm.fdCatelogList}" var="kmsWikiCatelogForm" varStatus="varStatuses">
								<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=addVersion&fdParentId=${kmsWikiMainForm.fdParentId}&catelogId=${kmsWikiCatelogForm.fdParentId}" requestMethod="GET">
									<li class="right_selectLi">
										<a href="#editable_${kmsWikiCatelogForm.fdId}" id="href_${kmsWikiCatelogForm.fdId}">${kmsWikiCatelogForm.fdName}</a>
									</li>
									<div id="viewable_${kmsWikiCatelogForm.fdId}"></div>
								</kmss:auth>
							</c:forEach>
							</ul>
						</c:if>
						<c:if test="${kmsWikiMainForm.method_GET == 'add' || kmsWikiMainForm.method_GET == 'edit'}">
							<ul class="l_i m_t10 f_l">
								<li><div class="btn_e" ><a href="#"  onclick="editCatelog();"><span>编辑目录</span></a></div></li>
							</ul>
							<div class="clear"></div>
							<ul class="m_t10" id="right_ul_catelog">
							</ul>
						</c:if>
					</div>
					<div id="right_tagContent1" class="right_tagContent" style="display: none;">
						<ul class="l_i m_t10">
							<li>
								${kmsWikiMainForm.fdTemplateDescription}
							</li>
						</ul>
					
					</div>
				</div>
			</div><!-- end right_box -->
		</div>
		<div class="clear"></div>
	</div><!-- main end -->
	
 	<div id= "buttonBarDiv"  class="btns_box" >
    <!-- 按钮显示控制 -->
    	<div class="btn_a" style="float:right">	
			<a href="javascript:void(0)" title="关闭" onclick="closeWindow();"><span><bean:message key="button.close"/></span></a>
		</div>
		<logic:equal name="kmsWikiMainForm" property="method_GET" value="add">
			<kmss:windowTitle subjectKey="kms-wiki:kmswiki.add.title" moduleKey="kms-wiki:module.kmsWikiMain" />
			<div class="btn_a" style="float:right">	
				<a href="javascript:void(0)"  onclick="commitMethod('save','false');" title="提交"><span><bean:message key="button.submit"/></span></a>
			</div>
			<div class="btn_a" style="float:right">	
				<a href="javascript:void(0)"   onclick="commitMethod('save','true');" title="暂存"><span><bean:message key="button.savedraft"/></span></a>
			</div>	
		</logic:equal>
		<logic:equal name="kmsWikiMainForm" property="method_GET" value="addVersion">
			<kmss:windowTitle subject="${kmsWikiMainForm.docSubject}" moduleKey="kms-wiki:module.kmsWikiMain" />
			<div class="btn_a" style="float:right">	
				<a href="javascript:void(0)"  onclick="commitMethod('save','false');" title="提交"><span><bean:message key="button.submit"/></span></a>
			</div>
			<div class="btn_a" style="float:right">	
				<a href="javascript:void(0)"   onclick="commitMethod('save','true');" title="暂存"><span><bean:message key="button.savedraft"/></span></a>
			</div>	
		</logic:equal>
		<logic:equal name="kmsWikiMainForm" property="method_GET" value="edit">
			<kmss:windowTitle subject="${kmsWikiMainForm.docSubject}" moduleKey="kms-wiki:module.kmsWikiMain" />
			<c:if test="${kmsWikiMainForm.docStatus == '20' || kmsWikiMainForm.docStatus == '10'}">
				<div class="btn_a" style="float:right">	
					<a href="javascript:void(0)" onclick="commitMethod('update','false');" title="提交"><span><bean:message key="button.submit"/></span></a>	
				</div>
			</c:if>
			<c:if test="${kmsWikiMainForm.docStatus == '10'}">
				<div class="btn_a" style="float:right">	
					<a href="javascript:void(0)" onclick="commitMethod('update','true');" title="暂存"><span><bean:message key="button.savedraft"/></span></a>
				</div>
			</c:if>
			<c:if test="${kmsWikiMainForm.docStatus == '30'|| kmsWikiMainForm.docStatus == '11'}">
				<div class="btn_a" style="float:right">	
					<a href="javascript:void(0)" onclick="commitMethod('update', 'false');" title="提交"><span><bean:message key="button.submit"/></span></a>
				</div>	 
			</c:if>
		</logic:equal> 
 	</div>
</div>
<input type="hidden" name="methodType" />
<c:if test="${kmsWikiMainForm.method_GET=='addVersion'}">
	<input type="hidden" name="fdOptionType" value="update" />
</c:if>
<c:if test="${kmsWikiMainForm.method_GET=='add'}">
	<input type="hidden" name="fdOptionType" value="add" />
</c:if>
<html:hidden property="fdTemplateId" />
<html:hidden property="fdId" />
<html:hidden property="docReadCount" />
<html:hidden property="docIntrCount" />
<html:hidden property="fdHtmlContent" />
<html:hidden property="fdParentId" />
<html:hidden property="fdVersion" />
<html:hidden property="fdLastEdition" />
<html:hidden property="fdFirstId" /> 
<html:hidden property="docCreatorId" />
<html:hidden property="docCreateTime" />
<html:hidden property="docAlterorId" />
<html:hidden property="docAlterTime" />
<html:hidden property="docPublishTime" />
<html:hidden property="docStatus" />
<html:hidden property="method_GET" />
<html:hidden property="extendFilePath" />
<html:hidden property="extendDataXML" />
</html:form>
<html:javascript formName="kmsWikiMainForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/kms/common/resource/jsp/include_kms_down.jsp"%>