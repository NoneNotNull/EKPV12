package com.landray.kmss.kms.multidoc.webservice.category.service;

import java.util.List;

import javax.jws.WebService;

import com.landray.kmss.kms.common.webservice.exception.KmsFaultException;
import com.landray.kmss.kms.common.webservice.form.category.CategoryEntity;
import com.landray.kmss.kms.common.webservice.form.category.KmsSearchCategoryRequest;
import com.landray.kmss.sys.webservice2.interfaces.ISysWebservice;

@WebService
public interface IKmsMultidocSearchCategoryWSService extends ISysWebservice {
	/**
	 * 查询类别，返回list
	 * 
	 * @param parentId
	 * @return List<CategoryEntry>
	 */
	public List<CategoryEntity> searchCategoryList(KmsSearchCategoryRequest request)
			throws KmsFaultException;

}
