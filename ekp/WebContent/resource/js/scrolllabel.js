/*压缩类型：完全*/
/***********************************************
JS文件说明：
本JS文件中的函数不提供给普通模块调用。
该文件由导航滚动栏调用，滚动效果的调用函数。

作者：叶中奇
版本：1.0 2006-4-3
***********************************************/

Com_RegisterFile("scrolllabel.js");
Com_IncludeFile("nav_label.js", "style/"+Com_Parameter.Style+"/tree/");
var Nav_CurIndex = 0;					//当前展开的滚动栏索引
var Nav_PageList = new Array;			//数组，第n个滚动栏对应的URL
var Nav_Height;

/******************************************************************************
功能：实现导航栏的滚动效果
参数：
	index：	将要展现的滚动栏索引号
	x：		已经滚动的距离，不设置说明是第一次滚动
******************************************************************************/
function Nav_ScrollBar(index, x){
	//Nav_CurIndex==index说明点击的就是当前显示的栏目，不需要滚动
	if (Nav_CurIndex==index)
		return;
	var obj = document.getElementById("Nav_TBObj");
	var i = index*2+1;					//目标页面在表格中的索引号
	var j = Nav_CurIndex*2+1;			//原页面在表格中的索引号
	var barHeight = obj.rows[0].clientHeight;	//滚动栏的高度
	if(x==null){
		//若第一次滚动，将目标页面展现
		Nav_Height = document.body.clientHeight-Nav_PageList.length*barHeight-obj.offsetTop-2;
		obj.rows[i].style.display = "";
		x = 0;
	}
	//滚动80个像素
	x+=80;
	if (x>=Nav_Height){
		//目标页面即将展现的高度超过了能显示的高度，说明滚动可以结束
		x = Nav_Height;
		obj.rows[j].style.display = "none";
		obj.rows[i].style.height = null;
		Nav_CurIndex = index;
		try
		{
			//若iframe的URL跟当前页面的DNS根当前页面不同，访问其location会产生权限不足的错误，忽略该错误
			var objIframe = document.getElementById("Nav_Iframe_"+index);
			if(objIframe.src=="")
				objIframe.src = Nav_GetNavUrl(Nav_PageList[index]);
		}
		catch(e){}
	}else{
		//进行下一次滚动
		obj.rows[i].style.height = x<1?1:x;
		setTimeout("Nav_ScrollBar("+index+", "+x+")",1);
	}
}

/******************************************************************************
功能：返回滚动栏的HTML代码
******************************************************************************/
function Nav_Draw(DOMElem, pageList){
	var i, j, labelname, labelurl;
	var strHtml = "<table border=0 cellpadding=0 cellspacing=0 id=Nav_TBObj width=100% height=100%>";
	for(i=0; i<pageList.length; i++){
		j = pageList[i].indexOf("|");
		labelname = pageList[i].substring(0, j);
		labelurl = pageList[i].substring(j+1);
		Nav_PageList[i] = labelurl;
		//getNavBarHTML函数在主题风格的js中定义
		var labelTitle=labelname;
		var t,l = 0;
		for (t = 0; t < labelname.length && l < 20; t++) {
			if (labelname.charCodeAt(t)< 299) {
				l++;
			} else {
				l += 2;
			}
		 }
		if(l==20)
			labelTitle=labelname.substring(0,t)+"..";
	
		strHtml += "<tr><td class=navbar_label onclick=Nav_ScrollBar(" +i+ ") title='"+labelname+"'>"+Nav_GetBarHTML(labelTitle)+"</td></tr>";
		strHtml += "<tr style='"+(i!=0?"display:none;":"")+"'><td class=navbar_page><div style='width:100%;height:100%;overflow:auto'>";
		strHtml += "<iframe id=Nav_Iframe_"+i+(i==0?" src=\""+Nav_GetNavUrl(labelurl)+"\"":"")+" width=100% height=100% frameborder=0></iframe>";
		strHtml += "</div></td></tr>";
	}
	strHtml += "</table>";
	DOMElem.innerHTML = strHtml;
	//setTimeout("Nav_OnResize();", 10);
	if(window.Nav_DefaultIndex != null){
		Nav_ScrollBar(Nav_DefaultIndex);
	}
}

/******************************************************************************
功能：往原有的URL中加上主题风格信息
参数：
	orgUrl：原始URL
******************************************************************************/
function Nav_GetNavUrl(orgUrl){
	return orgUrl + (orgUrl.indexOf("?")>1?"&s_css=":"?s_css=") + Com_Parameter.Style;
}