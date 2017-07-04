/**
 * 
 */
package com.landray.kmss.tib.common.mapping.service.bean;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.constant.BaseTreeConstant;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.category.service.ISysCategoryMainService;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * @author qiujh
 * @version 1.0 2014-1-7
 */
public class TibCommonMappingGlobalCategoryTreeBean {
	
	private ISysCategoryMainService sysCategoryMainService;
	
	public void setSysCategoryMainService(
			ISysCategoryMainService sysCategoryMainService) {
		this.sysCategoryMainService = sysCategoryMainService;
	}

	public JSONArray treeView(String parentId, String modelName,
			String currId, String expandStr, String __currId, String href,
			String mainModelName, String fdId,
			HttpServletRequest request) throws Exception {
		JSONArray array = new JSONArray();
		boolean expand = StringUtil.isNotNull(parentId)
				&& "true".equals(expandStr);
		if (StringUtil.isNull(parentId) && StringUtil.isNotNull(currId)) {
			parentId = currId;
		}
		if (StringUtil.isNull(parentId) && StringUtil.isNotNull(__currId)) {
			Object[] category = findCategory(__currId);
			if (category != null)
				parentId = (String) category[3];
			else {
				SysDictModel templateModel = SysDataDict.getInstance()
						.getModel(modelName);
				IBaseService service = (IBaseService) SpringBeanUtil
						.getBean(templateModel.getServiceBean());
				String tableName = ModelUtil.getModelTableName(modelName);
				Object[] template = findTemplateModel(service, tableName,
						__currId);
				parentId = (String) template[2];
			}
		}

		Boolean isGetTemplate = isGetTemplate(request);
		List<String> authIds = new ArrayList<String>();
		if (isGetTemplate) {
			authIds = ___getCategoryAuthIds(modelName, null);
		}
		loadCategoriesByParentId(array, parentId, modelName, Boolean.TRUE,
				authIds, isGetTemplate, href, mainModelName, fdId);
		if (expand) {
			for (Iterator<?> it = array.iterator(); it.hasNext();) {
				JSONObject cate = (JSONObject) it.next();
				String cateId = cate.getString("value");
				JSONArray children = new JSONArray();
				loadCategoriesByParentId(children, cateId, modelName,
						Boolean.FALSE, authIds, isGetTemplate, href, mainModelName, fdId);
				cate.put("children", children);
			}
		}
		return array;
	}
	
	private Object[] findCategory(String id) throws Exception {
		HQLInfo info = new HQLInfo();
		info
				.setSelectBlock("sysCategoryMain.fdName, sysCategoryMain.fdId, sysCategoryMain.fdHierarchyId, sysCategoryMain.hbmParent.fdId");
		info.setWhereBlock("sysCategoryMain.fdId = :id");
		info.setParameter("id", id);
		List<?> list = sysCategoryMainService.findValue(info);
		if (list.isEmpty())
			return null;
		return (Object[]) list.get(0);
	}

	private List<Object[]> findCategories(String currId, String[] ids)
			throws Exception {
		if (ids == null || ids.length == 0)
			return Collections.emptyList();
		List<String> idList = new ArrayList<String>();
		for (String id : ids) {
			if (StringUtil.isNull(id) || currId.equals(id)) {
				continue;
			}
			idList.add(id);
		}
		if (idList.isEmpty()) {
			return Collections.emptyList();
		}
		HQLInfo info = new HQLInfo();
		info.setSelectBlock("sysCategoryMain.fdName, sysCategoryMain.fdId");
		info.setWhereBlock("sysCategoryMain.fdId in (:ids)");
		info.setOrderBy("sysCategoryMain.fdHierarchyId asc");
		info.setParameter("ids", idList);
		return (List<Object[]>) sysCategoryMainService.findValue(info);
	}
	
	private Object[] findTemplateModel(IBaseService service,
			String tableName, String id) throws Exception {
		HQLInfo info = new HQLInfo();
		info.setSelectBlock(tableName + ".fdName, " + tableName + ".fdId, "
				+ tableName + ".docCategory.fdId");
		info.setWhereBlock(tableName + ".fdId = :id");
		info.setParameter("id", id);
		List<?> list = service.findValue(info);
		if (list.isEmpty())
			return null;
		return (Object[]) list.get(0);
	}
	
	private Boolean isGetTemplate(HttpServletRequest request) {
		String _isGetTemplate = request.getParameter("getTemplate");
		Boolean isGetTemplate = Boolean.TRUE;
		if (StringUtil.isNotNull(_isGetTemplate) && "0".equals(_isGetTemplate))
			isGetTemplate = Boolean.FALSE;
		String _isShowTemplate = request.getParameter("showTemp");
		Boolean isShowTemplate = Boolean.TRUE;
		if (StringUtil.isNotNull(_isShowTemplate)
				&& "false".equals(_isShowTemplate))
			isShowTemplate = Boolean.FALSE;
		return isGetTemplate && isShowTemplate;
	}

	private List<String> ___getCategoryAuthIds(String modelName,
			String categoryId) throws Exception {
		// 计算有阅读权限的模板Id，分类Id及其分类的上级Id
		HQLInfo hqlInfo = new HQLInfo();
		SysDictModel templateModel = SysDataDict.getInstance().getModel(
				modelName);
		IBaseService baseService = (IBaseService) SpringBeanUtil
				.getBean(templateModel.getServiceBean());
		if (ISysAuthConstant.IS_AREA_ENABLED
				&& ISysAuthConstant.IS_ISOLATION_ENABLED) {
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaCheck,
					SysAuthConstant.AreaCheck.YES);
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaIsolation,
					ISysAuthConstant.ISOLATION_SCENE_CATEGORY);
		}

		String modelTableName = ModelUtil.getModelTableName(modelName);
		hqlInfo.setSelectBlock(modelTableName + ".fdId, " + modelTableName
				+ ".docCategory.fdHierarchyId");

		if (StringUtil.isNotNull(categoryId)) {
			hqlInfo.setWhereBlock(modelTableName
					+ ".docCategory.fdId = :categoryId");
			hqlInfo.setParameter("categoryId", categoryId);
		}

		List<?> results = baseService.findValue(hqlInfo);
		if (results.isEmpty()) {
			return new ArrayList<String>();
		}
		List<String> authIds = new ArrayList<String>();
		for (int i = 0; i < results.size(); i++) {
			Object[] obj = (Object[]) results.get(i);
			String id = obj[0].toString();
			if (StringUtil.isNotNull(id) && !authIds.contains(id)) {
				authIds.add(id);
			}
			String hid = obj[1].toString();
			convertHierarchyId2Ids(hid, authIds);
		}
		return authIds;
	}
	
	private void loadCategoriesByParentId(JSONArray array, String parentId,
			String modelName, Boolean autoFetch, List<String> __authList,
			Boolean isGetTemplate, String href, String mainModelName,
			String fdId) throws Exception {
		List<Object[]> list = findCategoriesByParentId(parentId, modelName);
		for (Object[] row : list) {
			//if (isGetTemplate && !__authList.contains(row[1]))
			//	continue;
			JSONObject obj = new JSONObject();
			obj.put("text", row[0]);
			// 1代表全局分类
			obj.put("value", modelName +"_1_"+ row[1] +"_"+ 
					mainModelName +"_"+ fdId);
			obj.put("nodeType", "CATEGORY");
			obj.put("autoFetch", autoFetch);
			String hrefStr = href.replace("!{parentId}", row[1].toString())
				.replace("!{mainModelName}", mainModelName).replace("!{fdId}", fdId);
			obj.put("href", hrefStr);
			// obj.put("href", "./?categoryId=" + row[1]);
			array.add(obj);
		}

	}
	
	private void convertHierarchyId2Ids(String hierarchyId, List<String> authIds) {
		if (StringUtil.isNotNull(hierarchyId)) {
			String[] ids = hierarchyId
					.split(BaseTreeConstant.HIERARCHY_ID_SPLIT);
			for (int j = 0; j < ids.length; j++) {
				if (StringUtil.isNotNull(ids[j]) && !authIds.contains(ids[j])) {
					authIds.add(ids[j]);
				}
			}
		}
	}
	
	private List<Object[]> findTemplatesByParentId(String parentId,
			IBaseService service, String tableName, SysDictModel templateModel)
			throws Exception {
		HQLInfo info = new HQLInfo();
		info.setSelectBlock(tableName + ".fdName, " + tableName + ".fdId");
		info.setWhereBlock(tableName + ".docCategory.fdId = :id");
		info.setParameter("id", parentId);
		if (templateModel.getPropertyMap().containsKey("fdOrder")) {
			info.setOrderBy(tableName + ".fdOrder, " + tableName + ".fdId");
		} else {
			info.setOrderBy(tableName + ".fdId");
		}
		return (List<Object[]>) service.findValue(info);
	}
	
	private List<Object[]> findCategoriesByParentId(String parentId,
			String modelName) throws Exception {
		HQLInfo info = new HQLInfo();
		info.setSelectBlock("sysCategoryMain.fdName, sysCategoryMain.fdId");
		if (StringUtil.isNotNull(parentId)) {
			info.setWhereBlock("sysCategoryMain.hbmParent.fdId = :id");
			info.setParameter("id", parentId);
		} else {
			info.setWhereBlock("sysCategoryMain.hbmParent.fdId is null");
		}
		info.setWhereBlock(info.getWhereBlock()
				+ " and sysCategoryMain.fdModelName = :modelName");
		info.setParameter("modelName", modelName);
		info.setOrderBy("sysCategoryMain.fdOrder, sysCategoryMain.fdId");
		return (List<Object[]>) sysCategoryMainService.findValue(info);
	}
}
