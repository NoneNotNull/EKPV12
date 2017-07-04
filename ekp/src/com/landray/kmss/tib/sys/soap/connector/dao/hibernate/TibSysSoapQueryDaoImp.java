package com.landray.kmss.tib.sys.soap.connector.dao.hibernate;

import java.util.Date;

import com.landray.kmss.common.dao.BaseDaoImp;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.tib.sys.soap.connector.dao.ITibSysSoapQueryDao;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapQuery;
import com.landray.kmss.util.UserUtil;


/**
 * 函数查询数据访问接口实现
 * 
 * @author 
 * @version 1.0 2012-08-28
 */
public class TibSysSoapQueryDaoImp extends BaseDaoImp implements ITibSysSoapQueryDao {

	@Override
	public String add(IBaseModel modelObj) throws Exception {
		TibSysSoapQuery TibSysSoapQuery = (TibSysSoapQuery) modelObj;
		if (TibSysSoapQuery.getDocCreateTime() == null) {
			TibSysSoapQuery.setDocCreateTime(new Date());
		}
		if (TibSysSoapQuery.getDocCreator() == null) {
			TibSysSoapQuery.setDocCreator(UserUtil.getUser());
		}
		return super.add(modelObj);
	}
	
}
