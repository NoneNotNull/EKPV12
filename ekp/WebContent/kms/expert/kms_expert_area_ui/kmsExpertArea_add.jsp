<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.simplecategory.model.ISysSimpleCategoryModel"%>
<%@page import="com.landray.kmss.sys.category.model.ISysCategoryBaseModel"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%	
	String cateName = (String)request.getParameter("cateModelName");
	Class<?> clz = Class.forName(cateName);
	String cateType = null;
	if (ISysSimpleCategoryModel.class.isAssignableFrom(clz))
		//简单分类
		cateType = "sysSimpleCategory";
	else if (ISysCategoryBaseModel.class.isAssignableFrom(clz))
		//全局分类
		cateType = "sysCategory";
	request.setAttribute("cateType",cateType);
%>
<script>
	Com_IncludeFile("data.js|dialog.js");
</script>
<tr>
	<td width="9%" class="td_normal_title">${param.areaMessage }</td>
	<td >
		<xform:dialog dialogJs="selectAreaNames('${cateType}', '${param.cateModelName }',
												'fdKmsExpertAreaListForms[${param.index}].fdCategoryId', 
												'fdKmsExpertAreaListForms[${param.index}].fdCategoryName',
												'${param.areaMessage}')"
					  propertyId="fdKmsExpertAreaListForms[${param.index}].fdCategoryId" 
					  propertyName="fdKmsExpertAreaListForms[${param.index}].fdCategoryName" 
					  style="width:93%">
		</xform:dialog>
	</td>
	<html:hidden
		property="fdKmsExpertAreaListForms[${param.index}].fdModelName"
		value="${param.fdModelName }" />
	<html:hidden property="fdKmsExpertAreaListForms[${param.index}].fdKey"
		         value="${param.fdKey }" />
</tr>

<script>

	function selectAreaNames(_cateType,cateModelName, idField, nameField, winTitle) {
		if(_cateType &&  _cateType == "sysSimpleCategory") {		
			seajs.use(['lui/dialog'],function(dialog) {
				dialog.simpleCategory(cateModelName, idField, nameField, true,
					null, winTitle, true,null,false);
			});
		}
		else if(_cateType &&  _cateType == "sysCategory") {
			seajs.use(['lui/dialog'],function(dialog) {
				dialog.category(cateModelName, idField, nameField, true,
					null, winTitle, true,null,false);
			});
		}
	}

</script>