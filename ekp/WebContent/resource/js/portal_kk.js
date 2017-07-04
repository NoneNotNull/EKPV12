/*压缩类型：完全*/
/******************************************************************************
作者：叶中奇
完成时间：2005-9-1
修订记录：
	2005-9-1：完成基本功能
JS文件说明：
	该文件在展现窗口页面时载入
全局变量：
	S_PortalInfo：对象，其属性见design_doc.js,新增属性：
		TimeOutID：		对象，TimeOutID[functionStr]表示执行functionStr的TimeoutID
		Today：			日期，服务器当天时间
		QuickNewIndex：	快速新建栏中显示的第一个按钮的索引号
******************************************************************************/

/******************************************************************************
功能：将页面的元素信息（不管是否存在）转成一个数组，方便程序的操作
******************************************************************************/
function getElementArray(elem)
{
	var rtnVal = elem;
	if(rtnVal==null)
		return new Array;
	if(rtnVal.length==null)
		return new Array(rtnVal);
	return rtnVal;
}

/******************************************************************************
功能：处理html中的一些敏感字符
******************************************************************************/
function htmlEscape(str)
{
	if(str==null || str=="")
		return str;
	var re = new RegExp();
	re.compile("&", "gi");
	str = str.replace(re, "&amp;");
	re.compile("\\\"", "gi");
	str = str.replace(re, "&quot;");
	re.compile("<", "gi");
	str = str.replace(re, "&lt;");
	re.compile(">", "gi");
	str = str.replace(re, "&gt;");
	return str;
}

/******************************************************************************
功能：按照英文字符的长度截取字符串
参数：
	str：	需要处理的字符串
	length：需要截取的字符个数（英文按1计算，中文按2计算）
返回：
	截断后的字符串
******************************************************************************/
function getSubstringByByteLength(str, length)
{
	//原字符串即使全部按中文算，仍没有达到预期的长度，不需要截取
	if(str.length*2 <= length)
		return str;
	var rtnLength = 0;	//已经截取的长度
	for(var i=0; i<str.length; i++)
	{
		//字符编码号大于200，将其视为中文，该判断可能不准确
		if(Math.abs(str.charCodeAt(i))>200)
			rtnLength = rtnLength + 2;
		else
			rtnLength++;
		//超出指定范围，直接返回
		if(rtnLength>length)
			return str.substring(0, i) + (rtnLength % 2==0?"..":"...");
	}
	return str;
}

/******************************************************************************
功能：页面的onload事件
******************************************************************************/
function Portal_OnLoad()
{
	//整理快速新建栏
	if(document.all.ID_QuickNew!=null && document.all.F_QuickNewName.value!="")
	{
		//注意，HTML模板中采用ID_QuickNew指定快速新建栏放置的位置，若无该对象或用户没有选择快速新建按钮，则不显示
		var nameList = htmlEscape(document.all.F_QuickNewName.value).split("\r\n");
		var urlList = document.all.F_QuickNewURL.value.split("\r\n");
		var imgList = document.all.F_QuickNewImg.value.split("\r\n");
		/**************************************************************
		info（快速新建按钮信息）说明：
		info为一个对象数组，info[i]表示第i个记录的信息，其属性有：
			name：	按钮显示名
			url：	按钮链接
			img：	按钮图片
		**************************************************************/
		var info = new Array;
		var re = new RegExp();
		re.compile(" ");
		for(var i=0; i<nameList.length; i++)
		{
			info[i] = new Array;
			info[i].name = nameList[i];
			info[i].url = formatUrl(urlList[i]);
			info[i].img = S_PortalInfo.Path + "common/icon/" + imgList[i];
		}
		//x坐标溢出则不显示，这里width设100%无效，该宽度会在Portlet_OnResize中重新定义
		//下面的getQuickNewInHTML和getQuickNewOutHTML分别获取到按钮栏内/外的HTML代码，在主题风格中的portlet_draw.js中定义
		var htmlCode = "<div style='overflow-x:hidden;width:100;height:100%' id=DIV_QuickNew>"+getQuickNewInHTML(info)+"</div>";
		document.all.ID_QuickNew.innerHTML = getQuickNewOutHTML(htmlCode);
		//更新快速新建按钮栏长度
		Portlet_OnResize("Portlet_ResetQuickNew()");
	}
	//若模板中声明了Win_OnLoad函数，则调用
	if(window.Win_OnLoad)
		Win_OnLoad();
}

/******************************************************************************
功能：更新快速新建按钮栏长度
******************************************************************************/
function Portlet_ResetQuickNew()
{
	S_PortalInfo.TimeOutID["Portlet_ResetQuickNew()"] = 0;
	var tdObj = DIV_QuickNew.offsetParent;	//容纳DIV_QuickNew的父对象
	//100是最小宽度，小于这个值不再整理
	if(tdObj.clientWidth<=100)
		return;
	//获取从DIV_QuickNew到ID_QuickNew的所有父对象中，最大的宽度
	var width, obj;
	for(obj=tdObj; obj.id!="ID_QuickNew"; obj=obj.parentNode)
	{
		if(obj.clientWidth!=0)
			width = obj.clientWidth;
	}
	//若该宽度超出了页面的宽度，则缩短后在重新整理
	if(width>document.body.clientWidth)
	{
		DIV_QuickNew.style.width = 100;
		Portlet_OnResize("Portlet_ResetQuickNew()");
	}
	else
		DIV_QuickNew.style.width = tdObj.clientWidth;
	QuickNew_CheckScrollPicInit();
}

/******************************************************************************
功能：页面的onresize事件
参数：
	func：
		字符串：说明该函数由程序触发，func是需要执行的函数的字符串
		对象：说明该函数由window的事件触发，func是事件对象
******************************************************************************/
function Portlet_OnResize(func)
{
	//因为窗口大小每发生改变，onresize事件就会触发，使用setTimeout可以缓冲一下，不在每次触发的时候都进行处理
	if(typeof(func)!="string")
	{
	//该函数由window.onsize事件触发，执行所有曾经执行过的函数
		for(func in S_PortalInfo.TimeOutID)
		{
			if(S_PortalInfo.TimeOutID[func]!=0)
				clearTimeout(S_PortalInfo.TimeOutID[func]);
			S_PortalInfo.TimeOutID[func] = setTimeout(func, 100);
		}
	}
	else
	{
	//该函数由程序触发，执行指定的函数
		if(S_PortalInfo.TimeOutID[func]==null)
			S_PortalInfo.TimeOutID[func] = 0;
		if(S_PortalInfo.TimeOutID[func]!=0)
			clearTimeout(S_PortalInfo.TimeOutID[func]);
		S_PortalInfo.TimeOutID[func] = setTimeout(func, 100);
	}
}
window.attachEvent("onresize",Portlet_OnResize);

/******************************************************************************
功能：重新整理窗口内容的长度，使它刚好达到满屏的效果
******************************************************************************/
function Portlet_ResetText()
{
	S_PortalInfo.TimeOutID["Portlet_ResetText()"] = 0;
	//获取到所有可折行的内容对象
	var textObj = getElementArray(document.all.LKS_Content_TXT);
	var doAgain = false;	//是否需要再Reset一次
	var i, lastObj, pObj, wordWidth, wordNum;
	for(i=0; i<textObj.length; i++)
	{
		pObj = textObj[i].offsetParent;			//内容对象的父对象中可定位的对象
		lastObj = pObj.lastChild;				//pObj的最后一个节点，用于定位
		if(lastObj.id!="LKS_Content_END")
		{
			//若该定位对象不存在，则创建一个
			lastObj = document.createElement("<a id=LKS_Content_END style='font-size:1px'></a>");
			lastObj.innerHTML = "&nbsp;";		//若对象内容为空，则其offsetLeft等属性不准确
			pObj.appendChild(lastObj);
		}
		//wordWidth：字体的大小所占的像素
		wordWidth = parseInt(textObj[i].currentStyle.fontSize);
		if(isNaN(wordWidth))
			wordWidth = 15;
		if(textObj[i].offsetTop+wordWidth<lastObj.offsetTop)
		{
			/******************************************************************
				textObj[i].offsetTop+wordWidth文字地步到pObj的高度
				若lastObj距离pObj对象的高度大于这个高度，说明文字已经折行了
				折行的文本，先将内容缩到最少，然后再计算一次
			******************************************************************/
			//textObj[i].innerText = "..";
			Com_SetInnerText(textObj[i], "..");
			doAgain = true;
			continue;
		}
		//若textObj[i].innerText==textObj[i].title，说明文字已经全部显示，不需要处理
		if(textObj[i].innerText == textObj[i].title || textObj[i].textContent == textObj[i].title)
			continue;
		/**********************************************************************
		下面一句计算整行总共可以容纳多少个字符，计算逻辑为
		1、计算右边空白的宽度，计算方法为：“整个框的宽度-最后一个对象的相对距离”
			pObj.offsetWidth-lastObj.offsetLeft
		2、计算正在显示的文字所占的宽度，计算方法为：“文字的下个对象的相对距离-文字对象的相对距离”
			textObj[i].nextSibling.offsetLeft-textObj[i].offsetLeft
		3、将1和2的结果相加，得出整行有多少空间用于显示文字
		4、将3的结果/文字的宽度*2，得出可容纳多少个英文字符
			注意到：一个中文字符占用了两个英文字符的空间
		5、最后的“-4”是预留了4个字符的空间，用于滚动条以及前面计算的一些微小的误差
		**********************************************************************/
		wordNum = Math.round((pObj.offsetWidth-lastObj.offsetLeft+textObj[i].nextSibling.offsetLeft-textObj[i].offsetLeft)/wordWidth*2)-6;
		//设置展现的文字信息
		//textObj[i].innerText = getSubstringByByteLength(textObj[i].title, wordNum);
		Com_SetInnerText(textObj[i], getSubstringByByteLength(textObj[i].title, wordNum));
	}
	//处理是否需要重做一次调整
	if(doAgain)
		Portlet_OnResize("Portlet_ResetText()");
}

/******************************************************************************
功能：滚动快速新建按钮栏
参数：
	direct：
		1，向右
		-1，向左
******************************************************************************/
function QuickNew_Scroll(direct)
{	
	var btnList = getElementArray(document.all.Btn_QuickNew);
	//btnList.length<2表示只有一个按钮，无需滚动
	if(btnList.length<2){
		QuickNew_CheckScrollPic();
		return;
	}
	//DIV_QuickNew.scrollLeft!=Btn_QuickNew[S_PortalInfo.QuickNewIndex].offsetLeft表明按钮已经无法再向右滚，忽略向右滚操作
	if(DIV_QuickNew.scrollLeft!=Btn_QuickNew[S_PortalInfo.QuickNewIndex].offsetLeft && direct>0){
		QuickNew_CheckScrollPic();
		return;
	}
	S_PortalInfo.QuickNewIndex += direct;
	if(S_PortalInfo.QuickNewIndex<0)
	{
		//索引越界，回滚
		S_PortalInfo.QuickNewIndex -= direct;
		QuickNew_CheckScrollPic();
		return;
	}
	if(S_PortalInfo.QuickNewIndex>=btnList.length)
	{
		//索引越界，回滚
		S_PortalInfo.QuickNewIndex -= direct;
		QuickNew_CheckScrollPic();
		return;
	}
	DIV_QuickNew.scrollLeft = Btn_QuickNew[S_PortalInfo.QuickNewIndex].offsetLeft;
	QuickNew_CheckScrollPic();
}
/******************************************************************************
功能：处理窗口的刷新
参数：
	unid：	窗口的uniqueID
******************************************************************************/
function Portlet_Refresh(unid)
{
	var portletList = getElementArray(document.all.LKS_Portlet);
	for(var i=0; i<portletList.length; i++)
	{
		if(portletList[i].uniqueID==unid)
		{
			portletList[i].LKS_Refresh();
			return;
		}
	}
}
/*********************************************************************************************************
功能：初始化滚动快速新建按钮栏时判断是否显示左右滚动图片
参数：无
**********************************************************************************************************/
function QuickNew_CheckScrollPicInit(){
	var btnList = getElementArray(document.all.Btn_QuickNew);
	var tdObj = DIV_QuickNew.offsetParent;
	var	QuickNew_width;
	if(btnList.length<2){
		QuickNew_width=Btn_QuickNew.offsetWidth*(btnList.length);
	}else{
		QuickNew_width=Btn_QuickNew[S_PortalInfo.QuickNewIndex].offsetWidth*(btnList.length);
	}
	//只有一个新建图标,或容器宽度大于内容长度,此两种情况左右滚动图片都不出现
	if(btnList.length<2 || QuickNew_width<=(tdObj.clientWidth+10)){ 
		SetQuickNewScrollPic(false,false);
		return;
	}
	QuickNew_width=Btn_QuickNew[S_PortalInfo.QuickNewIndex].offsetWidth*(btnList.length-S_PortalInfo.QuickNewIndex);
	//容器长度小于内容长度,出现左边滚动图片
	if(QuickNew_width>=(tdObj.clientWidth+8)){ 
		SetQuickNewScrollPic(null,true);
	}else{
		SetQuickNewScrollPic(null,false);
	}
}
/******************************************************************************
功能：滚动快速新建按钮栏时,判断是否显示左右滚动图片
参数：无
******************************************************************************/
function QuickNew_CheckScrollPic(){
	var btnList = getElementArray(document.all.Btn_QuickNew);
	var tdObj = DIV_QuickNew.offsetParent;
	var	QuickNew_width;
	if(btnList.length<2){
		QuickNew_width=Btn_QuickNew.offsetWidth*(btnList.length);
	}else{
		QuickNew_width=Btn_QuickNew[S_PortalInfo.QuickNewIndex].offsetWidth*(btnList.length);
	}
	//只有一个新建图标,或容器宽度大于内容长度,此两种情况左右滚动图片都不出现
	if(btnList.length<2 || QuickNew_width<=(tdObj.clientWidth+10)){
		SetQuickNewScrollPic(false,false);
		return;
	}
	//DIV_QuickNew.scrollLeft!=Btn_QuickNew[S_PortalInfo.QuickNewIndex].offsetLeft 表明按钮已经无法再向右滚，向右滚动的图片不再显示
	if(DIV_QuickNew.scrollLeft!=Btn_QuickNew[S_PortalInfo.QuickNewIndex].offsetLeft){ 
		SetQuickNewScrollPic(null,false);
	}else{
		SetQuickNewScrollPic(null,true);
	}
	//向右数组越界,则不再显示向右滚动的图片
	if(S_PortalInfo.QuickNewIndex>=btnList.length) 
	{
		SetQuickNewScrollPic(null,false);	
	}
	//向左数组越界,则不再显示向左滚动的图片
	if(S_PortalInfo.QuickNewIndex<=0)
	{
		SetQuickNewScrollPic(false,null);
	}else{
		SetQuickNewScrollPic(true,null);
	}
}
/******************************************************************************
功能：格式化URL
参数：url
******************************************************************************/
function formatUrl(url){
	if(url==null)
		return null;
	if(url.charAt(0)=="/")
		return Com_Parameter.ContextPath + url.substring(1);;
	return url;
}

//标签之前切换时执行 add by wubing date:2009-12-07
function showMultiTab(uuid,index,type){
	var portletID = document.getElementById(uuid).getAttribute("LKS_Portlet_ID");
	var portletDiv = document.getElementById(portletID);
	if(portletDiv==null){
		return;
	}
	var lksInfo = portletDiv.getAttribute("LKS_Info");
	var infoObj = eval("({"+lksInfo+"})");
	var tabs = eval(infoObj["TabFrameData"]);
	if(type=="extend"){
		_tagParent.innerHTML = getExtendTabBlockHTML(tabs,index);
	}else{
		_tagParent.innerHTML = getLimitTabBlockHTML(tabs,index);
	}

	for(var i=0;i<tabs.length;i++){
		if(i==index){
			var html = document.getElementById(tabs[i]["UUID"]).innerHTML;
			if(html==""){
				portletDiv.handleTabHTML(tabs[i]);
			}else{
				if(tabs[i].Height!=null)
					portletDiv.style.height = tabs[i].Height;
			}
			document.getElementById(tabs[i]["UUID"]).style.display="";
		}else{
			document.getElementById(tabs[i]["UUID"]).style.display="none";
		}
	}
	if(!S_PortalInfo.DesignMode)
		Portlet_OnResize("Portlet_ResetText()");

}

function getTagNodeParent(){
	var node = event.srcElement;
	for(;node = node.parentNode;){
		if(node.tagName=="CODE"){
			return node;
		}
	}
	return null;
}

function getTabTitleHTML(obj,index,type){
	var html = [];
	if(obj.MoreURL!="" && !S_PortalInfo.DesignMode){
		html.push('<a onfocus=this.blur() href="'+formatUrl(obj.MoreURL)+'" target='+obj.MoreTarget+'>');
	}
	html.push('<nobr title="'+obj.Title+'" onmouseover="showTabTrigger(\''+obj.UUID+'\','+index+',\''+type+'\');" onmouseout="clearShowTabTrigger();">'+obj.Title+'</nobr>');
	if(obj.MoreURL!="" && !S_PortalInfo.DesignMode){
		html.push('</a>');
	}

	return html.join('');
}

var _tabTrigger = null,_tagParent=null,_tagTempUUID=null;

function clearShowTabTrigger(){
	if(_tabTrigger!=null){
		_tagTempUUID = null;
		clearTimeout(_tabTrigger);
	}
}

function showTabTrigger(uuid,index,type){
	if(_tagTempUUID==uuid){
		return ;
	}
	_tagTempUUID=uuid;
	var ms = 300;//0.3秒
	_tagParent = getTagNodeParent();
	_tabTrigger = setTimeout('showMultiTab(\"'+ uuid+'\",'+index+',\"'+type+ '\")',ms);
}
