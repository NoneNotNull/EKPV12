package com.landray.kmss.km.doc.service.spring;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.event.Event_CommonDelete;
import com.landray.kmss.common.exception.KmssRuntimeException;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.km.doc.dao.IKmDocKnowledgeDao;
import com.landray.kmss.km.doc.model.KmDocKnowledge;
import com.landray.kmss.km.doc.model.KmDocKnowledgeKeyword;
import com.landray.kmss.km.doc.model.KmDocTemplate;
import com.landray.kmss.km.doc.model.KmDocTemplateKeyword;
import com.landray.kmss.km.doc.service.IKmDocKnowledgeService;
import com.landray.kmss.km.doc.service.IKmDocTemplateService;
import com.landray.kmss.sys.doc.model.SysDocBaseInfo;
import com.landray.kmss.sys.doc.service.spring.SysDocBaseInfoServiceImp;
import com.landray.kmss.sys.metadata.interfaces.ExtendDataServiceImp;
import com.landray.kmss.sys.quartz.interfaces.SysQuartzJobContext;
import com.landray.kmss.sys.workflow.interfaces.Event_SysFlowFinish;
import com.landray.kmss.sys.workflow.interfaces.ISysWfMainModel;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖 知识库文档业务接口实现
 */
public class KmDocKnowledgeServiceImp extends ExtendDataServiceImp implements
		IKmDocKnowledgeService, ApplicationListener, ApplicationContextAware {
	private IKmDocTemplateService kmDocTemplateService;

	public IKmDocTemplateService getKmDocTemplateService() {
		return kmDocTemplateService;
	}

	public void setKmDocTemplateService(
			IKmDocTemplateService kmDocTemplateService) {
		this.kmDocTemplateService = kmDocTemplateService;
	}

	public KmDocTemplate getKmDocTemplate(String templateId) throws Exception {
		KmDocTemplate kmDocTemplate = (KmDocTemplate) kmDocTemplateService
				.findByPrimaryKey(templateId);
		return kmDocTemplate;
	}

	private ApplicationContext applicationContext;

	private static Log logger = LogFactory
			.getLog(SysDocBaseInfoServiceImp.class);

	public void delete(IBaseModel modelObj) throws Exception {
		SysDocBaseInfo sysDocBaseInfo = (SysDocBaseInfo) modelObj;
		if (sysDocBaseInfo.getDocStatus().charAt(0) >= '3') {
			applicationContext.publishEvent(new Event_CommonDelete(modelObj));
		}
		super.delete(sysDocBaseInfo);
	}

	public void onApplicationEvent(ApplicationEvent event) {
		if (event == null)
			return;
		Object obj = event.getSource();
		if (!(obj instanceof KmDocKnowledge))
			return;
		if (event instanceof Event_SysFlowFinish) {
			KmDocKnowledge kmDocKnowledge = (KmDocKnowledge) obj;
			kmDocKnowledge.setDocPublishTime(new Date());
			if (kmDocKnowledge instanceof ISysWfMainModel)
				try {
					//getBaseDao().update(sysDocBaseInfo);
					//为支持bam2修改的代码块 begin 2013-08-22
					this.update(kmDocKnowledge);
					//为支持bam2修改的代码块 end 2013-08-22
				} catch (Exception e) {
					logger.error(e);
					throw new KmssRuntimeException(e);
				}
		}
	}

	public void setApplicationContext(ApplicationContext applicationContext)
			throws BeansException {
		this.applicationContext = applicationContext;
	}

	public void update(IExtendForm form, RequestContext requestContext)
			throws Exception {
		IBaseModel model = convertFormToModel(form, null, requestContext);
		if (model == null)
			throw new NoRecordException();
		SysDocBaseInfo sysDocBaseInfo = (SysDocBaseInfo) model;
		sysDocBaseInfo.setDocAlteror(UserUtil.getUser());
		sysDocBaseInfo.setDocAlterTime(new Date());
		sysDocBaseInfo.setDocAlterClientIp(requestContext.getRemoteAddr());
		update(sysDocBaseInfo);
	}

	public String add(IExtendForm form, RequestContext requestContext)
			throws Exception {
		IBaseModel model = convertFormToModel(form, null, requestContext);
		if (model == null)
			throw new NoRecordException();
		SysDocBaseInfo sysDocBaseInfo = (SysDocBaseInfo) model;
		sysDocBaseInfo.setDocCreator(UserUtil.getUser());
		sysDocBaseInfo.setDocCreateTime(new Date());
		sysDocBaseInfo.setDocCreatorClientIp(requestContext.getRemoteAddr());
		return add(model);
	}

	public int updateDucmentTemplate(String ids, String templateId)
			throws Exception {
		return ((IKmDocKnowledgeDao) this.getBaseDao()).updateDocumentTemplate(
				ids, templateId);
	}

	public void updateDocExpire(SysQuartzJobContext context) throws Exception {
		List list = findList("docStatus='30' and docExpire <> 0",
				"docPublishTime");
		for (int i = 0; i < list.size(); i++) {
			Calendar cal1 = Calendar.getInstance();
			Calendar cal2 = Calendar.getInstance();
			KmDocKnowledge kmDocKnowledge = ((KmDocKnowledge) list.get(i));
			Long expiredays = kmDocKnowledge.getDocExpire();
			Date publishday = kmDocKnowledge.getDocPublishTime();
			cal1.setTime(publishday);
			cal1.add(Calendar.YEAR, expiredays.intValue());
			cal2.setTime(new Date());
			if (cal1.getTime().compareTo(cal2.getTime()) < 0) {
				kmDocKnowledge.setDocStatus(SysDocConstant.DOC_STATUS_EXPIRE);
				update(kmDocKnowledge);
			}
			context.logMessage("主题为：" + kmDocKnowledge.getDocSubject()
					+ "的文档已过期");
		}
	}

	protected IBaseModel initBizModelSetting(RequestContext requestContext)
			throws Exception {
		KmDocKnowledge kmDocKnowledge = new KmDocKnowledge();
		String templateId = requestContext.getParameter("fdTemplateId");
		if (StringUtil.isNull(templateId))
			return kmDocKnowledge;
		KmDocTemplate template = (KmDocTemplate) kmDocTemplateService
				.findByPrimaryKey(templateId);
		if (template == null) {
			return kmDocKnowledge;
		}
		kmDocKnowledge.setKmDocTemplate(template);
		kmDocKnowledge.setDocCreator(UserUtil.getUser());
		kmDocKnowledge.setDocDept(UserUtil.getUser().getFdParent());

		kmDocKnowledge.setDocExpire(template.getDocExpire());
		kmDocKnowledge.setDocContent(template.getDocContent());
		List<KmDocTemplateKeyword> docTemplateList=template.getDocKeyword();
		List<KmDocKnowledgeKeyword> docList=new ArrayList<KmDocKnowledgeKeyword>();
		for (KmDocTemplateKeyword kmDocTemplateKeyword : docTemplateList) {
			KmDocKnowledgeKeyword keyword=new KmDocKnowledgeKeyword();
			keyword.setDocKeyword(kmDocTemplateKeyword.getDocKeyword());
			docList.add(keyword);
		}
		kmDocKnowledge.setDocKeyword(docList);
		kmDocKnowledge.setDocPosts(new ArrayList(template.getDocPosts()));
		kmDocKnowledge.setDocProperties(new ArrayList(template
				.getDocProperties()));

		return kmDocKnowledge;

	}

	protected void initCoreServiceFormSetting(IExtendForm form,
			IBaseModel model, RequestContext requestContext) throws Exception {
		KmDocKnowledge kmDocKnowledge = (KmDocKnowledge) model;
		dispatchCoreService.initFormSetting(form, "mainDoc", kmDocKnowledge
				.getKmDocTemplate(), "mainDoc", requestContext);
	}

}
