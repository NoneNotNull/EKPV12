<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>  
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script>
Com_IncludeFile("doclist.js|dialog.js|optbar.js");
Com_IncludeFile("tag_top_head.css", "style/"+Com_Parameter.Style+"/tag/");
</script>
<script>
//打开帮助
function openHelp(){
	 Com_OpenWindow('<c:url value="/sys/tag/sys_tag_top/tag_top_help.jsp"/>',"");
} 
//搜索提交
function  CommitSearch(){
	var queryString = document.getElementsByName("queryString")[0];
	 
	if(queryString.value==null||queryString.value==""||queryString.value=="<bean:message bundle='sys-tag' key='sysTagTags.inputTag' />"){//请输入内容
		alert("<bean:message bundle='sys-tag' key='sysTag.inputContent' />");
		queryString.focus();
		return ;
    }
	var queryType = document.getElementsByName("queryType")[0].value;
//	Com_OpenWindow("<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=searchMain&queryString="+encodeURI(queryString.value)+"&queryType="+encodeURI(queryType)+"'/>,'_blank'");
  Com_OpenWindow("<c:url value='/sys/ftsearch/searchBuilder.do?method=search&queryString="+encodeURI(queryString.value)+"&searchFields=tag&isSearchByButton=true&newLUI=true&facetClickPara=false&outModel=&modelGroupChecked='/>,'_blank'");
}
//清空搜索栏
function clearQuery(){
	var queryString = document.getElementsByName("queryString")[0];
	var q5= document.getElementById("q5");
	if(queryString.value=="<bean:message bundle='sys-tag' key='sysTagTags.inputTag' />"){
		queryString.value="";
		queryString.focus();
		q5.style.color="#1A1FE0";
	}
}
</script>
<body>  
<DIV class="bk_div">
<DIV style="margin-top: 25px;height: 90px">  
<table  width="95%"  border=0 style="text-align: right">
		<tr>
			<td style="width: 19%" ><img src='${KMSS_Parameter_StylePath}tag/glass.gif'> &nbsp;&nbsp;</td>
			<td align="center" style="width: 65%"> 
			    <input type='hidden' name="queryType"  />
				<input type='text' name="queryString" style="width:100%" id="q5" class="searchInput inputsgl" value="<bean:message bundle='sys-tag' key='sysTagTags.inputTag' />"
				 onkeydown="if (event.keyCode == 13 && this.value !='') CommitSearch();"
				 onfocus="clearQuery()"/>			 
			 </td>
			 <%--搜索--%> 
			<td  > 			
			<DIV  class="tab"> 
	 				<a href="javascript:void(0);" title="<bean:message bundle="sys-tag" key="sysTagResult.search" />" onclick="CommitSearch()" >
	 				<span>
	 				<bean:message bundle="sys-tag" key="sysTagResult.search" /></span>
	 				</a>  
	 			</DIV>
	 		</td>
			<td  >
		 	<%--帮助--%> 
				<DIV  class="tab" > 
	 				<a href="javascript:void(0);" title="<bean:message bundle="sys-tag" key="sysTagResult.help" />" onclick="openHelp()" >
	 				<span>
	 				<img src="${KMSS_Parameter_StylePath}tag/help.gif" style="float: left; margin-top: -4px;margin-right: 3px;" />
	 				<bean:message bundle="sys-tag" key="sysTagResult.help" />
	 				</span>
	 				</a>  
	 			</DIV> 
			</td>
		</tr> 
	</table> 
</DIV> 
</DIV>  
</body> 
 
