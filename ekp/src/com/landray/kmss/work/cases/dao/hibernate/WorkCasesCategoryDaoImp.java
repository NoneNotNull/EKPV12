package com.landray.kmss.work.cases.dao.hibernate;

import java.util.Date;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.simplecategory.dao.hibernate.SysSimpleCategoryDaoImp;
import com.landray.kmss.util.UserUtil;
import com.landray.kmss.work.cases.dao.IWorkCasesCategoryDao;
import com.landray.kmss.work.cases.model.WorkCasesCategory;

/**
 * 分类信息数据访问接口实现
 */
public class WorkCasesCategoryDaoImp extends SysSimpleCategoryDaoImp implements IWorkCasesCategoryDao {
	public String add(IBaseModel modelObj) throws Exception {
		WorkCasesCategory workCasesCategory = (WorkCasesCategory) modelObj;
		if (workCasesCategory.getDocCreator() == null) {
			// 创建者
			workCasesCategory.setDocCreator(UserUtil.getUser());
		}
		if (workCasesCategory.getDocCreateTime() == null) {
			// 创建时间
			workCasesCategory.setDocCreateTime(new Date());
		}
		return super.add(modelObj);
	}
}
