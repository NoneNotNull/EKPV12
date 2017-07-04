package com.landray.kmss.km.review.service.spring;

import com.landray.kmss.common.service.BaseTemplateTreeService;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.km.review.service.IKmReviewTemplateService;

public class KmReviewTemplateTreeService extends BaseTemplateTreeService {

	private IKmReviewTemplateService kmReviewTemplateService;
		
	public void setKmReviewTemplateService(
			IKmReviewTemplateService kmReviewTemplateService) {
		this.kmReviewTemplateService = kmReviewTemplateService;
	}

	protected IBaseService getServiceImp() {
		return kmReviewTemplateService;
	}
}
