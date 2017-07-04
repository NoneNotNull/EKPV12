<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit"  sidebar="auto">
<template:replace name="toolbar">
	<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
		<c:if test="${kmImissiveUnitForm.method_GET=='edit'}">
		    <ui:button text="提交" order="2" onclick="Com_Submit(document.kmImissiveUnitForm, 'update');">
		    </ui:button>
		</c:if>
		<c:if test="${kmImissiveUnitForm.method_GET=='add'}">
	  	    <ui:button text="保存" order="1" onclick="Com_Submit(document.kmImissiveUnitForm, 'save');">
		    </ui:button>
		    <ui:button text="保存并新建" order="2" onclick="Com_Submit(document.kmImissiveUnitForm, 'saveadd');">
		    </ui:button>
		</c:if>
		 <ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()">
		 </ui:button>
	</ui:toolbar>
</template:replace>
<template:replace name="content">
<html:form action="/km/imissive/km_imissive_unit/kmImissiveUnit.do">
<script type="text/javascript">
function refreshUnitDisplay(value){
	if(value=="1"){
		$(".secretary").show();
		document.getElementById("sec").setAttribute("validate", "required");
		document.getElementById("span_inner").style.display ="block";
	}
	if(value=="0"){
		document.getElementById("sec").setAttribute("validate", "");
		$(".secretary").hide();
		document.getElementById("span_inner").style.display ="none";
	}
}
$(document).ready(function(){
	refreshUnitDisplay('${kmImissiveUnitForm.fdNature}');
});
</script>
<p class="txttitle"><bean:message  bundle="km-imissive" key="table.kmImissiveUnit"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdCategoryId"/>
		</td><td width=85% colspan="3">
		    <xform:dialog required="true" propertyId="fdCategoryId" propertyName="fdCategoryName" className="inputsgl" style="width:94%" subject="${ lfn:message('km-imissive:kmImissiveUnit.fdCategoryId')}">
		       Dialog_Tree(false, 'fdCategoryId', 'fdCategoryName', ',', 'kmImissiveUnitCategoryTreeService', '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>', null, null, '${param.fdId}', null, null, '<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdCategoryId"/>');
		    </xform:dialog>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdNature"/>
		</td><td width=35%>
			<sunbor:enums property="fdNature" enumsType="kmImissiveUnit.fdNature" elementType="radio" htmlElementProperties="onclick='refreshUnitDisplay(value);'"/>
		</td>
		<td class="td_normal_title" width=15%>
		  <div class="secretary">
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdSecretaryId"/>
		  </div>
		</td>
		<td width=35%>
		  <div class="secretary">
		    <xform:address htmlElementProperties="id='sec'" required="true" subject="${ lfn:message('km-imissive:kmImissiveUnit.fdSecretaryId')}" propertyName="fdSecretaryNames" propertyId="fdSecretaryIds" orgType="ORG_TYPE_PERSON|ORG_TYPE_POST" className="inputsgl" style="width:85%" mulSelect="true"></xform:address>
		  </div>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdName"/>
		</td><td width=35%>
		  <div>
		    <div style="width:80%;float:left">
		     <input type="hidden" name="fdDeptId">
			 <xform:text property="fdName" className="inputsgl" style="width:96%" required="true" subject="${ lfn:message('km-imissive:kmImissiveUnit.fdName')}"/>
		    </div>
			<span id="span_inner" style="float:left;margin-left:8px">
			  <a href="#" onclick="Dialog_Address(false, 'fdDeptId', 'fdName', null, ORG_TYPE_DEPT);"><bean:message key="dialog.selectOrg"/></a>		
		    </span>
		  </div>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdShortName"/>
		</td><td width=35%>
			<xform:text property="fdShortName" style="width:85%" required="true"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdOrder"/>
		</td><td width=35%>
			<xform:text property="fdOrder" style="width:85%" validators="number"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdIsAvailable"/>
		</td><td width=35%>
			<sunbor:enums property="fdIsAvailable" enumsType="common_yesno" elementType="radio" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdContent"/>
		</td><td width=85% colspan='3'>
			<xform:textarea property="fdContent" style="width:94%" />
		</td>
	</tr>
	<tr>
			<td class="td_normal_title" width="15%">
			   <bean:message bundle="km-imissive" key="kmImissiveUnit.areader.distribute"/>
			</td>
			<td width="85%" colspan="3">
			 <xform:address propertyName="authReaderNamesDistribute" propertyId="authReaderIdsDistribute" orgType="ORG_TYPE_ALL|ORG_TYPE_ROLE"  style="width:94%" textarea="true" mulSelect="true"></xform:address>
			<br><bean:message bundle="km-imissive" key="kmImissiveUnit.unitUser"/>
			</td>
	</tr>
	<tr>
			<td class="td_normal_title" width="15%">
			  <bean:message bundle="km-imissive" key="kmImissiveUnit.areader.report"/>
			</td>
			<td width="85%" colspan="3">
			<xform:address propertyName="authReaderNamesReport" propertyId="authReaderIdsReport" orgType="ORG_TYPE_ALL|ORG_TYPE_ROLE"  style="width:94%" textarea="true" mulSelect="true"></xform:address>
			<br><bean:message bundle="km-imissive" key="kmImissiveUnit.unitUser"/>
			</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
<script language="JavaScript">
	$KMSSValidation(document.forms['kmImissiveUnitForm']);
</script>
</html:form>
</template:replace>
</template:include>