<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<!doctype html>
<html style="height: 100%">
<head>
<title>提问</title>
<meta http-equiv="Content-Type" content="text/html;"/>
<meta http-equiv="Pragma" content="No-Cache"/>
<%@ include file="/kms/common/resource/jsp/tags.jsp" %>
<%@ include file="/kms/common/resource/jsp/include_kms.jsp"%>
<%@ include file="/kms/ask/pda/extends_edit_js.jsp" %>
</head>
<body style="padding: 0;margin: 0;height:100%;background-color: #d7d7d7;min-height: 0">
<html:form action="/kms/ask/kms_ask_topic/kmsAskTopic.do" style="height: 100%" method="post">
<!-- banner -->
	<c:if test="${param['isAppflag']!='1'}">
		<c:choose>
		<c:when test="${sessionScope['S_CurModule']!=null}">
			<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
				<c:param name="fdNeedReturn" value="true"/>
				<c:param name="fdModuleName" value="${sessionScope['S_CurModuleName']}"/>
				<c:param name="fdModuleId" value="${sessionScope['S_CurModule']}"/>
			</c:import>
		</c:when>
		<c:otherwise>
			<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
					<c:param name="fdNeedHome" value="true"/>
			</c:import>
		</c:otherwise>
		</c:choose>
	</c:if>
	<div style="height: 100%">
		<div class="textarea_div" style="height:195px"> 
			<textarea style="width: 100%;height:100%;font-size: 30px" name="docSubject"  placeholder="请输入问题内容~"></textarea>
		</div>
		<!-- 弹出层 -->
		<div id="" class="warn_div"></div>
		<div id="" class="warn2_div"></div>
		
		<div class="ask_submit" style="height: 100%">
			<div style="padding-bottom: 1px; ">
				<ul class="money_title">
					<li style="float: left;">
						<span class="icon_value" style="float: left">悬赏：</span>
						<input name="fdScore" type="hidden" value="0">
						<div class="score_box">0</div>
					</li>
					<li style="float: right;">
						<img src="${kmsThemePath}/img/tips.gif" border="0" />
						<span style="color: #999999"><bean:message  bundle="kms-ask" key="kmsAskScore.currMoney.msg"/><b>${fdScore}</b></span>
					</li>
					<div class="clear"></div>
				</ul>
				<div class="money_content">
					<ul>
						<li class="out" score="0" >
							0分
						</li>
						<li class="out" score="5" >
							5分
						</li>
						<li class="out" score="10" >
							10分
						</li>
						<li class="out" score="20" >
							20分
						</li>
						<li class="out" score="30" >
							30分
						</li>
						<li class="out" score="60" >
							60分 
						</li>
						<li class="out" score="80" >
							80分
						</li>
						<li class="out" score="100" >
							100分
						</li>
						<div class="clear"></div>
					</ul>	
				</div>
			</div>
			<div>
				<input type="button" onclick="kmsAsk_Com_Submit('save');" value="提交问题" style="width:100%;height: 35px">
			</div>
		</div>
	</div>
<input type="hidden" name="fdKmsAskCategoryId" value="${param.fdCategoryId }">
<input type="hidden" name="method_GET" value="POST">
<input type="hidden" name="method" value="save">

</html:form>
</body>
</html>