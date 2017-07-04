package com.landray.kmss.common.service;

import java.util.List;

import com.landray.kmss.common.dao.IBaseCoreDao;
import com.landray.kmss.common.model.BaseCoreInnerModel;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.SpringBeanUtil;

/**
 * 机制类Service的基类
 * 
 * @author 叶中奇
 */
public class BaseCoreInnerServiceImp extends BaseServiceImp implements
		IBaseCoreInnerService {
	public List getCoreModels(IBaseModel mainModel, String key)
			throws Exception {
		return ((IBaseCoreDao) getBaseDao()).getCoreModels(mainModel, key);
	}

	public void deleteCoreModels(IBaseModel mainModel) throws Exception {
		((IBaseCoreDao) getBaseDao()).deleteCoreModels(mainModel);
	}

	public IBaseModel getMainModel(BaseCoreInnerModel coreModel)
			throws Exception {
		return findByPrimaryKey(coreModel.getFdModelId(), coreModel
				.getFdModelName(), true);
	}

	public IBaseModel getMainModel(BaseCoreInnerModel coreModel, boolean noLazy)
			throws Exception {
		return findByPrimaryKey(coreModel.getFdModelId(), coreModel
				.getFdModelName(), noLazy);
	}

	public void saveMainModel(IBaseModel mainModel) throws Exception {
		String modelName = ModelUtil.getModelClassName(mainModel);
		String serviceName = SysDataDict.getInstance().getModel(modelName)
				.getServiceBean();
		IBaseService service = (IBaseService) SpringBeanUtil
				.getBean(serviceName);
		service.getBaseDao().update(mainModel);
		// mainModel.recalculateFields();
		// getBaseDao().getHibernateSession().saveOrUpdate(mainModel);
	}
}
