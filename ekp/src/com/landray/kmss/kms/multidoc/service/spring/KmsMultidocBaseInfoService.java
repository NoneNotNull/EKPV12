package com.landray.kmss.kms.multidoc.service.spring;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.ApplicationEvent;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.event.Event_CommonDelete;
import com.landray.kmss.common.exception.KmssRuntimeException;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.sys.bookmark.model.SysBookmarkMain;
import com.landray.kmss.sys.bookmark.service.ISysBookmarkMainService;
import com.landray.kmss.sys.doc.model.SysDocBaseInfo;
import com.landray.kmss.sys.doc.service.ISysDocBaseInfoService;
import com.landray.kmss.sys.doc.service.spring.SysDocBaseInfoServiceImp;
import com.landray.kmss.sys.metadata.interfaces.ExtendDataServiceImp;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataService;
import com.landray.kmss.sys.workflow.interfaces.Event_SysFlowFinish;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.UserUtil;

/**
 * @author fyx
 * 
 */
public class KmsMultidocBaseInfoService extends ExtendDataServiceImp implements
		IExtendDataService, ISysDocBaseInfoService, ApplicationContextAware {

	private ApplicationContext applicationContext;

	private static Log logger = LogFactory
			.getLog(SysDocBaseInfoServiceImp.class);

	@Override
	public void delete(IBaseModel modelObj) throws Exception {
		SysDocBaseInfo sysDocBaseInfo = (SysDocBaseInfo) modelObj;
		if (sysDocBaseInfo.getDocStatus().charAt(0) >= '3') {
			applicationContext.publishEvent(new Event_CommonDelete(modelObj));
		}
		// 删除收藏
		String sql = "from  SysBookmarkMain  a where   a.fdModelId=:fdModelId";
		Query query = this.getBaseDao().getHibernateSession().createQuery(sql);
		query.setString("fdModelId", modelObj.getFdId());
		List<?> snList = query.list();
		ISysBookmarkMainService sysBookmarkMainService = (ISysBookmarkMainService) SpringBeanUtil
				.getBean("sysBookmarkMainService");
		
		for (int i = 0; i < snList.size(); i++) {
			SysBookmarkMain bookmark = (SysBookmarkMain) snList.get(i);
			sysBookmarkMainService.delete(bookmark);
		}

		super.delete(sysDocBaseInfo);
	}

	public void onApplicationEvent(ApplicationEvent event) {
		if (event == null)
			return;
		Object obj = event.getSource();
		if (!(obj instanceof KmsMultidocKnowledge))
			return;
		if (event instanceof Event_SysFlowFinish) {
			KmsMultidocKnowledge kmsMultidocKnowledge = (KmsMultidocKnowledge) obj;
			kmsMultidocKnowledge.setDocPublishTime(new Date());
			/*
			 * if (!(sysDocBaseInfo instanceof ISysWfMainModel)) try {
			 * getBaseDao().update(sysDocBaseInfo); } catch (Exception e) {
			 * logger.error(e); throw new KmssRuntimeException(e); }
			 */
			// 增加bam2产品支持 begin
			try {
				this.update(kmsMultidocKnowledge);
			} catch (Exception e) {
				logger.error(e);
				throw new KmssRuntimeException(e);
			}
			// 增加bam2产品支持 end
		}
	}

	public void setApplicationContext(ApplicationContext applicationContext)
			throws BeansException {
		this.applicationContext = applicationContext;
	}

	public void update(IExtendForm form, RequestContext requestContext)
			throws Exception {
		IBaseModel model = convertFormToModel(form, null, requestContext);
		if (model == null) {
			throw new NoRecordException();
		}
		SysDocBaseInfo sysDocBaseInfo = (SysDocBaseInfo) model;
		sysDocBaseInfo.setDocAlteror(UserUtil.getUser());
		sysDocBaseInfo.setDocAlterTime(new Date());
		sysDocBaseInfo.setDocAlterClientIp(requestContext.getRemoteAddr());
		update(sysDocBaseInfo);
	}

	public String add(IExtendForm form, RequestContext requestContext)
			throws Exception {
		String id = super.add(form, requestContext);
		SysDocBaseInfo sysDocBaseInfo = (SysDocBaseInfo) findByPrimaryKey(id);
		sysDocBaseInfo.setDocCreator(UserUtil.getUser());
		sysDocBaseInfo.setDocCreateTime(new Date());
		sysDocBaseInfo.setDocCreatorClientIp(requestContext.getRemoteAddr());
		getBaseDao().update(sysDocBaseInfo);
		return id;
	}
}
