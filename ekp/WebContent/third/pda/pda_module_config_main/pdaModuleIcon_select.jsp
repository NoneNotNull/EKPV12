<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/resource/jsp/htmlhead.jsp"%>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("jquery.js");
</script>
<style>
img{height: 60px;width: 62px;margin: 3px;border-width: 2px;border-style:solid;border-color:transparent;}
</style>
<script type="text/javascript">
$(document).ready(function(){ 
	 var obj = window.dialogArguments;
	 var height = 0;
	 var width = 0;
	 $("img").each(function (){
		 $(this).css("cursor","pointer");
		 if(obj!=null && obj.value == this.name){
			 $(this).css("border-color","#FF0000");
		 }else{
			 $(this).mouseover(function (){
					$(this).css("border-color","#0000FF");
				});
				$(this).mouseout(function (){
					$(this).css("border-color","transparent");
				});
		 }
		$(this).click(function (){
			if(obj!=null){
				obj.value = this.name;
			}
			window.close();
		});
		
	 });
});
</script><br>
<p class="txttitle"><bean:message bundle="third-pda" key="pdaModuleConfigMain.selectModuleIcon"/></p>
<body>
<center>
<c:set var="iconSize" value="${fn:length(iconUrls)}"/>
<c:set var="rowCount" value="${ iconSize%7==0 ?iconSize/7:(iconSize/7 + 1)}"/>
<c:if test="${ rowCount > 0}">
<table>
	<c:forEach var="x" begin="0" end="${rowCount-1}" step="1" >
		<tr>
			<c:forEach var="y" begin="0" end="6" step="1" >
				<td>
					<c:if test="${(x*7 + y) < iconSize}">
						<img align="middle" src='<c:url value="${iconUrls[x*7 + y]}"/>' name="${iconUrls[x*7 + y]}">
					</c:if>
				</td>
			</c:forEach>
		</tr>
	</c:forEach>
</table>
</c:if>
</center>
</body>
</html>