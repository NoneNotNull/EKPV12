/*压缩类型：无*/
//Portlet内容HTML（对于Iframe不生效）
function getContentHTML(obj){
	if(obj.TabFrame){//多标签窗口内容
		return getMultiTabContentHTML(obj);
	}
	var divCode="";
	if(!obj.ExtendHeight){
		divCode += "<div name='div_portlet_content' style='overflow:" +(obj.ScrollBar?"auto":"hidden") 
		 		+";width:100%;height:"+ obj.Height+ "px;line-height:"+ obj.Height+ "px;'>";
	}else{
		divCode += "<div name='div_portlet_content' style='overflow:visible;width:100%;height:100%;line-height:100%;'>";
	}
	
	//内容部分为空
	if(!obj.Content.length){
		return divCode + obj.Content +"</div>";
	}

	var i, j, tmpStr, content;
	var portletType = obj.PositionInfo=="Extend_1"?"extend":"limit";
	var htmlCode = "<table width=100% border=0 cellspacing=0 cellpadding=0><tr><td class="+portletType+"_content_padding>";
	content = obj.HeadContent;
	var isShowHead = content!=null && content.length>0;
	//图片标题栏
	if(isShowHead){	//截断过长标题
		var getByLength = function(words, length) {
			if(length < words.length)
				words = words.substring(0, length-2) + "...";
			return Com_HtmlEscape(words.replace(/&/g, escape("&")));
		};
		var textLength = 20;
		var links = escape(content[0].href);
		var texts = getByLength(content[0].text, textLength);
		var pics = escape(content[0].image);
		var width =  parseInt(escape(content[0].width));
		var height = parseInt(escape(content[0].height));
		for(var i=1;i<content.length;i++){			
			links += "|" + escape(content[i].href);
			texts += "|" + getByLength(content[i].text, textLength);
			pics += "|" + escape(content[i].image);
       	}
       	
		texts = texts.replace("'","="); // 获取控件页面有此调用，原因不详
	    var focus_width = 250;
		var focus_height = 182; 
		if(width){
			if(width>800)
				focus_width =800;
			else
		        focus_width =width;
		}
		if(height){
			if(height>600)
				focus_height = 600;
			else
		        focus_height =height; 
		}
		var text_height = 16;
		var swf_height = focus_height + text_height;
		texts = encodeURI(texts);//对标题文本进行编码，避免标题有百分号等特殊字符时标题和图片不能正常显示
		htmlCode += "<table width=100% border=0 cellspacing=0 cellpadding=0><tr valign=top><td width=200px>";
		htmlCode += '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" width="'+ focus_width +'" height="'+ swf_height +'">';
		htmlCode += '<param name="allowScriptAccess" value="sameDomain"><param name="movie" value="'+Com_Parameter.ContextPath+'resource/plusin/picturenews.swf"><param name="quality" value="high"><param name="bgcolor" value="#fff">';
		htmlCode += '<param name="menu" value="false"><param name=wmode value="transparent">';
		htmlCode += '<param name="FlashVars" value="pics='+pics+'&links='+links+'&texts='+texts+'&borderwidth='+focus_width+'&borderheight='+focus_height+'&textheight='+text_height+'">';
		htmlCode += '<embed src="'+Com_Parameter.ContextPath+'resource/plusin/picturenews.swf" quality="high" FlashVars="pics='+pics+'&links='+links+'&texts='+texts+'&borderwidth='+focus_width+'&borderheight='+focus_height+'&textheight='+text_height+'" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" wmode="transparent" type="application/x-shockwave-flash" width="'+ focus_width +'" height="'+ swf_height +'"><\/embed>'
		htmlCode += '</object></td><td style="padding-left:10px">';
	}
	htmlCode += "<table width=100% id=TB_Content>";
	content = obj.Content;
	for(i=0; i<content.length; i++){
		tmpStr = portletType+"_content_"+(content[i].importance==null?"no":content[i].importance);
		if(content[i].icon==null){
			if("1"==content[i].importance)
				htmlCode += "<tr><td><font id="+tmpStr+" class=limit_content_icon>!</font>&nbsp;&nbsp;";
			else
				htmlCode += "<tr><td><font id="+tmpStr+" class=limit_content_icon>•</font>&nbsp;&nbsp;";
		}else{
		    htmlCode += "<tr><td><img src='"+content[i].icon+"'>&nbsp;"; 
		}
		var otherinfo = "";
		if(content[i].otherinfo!=null)
			otherinfo= "&nbsp;"+content[i].otherinfo+"&nbsp;";
		tmpStr = "";
		if(content[i].created!=null)
			tmpStr = content[i].created;
		if(content[i].creator!=null)
			tmpStr += tmpStr==""?content[i].creator:("&nbsp;"+content[i].creator);
		if(tmpStr!="")
			tmpStr = "&nbsp;("+tmpStr+")";
		if(content[i].href!=null)
			htmlCode += "<a href="+content[i].href+" target="+content[i].target+">"+content[i].text+otherinfo+tmpStr+"</a>";
		else
			htmlCode += content[i].text+otherinfo+tmpStr;
		if(content[i].isnew)
			htmlCode += "<img src="+S_PortalInfo.StylePath+"portal/new.gif>";
		htmlCode += "</td></tr>";
	}
	htmlCode += "</table>";
	if(isShowHead){
		htmlCode += "</td></tr></table>";
	}
	htmlCode += "</td></tr></table>";
	
	if(divCode!="")
		htmlCode = divCode + htmlCode+ "</div>";

	return htmlCode;
}

//快速新建外框HTML
function getQuickNewOutHTML(htmlCode){
	var rtnVal="<div style=\"height:75px; width:100%; float:left;\">" ;
	rtnVal += "<center><div style=\"height:75px; width:100%;\"><table height=100% width=98% border=0 ceillpadding=0 cellspacing=0><tr>";
	rtnVal += "<td id=portal_scroll_left background="+S_PortalInfo.StylePath+"portal/newdocbg_0.gif width='18' class=quicknew_left " +
				"onmouseover=QuickScrollBackgroundPic(this,-1,'OVER') onmouseout = QuickScrollBackgroundPic(this,-1,'OUT') onclick=QuickNew_Scroll(-1);>";
	rtnVal += "</td>";
	rtnVal += "<td background="+S_PortalInfo.StylePath+"portal/newdocbg_2.gif>"+htmlCode+"</td>";
	rtnVal += "<td id=portal_scroll_right background="+S_PortalInfo.StylePath+"portal/newdocbg_5.gif width='18' class=quicknew_right " +
			  "onmouseover=QuickScrollBackgroundPic(this,1,'OVER') onmouseout = QuickScrollBackgroundPic(this,1,'OUT') onclick=QuickNew_Scroll(1);>";
	rtnVal += "</td>";
	rtnVal += "</tr></table><div></center></div>";
	return rtnVal;
}

//快速新建按钮HTML
function getQuickNewInHTML(info){
	var rtnVal = "<table height=100% border=0 cellpadding=0 cellspacing=0><tr>";
	for(var i=0; i<info.length; i++){
		if(i>0)
			rtnVal += "<td width=2></td>";
		//注意，此ID必需为Btn_QuickNew
		rtnVal += "<td class=quicknew_btn id=Btn_QuickNew style='background: url("+info[i].img+") no-repeat bottom left;' " +
				"onClick=\"Com_OpenWindow('"+info[i].url+"');\">";
		rtnVal += "<a id='gotoUrl"+i+"'><nobr>"+info[i].name+"</nobr></a></td>";
	} 
	rtnVal += "</tr></table>";
	return rtnVal;
}


//快速切换图片
function QuickScrollBackgroundPic(obj,info,operation){
	var backgroundURL = obj.backgroundImage;
	if(operation == 'OVER'){
		if(info == -1){
			var reg = /newdocbg_1.gif/;
			if(reg.test(backgroundURL)){
				backgroundURL = backgroundURL.replace(reg,"newdocbg_11.gif");
				obj.backgroundImage = backgroundURL;			
			}		
		}else{
			var reg = /newdocbg_4.gif/;
			if(reg.test(backgroundURL)){
				backgroundURL = backgroundURL.replace(reg,"newdocbg_44.gif");
				obj.backgroundImage = backgroundURL;			
			}	
		}
	}else{
		if(info == -1){
			var reg = /newdocbg_11.gif/;
			if(reg.test(backgroundURL)){
				backgroundURL = backgroundURL.replace(reg,"newdocbg_1.gif");
				obj.backgroundImage = backgroundURL;			
			}		
		}else{
			var reg = /newdocbg_44.gif/;
			if(reg.test(backgroundURL)){
				backgroundURL = backgroundURL.replace(reg,"newdocbg_4.gif");
				obj.backgroundImage = backgroundURL;			
			}	
		}	
	}
}
/******************************************************************************
功能：根据传入的参数设置左右滚动图片的样式
参数：
	isLeftScroll  :  是否可以向左滚动?true则显示带向左箭头的图片,false则显示没有箭头的图片,null则不改变现有的图片
	isRightScroll  : 是否可以向右滚动?true则显示带向右箭头的图片,false则显示没有箭头的图片,null则不改变现有的图片
******************************************************************************/
function SetQuickNewScrollPic(isLeftScroll,isRightScroll){	
	if(isLeftScroll!=null){
		var portal_scroll_left = document.getElementById("portal_scroll_left");
		var background = portal_scroll_left.getAttribute("background");
		if(isLeftScroll){
			var reg = /newdocbg_11.gif/;
			if(reg.test(background)){
				portal_scroll_left.setAttribute("background",S_PortalInfo.StylePath+"portal/newdocbg_11.gif");
				portal_scroll_left.style.cursor="";
			}else{
				portal_scroll_left.setAttribute("background",S_PortalInfo.StylePath+"portal/newdocbg_1.gif");	
				portal_scroll_left.style.cursor="pointer";
			}					
		}else{			
				portal_scroll_left.setAttribute("background",S_PortalInfo.StylePath+"portal/newdocbg_0.gif");	
				portal_scroll_left.style.cursor="";
		}
	}
	if(isRightScroll!=null){
		var portal_scroll_right=document.getElementById("portal_scroll_right");
		var background = portal_scroll_right.getAttribute("background");
		if(isRightScroll){
			var reg = /newdocbg_44.gif/;
			if(reg.test(background)){	
				portal_scroll_right.setAttribute("background",S_PortalInfo.StylePath+"portal/newdocbg_44.gif");
				portal_scroll_right.style.cursor="";
			}else{
				portal_scroll_right.setAttribute("background",S_PortalInfo.StylePath+"portal/newdocbg_4.gif");	
				portal_scroll_right.style.cursor="pointer";
			}	
		}else{
			portal_scroll_right.setAttribute("background",S_PortalInfo.StylePath+"portal/newdocbg_5.gif");
			portal_scroll_right.style.cursor = "";
		}
	}
}

//Portlet外框HTML
function getPortletHTML(obj, content){
	if(obj.TabFrame){//多标签窗口
		return getMultiTabHTML(obj, content);
	}
	var htmlCode, titleHTML,cBtnHTML="";
	var portletType = obj.PositionInfo=="Extend_1"?"extend":"limit";
	titleHTML = obj.Title;
	if(S_PortalInfo.DesignMode){
		if(obj.ShowCreateBtn && obj.CreateURL!=""){
			cBtnHTML = obj.CreateBtLabel;
		}
		titleHTML="<a>"+titleHTML+"</a>";
	}else{
		var quickArea="";
		if(obj.MoreURL!=""){
			var moreUrl = obj.MoreURL;
			if(moreUrl!=null && moreUrl.charAt(0)=="/")
				moreUrl =Com_SetUrlParameter(obj.MoreURL,"pageId",S_PortalInfo.CurHomePageId);
			titleHTML = "<a href="+moreUrl+" target="+obj.MoreTarget+">"+titleHTML+"</a>";
			if(obj.ShowCreateBtn && obj.CreateURL!=""){
				quickArea+="<span class='title_quick_more'";
				quickArea += " onClick=\"Com_OpenWindow('"+moreUrl+"','"+obj.MoreTarget+"');\" title='"+(S_PortalInfo.lang!=null?S_PortalInfo.lang.more:"more")+"'>";
				quickArea += "</span>";
			}
			
		}
		if(obj.ShowCreateBtn && obj.CreateURL!=""){
			if(quickArea!="")
				quickArea +="&nbsp;&nbsp;";
			quickArea += "<span class='title_quick_create'";
			quickArea += " onClick=\"Com_OpenWindow('"+obj.CreateURL+"','_blank');\" title='"+(S_PortalInfo.lang!=null?S_PortalInfo.lang.create:"create")+"'>";
			quickArea += "</span>";
		}
		cBtnHTML=quickArea;
	}
	if(portletType=="extend"){
		return getSingleExtendHTML(titleHTML,cBtnHTML,obj.Height,content);
	}else{
		if(typeof getSingleLimitHTML=="function"){
			return getSingleLimitHTML(titleHTML,cBtnHTML,obj.Height,content);
		}
	}
}

//多标签窗口内容 add by wubing date:2009-12-07
function getMultiTabContentHTML(obj){
	var tabs = eval(obj.TabFrameData);
	var content = obj.Content;
	var html = [];
	for(var i=0;i<tabs.length;i++){
		html.push('<div style="height:100%" id="'+tabs[i]['UUID']+'"');
		html.push((i!=obj.CurShowTab?' style="display:none"':''),'>');
		html.push(getContentHTML(content[tabs[i]['UUID']]));
		html.push('</div>');
	}
	return html.join('');
}

function getPortletElement(obj){
	for(;obj!=null;obj=obj.parentNode){
		if(obj.getAttribute("id")=="LKS_Portlet" && obj.getAttribute("LKS_Info")!=null){
			return obj;
		}
	}
	return null;
}

//多标签窗口 add by wubing date:2009-12-07
function getMultiTabHTML(obj,content){
	var tabs = eval(obj.TabFrameData);
	if(obj.PositionInfo=="Extend_1"){
		return getMultiTabExtendHTML(tabs,content,obj.CurShowTab);
	}else{
		return getMultiTabLimitHTML(tabs,content,obj.CurShowTab);
	}
}

//以下为工具生部分

//中间单标签
function getSingleExtendHTML(titleHTML,cBtnHTML,height,content){
	var html = [];
	html.push('<div class="grid_m">');
	html.push('		<div class="grid_title c"><div class="t_l"><h2>'+titleHTML+'</h2><span class="quick_area">'+cBtnHTML+'</span></div></div>');
	html.push('		<div class="grid_content">');
	html.push('		<div class="p10">');
	html.push('            '+content+'');
	html.push('			</div>');
	html.push('		</div>');
	html.push('</div>');
	return html.join('');
}
//右边单标签
function getSingleLimitHTML(titleHTML,cBtnHTML,height,content){
	var html = [];
	html.push('<div class="grid gridRight">');
	html.push('		<div class="grid_right_title"><div class="left"><h2>'+titleHTML+'</h2></div><div class="right"><span class="quick_area">'+cBtnHTML+'</span></div><div style=" clear:both"></div></div>');
	html.push('		<div class="grid_content">');
	html.push('		<div class="p10">');
	html.push('            '+content+'');
	html.push('			</div>');
	html.push('		</div>');
	html.push('</div>');
	return html.join('');
}
//中间多标签
function getMultiTabExtendHTML(tabs,content,curIndex){
	var html = [];
	 html.push('<div class="grid2">');
	 html.push('    	<div class="grid_header2">');
	 html.push('<CODE>');
	 html.push(getExtendTabBlockHTML(tabs,curIndex));
	 html.push('</CODE>');
	 html.push('<span class="quick_area">');
	 html.push(getQuickAreaHtml(tabs[curIndex]));
	 html.push('</span>');
	 html.push('        </div>');
	 html.push('        <div class="grid_content2">');
	 html.push('        	<div class="p10">');
	 html.push('            '+content+'            </div>');
	 html.push('        </div>');
	 html.push('</div>');
	return html.join('');
}
//右边多标签
function getMultiTabLimitHTML(tabs,content,curIndex){
	var html = [];
	 html.push('<div class="grid2_right grid2Right">');
	 html.push('    	<div class="grid_right_header2">');
	 html.push('<CODE>');
	 html.push(getLimitTabBlockHTML(tabs,curIndex));
	 html.push('</CODE>');
	 html.push('<span class="quick_area">');
	 html.push(getQuickAreaHtml(tabs[curIndex]));
	 html.push('</span>');
	 html.push('        </div>');
	 html.push('        <div class="grid_content2">');
	 html.push('        	<div class="p10">');
	 html.push('            '+content+'');
	 html.push('            </div>');
	 html.push('        </div>');
	 html.push('</div>');
	return html.join('');
}

function getExtendTabBlockHTML(tabs,index){
	var oldIndex = index;
	if(!index){
		index = 0;
	}
	var html = [];
	 html.push('        	<ul>');	
	 var none = "";
	for(var i=0;i<tabs.length;i++){
		if(i==tabs.length-1)
			none = "none";
		else
			none = "";
		if(i==index){
			 html.push('            <li class="m2 '+none+'">'+getTabTitleHTML(tabs[i],i,'extend')+'</li>');	
			continue;
		}
		 html.push('            <li class="m1 '+none+'">'+getTabTitleHTML(tabs[i],i,'extend')+'</li>');	
	}
	html.push('            </ul>');	
	if(oldIndex!=null){
		var portlet = document.getElementById(tabs[index]["UUID"]);
		if(portlet!=null){
			var portletDiv = getPortletElement(portlet);
			var codeVar=portletDiv.getElementsByTagName("code");
			if(codeVar!=null && codeVar.length>0){
				var quickArea=codeVar[0].nextSibling;
				if(quickArea!=null && quickArea.tagName.toLowerCase()=='span' && quickArea.getAttribute("className")=='quick_area'){
					quickArea.innerHTML=getQuickAreaHtml(tabs[index]);
				}
			}
		}
	}
	return html.join('');
}


function getLimitTabBlockHTML(tabs,index){
	var oldIndex = index;
	if(!index){
		index = 0;
	}
	var html = [];
	 html.push('        	<ul>');	
	 var none = "";
	for(var i=0;i<tabs.length;i++){
		if(i==tabs.length-1)
			none = "none";
		else
			none = "";
		if(i==index){

			 html.push('            <li class="cur2 '+none+'">'+getTabTitleHTML(tabs[i],i,'limit')+'</li>');	
			continue;
		}
		 html.push('            <li class="cur '+none+'">'+getTabTitleHTML(tabs[i],i,'limit')+'</li>');	
	}	
	html.push('            </ul>');	
	if(oldIndex!=null){
		var portlet = document.getElementById(tabs[index]["UUID"]);
		if(portlet!=null){
			var portletDiv = getPortletElement(portlet);
			var codeVar=portletDiv.getElementsByTagName("code");
			if(codeVar!=null && codeVar.length>0){
				var quickArea=codeVar[0].nextSibling;
				if(quickArea!=null && quickArea.tagName.toLowerCase()=='span' && quickArea.getAttribute("className")=='quick_area'){
					quickArea.innerHTML=getQuickAreaHtml(tabs[index]);
				}
			}
		}
	}
	return html.join('');
}
function getQuickAreaHtml(obj){
	var quickArea="";
	if(S_PortalInfo.DesignMode){
		if(obj.ShowCreateBtn && obj.CreateURL!="" && obj.CreateBtLabel!=null){
			quickArea = obj.CreateBtLabel;
		}
	}else{
		if(obj.ShowCreateBtn && obj.CreateURL!=""){
			if(obj.MoreURL!=""){
				var moreUrl=Com_SetUrlParameter(obj.MoreURL,"pageId",S_PortalInfo.CurHomePageId);
				quickArea +="<span class='title_quick_more'";
				quickArea += " onClick=\"Com_OpenWindow('"+ formatUrl(moreUrl) +"','"+obj.MoreTarget+"');\" title='"+(S_PortalInfo.lang!=null?S_PortalInfo.lang.more:"more")+"'>";
				quickArea += "</span>";
			}
			if(quickArea!="")
				quickArea +="&nbsp;&nbsp;";
			quickArea += "<span class='title_quick_create'";
			quickArea += " onClick=\"Com_OpenWindow('"+formatUrl(obj.CreateURL)+"','_blank');\" title='"+(S_PortalInfo.lang!=null?S_PortalInfo.lang.create:"create")+"'>";
			quickArea += "</span>";
		}
	}
	return quickArea;
}
