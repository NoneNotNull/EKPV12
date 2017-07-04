<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script>
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("dialog.js|docutil.js|optbar.js|validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js");
Com_IncludeFile("jquery.js");
Com_IncludeFile("calendar.js");
</script>
<script type="text/javascript">
//回车执行搜索
if (document.addEventListener) {//如果是Firefox
    document.addEventListener("keypress", otherHandler, true);
} else {
    document.attachEvent("onkeypress", ieHandler);
}
function otherHandler(evt) {
   if (evt.keyCode == 13) {
  	 KmReview_Search();
    }
}
function ieHandler(evt) {
  if (evt.keyCode == 13) {
 	 KmReview_Search();
    }
}

//搜索方法
function KmReview_Search(){
	var url = Com_Parameter.ContextPath+"km/review/km_review_main/kmReviewMain.do?method=";

	url += Com_GetUrlParameter(location.href, "method");

	if("" != Com_GetUrlParameter(location.href, "type"))
		url = Com_SetUrlParameter(url, "type", Com_GetUrlParameter(location.href, "type"));
	if("" != Com_GetUrlParameter(location.href, "pageno"))
		url = Com_SetUrlParameter(url, "pageno", Com_GetUrlParameter(location.href, "pageno"));
	if("" != Com_GetUrlParameter(location.href, "rowsize"))
		url = Com_SetUrlParameter(url, "rowsize", Com_GetUrlParameter(location.href, "rowsize"));
	if("" != Com_GetUrlParameter(location.href, "orderby"))
		url = Com_SetUrlParameter(url, "orderby", Com_GetUrlParameter(location.href, "orderby"));
	if("" != Com_GetUrlParameter(location.href, "ordertype"))
		url = Com_SetUrlParameter(url, "ordertype", Com_GetUrlParameter(location.href, "ordertype"));
	if("" != Com_GetUrlParameter(location.href, "excepteIds"))
		url = Com_SetUrlParameter(url, "excepteIds", Com_GetUrlParameter(location.href, "excepteIds"));
	if("" != Com_GetUrlParameter(location.href, "isShowAll"))
		url = Com_SetUrlParameter(url, "isShowAll", Com_GetUrlParameter(location.href, "isShowAll"));
	if("" != Com_GetUrlParameter(location.href, "nodeType"))
		url = Com_SetUrlParameter(url, "nodeType", Com_GetUrlParameter(location.href, "nodeType"));
	if("" != Com_GetUrlParameter(location.href, "categoryId"))
		url = Com_SetUrlParameter(url, "categoryId", Com_GetUrlParameter(location.href, "categoryId"));
	if("" != Com_GetUrlParameter(location.href, "myflow"))
		url = Com_SetUrlParameter(url, "myflow", Com_GetUrlParameter(location.href, "myflow"));
	if("" != Com_GetUrlParameter(location.href, "status"))
		url = Com_SetUrlParameter(url, "status", Com_GetUrlParameter(location.href, "status"));
	if("" != Com_GetUrlParameter(location.href, "mydoc"))
		url = Com_SetUrlParameter(url, "mydoc", Com_GetUrlParameter(location.href, "mydoc"));
	if("" != Com_GetUrlParameter(location.href, "s_path"))
		url = Com_SetUrlParameter(url, "s_path", Com_GetUrlParameter(location.href, "s_path"));
	if("" != Com_GetUrlParameter(location.href, "s_css"))
		url = Com_SetUrlParameter(url, "s_css", Com_GetUrlParameter(location.href, "s_css"));
	if("" != Com_GetUrlParameter(location.href, "departmentId"))
		url = Com_SetUrlParameter(url, "departmentId", Com_GetUrlParameter(location.href, "departmentId"));

	//主题
	var docSubject = document.getElementsByName("docSubject")[0].value;
	if("" != docSubject)
		url = Com_SetUrlParameter(url, "docSubject", docSubject);
	//申请单编号
	var fdNumber = document.getElementsByName("fdNumber")[0].value;
	if("" != fdNumber)
		url = Com_SetUrlParameter(url, "fdNumber", fdNumber);
	//申请人
	var docCreatorId = document.getElementsByName("docCreatorId")[0].value;
	if("" != docCreatorId)
		url = Com_SetUrlParameter(url, "docCreatorId", docCreatorId);
	//创建时间
	var docStartdate = document.getElementsByName("docStartdate")[0].value;
	if("" != docStartdate)
		url = Com_SetUrlParameter(url, "docStartdate", docStartdate);
	var docFinishdate = document.getElementsByName("docFinishdate")[0].value;
	if("" != docFinishdate)
		url = Com_SetUrlParameter(url, "docFinishdate", docFinishdate);
	//模板名称
	var fdTemplateId = document.getElementsByName("fdTemplateId")[0].value;
	if("" != fdTemplateId)
		url = Com_SetUrlParameter(url, "fdTemplateId", fdTemplateId);

	window.location.href = url;
}

//重置方法
function doReset(){
	var url = Com_Parameter.ContextPath+"km/review/km_review_main/kmReviewMain.do?method=";

	url += Com_GetUrlParameter(location.href, "method");

	if("" != Com_GetUrlParameter(location.href, "type"))
		url = Com_SetUrlParameter(url, "type", Com_GetUrlParameter(location.href, "type"));
	if("" != Com_GetUrlParameter(location.href, "pageno"))
		url = Com_SetUrlParameter(url, "pageno", Com_GetUrlParameter(location.href, "pageno"));
	if("" != Com_GetUrlParameter(location.href, "rowsize"))
		url = Com_SetUrlParameter(url, "rowsize", Com_GetUrlParameter(location.href, "rowsize"));
	if("" != Com_GetUrlParameter(location.href, "orderby"))
		url = Com_SetUrlParameter(url, "orderby", Com_GetUrlParameter(location.href, "orderby"));
	if("" != Com_GetUrlParameter(location.href, "ordertype"))
		url = Com_SetUrlParameter(url, "ordertype", Com_GetUrlParameter(location.href, "ordertype"));
	if("" != Com_GetUrlParameter(location.href, "excepteIds"))
		url = Com_SetUrlParameter(url, "excepteIds", Com_GetUrlParameter(location.href, "excepteIds"));
	if("" != Com_GetUrlParameter(location.href, "isShowAll"))
		url = Com_SetUrlParameter(url, "isShowAll", Com_GetUrlParameter(location.href, "isShowAll"));
	if("" != Com_GetUrlParameter(location.href, "nodeType"))
		url = Com_SetUrlParameter(url, "nodeType", Com_GetUrlParameter(location.href, "nodeType"));
	if("" != Com_GetUrlParameter(location.href, "categoryId"))
		url = Com_SetUrlParameter(url, "categoryId", Com_GetUrlParameter(location.href, "categoryId"));
	if("" != Com_GetUrlParameter(location.href, "myflow"))
		url = Com_SetUrlParameter(url, "myflow", Com_GetUrlParameter(location.href, "myflow"));
	if("" != Com_GetUrlParameter(location.href, "status"))
		url = Com_SetUrlParameter(url, "status", Com_GetUrlParameter(location.href, "status"));
	if("" != Com_GetUrlParameter(location.href, "mydoc"))
		url = Com_SetUrlParameter(url, "mydoc", Com_GetUrlParameter(location.href, "mydoc"));
	if("" != Com_GetUrlParameter(location.href, "s_path"))
		url = Com_SetUrlParameter(url, "s_path", Com_GetUrlParameter(location.href, "s_path"));
	if("" != Com_GetUrlParameter(location.href, "s_css"))
		url = Com_SetUrlParameter(url, "s_css", Com_GetUrlParameter(location.href, "s_css"));
	if("" != Com_GetUrlParameter(location.href, "departmentId"))
		url = Com_SetUrlParameter(url, "departmentId", Com_GetUrlParameter(location.href, "departmentId"));

	window.location.href = url;
}

function doCheckDate(){
	var docStartdate = document.getElementsByName("docStartdate")[0].value;
	var docFinishdate = document.getElementsByName("docFinishdate")[0].value;
	if(docStartdate != '' && docFinishdate != ''){
		if(docStartdate > docFinishdate){
			alert('<bean:message bundle="km-review" key="kmReviewMain.startDateAfterendDate"/>');
		}
	}
}

window.onload =function (){
	//保留查询时输入的数据，只有在执行重置时清空
	var oldUrl = location.href;
	var docSubject = Com_GetUrlParameter(oldUrl,'docSubject');
	var fdNumber = Com_GetUrlParameter(oldUrl,'fdNumber');
	var docStartdate = Com_GetUrlParameter(oldUrl,'docStartdate');
	var docFinishdate = Com_GetUrlParameter(oldUrl,'docFinishdate');
	var docCreatorId = Com_GetUrlParameter(oldUrl,'docCreatorId');
	var fdTemplateId = Com_GetUrlParameter(oldUrl,'fdTemplateId');
	
	if(docCreatorId != null &&  docCreatorId != ''){
		document.getElementsByName("docCreatorId")[0].value = "${requestScope.docCreatorId}";
		document.getElementsByName("docCreatorName")[0].value = "${requestScope.docCreatorName}";
	}
	if(docSubject != null &&  docSubject != ''){
		document.getElementsByName("docSubject")[0].value=docSubject;
	}
	if(fdNumber != null &&  fdNumber != ''){
		document.getElementsByName("fdNumber")[0].value=fdNumber;
	}
	if(docStartdate != null &&  docStartdate != ''){
		document.getElementsByName("docStartdate")[0].value=docStartdate;
	}
	if(docFinishdate != null &&  docFinishdate != ''){
		document.getElementsByName("docFinishdate")[0].value=docFinishdate;
	}
	if(fdTemplateId != null &&  fdTemplateId != ''){
		document.getElementsByName("fdTemplateId")[0].value = "${requestScope.fdTemplateId}";
		document.getElementsByName("fdTemplateName")[0].value = "${requestScope.fdTemplateName}";
	}
};
</script>
	<table id="condition" class="tb_normal" width="95%">
		<tr width="100%">
			<!-- 主题 -->
			<td class="td_normal_title" width="10%">
				<bean:message bundle="km-review" key="kmReviewMain.docSubject"/>
			</td><td width="23%" >
				<input type="text" id="docSubject" name="docSubject" class="inputSgl" style="width:80%">
			</td>
			<!-- 申请人 -->
			<td class="td_normal_title" width="10%">
				<bean:message bundle="km-review" key="kmReviewMain.docCreatorName"/>
			</td><td width="23%">
				<xform:dialog  propertyId="docCreatorId" propertyName="docCreatorName" style="width:80%"
					dialogJs="Dialog_Address(false, 'docCreatorId', 'docCreatorName', ';', ORG_TYPE_PERSON)"  showStatus="edit" />
			</td>
			<td width="33%" colspan="2">
				<!-- 查询按钮 -->
				<input type="button" value="<bean:message bundle="km-review" key="button.searchList"/>" onclick="KmReview_Search()">
				<!-- 重置按钮 -->
				<input type="button" value="<bean:message bundle="km-review" key="button.reset"/>"  onclick="doReset()">
			</td>
		</tr>
		<tr>
			<!-- 申请单编号 -->
			<td class="td_normal_title" width="10%">
				<bean:message bundle="km-review" key="kmReviewMain.fdNumber"/>
			</td><td width="23%">
				<xform:text property="fdNumber" showStatus="edit" style="width:80%"></xform:text>
			</td>
			<!-- 模板名称 -->
			<td class="td_normal_title" width="10%">
				<bean:message bundle="km-review" key="kmReviewTemplate.fdName"/>
			</td><td width="23%">
				<xform:dialog propertyId="fdTemplateId" propertyName="fdTemplateName" style="width:80%" showStatus="edit"
					dialogJs="Dialog_Template('com.landray.kmss.km.review.model.KmReviewTemplate','fdTemplateId::fdTemplateName',false,true);" />
			</td>
			<!-- 创建时间 -->
			<td class="td_normal_title" width="10%">
				<bean:message bundle="km-review" key="kmReviewTemplate.docCreateTime"/>
			</td><td width="23%">
				<xform:datetime  property="docStartdate" dateTimeType="date" showStatus="edit" style="width:30%" onValueChange="doCheckDate"/>—
				<xform:datetime  property="docFinishdate" dateTimeType="date" showStatus="edit" style="width:30%" onValueChange="doCheckDate"/>
			</td>
		</tr>
	</table>