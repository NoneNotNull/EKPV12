/*压缩类型：标准*/
Com_RegisterFile("rightmenu.js");
Com_IncludeFile("popwin.js");

function MenuItem(name,location,argument){
	this.Name = name;
	this.Location = location;
	this.Argument = argument;
}
function RightMenuObject(width)
{
	this.MenuItems = new Array;
	this.PopWin = new PopWinObject();
	this.PopWin.ClearWhenHide = true;
	this.PopWin.Document.oncontextmenu = function(){return false;};
	this.Width = width?width:0;
	this.PopWin.RowMouseOver = function(item){
		item.style.color="#ffffff";
		item.style.backgroundColor="#000080";
	};
	this.PopWin.RowMouseOut = function(item){
		item.style.color="#000000";
		item.style.backgroundColor="#cccccc";
	};
	this.AddItem = function(name,location,argument){
		this.MenuItems[this.MenuItems.length] = new MenuItem(name, location, argument);
	};
	this.GetMenu = function(){
		var ishasMenu = false;
		var strHTML = "<table cellspacing=0>";
		for(var i = 0; i < this.MenuItems.length; i++){
			strHTML += "<tr><td><button style='font-size:9pt; color:#000000; background-color:#cccccc; text-align:left; padding:2px 16px 1px 12px;border:0 solid;";
			if(this.Width!=0)
				strHTML += "width:"+this.Width+"px;'";
			else
				strHTML += "'";
			strHTML += " onmouseout='window.PopWinObject.RowMouseOut(this);'";
			strHTML += " onmouseover='window.PopWinObject.RowMouseOver(this);'";
			if(this.MenuItems[i].Location)
				strHTML += " onclick=\"window.PopWinObject.Parent." + this.MenuItems[i].Location + "(" + (this.MenuItems[i].Argument?this.MenuItems[i].Argument:"") + ");window.PopWinObject.Hide();\"";
			strHTML += ">";
			strHTML += this.MenuItems[i].Name;
			strHTML += "</button></td></tr>";
			ishasMenu = true;
		}
		strHTML += "</table>";
		if(ishasMenu){
			strHTML += '<script type="text/javascript"></script>';
		}
		return strHTML;
	};
	this.Show = function(){
		this.PopWin.OnShow = function(){
			var btns=this.Document.getElementsByTagName("BUTTON");
			var buwidth=0;
			for(var i=0;i<btns.length;i++){
				var temp = btns[i].clientWidth;	
				if(btns[i].clientWidth > buwidth)
					buwidth=btns[i].clientWidth;
			}
			for(i=0;i<btns.length;i++)
				btns[i].style.width = buwidth;
		};
		this.PopWin.PopByMouse(this.GetMenu());
	};
}
