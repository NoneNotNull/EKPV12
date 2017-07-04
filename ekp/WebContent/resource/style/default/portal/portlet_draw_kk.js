/*压缩类型：无*/
//Portlet外框HTML
function getPortletHTML(obj, content)
{
	if(obj.TabFrame){//多标签窗口
		return getMultiTabHTML(obj, content);
	}
	
	var htmlCode, titleHTML;
	var portletType = obj.PositionInfo=="Extend_1"?"extend":"limit";
	titleHTML = obj.Title;
	if(obj.MoreURL!="" && !S_PortalInfo.DesignMode){
		titleHTML = "<a href="+obj.MoreURL+" target="+obj.MoreTarget+">"+titleHTML+"</a>";
	}

	//==========是否显示'新建'按钮==================
	var cBtn = "";
	if(obj.ShowCreateBtn && obj.CreateURL!=""){
		cBtn="<a href="+obj.CreateURL+" target=_blank>"+obj.CreateBtLabel+"</a>";
	}
	//==============================================

	if(obj.PositionInfo=="Extend_1")
	{
		htmlCode ='	<table style="width:100%;" border=0 cellspacing=0 cellpadding=0>';
		htmlCode +='	<tr style="height:24px">';
		htmlCode +='		<td width=5px style="background-image:url('+S_PortalInfo.StylePath+'portal/extend_left.gif)">';
		htmlCode +='		</td>';
		htmlCode +='		<td style="background-image:url('+S_PortalInfo.StylePath+'portal/extend_center.gif); " class="extend_title"><nobr>';
		htmlCode +=titleHTML;
		htmlCode +='		</nobr></td>';
		//============显示新建按钮======================
		htmlCode += "<td width=70 style='background-image:url("+S_PortalInfo.StylePath+"portal/extend_center.gif);background-repeat: repeat-x' class=extend_title><b>"+cBtn+"</b></td>";
		//============================================
		htmlCode +='		<td width=5px style="background-image:url('+S_PortalInfo.StylePath+'portal/extend_right.gif)">';
		htmlCode +='		</td>';
		htmlCode +='	</tr>';
		htmlCode +='</table>';
		
		htmlCode +='<table style="width:100%; height:100%" border=0 cellspacing=0 cellpadding=0>';
		htmlCode +='	<tr>';
		htmlCode +='		<td valign=top class=extend_bd24>'+content+'</td>';
		htmlCode +='	</tr>';
		htmlCode +='</table>';

		htmlCode +="<table width=100% height=5px cellpadding=0 cellspacing=0 border=0><tr>";
		htmlCode +="<td style='width:5px; background-image:url("+S_PortalInfo.StylePath+"portal/extend_bottom_left.jpg)'></td>";
		htmlCode +="<td class=extend_bd3>&nbsp;</td>";
		htmlCode +="<td style='width:7px; background-image:url("+S_PortalInfo.StylePath+"portal/extend_bottom_right.jpg)'></td>";
		htmlCode +="</tr></table>";

	}
	else
	{
		htmlCode ='	<table style="width:100%;" border=0 cellspacing=0 cellpadding=0>';
		htmlCode +='	<tr style="height:22px">';
		htmlCode +='		<td width=6px style="background-image:url('+S_PortalInfo.StylePath+'portal/limit_left.gif)">';
		htmlCode +='		</td>';
		htmlCode +=' 		<td style="background-image:url('+S_PortalInfo.StylePath+'portal/limit_center.gif); " class="limit_title"><nobr>';
		htmlCode +=titleHTML;
		htmlCode +='		</nobr></td>';
		htmlCode +=' 		<td width=6px style="background-image:url('+S_PortalInfo.StylePath+'portal/limit_right.gif)">';
		htmlCode +=' 		</td>';
		htmlCode +=' 	</tr>';
		htmlCode +=' </table>';

		htmlCode +='<table style="width:100%; height:100%" border=0 cellspacing=0 cellpadding=0>';
		htmlCode +='	<tr>';
		htmlCode +='		<td valign=top>'+content+'</td>';
		htmlCode +='	</tr>';
		htmlCode +='</table>';
	}
	
	return htmlCode;
}

//多标签窗口 add by wubing date:2009-12-07
function getMultiTabHTML(obj,content){
	var tabs = eval(obj.TabFrameData);
	var tabFrame = [];
	var portletType = obj.PositionInfo=="Extend_1"?"extend":"limit";
	if(obj.PositionInfo=="Extend_1"){
		tabFrame.push('<table style="width:100%;" cellpadding=0 cellspacing=0 border=0>');
		tabFrame.push('		<tr style="height:29px">');
		tabFrame.push('			<td style="height:29px" background="'+S_PortalInfo.StylePath+'portal/lab_table_bg.jpg">');
		tabFrame.push('<CODE>');
		tabFrame.push(getExtendTabBlockHTML(tabs));
		tabFrame.push('</CODE>');
		tabFrame.push('			</td>');
		tabFrame.push('			<td width=7px style="background-image:url('+S_PortalInfo.StylePath+'portal/lab_table_right.jpg)"></td>');
		tabFrame.push('		</tr>');
		
		tabFrame.push('	</table>');

		tabFrame.push('<table style="width:100%; height:100%" border=0 cellspacing=0 cellpadding=0>');
		tabFrame.push('	<tr>');
		tabFrame.push('		<td valign=top class=extend_bd24>'+content+'</td>');
		tabFrame.push('	</tr>');
		tabFrame.push('</table>');

		//底部
		tabFrame.push("<table width=100% height=5px cellpadding=0 cellspacing=0 border=0><tr>");
		tabFrame.push("<td style='width:5px; background-image:url("+S_PortalInfo.StylePath+"portal/extend_bottom_left.jpg)'></td>");
		tabFrame.push("<td class=extend_bd3>&nbsp;</td>");
		tabFrame.push("<td style='width:7px; background-image:url("+S_PortalInfo.StylePath+"portal/extend_bottom_right.jpg)'></td>");
		tabFrame.push("</tr></table>");

	}else{
		tabFrame.push('<table width=100% cellpadding=0 cellspacing=0 border=0>');
		tabFrame.push('		<tr style="height:29px">');
		tabFrame.push('			<td background="'+S_PortalInfo.StylePath+'portal/lab_table_bg.gif">');
		tabFrame.push('<CODE>');
		tabFrame.push(getLimitTabBlockHTML(tabs));
		tabFrame.push('</CODE>');
		tabFrame.push('			</td>');
		tabFrame.push('			<td width=7px style="background-image:url('+S_PortalInfo.StylePath+'portal/lab_table_right.jpg)"></td>');
		tabFrame.push('		</tr>');
		tabFrame.push('	</table>');

		tabFrame.push('<table style="width:100%; height:100%" border=0 cellspacing=0 cellpadding=0>');
		tabFrame.push('	<tr>');
		tabFrame.push('		<td valign=top class=extend_bd24>'+content+'</td>');
		tabFrame.push('	</tr>');
		tabFrame.push('</table>');

		//底部
		tabFrame.push("<table width=100% height=5px cellpadding=0 cellspacing=0 border=0><tr>");
		tabFrame.push("<td style='width:5px; background-image:url("+S_PortalInfo.StylePath+"portal/extend_bottom_left.jpg)'></td>");
		tabFrame.push("<td class=extend_bd3>&nbsp;</td>");
		tabFrame.push("<td style='width:7px; background-image:url("+S_PortalInfo.StylePath+"portal/extend_bottom_right.jpg)'></td>");
		tabFrame.push("</tr></table>");

	}
	return tabFrame.join('');
}


function getExtendTabBlockHTML(tabs,index){
	if(!index){
		index = 0;
	}
	var html = [];
	html.push('<table style="height:29px" border=0 cellspacing=0 cellpadding=0>');
	html.push('<tr>');
	for(var i=0;i<tabs.length;i++){
		var tmp = "nor",tmp1="first_";
		if(i>0){
			html.push('<td class="extend_label_split">&nbsp;</td>');
			tmp1=""
		}
		if(i==index){
			tmp = "sel";
		}
		html.push('<td width=6px background="'+S_PortalInfo.StylePath+'portal/extend_'+tmp+'_'+tmp1+'left.gif">');
		html.push('</td>');
		html.push('<td background="'+S_PortalInfo.StylePath+'portal/extend_'+tmp+'_center.gif" class="extend_'+tmp+'_title">');
		html.push(getTabTitleHTML(tabs[i],i,'extend'));
		html.push('</td>');
		html.push('<td width=6px background="'+S_PortalInfo.StylePath+'portal/extend_'+tmp+'_right.gif">');
		html.push('</td>');
	}
	html.push('</tr>');
	html.push('</table>');
	return html.join('');
}

function getLimitTabBlockHTML(tabs,index){
	if(!index){
		index = 0;
	}
	var html = [];
	for(var i=0;i<tabs.length;i++){
		var tmp = "nor",tmp1="first_";
		if(i>0){
			html.push('<td class="extend_label_split">&nbsp;</td>');
			tmp1=""
		}
		if(i==index){
			tmp = "sel";
		}
		html.push('<td width=6px background="'+S_PortalInfo.StylePath+'portal/limit_'+tmp+'_'+tmp1+'left.gif">');
		html.push('</td>');
		html.push('<td background="'+S_PortalInfo.StylePath+'portal/limit_'+tmp+'_center.gif" class="limit_'+tmp+'_title">');
		html.push(getTabTitleHTML(tabs[i],i,'limit'));
		html.push('</td>');
		html.push('<td width=6px background="'+S_PortalInfo.StylePath+'portal/limit_'+tmp+'_right.gif">');
		html.push('</td>');
	}
	return html.join('');
}

//Portlet内容HTML（对于Iframe不生效）
function getContentHTML(obj)
{
	if(obj.TabFrame){//多标签窗口内容
		return getMultiTabContentHTML(obj);
	}

	var i, j, tmpStr, content;
	var portletType = obj.PositionInfo=="Extend_1"?"extend":"limit";
	var htmlCode = "<table width=100% border=0 cellspacing=0 cellpadding=0><tr><td class="+portletType+"_content_padding>";
	content = obj.HeadContent;
	var isShowHead = content!=null && content.length>0;
	//图片标题栏
	if(isShowHead)
	{	//截断过长标题
		var getByLength = function(words, length) {
			if(length < words.length)
				words = words.substring(0, length-2) + "...";
			return Com_HtmlEscape(words.replace(/&/g, escape("&")));
		}
		var textLength = 16;
		var links = escape(content[0].href);
		var texts = getByLength(content[0].text, textLength);
		var pics = escape(content[0].image);
		for(var i=1;i<content.length;i++){
			links += "|" + escape(content[i].href);
			texts += "|" + getByLength(content[i].text, textLength);
			pics += "|" + escape(content[i].image);
       	}
       	
		texts = texts.replace("'","="); // 获取控件页面有此调用，原因不详
		var focus_width = 190;
		var focus_height = 143; // 原值是 175
		var text_height = 16;
		//var UrlCss = '';
		//var Play_M = 12;
		//var Bg_Color = '0xFFFFFF';
		//var Bg_Img = 'NO';
		//var text_padding = 5;
		var swf_height = focus_height + text_height;
		texts = encodeURI(texts);//对标题文本进行编码，避免标题有百分号等特殊字符时标题和图片不能正常显示
		htmlCode += "<table width=100% border=0 cellspacing=0 cellpadding=0><tr valign=top><td>";
		htmlCode += '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" width="'+ focus_width +'" height="'+ swf_height +'">';
		htmlCode += '<param name="allowScriptAccess" value="sameDomain"><param name="movie" value="'+Com_Parameter.ContextPath+'resource/plusin/picturenews.swf"><param name="quality" value="high"><param name="bgcolor" value="#fff">';
		htmlCode += '<param name="menu" value="false"><param name=wmode value="transparent">';
		htmlCode += '<param name="FlashVars" value="pics='+pics+'&links='+links+'&texts='+texts+'&borderwidth='+focus_width+'&borderheight='+focus_height+'&textheight='+text_height+'">';
		htmlCode += '<embed src="'+Com_Parameter.ContextPath+'resource/plusin/picturenews.swf" quality="high" FlashVars="pics='+pics+'&links='+links+'&texts='+texts+'&borderwidth='+focus_width+'&borderheight='+focus_height+'&textheight='+text_height+'" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" wmode="transparent" type="application/x-shockwave-flash" width="'+ focus_width +'" height="'+ swf_height +'"><\/embed>'
		htmlCode += '</object></td></tr><tr><td style="padding-left:10px">';
	}
	//内容部分
	
	htmlCode += "<table width=100% id=TB_Content>";
	content = obj.Content;
	for(i=0; i<content.length; i++)
	{
		tmpStr = portletType+"_content_"+(content[i].importance==null?"no":content[i].importance);
		htmlCode += "<tr><td><img src='"+S_PortalInfo.StylePath+"portal/icon_kk.gif'>&nbsp;&nbsp;"; 

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
	return htmlCode;
}

//多标签窗口内容 add by wubing date:2009-12-07
function getMultiTabContentHTML(obj){
	var tabs = eval(obj.TabFrameData);
	var content = obj.Content;
	var html = [];
	for(var i=0;i<tabs.length;i++){
		html.push('<div style="height:100%" id="'+tabs[i]['UUID']+'" LKS_Portlet_ID="'+obj.elementUniqueID+'"');
		html.push((i>0?' style="display:none"':''),'>');
		html.push(getContentHTML(content[tabs[i]['UUID']]));
		html.push('</div>');
	}
	return html.join('');
}

//快速新建外框HTML
function getQuickNewOutHTML(htmlCode)
{
	var rtnVal = "<table height=61 width=100% border=0 cellpadding=0 cellspacing=0><tr>";
	rtnVal += "<td id=portal_scroll_left background="+S_PortalInfo.StylePath+"portal/newdocbg_0.gif width=14 class=quicknew_left onclick=QuickNew_Scroll(-1);>";
	//此处图片起占位作用
	rtnVal += "<img src="+S_PortalInfo.Path+"/common/images/ecblank.gif height=1 width=14></td>";
	rtnVal += "<td background="+S_PortalInfo.StylePath+"portal/newdocbg_2.gif>"+htmlCode+"</td>";
	rtnVal += "<td id=portal_scroll_right background="+S_PortalInfo.StylePath+"portal/newdocbg_4.gif width=14 class=quicknew_right onclick=QuickNew_Scroll(1);>";
	rtnVal += "<img src="+S_PortalInfo.Path+"/common/images/ecblank.gif height=1 width=14></td>";
	rtnVal += "</tr></table>";
	return rtnVal;
}

//快速新建按钮HTML
function getQuickNewInHTML(info)
{
	var rtnVal = "<table height=100% border=0 cellpadding=0 cellspacing=0><tr>";
	for(var i=0; i<info.length; i++)
	{
		if(i>0)
			rtnVal += "<td width=2><img src="+S_PortalInfo.StylePath+"portal/newdocbg_3.gif></td>";
		//注意，此ID必需为Btn_QuickNew
		rtnVal += "<td class=quicknew_btn id=Btn_QuickNew>";
		//此处图片起占位作用
		rtnVal += "<div><img src="+S_PortalInfo.Path+"/common/images/ecblank.gif height=1 width=70></div>";
		rtnVal += "<a href="+info[i].url+" target=_blank><img src="+info[i].img+" border=0 width=38 height=32><br><nobr>"+info[i].name+"</nobr></a></td>";
	}
	rtnVal += "</tr></table>";
	return rtnVal;
}
/******************************************************************************
功能：根据传入的参数设置左右滚动图片的样式
参数：
	isLeftScroll  :  是否可以向左滚动?true则显示带向左箭头的图片,false则显示没有箭头的图片,null则不改变现有的图片
	isRightScroll  : 是否可以向右滚动?true则显示带向右箭头的图片,false则显示没有箭头的图片,null则不改变现有的图片
******************************************************************************/
function SetQuickNewScrollPic(isLeftScroll,isRightScroll){
	if(isLeftScroll!=null){
		if(isLeftScroll){
			document.all.portal_scroll_left.background=S_PortalInfo.StylePath+"portal/newdocbg_1.gif";
		}else{
			document.all.portal_scroll_left.background=S_PortalInfo.StylePath+"portal/newdocbg_0.gif";
		}
	}
	if(isRightScroll!=null){
		if(isRightScroll){
			document.all.portal_scroll_right.background=S_PortalInfo.StylePath+"portal/newdocbg_4.gif";
		}else{
			document.all.portal_scroll_right.background=S_PortalInfo.StylePath+"portal/newdocbg_5.gif";
		}
	}
}
