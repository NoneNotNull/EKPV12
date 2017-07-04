<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>	
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@ include file="/kms/common/kms_personal/kms_personal_common_js.jsp" %>
<%@ include file="/kms/common/kms_personal/kms_personal_common_tmpl.jsp" %>
<%
	if(request.getAttribute("isCurUser")!=null){
		Boolean isCurUser =Boolean.valueOf(request.getAttribute("isCurUser").toString()) ; 
		pageContext.setAttribute("userDirect", isCurUser ? "我" : "TA");
	}
%>
<c:set var="attForms" value="${kmsExpertInfoForm.attachmentForms['spic'] }" />
<c:set var="headPicURL" value="${kmsResourcePath }/theme/default/img/pic_head.jpg" />
<c:forEach var="sysAttMain" items="${attForms.attachments }" varStatus="vsStatus">
	<c:if test="${vsStatus.first }">
		<c:set var="fdAttId" value="${sysAttMain.fdId }" />
		<c:set var="headPicURL" value="${pageContext.request.contextPath }/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}" />
	</c:if>
</c:forEach>
<%@ include file="kmsExpertInfo_edit_js.jsp" %>
<div id="main2">
<div class="content5 box c">
<div class="leftbar2">
<%-- 加载个人基本信息 --%>
<div class="kmsPersonInfo">
	<kms:portlet title="个人基本信息" id="kmsPersonInfo" dataType="Bean" dataBean="kmsPersonalIntegralInfoPortlet" beanParm="{fdPersonId:\"${param.fdPersonId}\",expert:\"true\"}" template="portlet_common_per_tmpl"></kms:portlet>
</div>
<div class="submenu_box">
<ul class="subnav2">
	<c:if test="${isCurUser}">
		<li><a href="javascript:myPage('method=myKmInfo');" title="我的KM">我的KM</a></li>
	</c:if>
	<li class="on"><a href="javascript:myPage('method=personalInfo');" title="基本信息">基本信息</a></li>
	<c:forEach var="kmsPersonal" items="${kmsPersonalList}">
		<li><a href="javascript:myKmDetails('km_path=${kmsPersonal.modulePath }');" title="">${isCurUser eq true ? '我的' : 'TA的' }${kmsPersonal.navMessage }</a></li>
	</c:forEach>
	<c:if test="${isCurUser}">
	<li><a href="javascript:myKmDetails('km_path=/km/bookmark');" class="sc" title="我的收藏">我的收藏<span class="sc_icon" onclick="setBookmarkCategory();"></span></a>
		<c:if test="${fn:length(bookmarkCategoryList) > 0 }">
		<ul class="subnav3">
			<c:forEach var="bookmarkCategory" items="${bookmarkCategoryList }">
			<li><a href="javascript:myKmDetails('km_path=/km/bookmark', '${bookmarkCategory.fdId }');" title="${bookmarkCategory.fdName }">${bookmarkCategory.fdName }</a></li>
			</c:forEach>
		</ul>
		</c:if>
	</li>
	</c:if>
</ul>
</div>
<!-- end submenu_box -->
</div>
<!-- end leftbar2 -->
<form action="<c:url value='/kms/expert/kms_expert_info/kmsExpertInfo.do' />" method="post" id="kmsExpertInfoForm" >
<div class="cont2">
<h3 class="h3_2"><span>专家信息</span></h3>
<table width="100%" border="0" cellspacing="1" cellpadding="0"
	class="t_e3 m_t10 c" >
		<tr>
			<th width="10%"><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.name" /></th>
			<td width="30%">${kmsExpertInfoForm.fdName}</td>
			<th width="10%"><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.sex" /></th>
			<td width="30%">
				<!--<c:if test="${kmsExpertInfoForm.fdSex!=null&&kmsExpertInfoForm.fdSex!='' }">
		        	<sunbor:enumsShow value="${kmsExpertInfoForm.fdSex }" enumsType="kmsExpert_personInfo_sex" />
		        </c:if>-->
		        <input type="radio" name="fdSex" value="1" ${kmsExpertInfoForm.fdSex == 1 ? 'checked': ''}/><sunbor:enumsShow value="1" enumsType="kmsExpert_personInfo_sex" />
		        <input type="radio" class="m_l10" name="fdSex" value="0" ${kmsExpertInfoForm.fdSex == 0 ? 'checked': ''}/><sunbor:enumsShow value="0" enumsType="kmsExpert_personInfo_sex" />
			</td>
			<td rowspan="5">
				<a title="" class="img_f" href="#"><img id="headPic" height="196" width="164" src="${headPicURL }" onload="javascript:drawImage(this,this.parentNode)"></a>
					(建议头像大小为：196*164)
				<input id="file_upload" name="file_upload" type="file" />
			</td>
		</tr>
		<tr>
			<th width="10%"><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.post" /></th>
			<td width="30%"><% 
			  		List postList = (List)request.getAttribute("posts");
				    if(postList.size()!=0){
			  	%>     	 	
				<c:forEach items="${posts}" var="post"  varStatus="status">
		        	<c:out value="${post}" /><br>
		        </c:forEach>
		        <%
				    }
				%>
			</td>
			<th width="10%"><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.department" /></th>
			<td width="30%">${kmsExpertInfoForm.fdDeptName}</td>
		</tr>
		<tr>
			<th><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdMobile" /></th>
			<td>${kmsExpertInfoForm.fdMobileNo }</td>
			<th><bean:message bundle="kms-expert" key="kmsExpert.comtele" /></th>
			<td>${kmsExpertInfoForm.fdWorkPhone}</td>
		</tr>
		<tr>
			<th><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdEmail" /></th>
			<td>${kmsExpertInfoForm.fdEmail }</td>
			<th><bean:message bundle="kms-expert" key="kmsExpert.rtx" /></th>
			<td>${kmsExpertInfoForm.fdRtxNo }</td>
		</tr>
		
		<tr>
			<th><bean:message bundle="kms-expert" key="kmsExpert.qq" /></th>
			<td><input type="text" name="fdQqNumber" class="i_b" value="${kmsExpertInfoForm.fdQqNumber }"/></td>
			<th><bean:message bundle="kms-expert" key="kmsExpert.msn" /></th>
			<td><input type="text" name="fdMsnNumber" class="i_b" value="${kmsExpertInfoForm.fdMsnNumber }"/></td>
		</tr>
		<tr height="40px">
			<th><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdOrder" />：</th>
			<td><input type="text" name="fdOrder" class="i_b" value="${kmsExpertInfoForm.fdOrder }"/></td>
			<th><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdAreaName" />：</th>
			<td>
				<input type="hidden" name="kmsExpertTypeId" value="${kmsExpertInfoForm.kmsExpertTypeId }"/>
				<input type="text" name="kmsExpertTypeName" value="${kmsExpertInfoForm.kmsExpertTypeName }" readonly="readonly" class="i_b"/>
				<span class="txtstrong">*</span> <a href="#" id="selectAreaNames" onclick="openExpertWindow();"><bean:message key="dialog.selectOther" /></a>
		    </td>
		</tr>
		
		<c:forEach items="${kmsExpertAreas}" var="kmsExpertArea" varStatus="vstatus">
			<c:import url="/kms/expert/kms_expert_area/kmsExpertArea_edit.jsp"
				charEncoding="UTF-8">
				<c:param name="areaMessage" value="${kmsExpertArea.areaMessageKey}" />
				<c:param name="treeBean" value="${kmsExpertArea.treeBean}" />
				<c:param name="index" value="${vstatus.index}" />
				<c:param name="fdModelName" value="${ kmsExpertArea.uuid}" />
			</c:import>
		</c:forEach>
		<tr>
			<th><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdBackground" />：</th>
			<td colspan="4"><TEXTAREA name="fdBackground" class="textarea_b">${kmsExpertInfoForm.fdBackground }</TEXTAREA></td>
		</tr>
		
		<tr>
			<th></th>
			<td colspan="4"><div class="btn_i"><a href="javascript:void(0)" title="保存" onclick="submitForm();"><span><strong>保存</strong></span></a></div></td>
		</tr>
		<input type="hidden" name="fdId" value="${kmsExpertInfoForm.fdId }" />
		<!--  <input type="hidden" name="fdPersonType" value="true" />-->
		<input type="hidden" name="fdPersonId" value="${param.fdPersonId}" />
		<input type="hidden" name="method" value="ajaxUpdate"/>
</table>
</div>
</form>
<!-- end cont2 --></div>
</div>
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 