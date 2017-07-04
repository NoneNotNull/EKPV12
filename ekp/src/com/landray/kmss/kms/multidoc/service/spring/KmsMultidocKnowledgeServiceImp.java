package com.landray.kmss.kms.multidoc.service.spring;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.hibernate.FlushMode;
import org.hibernate.Query;
import org.springframework.context.ApplicationListener;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLCombiner;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.dao.HQLWrapper;
import com.landray.kmss.common.exception.KmssRuntimeException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.constant.SysOrgConstant;
import com.landray.kmss.kms.common.constant.KmsCommonOperateConstant;
import com.landray.kmss.kms.common.constant.KmsDocConstant;
import com.landray.kmss.kms.common.service.IKmsCommonRecycleLogService;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseService;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.kms.multidoc.dao.IKmsMultidocKnowledgeDao;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.model.KmsMultidocSnContext;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocGenerateSnService;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.kms.multidoc.util.Constants;
import com.landray.kmss.sys.attachment.service.ISysAttMainCoreInnerService;
import com.landray.kmss.sys.authentication.background.IBackgroundAuthService;
import com.landray.kmss.sys.category.service.ISysCategoryPropertyService;
import com.landray.kmss.sys.edition.interfaces.ISysEditionMainModel;
import com.landray.kmss.sys.metadata.model.ExtendDataModelInfo;
import com.landray.kmss.sys.organization.interfaces.SysOrgHQLUtil;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.sys.organization.service.ISysOrgPersonService;
import com.landray.kmss.sys.property.model.SysPropertyTemplate;
import com.landray.kmss.sys.property.util.SysPropertySetUtil;
import com.landray.kmss.sys.property.util.SysPropertyUtil;
import com.landray.kmss.sys.quartz.interfaces.SysQuartzJobContext;
import com.landray.kmss.sys.right.interfaces.BaseAuthTmpModel;
import com.landray.kmss.sys.simplecategory.service.ICateChgExtend;
import com.landray.kmss.sys.tag.model.SysTagMain;
import com.landray.kmss.sys.tag.model.SysTagMainRelation;
import com.landray.kmss.sys.tag.model.SysTagTags;
import com.landray.kmss.sys.tag.service.ISysTagMainRelationService;
import com.landray.kmss.sys.tag.service.ISysTagMainService;
import com.landray.kmss.sys.tag.service.ISysTagTagsService;
import com.landray.kmss.sys.transport.service.ISysTransportImport;
import com.landray.kmss.sys.workflow.engine.WorkflowEngineContext;
import com.landray.kmss.sys.workflow.interfaces.ISysWfProcessSubService;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.Runner;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * 创建日期 2011-九月-04
 * 
 * @author 知识库文档业务接口实现
 */
public class KmsMultidocKnowledgeServiceImp extends KmsMultidocBaseInfoService
		implements IKmsKnowledgeBaseService, ISysTransportImport,
		ICateChgExtend, IKmsMultidocKnowledgeService, ApplicationListener {

	// private IKmsMultidocTemplateService kmsMultidocTemplateService;
	private IKmsKnowledgeCategoryService kmsKnowledgeCategoryService;
	private ISysCategoryPropertyService sysCategoryPropertyService;
	private IKmsMultidocGenerateSnService kmsMultidocGenerateSnService = null;
	private ISysWfProcessSubService sysWfProcessSubService;
	public IBackgroundAuthService backgroundAuthService;
	private ISysTagMainService sysTagMainService;
	private ISysTagTagsService sysTagTagsService;
	private ISysAttMainCoreInnerService sysAttMainService;
	private ISysTagMainRelationService sysTagMainRelationService;
	private ISysOrgPersonService sysOrgPersonService;

	private IKmsCommonRecycleLogService kmsCommonRecycleLogService;

	public void setKmsCommonRecycleLogService(
			IKmsCommonRecycleLogService kmsCommonRecycleLogService) {
		this.kmsCommonRecycleLogService = kmsCommonRecycleLogService;
	}

	public IKmsKnowledgeCategoryService getKmsKnowledgeCategoryService() {
		return kmsKnowledgeCategoryService;
	}

	public void setKmsKnowledgeCategoryService(
			IKmsKnowledgeCategoryService kmsKnowledgeCategoryService) {
		this.kmsKnowledgeCategoryService = kmsKnowledgeCategoryService;
	}

	public void setSysTagMainRelationService(
			ISysTagMainRelationService sysTagMainRelationService) {
		this.sysTagMainRelationService = sysTagMainRelationService;
	}

	public void setSysAttMainService(
			ISysAttMainCoreInnerService sysAttMainService) {
		this.sysAttMainService = sysAttMainService;
	}

	public void setBackgroundAuthService(
			IBackgroundAuthService backgroundAuthService) {
		this.backgroundAuthService = backgroundAuthService;
	}

	public void setSysOrgPersonService(ISysOrgPersonService sysOrgPersonService) {
		this.sysOrgPersonService = sysOrgPersonService;
	}

	public void setSysWfProcessSubService(
			ISysWfProcessSubService sysWfProcessSubService) {
		this.sysWfProcessSubService = sysWfProcessSubService;
	}

	public void setKmsMultidocGenerateSnService(
			IKmsMultidocGenerateSnService kmsMultidocGenerateSnService) {
		this.kmsMultidocGenerateSnService = kmsMultidocGenerateSnService;
	}

	public void setSysTagTagsService(ISysTagTagsService sysTagTagsService) {
		this.sysTagTagsService = sysTagTagsService;
	}

	public void setSysTagMainService(ISysTagMainService sysTagMainService) {
		this.sysTagMainService = sysTagMainService;
	}

	public ISysCategoryPropertyService getSysCategoryPropertyService() {
		return sysCategoryPropertyService;
	}

	public void setSysCategoryPropertyService(
			ISysCategoryPropertyService sysCategoryPropertyService) {
		this.sysCategoryPropertyService = sysCategoryPropertyService;
	}

	/**
	 * 加入集团分级标识
	 */
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

	public KmsKnowledgeCategory getKnowledgeCategory(String categoryId)
			throws Exception {
		KmsKnowledgeCategory knowledgeCategory = (KmsKnowledgeCategory) getKmsKnowledgeCategoryService()
				.findByPrimaryKey(categoryId);
		return knowledgeCategory;
	}

	public int updateDucmentTemplate(String ids, String templateId)
			throws Exception {
		return ((IKmsMultidocKnowledgeDao) this.getBaseDao())
				.updateDocumentTemplate(ids, templateId);
	}

	public void updateDocExpire(SysQuartzJobContext context) throws Exception {
		List<?> list = findList("docStatus="
				+ SysDocConstant.DOC_STATUS_PUBLISH + " and docExpire <> 0",
				"docPublishTime");
		for (int i = 0; i < list.size(); i++) {
			Calendar cal1 = Calendar.getInstance();
			Calendar cal2 = Calendar.getInstance();
			KmsMultidocKnowledge kmsMultidocKnowledge = ((KmsMultidocKnowledge) list
					.get(i));
			Long expiredays = kmsMultidocKnowledge.getDocExpire();
			Date publishday = kmsMultidocKnowledge.getDocPublishTime();
			cal1.setTime(publishday);
			cal1.add(Calendar.YEAR, expiredays.intValue());
			cal2.setTime(new Date());
			if (cal1.getTime().compareTo(cal2.getTime()) < 0) {
				kmsMultidocKnowledge
						.setDocStatus(SysDocConstant.DOC_STATUS_EXPIRE);
				update(kmsMultidocKnowledge);
			}
			context.logMessage("主题为：" + kmsMultidocKnowledge.getDocSubject()
					+ "的文档已过期");
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	protected IBaseModel initBizModelSetting(RequestContext request)
			throws Exception {
		String templateId = request.getParameter("fdTemplateId");
		if (StringUtil.isNull(templateId)) {
			return null;
		}
		KmsKnowledgeCategory docCategory = getKnowledgeCategory(templateId);
		KmsMultidocKnowledge model = new KmsMultidocKnowledge();
		model.setDocCategory(docCategory);
		model.setDocCreator(UserUtil.getUser());
		model.setDocCreateTime(new Date());
		model.setDocDept(UserUtil.getUser().getFdParent());
		model.setDocExpire(docCategory.getDocExpire() != null ? docCategory
				.getDocExpire() : Long.valueOf(Constants.DEF_EXPIRE));
		model.setDocPosts(new ArrayList(docCategory.getDocPosts()));
		model.setExtendFilePath(SysPropertyUtil.getExtendFilePath(docCategory));
		return model;
	}

	@Override
	protected void initCoreServiceFormSetting(IExtendForm form,
			IBaseModel model, RequestContext requestContext) throws Exception {
		KmsMultidocKnowledge mainModel = (KmsMultidocKnowledge) model;
		dispatchCoreService.initFormSetting(form, "mainDoc", mainModel
				.getDocCategory(), "mainDoc", requestContext);
	}

	public String add(IBaseModel modelObj) throws Exception {
		// 生成文件编号
		KmsMultidocKnowledge mainModel = (KmsMultidocKnowledge) modelObj;
		KmsKnowledgeCategory category = mainModel.getDocCategory();
		if (!SysDocConstant.DOC_STATUS_DRAFT.equals(mainModel.getDocStatus())
				&& StringUtil.isNotNull(category.getFdNumberPrefix())) {
			KmsMultidocSnContext context = new KmsMultidocSnContext();
			context.setFdPrefix(category.getFdNumberPrefix());
			context.setFdModelName(ModelUtil.getModelClassName(mainModel));
			context.setFdTemplate(category);
			String fdNumber = kmsMultidocGenerateSnService
					.getSerialNumber(context);
			mainModel.setFdNumber(fdNumber);
		}
		if (mainModel.getDocCreateTime() == null)
			mainModel.setDocCreateTime(new Date());
		if (mainModel.getDocCreator() == null)
			mainModel.setDocCreator(UserUtil.getUser());
		// Map<String, Object> map =
		// mainModel.getExtendDataModelInfo().getModelData();
		// updateCheckboxValue(map);
		mainModel.getExtendDataModelInfo().saveModelData();
		return super.add(mainModel);
	}

	public void addDocByImportExcel(KmsMultidocKnowledge modelObj)
			throws Exception {

		// IBaseModel model = convertFormToModel(form, null, requestContext);
		// sysMetadataService.convertModelToForm(form, model,
		// context.getRequestContext());

		KmsMultidocKnowledge mainModel = modelObj;
		if (!SysDocConstant.DOC_STATUS_DRAFT.equals(mainModel.getDocStatus())
				&& StringUtil.isNotNull(mainModel.getDocCategory()
						.getFdNumberPrefix())) {
			KmsMultidocSnContext context = new KmsMultidocSnContext();
			context.setFdPrefix(mainModel.getDocCategory().getFdNumberPrefix());
			context.setFdModelName(ModelUtil.getModelClassName(mainModel));
			context.setFdTemplate(mainModel.getDocCategory());
			String fdNumber = "";
			fdNumber = this.kmsMultidocGenerateSnService
					.getSerialNumber(context);
			mainModel.setFdNumber(fdNumber);
		}
		mainModel.setDocStatus(SysDocConstant.DOC_STATUS_PUBLISH);
		recalculateEditorField(mainModel, mainModel.getDocCategory());
		setAuthorDefault(mainModel);
		addAutoPublish(modelObj);
	}

	@Override
	public void update(IBaseModel modelObj) throws Exception {
		KmsMultidocKnowledge mainModel = (KmsMultidocKnowledge) modelObj;
		if (!SysDocConstant.DOC_STATUS_DRAFT.equals(mainModel.getDocStatus())
				&& StringUtil.isNull(mainModel.getFdNumber())) {
			KmsMultidocSnContext context = new KmsMultidocSnContext();
			KmsKnowledgeCategory template = mainModel.getDocCategory();
			context.setFdPrefix(template.getFdNumberPrefix());
			context.setFdModelName(ModelUtil.getModelClassName(mainModel));
			context.setFdTemplate(template);
			String fdNumber = kmsMultidocGenerateSnService
					.getSerialNumber(context);
			mainModel.setFdNumber(fdNumber);
		}
		// updateCheckboxValue(mainModel.getExtendDataModelInfo().getModelData());
		setAuthorDefault(mainModel);
		super.update(mainModel);
	}

	public void updateChgCate(String docIds, String templateId,
			RequestContext requestInfo) throws Exception {
		String[] ids = docIds.split("\\s*[;,]\\s*");
		List<?> docs = this.findByPrimaryKeys(ids);
		for (int i = 0; i < docs.size(); i++) {
			KmsMultidocKnowledge mainModel = (KmsMultidocKnowledge) docs.get(i);
			// 去掉原有的扩展属性
			Map<String, Object> map = mainModel.getExtendDataModelInfo()
					.getModelData();
			mainModel.setExtendDataXML(null);
			// 删除原有扩展属性
			this.deleteExtendData(mainModel);
			mainModel.setDocCategory(this.getKnowledgeCategory(templateId));
			// 更新设置扩展属性
			mainModel.setExtendFilePath(SysPropertyUtil
					.getExtendFilePath(mainModel.getDocCategory()));
			mainModel
					.setExtendDataModelInfo(new ExtendDataModelInfo(mainModel));
			sysMetadataService.initModelSetting(requestInfo, mainModel);
			mainModel.getExtendDataModelInfo().getModelData();
			setPropertyValue(map, mainModel);
			this.update(mainModel);
		}
	}

	/**
	 * 如果作者为空，设置当前用户为作者
	 * 
	 * @param model
	 */
	private void setAuthorDefault(KmsMultidocKnowledge model) {
		if (StringUtil.isNull(model.getOuterAuthor())) {
			if (model.getDocAuthor() == null) {
				SysOrgPerson u = UserUtil.getUser();
				model.setDocAuthor(u);
			} else {
				if (StringUtil.isNull(model.getDocAuthor().getFdId())) {
					SysOrgPerson u = UserUtil.getUser();
					model.setDocAuthor(u);
				}
			}
		}

		if (model.getDocCreator() == null) {
			model.setDocCreator(UserUtil.getUser());
		}

	}

	/**
	 * 更新sys_relation_static表
	 * 
	 * @throws Exception
	 */
	public void updateRelationStatic(String fdId, String url) throws Exception {
		// sys_relation_static表
		String hql = "insert into sys_relation_static values ('" + fdId
				+ "' ,'" + url + "' ,'')";
		getBaseDao().getHibernateSession().createSQLQuery(hql).executeUpdate();
	}

	/**
	 * 得到岗位相关信息 组织架构里service此类调用。 orgType 2=部门，4=岗位，8=员工 parentId 上级机构ID
	 */
	public List<SysOrgElement> getOrgElement(String orgType, String parentId,
			boolean isAll) throws Exception {
		if (StringUtil.isNotNull(orgType)) {
			int otype = 0x0;

			if (orgType.equals("ORG_TYPE_PERSON")) { // 员工
				otype = SysOrgConstant.ORG_TYPE_PERSON;
			}
			if (orgType.equals("ORG_TYPE_POST")) { // 岗位
				otype = SysOrgConstant.ORG_TYPE_POST;
			}
			if (orgType.equals("ORG_TYPE_DEPT")) {// 部门
				otype = SysOrgConstant.ORG_TYPE_DEPT;
			}

			String parentCondition = null;
			if (StringUtil.isNotNull(parentId)) {
				parentCondition = "and hbmParent.fdId='" + parentId.trim()
						+ "'";
			} else {
				if (isAll)
					parentCondition = ""; // 所有的
				else
					parentCondition = "and hbmParent.fdId=null "; // 根的
			}

			String sql = "from  com.landray.kmss.sys.organization.model.SysOrgElement where  fdIsAvailable=1 "
					+ parentCondition
					+ "  and  fdOrgType="
					+ otype
					+ " order by  fdOrder asc";
			Query query = this.getBaseDao().getHibernateSession().createQuery(
					sql);

			List<SysOrgElement> snList = query.list();

			return snList;

		} else
			return null;
	}

	private void addAutoPublish(KmsMultidocKnowledge modelObj) throws Exception {
		try {
			this.backgroundAuthService.switchUser(modelObj.getDocCreator(),
					new Runner() {
						public Object run(Object parameter) throws Exception {
							KmsMultidocKnowledge doc = (KmsMultidocKnowledge) parameter;

							getBaseDao().add(doc);
							WorkflowEngineContext subContext = KmsMultidocKnowledgeServiceImp.this.sysWfProcessSubService
									.init(doc, "mainDoc", doc.getDocCategory(),
											"mainDoc");
							KmsMultidocKnowledgeServiceImp.this.sysWfProcessSubService
									.doAction(subContext, doc);
							return null;
						}
					}, modelObj);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unchecked")
	private void recalculateEditorField(KmsMultidocKnowledge mainModel,
			BaseAuthTmpModel fdTemplate) {
		mainModel.setAuthEditorFlag(fdTemplate.getAuthEditorFlag());
		if (fdTemplate.getAuthAllEditors() != null) {
			mainModel.getAuthAllEditors().addAll(
					new ArrayList(fdTemplate.getAuthAllEditors()));
		}
		if (fdTemplate.getAuthEditors() != null) {
			mainModel.getAuthEditors().addAll(
					new ArrayList(fdTemplate.getAuthEditors()));
		}
		if (fdTemplate.getAuthOtherEditors() != null)
			mainModel.getAuthOtherEditors().addAll(
					new ArrayList(fdTemplate.getAuthOtherEditors()));
	}

	/**
	 * 设置标签（action and webservice and import）
	 */
	public void setTagMain(String docId, String tags) throws Exception {
		if (StringUtil.isNull(tags) || StringUtil.isNull(docId))
			return;
		KmsMultidocKnowledge doc = (KmsMultidocKnowledge) this
				.findByPrimaryKey(docId);

		HQLInfo hqlInfo = new HQLInfo();
		String whereBlock = " fdModelId=:fdModelId and  fdModelName='"
				+ this.getModelName() + "'";
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setParameter("fdModelId", docId);
		List snList = sysTagMainService.findList(hqlInfo);
		SysTagMain tagMain = null;
		if (ArrayUtil.isEmpty(snList)) {
			tagMain = new SysTagMain();
			tagMain.setFdModelId(docId);
			tagMain.setFdModelName(this.getModelName());
			tagMain.setDocCreator(UserUtil.getUser());
			tagMain.setDocStatus(doc.getDocStatus());
			tagMain.setDocCreateTime(new Date());
			tagMain.setDocSubject(doc.getDocSubject());
			tagMain.setFdKey("mainDoc");
			sysTagMainService.add(tagMain);
		} else {
			tagMain = (SysTagMain) snList.get(0);
		}
		doc.setSysTagMain(tagMain);
		String[] split = tags.split("[;；]");

		for (int i = 0; i < split.length; i++) {
			split[i] = split[i].trim();
			if (StringUtil.isNull(split[i]))
				continue;
			HQLInfo hql = new HQLInfo();
			hql
					.setJoinBlock("left join sysTagMain.sysTagMainRelationList sysTagMainRelation");
			hql
					.setWhereBlock("sysTagMainRelation.fdTagName =:fdTagName and sysTagMain.fdModelId = :fdModelId");
			hql.setParameter("fdModelId", docId);
			hql.setParameter("fdTagName", split[i]);
			List list = sysTagMainService.findList(hql);
			if ((list != null) && (!list.isEmpty())) {
				continue;
			}

			SysTagMainRelation sysTagMainRelation = new SysTagMainRelation();
			sysTagTagsService.getBaseDao().getHibernateSession().setFlushMode(
					FlushMode.AUTO);
			if (doc.getDocStatus().charAt(0) >= '3') {// 文档在发布时在标签机制中会添加或更新引用次数，详见SysTagMainServiceImp
				HQLInfo hqlInfo1 = new HQLInfo();
				hqlInfo1.setWhereBlock("sysTagTags.fdName =:fdName");
				hqlInfo1.setParameter("fdName", split[i]);
				List findList = sysTagTagsService.findList(hqlInfo1);

				if ((findList != null) && (!findList.isEmpty())) {
					SysTagTags tag = (SysTagTags) findList.get(0);
					tag.setFdQuoteTimes(tag.getFdQuoteTimes() + 1);
					tag.setFdCountQuoteTimes(tag.getFdCountQuoteTimes() + 1);
					sysTagTagsService.update(tag);
				} else {
					SysTagTags tagTags = new SysTagTags();
					tagTags.setFdName(split[i]);
					tagTags.setFdStatus(Integer.valueOf(1));
					tagTags.setFdIsPrivate(Integer.valueOf(1));
					tagTags.setFdQuoteTimes(Integer.valueOf(1));
					tagTags.setFdCountQuoteTimes(Integer.valueOf(1));
					sysTagTagsService.add(tagTags);
				}
			}
			sysTagMainRelation.setFdTagName(split[i]);
			sysTagMainRelation.setFdMainTag(doc.getSysTagMain());
			sysTagMainRelationService.getBaseDao().getHibernateSession()
					.setFlushMode(FlushMode.AUTO);
			sysTagMainRelationService.add(sysTagMainRelation);
		}
	}

	/**
	 * 设置属性（webservice）
	 * 
	 */
	public void setPropertyList(String docId, List<HashMap> propertyList)
			throws Exception {

		if (StringUtil.isNull(docId) || propertyList == null
				|| propertyList.isEmpty())
			return;
		KmsMultidocKnowledge doc = (KmsMultidocKnowledge) this
				.findByPrimaryKey(docId);
		if (doc.getDocCategory().getSysPropertyTemplate() == null)
			return;

		SysPropertyTemplate propertyTemplate = doc.getDocCategory()
				.getSysPropertyTemplate();

		for (Map<String, String> property : propertyList) {
			String propertyName = property.get("propertyName");
			String propertyValue = property.get("propertyValue");
			Map<String, Object> map = SysPropertySetUtil.setValue(
					propertyTemplate, propertyName, propertyValue);

			doc.getExtendDataModelInfo().getModelData().putAll(map);
		}
		this.update(doc);

	}

	/**
	 * 导入
	 */
	public void addImport(IBaseModel modelObj) throws Exception {
		KmsMultidocKnowledge mainModel = (KmsMultidocKnowledge) modelObj;
		setModelValue(mainModel, true);
		addAutoPublish(mainModel);
		if (StringUtil.isNotNull(mainModel.getTags())) {
			setTagMain(mainModel.getFdId(), mainModel.getTags());
		}
	}

	/**
	 * 
	 * 设置附件
	 * 
	 */
	public String setAttachment(String path, KmsMultidocKnowledge mainModel)
			throws Exception {
		String retunStr = "";
		if (StringUtil.isNull(path))
			return retunStr;
		String[] attStrs = path.split("[;；]");
		for (int i = 0; i < attStrs.length; i++) {
			if (StringUtil.isNull(attStrs[i]))
				continue;
			File attFile = new File(attStrs[i]);
			if (attFile == null || !attFile.exists()) {
				retunStr = retunStr + attStrs[i] + ";";
			}
		}
		if (retunStr.length() > 0)
			return "导入失败，" + retunStr + " 附件不存在 。请检查附件路径是否正确。";

		for (int k = 0; k < attStrs.length; k++) {
			if (StringUtil.isNull(attStrs[k]))
				continue;
			String attName = attStrs[k].substring(attStrs[k].lastIndexOf(System
					.getProperty("file.separator")) + 1, attStrs[k].length());
			File attFile = new File(attStrs[k]);
			if (attFile != null) {
				// String fileType = FilenameUtils.getExtension(attName);
				FileInputStream fileInputStream = new FileInputStream(attFile);
				sysAttMainService.addAttachment(mainModel, "attachment",
						fileInputStream, attName, "byte", Double
								.valueOf(fileInputStream.available()),
						attStrs[k]);
				// if (ImageCompressUtils.isImageType(fileType)) {
				// // 图片缩略图
				// String fileId = sysAttMain.getFdFileId();
				// SysAttFile sysAttFile = null;
				// if (fileId != null && !"".equals(fileId)) {
				// sysAttFile = (SysAttFile) sysAttUploadService
				// .getFileById(fileId);
				// if (sysAttFile != null) {
				// sysAttMain
				// .setFdFilePath(sysAttFile.getFdFilePath());
				// }
				// }
				// InputStream thumbSource = new FileInputStream(attFile);
				// ThumbnailUtil.resizeByFix(800, 800, formatPath(sysAttMain
				// .getFdFilePath())
				// + "_" + "s1", thumbSource);
				// thumbSource = new FileInputStream(attFile);
				// ThumbnailUtil.resizeByFix(2250, 1695,
				// formatPath(sysAttMain
				// .getFdFilePath())
				// + "_" + "s2", thumbSource);
				// IOUtils.closeQuietly(thumbSource);
				// }
				IOUtils.closeQuietly(fileInputStream);

				/*
				 * FileInputStream fileInputStream = new
				 * FileInputStream(attFile); int fileLength =
				 * fileInputStream.available(); byte[] content = new
				 * byte[fileLength]; fileInputStream.read(content, 0,
				 * fileLength); fileInputStream.close();
				 * sysAttMainService.addAttachment(mainModel, "attachment",
				 * content, attName, "byte");
				 */
			}
		}
		return retunStr;
	}

	public void updateImport(IBaseModel modelObj) throws Exception {
		KmsMultidocKnowledge mainModel = (KmsMultidocKnowledge) modelObj;
		setModelValue(mainModel, false);
		getBaseDao().update(modelObj);
		// 标签
		if (StringUtil.isNotNull(mainModel.getTags())) {
			setTagMain(mainModel.getFdId(), mainModel.getTags());
		}
	}

	// private void updateCheckboxValue(Map<String, Object> map) throws
	// Exception {
	// if (map == null || map.isEmpty())
	// return;
	// Iterator<Map.Entry<String,Object>> iter2 =
	// (Iterator<Map.Entry<String,Object>>) map.entrySet().iterator();
	// while (iter2.hasNext()) {
	// Map.Entry<String,Object> structure = iter2.next();
	// DefineCache dc = SysPropertyCacheUtil
	// .getDefineByStructureName(structure.getKey());
	// if (dc != null && "checkbox".equals(dc.getDisplayType())) {
	// String v = (String) structure.getValue();
	// if (v != null && v.indexOf(";") != 0) {
	// map.put(structure.getKey(), ";" + v + ";");
	// }
	// }
	// }
	// }

	/**
	 * @param mainModel
	 * @param isNew
	 *            导入是否是新增
	 */
	private void setModelValue(KmsMultidocKnowledge mainModel, boolean isNew)
			throws Exception {
		if (mainModel.getDocCreateTime() == null)
			mainModel.setDocCreateTime(new Date());
		if (mainModel.getDocCreator() == null)
			mainModel.setDocCreator(UserUtil.getUser());
		mainModel.setExtendFilePath(SysPropertyUtil.getExtendFilePath(mainModel
				.getDocCategory()));
		if (isNew) {
			mainModel.setDocStatus(SysDocConstant.DOC_STATUS_EXAMINE);
			if (!SysDocConstant.DOC_STATUS_DRAFT.equals(mainModel
					.getDocStatus())
					&& StringUtil.isNotNull(mainModel.getDocCategory()
							.getFdNumberPrefix())) {
				KmsMultidocSnContext context = new KmsMultidocSnContext();
				context.setFdPrefix(mainModel.getDocCategory()
						.getFdNumberPrefix());
				context.setFdModelName(ModelUtil.getModelClassName(mainModel));
				context.setFdTemplate(mainModel.getDocCategory());
				mainModel.setFdNumber(kmsMultidocGenerateSnService
						.getSerialNumber(context));
			}
		}
		// 属性
		if (mainModel.getDocCategory().getSysPropertyTemplate() != null
				&& StringUtil.isNotNull(mainModel.getExtendData())) {
			String str = mainModel.getExtendData();
			String[] strs = str.split("\n");
			for (int i = 0; i < strs.length; i++) {
				String propertyName = strs[i]
						.substring(0, strs[i].indexOf(":"));
				String propertyValue = strs[i].substring(
						strs[i].indexOf(":") + 1, strs[i].length());
				Map map = SysPropertySetUtil.setValue(mainModel
						.getDocCategory().getSysPropertyTemplate(),
						propertyName, propertyValue);
				if (map != null)
					mainModel.getExtendDataModelInfo().getModelData().putAll(
							map);
			}
		}
		// 作者
		if (StringUtil.isNotNull(mainModel.getAuthorName())) {
			String whereBlock = SysOrgHQLUtil.buildWhereBlock(
					SysOrgConstant.ORG_TYPE_PERSON, "fd_name='"
							+ mainModel.getAuthorName() + "'", "sysOrgPerson");
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setWhereBlock(whereBlock);
			List list = sysOrgPersonService.findList(hqlInfo);
			if (list.isEmpty()) {
				mainModel.setOuterAuthor(mainModel.getAuthorName());
			} else {
				SysOrgPerson person = (SysOrgPerson) list.get(0);
				mainModel.setDocAuthor(person);
			}
		}
		// 附件
		if (StringUtil.isNotNull(mainModel.getAttPath())) {
			String str = setAttachment(mainModel.getAttPath(), mainModel);
			if (str.length() > 0)
				throw new Exception(str);
		}
		mainModel.setDocExpire(0L);
		// mainModel.setDocPublishTime(new Date());
		// mainModel.setDocIsIndexTop(false);
		recalculateEditorField(mainModel, mainModel.getDocCategory());
		setAuthorDefault(mainModel);
	}

	private void setPropertyValue(Map<String, Object> map, IBaseModel model)
			throws Exception {
		KmsMultidocKnowledge mainModel = (KmsMultidocKnowledge) model;
		Map<String, Object> mmap = mainModel.getExtendDataModelInfo()
				.getModelData();
		if (map == null || map.isEmpty() || mmap == null || mmap.isEmpty())
			return;
		Iterator<Map.Entry<String, Object>> iter2 = (Iterator<Map.Entry<String, Object>>) map
				.entrySet().iterator();
		while (iter2.hasNext()) {
			Map.Entry<String, Object> structure = iter2.next();
			if (mmap.containsKey(structure.getKey())) {
				mmap.put(structure.getKey(), structure.getValue());
			}
		}
		mainModel.getExtendDataModelInfo().saveModelData();
	}

	// 获取当前分类为第几级分类
	public int getLevelCount(KmsKnowledgeCategory kmsKnowledgeCategory)
			throws Exception {
		String fdHierarchyId = kmsKnowledgeCategory.getFdHierarchyId();
		int countX = 0;
		for (int i = 0; i < fdHierarchyId.length(); i++) {
			if (fdHierarchyId.charAt(i) == 'x') {
				countX++;
			}
		}
		return countX - 1;
	}

	// 根据分类拼出该分类的fdSetTopLevel排序码
	public String getFdSetTopLevel(KmsKnowledgeCategory kmsKnowledgeCategory,
			String str) throws Exception {
		String fdHierarchyId = kmsKnowledgeCategory.getFdHierarchyId();
		int countX = 0;
		int levelCount = 0;
		for (int i = 0; i < fdHierarchyId.length(); i++) {
			if (fdHierarchyId.charAt(i) == 'x') {
				countX++;
			}
		}
		levelCount = countX - 1;
		String fdSetTopLevel = "";
		StringBuilder sb = new StringBuilder();
		for (int n = 0; n < levelCount - 1; n++) {
			sb.append("0");
		}
		fdSetTopLevel = sb.append(str).toString();
		return fdSetTopLevel;
	}

	// 经过筛选器筛选后的文档hql（已权限处理）
	public HQLWrapper getDocHql(String whereBlock, String __joinBlock,
			HttpServletRequest request) throws Exception {

		HQLInfo hql = new HQLInfo();
		if (hql.getCheckParam(SysAuthConstant.CheckType.AllCheck) == null) {
			hql.setCheckParam(SysAuthConstant.CheckType.AllCheck,
					SysAuthConstant.AllCheck.DEFAULT);
		}
		hql.setSelectBlock("kmsMultidocKnowledge.fdId");
		hql.setFromBlock(__joinBlock);
		hql
				.setModelName("com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge");
		hql.setWhereBlock(whereBlock);
		HQLCombiner hqlCombiner = (HQLCombiner) SpringBeanUtil
				.getBean("hqlCombiner");
		HQLWrapper hqlWrapper = hqlCombiner.buildQueryHQL(hql);
		return hqlWrapper;
	}

	public void delete(IBaseModel modelObj) throws Exception {
		super.delete(modelObj);
		String docStatus = ((KmsMultidocKnowledge) modelObj).getDocStatus();
		if (KmsDocConstant.DOC_STATUS_RECYCLE.equals(docStatus)
				|| KmsDocConstant.DOC_STATUS_PUBLISH.equals((docStatus)))
			this.kmsCommonRecycleLogService.addLog(modelObj,
					KmsCommonOperateConstant.RECYCLELOG_OPERATE_DELETE);
	}

	@Override
	public void updateRecycle(String[] ids) throws Exception {
		for (int i = 0; i < ids.length; i++) {
			updateRecycle(ids[i]);
		}
	}

	/**
	 * 回收文档
	 */
	@Override
	public void updateRecycle(String id) throws Exception {
		KmsMultidocKnowledge model = (KmsMultidocKnowledge) this
				.findByPrimaryKey(id);
		if (!KmsDocConstant.DOC_STATUS_PUBLISH.equals(model.getDocStatus()))
			return;
		// 若当前版本有新版本，则不能回收
		ISysEditionMainModel editionMainModel = (ISysEditionMainModel) model;
		if (editionMainModel.getDocIsLocked() != null
				&& editionMainModel.getDocIsLocked().booleanValue()) {
			throw new KmssRuntimeException(new KmssMessage(
					"sys-edition:error.deletelockeddoc"));
		}
		// 记录日志
		kmsCommonRecycleLogService.addLog(model,
				KmsCommonOperateConstant.RECYCLELOG_OPERATE_RECYCLE);
		model.setDocStatus(KmsDocConstant.DOC_STATUS_RECYCLE);
		((IKmsMultidocKnowledgeDao) this.getBaseDao()).updateDocdelete(model);
	}

	public void updateRecover(String id, String description) throws Exception {
		KmsMultidocKnowledge model = (KmsMultidocKnowledge) this
				.findByPrimaryKey(id);
		if (!KmsDocConstant.DOC_STATUS_RECYCLE.equals(model.getDocStatus()))
			return;
		kmsCommonRecycleLogService.addLog(model,
				KmsCommonOperateConstant.RECYCLELOG_OPERATE_RECOVER,
				description);
		model.setDocStatus(KmsDocConstant.DOC_STATUS_PUBLISH);
		this.getBaseDao().update(model);
	}

	@Override
	public void updateCateInfo(IBaseModel model, IBaseModel cateModel)
			throws Exception {
		KmsMultidocKnowledge knowledge = (KmsMultidocKnowledge) model;
		KmsKnowledgeCategory category = (KmsKnowledgeCategory) cateModel;
		knowledge
				.setExtendFilePath(SysPropertyUtil.getExtendFilePath(category));
	}
}
