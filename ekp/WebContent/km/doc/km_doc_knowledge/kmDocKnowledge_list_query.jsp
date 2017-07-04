<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("dialog.js|docutil.js|optbar.js|validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js");
Com_IncludeFile("jquery.js");
Com_IncludeFile("calendar.js");
</script>
<script type="text/javascript" charset="UTF-8">
//回车执行搜索
if (document.addEventListener) {//如果是Firefox
    document.addEventListener("keypress", otherHandler, true);
} else {
    document.attachEvent("onkeypress", ieHandler);
}
function otherHandler(evt) {
   if (evt.keyCode == 13) {
	   KmDoc_Search();
    }
}
function ieHandler(evt) {
  if (evt.keyCode == 13) {
	  KmDoc_Search();
    }
}

//搜索方法
function KmDoc_Search(){
	var url = Com_Parameter.ContextPath+"km/doc/km_doc_knowledge/kmDocKnowledge.do?method=";

	url += Com_GetUrlParameter(location.href, "method");
	
	if("" != Com_GetUrlParameter(location.href, "pink"))
		url = Com_SetUrlParameter(url, "pink", Com_GetUrlParameter(location.href, "pink"));
	if("" != Com_GetUrlParameter(location.href, "categoryId"))
		url = Com_SetUrlParameter(url, "categoryId", Com_GetUrlParameter(location.href, "categoryId"));
	if("" != Com_GetUrlParameter(location.href, "departmentId"))
		url = Com_SetUrlParameter(url, "departmentId", Com_GetUrlParameter(location.href, "departmentId"));
	if("" != Com_GetUrlParameter(location.href, "isShowAll"))
		url = Com_SetUrlParameter(url, "isShowAll", Com_GetUrlParameter(location.href, "isShowAll"));
	if("" != Com_GetUrlParameter(location.href, "nodeType"))
		url = Com_SetUrlParameter(url, "nodeType", Com_GetUrlParameter(location.href, "nodeType"));
	if("" != Com_GetUrlParameter(location.href, "orderby"))
		url = Com_SetUrlParameter(url, "orderby", Com_GetUrlParameter(location.href, "orderby"));
	if("" != Com_GetUrlParameter(location.href, "ordertype"))
		url = Com_SetUrlParameter(url, "ordertype", Com_GetUrlParameter(location.href, "ordertype"));
	if("" != Com_GetUrlParameter(location.href, "myflow"))
		url = Com_SetUrlParameter(url, "myflow", Com_GetUrlParameter(location.href, "myflow"));
	if("" != Com_GetUrlParameter(location.href, "mydoc"))
		url = Com_SetUrlParameter(url, "mydoc", Com_GetUrlParameter(location.href, "mydoc"));
	if("" != Com_GetUrlParameter(location.href, "status"))
		url = Com_SetUrlParameter(url, "status", Com_GetUrlParameter(location.href, "status"));
	if("" != Com_GetUrlParameter(location.href, "s_path"))
		url = Com_SetUrlParameter(url, "s_path", Com_GetUrlParameter(location.href, "s_path"));
	if("" != Com_GetUrlParameter(location.href, "s_css"))
		url = Com_SetUrlParameter(url, "s_css", Com_GetUrlParameter(location.href, "s_css"));

	//文档标题
	var docSubject = document.getElementsByName("docSubject")[0].value;
	if("" != docSubject)
		url = Com_SetUrlParameter(url, "docSubject", docSubject);
	//录入人
	var docCreatorId = document.getElementsByName("docCreatorId")[0].value;
	if("" != docCreatorId)
		url = Com_SetUrlParameter(url, "docCreatorId", docCreatorId);
	var docCreatorName = document.getElementsByName("docCreatorName")[0].value;
	if("" != docCreatorName)
		url = Com_SetUrlParameter(url, "docCreatorName", docCreatorName);
	//分类（选择）
	var fdDocTemplateId = document.getElementsByName("fdDocTemplateId")[0].value;
	if("" != fdDocTemplateId)
		url = Com_SetUrlParameter(url, "fdDocTemplateId", fdDocTemplateId);
	var fdDocTemplateName = document.getElementsByName("fdDocTemplateName")[0].value;
	if("" != fdDocTemplateName)
		url = Com_SetUrlParameter(url, "fdDocTemplateName", fdDocTemplateName);
	//录入时间（区间）
	var docStartdate = document.getElementsByName("docStartdate")[0].value;
	if("" != docStartdate)
		url = Com_SetUrlParameter(url, "docStartdate", docStartdate);
	var docFinishdate = document.getElementsByName("docFinishdate")[0].value;
	if("" != docFinishdate)
		url = Com_SetUrlParameter(url, "docFinishdate", docFinishdate);
	//文档状态 （下拉框）
	var docStatus = document.getElementsByName("docStatus")[0].value;
	if('0' != docStatus)
		url = Com_SetUrlParameter(url, "docStatus", docStatus);
	//内容
	//var docContent = document.getElementsByName("docContent")[0].value;
	//if("" != docContent)
	//	url = Com_SetUrlParameter(url, "docContent", docContent);
	//文件作者
	//var docAuthorId = document.getElementsByName("docAuthorId")[0].value;
	//if("" != docAuthorId)
	//	url = Com_SetUrlParameter(url, "docAuthorId", docAuthorId);
	//var docAuthorName = document.getElementsByName("docAuthorName")[0].value;
	//if("" != docAuthorName)
	//	url = Com_SetUrlParameter(url, "docAuthorName", docAuthorName);
	
	window.location.href = url;
}

//开始时间不能大于终止时间
function doCheckDate(){
	var docStartdate = document.getElementsByName("docStartdate")[0].value;
	var docFinishdate = document.getElementsByName("docFinishdate")[0].value;
	if(docStartdate != '' && docFinishdate != ''){
		if(docStartdate > docFinishdate){
			alert('<bean:message bundle="km-review" key="kmReviewMain.startDateAfterendDate"/>');
		}
	}
}

//重置方法
function doReset(){
	var url = Com_Parameter.ContextPath+"km/doc/km_doc_knowledge/kmDocKnowledge.do?method=";

	url += Com_GetUrlParameter(location.href, "method");
	
	if("" != Com_GetUrlParameter(location.href, "pink"))
		url = Com_SetUrlParameter(url, "pink", Com_GetUrlParameter(location.href, "pink"));
	if("" != Com_GetUrlParameter(location.href, "categoryId"))
		url = Com_SetUrlParameter(url, "categoryId", Com_GetUrlParameter(location.href, "categoryId"));
	if("" != Com_GetUrlParameter(location.href, "departmentId"))
		url = Com_SetUrlParameter(url, "departmentId", Com_GetUrlParameter(location.href, "departmentId"));
	if("" != Com_GetUrlParameter(location.href, "isShowAll"))
		url = Com_SetUrlParameter(url, "isShowAll", Com_GetUrlParameter(location.href, "isShowAll"));
	if("" != Com_GetUrlParameter(location.href, "nodeType"))
		url = Com_SetUrlParameter(url, "nodeType", Com_GetUrlParameter(location.href, "nodeType"));
	if("" != Com_GetUrlParameter(location.href, "orderby"))
		url = Com_SetUrlParameter(url, "orderby", Com_GetUrlParameter(location.href, "orderby"));
	if("" != Com_GetUrlParameter(location.href, "ordertype"))
		url = Com_SetUrlParameter(url, "ordertype", Com_GetUrlParameter(location.href, "ordertype"));
	if("" != Com_GetUrlParameter(location.href, "myflow"))
		url = Com_SetUrlParameter(url, "myflow", Com_GetUrlParameter(location.href, "myflow"));
	if("" != Com_GetUrlParameter(location.href, "mydoc"))
		url = Com_SetUrlParameter(url, "mydoc", Com_GetUrlParameter(location.href, "mydoc"));
	if("" != Com_GetUrlParameter(location.href, "status"))
		url = Com_SetUrlParameter(url, "status", Com_GetUrlParameter(location.href, "status"));
	if("" != Com_GetUrlParameter(location.href, "s_path"))
		url = Com_SetUrlParameter(url, "s_path", Com_GetUrlParameter(location.href, "s_path"));
	if("" != Com_GetUrlParameter(location.href, "s_css"))
		url = Com_SetUrlParameter(url, "s_css", Com_GetUrlParameter(location.href, "s_css"));
		
	window.location.href = url;
}

</script>
<table id="condition" class="tb_normal" width="95%">
	<tr>
		<!-- 文档标题 -->
		<td class="td_normal_title" width="10%">
			<bean:message bundle="sys-doc" key="sysDocBaseInfo.docSubject" />
		</td><td width="23%" >
			<xform:text property="docSubject" showStatus="edit" style="width:80%"></xform:text>
		</td>
		<!-- 录入人 -->
		<td class="td_normal_title" width="10%" >
			<bean:message bundle="sys-doc" key="sysDocBaseInfo.docCreator" />
		</td><td width="23%" >
			<xform:dialog  propertyId="docCreatorId" propertyName="docCreatorName" style="width:80%"
				dialogJs="Dialog_Address(false, 'docCreatorId', 'docCreatorName', ';', ORG_TYPE_PERSON)"  showStatus="edit" />
		</td><td width="33%" colspan="2">
			<!-- 查询按钮 -->
			<input type="button" value="<bean:message bundle="km-doc" key="kmDoc.button.search"/>" onclick="KmDoc_Search()">
			<!-- 重置按钮 -->
			<input type="button" value="<bean:message bundle="km-doc" key="kmDoc.button.reset"/>"  onclick="doReset()">
		</td>
	</tr><tr>
		<!-- 分类（选择）  -->
		<td class="td_normal_title" width="10%" >
			<bean:message bundle="km-doc" key="kmDocKnowledge.fdTemplateName" />
		</td><td width="23%" >
			<html:hidden property="fdDocTemplateId" />
		    <html:text styleClass="inputsgl" property="fdDocTemplateName" readonly="true" style="width:80%"/>
		  <a href="#" onclick="Dialog_SimpleCategory('com.landray.kmss.km.doc.model.KmDocTemplate','fdDocTemplateId','fdDocTemplateName');"><bean:message key="button.select"/></a>
		</td>
		<!-- 录入时间（区间） -->
		<td class="td_normal_title" width="10%" >
			<bean:message bundle="km-doc" key="kmDocTemplate.docCreateTime" />
		</td><td width="23%" >
			<xform:datetime  property="docStartdate" dateTimeType="date" showStatus="edit" style="width:30%" onValueChange="doCheckDate"/>—
			<xform:datetime  property="docFinishdate" dateTimeType="date" showStatus="edit" style="width:30%" onValueChange="doCheckDate"/>
		</td>
		<!-- 文档状态 （下拉框） -->
		<td class="td_normal_title" width="10%" >
			<bean:message bundle="km-doc" key="kmDoc.kmDocKnowledge.docStatus" />
		</td><td width="23%" >
			<xform:select
				property="docStatus" showStatus="edit">
				<xform:enumsDataSource enumsType="common_status_search"/>
			</xform:select>
		</td>
	</tr>
	<%--  <tr>
		<!-- 内容 -->
		<td class="td_normal_title" width="10%" >
			<bean:message bundle="sys-doc" key="sysDocBaseInfo.docContent" />
		</td><td width="23%" >
			<xform:text property="docContent" showStatus="edit" style="width:80%"></xform:text>
		</td>
		<!-- 文件作者 -->
		<td class="td_normal_title" width="10%" >
			<bean:message bundle="sys-doc" key="sysDocBaseInfo.docAuthor" />
		</td><td width="23%" >
			<xform:dialog  propertyId="docAuthorId" propertyName="docAuthorName" style="width:80%"
				dialogJs="Dialog_Address(false, 'docAuthorId', 'docAuthorName', ';', ORG_TYPE_PERSON)" showStatus="edit" />
		</td>
	</tr> --%>
</table>
