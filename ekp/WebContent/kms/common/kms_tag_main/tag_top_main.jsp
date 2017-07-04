<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<script src="${kmsResourcePath }/js/kms_tabview.js"></script>
<script>
Com_IncludeFile("data.js");
Com_IncludeFile("tag_top_main.css", "style/"+Com_Parameter.Style+"/tag/");
jQuery(document).ready(function() {
	var tabview = new KMS.TabView("#kmsTagMainTabview", {
		onTabshow: function(tab) {
			var target = tab.target[0];
			if (target.id == "kmsTagCloud") {
				var iframeCloud = document.getElementById("iframeCloud");
				iframeCloud.src="<c:url value='/sys/tag/sys_tag_top_log/sysTagTopLog.do?method=searchCloud'/>";
			}
		}
	});
	tabview.init(0);

	(function() {
		var iframeCloud = document.getElementById("iframeCloud"),
		resetIfrHeight = function() {
			var doc = iframeCloud.contentWindow.document,
			height = Math.max(doc.body.scrollHeight, doc.documentElement.scrollHeight);
			iframeCloud.height = height;
		};

		if (iframeCloud.attachEvent) {
			iframeCloud.attachEvent("onload", resetIfrHeight);
		} else {
			iframeCloud.onload = iframeCloud;
		}
	}());
});

function onClickTag(tagName,obj){
	var href = "<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=searchMain'/>";
	href=href+"&queryString="+encodeURIComponent(tagName)+"&queryType=normal";
	window.open(href,"_blank");
}

</script>
<style>
.tagBox { width:231px;height:400px;float:left;margin:6px; }
</style>
<div id="wrapper">
<div id="main" class="box c">
	<div class="con m_t10 tabview" id="kmsTagMainTabview"  style="width:100%;">
		<ul id="tags" class="c tab_ul" style="width:100%;">
			<li><a href="javascript:void(0)" rel="kmsTagTopRank">标签排行</a></li>
			<li><a href="javascript:void(0)" rel="kmsTagCloud">标签云图</a></li>
		</ul>
		<div id="tagContent">
			<div class="tagContent" id="kmsTagTopRank" style="width:100%;height:auto;">
				<%-- 最新标签TOP10 --%>
				<div class="box1 tagBox">
					<h2 class="h2_1">最新标签TOP10</h2>
					<div class="box2">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_a m_t10">
							<tr>
								<th>排名</th>
								<th>标签</th>
							</tr>
							<c:forEach items="${topFirstList}" var="sysTagTags" varStatus="v_status">
							<tr>
								<td>${v_status.index+1}</td>
								<td><a href="#" onclick="onClickTag('${sysTagTags.fdName}',this);">${sysTagTags.fdName }</a></td>
							</tr>
							</c:forEach>
						</table>
					</div>
				</div>
				
				<%-- 昨日最热TOP10 --%>
				<div class="box1 tagBox">
					<h2 class="h2_1">昨日最热TOP10</h2>
					<div class="box2">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_a m_t10">
							<tr>
								<th>排名</th>
								<th>趋势</th>
								<th>标签</th>
							</tr>
							<c:forEach items="${topSecondList}" var="sysTagTopLog" varStatus="v_status">
							<tr>
								<td>${v_status.index+1}</td>
								<td><kmss:showTagTrend trendValue="${sysTagTopLog.fdTrend}"/></td>
								<td><a href="#" onclick="onClickTag('${sysTagTopLog.fdSysTagTags.fdName}',this);">${sysTagTopLog.fdSysTagTags.fdName}</a></td>
							</tr>
							</c:forEach>
						</table>
					</div>
				</div>
				
				<%-- 7天内最热TOP10 --%>
				<div class="box1 tagBox">
					<h2 class="h2_1">7天内最热TOP10</h2>
					<div class="box2">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_a m_t10">
							<tr>
								<th>排名</th>
								<th>趋势</th>
								<th>标签</th>
							</tr>
							<c:forEach items="${topThirdList}" var="sysTagTopLog" varStatus="v_status">
							<tr>
								<td>${v_status.index+1}</td>
								<td><kmss:showTagTrend trendValue="${sysTagTopLog.fdTrend}"/></td>
								<td><a href="#" onclick="onClickTag('${sysTagTopLog.fdSysTagTags.fdName}',this);">${sysTagTopLog.fdSysTagTags.fdName}</a></td>
								<td></td>
							</tr>
							</c:forEach>
						</table>
					</div>
				</div>
				
				<%-- 热门搜索 --%>
				<div class="box1 tagBox">
					<h2 class="h2_1">热门搜索</h2>
					<div class="box2">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_a m_t10">
							<tr>
								<th>排名</th>
								<th>趋势</th>
								<th>标签</th>
							</tr>
							<c:forEach items="${topFourthList}" var="sysTagTopLog" varStatus="v_status">
							<tr>
								<td>${v_status.index+1}</td>
								<td><kmss:showTagTrend trendValue="${sysTagTopLog.fdTrend}"/></td>
								<td><a href="#" onclick="onClickTag('${sysTagTopLog.fdSysTagTags.fdName}',this);">${sysTagTopLog.fdSysTagTags.fdName}</a></td>
								<td></td>
							</tr>
							</c:forEach>
						</table>
					</div>
				</div>
				
				<%-- 分类排行--%>
				<c:forEach var="tempMap" items="${categoryList}" varStatus="vstatus_"> 
				<c:forEach var="tempMap_" items="${tempMap}"> 
				<c:set var="sysTagCategory" value="${tempMap_.key}"/>
				<c:set var="tagTopList" value="${tempMap_.value}"/>
				<c:if test="${vstatus_.index < 4}">
					<div class="box1 tagBox">
					<h2 class="h2_1">${sysTagCategory.fdName}</h2>
					<div class="box2">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_a m_t10">
							<tr>
								<th>排名</th>
								<th>趋势</th>
								<th>标签</th>
							</tr>
							<c:forEach items="${tagTopList}" var="sysTagTopLog" varStatus="v_status">
							<tr>
								<td>${v_status.index+1}</td>
								<td><kmss:showTagTrend trendValue="${sysTagTopLog.fdTrend}"/></td>
								<td><a href="#" onclick="onClickTag('${sysTagTopLog.fdSysTagTags.fdName}',this);">${sysTagTopLog.fdSysTagTags.fdName}</a></td>
								<td></td>
							</tr>
							</c:forEach>
						</table>
					</div>
					</div>
				</c:if>
				</c:forEach>
				</c:forEach>
				
				<div class="clear"></div>
			</div>
			<div class="tagContent" id="kmsTagCloud" style="width:100%;height:auto;">
				<iframe id="iframeCloud" width="100%" height="100%" frameborder="0" scrolling="no" marginheight="0"></iframe> 
			</div>
		</div>
	</div><!-- end #con -->
</div><!-- main end -->
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 