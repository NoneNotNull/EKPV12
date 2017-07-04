/**
 * 
 */
package com.landray.kmss.tib.common.inoutdata.service.spring;

import com.landray.kmss.common.dao.IBaseDao;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.tib.common.inoutdata.service.ITibCommonInoutdataInterceptor;

/**
 * @author 邱建华
 * @version 1.0 2013-1-7
 */
public class TibCommonInoutdataInterceptorImp implements ITibCommonInoutdataInterceptor {

	public IBaseModel beforeSave(IBaseDao baseDao, IBaseModel baseModel) {
		return baseModel;
	}

	public IBaseModel beforeUpdate(IBaseDao baseDao, IBaseModel baseModel) {
		return baseModel;
	}

}
