<%@page import="com.landray.kmss.sys.config.design.SysConfigs"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
var Search_ModelName = "${param.fdModelName}";
var Search_CustomPara = "${param.customPara}"; // 自定义参数
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
	/*
	var url = location.href;
	url = url.substring(0, url.indexOf("?"));
	*/
		var url = "<c:url value="/sys/ftsearch/searchBuilder.do?method=search"/>";
		var seq = parseInt(Com_GetUrlParameter(url, "s_seq"));
		seq = isNaN(seq)?1:seq+1;
		url = Com_SetUrlParameter(url, "s_seq", seq);
	 	url = Com_SetUrlParameter(url, "modelName", Search_ModelName);
		url = Com_SetUrlParameter(url, "queryString", keyField.value);
		Com_OpenWindow(url,"_blank");
	
	//Com_OpenWindow(url+"?method=search&queryString="+encodeURIComponent(keyField.value), "_blank");
}

function Search_More(){
	Search_Hide();
	Com_OpenWindow("<c:url value="/sys/search/search.do?method=condition&fdModelName=" />" + Search_ModelName + "&customPara=" + Search_CustomPara,"_blank");
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
				<%-- 
				<input type="button" class="btn_search" onclick="Search_Simple();" value="<bean:message key="button.search"/>">
				--%>
				<% if(SysConfigs.getInstance().getSearch(request.getParameter("fdModelName"))!=null){ %>
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