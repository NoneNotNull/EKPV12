<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@page import="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"%>
<%@page import="java.util.List"%>
<%@ include file="kms_multidoc_index_js.jsp" %>
	<div id="main" class="box c">
		<div class="content3">
			<div class="location"><a href="javascript:void(0)" onclick="gotoIndex();return false;" class="home" title="首页">首页</a>&gt;<a href="javascript:void(0)" onclick='gotoMultidocCenter();return false;' title="知识中心">知识中心</a>&gt; 
			<a  href="javascript:void(0)"  onclick="gotoFilter();return false;">${filterTypeName}</a>${kmsMultidocPath}</div>
			<c:if test="${hasTemplate=='true' }">
			<div class="r_a m_t10">
				<div class="t_l"></div><div class="t_r"></div><div class="b_l"></div><div class="b_r"></div>	
				<div class="r_con c" id='templates'>
					
					<div class="text_list" style="width: 650px;">
					<c:if test="${empty docTemplateList}">
							该分类下没有子类！
					</c:if>
					<c:if test="${not empty docTemplateList}">
					<c:forEach items="${docTemplateList}" var="kmsDocTemplateMap" varStatus="varStatus">
						 <c:if test="${hasTemplate=='true'}">
							 <a id="${kmsDocTemplateMap.value}" title="${kmsDocTemplateMap.text}"  href='javascript:void(0)' onclick="window.open('<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&templateId=${kmsDocTemplateMap.value}&templateText=${kmsDocTemplateMap.text}" />','_self');return false;">
						 </c:if>
						 <c:if test="${hasTemplate=='false'}">
							 <a id="${kmsDocTemplateMap.value}" title="${kmsDocTemplateMap.text}"  href='javascript:void(0)' onclick="window.open('<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&filterConfigId=${filterConfigId}&optionId=${kmsDocTemplateMap.value}&templateText=${kmsDocTemplateMap.text}" />','_self');return false;">
						 </c:if>
							    <nobr><script language='javascript'>
								     document.write(getShortName("${kmsDocTemplateMap.text}"));
								</script>
							 <span><img src="${kmsContextPath}resource/style/common/images/loading.gif" border="0" /></span></nobr></a>  
					</c:forEach> 
					 </c:if>  
					</div>		
				</div>
			</div><!-- end r_a -->
			</c:if>
			
			<input type=hidden name="hasTemplate" value="${hasTemplate}"  id="hasTemplate"/> 
			<input type=hidden name="templateId" value="${templateId}"  id="templateId"/>
			<input type=hidden name="filterConfigId" value="${filterConfigId}"  id="filterConfigId"/>
			<!--扩展属性筛选器filter-->
			<div id="propFilter" ></div>
            
			<div class="m_t30" style="zoom:1;">
				<div class="title2 m_t10 c">
					<h2 class="h2_2">${templateName }</h2>
					<div class="btns_box">
						<kmss:auth
							requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add&fdTemplateId=${param.templateId}"
							requestMethod="GET">
							<div class="btn_a"><a onclick="showSelectTemplate('addDoc')" href="javascript:void(0)"><span>新建</span></a></div>
						</kmss:auth>
						<kmss:auth
							requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=deleteall&status=${param.status}&categoryId=${param.templateId}&nodeType=${param.nodeType}"
							requestMethod="GET">
							<div class="btn_a">	
								<a onclick="deleteDoc()"   href="javascript:void(0)"><span>删除</span></a>
							</div>
					    </kmss:auth>
					    <kmss:auth
								requestURL="/sys/right/rightDocChange.do?method=docRightEdit&modelName=com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge&categoryId=${param.templateId}"
								requestMethod="GET">
							<div class="btn_a" id="changeRightAll">				
								 <a href="javascript:void(0)" onclick="changeRightAll();" title="权限变更">
								 <span><bean:message bundle="kms-multidoc" key="kmsMultidoc.button.changeRight" /></span></a>
							</div>
						</kmss:auth>
					    
						 <kmss:auth 
							 requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=templateChange&categoryId=${param.templateId}"
								requestMethod="GET">
						<div class="btn_a"  id="changeTemp">				
						 <a href="javascript:void(0)" onclick="changeTemp();" title="分类转移">
								 <span><bean:message key="sysSimpleCategory.chg.button" bundle="sys-simplecategory"/></span></a>
						</div>		 
						</kmss:auth>	
					    <kmss:auth
							requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=editPropertys&templateId=${param.templateId}"
							requestMethod="GET">
						<div class="btn_a" id="editProperty">				
						 <a href="javascript:void(0)" onclick="editProperty();" title="属性修改">
								 <span><bean:message key="button.chengeProperty" bundle="kms-multidoc"/></span></a>
						</div>		 
						</kmss:auth>	
					    <div class="btn_a"><a title="组合查询" href="javascript:void(0)" onclick='searchCombine();return false;'><span>组合查询</span></a></div>
					</div>
				</div>
				
				<div class="km_list" id='kmsDocList'>
				</div>

				<!-- end 分页-->	
			</div>
		</div><!-- end content3 -->	

		<div class="rightbar">
		
			<kms:portlet id="kmsLatestPortlet" cssClass="box3" title="最新知识文档" template="portlet_doc_index_latest_tmpl" dataType="Bean" dataBean="kmsMultidocKnowledgePreXMLService" beanParm="{listType:\"latest\"}"></kms:portlet>
			
			<kms:portlet id="kmsHotPortlet" cssClass="box3 m_t10" title="最热知识文档" template="portlet_doc_index_hot_tmpl" dataType="Bean" dataBean="kmsMultidocKnowledgePreXMLService" beanParm="{listType:\"hot\"}"></kms:portlet>
			
		</div><!-- end  rightbar-->
	</div><!-- main end -->
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 