/*压缩类型：标准*/
/*******************************************************************************
 * JS文件说明： 该文件用于文档查看页面label平铺展示使用。
 * 
 * 使用方式： jsp页面引入该js。
 * 
 * label使用的HTML模型： 
 * <div class="label_doc_area" id="label_doc_area">
 *      <!--文档中label区域。 
 * 			class 属性必填。 
 * 			id 属性必填。--> 
 * <div class="label_doc" isExpand="1" labelName="流程" useLabel="true" labelType="flow"> 
 *       <!--单个label显示区域。 
 * 					class 属性必填。
 * 					isExpand 可填，默认折叠，是否默认展开。值：1为展开 其他值为折叠 
 * 					labelName可填，标签名。使用useLabel时，从原页签机制获取名称。 
 * 					useLabel 可填，是否从老标签获取信息（信息包含标签名，以及显示样式）值：true 是， 其他 否
 * 					labelType 可填，默认为常规类型，类型值主要在window.Label_Doc_Type全局变量罗列 
 * 							default	默认类型 base 基本信息类型 flow 流程类型 right 权限类型 read 阅读机制类型 relation 关联机制类型 communicate
 * 							沟通类型 circulation 传阅类型 feedback 反馈类型 olddata 老数据类型（数据迁移而来的信息）--> 
 *  <table>
 * 		<tr LKS_LabelName="流程" style="display:none"></tr>
 * 		<!--老的页签行--> 
 * </table>
 * </div> 
 * ... 
 * </div>
 * 
 * 作者：李衡 版本：1.0 2013-3-13
 ******************************************************************************/
Com_IncludeFile("label_doc.css", Com_Parameter.ContextPath+"km/review/resource/style/doc/","css",true);
Com_IncludeFile("jquery.js");
if(window.Label_Doc_Array == null){//默认处理id为label_doc_area的区域
	window.Label_Doc_Array = ["label_doc_area"];
}

if(window.Label_Doc_Type==null){  //label显示区类型
	window.Label_Doc_Type = [{"type":"default","cssValue":"lable_left_default"},
	                          {"type":"base","cssValue":"lable_left_base"},
	                          {"type":"flow","cssValue":"lable_left_flow"},
	                          {"type":"right","cssValue":"lable_left_right"},
	                          {"type":"read","cssValue":"lable_left_read"},
	                          {"type":"relation","cssValue":"lable_left_relation"},
	                          {"type":"communicate","cssValue":"lable_left_communicate"},
	                          {"type":"circulation","cssValue":"lable_left_circulation"},
	                          {"type":"feedback","cssValue":"lable_left_feedback"},
	                          {"type":"olddata","cssValue":"lable_left_olddata"}];
}

function Label_OnDocLoadShow(){
	if(window.Label_Doc_Array!=null){
		var queryFlag = false;
		for(var i=0; i<Label_Doc_Array.length; i++){
			var labelAreaId = Label_Doc_Array[i];
			var labelAreaObj = document.getElementById(labelAreaId);
			var labelArr = labelAreaObj.childNodes;
			var oldLength = labelArr.length;
			for(var j=0;j<labelArr.length;j++){
				var labelContent = labelArr[j];
				if(labelContent.nodeName.toLowerCase()!="div")
					continue;
				var classStr = labelContent.className;
				if(classStr == "label_doc"){
					var isExpand = labelContent.getAttribute("isExpand")=="1"?true:false;
					var lableName = labelContent.getAttribute("labelName");
					var labelType = labelContent.getAttribute("labelType");
					var useLabel = labelContent.getAttribute("useLabel")=="true"?true:false;
					labelContent.style.display = isExpand?"block":"none";
					labelContent.setAttribute("id","label_doc_" + i + "_" + j);
					if(useLabel){
						var trObj = label_getOldLabel(labelContent);
						if(trObj!=null){
							lableName = (lableName!=null && lableName!="")? lableName:trObj.getAttribute("LKS_LabelName");// 读取老页签名称
							if(isExpand){//设置老页签内容可见
								trObj.style.display = "table-row";
							}
						}
					}
					if(lableName!=null){
						var label = document.createElement("div");
						var tmpCalss = "label_tab_cell";
						if(isExpand){
							tmpCalss = "label_tab_cell";
						}else{
							tmpCalss = "label_tab_expand";
						}
						label.className = "label_tab";
						label.innerHTML = "<span class='lable_left'><span class='"+label_getCureentLabelTypeCss(labelType)+"'></span>"
							+"<label id='label_name_"+ i +"_" + j+"' class='"+tmpCalss+"'>" + lableName+"</label></span>"
							+"<span class='lable_right'></span>";
						Com_AddEventListener(label,"click",label_doc_expand);
						var labelId = "label_tab_"+ i +"_" + j;
						label.setAttribute("id",labelId);
						label_tool_setMenu(labelAreaId,labelId,lableName);
						labelAreaObj.insertBefore(label, labelContent);
						if(oldLength!=labelArr.length)	
							j++;	
					}
					if(isExpand){
						lable_afterlabelShow(labelContent);
					}
				}
			}
			label_tool_createToolArea(labelAreaId);
		}
	} 
}

/* 
 * labelid  要展现的labelid  可为空，凭事件获取操作label对象
 * forceExpand  是否强制展现，true为强制展现    false为强制折叠  空则根据自身状态处理
 */
function label_doc_expand(labelId,forceExpand){
	var labelObj = null;
	if(labelId!=null && labelId!="" && typeof(labelId)=="string"){
		labelObj = document.getElementById(labelId);
	}else{
		var eventObj = Com_GetEventObject(); 
		var domObj = eventObj.target ? eventObj.target : eventObj.srcElement;
		while(true){
			if(domObj.nodeName.toLowerCase()=="div" && domObj.className=="label_tab"){
				labelObj = domObj; 
				break;
			}else{
				domObj = domObj.parentNode;
			}
		}
	}
	var labelDomId = labelObj.getAttribute("id");
	var labelDocId = labelDomId.replace("label_tab_","label_doc_");
	var labelNameId = labelDomId.replace("label_tab_","label_name_");
	var labelDocObj = document.getElementById(labelDocId);
	if(labelDocObj!=null){
		var isExpand = labelDocObj.getAttribute("isExpand")=="1"?true:false;
		var useLabel = labelDocObj.getAttribute("useLabel")=="true"?true:false;
		var labNameObj =  document.getElementById(labelNameId);
		if(isExpand){
			if(forceExpand==null || forceExpand==false){
				labelDocObj.style.display="none";
				labelDocObj.setAttribute("isExpand","0");
				labNameObj.className = "label_tab_expand";
			}
		}else{
			if(forceExpand==null || forceExpand==true){
				labelDocObj.style.display="block";
				labelDocObj.setAttribute("isExpand","1");
				labNameObj.className = "label_tab_cell";
				if(useLabel){	//设置老页签内容可见
					var trObj = label_getOldLabel(labelDocObj);
					trObj.style.display = "table-row";
				}
				lable_afterlabelShow(labelDocObj);
			}
		}
	}
}
//页签显示后需要执行的附加操作
function lable_afterlabelShow(arguObj){
	$(arguObj).find("*[onresize]:visible").each(function(){
		var funStr = this.getAttribute("onresize");
		if(funStr!=null && funStr!=""){
			var tmpFunc = new Function(funStr);
			tmpFunc.call(this, Com_GetEventObject());
		}
	});
}
 
//获取老页签对象
function label_getOldLabel(labelDoc){
	var tableArr = labelDoc.childNodes;
	for(var i=0;i<tableArr.length;i++){
		var tableObj = tableArr[i];
		if(tableObj.nodeName.toLowerCase()!="table")
			continue;
		var trArr = tableObj.rows;
		for(var j=0; j<trArr.length; j++){
			var trObj = trArr[j];
			if(trObj.getAttribute("LKS_LabelName")!=null){
				return trObj;
			}else continue;
		}
	}
}
//根据操作类型显示CSS样式
function label_getCureentLabelTypeCss(labelType){
	if(labelType==null || labelType=="")
		labelType = "default";
	else
		labelType = labelType.toLowerCase();
	for(var i=0;i<window.Label_Doc_Type.length;i++){
		var tmpObj = window.Label_Doc_Type[i];
		if(tmpObj["type"]==labelType)
			return tmpObj["cssValue"];
	}
	return window.Label_Doc_Type[0]["cssValue"];
}
//显示导航操作区域
function label_tool_showMenu(){
	for(var i=0; i<Label_Doc_Array.length; i++){
		var labelDocId = Label_Doc_Array[i];
		var toolId = labelDocId + "_tool";
		var labelAreaObj = document.getElementById(toolId);
		if(labelAreaObj!=null){
			try{
				var centerTop = document.body.scrollTop + document.body.clientHeight*0.5;
				labelAreaObj.style.top = centerTop +"px";
				labelAreaObj.style.display = "block";
				var toolObj = document.getElementById(toolId+"_menuList");
				if(toolObj!=null){
					toolObj.style.left = (labelAreaObj.offsetLeft - toolObj.offsetWidth)+"px"; 
					toolObj.style.top = (centerTop - (toolObj.offsetHeight-100)/2)+ "px" ;
				}
				var topObj = labelAreaObj.lastChild;
				if(topObj.className=="label_doc_top"){
					if(document.body.scrollTop>0){
						topObj.style.display="block";
					}else{
						topObj.style.display="none";
					}
				}
			}catch(e){}
		}
	}
}
//定位文档位置
function label_tool_top(postion){
	var urlVar = location.href;
	if(urlVar.lastIndexOf("#")>-1)
		urlVar = urlVar.substring(0, urlVar.lastIndexOf("#"));
	if( postion==null || postion==""){
		location.href = urlVar+"#";
	}else{
		location.href = urlVar+"#"+postion;
	}
}
//设置导航数据存储
function label_tool_setMenu(labelAraaId,key,value){
	var toolId = labelAraaId + "_tool";
	if(toolId == null || toolId=="")
		return ;
	if(window._S_Menu_Array==null){
		window._S_Menu_Array = new Object();
	}
	var isHas = false;
	if(window._S_Menu_Array[toolId]!=null){
		var menuArr = window._S_Menu_Array[toolId];
		for(var i=0;i<menuArr.length;i++){
			var itemObj = menuArr[i];
			if(itemObj["key"]==key){
				itemObj["value"] = value;
				isHas = true;
			}
		}
	}else{
		window._S_Menu_Array[toolId] = new Array();
		isHas = false;
	}
	if(!isHas){
		var itemObj = new Object();
		itemObj["key"] = key;
		itemObj["value"] = value;
		window._S_Menu_Array[toolId].push(itemObj);
	}
}
//获取导航内容HTML
function label_tool_getMenuHTML(toolId){
	if(window._S_Menu_Array==null){
		return "";
	}
	if(window._S_Menu_Array[toolId]){
		var menus = window._S_Menu_Array[toolId];
		if(menus.length>0){
			var rtnHtml = "<ul class='label_ul_menuList'>";
			for (var i = 0; i < menus.length; i++) {
				var menuObj = menus[i];
				rtnHtml+="<li><a href=\"javascript:label_doc_expand('"+menuObj["key"]+"',true);label_tool_top('"+menuObj["key"]+"');\">"
							+ menuObj["value"]+"</a></li>";
			}
			rtnHtml += "</ul>";
			rtnHtml += "<span class='label_menu_opt' onclick=\"label_tool_expandAllLabel(this,'"+toolId+"');\">"+Data_GetResourceString("km-review:lable.msg.expand.all")+"</span>";
			return rtnHtml;
		}
	}
	return "";
}
//通过导航展开文档功能区域
function label_tool_expandAllLabel(thisObj,toolId){
	if(window._S_Menu_Array==null){
		return;
	}
	var isExpand = thisObj.getAttribute("opt_expanded")=="1"?true:false;
	if(window._S_Menu_Array[toolId]){
		var menus = window._S_Menu_Array[toolId];
		for (var i = 0; i < menus.length; i++) {
			var menuObj = menus[i];
			label_doc_expand(menuObj["key"],!isExpand);
		}
	}
	if(isExpand){
		thisObj.setAttribute("opt_expanded","0");
		$(thisObj).text(Data_GetResourceString("km-review:lable.msg.expand.all"));
	}else{
		thisObj.setAttribute("opt_expanded","1");
		$(thisObj).text(Data_GetResourceString("km-review:lable.msg.fold.all"));
	}
}
//导航展开、折叠
function label_tool_expandMenu(thisObj,toolId){
	var isExpand = thisObj.getAttribute("expanded")=="1"?true:false;
	var menuId = toolId+"_menuList";
	if(isExpand){
		thisObj.className = "label_doc_menu";
		thisObj.setAttribute("expanded","0");
		var menuList = document.getElementById(menuId);
		if(menuList!=null)
			document.body.removeChild(menuList);
	}else{
		thisObj.className = "label_doc_menu_expand";
		thisObj.setAttribute("expanded","1");
		var menuHTML = label_tool_getMenuHTML(toolId);
		if(menuHTML!="" && menuHTML!=null){
			var toolObj = document.getElementById(toolId);
			var menuDiv = document.createElement("div");
			menuDiv.className="label_doc_menuList";
			menuDiv.setAttribute("id", menuId);
			menuDiv.innerHTML = menuHTML;
			document.body.appendChild(menuDiv);
			menuDiv.style.left = (toolObj.offsetLeft - toolObj.offsetWidth)+"px"; 
			menuDiv.style.top = (toolObj.offsetTop - (menuDiv.offsetHeight-100)/2)+ "px" ;
		}
	}
}
//创建导航操作区
function label_tool_createToolArea(key){
	var toolId = key + "_tool";
	var toolAreaObj = document.getElementById(toolId);
	if(toolAreaObj==null){
		toolAreaObj = document.createElement("div");
		toolAreaObj.setAttribute("id", toolId);
		toolAreaObj.className="label_doc_tool";
		var htmlVar = "";
		if(window._S_Menu_Array!=null && window._S_Menu_Array[toolId]!=null){
			htmlVar +=  "<div class=\"label_doc_menu\" onclick=\"label_tool_expandMenu(this,'"+toolId+"');\">" +
					"<center><div style=\"width:13px;text-align:center;\">"+Data_GetResourceString("km-review:lable.msg.nav")+"</div></center></div>";
		}
		htmlVar += "<div class=\"label_doc_top\" onclick=\"label_tool_top();\"></div>";
		toolAreaObj.innerHTML = htmlVar;
		document.body.appendChild(toolAreaObj);
		setInterval("label_tool_showMenu();",100);
	}
}

Com_AddEventListener(window, "load", Label_OnDocLoadShow);