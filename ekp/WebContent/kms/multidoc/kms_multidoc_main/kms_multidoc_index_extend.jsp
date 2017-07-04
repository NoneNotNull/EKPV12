<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@page import="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"%>
<%@page import="java.util.List"%>
<%@ include file="kms_multidoc_index_js_extend.jsp" %>
	<div id="main" class="box c">
		<div class="leftbar" >
			<div class="iMenu" style="padding-left:30px">
				<div class="menuTit"><h2><a href="javascript:docListPage('${param.templateId }');">${empty templateName? "知识分类":templateName}</a></h2></div>
				<div >
					<div id="accordian" s_bean="kmsDocknowledgeCategoryExtendPortlet" fdCategoryId="${param.templateId }">
					</div>	
				</div>
			</div>
		
		</div>
		<div class="content2">
			<div class="location"><a href="javascript:void(0)" onclick="gotoIndex();return false;" class="home" title="首页">首页</a>&gt;<a href="javascript:void(0)" onclick='gotoMultidocCenter();return false;' title="知识中心">知识中心</a>&gt; 
			<a  href="javascript:void(0)"  onclick="gotoFilter();return false;">${filterTypeName}</a>${kmsMultidocPath}</div>
			
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
							requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
							requestMethod="GET">
							<div class="btn_a">	
								<a onclick="deleteDoc()"   href="javascript:void(0)"><span>删除</span></a>
							</div>
					    </kmss:auth>
						 <kmss:auth 
							 requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=templateChange"
								requestMethod="GET">
						<div class="btn_a">				
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
	</div><!-- main end -->
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 