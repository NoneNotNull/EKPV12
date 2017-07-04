<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.KmssMessageWriter,com.landray.kmss.util.KmssReturnPage" %>
<%   
	KmssMessageWriter msgWriter = null;
	if(request.getAttribute("KMSS_RETURNPAGE")!=null){
		msgWriter = new KmssMessageWriter(request, (KmssReturnPage)request.getAttribute("KMSS_RETURNPAGE"));
	}else{
		msgWriter = new KmssMessageWriter(request, null);
	}
	if(request.getHeader("accept")!=null){
		if(request.getHeader("accept").indexOf("application/json") >=0){
			out.write(msgWriter.DrawJsonMessage(false).toString());
			return;
		}
	}
	response.setHeader("lui-status","true");
%>
<%@ include file="/third/pda/htmlhead.jsp"%>
	<script type="text/javascript">
		var time = 0;
		function redirectTo(){
			var docLink = document.getElementsByName("inp_return")[0];
			if(docLink.value == ''){
				if('${sessionScope["S_CurModule"]}'!=''){
					gotoList();
				}else{
					if("${param['isAppflag']=='1'}"=='true'){
						history.go(-1);
					}else
						gotoUrl('<c:url value="/third/pda/index.jsp"/>');
				}
			}else{
				if(docLink.value.indexOf("/")==0)
					location.replace(Com_SetUrlParameter(Com_Parameter.ContextPath + docLink.value.substring(1),'_reload','1'));
				else
					location.replace(Com_SetUrlParameter(docLink.value,'_reload','1'));
			}
		}
		function timeInteval(){
			var _timeArea = document.getElementById("_timeArea");
			if(time==3){
				redirectTo();
				return;
			}
			_timeArea.innerHTML = 3 - time;
			time ++;
			setTimeout("timeInteval()",1000);
		}
	</script>
</head>
<body>
	<c:if test="${sessionScope['S_CurModule']!=null}">
		<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
			<c:param name="fdNeedReturn" value="true"/>
			<c:param name="fdModuleName" value="${sessionScope['S_CurModuleName']}"/>
			<c:param name="fdModuleId" value="${sessionScope['S_CurModule']}"/>
		</c:import>
	</c:if>
	<center>
		<div style="margin-top: 100px;width:150px;padding-left:65px;text-align:left;height:64px;background: url('<c:url value="/third/pda/resource/images/ico_success.png"/>') left no-repeat;">
			<br/>
			&nbsp;&nbsp;<b style="font-size: 15px;font-weight: bolder"><bean:message key="return.optSuccess" /></b>
			<br/>
			<input name="inp_return" type="hidden" value="${sessionScope['S_DocLink']}"/>
			<c:if test="${param['isAppflag']!='1' or (sessionScope['S_DocLink']!=null and sessionScope['S_DocLink']!='')}">
				&nbsp;&nbsp;<font style="color:purple;" id="_timeArea"></font><%=ResourceUtil.getString(request.getSession(), "third-pda","phone.return.msg") %>
				<a name='href_return' style="text-decoration: underline;cursor: pointer;" onclick="redirectTo();"><%=ResourceUtil.getString(request.getSession(), "third-pda","phone.view.back")%></a>
				<script type="text/javascript">Com_AddEventListener(window,'load',function(){timeInteval();});</script>
			</c:if>
		</div>
	</center>
</body>
</html>