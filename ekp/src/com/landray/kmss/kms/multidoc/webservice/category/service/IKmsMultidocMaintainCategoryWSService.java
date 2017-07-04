package com.landray.kmss.kms.multidoc.webservice.category.service;

import javax.jws.WebService;

import com.landray.kmss.kms.common.webservice.exception.KmsFaultException;
import com.landray.kmss.kms.common.webservice.form.category.KmsMaintainCategoryResponse;
import com.landray.kmss.kms.multidoc.webservice.category.form.KmsMultidocMaintainCategoryRequest;
import com.landray.kmss.sys.webservice2.interfaces.ISysWebservice;

@WebService
public interface IKmsMultidocMaintainCategoryWSService extends ISysWebservice {

	/**
	 * 新增类别
	 * 
	 * @param requests
	 * @return KmsMaintainCategoryResponse
	 * @throws KmsFaultException
	 */
	public KmsMaintainCategoryResponse addCategories(
			KmsMultidocMaintainCategoryRequest... requests) throws KmsFaultException;

	/**
	 * 更新类别
	 * 
	 * @param request
	 * @return String
	 * @throws KmsFaultException
	 */
	public String updateCategory(KmsMultidocMaintainCategoryRequest request)
			throws KmsFaultException;

	/**
	 * 删除类别
	 * 
	 * @param request
	 * @return
	 * @throws KmsFaultException
	 */
	public String delCategory(KmsMultidocMaintainCategoryRequest request)
			throws KmsFaultException;

}
