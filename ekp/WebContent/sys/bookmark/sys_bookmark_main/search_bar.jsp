<%@page import="com.landray.kmss.sys.config.design.SysConfigs"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
var Search_ModelName = "com.landray.kmss.sys.bookmark.model.SysBookmarkMain";
function Search_Show(){
	Search_Div.style.top = 38+"px";
	Search_Div.style.display = "";
}

function Search_Hide(){
	Search_Div.style.display = "none";
}

function Search_Simple(){
	var keyField = document.getElementsByName("Search_Keyword")[0];
	if(keyField.value==""){
		alert('<bean:message key="error.search.keywords.required"/>');
		keyField.focus();
		return;
	}
	Search_Hide();
	Com_OpenWindow("<c:url value="/sys/search/search.do?method=result&fdModelName=com.landray.kmss.sys.bookmark.model.SysBookmarkMain&v0_0=" />"+keyField.value,"_blank");
}

function Search_More(){
	Search_Hide();
	Com_OpenWindow("<c:url value="/sys/search/search.do?method=condition&fdModelName=" />"+Search_ModelName,"_blank");
}
</script>
<div id="Search_Div" style="display:none; position:absolute; top:5px; right:20px;">
	<table class="tb_search">
		<tr>
			<td nowrap>
				&nbsp;<bean:message key="message.quickSearch"/>:<bean:message key="message.keyword"/>
			</td>
			<td nowrap>
				<input name="Search_Keyword" class="input_search" onkeydown="if (event.keyCode == 13 && this.value !='') Search_Simple();" >
				<input type="button" class="btn_search" onclick="Search_Simple();" value="<bean:message key="button.search"/>">
				<% if(SysConfigs.getInstance().getSearch("com.landray.kmss.sys.bookmark.model.SysBookmarkMain")!=null){ %>
				<input type="button" class="btn_search" onclick="Search_More();" value="<bean:message key="button.advancedSearch"/>" >
				<% } %>
			</td>
			<td valign="top">
				<a href="#">
					<img alt="<bean:message key="button.close"/>" border="0" src="${KMSS_Parameter_StylePath}icons/x.gif" width="5" height="5" hspace="2" vspace="2" onclick="Search_Hide();">
				</a>
			</td>
		</tr>
	</table>
</div>