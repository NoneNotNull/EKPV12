<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.km.imeeting.model.KmImeetingUse"%>
<%@page import="java.util.Date"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
	Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
	Com_IncludeFile("dialog.js", "style/"+Com_Parameter.Style+"/dialog/");
	Com_IncludeFile("dialog.js|jquery.js");
</script>
<style>
	.selected{color: #1b83d8;}
</style>
<script type="text/javascript">
	//初始化
	$(document).ready(function(){
		var fdPlaceId=document.getElementsByName("fdPlaceId")[0];
		var fdPlaceName=document.getElementsByName("fdPlaceName")[0];
		if(fdPlaceId.value==null||fdPlaceId.value==""){
			fdPlaceId.value="${param.fdPlace}";
			fdPlaceName.value="${param.fdPlaceName}";
		}
	}); 
	//搜索
	function findUses(dateType){
		dateType= dateType || "";
		var fdPlace = document.getElementsByName("fdPlaceId")[0].value ; 
		var fdPlaceName=document.getElementsByName("fdPlaceName")[0].value;
		if(dateType){
			document.getElementsByName("fdStartDate")[0].value="";
			document.getElementsByName("fdEndDate")[0].value="";
		}
		var fdStartDate = document.getElementsByName("fdStartDate")[0].value ; 
		var fdEndDate = document.getElementsByName("fdEndDate")[0].value ;
		var s_path = Com_GetUrlParameter(location.href, "s_path");
		Com_OpenWindow('<c:url value="/km/imeeting/km_imeeting_res/kmImeetingRes.do" />?method=listUse&dateType='+dateType+'&fdPlace='+fdPlace+'&fdPlaceName='+fdPlaceName+'&fdStartDate='+fdStartDate+'&fdEndDate='+fdEndDate+'&s_path='+s_path,'_self');
	}
	//选择会议室
	function selectHoldPlace(){
		var resId=$('[name="fdPlaceId"]').val();//地点ID
		var resName=$('[name="fdPlaceName"]').val();//地点Name
		var url="${KMSS_Parameter_ContextPath}km/imeeting/km_imeeting_res/kmImeetingRes_showAllResDialog.jsp?resId="+resId+"&resName="+resName;
		var width=800;var height=520;
		var left = (screen.width-width)/2;
		var top = (screen.height-height)/2;
		if(window.showModalDialog){
			var winStyle = "resizable:1;scroll:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;dialogleft:"+left+";dialogtop:"+top;
			var selectedResource=window.showModalDialog(url, null, winStyle);
			if(selectedResource){
				$('[name="fdPlaceId"]').val(selectedResource.resId);
				$('[name="fdPlaceName"]').val(selectedResource.resName);
			}
		}else{
			var winStyle = "width="+width+",height="+height+",dependent=yes,alwaysRaised=1,resizable=1,scrollbars=1"+",left="+left+",top="+top;
			window.open(url,"",winStyle);
			window.dialogCallback=function(selectedResource){
				if(selectedResource){
					$('[name="fdPlaceId"]').val(selectedResource.resId);
					$('[name="fdPlaceName"]').val(selectedResource.resName);
				}
			};
		}
	}
</script>
<br/>
<html:form action="/km/imeeting/km_imeeting_res/kmImeetingRes.do">
<center>
	<div style="width: 100%">
		<table width="100%" class="tb_normal">
			<tr>
				<td class="td_normal_title">
					<bean:message  bundle="km-imeeting" key="kmImeetingResUse.fdPlace"/>
				</td>
				<td width="25%">
					<xform:dialog propertyId="fdPlaceId" propertyName="fdPlaceName" showStatus="edit" className="inputsgl" style="width:100%;">
						selectHoldPlace();
					</xform:dialog>
				</td>
				<td class="td_normal_title">
					<bean:message  bundle="km-imeeting" key="kmImeetingMain.fdDate"/>
				</td>
				<td>
					<xform:datetime property="fdStartDate" value="${param.fdStartDate}"dateTimeType="datetime" showStatus="edit"></xform:datetime>
					<span style="position: relative;top:-7px;">~</span>
					<xform:datetime property="fdEndDate" value="${param.fdEndDate}" dateTimeType="datetime" showStatus="edit"></xform:datetime>
				</td>
				<td>
					<input type="button" id="ok_id" class="lui_form_button"
						value="<bean:message  bundle="km-imeeting" key="kmImeetingUse.btn.search"/>" onclick="findUses();"/>
				</td>
			</tr>
		</table>
		<div style="padding: 8px;border: 1px solid #e8e8e8;border-top:0px; ">
			<center>
				<a href="javascript:void(0);" onclick="findUses('thisweek')" <c:if test="${param.dateType=='thisweek' }">class="selected"</c:if>
					style="margin-right: 10px;text-decoration: underline;">
					<bean:message bundle="km-imeeting" key="kmImeetingUse.btn.thisweek"/>
				</a>
				<a href="javascript:void(0);" onclick="findUses('nextweek')" <c:if test="${param.dateType=='nextweek' }">class="selected"</c:if>
					style="margin-right: 10px;text-decoration: underline;">
					<bean:message bundle="km-imeeting" key="kmImeetingUse.btn.nextweek"/>
				</a>
				<a href="javascript:void(0);" onclick="findUses('thismonth')" <c:if test="${param.dateType=='thismonth' }">class="selected"</c:if>
					style="margin-right: 10px;text-decoration: underline;">
					<bean:message bundle="km-imeeting" key="kmImeetingUse.btn.thismonth"/>
				</a>
			</center>	
		</div>
	</div>
</center>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="fdPlace">
					<bean:message bundle="km-imeeting" key="kmImeetingResUse.fdPlace"/>
				</sunbor:column>
				<sunbor:column property="fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingResUse.fdName"/>
				</sunbor:column>
				<sunbor:column property="fdHoldDate">
					<bean:message bundle="km-imeeting" key="kmImeetingResUse.fdHoldDate"/>
				</sunbor:column>
				<sunbor:column property="fdFinishDate">
					<bean:message bundle="km-imeeting" key="kmImeetingResUse.fdFinishDate"/>
				</sunbor:column>
				<sunbor:column property="personName">
					<bean:message bundle="km-imeeting" key="kmImeetingResUse.personName"/>
				</sunbor:column>
				<sunbor:column property="docStatus">
					<bean:message bundle="km-imeeting" key="kmImeetingResUse.docStatus"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImeetingResUse" varStatus="vstatus">
			<c:if test="${kmImeetingResUse.isMeeting==true }">
				<tr kmss_href="<c:url value="/km/imeeting/km_imeeting_main/kmImeetingMain.do" />?method=view&fdId=${kmImeetingResUse.fdId}">
			</c:if>
			<c:if test="${kmImeetingResUse.isMeeting==false }">
				<tr>
			</c:if>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmImeetingResUse.fdPlace}" />
				</td>
				<td>
					<c:if test="${ kmImeetingResUse.isMeeting==true}">
						<c:out value="${kmImeetingResUse.fdName}" />
					</c:if>
					<c:if test="${ kmImeetingResUse.isMeeting==false}">
						(<bean:message bundle="km-imeeting" key="kmImeetingBook.book" />)<c:out value="${kmImeetingResUse.fdName}" />
					</c:if>
				</td>
				<td>
					<kmss:showDate value="${kmImeetingResUse.fdHoldDate}" />
				</td>
				<td>
					<kmss:showDate value="${kmImeetingResUse.fdFinishDate}" />
				</td>
				<td>
					<c:out value="${kmImeetingResUse.personName}" />
				</td>
				<td>
					<%
						Date now=new Date();
						Boolean isBegin=false,isEnd=false;
						KmImeetingUse kmImeetingResUse=(KmImeetingUse)pageContext.findAttribute("kmImeetingResUse");
						if (kmImeetingResUse.getFdHoldDate().getTime() < now.getTime()) {
							isBegin = true;
						}
						// 会议已结束
						if (kmImeetingResUse.getFdFinishDate().getTime() < now.getTime()) {
							isEnd = true;
						}
						request.setAttribute("isBegin", isBegin);
						request.setAttribute("isEnd", isEnd);
					%>
					<c:if test="${kmImeetingResUse.docStatus!='30' && kmImeetingResUse.docStatus!='41' }">
						<sunbor:enumsShow value="${kmImeetingResUse.docStatus}" enumsType="common_status" />
					</c:if>
					<%--未召开--%>
					<c:if test="${kmImeetingResUse.docStatus=='30' && isBegin==false }">
						<bean:message bundle="km-imeeting" key="kmImeeting.status.publish.unHold"/>
					</c:if>
					<%--正在召开--%>
					<c:if test="${kmImeetingResUse.docStatus=='30' && isBegin==true && isEnd==false }">
						进行中
					</c:if>
					<%--已召开--%>
					<c:if test="${kmImeetingResUse.docStatus=='30' && isEnd==true }">
						<bean:message bundle="km-imeeting" key="kmImeeting.status.publish.hold"/>
					</c:if>
					<%--已取消--%>
					<c:if test="${kmImeetingResUse.docStatus=='41' }">
						已取消
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>