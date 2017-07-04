package com.landray.kmss.common.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.util.SpringBeanUtil;

/**
 * 当主域模型做了一定的改动时，由该类通知所有“已注册”的机制响应动作
 * 
 * @author 叶中奇
 * @version 1.0
 */
@SuppressWarnings("unchecked")
public class DispatchCoreServiceImp implements IDispatchCoreService,
		ApplicationContextAware, ApplicationListener {
	private static final Log logger = LogFactory
			.getLog(DispatchCoreServiceImp.class);

	private List mechanismServices;

	private ThreadLocal allServices = new ThreadLocal();

	public void add(IBaseModel model) throws Exception {
		if (logger.isDebugEnabled())
			logger.debug("执行机制分发add");
		List serviceList = getServiceList();
		for (int i = 0; i < serviceList.size(); i++) {
			IBaseCoreOuterService service = (IBaseCoreOuterService) serviceList
					.get(i);
			service.add(model);
		}
	}

	public void cloneModelToForm(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
		if (logger.isDebugEnabled())
			logger.debug("执行机制分发cloneModelToForm");
		List serviceList = getServiceList();
		for (int i = 0; i < serviceList.size(); i++) {
			IBaseCoreOuterService service = (IBaseCoreOuterService) serviceList
					.get(i);
			service.cloneModelToForm(form, model, requestContext);
		}
	}

	public void convertFormToModel(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
		if (logger.isDebugEnabled())
			logger.debug("执行机制分发convertFormToModel");
		List serviceList = getServiceList();
		for (int i = 0; i < serviceList.size(); i++) {
			IBaseCoreOuterService service = (IBaseCoreOuterService) serviceList
					.get(i);
			service.convertFormToModel(form, model, requestContext);
		}
	}

	public void convertModelToForm(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
		if (logger.isDebugEnabled())
			logger.debug("执行机制分发convertModelToForm");
		List serviceList = getServiceList();
		for (int i = 0; i < serviceList.size(); i++) {
			IBaseCoreOuterService service = (IBaseCoreOuterService) serviceList
					.get(i);
			service.convertModelToForm(form, model, requestContext);
		}
	}

	public void delete(IBaseModel model) throws Exception {
		if (logger.isDebugEnabled())
			logger.debug("执行机制分发delete");
		List serviceList = getServiceList();
		for (int i = 0; i < serviceList.size(); i++) {
			IBaseCoreOuterService service = (IBaseCoreOuterService) serviceList
					.get(i);
			service.delete(model);
		}
	}

	private List getServiceList() {
		if (mechanismServices != null) {
			// spring启动完成才会调用机制的service
			List serviceList = (List) allServices.get();
			if (serviceList == null) {
				serviceList = new ArrayList();
				serviceList.addAll(mechanismServices);
				allServices.set(serviceList);
			}
			return serviceList;
		}
		return new ArrayList();
	}

	public void initFormSetting(IExtendForm mainForm, String mainKey,
			IBaseModel settingModel, String settingKey,
			RequestContext requestContext) throws Exception {
		if (logger.isDebugEnabled())
			logger.debug("执行机制分发initFormSetting");
		List serviceList = getServiceList();
		for (int i = 0; i < serviceList.size(); i++) {
			IBaseCoreOuterService service = (IBaseCoreOuterService) serviceList
					.get(i);
			service.initFormSetting(mainForm, mainKey, settingModel,
					settingKey, requestContext);
		}
	}

	public void initModelSetting(IBaseModel mainModel, String mainKey,
			IBaseModel settingModel, String settingKey) throws Exception {
		if (logger.isDebugEnabled())
			logger.debug("执行机制分发initModelSetting");
		List serviceList = getServiceList();
		for (int i = 0; i < serviceList.size(); i++) {
			IBaseCoreOuterService service = (IBaseCoreOuterService) serviceList
					.get(i);
			service.initModelSetting(mainModel, mainKey, settingModel,
					settingKey);
		}
	}

	public void setApplicationContext(ApplicationContext applicationContext)
			throws BeansException {
		SpringBeanUtil.setApplicationContext(applicationContext);
	}

	public void update(IBaseModel model) throws Exception {
		if (logger.isDebugEnabled())
			logger.debug("执行机制分发update");
		List serviceList = getServiceList();
		for (int i = 0; i < serviceList.size(); i++) {
			IBaseCoreOuterService service = (IBaseCoreOuterService) serviceList
					.get(i);
			service.update(model);
		}
	}

	public void addService(IAdditionalService service) {
		List serviceList = getServiceList();
		if (!serviceList.contains(service))
			serviceList.add(service);
	}

	public void removeService(IAdditionalService service) {
		getServiceList().remove(service);
	}

	public void resetService() {
		allServices.remove();
	}

	public List<?> exportData(String id, String modelName) throws Exception {
		if (logger.isDebugEnabled())
			logger.debug("执行机制分发exportToFile");
		List<Object> rtn = new ArrayList<Object>();
		List<?> serviceList = getServiceList();
		for (int i = 0; i < serviceList.size(); i++) {
			IBaseCoreOuterService service = (IBaseCoreOuterService) serviceList
					.get(i);
			List<?> datas = service.exportData(id, modelName);
			if (datas != null && !datas.isEmpty()) {
				rtn.addAll(datas);
			}
		}
		return rtn;
	}

	public Class<?> getSourceClass() {
		return getClass();
	}

	public void onApplicationEvent(ApplicationEvent event) {
		if (event == null || !(event instanceof ContextRefreshedEvent)) {
			return;
		}
		mechanismServices = SpringBeanUtil.getBeansForType(
				ICoreOuterService.class, "dispatchCoreService");
	}
}
