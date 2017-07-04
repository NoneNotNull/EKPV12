package com.landray.kmss.kms.multidoc.webservice;

import javax.jws.WebService;

import com.landray.kmss.sys.webservice2.interfaces.ISysWebservice;
@WebService
public interface  IKmsMultidocWebserviceService extends ISysWebservice{
	
	/**
	 * 测试的
	 * @param username
	 * @param point
	 */
	
	public void sayHello(String username, int point);
	/**
	 * 启动流程
	 * @param username
	 * @param point
	 */
	public String addMultidoc(KmsMultidocParamterForm webForm) throws Exception ;
}
