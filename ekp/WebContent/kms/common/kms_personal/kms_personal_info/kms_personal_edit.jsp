<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>	
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %>
<%@ include file="../kms_personal_common_js.jsp" %>
<%@ include file="../kms_personal_common_tmpl.jsp" %>
<%
	if(request.getAttribute("isCurUser")!=null){
		Boolean isCurUser =Boolean.valueOf(request.getAttribute("isCurUser").toString()) ; 
		pageContext.setAttribute("userDirect", isCurUser ? "我" : "TA");
	}
%>
<c:set var="attForms" value="${kmsPersonInfoForm.attachmentForms['spic'] }" />
<c:set var="headPicURL" value="${kmsResourcePath }/theme/default/img/pic_head.jpg" />
<c:forEach var="sysAttMain" items="${attForms.attachments }" varStatus="vsStatus">
	<c:if test="${vsStatus.first }">
		<c:set var="fdAttId" value="${sysAttMain.fdId }" />
		<c:set var="headPicURL" value="${pageContext.request.contextPath }/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}" />
	</c:if>
</c:forEach>
<%@ include file="kms_personal_edit_js.jsp" %>
<div id="main2">
<div class="content5 box c">
<div class="leftbar2">
<%-- 加载个人基本信息 --%>
<div class="kmsPersonInfo">
	<kms:portlet title="个人基本信息" id="kmsPersonInfo" dataType="Bean" dataBean="kmsPersonalIntegralInfoPortlet" beanParm="{fdPersonId:\"${param.fdPersonId}\"}" template="portlet_common_per_tmpl"></kms:portlet>
</div>
<div class="submenu_box">
<ul class="subnav2">
	<c:if test="${isCurUser}">
		<li><a href="javascript:myPage('method=myKmInfo');" title="我的KM">我的KM</a></li>
	</c:if>
	<li class="on"><a href="javascript:myPage('method=personalInfo');" title="基本信息">基本信息</a></li>
	<li><a href="javascript:myPage('method=followSetting');" title="我的订阅">我的订阅</a></li>
	<c:forEach var="kmsPersonal" items="${kmsPersonalList}">
		<li><a href="javascript:myKmDetails('km_path=${kmsPersonal.modulePath }');" title="">${isCurUser==true ? '我的' : 'TA的' }${kmsPersonal.navMessage }</a></li>
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
<form action="<c:url value='/kms/common/kms_person_info/kmsPersonInfo.do' />" method="post" id="kmsPersonInfoForm">
<div class="cont2">
				<h3 class="h3_2"><span>基本信息</span></h3>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" class="t_e3 m_t10 c">
				
					<tr>
						<td>
							<table>
								<tr>
									<th>姓名：</th>
									<td><c:out value="${kmsPersonInfoForm.fdPerson.fdName}" /></td>
									<th>英文名：</th>
									<td><input type="text" name="fdEnName" class="i_b" value="${kmsPersonInfoForm.fdEnName }"/></td>
								</tr>
								<tr>
									<th>性别： </th>
									<td><input type="radio" name="fdSex" value="1" ${kmsPersonInfoForm.fdSex == 1 ? 'checked': ''}/>男<input type="radio" class="m_l10" name="fdSex" value="0" ${kmsPersonInfoForm.fdSex == 0 ? 'checked': ''}/>女</td>
									<th>单位Email：</th>
									<td><input type="text" name="fdPerson.fdEmail" class="i_b"  value="${kmsPersonInfoForm.fdPerson.fdEmail}"/></td>
								</tr>
								<tr>
									<th>手机：</th>
									<td><input type="text" name="fdPerson.fdMobileNo" class="i_b" value="${kmsPersonInfoForm.fdPerson.fdMobileNo }"/></td>
									<th>单位电话：</th>
									<td><input type="text" name="fdPerson.fdWorkPhone" class="i_b"  value="${kmsPersonInfoForm.fdPerson.fdWorkPhone }"/></td>
								</tr>
								<tr>
									<th>隶属部门：</th>
									<td colspan="3"><c:out value="${kmsPersonInfoForm.fdPerson.fdParentName }" /><!-- <a href="javascript:void" class="a_b m_l10">（部门架构）</a> --></td>
								</tr>
								<tr>
									<th>所属岗位：</th>
									<td colspan="3"><c:out value="${kmsPersonInfoForm.fdPerson.fdPostNames }" /></td>
								</tr>
								<tr>
									<th>自我介绍： </th>
									<td colspan="3"><textarea name="fdBackground" class="textarea_b"><c:out value="${kmsPersonInfoForm.fdBackground }" /></textarea></td>
								</tr>
								<tr>
									<th></th>
									<td colspan="3"><div class="btn_i"><a href="javascript:void(0)" title="保存" onclick="submitForm();"><span><strong>保存</strong></span></a></div></td>
								</tr>
							</table>
						</td>
						<td>
							<div>
								<a title="" class="img_f" href="#"><img id="headPic" height="196" width="164" src="${headPicURL }" onload="javascript:drawImage(this,this.parentNode)"></a>
								(建议头像大小为：196*164)
								<input id="file_upload" name="file_upload" type="file" />
							</div>
						</td>
					</tr>
					
				</table>
				<input type="hidden" name="fdId" value="${kmsPersonInfoForm.fdId }" />
				<input type="hidden" name="fdPerson.fdId" value="${kmsPersonInfoForm.fdPerson.fdId }" />
				<input type="hidden" name="method" value="ajaxUpdate"/>
</div>
</form>
</div><!-- end cont2 -->
</div>

<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 