<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>


<script type="text/javascript">

	function checkModels(){
		var modelName="";  
		var flag=true;
		var entriesDesignCount=document.getElementsByName("entriesDesignCount")[0].value;
			//循环勾选
			for(var i=0;i<entriesDesignCount;i++){
				if( document.getElementsByName("element"+i)[0].checked){
					modelName+=document.getElementsByName("element"+i)[0].value+"%"; 
				}
			}	 
		 	if(modelName!=""){
				modelName=modelName.substring(0,modelName.length-1);
		 	}
		 	document.getElementsByName("fdCategoryModel")[0].value= modelName;
	}

	function commit(method){
		if(document.getElementsByName("fdCategoryModel")[0].value==""){
			alert("请选择对应模块！");
			return false;
		}
		Com_Submit(document.sysFtsearchModelgroupForm, method)
	}

</script>

<html:form action="/sys/ftsearch/expand/sys_ftsearch_modelgroup/sysFtsearchModelgroup.do">
<div id="optBarDiv">
	<c:if test="${sysFtsearchModelgroupForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="commit('update')">
	</c:if>
	<c:if test="${sysFtsearchModelgroupForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="commit('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="commit('saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-ftsearch-expand" key="table.sysFtsearchModelgroup"/></p>

<input type='hidden'  name ='entriesDesignCount'  value='${entriesDesignCount}' />

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchModelgroup.fdCategoryName"/>
		</td><td width="35%">
			<xform:text property="fdCategoryName" style="width:85%" />
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchModelgroup.fdCategoryModel"/>
		</td>
		<td width="35%">
			<c:forEach items="${entriesDesign}" var="element" varStatus="status">
				<li>
					<label for="">
						<input id='element${status.index}' type="checkbox" name="checkbox_model"
							<c:if test="${element['flag']==true}">
							checked
							</c:if> 
						onclick="checkModels('checkbox_model')"  value='${element['multiModelName']}'>${element['multiModelDesc']}</label>
				</li>
			</c:forEach>	
			<html:hidden property="fdCategoryModel"/>
			
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>