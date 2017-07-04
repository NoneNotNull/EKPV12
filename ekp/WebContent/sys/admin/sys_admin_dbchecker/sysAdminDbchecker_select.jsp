<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/sys/config/resource/edit_top.jsp"%>
<link rel="stylesheet" href="<c:url value="/sys/admin/resource/images/dbcheck_select.css"/>" />
<kmss:windowTitle subjectKey="sys-admin:sysAdminDbchecker.dbchecker" moduleKey="sys-admin:home.nav.sysAdmin" />
<script type="text/JavaScript">
Com_IncludeFile("jquery.js");
</script>
<script type="text/javascript" src="<c:url value="/sys/admin/resource/js/jquery.corner.js"/>"></script>
<script type="text/javascript">
function chooesType(val) {
	var advance = document.getElementById("advance");
	if(val=="1") {
		advance.style.display = 'none';
	} else {
		advance.style.display = '';
	}
	$("#div_main").corner("destroy");
	$("#div_main").corner("13px");
}
//全选
function selectAll(obj) {
	var _fdCheckScope = document.getElementsByName("fdCheckScope");
	for(var i = 0; i < _fdCheckScope.length; i++){
		if(obj.checked) {
			_fdCheckScope[i].checked = true;
		} else {
			_fdCheckScope[i].checked = false;
		}
	}
}
//单个的选择
function selectElement(element){
	if(element && !element.checked){
		document.getElementsByName("fdCheckScopeAll")[0].checked = false;
	} else {
		var flag = true;
		var _fdCheckScope = document.getElementsByName("fdCheckScope");
		for (var j = 0; j < _fdCheckScope.length; j++){
			if(!_fdCheckScope[j].checked){
				flag = false;
				break;
			}
		}
		if(flag) { //勾选全选
			document.getElementsByName("fdCheckScopeAll")[0].checked = true;
		} else {
			document.getElementsByName("fdCheckScopeAll")[0].checked = false;
		}
	}
}
var SysAdmin_Loading_Div;
function createLoadingDiv() {
	var _img, _text, _div;
	_img = document.createElement('img');
	_img.src = Com_Parameter.ContextPath + "resource/style/common/images/loading.gif";
	_text = document.createElement("label");
	_text.id = 'SysAdmin_loading_Text_Label';
	_text.appendChild(document.createTextNode('<bean:message bundle="sys-admin" key="sysAdminDbchecker.checking"/>'));
	_text.style.color = "#00F";
	_text.style.height = "16px";
	_text.style.margin = "5px";
	_div = document.createElement('div');
	_div.id = "SysAdmin_Loading_Div";
	_div.style.position = "absolute";
	_div.style.padding = "5px 10px";
	_div.style.fontSize = "12px";
	_div.style.backgroundColor = "#F5F5F5";
	_div.appendChild(_img);
	_div.appendChild(_text);
	_div.style.top = 95 + document.body.scrollTop;
	_div.style.left = document.body.clientWidth / 2 + document.body.scrollLeft - 73;
	SysAdmin_Loading_Div = _div;
}
function showLoadingDiv() {
	document.body.appendChild(SysAdmin_Loading_Div);
}
function check() {
	var flag = false;
	var _fdCheckType = document.getElementsByName("fdCheckType");
	if(_fdCheckType[0].checked) {
		flag = true;
	} else {
		var _fdCheckScope = document.getElementsByName("fdCheckScope");
		for(var i = 0; i < _fdCheckScope.length; i++) {
			if(_fdCheckScope[i].checked) {
				flag = true;
				break;
			}
		}
	}
	if(flag) {
		if(!confirm('<bean:message bundle="sys-admin" key="sysAdminDbchecker.startCheck.comfirm"/>')) {
			return false;
		}
		showLoadingDiv(); // 提示信息
		return true;
	} else {
		alert("至少需要选择一个应用模块进行检测！");
		return false;
	}
}
$(document).ready(function() {
	chooesType("1");
	createLoadingDiv();
});
</script>
<br />
<html:form action="/sys/admin/sys_admin_dbchecker/sysAdminDbchecker.do">
<p class="txttitle"><bean:message bundle="sys-admin" key="sysAdminDbchecker.dbchecker"/></p>
<center>
<div id="div_main" class="div_main">
<table width="100%" class="tb_normal" cellspacing="1">
	<tr>
		<td height="15px" background="<c:url value="/sys/admin/resource/images/bg_blue.gif"/>" class="rd_title">
			<label>
				<html:radio property="fdCheckType" value="1" onclick="chooesType(this.value);" /><bean:message key="sysAdminDbchecker.fdCheckType.1" bundle="sys-admin" />
			</label>
		</td>
	</tr>
	<tr>
		<td height="15px" background="<c:url value="/sys/admin/resource/images/bg_blue.gif"/>" class="rd_title">
			<label>
				<html:radio property="fdCheckType" value="2" onclick="chooesType(this.value);" /><bean:message key="sysAdminDbchecker.fdCheckType.2" bundle="sys-admin" />
			</label>
		</td>
	</tr>
	<tr id="advance" style="display: none">
		<td align="center" style="border: 0px;">
			<table class="tb_noborder" width="100%">
				<tr>
					<td>
						<div style="border-bottom: 1px dashed; height: 25px;">
							<div style="float: left; margin-left: 5px; font-weight: bold;"><bean:message key="sysAdminDbchecker.byAppModel" bundle="sys-admin" /></div>
							<div style="float: right; margin-right: 5px;">
								<label>
									<input type="checkbox" name="fdCheckScopeAll" value="all" onclick="selectAll(this);" /><bean:message key="sysAdminDbchecker.selectAll" bundle="sys-admin" />
				  				</label>
			  				</div>
		  				</div>
  						<div style="text-align: center; padding: 3px;">
						<table style="width:100%" class="tb_dotted">
							<tr>
							<c:forEach items="${moduleList}" var="element" varStatus="status">
						  		<td style="border: 0" width="25%">
						  			<label>
						  				<html:checkbox property="fdCheckScope" value="${element['urlPrefix']}" onclick="selectElement(this);" />
										<c:out value="${element['name']}" />
									</label>
								</td>
						<c:if test="${(status.index+1) mod 4 eq 0}">
							</tr>
							<c:if test="${!(status.last)}">
							<tr>
							</c:if>
						</c:if>
							</c:forEach>
							<c:if test="${fn:length(moduleList) mod 4 ne 0}">
								<c:if test="${entriesDesignCount mod 4 eq 1}">
									<td style="border: 0" width="25%"></td>
									<td style="border: 0" width="25%"></td>
									<td style="border: 0" width="25%"></td>
								</c:if>
								<c:if test="${fn:length(moduleList) mod 4 eq 2}">
									<td style="border: 0" width="25%"></td>
									<td style="border: 0" width="25%"></td>
								</c:if>
								<c:if test="${fn:length(moduleList) mod 4 eq 3}">
									<td style="border: 0" width="25%"></td>
								</c:if>
							</c:if>
							</tr>
						</table>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<center>
<table width="auto" class="tb_noborder" style="margin-top: 10px;"  cellpadding="0" cellspacing="0">
	<tr>
		<td background="<c:url value="/sys/admin/resource/images/but_left_nor.png"/>" width="30" height="37"></td>
		<td align="center" background="<c:url value="/sys/admin/resource/images/but_cent_nor.png"/>">
			<a href="javascript:void(0);" class="btn_submit_txt"
				onclick="if(!check())return;Com_Submit(document.sysAdminDbcheckerForm, 'check');"><bean:message
				bundle="sys-admin" key="sysAdminDbchecker.startCheck" /></a>
		</td>
		<td background="<c:url value="/sys/admin/resource/images/but_right_nor.png"/>"  width="10" height="37"></td>
	</tr>
</table>
</center>
</div>
</center>
<html:hidden property="method_GET" />
</html:form>
<%@ include file="/sys/config/resource/edit_down.jsp"%>