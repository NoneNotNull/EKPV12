package com.landray.kmss.common.dao;

import java.util.List;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.util.ModelUtil;

/**
 * 机制类Dao代码的基类<br>
 * 使用范围：机制类的Dao代码，作为继承调用。
 * 
 * @author 叶中奇
 * @version 1.0 2006-6-16
 */
public abstract class BaseCoreInnerDaoImp extends BaseDaoImp implements
		IBaseCoreDao {
	public List getCoreModels(IBaseModel mainModel, String key)
			throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		String tableName = ModelUtil.getModelTableName(getModelName());
		String whereBlock = tableName + ".fdModelName=:fdModelName and "
				+ tableName + ".fdModelId=:fdModelId";
		hqlInfo.setParameter("fdModelName", ModelUtil
				.getModelClassName(mainModel));
		hqlInfo.setParameter("fdModelId", mainModel.getFdId());
		if (key != null) {
			whereBlock += " and " + tableName + ".fdKey=:fdKey";
			hqlInfo.setParameter("fdKey", key);
		}
		hqlInfo.setWhereBlock(whereBlock);
		return findList(hqlInfo);
	}

	public void deleteCoreModels(IBaseModel mainModel) throws Exception {
		List coreModels = getCoreModels(mainModel, null);
		for (int i = coreModels.size() - 1; i >= 0; i--)
			delete((IBaseModel) coreModels.get(i));
	}
}
