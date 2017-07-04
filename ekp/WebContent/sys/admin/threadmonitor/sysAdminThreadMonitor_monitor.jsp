<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<div id="optBarDiv">
	<input type="button" value="设置拦截地址"
		onclick="window.open('<c:url value="/sys/admin/threadmonitor.do?method=edit" />','_blank');"/>
	<input type="button" value="查看所有线程"
		onclick="window.open('<c:url value="/sys/admin/threadmonitor/threaddump.jsp" />','_blank');"/>
	<input type="button" value="刷新"
		onclick="history.go(0);"/>
</div>
<div style="text-align:right; line-height: 30px; padding-right:10px;">
	当前已经设置了&nbsp;<span style="color: #FF0000;font-weight: normal; font-size: 16px;">${urlBlockSize}</span>&nbsp;个拦截地址，
	以下列表为当前服务器所有HTTP请求的线程信息
</div>
<table id="List_ViewTable">
	<tr>
		<td width="40px">
			序号
		</td>
		<td width="120px">
			线程名
		</td>
		<td>
			请求地址
		</td>
		<td width="80px">
			用户
		</td>
		<td width="120px">
			IP
		</td>
		<td width="80px">
			历时（毫秒）
		</td>
	</tr>
	<c:forEach items="${threadDetails}" var="threadDetail" varStatus="status">
		<tr>
			<td>
				${status.index+1}
			</td>
			<td>
				<c:out value="${threadDetail.threadName}" />
			</td>
			<td style="text-align: left;">
				<c:out value="${threadDetail.url}" />
			</td>
			<td>
				<c:out value="${threadDetail.user}" />
			</td>
			<td>
				<c:out value="${threadDetail.ip}" />
			</td>
			<td>
				<kmss:showDecimalNumber pattern="#,###" value="${threadDetail.timeDuration}" />
			</td>
		</tr>
	</c:forEach>
</table>
<br>
<%@ include file="/resource/jsp/list_down.jsp"%>