package com.landray.kmss.work.cases.service.spring;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.sys.simplecategory.service.SysSimpleCategoryServiceImp;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.work.cases.service.IWorkCasesCategoryService;
/**
 * 分类信息业务接口实现
 */
public class WorkCasesCategoryServiceImp extends SysSimpleCategoryServiceImp implements IWorkCasesCategoryService,IXMLDataBean {

	@Override
	public List<Map<String, String>> getDataList(RequestContext requestInfo)
			throws Exception {
		String parentId = requestInfo.getParameter("parentId");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo
				.setSelectBlock("workCasesCategory.fdName, workCasesCategory.fdId");
		if (StringUtil.isNull(parentId)) {
			hqlInfo.setWhereBlock("workCasesCategory.hbmParent is null");
		} else {
			hqlInfo
					.setWhereBlock("workCasesCategory.hbmParent.fdId=:parentId");
			hqlInfo.setParameter("parentId", parentId);
		}
		List<?> result = findList(hqlInfo);
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		for (int i = 0; i < result.size(); i++) {
			Object[] obj = (Object[]) result.get(i);
			Map<String, String> node = new HashMap<String, String>();
			node.put("text", obj[0].toString());
			node.put("value", obj[1].toString());
			rtnList.add(node);
		}
		return rtnList;
	}


}
