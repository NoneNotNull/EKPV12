<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<!doctype html>
<html>
<head>
<title>提问</title>
<meta http-equiv="X-UA-Compatible" content="IE=9" />
<meta http-equiv="Content-Type" content="text/html;"/>
<meta http-equiv="Pragma" content="No-Cache"/>
<%
	String kkIp =  ResourceUtil.getKmssConfigString("third.im.kk.serverIp");
	String kkPort = ResourceUtil.getKmssConfigString("kmss.ims.kk.awareport");
	request.setAttribute("kkIp",kkIp);
	request.setAttribute("kkPort",kkPort);
%>
<%@ include file="/kms/common/resource/jsp/tags.jsp" %>
<%@ include file="/kms/common/resource/jsp/include_kms.jsp"%>
<%@ include file="/kms/common/resource/jsp/include_ekp.jsp"%>
<%@ include file="/kms/ask/kms_ask_kk/kmsAskKk_edit_js.jsp" %>

</head>
<body>
<html:form action="/kms/ask/kms_ask_kk/kmsKk2Ask.do" onsubmit="return validateKmsAskTopicForm(this);">
<html:hidden property="fdId"/>
<div id="wrapper" style="padding: 10px;">
<div id="main3" style="margin-top: 5px !important;">
		<div class="box c" style="width:100%">
			<div class="location">
				<a href="javascript:void(0)" class="home" title="我要提问">我要提问</a>
			</div>
			
			<div class="box7 l m_t10" style="width: 95%">
				<div class="title5 c"><h2 class="h2_6">我要提问</h2>
			 	<span class="p_b tar m_t5">还可以输入<a style="font-family: Constantia, Georgia;font-size: 24px;">50</a>字</span></div>	
				<div class="m_t10">
					<html:textarea property="docSubject" style="width:100%;height:60" rows = "3" ></html:textarea>
				</div>
				<html:hidden property="docCreateTime"/>
				<html:hidden property="fdPostTime"/>
				<html:hidden property="fdScore" value="0"/>
				<html:hidden property="fdStatus" value="0"/>
				<html:hidden property="docStatus" value="30"/>
				<html:hidden property="fdPosterName"/>
				<html:hidden property="fdGroupId"/>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_f">
					<thead>
					</thead>
					<tbody>
						<tr>
							<th valign="top">当前分类：</th>
							<td>
								<html:hidden property="fdKmsAskCategoryId"/>
						        <span id="fdKmsAskCategoryName"></span>
						        <a href="#" id="selectAreaNames" class="a_b">设置分类</a>	 
							</td>
							<td>
								<div class="btn_o r m_t10" id="attFocus"><a title="提交问题" href="#" onclick="return kmsAsk_Com_Submit('save');"><span>提交问题</span></a></div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="clear"></div>
			
			<div class="box6 m_t10" style="width: 95%;margin: 10px 0 ;padding: 15px">
				<div style="width:100%" id="otherPostsListDiv">
				</div>
			</div>
		</div>
	</div><!-- main end -->
</div>
<html:hidden property="method_GET" value="save"/>
</html:form>
<html:javascript formName="kmsAskTopicForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/kms/common/resource/jsp/include_kms_down.jsp" %>