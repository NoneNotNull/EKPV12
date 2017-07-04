<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/resource/jsp/list_top.jsp"%>
<style type="text/css"> 
ul, li{list-style-type: none;} 
ul {padding:1px;margin:0px 0px 0px 0px;height: 100px;width: 100%;}
li { float:left;width: 50%;text-align: left;}
.clear {clear:both; height: 0px;}
</style>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("jquery.js");
</script>
<script>
//设置已选择记录的map值
function setSelectedMapValue(_this,index){
	var subject = document.getElementsByName("subject{"+index+"}")[0].value;
	var link = document.getElementsByName("link{"+index+"}")[0].value;
	var value;
	if(_this.checked){
		value = subject+"|"+link;
		parent.selectedMap.put(link,value);
	}
	else{
		parent.selectedMap.remove(link);
	}
}
//检查是否已经选择了这条记录
function checkIsSelect(key){
	var isSelect = false;
	if(parent.selectedMap.containsKey(key))
		isSelect = true;
	return isSelect;
}
</script>
<center>
<table width="95%">
	<% if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) { %>
		<tr>	
			<td>
				<ul id="staticPageContent">
					<li><bean:message bundle="sys-relation" key="sysRelationMain.noDocumentation" /></li>
				</ul>
				<div class="clear"></div>
			</td>
		</tr>
	<%
	} else {
	%>
	<tr>	
		<td>
			<ul id="staticPageContent">
				<c:forEach items="${queryPage.list}" var="lksHit" varStatus="vstatus">
					<li><script>
							if(checkIsSelect('${lksHit.lksFieldsMap["linkStr"].value}'))
								document.write("<input  type='checkbox' checked='checked' onclick='setSelectedMapValue(this,${vstatus.index})' />");
							else
								document.write("<input  type='checkbox' onclick='setSelectedMapValue(this,${vstatus.index})' />");
						</script>
						<input type='hidden' name='subject{${vstatus.index}}' value='${lksHit.lksFieldsMap["subject"].value}' />
						<input type='hidden' name='link{${vstatus.index}}' value='${lksHit.lksFieldsMap["linkStr"].value}' />
						<a target='_blank' href='<c:url value="${lksHit.lksFieldsMap['linkStr'].value }"/>'>
						${vstatus.index+1}
						<c:choose>
							<c:when test="${lksHit.lksFieldsMap['title']!=null}">
								${lksHit.lksFieldsMap['title'].value}
							</c:when>
							<c:when test="${lksHit.lksFieldsMap['fileName']!=null}">
								${lksHit.lksFieldsMap['fileName'].value}
							</c:when>
							<c:otherwise>
								${lksHit.lksFieldsMap['subject'].value}
							</c:otherwise>
						</c:choose>
						
						</a>
					</li>
				</c:forEach>
			</ul>
			<div class="clear"></div>
		</td>
	</tr>
	<%
	}
	%>
</table>
<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
</center>
<%@ include file="/resource/jsp/list_down.jsp"%>