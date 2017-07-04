package com.landray.kmss.common.service;

import java.beans.PropertyDescriptor;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.convertor.ConvertorContext;
import com.landray.kmss.common.convertor.FormConvertor_Common;
import com.landray.kmss.common.convertor.IFormToModelConvertor;
import com.landray.kmss.common.convertor.IModelToFormConvertor;
import com.landray.kmss.common.convertor.ModelConvertor_Common;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.dao.IBaseDao;
import com.landray.kmss.common.exception.FormModelConvertException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;

/**
 * 直接调用了IBaseDao的接口实现了常用的CRUD以及查询等方法。<br>
 * 对于简单的业务，继承该类可以完成大部分功能，但对于复杂的业务逻辑，建议覆盖大部分该类的方法，或者不继承该类。<br>
 * 注意：要继承该类，必须<br>
 * <li>对应的model继承类{@link com.landray.kmss.common.model.IBaseModel IBaseModel}；</li>
 * 
 * @author 叶中奇
 * @version 1.0 2006-04-02
 */
public class BaseServiceImp implements IBaseService {
	private static final Log logger = LogFactory.getLog(BaseServiceImp.class);

	private IBaseDao baseDao;

	protected ICoreOuterService dispatchCoreService = null;

	public String add(IBaseModel modelObj) throws Exception {
		String rtnVal = getBaseDao().add(modelObj);
		if (dispatchCoreService != null)
			dispatchCoreService.add(modelObj);
		return rtnVal;
	}

	public String add(IExtendForm form, RequestContext requestContext)
			throws Exception {
		IBaseModel model = convertFormToModel(form, null, requestContext);
		return add(model);
	}

	public IExtendForm cloneModelToForm(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
		ConvertorContext context = new ConvertorContext();
		context.setBaseService(this);
		context.setObjMap(new HashMap());
		context.setRequestContext(requestContext);
		context.setIsClone(true);
		return convertModelToForm(form, model, context);
	}

	protected IBaseModel convertBizFormToModel(IExtendForm form,
			IBaseModel model, ConvertorContext context) throws Exception {
		String sPropertyName = null;
		try {
			if (form == null)
				return null;
			TimeCounter.logCurrentTime("service-convertFormToModel", true, form
					.getClass());
			Map objMap = context.getObjMap();
			if (objMap.containsKey(form))
				return (IBaseModel) objMap.get(form);
			// 获取主域模型
			if (model == null) {
				boolean formIdNotNull = StringUtil.isNotNull(form.getFdId());
				if (formIdNotNull) {
					model = findByPrimaryKey(form.getFdId(), form
							.getModelClass(), true);
				}
				if (model == null) {
					if (logger.isDebugEnabled())
						logger.debug("构建新的" + form.getModelClass().getName()
								+ "域模型");
					model = (IBaseModel) form.getModelClass().newInstance();
					if (formIdNotNull) {
						model.setFdId(form.getFdId());
					}
				}
			}
			form.setFdId(model.getFdId());
			ConvertorContext convertorContext = new ConvertorContext(context);
			convertorContext.setSObject(form);
			convertorContext.setTObject(model);

			// 建立域模型与Form模型的映射
			objMap.put(form, model);
			// 获取Form到域模型的映射
			Map propertyMap = form.getToModelPropertyMap().getPropertyMap();
			List propertyList = form.getToModelPropertyMap().getPropertyList();
			// 遍历Form模型的所有属性，转换无映射的属性
			PropertyDescriptor[] sProperties = PropertyUtils
					.getPropertyDescriptors(form);
			for (int i = 0; i < sProperties.length; i++) {
				sPropertyName = sProperties[i].getName();
				if (propertyMap.containsKey(sPropertyName)) {
					continue;
				} else {
					try {
						if (!PropertyUtils.isReadable(form, sPropertyName)
								|| !PropertyUtils.isWriteable(model,
										sPropertyName))
							continue;
					} catch (Exception e) {
						continue;
					}
				}
				IFormToModelConvertor convertor = new FormConvertor_Common(
						sPropertyName);
				convertorContext.setSPropertyName(sPropertyName);
				convertor.excute(convertorContext);
				if (logger.isDebugEnabled())
					logger.debug("成功执行" + form.getClass().getName() + "中Form."
							+ sPropertyName + "->Model."
							+ convertor.getTPropertyName() + "的"
							+ convertor.getClass().getName() + "转换");
			}
			// 转换有映射的属性
			for (int i = 0; i < propertyList.size(); i++) {
				sPropertyName = (String) propertyList.get(i);
				Object propertyInfo = propertyMap.get(sPropertyName);
				if (propertyInfo == null)
					continue;
				IFormToModelConvertor convertor;
				if (propertyInfo instanceof IFormToModelConvertor)
					convertor = (IFormToModelConvertor) propertyInfo;
				else
					convertor = new FormConvertor_Common((String) propertyInfo);
				convertorContext.setSPropertyName(sPropertyName);
				convertor.excute(convertorContext);
				if (logger.isDebugEnabled())
					logger.debug("成功执行" + form.getClass().getName() + "中Form."
							+ sPropertyName + "->Model."
							+ convertor.getTPropertyName() + "的"
							+ convertor.getClass().getName() + "转换");
			}
			TimeCounter.logCurrentTime("service-convertFormToModel", false,
					form.getClass());
		} catch (Exception e) {
			logger.error("转换Form属性：" + sPropertyName + "时发生错误", e);
			if (sPropertyName == null)
				throw new FormModelConvertException(e);
			else
				throw new FormModelConvertException(sPropertyName, e);
		}
		return model;
	}

	public final IBaseModel convertFormToModel(IExtendForm form,
			IBaseModel model, ConvertorContext context) throws Exception {
		model = convertBizFormToModel(form, model, context);
		if (dispatchCoreService != null)
			dispatchCoreService.convertFormToModel(form, model, context
					.getRequestContext());
		return model;
	}

	public IBaseModel convertFormToModel(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
		ConvertorContext context = new ConvertorContext();
		context.setBaseService(this);
		context.setObjMap(new HashMap());
		context.setRequestContext(requestContext);
		return convertFormToModel(form, model, context);
	}

	protected IExtendForm convertBizModelToForm(IExtendForm form,
			IBaseModel model, ConvertorContext context) throws Exception {
		String sPropertyName = null;
		try {
			if (model == null)
				return null;
			TimeCounter.logCurrentTime("service-convertModelToForm", true,
					model.getClass());
			Map objMap = context.getObjMap();
			if (objMap.containsKey(model))
				return (IExtendForm) objMap.get(model);
			// 构造新的Form模型
			if (form == null)
				form = (IExtendForm) model.getFormClass().newInstance();
			objMap.put(model, form);
			ConvertorContext convertorContext = new ConvertorContext(context);
			convertorContext.setSObject(model);
			convertorContext.setTObject(form);
			// 获取属性映射表
			Map propertyMap = model.getToFormPropertyMap().getPropertyMap();
			List propertyList = model.getToFormPropertyMap().getPropertyList();
			// 遍历域模型的所有属性，转换无映射的属性
			PropertyDescriptor[] sProperties = PropertyUtils
					.getPropertyDescriptors(model);
			for (int i = 0; i < sProperties.length; i++) {
				sPropertyName = sProperties[i].getName();
				if (propertyMap.containsKey(sPropertyName)) {
					continue;
				} else {
					try {
						if (!PropertyUtils.isReadable(model, sPropertyName)
								|| !PropertyUtils.isWriteable(form,
										sPropertyName))
							continue;
					} catch (Exception e) {
						continue;
					}
				}
				IModelToFormConvertor convertor = new ModelConvertor_Common(
						sPropertyName);
				convertorContext.setSPropertyName(sPropertyName);
				convertor.excute(convertorContext);
				if (logger.isDebugEnabled())
					logger.debug("成功执行" + model.getClass().getName()
							+ "中Model." + sPropertyName + "->Form."
							+ convertor.getTPropertyName() + "的"
							+ convertor.getClass().getName() + "转换");
			}
			// 转换有映射的属性
			for (int i = 0; i < propertyList.size(); i++) {
				sPropertyName = (String) propertyList.get(i);
				IModelToFormConvertor convertor;
				Object propertyInfo = propertyMap.get(sPropertyName);
				if (propertyInfo == null)
					continue;
				if (propertyInfo instanceof IModelToFormConvertor)
					convertor = (IModelToFormConvertor) propertyInfo;
				else
					convertor = new ModelConvertor_Common((String) propertyInfo);
				convertorContext.setSPropertyName(sPropertyName);
				convertor.excute(convertorContext);
				if (logger.isDebugEnabled())
					logger.debug("成功执行" + model.getClass().getName()
							+ "中Model." + sPropertyName + "->Form."
							+ convertor.getTPropertyName() + "的"
							+ convertor.getClass().getName() + "转换");
			}
			TimeCounter.logCurrentTime("service-convertModelToForm", false,
					model.getClass());
		} catch (Exception e) {
			logger.error("转换Model属性：" + sPropertyName + "时发生错误", e);
			if (sPropertyName == null)
				throw new FormModelConvertException(e);
			else
				throw new FormModelConvertException(sPropertyName, e);
		}
		return form;
	}

	public final IExtendForm convertModelToForm(IExtendForm form,
			IBaseModel model, ConvertorContext context) throws Exception {
		form = convertBizModelToForm(form, model, context);
		if (dispatchCoreService != null) {
			if (context.getIsClone()) {
				form.setFdId(IDGenerator.generateID());
				dispatchCoreService.cloneModelToForm(form, model, context
						.getRequestContext());
			} else
				dispatchCoreService.convertModelToForm(form, model, context
						.getRequestContext());
		}
		return form;
	}

	public IExtendForm convertModelToForm(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
		ConvertorContext context = new ConvertorContext();
		context.setBaseService(this);
		context.setObjMap(new HashMap());
		context.setRequestContext(requestContext);
		return convertModelToForm(form, model, context);
	}

	public void delete(IBaseModel modelObj) throws Exception {
		if (dispatchCoreService != null)
			dispatchCoreService.delete(modelObj);
		getBaseDao().delete(modelObj);
	}

	public final void delete(String id) throws Exception {
		delete(findByPrimaryKey(id));
	}

	public final void delete(String[] ids) throws Exception {
		for (int i = 0; i < ids.length; i++) {
			if (i > 0)
				flushHibernateSession();
			delete(ids[i]);
		}
	}

	public void flushHibernateSession() {
		getBaseDao().flushHibernateSession();
	}

	public IBaseModel findByPrimaryKey(String id) throws Exception {
		return getBaseDao().findByPrimaryKey(id);
	}

	public IBaseModel findByPrimaryKey(String id, Object modelInfo,
			boolean noLazy) throws Exception {
		return getBaseDao().findByPrimaryKey(id, modelInfo, noLazy);
	}

	public List findByPrimaryKeys(String[] ids) throws Exception {
		return getBaseDao().findByPrimaryKeys(ids);
	}

	public List findList(HQLInfo hqlInfo) throws Exception {
		return getBaseDao().findList(hqlInfo);
	}

	public List findList(String whereBlock, String orderBy) throws Exception {
		return getBaseDao().findList(whereBlock, orderBy);
	}

	public Page findPage(HQLInfo hqlInfo) throws Exception {
		return getBaseDao().findPage(hqlInfo);
	}

	public Page findPage(String whereBlock, String orderBy, int pageno,
			int rowsize) throws Exception {
		return getBaseDao().findPage(whereBlock, orderBy, pageno, rowsize);
	}

	public List findValue(HQLInfo hqlInfo) throws Exception {
		return getBaseDao().findValue(hqlInfo);
	}

	public List findValue(String selectBlock, String whereBlock, String orderBy)
			throws Exception {
		return getBaseDao().findValue(selectBlock, whereBlock, orderBy);
	}

	public IBaseDao getBaseDao() {
		return baseDao;
	}

	public String getModelName() {
		return getBaseDao().getModelName();
	}

	public void setBaseDao(IBaseDao baseDao) {
		this.baseDao = baseDao;
	}

	public final void setDispatchCoreService(ICoreOuterService coreService) {
		this.dispatchCoreService = coreService;
	}

	public void update(IBaseModel modelObj) throws Exception {
		getBaseDao().update(modelObj);
		if (dispatchCoreService != null)
			dispatchCoreService.update(modelObj);
	}

	public void update(IExtendForm form, RequestContext requestContext)
			throws Exception {
		IBaseModel model = convertFormToModel(form, null, requestContext);
		update(model);
	}

	public void clearHibernateSession() {
		getBaseDao().clearHibernateSession();
	}
}
