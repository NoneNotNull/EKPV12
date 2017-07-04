package com.landray.kmss.km.review.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.organization.service.ISysOrgElementService;

public class KmReviewDepartmentTreeService implements IXMLDataBean {

	private ISysOrgElementService sysOrgElementService;

	public List getDataList(RequestContext requestInfo) throws Exception {
		List orgElementList = sysOrgElementService.findList(null, null);
		List returnList = new ArrayList();
		for (int i = 0; i < orgElementList.size(); i++) {
			SysOrgElement element = (SysOrgElement) orgElementList.get(i);
			Map node = new HashMap();
			if (null != element.getFdParent()) {
				node.put("value", element.getFdParent().getFdId());
				node.put("text", element.getFdParent().getFdName());
				returnList.add(node);
			}
		}
		return returnList;
	}

	public void setSysOrgElementService(
			ISysOrgElementService sysOrgElementService) {
		this.sysOrgElementService = sysOrgElementService;
	}

}
