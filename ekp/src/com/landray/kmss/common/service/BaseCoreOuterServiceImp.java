package com.landray.kmss.common.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.BaseCoreInnerModel;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.util.ObjectUtil;

public class BaseCoreOuterServiceImp implements ICoreOuterService {
	private static final Log logger = LogFactory
			.getLog(BaseCoreOuterServiceImp.class);

	public void add(IBaseModel model) throws Exception {
		save(model);
	}

	public void cloneModelToForm(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
	}

	protected void convertFormMapToModelList(Map formMap, List modelList,
			RequestContext requestContext, IBaseCoreInnerService service)
			throws Exception {
		Iterator keys = formMap.keySet().iterator();
		List oldList = new ArrayList();
		oldList.addAll(modelList);
		modelList.clear();
		while (keys.hasNext()) {
			String key = (String) keys.next();
			IExtendForm form = (IExtendForm) formMap.get(key);
			BaseCoreInnerModel model = null;
			for (int i = 0; i < oldList.size(); i++) {
				model = (BaseCoreInnerModel) oldList.get(i);
				if (ObjectUtil.equals(model.getFdKey(), key))
					break;
				model = null;
			}
			if (model == null) {
				model = (BaseCoreInnerModel) form.getModelClass().newInstance();
				model.setFdKey(key);
			} else {
				oldList.remove(model);
			}
			if (logger.isDebugEnabled())
				logger.debug("转换：" + model.getClass() + "(" + model.getFdKey()
						+ ")");
			modelList.add(service.convertFormToModel(form, model,
					requestContext));
		}
		for (int i = 0; i < oldList.size(); i++) {
			BaseCoreInnerModel model = (BaseCoreInnerModel) oldList.get(i);
			if (logger.isDebugEnabled())
				logger.debug("删除：" + model.getClass() + "(" + model.getFdKey()
						+ ")");
			service.delete(model);
		}
	}

	public void convertFormToModel(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
	}

	protected void convertModelListToFormMap(Map formMap, List modelList,
			RequestContext requestContext, IBaseCoreInnerService service)
			throws Exception {
		for (int i = 0; i < modelList.size(); i++) {
			BaseCoreInnerModel model = (BaseCoreInnerModel) modelList.get(i);
			formMap.put(model.getFdKey(), service.convertModelToForm(null,
					model, requestContext));
		}
	}

	public void convertModelToForm(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
	}

	public void delete(IBaseModel model) throws Exception {
	}

	public void initFormSetting(IExtendForm mainForm, String mainKey,
			IBaseModel settingModel, String settingKey,
			RequestContext requestContext) throws Exception {
	}

	public void initModelSetting(IBaseModel mainModel, String mainKey,
			IBaseModel settingModel, String settingKey) throws Exception {
	}

	protected void save(IBaseModel model) throws Exception {
	}

	public void update(IBaseModel model) throws Exception {
		save(model);
	}

	public List<?> exportData(String id, String modelName) throws Exception {
		return Collections.EMPTY_LIST;
	}

	public Class<?> getSourceClass() {
		return getClass();
	}
}
