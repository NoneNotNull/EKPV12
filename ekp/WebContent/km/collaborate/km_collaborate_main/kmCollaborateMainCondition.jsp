<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<style>
body{ 
	background:white;
}
td{
	height:35px;
}
.tdBackground {
	background:#F0F0F0;
}
.tdDivhead1 {
float:left
}
.tdDivhead2 {
	float:right;width:74px;height:19px
}
.tb_normal{
	border-collapse:collapse;
	border: 1px #C0C0C0 solid;
	background-color: #FFFFFF;
}
.td_normal, .tb_normal td{
	border-collapse:collapse;
	border: 1px #C0C0C0 solid;
	padding:3px;
	font-size: 13px;
	font-family: "宋体";
}
.tr_normal_title{
	background-color: #F0F0F0;
	border-collapse:collapse;
	border: 1px #C0C0C0 solid;
	padding:3px;
	text-align:center;
	word-break:keep-all;
}
</style>
<script type="text/javascript">
   Com_IncludeFile("jquery.js|dialog.js|treeview.js|list.js");
</script>
<link type="text/css" rel="stylesheet" href="${KMSS_Parameter_ContextPath}km/collaborate/js/jquery.qtip.css" />
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}km/collaborate/js/jquery.qtip.js" charset="UTF-8"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("div[name='Ccontent']").each(function(){
		var value=$(this).html();
		value = value.replace(/<\/?[^>]*>/g,''); //去除HTML tag
		value = value.replace(/[ | ]*\n/g,'\n'); //去除行尾空白
	
		//value=value.replace(/<\/?.+?>/g,"&nbsp;");	
		$(this).html(value);
		
	});
	$("img[name='operate']").each(function(){
		$(this).qtip({
			content: {
			 attr: 'data-value'	
		   },	
		    position: {
				my: 'right center',
				at: 'top center',
			    effect: false
			}
			});
		});
	dyniFrameSize();
});

function dyniFrameSize() {
	try {
		// 调整高度
		var arguObj = document.getElementById("content");
		
		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (arguObj.offsetHeight + 180) + "px";
		}
	} catch(e) {
  }
}

	function changeSort(typek){
		var id = '${kmCollaborateMain.fdId}';
		window.open('<c:url value="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=condition&fdId='+ id +'&type='+ typek +'" />','_self');
	}
	function submitValue() {
		// 判断参与人员是否改变，若没有改变，则不触发事件，若改变了则触发事件并且判断是否人员已经重复， 重复则去掉
		// 新添加的参与者Ids和Names
		var fdPersonIds = document.getElementById("fdPersonId").value;
		var fdPersonNames = document.getElementById("fdPersonName").value;
		var personIds = new Array();
		var PersonNames = new Array();
		personIds=fdPersonIds.split(";");
		PersonNames=fdPersonNames.split(";");
		
		// 实际已经存在的参与者arrayObj为实际参与者数组
		var fdIds = table.getElementsByTagName("span"); 
		var arrayObj = new Array();
		for(var j=0; j < fdIds.length; j++){
			arrayObj.push(fdIds[j].innerText||fdIds[j].textContent);
		}
		// 若存在，则删除
		for ( var i=0 ; i < personIds.length ; ++i ) {
			if(IsInArray(arrayObj,personIds[i])){
				delete personIds[i];
				delete PersonNames[i];
			}
		}
		// 判断是否存在
		function IsInArray(arr,val){    
			var testStr=','+arr.join(",")+",";    
			return testStr.indexOf(","+val+",")!=-1;
		}
		if(personIds.join(";")!=';'){
			document.getElementById("fdPersonId").value = personIds.join(";");
			Com_Submit(document.kmCollaboratePartnerInfoForm, 'saveCondition');
		}
	}
	function isDelete(mainId,personId){
		if(confirm("<bean:message key='kmCollaborate.jsp.confirm' bundle='km-collaborate'/>")){
			$.getJSON('<c:url value="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=delete"/>',{'fdParentId':mainId,'fdId':personId},function(data){
					location.reload();
			
			});
		}
		
	}
	function fdTime(fdTime){
		var value = fdTime.substring(0, fdTime.length-5);
		return value;
	}
</script>
<body>
<html:form action="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do">
	<input type="hidden"  name="fdCommunicationMainId" value="${kmCollaborateMain.fdId }"/>
	<input type="hidden" id="fdPersonId" name="fdPersonId" />
	<input type="hidden" id="fdPersonName" name="fdPersonName" />
	<div id="content">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table width="100%" id="table" class="tb_normal" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="10%" class="tdBackground"><bean:message  key="kmCollaborate.jsp.promoter"  bundle="km-collaborate"/></td>
	    <td colspan="7">${kmCollaborateMain.docCreator.fdName}</td>
	  </tr>
	  <tr>
	    <td class="tdBackground"><bean:message key="kmCollaboratePartnerInfo.fdPerson" bundle="km-collaborate" /></td>
	    <td colspan="7">
	    	<div class="tdDivhead1">
	    		<strong><bean:message key="kmCollaborate.jsp.orderStyle" bundle="km-collaborate"/>:</strong>&nbsp;
	    		<a href="javaScript:void(0)" id="name" onclick="changeSort(id);"><bean:message key="kmCollaborate.jsp.fullName" bundle="km-collaborate"/></a>&nbsp;|&nbsp;
	    		<a href="javaScript:void(0)" id="depart" onclick="changeSort(id);"><bean:message key="kmCollaborate.jsp.department" bundle="km-collaborate"/></a>&nbsp;|&nbsp;
	    		<a href="javaScript:void(0)" id="condition" onclick="changeSort(id);"><bean:message key="kmCollaborate.jsp.status" bundle="km-collaborate"/></a>&nbsp;</div>
	   	 	<div class="tdDivhead2" style="border:0px solid #ccc ; cursor:pointer;">
		     	<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=saveCondition&fdId=${kmCollaborateMain.fdId}">
		            <c:if test="${kmCollaborateMain.docStatus== '30' }">
		    	    <span  id="zjry" style="background:url(../img/zjry_d.png); display:block; height:22px" onmouseout="document.all.zjry.style.background='url(../img/zjry_d.png)'" onmouseover="document.all.zjry.style.background='url(../img/zjry_focus.png)';"
		    	      onclick="hello()">
		    	        <span style="display:block; height:16px; padding:5px 0 5px 16px;"> 
		    	           <bean:message bundle="km-collaborate" key="kmCollaborate.jsp.zjry" />
		    	         </span>
		    	    </span>
		    	    </c:if>
		    	</kmss:auth> 
	    	</div>
	    </td>
	  </tr>
	  <tr>
	            <td class="tdBackground" rowspan="${fn:length(queryPage.list)+1}"></td>
				<td align="center" width="60pt">
					<strong><bean:message key="kmCollaborate.jsp.serial" bundle="km-collaborate"/></strong>
				</td>
				<td align="center" width="150px">
					<strong><bean:message key="kmCollaborate.jsp.fullName" bundle="km-collaborate"/></strong>
				</td>
				<td align="center" width="250px">
					<strong><bean:message key="kmCollaborate.jsp.department" bundle="km-collaborate"/></strong>
				</td>
				<td align="center" width="100px">
					<strong><bean:message key="kmCollaborate.jsp.status" bundle="km-collaborate"/></strong>
				</td>
				<td align="center" width="450px">
					<strong><bean:message key="kmCollaborate.jsp.latestReply" bundle="km-collaborate"/></strong>
				</td>
				<td align="center" width="200px">
					<strong><bean:message key="kmCollaborate.jsp.latestReplyTime" bundle="km-collaborate"/></strong>
				</td>
                <td></td>
		
		</tr>
	  <c:forEach items="${queryPage.list}" var="kmCollaboratePartnerInfo" varStatus="vstatus">
		  <tr>
		    <td align="center" width="60pt">${vstatus.index+1}</td>
		    <td align="center" width="150px"><span  style="display:none" name="fdIds">${kmCollaboratePartnerInfo.fdPerson.fdId }</span>${kmCollaboratePartnerInfo.fdPerson.fdName }</td>
		    <td align="center" width="250px"><c:if test="${kmCollaboratePartnerInfo.fdPerson.fdParent!=null }">${kmCollaboratePartnerInfo.fdPerson.fdParent.fdName }</c:if></td>
		    <td align="center" width="100px">
		    	<c:if test="${kmCollaboratePartnerInfo.fdIsReply == true }"><img src="../img/ykf_mail2.png"  align="absmiddle"/>&nbsp;<bean:message key="kmCollaborate.jsp.replied" bundle="km-collaborate"/></c:if>
		    	<c:if test="${kmCollaboratePartnerInfo.fdIsReply == false }">
		    		<c:if test="${kmCollaboratePartnerInfo.fdIsRead == true }"><img src="../img/ykf_mail.png"  align="absmiddle"/>&nbsp;<bean:message key="kmCollaborate.jsp.readed" bundle="km-collaborate"/></c:if>
		    		<c:if test="${kmCollaboratePartnerInfo.fdIsRead == false }"><img src="../img/wkf_mail.png"  align="absmiddle"/>&nbsp;<bean:message key="kmCollaborate.jsp.unRead" bundle="km-collaborate"/></c:if>
		    	</c:if>
		    </td> 
		     <td width="450px" style="border-right:none;">
		    	<div name="Ccontent">${kmCollaboratePartnerInfo.fdLatestReply}</div>
		    </td>
		    <td width="200px" style="border-right:none;">
		    	<div><kmss:showDate value="${kmCollaboratePartnerInfo.fdLatestRTime}" type="datetime" /></div>
		    </td>
		    <td width="80px">
		    	<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=deletePartner&fdPartnerInfoId=${kmCollaboratePartnerInfo.fdId}&fdId=${kmCollaboratePartnerInfo.fdCommunicationMain.fdId }">
			    	<c:if test="${kmCollaboratePartnerInfo.fdIsRead == false &&kmCollaborateMain.docStatus=='30'}">
			    		<img src="../img/delete.png" onClick="isDelete('${kmCollaborateMain.fdId }','${kmCollaboratePartnerInfo.fdId }')">
			    	</c:if>
				</kmss:auth>
				<c:if test="${kmCollaboratePartnerInfo.fdOperator != null }">
				<img name="operate" src="../img/note.png" data-value='${kmCollaboratePartnerInfo.fdOperator.fdName}<bean:message bundle="km-collaborate" key="kmCollaborate.jsp.yu" /><kmss:showDate value="${kmCollaboratePartnerInfo.fdCreateTime}" type="datetime" /> <bean:message key="kmCollaborate.jsp.addPerson" bundle="km-collaborate"/>：${kmCollaboratePartnerInfo.fdPerson.fdName }'>				
				</c:if>
		    </td>
		  </tr>
	</c:forEach>
	  <tr>
	    <td class="tdBackground"><bean:message key="kmCollaborate.jsp.followers" bundle="km-collaborate"/></td>
	    <td colspan="7">
	      <c:forEach items="${queryPage.list}" var="kmCollaboratePartnerInfo" varStatus="vstatus">
		     <c:if test="${kmCollaboratePartnerInfo.fdIsFollow == true }">
				${kmCollaboratePartnerInfo.fdPerson.fdName};
	    	 </c:if>
	      </c:forEach>
	    </td>
	  </tr>
	  
	</table>
   <%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
	</div>
	<script>
		function hello() {
			document.all.zjry.src="../img/zjry2.png";
			Dialog_Address(true,'fdPersonId','fdPersonName',';',ORG_TYPE_PERSON,submitValue);
		}
	</script>
</html:form>
</body>