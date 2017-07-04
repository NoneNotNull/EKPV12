/*压缩类型：无*/
document.writeln("<link rel=stylesheet href="+Com_Parameter.StylePath+"tree/tree_page.css>");
document.writeln("<style>");
document.writeln("*{ margin:0; padding:0;}");
document.writeln("body{ scrollbar-face-color:#f2f2f2;scrollbar-arrow-color:#cccccc;scrollbar-highlight-color:#fdfdfd;scrollbar-3dlight-color:#e5e5e3;scrollbar-shadow-color:#959794;scrollbar-darkshadow-color:#ffffff;scrollbar-track-color:#eeeeee;}");
switch(TREESTYLE){
case "nav":
	document.writeln("body{ background:#ffffff;}");
	document.writeln(".treediv {position: absolute;z-index:1; top:10px; left:10px;}");
	break;
case "LV1":
case "LV3":
	document.writeln("body{ background:#ffffff; border-top:1px solid #ccc;scrollbar-face-color:#f2f2f2;scrollbar-arrow-color:#cccccc;scrollbar-highlight-color:#fdfdfd;scrollbar-3dlight-color:#e5e5e3;scrollbar-shadow-color:#959794;scrollbar-darkshadow-color:#ffffff;scrollbar-track-color:#eeeeee;}");
	document.writeln(".treediv{ padding:10px 0 0 10px;}");
	break;
case "LV2":
	document.writeln("body{background:url("+Com_Parameter.StylePath+"tree/lock_bg.gif) repeat-x}");
	document.writeln(".treediv {position: absolute;z-index:1; top:36px; left:10px;}");
	break;
default:
	document.writeln(".treediv{ padding:10px 0 0 10px;}");
}
document.writeln("</style>");
IMGPATHPREFIX=Com_Parameter.StylePath+"tree/";