<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.search.web.SearchConditionEntry" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<link href="${KMSS_Parameter_StylePath}button/button.css" rel="stylesheet" type="text/css" />
<meta name="Keywords" content="" />
<meta name="Description" content="" />
<meta http-equiv="Content-Language" content="zh-cn" />
<head>
	
<script type="text/javascript">
//显示从第三行显示到最后
OptBar_IncludeChildWindow = true;
function setHiddenRow(oTable,iRow)//Writed by luhj
{
	show();
	var table =document.getElementById("TB_Condition");
	var countRow = table.rows.length;
	for(iRow;iRow<countRow;iRow++){
    	oTable.rows[iRow].style.display = "";
	}
	show_one_a();
}

//隐藏从第三到最后行

function hiddenRow()//by luhj
{
	show_one();
	//show();
	var oTable = document.getElementById("TB_Condition");
	var table =document.getElementById("TB_Condition");
	var countRow = table.rows.length;
	//var iRow = 3;
	//alert(countRow);
	for(var iRow=2;iRow<countRow;iRow++){
    oTable.rows[iRow].style.display = "none";
	}
	show_a();
}
// 打开窗口默认显示隐藏  by luhj 
window.onload = function(){
	<c:if test="${param.isShowMore=='true'}">
		show();
	</c:if>
	<c:if test="${param.isShowMore!='true'}">
		hiddenRow();
	</c:if>
}
	function getUrl(){

	var reurl;
	var url = null;
	reurl = countUrl() + "request.getRequestURL()";
	
	return reurl;
		}
//隐藏更多查询条件

function show(){
   document.getElementById("b").style.display = "none";
 }
//显示更多查询条件
 function show_one(){
   document.getElementById("b").style.display = "";
 }
 
//隐藏收回 by luhj
 function show_a(){
	   document.getElementById("a").style.display = "none";
	 }
	//显示收回
	 function show_one_a(){
	   document.getElementById("a").style.display = "";
	 }

//iframe自适应高度 by luhj
function SetWinHeight(obj) 
{ 
	var searchIframe=obj; 
		if (document.getElementById) 
		{ 
			if (searchIframe && !window.opera) 
				{ 
				if (searchIframe.contentDocument && searchIframe.contentDocument.body.offsetHeight) 
				searchIframe.height = searchIframe.contentDocument.body.scrollHeight; 
				else if(searchIframe.Document && searchIframe.Document.body.scrollHeight) 
				searchIframe.height = searchIframe.Document.body.scrollHeight; 
				} 
		} 
} 
</script>
</head>
<center>
<!--  
<p class="txttitle"><c:out value="${searchConditionInfo.title}" /></p>
-->
<c:choose>
	<c:when test="${not empty searchConditionInfo.sysSearchMain.fdKey}">
		<h4>${searchConditionInfo.sysSearchMain.fdName}</h4>
	</c:when>
	<c:otherwise>
		<h4><bean:message bundle="sys-search" key="search.documentQuery" /></h4>
	</c:otherwise>
</c:choose>
<form name="searchConditionForm" onsubmit="return false;">
<br>
<table width=95% class="tb_normal" id="TB_Condition" height="10%" align="center" style="border:  #c0c0c0 1px solid">
			<%@ include file="/sys/search/search_condition_entry.jsp"  %>
			<c:if test="${searchConditionInfo.conditionUrl!=null}">
				<c:import url="${searchConditionInfo.conditionUrl}" charEncoding="UTF-8"/>
			</c:if>
</table>
<table>
	<tr style="height: 5px;">
		<td>
		</td>
	</tr>
</table>
<div >
	<div style="width: 95%" align="right" >
			<a id="a" onclick="hiddenRow()" style= "color:#003acc;cursor: pointer; width: 90px;" ><bean:message bundle="sys-search" key="search.Withdraw" /></a>
			<a id="b" onclick="setHiddenRow(document.getElementById('TB_Condition'),2)"  style="color:#003acc;cursor: pointer;width: 90px;"><bean:message bundle="sys-search" key="search.moreSearchCriteria" /></a>
	</div>
</div>
<%--搜索  --%>
<div style="width: 100%;height: 23px;">
		<a class="btn_blue_input_s m_l20" href="#">
			<span>
				<input type="button" value="<bean:message key="button.search"/>" onclick="CommitSearch();" />
			</span>
		</a>
		&nbsp;&nbsp;
		<a class="btn_normal_input_s m_l20" href="#">
			<span>
				<input type="reset" value="<bean:message key="button.reset" />" onclick="resetDisplay()" />
			</span>
		</a>
</div>
    </form>
<div>
    <iframe src="" name="iframe" id="searchIframe" align="top" width="97%" Frameborder=No Border=0 Marginwidth=0 Marginheight=0 Scrolling=No onload="Javascript:SetWinHeight(this)">
    </iframe>
</div>

<script>
function emitResize() {

	if (window.dialog)
		dialog.content.emit('resize', {
			height: document.body.scrollHeight
		});
	else if (window.frameElement != null && window.frameElement.tagName == "IFRAME") {
		window.frameElement.style.height = document.getElementsByTagName('center')[0].offsetHeight + 70 + "px";
	} else
		return;
	setTimeout(emitResize, 200);
}
Com_AddEventListener(window, 'load', emitResize);
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>