<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="_sysAuthFormName" value="${param['formName']}"/>
<c:set var="_sysAuthAssignMapName" value="${param['authAssignMapName']}"/>
<c:set var="_sysAuthForm" value="${requestScope[_sysAuthFormName]}"/>
<c:if test="${fn:length(_sysAuthForm[_sysAuthAssignMapName])>0}">
	<table class="tb_normal" style="width: 100%">
		<c:forEach var="moduleMap" items="${_sysAuthForm[_sysAuthAssignMapName]}">
			<tr class="tr_normal_title" style="text-align: left; cursor: pointer;"
				onclick="showRow(this);">
				<td>
					<img src="${KMSS_Parameter_StylePath}icons/minus.gif">
					&nbsp;&nbsp;<c:out value="${fn:substringAfter(moduleMap.key,'_')}" />
				</td>
			</tr>
			<tr>
				<td>
				<table class="tb_noborder" style="width:100%;margin-left:10px;margin-right:10px;">
					<c:set var="moduleRoles" value="${moduleMap.value}"/>
		  			<c:if test="${fn:length(moduleRoles)%3==0}">
		  				<c:set var="rowSize" value="${fn:length(moduleRoles)/3}"/>
		  			</c:if>
		  			<c:if test="${fn:length(moduleRoles)%3!=0}">
		  				<c:set var="rowSize" value="${fn:length(moduleRoles)/3+1}"/>
		  			</c:if>
		  			<c:forEach var="rowIndex" begin="0" end="${rowSize-1}" step="1">
						<tr>
							<c:forEach var="roleMap" items="${moduleRoles}" begin="${rowIndex*3}" end="${(rowIndex+1)*3-1}" step="1">
								<td width="33%">
									<label title='<c:out value="${roleMap.value.desc}" />'>
										<input type="checkbox" disabled="disabled" checked="checked" />
										<c:out value="${roleMap.value.name}" />
									</label>
								</td>
				  			</c:forEach>
				  			<c:if test="${fn:length(moduleRoles)<(rowIndex+1)*3}">
				  				<c:forEach begin="0" end="${(rowIndex+1)*3-fn:length(moduleRoles)}" step="1">
					  				<td width="33%">
					  					&nbsp;
					  				</td>
				  				</c:forEach>
				  			</c:if>
						</tr>
					</c:forEach>
				</table>
				</td>
			</tr>
		</c:forEach>
	</table>
	<script>
	function showRow(trObj){
		var obj = trObj.getElementsByTagName("IMG")[0];
		trObj = trObj.nextSibling;
		while(trObj!=null){
			if(trObj!=null && trObj.tagName=="TR"){
				break;
			}
			trObj = trObj.nextSibling;
		}
		var trObj$ = $(trObj);
		if(trObj$.is(":hidden")){
			trObj$.show();
			obj.setAttribute("src",Com_Parameter.StylePath+"icons/minus.gif");
		}else{
			trObj$.hide();
			obj.src = Com_Parameter.StylePath+"icons/plus.gif";
		}
	}
	</script>
</c:if>
