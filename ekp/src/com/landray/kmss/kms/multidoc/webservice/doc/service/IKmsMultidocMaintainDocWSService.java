package com.landray.kmss.kms.multidoc.webservice.doc.service;

import javax.jws.WebService;

import com.landray.kmss.kms.common.webservice.exception.KmsFaultException;
import com.landray.kmss.kms.common.webservice.form.KmsAuthRequest;
import com.landray.kmss.kms.common.webservice.form.doc.KmsMaintianDocResponse;
import com.landray.kmss.kms.multidoc.webservice.doc.form.KmsMaintainMultidocDocRequest;
import com.landray.kmss.sys.webservice2.interfaces.ISysWebservice;

@WebService
public interface IKmsMultidocMaintainDocWSService extends ISysWebservice {
	/**
	 * 新增多维库文档，并返回fdId
	 * 
	 * @param request
	 * @return String
	 * @throws KmsFaultException
	 */
	public KmsMaintianDocResponse addDoc(KmsMaintainMultidocDocRequest request)
			throws KmsFaultException;

	/**
	 * 更新多维库文档,并返回状态(successful or failure)
	 * 
	 * @param request
	 * @return String
	 * @throws KmsFaultException
	 */
	public KmsMaintianDocResponse updateDoc(
			KmsMaintainMultidocDocRequest request) throws KmsFaultException;

	/**
	 * 删除多维库的文档,并返回状态(successful or failure)
	 * 
	 * @param KmsAuthRequest
	 * @param userId
	 * @return String
	 * @throws KmsFaultException
	 */
	public String delDoc(KmsAuthRequest request) throws KmsFaultException;

}
