<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<%@ include file="/sys/ftsearch/search_ui_js.jsp"%>
<title>${ lfn:message('sys-ftsearch-db:search.moduleName.all')}</title>
</head>
<body>
<% 
   List fieldList = (ArrayList)request.getAttribute("fieldList");
%>

<form id="sysFtsearchReadLogForm" name="sysFtsearchReadLogForm"  action="<c:url value="/sys/ftsearch/expand/sys_ftsearch_read_log/sysFtsearchReadLog.do?method=save" />" method="post" target="_blank">
<input id="fdDocSubject" name="fdDocSubject" type="hidden">
<input id="fdModelName" name="fdModelName" type="hidden">
<input id="fdCategory" name="fdCategory" type="hidden">
<input id="fdUrl" name="fdUrl" type="hidden">
<input id="fdSearchWord" name="fdSearchWord" type="hidden">
<input id="fdHitPosition" name="fdHitPosition" type="hidden">
<input id="fdModelId" name="fdModelId" type="hidden">
</form>

<%--范围个数--%>
<input type='hidden'  name ='entriesDesignCount'  value='${entriesDesignCount}' />
<input type="hidden" name="modelName" value="${fn:escapeXml(param.modelName)}" />
<input type="hidden" name="searchFields" value="${fn:escapeXml(param.searchFields)}" />
<input type='hidden'  name ='entriesDesignCount'  value='${entriesDesignCount}' />
<input type="hidden" name="multisSysModel" value='${multisSysModel}'/>
<input type="hidden" name="modelGroup" value="${modelGroup}" />
<input type="hidden" name="modelGroupChecked" value="${modelGroupChecked}" />
<input type="hidden" name="category"  value="${category}" />
<%if(request.getAttribute("EsError")!=null){%>
	<script>
		 seajs.use('lui/dialog', function(dialog) {
			 dialog.alert("请检查统一搜索服务是否启动？若启动请检查admin.do统一搜索配置的集群名是否正确，和统一搜索服务集群名要一致。");
		 });
	</script>
<%}%>
<div id="search_wrapper">
	<div id="search_head">
		<div class="box c" style="margin-left:170px">
			<a href="#" class="logo" title=""></a>
			<ul class="search_box">
				<li class="search">
					<input type="text" class="input_search" name="queryString" value="${queryString}"
						id="q5" onkeydown="if (event.keyCode == 13 && this.value !='') CommitSearch(0);">
					<script>
			   			$(function() {
						     $("#q5").autocomplete({
						         source: function(request, response) {
						             $.ajax({
						                 url: "${KMSS_Parameter_ContextPath}sys/ftsearch/expand/sys_ftsearch_chinese_legend/sysFtsearchChineseLegend.do?method=searchTip&q="+encodeURI($("#q5").val()),
						                 dataType: "json",
						                 data: request,
						                 success: function(data) {
						                     response(data);
						                 }
						             });
						         }
						     });
						 });
					</script>
					<a style="height:33px;cursor:pointer;" class="btn_search" onclick="CommitSearch(0);" title="${lfn:message('sys-ftsearch-db:search.ftsearch.button.search')}">
						<span>${lfn:message('sys-ftsearch-db:search.ftsearch.button.search')}</span>
					</a>
				</li>
				<li>
					<c:if test="${not empty modelGroupList}">
						<c:forEach items="${modelGroupList}" var="element" varStatus="status">
							<label for="">
								<input id='${element.fdId }' type="checkbox" value="${element.fdCategoryName}" name="modelGroups"
								onclick="selectModelGroup(this,'${element.fdCategoryModel}')" 
									<c:if test="${fn:contains(modelGroupChecked, element.fdCategoryName)}">
										checked
									</c:if>
								>${element.fdCategoryName}
							</label>
						</c:forEach>	
					</c:if>
				</li>
				<li style="text-align: left">
					<label for="">
						<input id='EKP'
								type="checkbox" name="sysName" onclick="selectAllModel(this,'checkbox_model')">
									EKP
					</label>
					<c:forEach items="${sysNameList}" var="sysNames" varStatus="status">
						<label for="">
						<input 
								type="checkbox" name="sysName" onclick="selectAllModel(this,'${sysNames }')"
								>${sysNames }
						</label>
					</c:forEach>
					<label for="">
						<a  href="#" onclick="showCheckModel()">更多>></a>
					</label>
				</li>	
			</ul>
			<div>
				<input type="button" class="btn_return" onclick="window.location.href='${KMSS_Parameter_ContextPath}'" value="${lfn:message('sys-ftsearch-db:search.ftsearch.search.return')}"/>
			</div>
		</div>
	</div><!-- search_head end -->
	<div id="search_main" class="c">
		<div class="search_left">
			<dl class="dl_b" id="search_by_field">
				<dt>${ lfn:message('sys-ftsearch-db:search.ftsearch.search.fields')}</dt>
			     <dd>
					<label for="">
						<input id='type_title'
							type="checkbox" name="search_field" onclick="searchByField()"
							<% if(fieldList==null || fieldList.contains("title")) { %>
									checked
							<% } %>
							 >${lfn:message('sys-ftsearch-db:search.ftsearch.field.title')}
					</label>
				</dd>
				<dd>
					<label for="">
						<input id='type_content'
							type="checkbox" name="search_field" onclick="searchByField()"
							<% if(fieldList==null || fieldList.contains("content")) { %>
									checked
							<% } %>>${lfn:message('sys-ftsearch-db:search.ftsearch.field.content')}
					</label>
				</dd>
				<dd>
					<label for=""> 
						<input id='type_attachment'
							type="checkbox" name="search_field" onclick="searchByField()"
							<% if(fieldList==null || fieldList.contains("attachment")) { %>
									checked
							<% } %>>${lfn:message('sys-ftsearch-db:search.ftsearch.field.attachment')}
					</label>
				</dd>
				<dd>
					<label for="">
						<input id='type_creator'
							type="checkbox" name="search_field" onclick="searchByField()"
							<% if(fieldList==null || fieldList.contains("creator")) { %>
									checked
							<% } %>>${lfn:message('sys-ftsearch-db:search.ftsearch.field.creator')}
					</label>
				</dd>
				<dd>
					<label for="">
						<input id='type_tag'
							type="checkbox" name="search_field" onclick="searchByField()"
							<% if(fieldList==null || fieldList.contains("tag")) { %>
									checked
							<% } %>>${lfn:message('sys-ftsearch-db:search.ftsearch.field.tag')}
					</label>
				</dd>
			</dl>
		</div><!-- end search_left -->
	<div id="search_main" class="c">
	
	<div id="search_range" class="search_range" style="display:none;margin-left:180px" >
	<p><bean:message key="search.ftsearch.search.range" bundle="sys-ftsearch-db" /></p>
			<ul id="hidden_div" class="ul1">
				<li id="selectLi"  class="li_opt">
					<a style="cursor:pointer;" class="btn_c" onclick="CommitSearch(2);">
					<span><em><bean:message key="search.ftsearch.confirm" bundle="sys-ftsearch-db" />
					</em></span></a>
				</li>
				<li class="li_range c" style="border-bottom:none">
				<h3>EKP：</h3>
					<ul id="model_view" name="model_view" style="display:none" class="ul2">
						<c:forEach items="${entriesDesign}" var="element" varStatus="status">
							<c:if test="${element['flag']==true}">
									<li> 
										<label for="">
											${element['title']}
										</label>
									 </li>
							</c:if> 
						</c:forEach>
					</ul>
					<ul id="model_select" name="model_select" class="ul2" >
						<c:forEach items="${entriesDesign}" var="element" varStatus="status">
									<li>
										<label for="">
											<input id='element${status.index}' type="checkbox" name="checkbox_model"
											<c:if test="${element['flag']==true}">
											checked
											</c:if> 
											 onclick="selectOutSystemModel('checkbox_model')"  value='${element['modelName']}'>${element['title']}</label>
									 </li>
						</c:forEach>		
					</ul>
					<div class="clear"></div>
				</li>
				
				<c:forEach items="${otherSysDesign}" var="sysDesigns" varStatus="status">
					<li class="li_range c" style="border-bottom:none">
						<h3>
							<c:forEach items="${sysNameList}" var="sysNames" varStatus="status2">
								<c:if test="${status.index==status2.index}">
											${sysNames }：
									<input type="hidden" id="${sysNames}_systemName" value="" name = 'systemName'>		
								</c:if> 
							</c:forEach>
						</h3>
						<ul name="multiSysmodel_view" style="display:none" class="ul2">
							<c:forEach items="${sysDesigns}" var="sysDesign" varStatus="status">
								<c:if test="${sysDesign['flag']==true}">
										<li>
											<label for="">
												${sysDesign['title']}
											</label>
										 </li>
								</c:if> 
							</c:forEach>
						</ul>
						<ul name="multiSysmodel_select" class="ul2" >
							<c:forEach items="${sysDesigns}" var="sysDesign" varStatus="status">
										<li>
											<label for="">
												<input id="${sysDesign['system'] }${status.index}" onclick="selectOutSystemModel('${sysDesign['system']}')" type="checkbox" name="${sysDesign['system'] }"
												<c:if test="${sysDesign['flag']==true}">
												checked
												</c:if> 
												 value='${sysDesign['modelName']}'>${sysDesign['title']}</label>
										 </li>
							</c:forEach>		
						</ul>
						
						<div class="clear"></div>
					</li>
				</c:forEach>
			</ul>
		</div>

		<div class="clear"></div>
	</div><!-- search_main end -->
</div>
<%@ include file="/sys/portal/template/default/footer.jsp"%>
</div>
</body>
</html>