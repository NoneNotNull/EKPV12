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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
<%@ include file="/sys/ftsearch/autocomplete_include.jsp" %>
<script type="text/javascript" src="${KMSS_Parameter_ResPath}style/common/fileIcon/fileIcon.js"></script>
<link href="styles/public.css" rel="stylesheet" type="text/css" />
<style type="text/css">
div dl dt a em{font-style:normal;color:red;font-weight:bold;}
dd div.summ  em{font-style:normal;color:red;font-weight:bold;}
</style>
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
		if(modelName!=null && modelName!="")
			UrlPara += "&modelName=" + modelName; 
		if(searchFields!=null && searchFields!="")
			UrlPara += "&searchFields=" + searchFields; 
		if(tagCubeOpen!=null && tagCubeOpen!="")
			UrlPara += "&tagCubeOpen=" + tagCubeOpen; 
		if(tagCubeLarge!=null && tagCubeLarge!="")
			UrlPara += "&tagCubeLarge=" + tagCubeLarge; 
		if(modelDivExpand!=null && modelDivExpand!="")
			UrlPara += "&modelDivExpand=" + modelDivExpand;
		UrlPara += "&isSearchByButton=" + isSearchByButton;

		UrlPara += getFilterParam();
		UrlPara += "&fwFlag="+"true";
		return UrlPara;
	}

	function getFilterParam(){
		var str = window.parent.submitFilterParam();
		//key value 过滤字段的字段名、过滤字段对应值，一一对应 
		var paramKey = str[0];
		var paramValue = str[1];
		var filterParamter = "";
		if(paramKey != "" && paramValue != ""){
			filterParamter = "&filterFields=" + paramKey +"&filterString="+paramValue;
		}
		
		return  filterParamter;
	}
	
	function readDoc(fdDocSubject,fdModelName,fdCategory,fdUrl,positionInPage) {
		document.getElementById("fdDocSubject").value=fdDocSubject;
		document.getElementById("fdModelName").value=fdModelName;
		document.getElementById("fdCategory").value=fdCategory;
		document.getElementById("fdUrl").value=fdUrl;
		document.getElementById("fdModelId").value=Com_GetUrlParameter(fdUrl, "fdId");
		var queryString = Com_GetUrlParameter(window.location.href, "queryString");
		document.getElementById("fdSearchWord").value=queryString;
		var pageno = Com_GetUrlParameter(window.location.href, "pageno");
		var rowsize = Com_GetUrlParameter(window.location.href, "rowsize");
		if(pageno==null || pageno=="")
			pageno=1;
		if(rowsize==null || rowsize=="")
			rowsize=10;
		var position = parseInt(pageno-1)*parseInt(rowsize) + parseInt(positionInPage) + 1;
		document.getElementById("fdHitPosition").value=position;
		var sysFtsearchReadLogForm = document.getElementById("sysFtsearchReadLogForm");
		
		sysFtsearchReadLogForm.submit();
		
		return null;	
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
		alert("<bean:message bundle='sys-ftsearch-db' key='ftsearch.select.queryString' />");
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
		var modelGroupChecked = document.getElementsByName("modelGroupChecked")[0].value;
		if(queryStringPos==0 || queryStringPos==1) {
			isSearchByButton="true";
			var queryStringObj =document.getElementsByName("queryString")[queryStringPos];//搜索内容 
		 	if(!checkQueryString(queryStringObj)){//如果搜索内容为空 则不进行搜索
			       return null;
		 	}
		 	var queryString = encodeURIComponent(queryStringObj.value);
		 	
		 	window.location.href="<c:url value='/sys/ftsearch/searchBuilder.do?method=search&queryString=' />"+queryString + getUrlParameter();  
		}
		else {
			var queryString=Com_GetUrlParameter(window.location.href, "queryString");
			if(queryString==null || queryString=="") 
				queryString = document.getElementsByName("queryString")[1].value;
			if(queryString==null || queryString=="") 
				queryString = document.getElementsByName("queryString")[0].value;
			if(queryString==null || queryString=="") 
				return null;
			else{
				queryString = encodeURIComponent(queryString);
				window.location.href="<c:url value='/sys/ftsearch/searchBuilder.do?method=search&queryString=' />"+queryString + getUrlParameter(); 
			}
		}
	}

	
	//结果排序
	function sortResult(sortType) {
		var url = Com_SetUrlParameter(window.location.href,"pageno",1);
		window.location.href = Com_SetUrlParameter(url,"sortType",sortType);
	}

	// 在结果中搜索
	function search_on_result() {
		
		var queryString=document.getElementsByName("queryString")[1];
		if(!checkQueryString(queryString)){//如果搜索内容为空 则不进行搜索
		       return false;
		}
		var modelGroupChecked = document.getElementsByName("modelGroupChecked")[0].value;
		var old_queryString = Com_GetUrlParameter(window.location.href, "queryString");

		var str_old = old_queryString.split(' ');
		var str_new = queryString.value.split(' ');
		for(var i = 0 ; i < str_old.length ; i++){
			for(var j = 0 ; j < str_new.length ; j++){
				if(str_old[i]==str_new[j]){
					alert("<bean:message bundle="sys-ftsearch-db"  key="search.ftsearch.existError1" />" +str_new[j]+ "<bean:message bundle="sys-ftsearch-db"  key="search.ftsearch.existError2" />");
					return false;
				}
			}
		}
		queryString = old_queryString + "&" + queryString.value;
		var url = Com_SetUrlParameter(window.location.href,"pageno",1)+"&outModel="+outmodel+"&modelGroupChecked="+modelGroupChecked;
		window.location.href = Com_SetUrlParameter(url,"queryString",queryString);
	}
	
	// 初始化摘要的展示
	function initSummary() {
		var rowsize = Com_GetUrlParameter(window.location.href, "rowsize");
		if(rowsize==null || rowsize=="")
			rowsize = "10";
		var rows = parseInt(rowsize);
		for(var i=0; i<rows; i++ ) {
			var summary = document.getElementById("summary_"+i);
			if(summary==null)
				break;
			if(summary.offsetHeight > 48) {
				summary.style.height = 48; 
				summary.style.overflow ="hidden";
				summary.style.cursor ="default";
				summary.setAttribute("ondblclick",expand);
			}
		}
	}

	// 摘要展开或收缩
	function expand() {
		var divObject = event.srcElement;
		document.selection.empty();
		//divObject.onselectstart= function() {return  false; };
		if(divObject.style.overflow =="visible" ) {
			divObject.style.overflow ="hidden";
			divObject.style.cursor ="default";
		}
		else if(divObject.style.overflow =="hidden" ) {
			divObject.style.overflow ="visible";
			divObject.style.cursor ="text";
		}
	}
	function isIE(){ //ie?
			   if (window.navigator.userAgent.toLowerCase().indexOf("msie")>=1)
			    return true;
			   else
			    return false;
			}

	if(!isIE()){ //firefox innerText define
	   HTMLElement.prototype.__defineGetter__(     "innerText",
	    function(){
	     var anyString = "";
	     var childS = this.childNodes;
	     for(var i=0; i<childS.length; i++) {
	      if(childS[i].nodeType==1)
	       anyString += childS[i].tagName=="BR" ? '\n' : childS[i].textContent;
	      else if(childS[i].nodeType==3)
	       anyString += childS[i].nodeValue;
	     }
	     return anyString;
	    }
	   );
	   HTMLElement.prototype.__defineSetter__(     "innerText",
	    function(sText){
	     this.textContent=sText;
	    }
	   );
	}

	function pagingShow(){
		var spans = document.getElementById("pagingTools");
		if(spans!=null){
			var aTags = spans.getElementsByTagName("a");
			if(aTags!=null && aTags.length>0){
				var status = aTags[aTags.length-2].innerHTML.indexOf("...");
				if(status == 0){
					aTags[aTags.length-2].style.display = "none";
				}
			}
		}
	}

	window.onload = function initCube() {
		initSummary();
		tagCubeOpen=Com_GetUrlParameter(window.location.href, "tagCubeOpen");
		tagCubeLarge=Com_GetUrlParameter(window.location.href, "tagCubeLarge");
		modelDivExpand=Com_GetUrlParameter(window.location.href, "modelDivExpand");
		if(tagCubeOpen=="true") {
			openCube();
		}
		
		if(modelDivExpand=="true") {
			view_select_model();
		}
		pagingShow();
	}

	//高级搜索
	function advancedSearchs(){ 
		var queryString=encodeURIComponent(document.getElementsByName("queryString")[0].value);
		if(document.getElementsByName("modelName")[0]){
			Com_OpenWindow(getAppendUrl()+"&modelName="+document.getElementsByName("modelName")[0].value+"&queryString="+queryString,"_blank");
		}else{
			Com_OpenWindow(getAppendUrl()+"&queryString="+queryString,"_blank");
		}	 
	}

	function getAppendUrl(){
		var url = '<c:url value="/sys/ftsearch/sys_ftsearch_result/sysFtsearchAdvanced.do" />?method=sysFtsearchAdvanced';
		return url;
	}

</script>
</head>
<body style="width:800px">
<% Page queryPage = (Page)request.getAttribute("queryPage");
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

<input type="hidden" id="" name="">
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
	<div id="search_head">
	<div class="box c" style="margin-left:170px;width:800px;">
		
		<ul class="search_box">
		<li class="range">
			<div style="width:450px">
			</div>
			</li>
			<li style="margin-left:60px">
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
			<li class="search">
			<input type="text" class="input_search" name="queryString" value="${queryString}" style="height:33px;width:440px;"
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
			</script><!-- -->
			<a style="height:33px;cursor:pointer;" class="btn_search" onclick="CommitSearch(0);" title="<bean:message key="search.ftsearch.button.search" bundle="sys-ftsearch-db" />">
			<span><bean:message key="search.ftsearch.button.search" bundle="sys-ftsearch-db" /></span>
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
		</ul>
	</div>
	</div><!-- search_head end 

	<div id="search_main" class="c">-->
		
	<c:if test="${queryPage==null || param.queryString==null}">
				<div class="" style="height: 500px; background:url(styles/images/bg_split.gif) repeat-y; border-bottom:1px solid #efefef;">
					
				</div>
	</c:if>

	<c:if test="${not empty queryPage && queryPage!=null}">
		<% if (queryPage.getTotalrows()==0){ %>	
			<c:if test="${ not empty mapSet['queryString']}" >
				<div class="" style="height: 500px">
					<ul class="search_none">
					
						<li><h3><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.sorry"/><span style="color: red">${queryString}</span><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.about" />
						</h3></li>
						<li><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.advice" /></li>
						<li><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.checkWrong" /></li>
						<li><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.deleteSome" /></li>
					</ul>
				</div>
			</c:if>
		<% }
		else  
		{ %>
		
		<div class="">
			<div class="search_main" style="min-height:500px; overflow:visible">
				<div class="search_result c">
					<ul class="btn_box">
						
						<li><a href="#" onclick="sortResult('time');"
						<c:if test="${param.sortType==null || param.sortType=='score'}">
						class="btn_a" 
						</c:if>
						<c:if test="${param.sortType=='time'}">
						class="btn_a_selected"
						
						</c:if>
						title=""><span><em><bean:message bundle="sys-ftsearch-db" key="search.ftsearch.sort.by.time" /></em></span></a></li>
						<li><a href="#" onclick="sortResult('score');"
						<c:if test="${param.sortType==null || param.sortType=='score'}">
						class="btn_a_selected" 
						
						</c:if>
						<c:if test="${param.sortType=='time'}">
						class="btn_a"
						</c:if>
						title=""><span><em><bean:message bundle="sys-ftsearch-db" key="search.ftsearch.sort.by.score" /></em></span></a></li>
					</ul>
					<p><bean:message bundle="sys-ftsearch-db" key="search.ftsearch.probably" />&nbsp;
						<%=queryPage.getTotalrows()%>&nbsp;<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.itemResult" />
					</p>
				</div><!-- end search_result -->	

				
				<div class="search_list">
					<%--如果查询有数据--%>
					<%--标题 时间 创建者 所属模块--%>
					<%for(int i=0;i<queryPage.getList().size();i++){
						LksHit lksHit = (LksHit)queryPage.getList().get(i);
						Map lksFieldsMap = lksHit.getLksFieldsMap();
						LksField link = (LksField)lksFieldsMap.get("linkStr");
						LksField title = (LksField)lksFieldsMap.get("title");
						LksField subject = (LksField)lksFieldsMap.get("subject");
						LksField content = (LksField)lksFieldsMap.get("content");
						LksField fileName = (LksField)lksFieldsMap.get("fileName");
					//	LksField fullText = (LksField)lksFieldsMap.get("fullText");
						LksField ekpDigest = (LksField)lksFieldsMap.get("ekpDigest");//附件摘要替换
						LksField juniorSummary = (LksField)lksFieldsMap.get("juniorSummary");
						LksField docKey = (LksField)lksFieldsMap.get("docKey");
						LksField mimeType = (LksField)lksFieldsMap.get("mimeType");
					
						String docInfo="";
						if(docKey != null){
							docInfo = docKey.getValue();
						}
						String linkArgu=null;
						if(docInfo.lastIndexOf("_")>-1)
							linkArgu=docInfo.substring(docInfo.lastIndexOf("_")+1);
						LksField keyword = (LksField)lksFieldsMap.get("keyword");
						LksField modelName = (LksField)lksFieldsMap.get("modelName");
						LksField category= (LksField)lksFieldsMap.get("category");
						LksField creator = (LksField)lksFieldsMap.get("creator");
						LksField createTime = (LksField)lksFieldsMap.get("createTime");  
						String linkUrl= "";
						if(link != null){
							linkUrl = link.getValue();
						}
						String mainDocLink = linkUrl;
						if(fileName!=null && StringUtil.isNotNull(linkArgu)){
							linkUrl+="&s_ftAttId=" + linkArgu;
						}
						request.setAttribute("mimeType",mimeType==null?"":mimeType.getValue()); 
						request.setAttribute("linkUrl",linkUrl); 
						request.setAttribute("mainDocLink",mainDocLink); 
						if(modelName != null){
							request.setAttribute("ResultModelName",ResultModelName.getModelName(modelName.getValue()));  
						}
						String fdDocSubject= "";
						String fdModelName= "";
						String fdCategory= "";
						String fdUrl= "";
						String fdSummary = "";
						String fdFileName = "";
						
						if(subject!=null) {
							fdDocSubject = subject.getValue();
						} else if(title!=null) {
							fdDocSubject = title.getValue();
						}else if(fileName!=null) {
							fdDocSubject = fileName.getValue();
						}
						if(modelName!=null) {
							fdModelName=modelName.getValue();
						}
						if(category!=null) {
							fdCategory=category.getValue();
						}
						if(link!=null) {
							fdUrl=linkUrl;
						}
						
						if(fileName!=null) {
							fdFileName=fileName.getValue();
						}
						
						if(content!=null) {
							fdSummary +=content.getValue();
						}
					//	if(fullText!=null) {
					//		fdSummary +=fullText.getValue();
					//	}
						if(ekpDigest!=null) {
							fdSummary +=ekpDigest.getValue();
						}
						
						//<[^(em)]+[^>]+[^(em)]{1}>
						String regEx_html="<[^>]+>"; //定义HTML标签的正则表达式
						Pattern p_html=Pattern.compile(regEx_html,Pattern.CASE_INSENSITIVE); 
				        Matcher m_html=p_html.matcher(fdDocSubject); 
				        fdDocSubject=m_html.replaceAll(""); //过滤html标签 
				        m_html=p_html.matcher(fdCategory); 
				        fdCategory=m_html.replaceAll("");
				        
				        m_html=p_html.matcher(fdModelName); 
				        fdModelName=m_html.replaceAll("");
				        
				        m_html=p_html.matcher(fdUrl); 
				        fdUrl=m_html.replaceAll("");
				        
				        m_html=p_html.matcher(mainDocLink); 
				        mainDocLink=m_html.replaceAll("");
				        
				     //   m_html=p_html.matcher(fdSummary); 
				      //  fdSummary=m_html.replaceAll("");
				        
				        //fdSummary = HtmlEscaper.escapeHTML(fdSummary);
				        //fdDocSubject = HtmlEscaper.escapeHTML2(fdDocSubject);
				        String fdTempTitle = HtmlEscaper.escapeHTML2(fdDocSubject);
				        //fdCategory = HtmlEscaper.escapeHTML(fdCategory);
				        // fdModelName = HtmlEscaper.escapeHTML(fdModelName);
				        //fdUrl = HtmlEscaper.escapeHTML(fdUrl);
					%> 
					<dl class="dl_c">
					<dt>
					<%if(fileName!=null){%>
			        	<script>
			        		document.write('<img src="${KMSS_Parameter_ResPath}style/common/fileIcon/'+GetIconNameByFileName('<%=fileName.getValue()%>')+'" height="16" width="16" border="0" />');
			        	</script>
		        	<%}%>
			        	<a href="#" onclick="readDoc('<%=fdTempTitle %>','<%=fdModelName %>','<%=fdCategory %>','<%=fdUrl %>','<%=i %>');" class="a_title"  >
			        	<%=subject!=null?subject.getValue():title!=null?title.getValue():fileName!=null?fileName.getValue():""%>
			        	</a>
		        	<%if(fileName!=null && link!=null){%>
		        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	<a href="#" onclick="readDoc('<%=fdTempTitle %>','<%=fdModelName %>','<%=fdCategory %>','<%=mainDocLink %>','<%=i %>');" class="a_view">
		        	<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.viewMainDoc" /></a>
		        	<%}%>
					</dt>
						<dd>
							<div id="summary_<%=i%>" class="summ">
								<%=fdSummary%>
							</div>
						</dd>
						<dd class="dd2">
							<bean:message bundle="sys-ftsearch-db" key="search.search.modelNames" />${ResultModelName}<span>|</span>
							<bean:message bundle="sys-ftsearch-db" key="search.search.creators" />
							<%if(creator!=null && request.getAttribute("escaperStr").equals(creator.getValue()))
							{ 
								out.println("<strong class = 'lksHit'>"+creator.getValue()+"</strong>");
							}else if(creator!=null)
							{ 
								out.println(creator.getValue());
							}%> 
							<span>|</span>
							<bean:message bundle="sys-ftsearch-db" key="search.search.createDates" /><%if(createTime!=null){	out.println(createTime.getValue());} %> 
						</dd>
					</dl>
					<%} %>
					
				</div><!-- end search_list -->
				
			</div>
			

			<div class="page">
				<!-- 翻页 -->
				<span id="pagingTools">
				<sunbor:page name="queryPage" pagenoText="pagenoText2" pageListSize="10" pageListSplit="">
					<sunbor:leftPaging><b><bean:message key="page.thePrev"/></b></sunbor:leftPaging>
					{11}
					<sunbor:rightPaging><b><bean:message key="page.theNext"/></b></sunbor:rightPaging>
				</sunbor:page>
				</span>
			</div>

			<div class="search_bottom" style="padding-left:50px; width:735px;height:33px">
				<input type="text" class="input_search" name="queryString" value="${queryString}" style="height:33px"
					id="q6" onkeydown="if (event.keyCode == 13 && this.value !='') CommitSearch(1);">
				<script>
	   			$(function() {
				     $("#q6").autocomplete({
				         source: function(request, response) {
				             $.ajax({
				                 url: "${KMSS_Parameter_ContextPath}sys/ftsearch/expand/sys_ftsearch_chinese_legend/sysFtsearchChineseLegend.do?method=searchTip&q="+encodeURI($("#q6").val()),
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
				<a style="height:33px;cursor:pointer;" class="btn_search" onclick="CommitSearch(1);" title="<bean:message key="search.ftsearch.button.search" bundle="sys-ftsearch-db" />">
					<span><bean:message key="search.ftsearch.button.search" bundle="sys-ftsearch-db" /></span>
				</a>
				
				<a style="cursor:pointer;" href="#" class="btn_b" title="<bean:message key="search.ftsearch.search.on.result" bundle="sys-ftsearch-db" />" onclick="search_on_result();"><span><em><bean:message key="search.ftsearch.search.on.result" bundle="sys-ftsearch-db" /></em></span></a>
			</div>
			
		</div><!-- end search_con -->
		<%} %>
		</c:if>
		
		<div class="clear"></div>

		
	<!--</div> search_main end -->
	
	<%@ include file="/resource/jsp/footer.jsp"%>

</div>
</body>
</html>