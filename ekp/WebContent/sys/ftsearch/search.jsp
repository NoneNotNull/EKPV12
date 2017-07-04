<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.ftsearch.config.LksField,
	java.util.List,
	java.util.ArrayList,
	java.util.Iterator,
	com.landray.kmss.sys.ftsearch.search.LksHit,
	java.util.Map,
	com.landray.kmss.util.ResourceUtil,
	com.landray.kmss.sys.config.dict.SysDataDict,
	com.landray.kmss.util.StringUtil,
	com.landray.kmss.sys.ftsearch.util.ResultModelName,
	com.landray.kmss.sys.ftsearch.search.AdvancedSearchIndex,
	com.sunbor.web.tag.Page,
	com.landray.kmss.sys.ftsearch.util.HtmlEscaper,
    java.util.regex.Matcher,
    java.util.regex.Pattern"
%>

<%@ include file="/resource/jsp/htmlhead.jsp"%>
<!--[if IE 6]>
<script src="js/DD_belatedPNG.js"></script>
<script>
    DD_belatedPNG.fix('div,a,span,h1'); /* EXAMPLE */
    /* string argument can be any CSS selector */
    /* using .png_bg example is unnecessary */
    /* change it to what suits you! */
</script>
<![endif]--> 

<script type="text/javascript">
//Com_IncludeFile("ftsearch.css", "style/common/ftsearch/");
//Com_IncludeFile("ftsearch_result.css", "style/"+Com_Parameter.Style+"/ftsearch/");
Com_IncludeFile("optbar.js|list.js");
Com_IncludeFile("attachment.js","${KMSS_Parameter_ContextPath}sys/attachment/js/","js",true);
Com_SetWindowTitle('<bean:message bundle="sys-ftsearch-db" key="search.moduleName" />');
Com_IncludeFile("treeview.js");
Com_IncludeFile("docutil.js|doclist.js|dialog.js|optbar.js|data.js"); 
//Com_IncludeFile("tag_search_main.css", "style/"+Com_Parameter.Style+"/tag/"); 
</script>

<link href="styles/public.css" rel="stylesheet" type="text/css" />

<script> 

		var sortType;
		var tagCubeOpen;
		var tagCubeLarge;
		var tagName="";
		var xml=""; 
		var isSearchByButton="false";
		var modelDivExpand;

		function getUrlParameter() {
			var UrlPara="";
			var modelName = document.getElementsByName("modelName")[0].value;
			var searchFields = document.getElementsByName("searchFields")[0].value;
			//if(queryString!=null && queryString!="")
			//	UrlPara += "&queryString=" + queryString; 
			if(modelName!=null && modelName!="")
				UrlPara += "&modelName=" + modelName; 
			if(searchFields!=null && searchFields!="")
				UrlPara += "&searchFields=" + searchFields; 
			//if(timeRange!=null && timeRange!="")
			//	UrlPara += "&timeRange=" + timeRange; 
			//if(sortType!=null && sortType!="")
			//	UrlPara += "&sortType=" + sortType; 
			if(tagCubeOpen!=null && tagCubeOpen!="")
				UrlPara += "&tagCubeOpen=" + tagCubeOpen; 
			if(tagCubeLarge!=null && tagCubeLarge!="")
				UrlPara += "&tagCubeLarge=" + tagCubeLarge; 
			if(modelDivExpand!=null && modelDivExpand!="")
				UrlPara += "&modelDivExpand=" + modelDivExpand;
			UrlPara += "&isSearchByButton=" + isSearchByButton;
			return UrlPara;
		
		}


		//选择搜索字段
		function selectField(){
			var fields="";  
			if(document.getElementById("type_title").checked) {
				fields+="title;";
			}
			if((document.getElementById("type_content")).checked) {
				fields+="content;";
			}
			if(document.getElementById("type_attachment").checked) {
				fields+="attachment;";
			}
			if(document.getElementById("type_creator").checked) {
				fields+="creator;";
			}
			if(document.getElementById("type_tag").checked) {
				fields+="tag;";
			}
			if(fields!=""){
				fields=fields.substring(0,fields.length-1);
		 	}
			document.getElementsByName("searchFields")[0].value= fields;
		}
		
		//检测输入内容不许为空
		function checkQueryString(obj)
		{
		 if(obj.value==""){//请输入内容
			alert("<bean:message bundle='sys-tag' key='sysTag.inputContent' />");
			obj.focus();
			return false;
		 }
		 if(obj.value.length > 100){
			 alert("<bean:message key='search.ftsearch.overlength' bundle='sys-ftsearch-db' />");
			 obj.focus();
			 return false;
		 }
		    return true;
		}

		//搜索按钮提交
		
		function CommitSearch(queryStringPos){
			var outmodel = selectOutModelInfo();
			var modelGroupChecked = document.getElementsByName("modelGroupChecked")[0].value;
			if(queryStringPos==0 || queryStringPos==1) {
				isSearchByButton="true";
				var queryStringObj =document.getElementsByName("queryString")[queryStringPos];//搜索内容 
			 	if(!checkQueryString(queryStringObj)){//如果搜索内容为空 则不进行搜索
				       return null;
			 	}
			 	var queryString = encodeURIComponent(queryStringObj.value);
			 	
			 	window.location.href="<c:url value='/sys/ftsearch/searchBuilder.do?method=search&queryString=' />"+queryString + getUrlParameter()+"&outModel="+outmodel+"&modelGroupChecked="+modelGroupChecked;  
			}
			else {
				var queryString=Com_GetUrlParameter(window.location.href, "queryString");
				if(queryString==null || queryString=="") 
					queryString = document.getElementsByName("queryString")[0].value;
				if(queryString==null || queryString=="") 
					return null;
				else{
					queryString = encodeURIComponent(queryString);
					window.location.href="<c:url value='/sys/ftsearch/searchBuilder.do?method=search&queryString=' />"+queryString + getUrlParameter()+"&outModel="+outmodel+"&modelGroupChecked="+modelGroupChecked; 
				}
			}
		}

		//外部系统模块
		function selectOutSystemModel(system){
			var modelName="";  
			var flag=true;
			var checkbox_models = document.getElementsByName(system);
			//循环勾选
			for(var i=0;i<checkbox_models.length;i++){
				if( checkbox_models[i].checked){
					modelName+=checkbox_models[i].value+";"; 
				}
			}
			if(modelName!=""){
				modelName=modelName.substring(0,modelName.length-1);
			}
			if(system == 'checkbox_model'){
				document.getElementsByName("modelName")[0].value= modelName;
			}else{
				document.getElementById(system+'_systemName').value = modelName;
				var modelStr = "";
				var hiddenDiv = document.getElementById("hidden_div");
				var allUl = hiddenDiv.getElementsByTagName("ul");
				for(var i = 0 ; i < allUl.length;i++){
					if(allUl[i].getAttribute("name") == "multiSysmodel_select"){
						var inputModel = allUl[i].getElementsByTagName("input");
						for(var j=0,k=0; j<inputModel.length; j++) {
							if(inputModel[j].checked) {
								modelStr += inputModel[j].value+";";
							}
						}
					}	
				}
				if(modelStr!=""){
					modelStr=modelStr.substring(0,modelStr.length-1);
				}
				document.getElementsByName("multisSysModel")[0].value= modelStr;
			}
		}
		
		//所有外部模块信息
		function selectOutModelInfo(){
			return document.getElementsByName("multisSysModel")[0].value;
		}
		
		//选择模块
		function selectModel(element){
			var modelName="";  
			var flag=true;
			var entriesDesignCount=document.getElementsByName("entriesDesignCount")[0].value;
				//循环勾选
				for(var i=0;i<entriesDesignCount;i++){
					if( document.getElementsByName("element"+i)[0].checked){
						modelName+=document.getElementsByName("element"+i)[0].value+";"; 
					}
				}	 
			 	if(modelName!=""){
					modelName=modelName.substring(0,modelName.length-1);
			 	}
				document.getElementsByName("modelName")[0].value= modelName;
		}

		//模块全选
		function selectAllModel(allModelObj,system) {
			var isChecked = allModelObj.checked;
			var check;
			if(isChecked)
				check = 'checked'; 
			else
				check = ''; 
			var checkbox_models = document.getElementsByName(system);
			for(var i=0; i<checkbox_models.length; i++) {
				checkbox_models[i].checked = check;
			}
			//selectModel();
			selectOutSystemModel(system);
		}

		// 获取所有已选择的模块
		function getAllSelectedModel() {
			var checkbox_models = document.getElementsByName("checkbox_model");
			var modelTitleString = new Array();
			for(var i=0,j=0; i<checkbox_models.length; i++) {
				if(checkbox_models[i].checked) {
					modelTitleString[j] = checkbox_models[i].parentNode.innerText||checkbox_models[i].parentNode.textContent;
					j++;
				}
			}
			return modelTitleString;
		}
		
		// 获取所有已选择的模块
		function getAllSelectedModel(name) {
			var checkbox_models = document.getElementsByName(name);
			var modelTitleString = new Array();
			for(var i=0,j=0; i<checkbox_models.length; i++) {
				if(checkbox_models[i].checked) {
					modelTitleString[j] = checkbox_models[i].parentNode.innerText||checkbox_models[i].parentNode.textContent;
					j++;
				}
			}
			return modelTitleString;
		}

		function modelGroupChecked(){
			var modelGroupChecked = "";
			var modelGroups = document.getElementsByName("modelGroups");
			for(var i=0; i<modelGroups.length; i++) {
				if(modelGroups[i].checked){
					modelGroupChecked += modelGroups[i].value+";";
				}
			}
			document.getElementsByName("modelGroupChecked")[0].value= modelGroupChecked;
		}

		// 切换模块选择栏的视图
		function view_select_model() {
			var selectLi = document.getElementById("selectLi");
			var model_view = document.getElementById("model_view");
			var model_select = document.getElementById("model_select");
			
			var hiddenDiv = document.getElementById("hidden_div");
			var allUl = hiddenDiv.getElementsByTagName("ul");
		
			if(selectLi.style.display=="none") {
				modelDivExpand = "true";
				selectLi.style.display = "";
				model_view.style.display = "none";
				model_select.style.display = "";
				
				for(var i = 0 ; i < allUl.length;i++){
					if(allUl[i].getAttribute("name") == "multiSysmodel_select"){
						allUl[i].style.display = "";
					}
					if(allUl[i].getAttribute("name") == "multiSysmodel_view"){
						allUl[i].style.display = "none";
					}
				}
			}
			else {
				modelDivExpand = "false";
				selectLi.style.display = "none";
				model_select.style.display = "none";
				
				var modelTitleString = getAllSelectedModel("checkbox_model");
				if(modelTitleString.length > 0 ) {
					var liObj;
					var labelObj;
					while(model_view.hasChildNodes()){
						model_view.removeChild(model_view.firstChild);
				    }	
				    	
					for(var i=0;i<modelTitleString.length;i++) {
						liObj = document.createElement("li");//li创建成功  
						labelObj = document.createElement("label");
						$(labelObj).text(modelTitleString[i]);
						liObj.appendChild(labelObj);
						model_view.appendChild(liObj);
					}
					model_view.style.display = "";
				}
				
				for(var i = 0 ; i < allUl.length;i++){
				
					if(allUl[i].getAttribute("name") == "multiSysmodel_select"){
						allUl[i].style.display = "none";
						
						var inputModel = allUl[i].getElementsByTagName("input");
						var sysModelTitleString = new Array();
						for(var j=0,k=0; j<inputModel.length; j++) {
							if(inputModel[j].checked) {
								sysModelTitleString[k] = inputModel[j].parentNode.innerText||inputModel[j].parentNode.textContent;
								k++;
							}
						}
						if(sysModelTitleString.length > 0 ) {
							var sysliObj;
							var syslabelObj;
							while(allUl[i-1].hasChildNodes()){
								allUl[i-1].removeChild(allUl[i-1].firstChild);
						    }	
							for(var n=0;n<sysModelTitleString.length;n++) {
								sysliObj = document.createElement("li");//li创建成功  
								syslabelObj = document.createElement("label");
								$(syslabelObj).text(sysModelTitleString[n]);
								sysliObj.appendChild(syslabelObj);
								allUl[i-1].appendChild(sysliObj);
							}
							allUl[i-1].style.display = "";
						}
					}
				}
			}
		//	selectLi.focus();
		}
		
		
		//多系统模块分类
		function selectModelGroup(obj,model){

			var isChecked = obj.checked;
			var check;
			if(isChecked)
				check = 'checked'; 
			else
				check = ''; 
			
			var arrs=model.split("%");
			for(var i = 0 ; i < arrs.length ; i++){
				var modelInfo = new Array();
				if(arrs[i].indexOf(":")!= -1)	{
					  modelInfo = arrs[i].split(":");
				}
				else{
					modelInfo[0] = 'checkbox_model';
					modelInfo[1] = arrs[i];
				}
				var checkbox_models = document.getElementsByName(modelInfo[0]);
				for(var j=0; j<checkbox_models.length; j++) {
					 var start = checkbox_models[j].value.indexOf("@");
					 var checkValue;
					 if(start == -1){
						 checkValue=checkbox_models[j].value;
					 }else{
					    checkValue=checkbox_models[j].value.substring(start+1,checkbox_models[j].value.length);
					 }
					 if(checkValue == modelInfo[1]){
						checkbox_models[j].checked = check;
					 }
				 }
				selectOutSystemModel(modelInfo[0]);
			}
			modelGroupChecked();
		}
		
		function showCheckModel(){
			var searchRange = document.getElementById("search_range");
			if(searchRange.style.display=="none") {
				document.getElementById("search_range").style.display = "";
			}else{
				document.getElementById("search_range").style.display = "none";
			}
			
		}
		
		function hiddenCheckModel(){
			var searchRange = document.getElementById("search_range");
			if(searchRange.style.display!="none") {
				document.getElementById("search_range").style.display = "none";
			}
		}

</script>
<script type="text/javascript" src="${KMSS_Parameter_ResPath}style/common/fileIcon/fileIcon.js"></script>
<%@ include file="/sys/ftsearch/autocomplete_include.jsp" %>
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
<input type="hidden" name="modelName" value="${param.modelName}" />
<input type="hidden" name="searchFields" value="${param.searchFields}" />
<input type='hidden'  name ='entriesDesignCount'  value='${entriesDesignCount}' />
<input type="hidden" name="multisSysModel" value='${multisSysModel}'/>
<input type="hidden" name="modelGroup" value="${modelGroup}" />
<input type="hidden" name="modelGroupChecked" value="${modelGroupChecked}" />


<div id="search_wrapper">
	<div id="search_head" style="margin-top:30px;margin: 0 auto;text-align:center;">
	<div style="width:990px;" >
				<a href="#" class="logo" title=""></a>
		<ul class="search_box" style="float:left" >
			<li class="search" style="margin-top:20px">
			<input type="text" class="input_search" name="queryString" value="" style="width:380px;height:33px;"
				id="q5" >
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
			<a style="height:33px;cursor:pointer;" class="btn_search" onclick="CommitSearch(0);" title="<bean:message key="search.ftsearch.button.search" bundle="sys-ftsearch-db" />">
			<span><bean:message key="search.ftsearch.button.search" bundle="sys-ftsearch-db" /></span>
			</a>	
			<!-- 
			<a style="height:33px;cursor:pointer;" class="btn_search" onclick="CommitSearch(0);" title="<bean:message key="search.ftsearch.button.search" bundle="sys-ftsearch-db" />">
			<span>高级搜索</span>
			</a>	 -->
			</li>
			
			<li style="text-align: left">
				<c:if test="${not empty modelGroupList}">
					<c:forEach items="${modelGroupList}" var="element" varStatus="status">
						<label for="">
							<input id='${element.fdId }' type="checkbox" value="${element.fdCategoryName}" name="modelGroups"
							onclick="selectModelGroup(this,'${element.fdCategoryModel}')" 
							>${element.fdCategoryName}
						</label>
					</c:forEach>	
				</c:if>
			</li>	
			
			<li style="text-align: left">
			<label for="">
			<input id='type_title'
					type="checkbox" name="search_field" onclick="selectField()"
					<% if(fieldList==null || fieldList.contains("title")) { %>
							checked
					<% } %>
					 ><bean:message key="search.ftsearch.field.title" bundle="sys-ftsearch-db" />
			</label>
			<label for="">
			<input id='type_content'
					type="checkbox" name="search_field" onclick="selectField()"
					<% if(fieldList==null || fieldList.contains("content")) { %>
							checked
					<% } %>><bean:message key="search.ftsearch.field.content" bundle="sys-ftsearch-db" />
			</label>
			<label for="">
			<input id='type_attachment'
					type="checkbox" name="search_field" onclick="selectField()"
					<% if(fieldList==null || fieldList.contains("attachment")) { %>
							checked
					<% } %>><bean:message key="search.ftsearch.field.attachment" bundle="sys-ftsearch-db" />
			</label>
			<label for="">
			<input id='type_creator'
					type="checkbox" name="search_field" onclick="selectField()"
					<% if(fieldList==null || fieldList.contains("creator")) { %>
							checked
					<% } %>><bean:message key="search.ftsearch.field.creator" bundle="sys-ftsearch-db" />
			</label>
			<label for="">
			<input id='type_tag'
					type="checkbox" name="search_field" onclick="selectField()"
					<% if(fieldList==null || fieldList.contains("tag")) { %>
							checked
					<% } %>><bean:message key="search.ftsearch.field.tag" bundle="sys-ftsearch-db" />
			</label>
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
	</div></div><!-- search_head end -->

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
	<%@ include file="/resource/jsp/footer.jsp"%>

</div>
</body>
</html>