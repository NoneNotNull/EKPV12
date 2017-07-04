package com.landray.kmss.km.review.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;

import com.landray.kmss.km.review.service.IKmReviewSnService;


/**
 * 主文档 Action
 * 
 * @author 
 * @version 1.0 2010-11-04
 */
public class KmReviewSnAction extends ExtendAction {
	protected IKmReviewSnService kmReviewSnService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(kmReviewSnService == null)
			kmReviewSnService = (IKmReviewSnService)getBean("kmReviewSnService");
		return kmReviewSnService;
	}
}

