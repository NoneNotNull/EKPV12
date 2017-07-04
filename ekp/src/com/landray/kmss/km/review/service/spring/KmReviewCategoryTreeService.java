package com.landray.kmss.km.review.service.spring;



import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.sys.category.model.SysCategoryMain;
import com.landray.kmss.sys.category.service.ISysCategoryMainService;

public class KmReviewCategoryTreeService implements IXMLDataBean {

	private ISysCategoryMainService categoryMainService;
	
	public List getDataList(RequestContext requestInfo) throws Exception {
		List categoryList = categoryMainService.findList(null, null);
		List returnList = new ArrayList();
		for (int i = 0; i < categoryList.size(); i++) {
			SysCategoryMain category = (SysCategoryMain) categoryList.get(i);
			Map node = new HashMap();
			node.put("value", category.getFdId());
			node.put("text", category.getFdName());
			returnList.add(node);
			
		}
		return returnList;
	}

	public void setCategoryMainService(ISysCategoryMainService categoryMainService) {
		this.categoryMainService = categoryMainService;
	}


		
	
}
