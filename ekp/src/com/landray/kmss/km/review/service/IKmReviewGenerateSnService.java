package com.landray.kmss.km.review.service;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.km.review.model.KmReviewSnContext;

/**
 * 
 * @author 李明辉 2010年11月4日
 * 
 *         生成流水号
 * 
 */
public interface IKmReviewGenerateSnService extends IBaseService {

	/**
	 * 
	 * 生成流水号
	 * 
	 * @param context
	 * 
	 * @return String
	 */
	public abstract String getSerialNumber(KmReviewSnContext context)
			throws Exception;

	public abstract void initalizeSerialNumber(KmReviewSnContext context)
			throws Exception;

}
