package com.landray.kmss.common.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseTemplateModel;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.StringUtil;

public abstract class BaseTemplateTreeService implements IXMLDataBean {
	protected abstract IBaseService getServiceImp();

	// private static Log logger =
	// LogFactory.getLog(BaseTemplateTreeService.class);

	public List getDataList(RequestContext requestInfo) throws Exception {
		String categoryId = requestInfo.getParameter("categoryId");
		String type = requestInfo.getParameter("getType");
		String authType = requestInfo.getParameter("checkAuth");
		if (StringUtil.isNull(type))
			type = "category";
		if (StringUtil.isNull(authType))
			authType = "";

		IBaseService baseService = getServiceImp();
		String tableName = ModelUtil.getModelTableName(baseService
				.getModelName());
		IBaseTemplateModel template;
		List returnList = new ArrayList();
		if (StringUtil.isNotNull(categoryId)) {
			String whereString = "";
			if ("property".equalsIgnoreCase(type)) {
				whereString = tableName + ".docProperties.fdId='" + categoryId
						+ "'";
			} else {
				whereString = tableName + ".docCategory.fdId='" + categoryId
						+ "'";
			}

			HQLInfo info = new HQLInfo();
			info.setWhereBlock(whereString);
			info.setOrderBy(tableName + ".fdOrder");

			if (authType.equalsIgnoreCase("reader")) {
				// info.setAuthCheckType(SysAuthConstant.AUTH_CHECK_READER);
				info.setCheckParam(SysAuthConstant.CheckType.AuthCheck,
						SysAuthConstant.AuthCheck.SYS_READER);
				info.setCheckParam(SysAuthConstant.CheckType.AreaCheck,
						SysAuthConstant.AreaCheck.YES);
				info.setCheckParam(SysAuthConstant.CheckType.AreaIsolation,
						ISysAuthConstant.ISOLATION_SCENE_CATEGORY);
			} else if (authType.equalsIgnoreCase("editor")) {
				// info.setAuthCheckType(SysAuthConstant.AUTH_CHECK_EDITOR);
				info.setCheckParam(SysAuthConstant.CheckType.AuthCheck,
						SysAuthConstant.AuthCheck.SYS_EDITOR);
				info.setCheckParam(SysAuthConstant.CheckType.AreaCheck,
						SysAuthConstant.AreaCheck.YES);
				info.setCheckParam(SysAuthConstant.CheckType.AreaIsolation,
						SysAuthConstant.AreaIsolation.CHILD);
			} else {
				info.setCheckParam(SysAuthConstant.CheckType.AuthCheck,
						SysAuthConstant.AuthCheck.SYS_NONE);
				info.setCheckParam(SysAuthConstant.CheckType.AreaCheck,
						SysAuthConstant.AreaCheck.NO);
			}
			// info.setAuthCheckType(SysAuthConstant.AUTH_CHECK_NONE);

			List list = baseService.findList(info);
			for (int i = 0; i < list.size(); i++) {
				template = (IBaseTemplateModel) list.get(i);
				Map node = new HashMap();
				node.put("value", template.getFdId());
				node.put("text", template.getFdName());
				node.put("nodeType", "TEMPLATE");
				node.put("isAutoFetch", "0");
				returnList.add(node);
			}
		}
		return returnList;
	}

}
