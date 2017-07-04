package com.landray.kmss.tib.sys.sap.connector.service.spring;

import java.util.List;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcTableService;

/**
 * 表参数配置业务接口实现
 * 
 * @author 
 * @version 1.0 2011-10-25
 */
public class TibSysSapRfcTableServiceImp extends TibSysSapRfcBaseTypeServiceImp implements ITibSysSapRfcTableService {

	
	
		@Override
		public Boolean checkIsUse(String funcId, String paramName) throws Exception {
			
			HQLInfo hqlInfo=new HQLInfo();
			hqlInfo.setSelectBlock(" fdUse ");
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
}
