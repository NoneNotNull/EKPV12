package com.landray.kmss.km.review.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.km.review.service.IKmReviewDocKeywordService;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌
 */
public class KmReviewDocKeywordAction extends ExtendAction

{
	protected IKmReviewDocKeywordService kmReviewDocKeywordService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmReviewDocKeywordService == null)
			kmReviewDocKeywordService = (IKmReviewDocKeywordService) getBean("kmReviewDocKeywordService");
		return kmReviewDocKeywordService;
	}
}
