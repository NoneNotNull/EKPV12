package com.landray.kmss.tib.sys.sap.connector.service;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;

public interface ITibSysSapRfcBaseTypeService extends IBaseService{

	public Boolean checkIsUse(String funcId,String paramName) throws Exception;
	
	public String getFdRfcParamXml(String funcId,String paramName) throws Exception;
	
	public Object findFirstValue(HQLInfo hqlInfo) throws Exception ;
	
}
