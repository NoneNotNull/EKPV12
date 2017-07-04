<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%-- 
<div id="bookmarkBtn" style="display:none;">
	<input type="button" value="<bean:message key="button.bookmark" bundle="sys-bookmark"/>" 
		onclick="ShowBookmarkDialog();">
</div>

<script language="JavaScript">
OptBar_AddOptBar("bookmarkBtn");
function ShowBookmarkDialog() {
	if (!List_CheckSelect()) return;
	var select = document.getElementsByName("List_Selected");
	var ids = "";
	for(var i=0; i<select.length; i++) {
		if(select[i].checked) {
			ids += select[i].value+";";
		}
	}
	ids= ids.substring(0, ids.length-1)
	var openurl = "<c:url value="/sys/bookmark/include/bookmark_edit_all.jsp" />";
	var width = 600;
	var height = 380;
	var left = (screen.width-width)/2;
	var top = (screen.height-height)/2;
	var fdModelName = "${param.fdModelName}";
	var fdTitleProName = "${param.fdTitleProName}";
	// for IE and FF3
	var winStyle = "resizable:1;scroll:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;dialogleft:"+left+";dialogtop:"+top;
	openurl = "<c:url value="/resource/jsp/frame.jsp?url=" />" + encodeURIComponent(openurl);
	showModalDialog(openurl, {'fdModelName': fdModelName, 'fdTitleProName': fdTitleProName , 'ids' : ids}, winStyle);
}
</script>
 --%>