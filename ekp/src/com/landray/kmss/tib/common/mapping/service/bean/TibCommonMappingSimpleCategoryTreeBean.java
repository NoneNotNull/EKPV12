/**
 * 
 */
package com.landray.kmss.tib.common.mapping.service.bean;

import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.authorization.interfaces.SysAuthAreaUtils;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * @author qiujh
 * @version 1.0 2014-1-7
 */
public class TibCommonMappingSimpleCategoryTreeBean {
	
	public JSONArray treeView(String modelName, String parentId, 
			String currId, String __currId, String expandStr, String href,
			String mainModelName, String fdId,
			HttpServletRequest request) throws Exception {
		
		boolean expand = StringUtil.isNotNull(parentId)
				&& "true".equals(expandStr);
		SysDictModel dict = SysDataDict.getInstance().getModel(modelName);
		IBaseService service = (IBaseService) SpringBeanUtil.getBean(dict
				.getServiceBean());
		String tableName = ModelUtil.getModelTableName(modelName);

		JSONArray array = new JSONArray();

		if (StringUtil.isNull(parentId) && StringUtil.isNotNull(currId)) {
			parentId = currId;
		}

		if (StringUtil.isNull(parentId) && StringUtil.isNotNull(__currId)) {
			Object[] category = findOne(service, tableName, __currId,
					request);
			parentId = (String) category[3];
		}

		loadCategoriesByParentId(array, service, parentId, modelName,
				tableName, Boolean.TRUE, href, mainModelName, fdId, request);

		if (expand) {
			for (Iterator<?> it = array.iterator(); it.hasNext();) {
				JSONObject cate = (JSONObject) it.next();
				String cateId = cate.getString("value");
				JSONArray children = new JSONArray();
				loadCategoriesByParentId(children, service, cateId, modelName, 
						tableName, Boolean.FALSE, href, mainModelName, fdId, request);
				cate.put("children", children);
			}
		}
		return array;
	}
	
	private Object[] findOne(IBaseService service, String tableName,
			String categoryId, HttpServletRequest request) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock(tableName + ".fdName, " + tableName + ".fdId, "
				+ tableName + ".fdHierarchyId, " + tableName
				+ ".hbmParent.fdId");
		hqlInfo.setWhereBlock(tableName + ".fdId=:categoryId");
		hqlInfo.setParameter("categoryId", categoryId);
		this.buildValue(request, hqlInfo, tableName);
		return (Object[]) service.findValue(hqlInfo).get(0);
	}
	
	private void buildValue(HttpServletRequest request, HQLInfo hqlInfo,
			String tableName) {
		String prefix = "qq.";
		Enumeration enume = request.getParameterNames();
		String whereBlock = hqlInfo.getWhereBlock();
		while (enume.hasMoreElements()) {
			String name = (String) enume.nextElement();
			if (name != null && name.trim().startsWith(prefix)) {
				String value = request.getParameter(name);
				if (StringUtil.isNotNull(value)) {
					name = name.trim().substring(prefix.length());
					String[] ___val = value.split("[;；,，]");

					String ___block = "";
					for (int i = 0; i < ___val.length; i++) {
						String param = "kmss_ext_props_"
								+ HQLUtil.getFieldIndex();
						___block = StringUtil.linkString(___block, " or ",
								tableName + "." + name + " =:" + param);
						hqlInfo.setParameter(param, ___val[i]);
					}
					whereBlock += " and (" + ___block + ")";
				}
			}
		}
		hqlInfo.setWhereBlock(whereBlock);
	}
	
	private void loadCategoriesByParentId(JSONArray array,
			IBaseService service, String categoryId, String modelName,
			String tableName, Boolean autoFetch, String href, 
			String mainModelName, String fdId, HttpServletRequest request)
			throws Exception {
		List<Object[]> list = (List<Object[]>) findAll(service, categoryId,
				modelName, tableName, request);
		for (Object[] cate : list) {
			JSONObject row = new JSONObject();
			row.put("text", cate[0]);
			// 0代表简单分类
			row.put("value", modelName +"_0_"+ cate[1] +"_"+ 
					mainModelName +"_"+ fdId);
			row.put("autoFetch", autoFetch);
			String hrefStr = href.replace("!{parentId}", cate[1].toString())
				.replace("!{text}", cate[0].toString())
				.replace("!{mainModelName}", mainModelName).replace("!{fdId}", fdId);
			row.put("href", hrefStr);
			// row.put("href", "./?categoryId=" + cate[1]);
			array.add(row);
		}
	}
	
	private List<?> findAll(IBaseService service, String categoryId,
			String modelName, String tableName, HttpServletRequest request)
			throws Exception {
		HQLInfo hqlInfo = new HQLInfo();

		if (ISysAuthConstant.IS_AREA_ENABLED
				&& ISysAuthConstant.IS_ISOLATION_ENABLED) {
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaCheck,
					SysAuthConstant.AreaCheck.YES);
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaIsolation,
					SysAuthConstant.AreaIsolation.BRANCH);
		}
		StringBuilder selectBlock = new StringBuilder().append(tableName)
				.append(".fdName, ").append(tableName).append(".fdId");

		if (SysAuthAreaUtils.isAreaEnabled(modelName)) {
			selectBlock.append(", ").append(tableName).append(".").append(
					ISysAuthConstant.AREA_FIELD_NAME).append(".").append(
					"fdHierarchyId");
		}
		hqlInfo.setSelectBlock(selectBlock.toString());
		if (StringUtil.isNull(categoryId)) {
			hqlInfo.setWhereBlock(tableName + ".hbmParent is null");
		} else {
			hqlInfo.setWhereBlock(tableName + ".hbmParent.fdId=:categoryId");
			hqlInfo.setParameter("categoryId", categoryId);
		}
		hqlInfo.setOrderBy(tableName + ".fdOrder, " + tableName + ".fdId");
		this.buildValue(request, hqlInfo, tableName);
		return service.findValue(hqlInfo);
	}
}
