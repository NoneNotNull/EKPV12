package com.landray.kmss.sys.news.service.spring;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.util.CollectionUtils;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.KmssRuntimeException;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.model.SysAttMain;
import com.landray.kmss.sys.attachment.service.ISysAttMainCoreInnerService;
import com.landray.kmss.sys.attachment.util.JgWebOffice;
import com.landray.kmss.sys.metadata.interfaces.ExtendDataServiceImp;
import com.landray.kmss.sys.news.dao.ISysNewsMainDao;
import com.landray.kmss.sys.news.forms.SysNewsMainForm;
import com.landray.kmss.sys.news.model.SysNewsMain;
import com.landray.kmss.sys.news.model.SysNewsMainKeyword;
import com.landray.kmss.sys.news.model.SysNewsTemplate;
import com.landray.kmss.sys.news.model.SysNewsTemplateKeyword;
import com.landray.kmss.sys.news.service.ISysNewsMainService;
import com.landray.kmss.sys.news.service.ISysNewsTemplateService;
import com.landray.kmss.sys.simplecategory.interfaces.SimpleCategoryUtil;
import com.landray.kmss.sys.simplecategory.model.ISysSimpleCategoryModel;
import com.landray.kmss.sys.workflow.interfaces.Event_SysFlowFinish;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * 创建日期 2007-Sep-17
 * 
 * @author 舒斌 新闻主表单业务接口实现
 */
public class SysNewsMainServiceImp extends ExtendDataServiceImp implements
		ISysNewsMainService, ApplicationListener {
	private ISysNewsTemplateService sysNewsTemplateService;

	protected ISysAttMainCoreInnerService sysAttMainCoreInnerService = null;

	public void setSysAttMainCoreInnerService(
			ISysAttMainCoreInnerService sysAttMainCoreInnerService) {
		this.sysAttMainCoreInnerService = sysAttMainCoreInnerService;
	}

	public void updateTemplate(String[] ids, String templateId)
			throws Exception {
		SysNewsTemplate template = (SysNewsTemplate) sysNewsTemplateService
				.findByPrimaryKey(templateId);
		List list = getBaseDao().findByPrimaryKeys(ids);
		for (Iterator it = list.iterator(); it.hasNext();) {
			SysNewsMain sysNewsMain = (SysNewsMain) it.next();
			sysNewsMain.setFdTemplate(template);
			getBaseDao().update(sysNewsMain);
		}
	}

	public void updateTop(String[] ids, Long days, boolean isTop)
			throws Exception {
		List list = getBaseDao().findByPrimaryKeys(ids);
		for (Iterator it = list.iterator(); it.hasNext();) {
			SysNewsMain sysNewsMain = (SysNewsMain) it.next();
			if (isTop) {
				sysNewsMain.setFdTopDays(days);
				sysNewsMain.setFdTopTime(new Date());
			} else {
				sysNewsMain.setFdTopDays(null);
				sysNewsMain.setFdTopTime(null);
			}
			getBaseDao().update(sysNewsMain);
		}
	}

	public IBaseModel convertFormToModel(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
		SysNewsMain newsMain = (SysNewsMain) super.convertFormToModel(form,
				model, requestContext);
		SysNewsMainForm newsForm = (SysNewsMainForm) form;
		AttachmentDetailsForm attDetailsForm = (AttachmentDetailsForm) newsForm
				.getAttachmentForms().get("Attachment");
		newsMain.setFdIsPicNews(new Boolean(StringUtil.isNotNull(attDetailsForm
				.getAttachmentIds())));
		newsMain.setDocAlterTime(new Date());
		return newsMain;
	}

	public StringBuffer getNewsPath(String templateId) throws Exception {
		ISysNewsMainDao dao = (ISysNewsMainDao) this.getBaseDao();
		List list = dao.getNewsPath(templateId);
		StringBuffer buffer = new StringBuffer();
		int j = list.size();
		for (int i = 0; i < j; i++) {
			buffer.append(list.get(i));
			if (i != j - 1)
				buffer.append(" > ");
		}
		return buffer;
	}

	public void onApplicationEvent(ApplicationEvent event) {
		if (event == null)
			return;
		Object obj = event.getSource();
		if (!(obj instanceof SysNewsMain))
			return;
		if (event instanceof Event_SysFlowFinish) {
			try {
				SysNewsMain newsMain = (SysNewsMain) obj;
				// 更新发布时间 修正为只有新建时，未编辑时才在发布时设置发布时间
				if (null == newsMain.getDocPublishTime()) {
					newsMain.setDocPublishTime(new Date());					
				}
				newsMain.setDocAlterTime(new Date());
				// 这里是特别要注意的地方，不能直接调用service的update方法保存域模型，否则会产生死循环！切记
				getBaseDao().update(newsMain);
			} catch (Exception e) {
				throw new KmssRuntimeException(e);
			}
		}
	}

	public void updateTopAgent() throws Exception {
		((ISysNewsMainDao) getBaseDao()).updateTopAgent();
	}

	public void updatePublish(String[] ids, boolean op) throws Exception {
		List list = getBaseDao().findByPrimaryKeys(ids);
		for (Iterator it = list.iterator(); it.hasNext();) {
			SysNewsMain sysNewsMain = (SysNewsMain) it.next();
			if (op) {
				sysNewsMain.setDocPublishTime(new Date());
				sysNewsMain.setDocStatus(SysDocConstant.DOC_STATUS_PUBLISH);
			} else {
				sysNewsMain.setDocStatus(SysDocConstant.DOC_STATUS_EXPIRE);
				sysNewsMain.setFdTopDays(null);
				sysNewsMain.setFdTopTime(null);
				sysNewsMain.setFdTopEndTime(null);
				sysNewsMain.setFdIsTop(Boolean.FALSE);
			}
			getBaseDao().update(sysNewsMain);
		}
	}

	public void setSysNewsTemplateService(
			ISysNewsTemplateService sysNewsTemplateService) {
		this.sysNewsTemplateService = sysNewsTemplateService;
	}

	public void updateAuthWithTmp(String tmpId) throws Exception {
		SysNewsTemplate tmp = (SysNewsTemplate) sysNewsTemplateService
				.findByPrimaryKey(tmpId);
		List authReaders = tmp.getAuthTmpReaders();
		List authEditors = tmp.getAuthTmpEditors();

		if (CollectionUtils.isEmpty(authReaders)
				&& CollectionUtils.isEmpty(authEditors))
			return;
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("sysNewsMain.fdTemplate.fdId=:tmpId");
		hqlInfo.setParameter("tmpId", tmpId);
		List allnews = findList(hqlInfo);
		if (!CollectionUtils.isEmpty(allnews)) {
			for (Iterator it = allnews.iterator(); it.hasNext();) {
				SysNewsMain sysNewsMain = (SysNewsMain) it.next();
				sysNewsMain.setAuthReaders(new ArrayList(authReaders));
				sysNewsMain.setAuthEditors(new ArrayList(authEditors));
				getBaseDao().update(sysNewsMain);
			}
		}
	}

	/**
	 * 加载发布记录
	 * 
	 * @author 周超
	 */
	public List findListPublishRecord(String fdModelName, String fdModelId)
			throws Exception {
		// 根据modelId 和modelName查询新闻记录
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo
				.setWhereBlock("sysNewsMain.fdModelId=:fdModelId and sysNewsMain.fdModelName=:fdModelName");
		hqlInfo.setParameter("fdModelId", fdModelId);
		hqlInfo.setParameter("fdModelName", fdModelName);
		return super.findList(hqlInfo);
	}

	public String add(IExtendForm form, RequestContext requestContext)
			throws Exception {
		IBaseModel model = convertFormToModel(form, null, requestContext);
		if (model == null)
			throw new NoRecordException();
		SysNewsMain sysNewsMain = (SysNewsMain) model;
		sysNewsMain.setDocCreator(UserUtil.getUser());
		sysNewsMain.setDocCreateTime(new Date());
		//sysNewsMain.setDocAlterTime(new Date());
		sysNewsMain.setDocCreatorClientIp(requestContext.getRemoteAddr());
		return add(model);
	}

	@Override
	public void delete(IBaseModel modelObj) throws Exception {
		String fdId = modelObj.getFdId();
		super.delete(modelObj);
		// 删除html文件
		if (JgWebOffice.isJGEnabled()) {
			JgWebOffice.deleteFile(fdId);
		}
	}

	/**
	 * 重写父类add方法，实现新闻文档内容切换到“word文档”再切换到“rtf域”提交时，把word文档附件删除
	 */
	@Override
	public String add(IBaseModel modelObj) throws Exception {
		SysNewsMain mainObj = (SysNewsMain) modelObj;
		if ("rtf".equals(mainObj.getFdContentType())) {
			AttachmentDetailsForm attDetailForm = (AttachmentDetailsForm) mainObj
					.getAttachmentForms().get("editonline");
			if (attDetailForm != null) {
				attDetailForm.setDeletedAttachmentIds(attDetailForm
						.getAttachmentIds());
				attDetailForm.setAttachmentIds("");
			}
		}
		return super.add(mainObj);
	}

	public Map<String, Object> getPortletDataMap(RequestContext requestInfo)
			throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		String whereBlock = "sysNewsMain.docStatus=:docStatus";
		String parentId = requestInfo.getParameter("cateid");
		String templateProperty = "sysNewsMain.fdTemplate";
		if (!StringUtil.isNull(parentId)) {
			ISysSimpleCategoryModel category = (ISysSimpleCategoryModel) sysNewsTemplateService
					.findByPrimaryKey(parentId);
			whereBlock = SimpleCategoryUtil.buildChildrenWhereBlock(category,
					templateProperty, whereBlock);
		}
		whereBlock += " and sysNewsMain.fdIsPicNews=1";
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo
				.setOrderBy("sysNewsMain.fdIsTop desc,sysNewsMain.fdTopTime desc,sysNewsMain.docAlterTime desc,sysNewsMain.docPublishTime desc,sysNewsMain.docCreateTime desc");
		hqlInfo.setPageNo(1);
		hqlInfo.setRowSize(1);
		hqlInfo.setParameter("docStatus", SysDocConstant.DOC_STATUS_PUBLISH);
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaCheck,SysAuthConstant.AreaCheck.YES);
		List<SysNewsMain> newList = getBaseDao().findPage(hqlInfo).getList();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		if (newList != null && !newList.isEmpty()) {
			SysNewsMain sysNewsMain = newList.get(0);
			String link = getAttachmentLink(sysNewsMain.getFdId(), "Attachment");
			rtnMap.put("image", link);
			StringBuffer sb = new StringBuffer();
			// 判断如果是链接新闻则显示文档的链接
			if (sysNewsMain.getFdIsLink() == null
					|| !(Boolean) sysNewsMain.getFdIsLink()) {
				sb.append("/sys/news/sys_news_main/sysNewsMain.do?method=view");
				sb.append("&fdId=" + sysNewsMain.getFdId());
			} else if ((Boolean) sysNewsMain.getFdIsLink()
					&& sysNewsMain.getFdLinkUrl() != null) {
				sb.append(sysNewsMain.getFdLinkUrl());
			}
			rtnMap.put("href", sb.toString());
		  //rtnMap.put("content", sysNewsMain.getDocContent());
			rtnMap.put("description", sysNewsMain.getFdDescription());
		}
		return rtnMap;
	}

	private String getAttachmentLink(String newsId, String fdKey)
			throws Exception {
		String link = null;
		List<SysAttMain> attList = sysAttMainCoreInnerService.findByModelKey(
				"com.landray.kmss.sys.news.model.SysNewsMain", newsId, fdKey);
		if (attList != null && !attList.isEmpty()) {
			SysAttMain att = (SysAttMain) attList.get(0);
			link = "/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId="
					+ att.getFdId() + "&fileName=" + att.getFdFileName();
		}
		return link;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	protected IBaseModel initBizModelSetting(RequestContext requestContext)
			throws Exception {
		SysNewsMain sysNewsMain = new SysNewsMain();
		String templateId = requestContext.getParameter("fdTemplateId");
		if (StringUtil.isNull(templateId))
			return sysNewsMain;
		SysNewsTemplate template = (SysNewsTemplate) sysNewsTemplateService.findByPrimaryKey(templateId);
		if (template == null) {
			return sysNewsMain;
		}
		// 模板名称
		sysNewsMain.setFdTemplate(template);
		// 新闻内容
		sysNewsMain.setDocContent(template.getDocContent());
		// 所属部门
		sysNewsMain.setFdDepartment(UserUtil.getUser().getFdParent() );
		// 关键字
		List<SysNewsTemplateKeyword> templateList=template.getDocKeyword();
		List<SysNewsMainKeyword> modelKeywordList=new ArrayList<SysNewsMainKeyword>();
		for (SysNewsTemplateKeyword tkey:templateList) {
			SysNewsMainKeyword tKeyword=new SysNewsMainKeyword();
			tKeyword.setDocKeyword(tkey.getDocKeyword());
			modelKeywordList.add(tKeyword);
		}
		sysNewsMain.setDocKeyword(modelKeywordList);
		// 新闻重要度
		sysNewsMain.setFdImportance( template.getFdImportance());
		// 新闻可阅读者
		sysNewsMain.setAuthReaders(template.getAuthTmpReaders());
		// 新闻可编辑者
		sysNewsMain.setAuthEditors( template.getAuthTmpEditors());
		sysNewsMain.setDocCreator(UserUtil.getUser());
		sysNewsMain.setFdAuthor(UserUtil.getUser());
		sysNewsMain.setDocCreateTime(new Date());
		sysNewsMain.setFdContentType(template.getFdContentType()); // 设置编辑方式
		return sysNewsMain;
	}
	
	@Override
	protected void initCoreServiceFormSetting(IExtendForm form,
			IBaseModel model, RequestContext requestContext) throws Exception {
		SysNewsMain sysNewsMain = (SysNewsMain) model;
		dispatchCoreService.initFormSetting(form, "newsMainDoc", sysNewsMain.getFdTemplate()
				, "newsMainDoc", requestContext);
	}
}
