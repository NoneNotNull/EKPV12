package com.landray.kmss.tib.sys.soap.connector.dao.hibernate;

import java.util.Date;

import com.landray.kmss.common.dao.BaseDaoImp;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.tib.sys.soap.connector.dao.ITibSysSoapSettingDao;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.util.UserUtil;


/**
 * WEBSERVICE服务配置数据访问接口实现
 * 
 * @author 
 * @version 1.0 2012-08-06
 */
public class TibSysSoapSettingDaoImp extends BaseDaoImp implements ITibSysSoapSettingDao {
	@Override
	public String add(IBaseModel modelObj) throws Exception {
		// 增加创建人和创建时间
		TibSysSoapSetting docModel = (TibSysSoapSetting)modelObj;
		if (docModel.getDocCreator() == null) {
			docModel.setDocCreator(UserUtil.getUser());
		}
		if (docModel.getDocCreateTime() == null) {
			docModel.setDocCreateTime(new Date());
		}
		return super.add(modelObj);
	}

	@Override
	public void update(IBaseModel modelObj) throws Exception {
		TibSysSoapSetting docModel = (TibSysSoapSetting)modelObj;
		docModel.setDocAlterTime(new Date());
		super.update(modelObj);
	}
	
}
