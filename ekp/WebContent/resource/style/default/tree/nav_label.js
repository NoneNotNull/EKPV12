/*压缩类型：无*/
document.writeln("<link rel=stylesheet href="+Com_Parameter.StylePath+"tree/nav_label.css>");
function Nav_GetBarHTML(title)
{
	var htmlCode = "<h2 class='nav_title'>";
	htmlCode += "<span>"+title+"</span>"
	htmlCode += "</h2>"
	return htmlCode;
}