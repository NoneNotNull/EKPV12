<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ include file="/sys/config/resource/view_top.jsp"%>
<kmss:windowTitle subjectKey="sys-admin:sysAdminDbchecker.checkResult" moduleKey="sys-admin:home.nav.sysAdmin" />
<script>
Com_IncludeFile("jquery.js|json2.js|popdialog.js");
Com_Parameter.CloseInfo='<bean:message key="message.closeWindow"/>';
</script>
<script type="text/javascript" src="<c:url value="/sys/admin/resource/js/ajaxSyncComponent.js"/>"></script>
<div id="optBarDiv">
	<input type="button" value='<bean:message bundle="sys-admin" key="sysAdminDbchecker.reCheck"/>'
		onclick="Com_OpenWindow('<c:url value="/sys/admin/sys_admin_dbchecker/sysAdminDbchecker.do" />?method=select&reCheck=true', '_self');">
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-admin" key="sysAdminDbchecker.checkResult" /></p>
<center>
<table width="95%" border="0" align="center">
	<tr>
		<td width="15" bgcolor="#FF0000">&nbsp;</td>
		<td><bean:message bundle="sys-admin" key="sysAdminDbchecker.error" /></td>
		<td></td>
	</tr>
	<tr>
		<td width="15" bgcolor="#FFFF00">&nbsp;</td>
		<td><bean:message bundle="sys-admin" key="sysAdminDbchecker.warn" /></td>
		<td></td>
	</tr>
	<tr>   
		<td width="15" bgcolor="#D1D1D1">&nbsp;</td>
		<td><bean:message bundle="sys-admin" key="sysAdminDbchecker.suggest" /></td>
		<td></td>
	</tr>
	<tr>
		<td width="15" bgcolor="#00FF00">&nbsp;</td>
		<td><bean:message bundle="sys-admin" key="sysAdminDbchecker.info" /></td>
		<td></td>
	</tr>
</table>
<kmss:auth requestURL="/sys/admin/resource/jsp/jsonp.jsp">
<table width=95%>
	<tr>
		<td align="right">
			<span id="progress1" style="color: red"></span>
		</td>
		<td align="right" width="10%">
			<input name="btnRepair" class="btnopt" type="button" value="<bean:message bundle="sys-admin" key="sysAdminDbchecker.start" />" style="height:20px" 
				onclick="repair();">
		</td>
	</tr>
</table>
</kmss:auth>
<table class="tb_normal" width=98% id="table_result">
	<tr>
		<td width="35%" class="td_normal_title" style="word-break: keep-all;"><bean:message bundle="sys-admin" key="sysAdminDbchecker.tableName" /></td>
		<td width="45%" class="td_normal_title"><bean:message bundle="sys-admin" key="sysAdminDbchecker.result" /></td>
		<td width="10%" class="td_normal_title"><bean:message bundle="sys-admin" key="sysAdminDbchecker.repairSuggest" /></td>
		<td width="10%" class="td_normal_title"><bean:message bundle="sys-admin" key="sysAdminDbchecker.repairResult" /></td>
	</tr>
	<c:set var="isCheckOk" value="true" />
	<c:forEach items="${dbChecker_checkResultDetailMap}" var="checkResultDetailMap" varStatus="statusLevel">
	<c:if test="${not empty checkResultDetailMap.value}">
	<c:set var="isCheckOk" value="false" />
	<%-- 错误级别 --%>
	<tr
	<c:choose>
		<c:when test="${'ERROR' eq checkResultDetailMap.key.type}">
			style="background-color:#FF0000"
		</c:when>
		<c:when test="${'WARN' eq checkResultDetailMap.key.type}">
			style="background-color:yellow"
		</c:when>
		<c:when test="${'SUGGEST' eq checkResultDetailMap.key.type}">
			style="background-color:#D1D1D1"
		</c:when>
		<c:when test="${'INFO' eq checkResultDetailMap.key.type}">
			style="background-color:#00FF00"
		</c:when>
	</c:choose>>
		<td>
			<img id="img_${checkResultDetailMap.key.type}" alt="<bean:message bundle="sys-admin" key ="sysAdminDbchecker.minus" />" border="0" 
				src="${KMSS_Parameter_ResPath}style/default/icons/minus.gif" onclick="showDetail('${checkResultDetailMap.key.type}', 'module');"/>
			<label>
				<c:if test="${checkResultDetailMap.key.type eq 'ERROR'}">
					<%-- 错误级别默认选中 --%>
					<input type="checkbox" name="cb_${statusLevel.index}" value="" onclick="onCbClick(this);" checked />
				</c:if>
				<c:if test="${checkResultDetailMap.key.type eq 'WARN'}">
					<input type="checkbox" name="cb_${statusLevel.index}" value="" onclick="onCbClick(this);" />
				</c:if>
				<c:out value="${checkResultDetailMap.key.name}" />
			</label>
		</td>
		<td colspan="3"></td>
	</tr>
	<%-- 按模块 --%>
	<c:forEach items="${checkResultDetailMap.value}" var="checkResultModuleMap" varStatus="statusModule">
	<tr module="tr_${checkResultDetailMap.key.type}">
		<td>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<img id="img_${checkResultDetailMap.key.type}_${checkResultModuleMap.key}" 
				alt='<bean:message bundle="sys-admin" key ="sysAdminDbchecker.minus" />' border="0" 
				src="${KMSS_Parameter_ResPath}style/default/icons/minus.gif" 
				onclick="showDetail('${checkResultDetailMap.key.type}_${checkResultModuleMap.key}', 'item');"/>
			<label>
				<c:if test="${checkResultDetailMap.key.type eq 'ERROR'}">
					<%-- 错误级别默认选中 --%>
					<input type="checkbox" name="cb_${statusLevel.index}_${statusModule.index}" 
						parent="cb_${statusLevel.index}" value="" onclick="onCbClick(this);" checked />
				</c:if>
				<c:if test="${checkResultDetailMap.key.type eq 'WARN'}">
					<input type="checkbox" name="cb_${statusLevel.index}_${statusModule.index}" 
						parent="cb_${statusLevel.index}" value="" onclick="onCbClick(this);" />
				</c:if>
				<c:out value="${checkResultModuleMap.key}" />
			</label>
		</td>
		<td colspan="3"></td>
	</tr>
	<c:forEach items="${checkResultModuleMap.value}" var="checkResult" varStatus="status">
	<tr module="tr_${checkResultDetailMap.key.type}" item="tr_${checkResultDetailMap.key.type}_${checkResultModuleMap.key}">
		<td>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<label>
			<c:set var="disabledCheckbox" value="false" />
			<c:if test="${'com.landray.kmss.sys.admin.dbchecker.core.NullResultRepairStrategy' == checkResult.resultRepair.fdResultRepairStrategy.name || empty checkResult.resultRepair.fdResultRepairStrategy.name}">
				<c:set var="disabledCheckbox" value="true" />
			</c:if>
			<c:if test="${checkResultDetailMap.key.type eq 'ERROR'}">
				<input type="checkbox" name="cb_${statusLevel.index}_${statusModule.index}_${statusItem.index}" id="${checkResult.fdId}"
					parent="cb_${statusLevel.index}_${statusModule.index}" value="${checkResult.fdId}" onclick="onCbClick(this);" <c:choose><c:when test="${'true' == disabledCheckbox}">disabled</c:when><c:otherwise>checked</c:otherwise></c:choose> />
			</c:if>
			<c:if test="${checkResultDetailMap.key.type eq 'WARN'}">
				<input type="checkbox" name="cb_${statusLevel.index}_${statusModule.index}_${statusItem.index}" id="${checkResult.fdId}"
					parent="cb_${statusLevel.index}_${statusModule.index}" value="${checkResult.fdId}" onclick="onCbClick(this);" <c:if test="${'true' == disabledCheckbox}">disabled</c:if> />
			</c:if>
			<%-- 优先级 --%>
			<input type="hidden" name="priority_${checkResult.fdId}" value="<c:out value='${checkResult.fdPriority}' />" />
			<%-- 修复策略 --%>
			<input type="hidden" name="strategy_${checkResult.fdId}" value="<c:out value='${checkResult.resultRepair.fdResultRepairStrategy.name}' />" />
			<%-- 参数 --%>
			<input type="hidden" name="param_${checkResult.fdId}" value="<c:out value='${checkResult.resultRepair.jsonString}' />" />
			<c:out value="${checkResult.fdTable}" />
			</label>
		</td>
		<td><c:out value="${checkResult.fdResult}" /></td>
		<td>
			<c:choose>
				<c:when test="${not empty checkResult.resultRepair.fdSuggest.fdName}">
					<a href="javascript:createDialog('<c:out value="${checkResult.resultRepair.fdSuggest.fdName}" />','<c:out value="${checkResult.resultRepair.fdSuggest.fdContent}" />');">
						<c:out value="${checkResult.resultRepair.fdSuggest.fdName}" />
					</a>
				</c:when>
				<c:otherwise>
					<c:out value="${checkResult.fdLevelType.info}" />
				</c:otherwise>
			</c:choose>
		</td>
		<td>
			<span id="result_${checkResult.fdId}">N/A</span>
		</td>
	</tr>
	</c:forEach>
	</c:forEach>
	</c:if>
	</c:forEach>
	<c:if test="${'true' == isCheckOk}">
		<tr>
			<td colspan="4"><bean:message bundle="sys-admin" key="sysAdminDbchecker.checkResult.ok" /></td>
		</tr>
	</c:if>
</table>
<kmss:auth requestURL="/sys/admin/resource/jsp/jsonp.jsp">
<table width=95%>
	<tr>
		<td align="right">
			<span id="progress2" style="color: red"></span>
		</td>
		<td align="right" width="10%">
			<input name="btnRepair" class="btnopt" type="button" value="<bean:message bundle="sys-admin" key="sysAdminDbchecker.start" />" style="height:20px" 
				onclick="repair();">
		</td>
	</tr>
</table>
</kmss:auth>
</center>
<script>
Lang = {
	plus: '<bean:message bundle="sys-admin" key ="sysAdminDbchecker.plus" />',
	minus: '<bean:message bundle="sys-admin" key ="sysAdminDbchecker.minus" />',
	noSelect: '<bean:message bundle="sys-admin" key ="sysAdminDbchecker.noSelect" />',
	comfirmRepair: '<bean:message bundle="sys-admin" key ="sysAdminDbchecker.comfirmRepair" />',
	waitting: '<bean:message bundle="sys-admin" key ="sysAdminDbchecker.waitting" />',
	running: '<bean:message bundle="sys-admin" key ="sysAdminDbchecker.running" />',
	start: '<bean:message bundle="sys-admin" key="sysAdminDbchecker.start" />',
	stop: '<bean:message bundle="sys-admin" key="sysAdminDbchecker.stop" />',
	success: '<bean:message bundle="sys-admin" key="sysAdminDbchecker.success" />',
	failure: '<bean:message bundle="sys-admin" key="sysAdminDbchecker.failure" />',
	close: '<bean:message key="button.close" />',
	repairProgress: '<bean:message bundle="sys-admin" key="sysAdminDbchecker.repairProgress" />'
};
function showDetail(id, type) {
	var isExpand = true;
	var _img = $("#img_"+id);
	if(_img) {
		var plus = "${KMSS_Parameter_ResPath}style/default/icons/plus.gif";
		var minus = "${KMSS_Parameter_ResPath}style/default/icons/minus.gif";
		if(_img.attr("src").indexOf(plus) > -1) {
			_img.attr("src", minus).attr("alt", Lang.minus).attr("title", Lang.minus);
		} else {
			isExpand = false;
			_img.attr("src", plus).attr("alt", Lang.plus).attr("title", Lang.plus);
		}
	}
	var _objs = $("table[id='table_result'] tr["+type+"='tr_"+id+"']");
	if(isExpand) {
		_objs.show();
	} else {
		_objs.hide();
	}
}
function onCbClick(cb) {
	var _cb = $(cb);
	var _childs = $(":checkbox:enabled[name^='"+cb.name+"_']"); // 以名称开头
	if(_cb.prop("checked") == true) {
		_childs.prop("checked", true);
	} else {
		_childs.prop("checked", false);
	}
	clickEvent(_cb, true);
}
// 父类事件
function clickEvent(cb, flag) {
	var _parentName = cb.attr("parent");
	if(_parentName != null) {
		var _parent = $(":checkbox[name='"+_parentName+"']");
		if(_parent != null) {
			if(!flag || cb.prop("checked") == false) {
				// 子类不选择，父类不选择
				_parent.prop("checked", false);
			} else {
				// 子类选择，判断父类是否选择（全选）
				var _childs = $(":checkbox:enabled[name^='"+_parent.attr("name")+"_']");
				_childs.each(function() {
					if($(this).prop("checked") == false) {
						flag = false;
						return false; // 中断循环（break）;
					}
				});
				if(flag) {
					_parent.prop("checked", true);
				} else {
					_parent.prop("checked", false);
				}
			}
			clickEvent(_parent, flag);
		}
	}
}
function repair() { // 修复
	var arr = [], i = 0, n = 0, j = 0, m = 0;
	$(":checkbox:checked[name^='cb_']").each(function() {
		var _this = $(this);
		var val = _this.val();
		if(val) {
			arr.push({
				fdId : val,
				priority : _this.siblings("input[name='priority_"+val+"']").val(),
				strategy : _this.siblings("input[name='strategy_"+val+"']").val(),
				param : _this.siblings("input[name='param_"+val+"']").val()
			});
		}
	});
	if(arr.length == 0) {
		alert(Lang.noSelect);
		return ;
	}
	if(!confirm(Lang.comfirmRepair)) {
		return;
	}
	arr.sort(function(x, y) { // 按优先级排序
		if(y.priority && x.priority) {
	    	return y.priority - x.priority;
		} else {
			return -999;
		}
	});
	for(i = 0, n = arr.length; i < n; i++) {
		$("#result_" + arr[i].fdId).html(Lang.waitting); // 等待执行...
	}
	var stopRepair = function (comp) {
		comp.stop();
		for(i = comp.index, n = comp.datas.length; i < n; i++) {
			var dat = comp.datas[i];
			for (j = 0, m = dat.item.length; j < m; j++) {
				$("#result_" + dat.item[j].fdId).html(Lang.stop); // 停止修复
			}
		}
	};
	var component = ajaxSyncComponent(Com_Parameter.ContextPath+"sys/admin/resource/jsp/jsonp.jsp?s_name=com.landray.kmss.sys.admin.dbchecker.service.spring.SysAdminDbRepairService");
	var btns = $("input[name='btnRepair']").attr("value", Lang.stop);
	for(i = 0, n = btns.length; i < n; i++) {
		btns[i].onclick = function() { // 注册停止修复事件
			stopRepair.call(this, component);
		};
	}
	var batch = 15, index = 0; // 批量提交
	for(i = 1, n = arr.length; i <= n; i++) { // 设置参数
		if(i % batch == 0 || i == n) {
			component.addData({item: arr.slice(index, i)});
			index = i;
		}
	}
	component.beforeRequest = function(comp) { // 请求前事件
		var _data = comp.datas[comp.index];
		for(i = 0; i < _data.item.length; i++) {
			$("#result_" + _data.item[i].fdId).html(Lang.running);
		}
	};
	component.afterResponse = function(arr, comp) { // 响应后事件
		for(i = 0; i < arr.length; i++) {
			var res = $("#result_" + arr[i].fdId);
			var sug = "";
			if(arr[i].suggest) {
				sug = "&nbsp;&nbsp;<a href=\"javascript:createDialog('"+htmlEscape(arr[i].suggest.fdName)+"', '"+htmlEscape(arr[i].suggest.fdContent)+"');\">"+htmlEscape(arr[i].suggest.fdName)+"</a>";
			}
			if("SUCCESS" === arr[i].state) {
				$("#"+arr[i].fdId).prop("checked", false).prop("disabled", true); // id查找提高性能
				res.css("color","#00FF00").html(Lang.success+sug);
			} else if("FAILURE" === arr[i].state) {
				res.css("color","#FF0000").html(Lang.failure+sug);
			}
			var p = Math.round(comp.index*100/comp.count);
			$("#progress1").html(Lang.repairProgress+p+"%");
			$("#progress2").html(Lang.repairProgress+p+"%");
		}
	};
	component.onComplate = function(comp) { // 完成后事件
		btns.attr("value", Lang.start);
		for(i = 0, n = btns.length; i < n; i++) {
			btns[i].onclick = function() {
					repair();
			};
		}
	};
	component.traverse();
}
function htmlEscape(s){
	if(s==null || s=="")
		return "";
	var re = /'/g;
	s = s.replace(re, "\\'");
	return s;
}

function createDialog(title, content) {
	var dialog = new PopDialog({width:600, title:title, content:content, buttons:{'<bean:message key="button.close" />': colseDialog}});
	function colseDialog() {
		dialog.close();
	}
}
</script>
<%@ include file="/sys/config/resource/view_down.jsp"%>