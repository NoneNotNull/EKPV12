function EventRightClick (_targetElement)
{ 
	var thisObject = this;
	this.targetElement = _targetElement;
	this.menuId = "mouse_menu_right";
	this.menuItem = [];
	this.init = function(){
		if(!document.getElementById(thisObject.menuId)){
			var x = document.createElement("div");
			x.id = thisObject.menuId;
			x.style.visibility="hidden";
			x.style.position="absolute";
			x.style.width = "100px";
			x.style.backgroundColor  = "#f0f0f0";
			x.style.border = "1px solid #f0f0f0"; 
			thisObject.addEvent(x,'mousedown',thisObject.sotpBub);
			thisObject.addEvent(x,'mousedown',thisObject.suppressBrowserMenu);
			document.body.appendChild(x);
		}
	};
	this.sotpBub = function(){
		e = thisObject.getEvent();
		if (window.event){
			e.cancelBubble = true;
		}else{
			e.stopPropagation();
		}
		return false;
	};
	this.display = function(e){
		thisObject.init();
		var mouseMenu = document.getElementById(thisObject.menuId);
		mouseMenu.style.visibility = 'hidden';
		var tg = (window.event) ? e.srcElement : e.target;
		var isClickTargetElement = thisObject.isSubElement(tg,thisObject.targetElement);
		if(isClickTargetElement){
			var posx = 0;
			var posy = 0;
			if(!e) var e = window.event;
			if (e.pageX || e.pageY)	{
				posx = e.pageX;
				posy = e.pageY;
			}else if (e.clientX || e.clientY){
				posx = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
				posy = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
			}
			mouseMenu.style.top = posy + 'px';
			mouseMenu.style.left = posx + 'px';
		} 
		thisObject.suppressBrowserMenu(e);
	};
	this.suppressBrowserMenu = function(e){
		if (e.preventDefault)	{
			e.preventDefault();
		}	else	{
			e.returnValue = false;
		} 
		if (navigator.userAgent.indexOf('Opera') != -1) 	{
			window.blur();
			window.focus();
		}
		return false;
	};
	this.isSubElement = function(tg,xobj){
		while(true){
			if(tg.nodeName == "BODY")
				return false;
			if(tg == xobj)
				return true;
			if(tg == null)
				return false;
			tg = tg.parentElement;
		}
		return false;
	};
	   
	this.addEvent = function( obj, type, fn ){
		if (obj.addEventListener)
			obj.addEventListener( type, fn, false );
		else if (obj.attachEvent)
			obj.attachEvent( "on"+type, fn );
	};
	this.removeEvent = function( obj, type, fn ){
		if (obj.removeEventListener)
			obj.removeEventListener( type, fn, false );
		else if (obj.detachEvent)
			obj.detachEvent( "on"+type, fn);
	};
	this.addMenu = function(name,location,argument){
		var m = {};
		m.name = name;
		m.location = location;
		m.argument = argument;
		thisObject.menuItem[thisObject.menuItem.length] = m;
		
		thisObject.show();
	};
	this.getMenu = function(){
		var html = "<table cellspacing='0' width='100%'>";
		for ( var i = 0; i < thisObject.menuItem.length; i++) {
			html += "<tr><td onclick=\"document.getElementById('"+thisObject.menuId+"').style.visibility = 'hidden';"+thisObject.menuItem[i].location+"("+thisObject.menuItem[i].argument+")\"" ;
			html += " style='padding:2px 16px 1px 12px;font-size:9pt; color:#000000; background-color:#CCCCCC; text-align:left; width:100%;' ";
			html += " onmouseout='this.style.color=\"#000000\";this.style.backgroundColor=\"#CCCCCC\";' ";
			html += " onmouseover='this.style.color=\"#FFFFFF\";this.style.backgroundColor=\"#000080\";this.style.cursor=\"pointer\"' ";
			html += ">"+thisObject.menuItem[i].name+"</td></tr>";
		}
		html += "</table>";
		return html;
	};
	this.getEvent = function(){
		if(window.event) 
	 		return window.event;//如果是ie
	  	func=arguments.callee.caller;
	    while(func!=null){
			var arg0=func.arguments[0];
			if(arg0){
				if(	(arg0.constructor == Event || arg0.constructor == MouseEvent || arg0.constructor == KeyboardEvent) 
					|| (typeof(arg0)=="object" && arg0.preventDefault && arg0.stopPropagation)
					){
					return arg0;
				}            
			}
			func=func.caller;
		}
		return null;
	};
	this.show = function(){
		document.getElementById(thisObject.menuId).innerHTML = thisObject.getMenu();
		document.getElementById(thisObject.menuId).style.visibility = "visible";
	}; 
	this.hide = function() {
		document.getElementById(thisObject.menuId).style.visibility = "hidden";
	};
	this.display(this.getEvent());
	
}
function EventRightClickHide(){
	if(document.getElementById("mouse_menu_right"))
		document.getElementById("mouse_menu_right").style.visibility = "hidden";
}
Com_AddEventListener(document,"mousedown",EventRightClickHide);
