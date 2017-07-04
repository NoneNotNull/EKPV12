<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"%>
<%@ page import="java.util.List"%>
<%@page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ include file="/kms/common/resource/jsp/include_kms_top.jsp"%>

<title><c:out value="${kmsMultidocKnowledgeForm.docSubject}" /></title>

<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script language="JavaScript">
	var fdModelId='${param.fdModelId}';
	var fdModelName='${param.fdModelName}';
	var fdWorkId='${param.fdWorkId}';
	var fdPhaseId='${param.fdPhaseId}';
	var url='<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}';
	if(fdModelId!=null&&fdModelId!=''){
		url+="&fdModelId="+fdModelId+"&fdModelName="+fdModelName+"&fdWorkId="+fdWorkId+"&fdPhaseId="+fdPhaseId;
	}
	Com_NewFileFromSimpleCateory('com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate',url);

</script>
</head>
<c:if test="${kmsMultidocKnowledgeForm.method_GET=='add' }">
	<%@page import="com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate"%>
	<%@page import="com.landray.kmss.kms.multidoc.service.IKmsMultidocTemplateService"%>
	<%@page import="org.springframework.context.ApplicationContext"%>
	<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
	<%@page import="com.landray.kmss.kms.multidoc.forms.KmsMultidocTemplateForm"%>
	<%@page import="com.landray.kmss.common.actions.RequestContext"%>
	<%  //得到 kmsMultidocTemplateForm
		String templateId = request.getParameter("fdTemplateId");
		ApplicationContext ctx = WebApplicationContextUtils
				.getRequiredWebApplicationContext(request.getSession()
				.getServletContext());
		IKmsMultidocTemplateService templateService = (IKmsMultidocTemplateService) ctx
				.getBean("kmsMultidocTemplateService");
		if (templateId != null) {
			KmsMultidocTemplate template = (KmsMultidocTemplate) templateService
			.findByPrimaryKey(templateId);
			KmsMultidocTemplateForm form = new KmsMultidocTemplateForm();
			templateService.convertModelToForm(form, template,
			new RequestContext(request));
			request.setAttribute("kmsMultidocTemplateForm", form);
		}
	%>
</c:if>
<c:set
	var="sysDocBaseInfoForm"
	value="${kmsMultidocKnowledgeForm}"
	scope="request" />
<body style="text-align:center">
<div id="wrapper">
<html:form action="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do"
				onsubmit="return validateKmsMultidocKnowledgeForm(this);">
	<div id="main" class="box c">
		<div class="content3">
			<div class="location m_t20" style="text-align:left"><a href="javascript:void(0)" class="home" onclick="gotoIndex()" title="首页"><bean:message	bundle="kms-multidoc" key="kmsMultidoc.homepage" /></a>&gt;
			<a  href="javascript:void(0)" onclick='gotoMultidocCenter()' title="知识中心"><bean:message	bundle="kms-multidoc" key="kmsMultidoc.center" /></a>&gt;
			<span><bean:message	bundle="kms-multidoc" key="kmsMultidoc.share" /></span></div>
			<div class="share2_box">
			  
				<div class="clear"></div>
				<html:hidden property="fdImportInfo"  styleId="fdImportInfo"/>
				<html:hidden property="fdDocTemplateId" styleId="fdDocTemplateId" /> 
				<html:hidden property="fdId" styleId="fdId" />
				<html:hidden property="docIsIndexTop" styleId="docIsIndexTop"/>
				<html:hidden property="docStatus"  styleId="docStatus" />
				<html:hidden property="extendFilePath"   />
				<html:hidden property="extendDataXML"   />
				<html:hidden property="method_GET" styleId="method_GET" />
				<html:hidden property="docCreateTime" />
				
				<html:hidden property="fdModelId" />
				<html:hidden property="fdModelName" />
				<html:hidden property="fdWorkId" />
				<html:hidden property="fdPhaseId" />
				<%@ include file="kmsMultidocKnowledge_script.jsp"%>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" class="t_e m_t20" style="word-wrap: break-word;">
				  <tr class="multidoctr">
					<th><span class="xing">*</span><bean:message
													bundle="sys-doc"
													key="sysDocBaseInfo.docSubject" />： </th><!-- 标题  -->	
					<td colspan="3"  ><html:text
						property="docSubject"
						styleClass="i_c" styleId="docSubject" /></td>
				  </tr>
				  <tr class="multidoctr">
					<th><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.kmsMultidocKnowledge.docTag" />：</th><!-- 知识标签  -->
					<td colspan="3">
					<!-- 标签机制 -->
					<c:import url="/kms/common/resource/ui/sysTagMain_edit.jsp"
						charEncoding="UTF-8">
						<c:param name="formName" value="kmsMultidocKnowledgeForm" />
						<c:param name="fdKey" value="mainDoc" /> 
						<c:param name="modelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
						<c:param name="fdQueryCondition" value="fdDocTemplateId;docDeptId" /> 
					</c:import>
					<!-- 标签机制 -->	
					 </td>
				  </tr>
				  <tr class="multidoctr">
					<th><bean:message
						bundle="kms-multidoc"
						key="kmsMultidocTemplate.fdStoretime" />：</th> <!-- 存储期限  -->
					<td colspan="3">
					<html:text property="docExpire"  styleClass="i_d m_r10"/><bean:message
						key="message.storetime"
						bundle="kms-multidoc" /><bean:message
						key="message.storetime.tip"
						bundle="kms-multidoc" />
					</td>
				  </tr>
				  
				 
				  
				  <tr class="multidoctr">
					<th><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.authorType" />：</th> <!-- 作者类型  -->
					<td><nobr><input type="radio" name="authorType" id="author1" value="1"  onclick="changeAuthor(this.value)"  />&nbsp;
								<bean:message
									bundle="kms-multidoc"
									key="kmsMultidoc.innerAuthor" /><!-- 内部作者 -->
					          <input type="radio" name="authorType" id="author2" value="2"  onclick="changeAuthor(this.value)" />&nbsp;
						         <bean:message
									bundle="kms-multidoc"
									key="kmsMultidoc.outerAuthor" /><!-- 外部作者 -->
						 </nobr>			
					</td>
					<th><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.docAuthor" />：</th><!-- 文档作者  -->
					<td>
					<div id="authorType1"  style="display:none" > 
					<html:hidden property="docAuthorId" styleId="docAuthorId"/> <html:text
						property="docAuthorName"
						styleClass="i_e m_r10"  styleId="docAuthorName"
						readonly="true" /><span class="btn_g">
						 <a href="#" onclick="Dialog_Address(false, 'docAuthorId','docAuthorName', ';', ORG_TYPE_PERSON);">
						 <span><bean:message key="dialog.selectOrg" /></span></a></span>
						
					</div>
					<div id="authorType2" style="display:none" > 
					  <html:text styleId="outerAuthor"  
										property="outerAuthor"
										styleClass="i_e m_r10"
						 />
					</div>
					 
					</td>
				  </tr>
				   
				  <tr class="multidoctr">
					 <th><bean:message
						bundle="kms-multidoc"
						key="table.kmsMultidocMainPost" />：</th> <!-- 所属岗位 --> 
					<td> <html:hidden property="docPostsIds" styleId='docPostsIds'/> <html:text
							property="docPostsNames"
							styleClass="i_e m_r10" styleId="docPostsNames"
							readonly="true" /><span class="btn_g"> 
							<a href="#"	onclick="Dialog_Address(false, 'docPostsIds','docPostsNames', ';',ORG_TYPE_POST);">
							<span><bean:message key="dialog.selectOrg" /></span></a></span></td>
					<th><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.form.main.docDeptId" />：</th><!--所属部门--> 
					<td><html:hidden property="docDeptId" styleId="docDeptId"  /> <html:text
						property="docDeptName"
						styleClass="i_e m_r10" styleId="docDeptName"
						readonly="true" /><span class="btn_g"> 
						 <a href="#" onclick="Dialog_Address(false, 'docDeptId','docDeptName', ';', ORG_TYPE_ORGORDEPT);"> 
						<span><bean:message key="dialog.selectOrg" /></span></a></span>
					  </td>
				  </tr>
				<%-- 所属场所 --%>
				<% if(ISysAuthConstant.IS_AREA_ENABLED) { %> 
				<tr class="multidoctr">	
				    <th>
				        <bean:message key="sysAuthArea.authArea" bundle="sys-authorization" />：
					</th>
					<td colspan="3">
						<input type="hidden" name="authAreaId" value="${kmsMultidocKnowledgeForm.authAreaId}"> 
						<xform:text property="authAreaName" showStatus="view" />	
					</td>	
				</tr >
				<% } %>
				  <tr class="multidoctr">
					<th><span class="xing">*</span><bean:message
						bundle="kms-multidoc"
						key="kmsMultidocKnowledge.fdTemplateName" />：</th><!-- 所属分类 --> 
					<td colspan="3">&nbsp;<c:out value="${kmsMultidocKnowledgeForm.fdDocTemplateName}"/>
					 <logic:equal
						name="kmsMultidocKnowledgeForm"
						property="method_GET"
						value="add">
					    <a href="javascript:void(0)" class="a_b m_l20" onclick="resetTemplate()" title="">
						    <bean:message
							bundle="kms-multidoc"
							key="kmsMultidoc.changeTemplate" /> <!-- 修改分类信息--> 
					   </a>
					 </logic:equal>    
					</td>
					 
				  </tr>
					  <tr class="multidoctr">
					
					<th><bean:message
						bundle="kms-multidoc"
						key="table.kmsMultidocTemplateProperty" />：</th> <!-- 辅类别 --> 
					<td colSpan="3">
					 <html:hidden property="docSecondaryCategoriesIds" />
					 <html:text
						property="docSecondaryCategoriesNames"
						readonly="true" styleId="docSecondaryCategoriesNames"
						styleClass="i_l m_r10" /><span class="btn_g">
						<a href="#" onclick="Dialog_SimpleCategory('com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate','docSecondaryCategoriesIds','docSecondaryCategoriesNames',true,null,'01',null,true,'${param.fdId}');">
						<span><bean:message key="dialog.selectOrg" /></span></a></span> 
				    </td>
					
				  </tr>
				 
				  <c:if test="${not empty kmsMultidocKnowledgeForm.extendFilePath}">
				 <tr class="multidoctr">
						<th>
					 	 	<strong>
					 	 		<bean:message
									bundle="kms-multidoc"
									key="kmsMultidoc.docProperty" />&nbsp;&nbsp;&nbsp;
							</strong>  
						</th> <!-- 文档属性 -->
						<td colspan="3">
						<div align="right">
						 	<a href="javascript:void(0)" onclick="showPropertyList()">
	 							<font id='wordShow' color="blue">
	 								<bean:message bundle="kms-multidoc" key="kmsMultidoc.button.close" /><!--收起-->
	 							</font>
	 							<img id='imgShow' src="${kmsResourcePath }/img/ic_coop.gif" />
	 						</a>
	 					</div>
						</td>                                                      
				 	</tr>
				   <!-- 属性 -->
				   <tbody id="propertyList">
				   		<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm" />
							<c:param name="fdDocTemplateId" value="${kmsMultidocKnowledgeForm.fdDocTemplateId}" />
					 	</c:import>
				   </tbody> 
				   <tr class="multidoctr">
				    <td colspan="4" ><hr/></td>
				   </tr>
				  </c:if>
				  
				  <tr class="multidoctr" ><!-- 摘要 -->
					<th><bean:message
							bundle="kms-multidoc"
							key="kmsMultidoc.docBrief" />：</th>
					<td colspan="3">
					<html:textarea
						property="fdDescription"
						style="width:100%;height:80px"
						  /></td>
				  </tr>	
				  <tr class="multidoctr">
					<th colspan="4" height="15"></th>
				  </tr>
				  <tr class="multidoctr" ><!-- 文档内容 -->
					<th><bean:message
							bundle="kms-multidoc"
							key="kmsMultidoc.kmsMultidocKnowledge.docContent" />：</th>
					<td colspan="3">
					<kmss:editor
							property="docContent"
							toolbarSet="Default"
							height="500" />
					</td>
				  </tr>
				  <tr class="multidoctr"><!-- 文档附件 -->
					<th><bean:message
							bundle="kms-multidoc"
							key="kmsMultidoc.attachement" /> ：
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
				  
				  <c:if test="${kmsMultidocKnowledgeForm.method_GET=='add'}">
					<tr class="multidoctr">
						<th>参考附件 ：
					</th>
						<td colspan="3">
						<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
							<c:param name="fdMulti" value="true" />
							<c:param
								name="fdKey"
								value="rattachment" />
							<c:param
								name="formBeanName"
								value="kmsMultidocTemplateForm" />
						</c:import>
						 
						 
						 </td>
					</tr>    
				</c:if>
  				<c:choose>
				   <c:when test="${kmsMultidocKnowledgeForm.method_GET=='add'}">
					 <!-- 版本 -->
						 <c:import
							url="/sys/edition/include/sysEditionMain_edit.jsp"
							charEncoding="UTF-8">
							<c:param
								name="formName"
								value="kmsMultidocKnowledgeForm" />
						 </c:import>
				   </c:when>
				</c:choose>
				</table>
				
				<div class="con con2 con2_3 m_t20">
					<div class="title4">
						<ul id="tags" class="c">
						</ul>
					</div>
					<div id="tagContent">
						<div id="tagContent0" class="tagContent selectTag">
							<div class="km_list5">  
								<table id='Label_Tabels' width="99%" cellspacing="0" cellpadding="0" border="0"   >
								    <!--   关联        -->
									<tr LKS_LabelName="<bean:message bundle="sys-relation" key="sysRelationMain.tab.label" />" style="display:none"  >
										<c:set var="mainModelForm" value="${kmsMultidocKnowledgeForm}"
											scope="request" />
										<c:set var="currModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"
											scope="request" />
										<td><%@ include file="/sys/relation/include/sysRelationMain_edit.jsp"%></td>
									</tr>	 
								     <!--   权限        -->
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
								    <%-- 版本 --%>
									 <c:import url="/kms/common/resource/ui/sysEditionMain_view.jsp"
										charEncoding="UTF-8">
										<c:param name="formName" value="kmsMultidocKnowledgeForm" />
									</c:import>
									 <!--   流程控制       -->
									<c:import url="/sys/workflow/include/sysWfProcess_edit.jsp"
										charEncoding="UTF-8">
										<c:param name="formName" value="kmsMultidocKnowledgeForm" />
										<c:param name="fdKey" value="mainDoc" />
									</c:import>	
								</table>
							</div>
						</div>
					</div>
				</div>	
								 
				<script>
					$KMSSValidation();
				</script>
			
				<div class="btns_box btns_box2 c">
				
				</div>
				<div class="clear"></div>
			</div>
		</div><!-- end content3 -->	
<br/>
		<div class="rightbar rightbar2">
			<div class="box3 m_t10" style="text-align:left">
				<div class="title1"><h2><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.docInfo" /></h2></div><!-- 文档信息 -->
				<div class="box2">
					<ul class="l_i m_t10" >
						<!-- 录入者 --><li><bean:message
							bundle="kms-multidoc"
							key="kmsMultidoc.inputUser" />：<c:out value="${kmsMultidocKnowledgeForm.docCreatorName}" /></li>
						<!-- 文档状态 --><li><bean:message
							bundle="kms-multidoc"
							key="kmsMultidoc.kmsMultidocKnowledge.docStatus" />：<sunbor:enumsShow value="${kmsMultidocKnowledgeForm.docStatus}" enumsType="common_status" /></li>
						<!-- 版本 --><li class="c"><strong><bean:message 
							bundle="sys-edition" 
							key="sysEditionMain.tab.label" />：V<c:out value="${kmsMultidocKnowledgeForm.docMainVersion}" />.<c:out value="${kmsMultidocKnowledgeForm.docAuxiVersion}" /></strong>
						<!-- 最后更新者 --><li><bean:message
							bundle="kms-multidoc"
							key="kmsMultidoc.lastUpdateUser" />：<span><c:out value="${kmsMultidocKnowledgeForm.docAlterorName}" /></span></li>
						<!-- 最后更新时间 --><li><bean:message
							bundle="kms-multidoc"
							key="kmsMultidoc.lastUpdateTime" />：<c:out value="${kmsMultidocKnowledgeForm.docAlterTime}" /></li>
					</ul>
				</div>
			</div>

			 
		</div><!-- end  rightbar-->
		<div class="clear"></div>
	</div><!-- main end -->
<!-- 校验代码生成语句-->
</html:form>
 <div id= "buttonBarDiv"  class="btns_box" >
     <!-- 按钮显示控制 -->
                 <div class="btn_a" style="float:right">	
					<a href="javascript:void(0)" title="关闭" onclick="closeThisWindow();"><span><bean:message key="button.close"/></span></a>
				    </div>
				 <logic:equal
					name="kmsMultidocKnowledgeForm"
					property="method_GET"
					value="add">
					<kmss:windowTitle
						subjectKey="kms-multidoc:kmsMultidoc.create.title"
						moduleKey="kms-multidoc:table.kmdoc" />
					 <div class="btn_a" style="float:right">	
				 	 <a href="javascript:void(0)"  onclick="if(checkCategory()) commitMethod('save','false');" title="提交">
							<span><bean:message key="button.submit"/></span></a>
					 </div>
					 <div class="btn_a" style="float:right">	
					 <a href="javascript:void(0)"   onclick="if(checkCategory()) commitMethod('save','true');" title="暂存">
							<span><bean:message key="kmsMultidoc.button.savedraft" bundle="kms-multidoc"/></span></a>
					 </div>	
				</logic:equal>
				  <logic:equal
						name="kmsMultidocKnowledgeForm"
						property="method_GET"
						value="edit">
						<kmss:windowTitle
							subject="${kmsMultidocKnowledgeForm.docSubject}"
							moduleKey="kms-multidoc:table.kmdoc" />
						<c:if test="${kmsMultidocKnowledgeForm.docStatusFirstDigit<'3'}">
						   <div class="btn_a" style="float:right">	
							<a href="javascript:void(0)" onclick="if(checkCategory()) commitMethod('update','false');" title="提交">
							<span><bean:message key="button.submit"/></span></a>	
							</div>
						</c:if>
						
						<c:if test="${kmsMultidocKnowledgeForm.docStatusFirstDigit=='1'}">
						<div class="btn_a" style="float:right">	
							<a href="javascript:void(0)" onclick="if(checkCategory()) commitMethod('update','true');" title="暂存">
							<span><bean:message key="kmsMultidoc.button.savedraft" bundle="kms-multidoc"/></span></a>
						</div>
						</c:if>
						
						<c:if test="${kmsMultidocKnowledgeForm.docStatusFirstDigit>='3'}">
						<div class="btn_a" style="float:right">	
							<a href="javascript:void(0)" onclick="if(checkCategory()) Com_Submit(document.kmsMultidocKnowledgeForm, 'update');" title="提交">
							<span><bean:message key="button.submit"/></strong></span></a>
						</div>	 
						</c:if>
					</logic:equal> 
					
    	 
 </div>
<html:javascript
	formName="kmsMultidocKnowledgeForm"
	cdata="false"
	dynamicJavascript="true"
	staticJavascript="false" />
</div>
 
<%@ include file="kmsMultidocKnowledge_edit_script.jsp"%>
<%@ include file="/kms/common/resource/jsp/include_kms_down.jsp" %>