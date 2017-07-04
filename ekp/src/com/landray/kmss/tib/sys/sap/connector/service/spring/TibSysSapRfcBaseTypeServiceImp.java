package com.landray.kmss.tib.sys.sap.connector.service.spring;

import java.util.List;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcBaseTypeService;

public class TibSysSapRfcBaseTypeServiceImp extends BaseServiceImp implements ITibSysSapRfcBaseTypeService{

	
	public Boolean checkIsUse(String funcId, String paramName) throws Exception {
		// TODO 自动生成的方法存根
		
		HQLInfo hqlInfo=new HQLInfo();
		hqlInfo.setSelectBlock(" fdParameterUse ");
		hqlInfo.setWhereBlock("fdFunction.fdId=:fdId and fdParameterName=:fdParameterName");
		
		hqlInfo.setParameter("fdId", funcId);
		hqlInfo.setParameter("fdParameterName", paramName) ;
		
		List<?> result= findValue(hqlInfo);
		
		if(result.isEmpty()){
			return false;
		}
		Boolean fdUse = (Boolean)result.get(0);
		// TODO 自动生成的方法存根
		return fdUse;
		
	}

	public String getFdRfcParamXml(String funcId, String paramName)
			throws Exception {
		HQLInfo hqlInfo=new HQLInfo();
		
		hqlInfo.setSelectBlock(" fdRfcParamXml ");
		hqlInfo.setWhereBlock("fdFunction.fdId=:fdId and fdParameterName=:fdParameterName");
		hqlInfo.setParameter("fdId", funcId);
		hqlInfo.setParameter("fdParameterName", paramName);
		// TODO 自动生成的方法存根
		List<?> result = findValue(hqlInfo);
		if(!result.isEmpty()){
			
			
			return (String)result.get(0);
		}
		return null;
	}
	
	public Object findFirstValue(HQLInfo hqlInfo) throws Exception {
		// TODO 自动生成的方法存根
		List<?> result =findValue(hqlInfo);
		
		if(!result.isEmpty()){
			return result.get(0);
		}
		
		return null;
	}

	
}
