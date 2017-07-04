<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.landray.kmss.sys.ftsearch.config.LksField,
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
    java.util.regex.Pattern"%>
<script type="text/javascript"
	src="${KMSS_Parameter_ResPath}style/common/fileIcon/fileIcon.js"></script>
<%@ include file="/sys/ftsearch/autocomplete_include.jsp"%>
<link style="text/css" rel="stylesheet"
	href="${LUI_ContextPath}/sys/ftsearch/styles/search.css">
<link style="text/css" rel="stylesheet"
	href="${LUI_ContextPath}/sys/ftsearch/styles/zTreeStyle/zTreeStyle.css">
<script type="text/javascript" src="js/jquery.ztree.core-3.4.js"></script>
<script type="text/javascript" src="js/jquery.ztree.excheck-3.4.js"></script>
<script type="text/javascript"> 
		var sortType;
		var tagCubeOpen;
		var tagCubeLarge;
		var tagName="";
		var xml=""; 
		var isSearchByButton="false";
		var modelDivExpand;
		var newLUI="true";
		var facetClickPara="false";
		var selectPara="false";
		var checkBeforeFlag="false"
		
		function getUrlParameter() {
			var UrlPara="";
			checkBeforeFlag="false";
			var modelName = document.getElementsByName("modelName")[0].value;
			if(modelName == null || modelName ==""){
				var checkbox_models = document.getElementsByName("checkbox_model");
				//循环勾选
				for(var i=0;i<checkbox_models.length;i++){
					if( checkbox_models[i].checked){
						modelName+=checkbox_models[i].value+";"; 
					}
				}
			}
			selectField();
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
			UrlPara += "&newLUI=" + newLUI;
			UrlPara += "&checkBeforeFlag=" + checkBeforeFlag;
			if(facetClickPara){
				UrlPara += "&facetClickPara=" + facetClickPara;
			}
			var category = getTreeData();
			if(category){
				UrlPara += "&category=" + category;
			}else{
				var zTree = $.fn.zTree.getZTreeObj("categoryTree");
				if(zTree){
					var nodes = zTree.getNodes();
					if(nodes.length == 0){
						UrlPara += "&category=" + document.getElementsByName("category")[0].value;
					}
				}
			}
			return UrlPara;
		}
		function readDoc(fdModelName,fdCategory,fdUrl,fdSystemName,positionInPage) {
			var obj = this.event.target || this.event.srcElement;
			var fdDocSubject = obj.id;
			fdDocSubject = fdDocSubject.replace("\'","'").replace("&quot;","\"");
			document.getElementById("fdDocSubject").value=fdDocSubject;
			document.getElementById("fdModelName").value=fdModelName;
			document.getElementById("fdCategory").value=fdCategory;
			document.getElementById("fdUrl").value=fdSystemName+"\u001D"+fdUrl;
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
			 seajs.use('lui/dialog', function(dialog) {
				 dialog.alert("${ lfn:message('sys-tag:sysTag.inputContent')}",function(){
					 obj.focus();
				 });
			  });
			return false;
		 }
		 if(obj.value.length > 100){
			 seajs.use('lui/dialog', function(dialog) {
				 dialog.alert("${ lfn:message('sys-ftsearch-db:search.ftsearch.overlength')}",function(){
					 obj.focus();
				});
			 });
			 return false;
		 }
		    return true;
		}
		
		
		// 按时间
		function searchByTime(parameter){ 
			var timeRange="";
			var queryString=document.getElementsByName("queryString")[0];//搜索内容  
		 	if(!checkQueryString(queryString)){//如果搜索内容为空 则不进行搜索
			       return false;
		 	} 
		 	queryString=encodeURIComponent(queryString.value);//中文处理
			if(parameter=="day"){//一天内 
				timeRange='day';
			}
			else if(parameter=="week"){//一周内 
				timeRange='week';
			}
			else if(parameter=="month"){//一月内 
				timeRange='month';
			}
			else if(parameter=="year"){//一年内 
				timeRange='year';
			}
			var outmodel = selectOutModelInfo();
			var modelGroupChecked = document.getElementsByName("modelGroupChecked")[0].value;
			var facetClickParaTemp=Com_GetUrlParameter(window.location.href, "facetClickPara");
			if(facetClickParaTemp=="true"){
				facetClickPara="true";
			}
			window.location.href="<c:url value='/sys/ftsearch/searchBuilder.do?method=search&queryString=' />"
				+queryString +"&type=1&timeRange="+timeRange+getUrlParameter()+"&outModel="+outmodel+"&modelGroupChecked="+modelGroupChecked;  
			
		}
		
		
		//按字段
		function searchByField(){ 
			var queryString=document.getElementsByName("queryString")[0];//搜索内容  
		 	if(!checkQueryString(queryString)){//如果搜索内容为空 则不进行搜索
		 			$("#search_by_field input").attr("checked",true);
			       return false;
		 	} 
		 	queryString=encodeURIComponent(queryString.value);//中文处理
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
			var outmodel = selectOutModelInfo();
			var modelGroupChecked = document.getElementsByName("modelGroupChecked")[0].value;
			var facetClickParaTemp=Com_GetUrlParameter(window.location.href, "facetClickPara");
			if(facetClickParaTemp=="true"){
				facetClickPara="true";
			}
			window.location.href="<c:url value='/sys/ftsearch/searchBuilder.do?method=search&queryString=' />"+queryString +"&type=1"+getUrlParameter()+
			"&outModel="+outmodel+"&modelGroupChecked="+modelGroupChecked; 
			
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
			 	var facetClickParaTemp=Com_GetUrlParameter(window.location.href, "facetClickPara");
				if(facetClickParaTemp=="true"){
					facetClickPara="true";
				}
			 	window.location.href="<c:url value='/sys/ftsearch/searchBuilder.do?method=search&queryString=' />"+queryString + getUrlParameter()+"&outModel="+outmodel+"&modelGroupChecked="+modelGroupChecked;  
			}
			else {
				if(queryStringPos==3&&(${fn:length(modelList)}>1)){
					facetClickPara="true";
				}
				if(queryStringPos ==4){
					document.getElementsByName("modelName")[0].value ="";
				}
				var queryString=Com_GetUrlParameter(window.location.href, "queryString");
				if(queryString==null || queryString=="") 
					queryString = document.getElementsByName("queryString")[1].value;
				if(queryString==null || queryString=="") 
					queryString = document.getElementsByName("queryString")[0].value;
				if(queryString==null || queryString==""){ 
					return null;
				}else{
					queryString = encodeURIComponent(queryString);
					if(queryStringPos !=3){
						window.location.href="<c:url value='/sys/ftsearch/searchBuilder.do?method=search&queryString=' />"+queryString + getUrlParameter()+"&outModel="+outmodel+"&modelGroupChecked="+modelGroupChecked;
					}else{
						window.location.href="<c:url value='/sys/ftsearch/searchBuilder.do?method=search&queryString=' />"+queryString + getUrlParameter()+"&outModel="+outmodel+"&modelGroupChecked="+modelGroupChecked; 
					}		
				}
			}
		}

		function isIE(){ //ie?
		   if (window.navigator.userAgent.toLowerCase().indexOf("msie")>=1)
		    return true;
		   else
		    return false;
		}
		
		//判断对象是否存在
		function docEle(id) {
			if(document.getElementById(id)!=null)
				return true;
		    return false;
		}

		//获取随机数
		function getRand(){
			var Num=Math.floor(Math.random()*1000000);
			return Num;
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
			var outmodel = selectOutModelInfo();
			var modelGroupChecked = document.getElementsByName("modelGroupChecked")[0].value;
			var old_queryString = Com_GetUrlParameter(window.location.href, "queryString");
			var str_old = old_queryString.replace("&"," ").split(' ');
			var str_new = queryString.value.split(' ');
			for(var i = 0 ; i < str_old.length ; i++){
				for(var j = 0 ; j < str_new.length ; j++){
					if(str_old[i]==str_new[j]){
						seajs.use('lui/dialog', function(dialog) {
							 dialog.alert("${ lfn:message('sys-ftsearch-db:search.ftsearch.existError1')}"+str_new[j]+ "${ lfn:message('sys-ftsearch-db:search.ftsearch.existError2')}");
						});
						return false;
					}
				}
			}
			queryString = old_queryString + "&" + queryString.value;
			var url = Com_SetUrlParameter(window.location.href,"pageno",1)+"&outModel="+outmodel+"&modelGroupChecked="+modelGroupChecked;
			var checkBeforeFlag=Com_GetUrlParameter(url, "checkBeforeFlag");
			if(checkBeforeFlag==""||checkBeforeFlag==null){//结果中搜索不纠错
				url=url;
			}else{
				checkBeforeFlag="true";
				url=Com_SetUrlParameter(url,"checkBeforeFlag",checkBeforeFlag);
			}
			window.location.href = Com_SetUrlParameter(url,"queryString",queryString);
		}

		function relatedSearchWord(){
			var obj = this.event.target || this.event.srcElement;
			searchWord(obj.id);
	
		}

		// 点击热词或相关搜索词查询
		function searchWord(queryString) {
			queryString = encodeURIComponent(queryString);
			var UrlPara="";
			var modelName = document.getElementsByName("modelName")[0].value;
			var searchFields = document.getElementsByName("searchFields")[0].value;
			if(modelName!=null && modelName!="")
				UrlPara += "&modelName=" + modelName; 
			if(searchFields!=null && searchFields!="")
				UrlPara += "&searchFields=" + searchFields;
			if(modelDivExpand!=null && modelDivExpand!="")
				UrlPara += "&modelDivExpand=" + modelDivExpand;
			UrlPara += "&newLUI=" + newLUI;
			var outmodel = selectOutModelInfo();
			var facetClickParaTemp=Com_GetUrlParameter(window.location.href, "facetClickPara");
			if(facetClickParaTemp=="true"){
				UrlPara += "&facetClickPara=true";
			}
			var modelGroupChecked = document.getElementsByName("modelGroupChecked")[0].value;
			window.location.href="<c:url value='/sys/ftsearch/searchBuilder.do?method=search&queryString=' />"+queryString + UrlPara+"&outModel="+outmodel+"&modelGroupChecked="+modelGroupChecked; 
		}
		// 点击纠错中原错词（依然搜索）
		function searchOldWord(queryString) {
			checkBeforeFlag="true";
			queryString = encodeURIComponent(queryString);
			var UrlPara="";
			var modelName = document.getElementsByName("modelName")[0].value;
			var searchFields = document.getElementsByName("searchFields")[0].value;
			if(modelName!=null && modelName!="")
				UrlPara += "&modelName=" + modelName; 
			if(searchFields!=null && searchFields!="")
				UrlPara += "&searchFields=" + searchFields;
			if(modelDivExpand!=null && modelDivExpand!="")
				UrlPara += "&modelDivExpand=" + modelDivExpand;
			UrlPara += "&newLUI=" + newLUI;
			UrlPara += "&checkBeforeFlag=" + checkBeforeFlag;
			var outmodel = selectOutModelInfo();
			var modelGroupChecked = document.getElementsByName("modelGroupChecked")[0].value;
			window.location.href="<c:url value='/sys/ftsearch/searchBuilder.do?method=search&queryString=' />"+queryString + UrlPara+"&outModel="+outmodel+"&modelGroupChecked="+modelGroupChecked; 
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
				if(summary.offsetHeight > 40) {
					summary.style.height = "40px"; 
					summary.style.overflow ="hidden";
					summary.style.cursor ="default";
					summary.setAttribute("ondblclick","expand()");
				}
			}
		}

		// 摘要展开或收缩
		function expand() {
			var divObject = event.srcElement;
			if(divObject.style.overflow =="visible" ) {
				divObject.style.height="40px";
				divObject.style.overflow ="hidden";
				divObject.style.cursor ="default";
			}
			else if(divObject.style.overflow =="hidden" ) {
				divObject.style.height="auto";
				divObject.style.overflow ="visible";
				divObject.style.cursor ="text";
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
				selectPara="true";
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
		
		//返回外部模块信息
		function selectOutModelInfo(){
			var outValue=document.getElementsByName("multisSysModel")[0].value;
			if(outValue==null||outValue==""&&selectPara=="false"){
				outValue=Com_GetUrlParameter(window.location.href, "outModel");
			}
			if(outValue==null){
				outValue="";
			}
			return outValue;
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
			view_select_model();
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
			modelDivExpand=Com_GetUrlParameter(window.location.href, "modelDivExpand");
			if(modelDivExpand=="true") {
				view_select_model();
			}
			//pagingShow();
		}
		//分页
		 LUI.ready(function(){
			seajs.use('lui/topic',function(topic){
				var evt = {page: {currentPage:"${queryPage.pageno}", pageSize:"${queryPage.rowsize}", totalSize:"${queryPage.totalrows}"}};
		        topic.subscribe('paging.changed',function(evt){
				    var arr = evt.page;
				    var pageno=arr[0].value;
				    var rowsize=arr[1].value;
					var url = Com_SetUrlParameter(window.location.href,"pageno",pageno);
					window.location.href = Com_SetUrlParameter(url,"rowsize",rowsize);
	        	 });
			});
		})
		//类别点击搜索
		function facetSearch(parm){
			 if(typeof(parm)=="object"){
				 parm = parm.id;
			 }
			 if($("#ftsearch_facet img").length){
				 facetClickPara="true";
			 }
			 var data= parm.split(".");
			 var value=data[data.length-1];
			$("#model_select input").each(function(){
				if($.trim($(this).val())== $.trim(value)){
					$("#model_select input").prop("checked",false);
					$(this).prop("checked",true);
					selectOutSystemModel('checkbox_model');
				}
			});
			$("#multiSysmodel_select_id input").each(function(){
				var selectValueArr= $(this).val().split(".");
				var selectValue=selectValueArr[selectValueArr.length-1];
				$("#multiSysmodel_select_id input").prop("checked",false); 
				if($.trim(selectValue)== $.trim(value)){
					$(this).prop("checked",true);
				}
				selectOutSystemModel($(this).attr('name'));
			});
			if(parm.indexOf(".") == -1){
				CommitSearch(parm);
			}else{
				CommitSearch(3);
			}
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
		//后退并刷新
		function backAndFresh(){
			$("#model_select input").prop("checked",false);
			selectOutSystemModel('checkbox_model');
			$("#multiSysmodel_select_id input").each(function(){
				$("#multiSysmodel_select_id input").prop("checked",false); 
				selectOutSystemModel($(this).attr('name'));
			});
			CommitSearch(3);
		}
		LUI.ready(function(){
			$(".lui_portal_footer").show();
			var timeType=Com_GetUrlParameter(window.location.href, "timeRange");
			$("#"+timeType).css("color","red");
		})
		function getIconNameByFileName(fileName) {
			if(fileName==null || fileName=="")
				return "documents.png";
			var fileExt = fileName.substring(fileName.lastIndexOf("."));
			if(fileExt!="")
				fileExt=fileExt.toLowerCase();
			switch(fileExt){
				case ".doc":
				case ".docx":
					  return "word.png";
				case ".xls":
				case ".xlsx":
					return "excel.png";
				case ".ppt":
				case ".pptx":
					return "ppt.gif";
				case ".pdf":return "pdf.png";
				case ".txt":return "txt.gif";
				case ".jpg":return "image.png";
				case ".ico":return "image.png";
				case ".bmp":return "image.png";
				case ".gif":return "image.png";
				case ".png":return "image.png";
				case ".zip":
				case ".rar":
					return "zip.gif";
				case ".htm":
				case ".html":
					return "htm.gif";
				default:return "documents.png";
	}
}
		function selectSearchField(){
			 var target = this.event.target || this.event.srcElement;
			 var searchField = $("input[name='search_field']");
			 if(target.checked){
					searchField.prop("checked",true);
	         }else{
	        		searchField.prop("checked",false);
	          }
			 
		}
		
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
			var setting = {
				check : {
					enable : true,
					chkboxType : { "Y" : "s", "N" : "s" }
				},
				data : {
					simpleData : {
						enable : true
					}
				},
				view:{
					nameIsHTML:true,
					showTitle:false,
					showIcon:true
				},
			    callback: {
					onClick: zTreeOnClick,
				    beforeDblClick:beforeDblClick
				}
			};
			function beforeDblClick(treeId,treeNode){
				return false;
			}
			function zTreeOnClick(event,treeId,treeNode){
				var zTree = $.fn.zTree.getZTreeObj("categoryTree");
				if(treeNode.checked == true){
					zTree.checkNode(treeNode,false,true);
				}else{
					zTree.checkNode(treeNode,true,true);
				}
			}
				
			function formatTreeData() {
				var srcCategory = $("#srcCategory").val();
				if(!srcCategory){
					return null;
				}
				var json =  $.parseJSON(srcCategory);
				var json_arr = [], json_len = json.length;
				for ( var i = 0; i < json_len; i++) {
					var j_arr = [];
					//j_arr
					j_arr['id'] = json[i]['mapkey'];
					j_arr['name'] = json[i]['mapName']+"<font style='color:#999;'>("+json[i]['mapCount']+")</font>";
					if(json[i]['mapPid']){
						j_arr['pId'] = json[i]['mapPid'];
						j_arr['modelName'] = json[i]['modelName'];
					}else{
						j_arr['pId'] = '0';
						j_arr['modelName'] = json[i]['key'];
					}
					j_arr['open'] = isTrueCategory(j_arr['id']);
					j_arr['checked'] = isTrueCategory(j_arr['id']);
					json_arr.push(j_arr);
				}

				var jsonstr = "[";
				for (i = 0; i < json_arr.length; i++) {
					jsonstr += "{\"id\":\"" + json_arr[i]['id'] + "\","
							+ "\"modelName\":\""+json_arr[i]['modelName']+"\","
							+ "\"pId\":\"" + json_arr[i]['pId'] + "\"" + ",\"name\":"
							+ "\"" + json_arr[i]['name'] 
							+ "\",\"open\":\""+json_arr[i]['open']+"\""
							+ ",\"checked\":\""+json_arr[i]['checked']
							+ "\"\},";
				}
				jsonstr = jsonstr.substring(0, jsonstr.lastIndexOf(','));
				jsonstr += "]";
				
				return $.parseJSON(jsonstr);
			}

			function isTrueCategory(key){
				var category = $("#category").val();
					if(category){
						var cates = category.split(",");
						for(var i in cates){
							if(key == cates[i]){
								return "true";
							}
						} 
					}
				return "false";
			}
			
			function getTreeData() {
				var result = '';
				var zTree = $.fn.zTree.getZTreeObj("categoryTree");
				 if (zTree != null) {
						var nodes = zTree.getCheckedNodes(true);
						for(var i = 0;i<nodes.length ;i++){
							var categoryLine = nodes[i].id;
							if(nodes[i].halfCheck ==false){
								result += categoryLine+",";
							}
						}
					}
				return result;
			}
			 $(document).ready(function(){
				 	var categorys = formatTreeData();
				 	if(categorys){
					 	$.fn.zTree.init($("#categoryTree"), setting,categorys);
					 	var zTree = $.fn.zTree.getZTreeObj("categoryTree");
						 if (zTree != null) {
								var nodes = zTree.getNodes();
								traversalNode(nodes,zTree);
							}
					 	}
				 	}
			 );
	  function traversalNode(nodes,zTree){
			for(var i = 0;i<nodes.length ;i++){
				if(nodes[i].check_Child_State =='1' || nodes[i].check_Child_State =='2'){
					if(nodes[i].checked==false){
						zTree.expandNode(nodes[i]);
					}else{
						zTree.expandNode(nodes[i],false);
					}
				}
				
				var children = nodes[i].children;
				if(children)
					traversalNode(children,zTree);
			}
	   }
</script>