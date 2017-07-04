/*压缩类型：标准*/
/***********************************************
JS文件说明：
本JS文件中的函数不提供给普通模块调用。
本JS文件提供了页面中弹出菜单的对象

作者：叶中奇
版本：1.0 2006-4-3
***********************************************/
Com_RegisterFile("popwin.js");

var Popwin_ObjectList = new Array();

function PopWinObject(){
	var i=document.createElement("div");
	var bestScrollLeft = document.documentElement.scrollLeft==0?document.body.scrollLeft:document.documentElement.scrollLeft;
	var bestScrollTop = document.documentElement.scrollTop==0?document.body.scrollTop:document.documentElement.scrollTop;
	document.body.appendChild(i);
	this.id = "PopWinIframe_" + Math.floor(Math.random()*1000000);
	Com_SetOuterHTML(i, "<iframe IsPopWin=1 id='"+this.id+"' name='"+this.id+"' width=1 height=1 frameborder=0 scrolling=no style='position:absolute;display:none;z-index:99999'></iframe>");
	this.Iframe = document.getElementById(this.id);
	this.Iframe.Object = this;
	this.Parent = self;
	this.Window = window.frames[this.id];
	this.Document = this.Window.document;
	this.Window.document.open();
	this.Window.document.close();
	this.Window.PopWinObject = this;
	this.Body = this.Window.document.body;
	this.Iframe.setAttribute("id","");
	this.Body.style.borderWidth="2px";
	this.Body.style.borderStyle="outset";
	this.Body.style.marginTop=0;
	this.Body.style.marginLeft=0;
	this.Body.style.marginRight=0;
	this.Body.style.marginBottom=0;
	this.Body.style.backgroundColor="#cccccc";
	this.IsAutoSize = true;
	this.HideWhenMouseOut = true;
	this.ClearWhenHide = false;
	
	Com_AddEventListener(this.Iframe,"mouseover", function(){
		this.Object.Display = "block";
	});
	
	Com_AddEventListener(this.Iframe,"mouseout" ,function(){
		this.Object.Display = "none";
		setTimeout("if(window.PopWinObject.Display=='none' && window.PopWinObject.HideWhenMouseOut) window.PopWinObject.Hide();",2000);
	});

	this.Show = function (x,y,w,h,html){
		if(html)
			this.Body.innerHTML = html;
		if(h)
			this.Iframe.style.height = h + "px";
		if(w)
			this.Iframe.style.width = w + "px";
		if(y)
			this.Iframe.style.top = y + "px";
		if(x)
			this.Iframe.style.left = x + "px";
		this.Iframe.style.display = "block";
		if(this.IsAutoSize)
			this.Window.setTimeout("window.PopWinObject.AutoSize();",1);
		if(this.OnShow)
			this.Window.setTimeout("window.PopWinObject.OnShow();",10);
		Popwin_ObjectList[Popwin_ObjectList.length] = this;
	};
	
	this.AutoSize = function(){
		this.Iframe.style.width = this.Body.scrollWidth + "px";
		this.Iframe.style.height = this.Body.scrollHeight + "px";
	};
	
	this.BestPosition = function(){
		var x,y,cx,cy;
		var getNumber=function(str){
			str=str.replace(/[^\d]*/ig,"");
			if(str!=null && str!='')
				return parseInt(str, 10);
			return 0;
		};
		cx = document.body.clientWidth - this.ReferX - getNumber(this.Iframe.style.width);
		cy = document.body.clientHeight - this.ReferY - getNumber(this.Iframe.style.height);
		if(cx<0){
			this.Iframe.style.left = (getNumber(this.Iframe.style.left) + cx) + "px";
		}
		if(cy<0){
			this.Iframe.style.top = (getNumber(this.Iframe.style.top) + cy) + "px";
		}
	};
	
	this.PopByPoint = function(html,x,y){
		this.ReferX = x;
		this.ReferY = y;
		
		this.Show(this.ReferX + bestScrollLeft,this.ReferY + bestScrollTop ,null,null,html);
		this.Window.setTimeout("window.PopWinObject.BestPosition();",100);
	};
	
	this.PopByMouse = function(html){
		var eveObj = Com_GetEventObject();
		if(eveObj!=null){
			this.ReferX = eveObj.clientX;
			this.ReferY = eveObj.clientY;
		}
		this.Show(this.ReferX + bestScrollLeft,this.ReferY + bestScrollTop ,null,null,html);
		this.Window.setTimeout("window.PopWinObject.BestPosition();",100);
	};

	this.Hide = function(){
		if(this.Iframe.style.display!="none"){
			this.Iframe.style.display = "none";
			var tmpArr = new Array();
			for(var i=0; i<Popwin_ObjectList.length; i++){
				if(Popwin_ObjectList[i]!=this){
					tmpArr[tmpArr.length] = Popwin_ObjectList[i];
				}else{
					document.body.removeChild(this.Iframe);
				}
			}
			Popwin_ObjectList = tmpArr;
		}
	};
}

function Popwin_OnDocumentMouseDown(){
	for(var i=0; i<Popwin_ObjectList.length; i++){
		if(Popwin_ObjectList[i]!=null){
			Popwin_ObjectList[i].Hide();
		}
	}
	Popwin_ObjectList = new Array;
}

Com_AddEventListener(document, "mousedown", Popwin_OnDocumentMouseDown);