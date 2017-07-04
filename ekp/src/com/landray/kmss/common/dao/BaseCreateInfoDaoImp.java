package com.landray.kmss.common.dao;

import java.util.Date;

import com.landray.kmss.common.model.IBaseCreateInfoModel;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.util.UserUtil;

public class BaseCreateInfoDaoImp extends BaseDaoImp {
	public String add(IBaseModel modelObj) throws Exception {
		IBaseCreateInfoModel createInfoModel = (IBaseCreateInfoModel) modelObj;
		if (createInfoModel.getDocCreateTime() == null)
			createInfoModel.setDocCreateTime(new Date());
		if (createInfoModel.getDocCreator() == null)
			createInfoModel.setDocCreator(UserUtil.getUser());

		return super.add(modelObj);
	}

}
