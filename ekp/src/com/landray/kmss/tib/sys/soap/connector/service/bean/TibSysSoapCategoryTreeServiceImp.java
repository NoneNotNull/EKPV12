package com.landray.kmss.tib.sys.soap.connector.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapCategory;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapCategoryService;
import com.landray.kmss.util.StringUtil;

/**
 * 获取分类树形结构
 * @author zhangtian
 * date :2012-8-6 上午08:04:01
 */
public class TibSysSoapCategoryTreeServiceImp  implements IXMLDataBean {

	private ITibSysSoapCategoryService tibSysSoapCategoryService;
	
	public List getDataList(RequestContext requestInfo) throws Exception {
		String parentId = requestInfo.getParameter("parentId");
		String flag = requestInfo.getParameter("flag");
		HQLInfo hqlInfo = new HQLInfo();

		if (StringUtil.isNull(parentId)) {
			hqlInfo.setWhereBlock("tibSysSoapCategory.hbmParent is null");

		} else {
			hqlInfo.setWhereBlock("tibSysSoapCategory.hbmParent.fdId=:parentId");
			hqlInfo.setParameter("parentId", parentId);
		}
		if (StringUtil.isNotNull(hqlInfo.getWhereBlock())) {
			List result = tibSysSoapCategoryService.findList(hqlInfo);

			List rtnValue = new ArrayList();
			for (int i = 0; i < result.size(); i++) {
				TibSysSoapCategory tibSysSoapCategory = (TibSysSoapCategory) result.get(i);
				Map node = new HashMap();
				node.put("text", tibSysSoapCategory.getFdName());
				node.put("value", tibSysSoapCategory.getFdId());
				rtnValue.add(node);
			}
			return rtnValue;
		} else {
			return null;
		}
	}

	public ITibSysSoapCategoryService getTibSysSoapCategoryService() {
		return tibSysSoapCategoryService;
	}

	public void setTibSysSoapCategoryService(
			ITibSysSoapCategoryService tibSysSoapCategoryService) {
		this.tibSysSoapCategoryService = tibSysSoapCategoryService;
	}

	
	
	
}
