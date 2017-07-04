<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%-- 暂时屏蔽
<script src='${ KMSS_Parameter_ContextPath }sys/bookmark/import/bookmark.js'></script>
<ui:button text="${ lfn:message('sys-bookmark:button.bookmark') }" onclick="batchBookmark()" order="1">
</ui:button>

<script language="JavaScript">

function batchBookmark(){
	var bids = getBookmarkIds();
	if(bids.length <= 0){
		seajs.use(['lui/dialog'],function(dialog){
			dialog.alert("${lfn:message('page.noSelect')}");
		});
		return;
	}
	___BookmarkDialog({'ids': getBookmarkIds(),'fdTitleProName':'${param.fdTitleProName}','fdModelId': '${param.fdModelId}','fdModelName': '${param.fdModelName}'});
}
function getBookmarkIds() { 
	var select = document.getElementsByName("List_Selected");
	var ids = "";
	for(var i=0; i<select.length; i++) {
		if(select[i].checked) {
			ids += select[i].value+";";
		}
	}
	if(ids.length > 0)
		ids= ids.substring(0, ids.length-1);
	return ids;
}
</script> --%>
