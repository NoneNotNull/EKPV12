<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<link href="${KMSS_Parameter_StylePath}list/listview.css" rel="stylesheet" type="text/css" />
<link href="${KMSS_Parameter_StylePath}list/list_page.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">	
	Com_IncludeFile("treeview.js|jquery.js|docutil.js|data.js");
	Com_IncludeFile("dialog.js", "style/"+Com_Parameter.Style+"/dialog/");
</script>
<script type="text/javascript">
	var LKSTree;
	Tree_IncludeCSSFile();
	Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
	var LKSTreeSub;
	var modelName = top.dialogObject.modelName;
	var categoryIncludeValue=null, propertyIncludeValue=null,searchCategoryValue=null;
	
	function loadAuthNodesValue() { // 过滤没权限或者没有模板的分类节点
		var key=document.getElementById("searchTxt");
		var keyValue="";
		if(key!=null && typeof(key)!="undefined")
		{
			keyValue=encodeURI(encodeURI(key.value));
		}
		var nodesValue = new KMSSData().AddBeanData("sysCategoryAuthTreeService&modelName="+modelName+"&searchKey="+keyValue).GetHashMapArray();
		categoryIncludeValue=[];
		for(var val in nodesValue[0]) {
			categoryIncludeValue.push(nodesValue[0][val]);
		}
		propertyIncludeValue=[];
		for(var v in nodesValue[1]) {
			propertyIncludeValue.push(nodesValue[1][v]);
		}
	
		if(nodesValue!=null && nodesValue.length>=3)
		{
			searchCategoryValue=[];
			for(var v in nodesValue[2]) {
				searchCategoryValue.push(nodesValue[2][v]);
			}
		}
		
	}
	function generateTree(){
		LKSTree = new TreeView("LKSTree", "<bean:message key="dialog.window.title" bundle="sys-category"/>", document.getElementById("treeDiv"));
		LKSTree.isShowCheckBox=true;
		LKSTree.isMultSel = top.dialogObject.mulSelect;
	
		LKSTree.isAutoSelectChildren = false;
		LKSTree.authNodeValue = categoryIncludeValue;
		var n1, n2;
		n1 = LKSTree.treeRoot;
		//LKSTree.OnNodeCheckedQueryChange = setNodeSelected;
		n1.authType = top.dialogObject.authType;
		n2 = n1.AppendCategoryData(modelName, null, 1);
		LKSTree.Show();
	}
	function generateTreeSub(){
	
	//============================请修改下面的代码============================
		LKSTreeSub = new TreeView("LKSTreeSub", "<bean:message key="dialog.window.title" bundle="sys-category"/>", document.getElementById("treeDivSub"));
		LKSTreeSub.isShowCheckBox = true;
		LKSTreeSub.isMultSel = top.dialogObject.mulSelect;
		LKSTreeSub.isAutoSelectChildren = false;
		LKSTreeSub.authNodeValue = propertyIncludeValue;
		var n1, n2, n3;
		n1 = LKSTreeSub.treeRoot;
		n1.authType = top.dialogObject.authType;
		n2 = n1.AppendPropertyData(null, true, modelName);
		LKSTreeSub.Show();
	}
	
	function Com_DialogReturnValue(){
		var rtnVal = new Array;
		
		if(top.dialogObject.mulSelect) {
			var nodes = LKSTree.GetCheckedNode();
			if(nodes!=null && nodes.length>0){
				for(var i=0;i<nodes.length;i++) {				
					rtnVal[rtnVal.length] = new Array;				
					rtnVal[rtnVal.length-1]["id"] = nodes[i].value;	
					rtnVal[rtnVal.length-1]["name"] = (nodes[i].title==null || nodes[i].title=="")?nodes[i].text:nodes[i].title;
				}
			}
			var nodesSub = LKSTreeSub.GetCheckedNode();
			if(nodesSub!=null && nodesSub.length>0) {
				for(var j=0;j<notesSub.length;j++) {
					var add = true;
					if(nodes!=null && nodes.length>0) {
						for(var i=0;i<nodes.length;i++) {
							if(nodes[i].value==notesSub[j]) {add=false;break;}
						}
					}
					if(add) {
						var i = rtnVal.length;
						rtnVal[i] = new Array;
						rtnVal[i]["id"] = notesSub[j].value;			
						rtnVal[i]["name"] = (notesSub[j].title==null || notesSub[j].title=="")?notesSub[j].text:notesSub[j].title;
					}
				}
			}
		}else{
				var nodes = LKSTree.GetCheckedNode();
				if(nodes==null) nodes = LKSTreeSub.GetCheckedNode();
				if(nodes!=null){
					rtnVal[0] = new Array;
					rtnVal[0]["id"] = nodes.value;	
					rtnVal[0]["name"] = (nodes.title==null || nodes.title=="")?nodes.text:nodes.title;	
				}
		}
	
		if(rtnVal.length==0)
			alert('<bean:message key="dialog.requiredSelect" />');
		else {
			parent.Com_DialogReturn(rtnVal);
		}
	}
	
	function Com_DialogReturnEmpty(){
		parent.Com_DialogReturn(new Array());
	}
	
	function setNodeSelected(node,optType) {
		selectNodes = node;
		return true;
	}
	
	function showSearchResult(){
		var resDiv="<table width='100%'>";
		
		if(searchCategoryValue ==null || (searchCategoryValue!=null && searchCategoryValue.length==0))
		{
			resDiv+="<tr><td colspan=2><bean:message bundle="sys-category" key="dialog.lable.cannotFind" /></td></tr>";
			$("#treeDiv").append(resDiv);
		}
		else
		{
			resDiv+="<thead><tr class='tr_listfirst'><td align='center' width='60%'><bean:message bundle="sys-category" key="dialog.lable.templateName" /></td><td align='center' width='40%'><bean:message bundle="sys-category" key="dialog.lable.categoryName" /></td></tr></thead>";
			resDiv+="<tbody>";
			for(var i=0;i<searchCategoryValue.length;i++)
			{
				var s=searchCategoryValue[i].split(":");
				var trClass="";
				if(i%2==0)
					trClass=" class='tr_listrow1' ";
				else
					trClass=" class='tr_listrow2' ";
				resDiv+=" <tr "+trClass+" style='cursor:pointer;' onclick=\"javascript:selectValue('"+s[0]+"','"+s[1]+"')\"><td align='center'>"+s[1]+"</td><td align='center'>"+s[2]+"</td></tr>";
			}//<a href=\"javascript:selectValue('"+s[0]+"','"+s[1]+"')\" >  </a>
			resDiv+="</tbody>";
		}
		resDiv+="</table>";
		$("#treeDiv").empty();
		//alert(resDiv);
		$("#treeDiv").append(resDiv);
		
	    $(".tr_listrow1").mouseover(function(){      //鼠标移动的高亮显示  
	        $(this).addClass("selected");  
	    }).mouseout(function(){
	        $(this).removeClass("selected");  
		});
	    $(".tr_listrow2").mouseover(function(){      //鼠标移动的高亮显示  
	        $(this).addClass("selected");  
	    }).mouseout(function(){
	        $(this).removeClass("selected");  
		});
	    
	}
	
	function startSearch(){
		$("#treeDiv").empty();
		$("#treeDiv").append('<bean:message bundle="sys-category" key="dialog.lable.startSearching" />');
		loadAuthNodesValue();	
		showSearchResult();
		$('#Label_Tabel_Label_Btn_1').click();
		$("#div_return").show();
	}
	
	function funSearch(){
		var e = Com_GetEventObject();
		var keyCode= e.keyCode ? e.keyCode : e.which ? e.which : e.charCode;
		if(keyCode==13){
			startSearch();
		}
	}

	function selectValue(id,name){
		var rtnVal = new Array;
		rtnVal[0] = new Array;
		rtnVal[0]["id"] = id;
		rtnVal[0]["name"] = name;
		parent.Com_DialogReturn(rtnVal);
	}

	function showTree(){
		$("#treeDiv").empty();
		$("#div_return").hide();
		generateTree();generateTreeSub();
	}

	function clearKeywords(){
		var keywords = document.getElementById("searchTxt");
		if(keywords!=null && typeof(keywords)!="undefined"){
			if(keywords.value=='<bean:message bundle="sys-category" key="dialog.lable.enterTemplate" />'){
				keywords.value = "";
			}
		}
	}

	$(function(){
		$(window).bind("scroll",function(){
			$("#ID_CATEGORY_SEARCH").css("top", parseFloat($(window).scrollTop())+2);
		});
	});
	
</script>
<style type="text/css">
<!--
.div_outer{
	width: 100%;
	height: 28px;
	padding: 10px 0px 10px 0;
	text-align: center;	
}
.div_in {
	position: relative;
	margin-left: 5px;
	width: 283px;
	height: 22px;
	text-align: left;
}

.input_search {
	color: #0066FF;
	font-size: 12px;
	width: 164px;
	margin: 0px 3px 0px 3px;
	padding: 1px;
	border: 0px;
	float: left;
	border: 1px solid #999999;
}

.selected {
	background: #6fb2eb;
}

.searchBtn{
	width: 50px;
	float: left;
}

.returnBtn{
	display: none;
	width: 50px;
	margin-left:3px;
	text-align: center;
}
-->
</style>
</head>
<body>
<div class="div_outer" id="ID_CATEGORY_SEARCH" >
	<center>
		<div class="div_in">
			<INPUT onkeydown="return funSearch();"
				onclick="return clearKeywords();" onfocus="clearKeywords();" 
				onblur="if(this.value=='') this.value='<bean:message bundle="sys-category" key="dialog.lable.enterTemplate" />';" 
				class='input_search' 
				value='<bean:message bundle="sys-category" key="dialog.lable.enterTemplate" />'
				id="searchTxt" />
			<input onclick='startSearch();' class="btndialog searchBtn" type="button" value='<bean:message key="button.search" />' >
			<input id="div_return" type="button" class="btndialog returnBtn" onclick="return showTree();"  title='<bean:message bundle="sys-category" key="dialog.lable.returnToList" />' value="<bean:message bundle="sys-category" key="dialog.lable.return" />">
		</div>
	</center>
</div>
<table id="Label_Tabel" width=100% height="75%" LKS_LabelDefaultIndex="1">
	<tr LKS_LabelName="<bean:message bundle="sys-category" key="dialog.lable.sysCategoryMain" />" height="100%">
		<td valign="top">
			<div id=treeDiv></div>
		</td>
	</tr>
	<tr LKS_LabelName="<bean:message bundle="sys-category" key="dialog.lable.sysCategoryProperty" />"  height="100%">
		<td valign="top">
			<div id=treeDivSub></div>
		</td>
	</tr>
</table>
<script>loadAuthNodesValue();generateTree();generateTreeSub();</script>
</body>
</html>