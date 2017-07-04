/**
 * 
 */
package com.landray.kmss.tib.common.inoutdata.service;

import java.util.List;
import java.util.Map;

/**
 * @author 邱建华
 * @version 1.0 2013-1-9
 */
public interface ITibCommonInoutdataCategoryService {
	/***********************************************
	功能：添加类别展开树，此方法是获取全局分类的
	参数：
		modelName:必填，当前的域模型名称
		authType:对节点的验证权限,0显示所有(00可以选中所有,01只能选中有维护权限的,
					02只能选中有使用权限的),1 只显示有维护权限的 2 只显示有使用权限的
		categoryId:必填，当前类别id，通常为!{value}
		getTemplate: 可选，是否显示模板，0不显示，1 显示模板，类别不可选择，2 显示模板并且类别可选择 默认是2
		showType:可选,显示方式,0显示父机构分类和子机构分类,只1显示父机构分类,2只显示子机构分类
	***********************************************/
	public List<Map<String, Object>> getGlobalCategoryList(String categoryId, String modelName,
			String authType, String isGetTemplate, String showType) throws Exception; 
	
	/***********************************************
	功能：添加类别展开树，此方法是获取简单分类的
	参数：
		modelName:必填，当前的域模型名称
		authType:对节点的验证权限,0显示所有(00可以选中所有,01只能选中有维护权限的,
					02只能选中有使用权限的),1 只显示有维护权限的 2 只显示有使用权限的
		categoryId:必填，当前类别id，通常为!{value}
		showType:可选,显示方式,0显示父机构分类和子机构分类,只1显示父机构分类,2只显示子机构分类
	***********************************************/
	public List<Map<String, Object>> getSimpleCategoryList(String categoryId, 
			String modelName, String authType) throws Exception; 

	public static final String TIB_COMMONMAPPINGMAIN_NAME = "com.landray.kmss.tib.common.mapping.model.TibCommonMappingMain";
}
