package com.landray.kmss.kms.multidoc.service;

import com.landray.kmss.kms.multidoc.model.KmsMultidocSnContext;

public interface IKmsMultidocSnRule {
	/**
	 * 根据入参生成流水号
	 * 
	 * @param kmReviewSnContext
	 *            上下文，用于传递查询流水号的参数及返回信息
	 * @return String;
	 * @throws RuntimeException
	 */
	public abstract String createSerialNumber(KmsMultidocSnContext kmReviewSnContext)
			throws Exception;

}
