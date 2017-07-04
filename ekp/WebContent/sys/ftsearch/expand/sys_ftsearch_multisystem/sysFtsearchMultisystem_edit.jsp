<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/ftsearch/expand/sys_ftsearch_multisystem/sysFtsearchMultisystem.do">
<div id="optBarDiv">
	<c:if test="${sysFtsearchMultisystemForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="_submitForm('update');">
	</c:if>
	<c:if test="${sysFtsearchMultisystemForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="_submitForm('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="_submitForm('saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-ftsearch-expand" key="table.sysFtsearchMultisystem"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.fdUrl"/>
		</td><td colspan="3">
			<xform:text property="fdUrl" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.fdSystemName"/>
		</td><td colspan="3">
			<xform:text property="fdSystemName" style="width:35%" />
		</td>
	</tr>
	<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.fdSystemModel"/>
			</td>
			<td width=35%>
				<xform:text property="fdSystemModel" style="width:85%"/>
				<span class="txtstrong">*</span>
				<input type="button" class="btnopt" value="<bean:message bundle="sys-ftsearch-expand" key="button.obtain"/>" onclick="getOutModel()"/>
			</td>
			<td width=50% colspan="2">
				<span style = "color:red">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.modelMessage"/>
				</span>
			</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.fdModelUrl"/>
		</td>
		<td width=35%>
			<xform:text property="fdModelUrl" style="width:85%"/>
			&nbsp;&nbsp;
			<input type="button" class="btnopt" value="<bean:message bundle="sys-ftsearch-expand" key="button.obtain"/>" onclick="getOutModelURL()"/>
		</td>
		<td  width=50% colspan="2">
			<span style = "color:red">
				<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.UrlMessage"/>
			</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.fdSystemIndexdb"/>
		</td><td width="35%">
			<xform:text property="fdSystemIndexdb" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.fdSelectFlag"/>
		</td>
		<td width="35%">
			<xform:radio property="fdSelectFlag">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
	Com_IncludeFile("jquery.js");
	function getOutModel(){
		var fdUrlValue=document.getElementsByName("fdUrl")[0].value;
		if(fdUrlValue==null||fdUrlValue==""){
			alert("请先填写外系统URL！填写了URL才能获取！");
		}else{
			var url="";
			if (fdUrlValue.charAt(fdUrlValue.length - 1) == '/') {
				fdUrlValue=fdUrlValue.substring(0,fdUrlValue.length-1);
				url = fdUrlValue+"/sys/ftsearch/sys_ftsearch_config/sysFtsearchConfig.do?method=getList&jsoncallback=?";
			}else{
				url = fdUrlValue+"/sys/ftsearch/sys_ftsearch_config/sysFtsearchConfig.do?method=getList&jsoncallback=?";
			};
			<%--
			$.getJSON(url, 
		          function(json){ 
					var rtnSystemModel = document.getElementsByName("fdSystemModel")[0];
					rtnSystemModel.value = json;
		     }); 
	         --%>
			$.ajax({
	                url: url,
	                type: "GET",
	                dataType: 'jsonp',
	                jsonp: 'jsoncallback',
	                success: function(data) {
						var rtnSystemModel = document.getElementsByName("fdSystemModel")[0];
	    				rtnSystemModel.value = data;
	                },
	                error : function() {      
	                    alert("请求失败！");    
	               }    
	         });
		}
	};
	function getOutModelURL(){
		var fdUrlValue=document.getElementsByName("fdUrl")[0].value;
		if(fdUrlValue==null||fdUrlValue==""){
			alert("请先填写外系统URL！填写了URL才能获取！");
		}else{
			var url="";
			if (fdUrlValue.charAt(fdUrlValue.length - 1) == '/') {
				fdUrlValue=fdUrlValue.substring(0,fdUrlValue.length-1);
				url = fdUrlValue+"/sys/ftsearch/sys_ftsearch_config/sysFtsearchConfig.do?method=getModelUrlList&jsoncallback=?";
			}else{
				url = fdUrlValue+"/sys/ftsearch/sys_ftsearch_config/sysFtsearchConfig.do?method=getModelUrlList&jsoncallback=?";
			};
			<%--
			$.getJSON(url, 
		          function(json){ 
					var rtnSystemModel = document.getElementsByName("fdSystemModel")[0];
					rtnSystemModel.value = json;
		     }); 
	         --%>
			$.ajax({
	                url: url,
	                type: "GET",
	                dataType: 'jsonp',
	                jsonp: 'jsoncallback',
	                success: function(data) {
						var rtnSystemModel = document.getElementsByName("fdModelUrl")[0];
	    				rtnSystemModel.value = data;
	                },
	                error : function() {      
	                    alert("请求失败！");    
	               }    
	         });
		}
	};
	
	
	
	function _submitForm(parameter){
		if(_check()){
			if(parameter=="update"){
				Com_Submit(document.sysFtsearchMultisystemForm, 'update');
			}else if(parameter=="save"){
				Com_Submit(document.sysFtsearchMultisystemForm, 'save');
			}else if(parameter=="saveadd"){
				Com_Submit(document.sysFtsearchMultisystemForm, 'saveadd');
			}
		}
	}
	function _check(){
		var model = document.getElementsByName("fdSystemModel")[0].value.replace(/[ ]/g,""); 
		if(model=="" ){
			alert("模块不能为空");
			return false;
		}
		return true;
	}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>