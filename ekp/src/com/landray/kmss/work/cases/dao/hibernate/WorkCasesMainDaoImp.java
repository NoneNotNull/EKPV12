package com.landray.kmss.work.cases.dao.hibernate;

import java.util.Date;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.metadata.interfaces.ExtendDataDaoImp;
import com.landray.kmss.util.UserUtil;
import com.landray.kmss.work.cases.dao.IWorkCasesMainDao;
import com.landray.kmss.work.cases.model.WorkCasesMain;

/**
 * 文档类数据访问接口实现
 */
public class WorkCasesMainDaoImp extends ExtendDataDaoImp implements IWorkCasesMainDao {
	public String add(IBaseModel modelObj) throws Exception {
		WorkCasesMain createInfoModel = (WorkCasesMain) modelObj;
		if (createInfoModel.getDocCreator() == null) {
			// 创建者
			createInfoModel.setDocCreator(UserUtil.getUser());
		}
		if (createInfoModel.getDocCreateTime() == null) {
			// 创建时间
			createInfoModel.setDocCreateTime(new Date());
		}
		return super.add(modelObj);
	}
}
