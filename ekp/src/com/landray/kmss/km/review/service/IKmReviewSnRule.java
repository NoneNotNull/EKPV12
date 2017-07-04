package com.landray.kmss.km.review.service;

import com.landray.kmss.km.review.model.KmReviewSnContext;

/**
 * 流水号生成规则接口
 * 
 * @author:李明辉 2010年11月4日
 * 
 */

public interface IKmReviewSnRule {
	/**
	 * 根据入参生成流水号
	 * 
	 * @param kmReviewSnContext
	 *            上下文，用于传递查询流水号的参数及返回信息
	 * @return String;
	 * @throws RuntimeException
	 */
	public abstract String createSerialNumber(
			KmReviewSnContext kmReviewSnContext) throws Exception;

}
