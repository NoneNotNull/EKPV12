<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/sys/praise/sysPraiseMain_view_js.jsp"%>
<%@page import="com.landray.kmss.sys.praise.service.ISysPraiseMainService"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.util.UserUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/sys/praise/style/view.css" />
<c:set var="formName" value="${requestScope[param.formName]}"/>

<%
	ISysPraiseMainService sysPraiseMainService = 
			(ISysPraiseMainService) SpringBeanUtil.getBean("sysPraiseMainService");
	Boolean isPraised = sysPraiseMainService.checkPraised(UserUtil.getUser().getFdId(),
							request.getParameter("fdModelId"),request.getParameter("fdModelName"));
	pageContext.setAttribute("isPraised",isPraised);
	
	String praise = ResourceUtil.getString("sys-praise:sysPraiseMain.praise");
	String cancelPraise = ResourceUtil.getString("sys-praise:sysPraiseMain.cancel.praise");
	if(isPraised){
		pageContext.setAttribute("title",cancelPraise);
	}else{
		pageContext.setAttribute("title",praise);
	}
%>
<script type="text/javascript">
	//重写点赞，实现与悬浮框联动
	window.sysPraise_forum = function(praiseId) {
		var praiseObj = $("#aid_" + praiseId);
		var fdModelId = praiseObj.attr("praise-data-modelid");
		var fdModelName = praiseObj.attr("praise-data-modelname");
		LUI.$
				.ajax( {
					type : "POST",
					url : "<c:url value='/sys/praise/sys_praise_main/sysPraiseMain.do?method=executePraise'/>",
					data : {
						fdModelId : fdModelId,
						fdModelName : fdModelName
					},
					dataType : 'text',
					async : false,
					success : function(data) {
						var praiseCount = parseInt($("#aid_" + praiseId
								+ ' #praise_count')[0].innerHTML);
						var isPraised = $("#check_" + praiseId).val();
						if ("true" == isPraised) {
							$("#check_" + praiseId).val("false");
							$("#aid_" + praiseId + ' #praise_count')[0].innerHTML = praiseCount - 1;

							$("#aid_" + praiseId + ' #praise_icon')
									.removeClass("sys_unpraise").addClass(
											"sys_praise");
							$("span[data-lui-id='" + fdModelId + "']")
									.attr("title",
											"${ lfn:message('sys-praise:sysPraiseMain.praise')}");
							//悬浮框
							$("#check_isPraised").val("false");
	            			$("#fix_praise_count")[0].innerHTML = praiseCount - 1;
	            		    $("#fix_praise").attr("title","${ lfn:message('sys-praise:sysPraiseMain.praise')}");
						} else {
							$("#check_" + praiseId).val("true");
							$("#aid_" + praiseId + ' #praise_count')[0].innerHTML = praiseCount + 1;

							$("#aid_" + praiseId + ' #praise_icon')
									.removeClass("sys_praise").addClass(
											"sys_unpraise");
							$("span[data-lui-id='" + fdModelId + "']")
									.attr("title",
											"${ lfn:message('sys-praise:sysPraiseMain.cancel.praise')}");
							//悬浮框
							$("#check_isPraised").val("true");
							$("#fix_praise_count")[0].innerHTML = praiseCount + 1;
							$("#fix_praise").attr("title","${ lfn:message('sys-praise:sysPraiseMain.cancel.praise')}");
						}
					},
					error : function() {

					}
				});
	};
</script>
<input type="hidden" name="isPraised" value="${isPraised}" id="check_${param.fdModelId}">
<span id="aid_${param.fdModelId}" 
		praise-data-modelid="${param.fdModelId}" praise-data-modelname="${param.fdModelName}" style="position:relative;">
	<span onclick="sysPraise_forum('${param.fdModelId}');" class="cur" data-lui-id='${param.fdModelId}' title="${title}">
		<span id="praise_icon" class="${isPraised == true ? 'sys_unpraise' : 'sys_praise'}" ></span>
		<span id="praise_count" class="praise_count">
			${not empty param.docPraiseCount ? param.docPraiseCount : formName.docPraiseCount}
		</span>
	</span>
	<div class="lui_praise_layer" style="display:none;">
		<html:hidden property="showPraiserCount" value="${param.showPraiserCount}"/>
		<div class="bg">
			<table class="lui_praise_table">
				<tr>
					<td>
						<div class="content layer_person">
							<div class="lui_praise_close_d" id="praise_close">
								<span class="lui_praise_close_s"></span>
							</div>
							<ul class="person_list clearfix" id="praisedPerson_list">
							</ul>
							<div id="praise_page_list" class="praise_page_list">
								<a class="praise_page_set">
									<span>
										<em onclick="prePage('${param.fdModelId}');" data-praise-mark="1" class="praise_icon_l" id="btn_preno"></em>
									</span>
									<span>
										<em onclick="nextPage('${param.fdModelId}');" data-praise-mark="1" class="praise_icon_r" id="btn_nextno"></em>
									</span>
								</a>
							</div>
						</div>
					</td>
				</tr>
			</table>
			<div class="app_arrow app_arrow_p"></div>
		</div>
	</div>
</span>
