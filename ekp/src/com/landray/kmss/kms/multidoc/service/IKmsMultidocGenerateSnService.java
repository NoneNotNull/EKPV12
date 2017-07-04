package com.landray.kmss.kms.multidoc.service;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.kms.multidoc.model.KmsMultidocSnContext;

public interface IKmsMultidocGenerateSnService extends IBaseService {

	/**
	 * 
	 * 生成流水号
	 * 
	 * @param context
	 * 
	 * @return String
	 */
	public abstract String getSerialNumber(KmsMultidocSnContext context)
			throws Exception;

	/**
	 * 
	 * 初始化流水号
	 * 
	 * @param context
	 * 
	 * @return String
	 */
	public abstract void initalizeSerialNumber(KmsMultidocSnContext context)
			throws Exception;

}
