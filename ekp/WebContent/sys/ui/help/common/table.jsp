<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<script>
	function selectIdText(obj){
		Com_GetEventObject().cancelBubble=true;
		var span = LUI.$(obj);
		var input = LUI.$("<input style='position: absolute;width:"+(span.width()+16)+"px; border:0px;'>").insertBefore(span);
		input.val(span.text());
		input[0].select();
		input[0].focus();
		input.click(function(){return false;});
		input.blur(function(){input.remove();});
	}
</script>
<table style="width:100%;" class="tb_normal">
	<tr class="tr_normal_title">
		<td width="40px">序号</td>
		<c:forEach items="${columns}" var="column">
			<td>${column.name}</td>
		</c:forEach>
	</tr>
	<c:forEach items="${datas}" var="data" varStatus="vstatus">
		<tr kmss_id="${data.fdId}"
			<c:choose>
				<c:when test="${not empty onRowClick}">
					style="cursor:pointer;"
					onclick="${onRowClick}"
					kmss_help="${data.fdHelp}"
				</c:when>
				<c:when test="${not empty data.fdHelp}">
					style="cursor:pointer;"
					onclick="location.href='${LUI_ContextPath}${data.fdHelp}';"
				</c:when>
			</c:choose>
			onmouseover="this.style.backgroundColor='#F6F6F6';"
			onmouseout="this.style.backgroundColor='#FFFFFF';">
			<td style="text-align: center;">${vstatus.index+1}</td>
			<c:forEach items="${columns}" var="column">
				<td style="${column.style}">
					<c:choose>
						<c:when test="${column.id=='fdId'}">
							<span onclick="selectIdText(this);" style="cursor: text;"><c:out value="${data.fdId}" /></span>
						</c:when>
						<c:when test="${column.id=='fdThumb'}">
							<c:if test="${ not empty data.fdThumb }">
								<div style="display:inline-block">
									<img src="${LUI_ContextPath}${data.fdThumb}" style="max-height: 100px;">
									<ui:popup>
										<img src="${LUI_ContextPath}${data.fdThumb}" style="max-height:500px;">
									</ui:popup>
								</div>
							</c:if>
						</c:when>
						<c:when test="${column.type=='__custom__'}">
							<a href="javascript:void(0);" onclick="${ column.onclick }('${data.fdId}',event)">${empty column.text ? data[column.id] : column.text }</a>
						</c:when>
						<c:otherwise>
							<c:out value="${data[column.id]}" />
						</c:otherwise>
					</c:choose>
				</td>
			</c:forEach>
		</tr>
	</c:forEach>
</table>