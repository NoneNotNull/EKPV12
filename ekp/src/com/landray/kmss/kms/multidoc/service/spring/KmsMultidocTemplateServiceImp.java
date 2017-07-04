package com.landray.kmss.kms.multidoc.service.spring;

import java.util.Date;
import java.util.List;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.model.KmsMultidocSnContext;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocGenerateSnService;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocTemplateService;
import com.landray.kmss.sys.simplecategory.service.SysSimpleCategoryServiceImp;
import com.landray.kmss.sys.transport.service.ISysTransportImport;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * 创建日期 2007-Sep-18
 * 
 * @author 模板设置业务接口实现
 */
public class KmsMultidocTemplateServiceImp extends SysSimpleCategoryServiceImp
		implements ISysTransportImport, IKmsMultidocTemplateService {

	private IKmsMultidocGenerateSnService kmsMultidocGenerateSnService;

	public void setKmsMultidocGenerateSnService(
			IKmsMultidocGenerateSnService kmsMultidocGenerateSnService) {
		this.kmsMultidocGenerateSnService = kmsMultidocGenerateSnService;
	}

	public List<?> findLevelOneTemplate() throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("kmsMultidocTemplate.hbmParent is null");
		hqlInfo.setOrderBy("kmsMultidocTemplate.fdOrder");
		return this.findList(hqlInfo);
	}

	@Override
	public String add(IBaseModel modelObj) throws Exception {
		KmsMultidocTemplate kmsMultidocTemplate = (KmsMultidocTemplate) modelObj;
		KmsMultidocSnContext context = new KmsMultidocSnContext();
		context.setFdPrefix(kmsMultidocTemplate.getFdNumberPrefix());
		context.setFdModelName(KmsMultidocKnowledge.class.getName());
		context.setFdTemplate(modelObj);
		kmsMultidocGenerateSnService.initalizeSerialNumber(context);
		return super.add(modelObj);
	}

	@Override
	public void update(IBaseModel modelObj) throws Exception {
		KmsMultidocTemplate kmsMultidocTemplate = (KmsMultidocTemplate) modelObj;
		KmsMultidocSnContext context = new KmsMultidocSnContext();
		context.setFdPrefix(kmsMultidocTemplate.getFdNumberPrefix());
		context.setFdModelName(KmsMultidocKnowledge.class.getName());
		context.setFdTemplate(modelObj);
		kmsMultidocGenerateSnService.initalizeSerialNumber(context);
		super.update(modelObj);
	}

	public List<KmsMultidocTemplate> findChildren(String templateId)
			throws Exception {
		if (StringUtil.isNotNull(templateId)) {
			HQLInfo hqlInfo = new HQLInfo();
			// hqlInfo.setSelectBlock("kmsMultidocTemplate.fdId");
			hqlInfo
					.setWhereBlock("kmsMultidocTemplate.hbmParent.fdId = :templateId");
			hqlInfo.setParameter("templateId", templateId);
			List<KmsMultidocTemplate> results = findList(hqlInfo);

			return results;
		} else
			return null;
	}

	public boolean checkTemplateName(String templateId, String templateName,
			String parentId) throws Exception {
		if (StringUtil.isNotNull(templateId)
				&& StringUtil.isNotNull(templateName)) {
			String wherepid = "";
			if (StringUtil.isNotNull(parentId)) {
				wherepid = "and kmsMultidocTemplate.hbmParent.fdId ='"
						+ parentId + "'";
			} else {
				wherepid = "and kmsMultidocTemplate.hbmParent.fdId is null";
			}

			String sql = "kmsMultidocTemplate.fdId <> :templateId  and kmsMultidocTemplate.fdName= :templateName "
					+ wherepid;
			HQLInfo hqlInfo = new HQLInfo();
			// hqlInfo.setSelectBlock("kmsMultidocTemplate.fdId");
			hqlInfo.setWhereBlock(sql);
			hqlInfo.setParameter("templateId", templateId);
			hqlInfo.setParameter("templateName", templateName);
			List<KmsMultidocTemplate> results = findList(hqlInfo);

			if (results.isEmpty())
				return false;
			else
				return true;
		}
		return true;
	}

	public List<KmsMultidocTemplate> findChildrenAll(
			KmsMultidocTemplate template) throws Exception {
		if (template != null) {
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setWhereBlock("kmsMultidocTemplate.fdId !='"
					+ template.getFdId()
					+ "' and kmsMultidocTemplate.fdHierarchyId like '"
					+ template.getFdHierarchyId() + "%' ");
			List<KmsMultidocTemplate> results = findList(hqlInfo);
			return results;
		} else
			return null;
	}

	public void addImport(IBaseModel modelObj) throws Exception {

		KmsMultidocTemplate template = (KmsMultidocTemplate) modelObj;
		if (template.getDocExpire() == null)
			template.setDocExpire(0L);
		// if (template.getSysWfTemplateModels() == null)
		// template.setSysWfTemplateModels(findDefaultWf(template.getFdId()));//
		// 默认流程
		if (template.getDocAlteror() == null)
			template.setDocAlteror(UserUtil.getUser());
		template.setDocAlterTime(new Date());
		template.setFdIsinheritMaintainer(true);
		template.setFdIsinheritUser(true);
		template.setAuthTmpAttNocopy(false);
		template.setAuthTmpAttNodownload(false);
		template.setAuthTmpAttNoprint(false);

		add(template);
	}

	public void updateImport(IBaseModel modelObj) throws Exception {
		super.update(modelObj);
	}

	@SuppressWarnings("unchecked")
	public List findList(HQLInfo hqlInfo) throws Exception {
		if (hqlInfo.getCheckParam(SysAuthConstant.CheckType.AllCheck) == null
				&& !SysAuthConstant.AreaCheck.NO.equals(hqlInfo
						.getCheckParam(SysAuthConstant.CheckType.AreaCheck))) {
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaCheck,
					SysAuthConstant.AreaCheck.YES);
		}
		return super.findList(hqlInfo);
	}
}
