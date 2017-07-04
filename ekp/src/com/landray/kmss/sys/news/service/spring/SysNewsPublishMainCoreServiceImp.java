package com.landray.kmss.sys.news.service.spring;

import java.util.List;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.BaseCoreOuterServiceImp;
import com.landray.kmss.common.service.ICoreOuterService;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.sys.news.forms.SysNewsPublishMainForm;
import com.landray.kmss.sys.news.interfaces.ISysNewsPublishCategoryModel;
import com.landray.kmss.sys.news.interfaces.ISysNewsPublishMainForm;
import com.landray.kmss.sys.news.interfaces.ISysNewsPublishMainModel;
import com.landray.kmss.sys.news.model.SysNewsPublishCategory;
import com.landray.kmss.sys.news.model.SysNewsPublishMain;
import com.landray.kmss.sys.news.service.ISysNewsMainService;
import com.landray.kmss.sys.news.service.ISysNewsPublishCategoryService;
import com.landray.kmss.sys.news.service.ISysNewsPublishMainService;
import com.landray.kmss.sys.workflow.interfaces.ISysWfMainModel;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 创建日期 2009-八月-02
 * 
 * @author 周超 发布机制类别设置
 */

public class SysNewsPublishMainCoreServiceImp extends BaseCoreOuterServiceImp
		implements ICoreOuterService {
	private ISysNewsPublishMainService sysNewsPublishMainService = null;
	private ISysNewsPublishCategoryService sysNewsPublishCategoryService = null;
	private static final Log logger = LogFactory
			.getLog(SysNewsPublishMainCoreServiceImp.class);

	public void setSysNewsPublishMainService(
			ISysNewsPublishMainService sysNewsPublishMainService) {
		this.sysNewsPublishMainService = sysNewsPublishMainService;
	}

	private ISysNewsMainService sysNewsMainService;

	public void setSysNewsPublishCategoryService(
			ISysNewsPublishCategoryService sysNewsPublishCategoryService) {
		this.sysNewsPublishCategoryService = sysNewsPublishCategoryService;
	}

	public void setSysNewsMainService(ISysNewsMainService sysNewsMainService) {
		this.sysNewsMainService = sysNewsMainService;
	}

	public void initFormSetting(IExtendForm mainForm, String mainKey,
			IBaseModel settingModel, String settingKey,
			RequestContext requestContext) throws Exception {
		if (!(mainForm instanceof ISysNewsPublishMainForm && settingModel instanceof ISysNewsPublishCategoryModel)) {
			return;
		}
		List settingList = sysNewsPublishCategoryService.getCoreModels(
				settingModel, settingKey);
		if (settingList == null || settingList.isEmpty()) {
			if (logger.isDebugEnabled())
				logger.debug("发布设置信息不存在，忽略加载操作");
			return;
		}
		ISysNewsPublishMainForm mainSettingForm = (ISysNewsPublishMainForm) mainForm;
		SysNewsPublishMainForm sysNewsPublishMainForm = mainSettingForm
				.getSysNewsPublishMainForm();
		SysNewsPublishCategory sysNewsPublishCategory = (SysNewsPublishCategory) settingList
				.get(0);
		copyCategoryToMainForm(sysNewsPublishMainForm, sysNewsPublishCategory);
		sysNewsPublishMainForm.setFdKey(mainKey);

	}

	private void copyCategoryToMainForm(
			SysNewsPublishMainForm sysNewsPublishMainForm,
			SysNewsPublishCategory sysNewsPublishCategory) {
		sysNewsPublishMainForm.setFdCategoryId(sysNewsPublishCategory
				.getFdCategoryId());
		sysNewsPublishMainForm.setFdCategoryName(sysNewsPublishCategory
				.getFdCategoryName());
		sysNewsPublishMainForm.setFdImportance(sysNewsPublishCategory
				.getFdImportance().toString());
		sysNewsPublishMainForm.setFdIsAutoPublish(sysNewsPublishCategory
				.getFdIsAutoPublish().toString());
		sysNewsPublishMainForm.setFdIsFlow(sysNewsPublishCategory.getFdIsFlow()
				.toString());
		sysNewsPublishMainForm.setFdIsModifyCate(sysNewsPublishCategory
				.getFdIsModifyCate().toString());
		sysNewsPublishMainForm.setFdIsModifyImpor(sysNewsPublishCategory
				.getFdIsModifyImpor().toString());

	}

	public void convertFormToModel(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
		if (!(form instanceof ISysNewsPublishMainForm && model instanceof ISysNewsPublishMainModel))
			return;
		if (logger.isDebugEnabled())
			logger.debug("将发布机制设置从Form转成Model");
		ISysNewsPublishMainForm mainForm = (ISysNewsPublishMainForm) form;
		ISysNewsPublishMainModel mainModel = (ISysNewsPublishMainModel) model;
		mainModel
				.setSysNewsPublishMain((SysNewsPublishMain) sysNewsPublishMainService
						.convertFormToModel(mainForm
								.getSysNewsPublishMainForm(), mainModel
								.getSysNewsPublishMain(), requestContext));
	}

	public void save(IBaseModel model) throws Exception {
		if (!(model instanceof ISysNewsPublishMainModel))
			return;
		if (logger.isDebugEnabled())
			logger.debug("增加发布机制设置记录");
		ISysNewsPublishMainModel mainModel = (ISysNewsPublishMainModel) model;
		if (mainModel.getSysNewsPublishMain() == null)
			return;
		SysNewsPublishMain sysNewsPublishMain = mainModel
				.getSysNewsPublishMain();
		sysNewsPublishMain.setFdModelId(model.getFdId());
		sysNewsPublishMain.setFdModelName(ModelUtil.getModelClassName(model));
		// sysNewsPublishMain.setAuthArea(mainModel.getAuthArea());
		sysNewsPublishMainService.update(sysNewsPublishMain);// 必须先保存，否则会无法获取发布设置的信息导致无法发布
		String docStatus = (String) PropertyUtils.getProperty(model,
				"docStatus");// 当前的文档状态
		if (!(model instanceof ISysWfMainModel)) {// 如果没有部署流程则判断文档状态
			if (SysDocConstant.DOC_STATUS_PUBLISH.equals(docStatus)) {
				sysNewsPublishMainService.AutoPublish(model); // 自动发布新闻
				sysNewsPublishMain.setDocStatus(docStatus);
				sysNewsPublishMainService.update(sysNewsPublishMain);// 必须再更新状态以便文档再编辑时判断是否已经发布
			}
		}
	}

	public void delete(IBaseModel model) throws Exception {
		if (!(model instanceof ISysNewsPublishMainModel))
			return;
		this.deleteSysNews(model);// 删除新闻记录
		if (logger.isDebugEnabled())
			logger.debug("删除相关的发布信息记录");
		sysNewsPublishMainService.deleteCoreModels(model);
	}

	// 删除新闻
	private void deleteSysNews(IBaseModel model) throws Exception {
		String fdModelName = ModelUtil.getModelClassName(model);
		IBaseModel basemodel = (IBaseModel) model;
		String fdModelId = basemodel.getFdId();// 根据Id获取新闻
		List listRecord = sysNewsMainService.findListPublishRecord(fdModelName,
				fdModelId);
		if (listRecord != null && !listRecord.isEmpty()) {
			for (int i = 0; i < listRecord.size(); i++) {
				IBaseModel modelObj = (IBaseModel) listRecord.get(i);
				this.sysNewsMainService.delete(modelObj);
			}
		}
		if (logger.isDebugEnabled())
			logger.debug("删除新闻记录");
	}

	public void convertModelToForm(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
		if (model instanceof ISysNewsPublishMainModel
				&& form instanceof ISysNewsPublishMainForm) {
			ISysNewsPublishMainForm mainForm = (ISysNewsPublishMainForm) form;
			ISysNewsPublishMainModel mainModel = (ISysNewsPublishMainModel) model;
			List coreModels = sysNewsPublishMainService.getCoreModels(model,
					null);
			if (coreModels == null || coreModels.size() == 0) {
				if (logger.isWarnEnabled())
					logger.warn("无法获取发布信息，忽略发布信息从Model中clone并转成Form的操作");
				return;
			}
			mainModel.setSysNewsPublishMain((SysNewsPublishMain) coreModels
					.get(0));
			if (logger.isDebugEnabled())
				logger.debug("将发布信息从Model转成Form");
			sysNewsPublishMainService.convertModelToForm(mainForm
					.getSysNewsPublishMainForm(), mainModel
					.getSysNewsPublishMain(), requestContext);
			String docStatus = mainModel.getSysNewsPublishMain().getDocStatus();
			Boolean fdIsShow = false;
			if (StringUtil.isNotNull(docStatus)) {// 如果为空在页面有判断也显示，考虑到docStatus是机制后加的，旧数据为空
				fdIsShow = docStatus.charAt(0) >= '3';
				mainForm.getSysNewsPublishMainForm().setFdIsShow(fdIsShow);
			}
		}
	}

	public void cloneModelToForm(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
		if (!(model instanceof ISysNewsPublishMainModel && form instanceof ISysNewsPublishMainForm)) {
			return;
		}
		convertModelToForm(form, model, requestContext);
		SysNewsPublishMainForm sysNewsPublishMainForm = ((ISysNewsPublishMainForm) form)
				.getSysNewsPublishMainForm();
		sysNewsPublishMainForm.setFdId(null);
	}
}