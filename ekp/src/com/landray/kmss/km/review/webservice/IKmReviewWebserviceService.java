package com.landray.kmss.km.review.webservice;

import javax.jws.WebService;

import com.landray.kmss.sys.webservice2.interfaces.ISysWebservice;

@WebService
public interface IKmReviewWebserviceService extends ISysWebservice {

	/**
	 * 启动流程
	 */
	public String addReview(KmReviewParamterForm webForm) throws Exception;

}
