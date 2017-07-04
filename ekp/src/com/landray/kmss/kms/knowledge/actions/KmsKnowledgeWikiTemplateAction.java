package com.landray.kmss.kms.knowledge.actions;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.ArrayUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.component.bklink.util.CompBklinkUtil;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeWikiCatalogForm;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeWikiCatalog;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeWikiTemplate;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeWikiTemplateService;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.authorization.interfaces.SysAuthAreaUtils;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;

 
/**
 * 模板表 Action
 * 
 * @author 
 * @version 1.0 2012-03-23
 */
public class KmsKnowledgeWikiTemplateAction extends ExtendAction {
	protected IKmsKnowledgeWikiTemplateService kmsKnowledgeWikiTemplateService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(kmsKnowledgeWikiTemplateService == null)
			kmsKnowledgeWikiTemplateService = (IKmsKnowledgeWikiTemplateService)getBean("kmsKnowledgeWikiTemplateService");
		return kmsKnowledgeWikiTemplateService;
	}
	
	protected void loadActionForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		form.reset(mapping, request);
		IExtendForm rtnForm = null;
		String id = request.getParameter("fdId");
		if (!StringUtil.isNull(id)) {
			IBaseModel model = getServiceImp(request).findByPrimaryKey(id,
					null, true);
			if (model != null){
				KmsKnowledgeWikiTemplate mainModel = (KmsKnowledgeWikiTemplate)model;
				mainModel.setFdCatelogList(getCatelogListByOrder(mainModel.getFdCatelogList()));
				
				rtnForm = getServiceImp(request).convertModelToForm(
						(IExtendForm) form, mainModel, new RequestContext(request));
			}
		}
		if (rtnForm == null)
			throw new NoRecordException();
		request.setAttribute(getFormName(rtnForm, request), rtnForm);
	}
	
	
	/**
	 * 将目录排序
	 * @param <T>
	 * */
	protected <T extends KmsKnowledgeWikiCatalog> List<T> getCatelogListByOrder(List<T> list){
		Collections.sort(list, new Comparator<T>(){
			public int compare(T t1,T t2){
				return t1.getFdOrder()-t2.getFdOrder();
			}
		});
		return list;
	}
	
	/**
	 * 异步获取目录
	 */
	public ActionForward loadTemplate(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-loadTemplate", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("GET"))
				throw new UnexpectedRequestException();
			JSONObject rtObject = new JSONObject();
			JSONArray catelogArray = new JSONArray();
			String id = request.getParameter("fdTemplateId");
			//编辑规范
			String  description = "";
			if (StringUtil.isNull(id)) {
				rtObject.put("description", "");
				rtObject.put("catelogJson", catelogArray);
			}
			else {
				KmsKnowledgeWikiTemplate kmsWikiTemplate = (KmsKnowledgeWikiTemplate) getServiceImp(request)
						.findByPrimaryKey(id);
				if(kmsWikiTemplate != null) {
					description = kmsWikiTemplate.getFdDescription();
					List catelogList = kmsWikiTemplate.getFdCatelogList();
					JSONObject tmpCatelogJson = null;
					if(catelogList.size() > 0) {
						for(int i=0; i<catelogList.size(); i++) {
							//获取模板目录
							KmsKnowledgeWikiCatalog tmpCatelogTemplate = (KmsKnowledgeWikiCatalog)catelogList.get(i);
							if(tmpCatelogTemplate != null) {
								KmsKnowledgeWikiCatalogForm catelogFormTmp = null;
								//转换模板目录
								catelogFormTmp = (KmsKnowledgeWikiCatalogForm) getServiceImp(request)
									.convertModelToForm((IExtendForm) catelogFormTmp,tmpCatelogTemplate,
									    new RequestContext(request));
								//KmsWikiCatelogForm catelogForm = new KmsWikiCatelogForm();
								tmpCatelogJson = new JSONObject();
								tmpCatelogJson.put("fdId", IDGenerator.generateID());
								tmpCatelogJson.put("fdName", catelogFormTmp.getFdName());
								tmpCatelogJson.put("fdOrder", catelogFormTmp.getFdOrder());
								tmpCatelogJson.put("docContent", "");
								tmpCatelogJson.put("fdParentId", "");
								tmpCatelogJson.put("authEditorIds", catelogFormTmp.getAuthTmpEditorIds());
								tmpCatelogJson.put("authEditorNames", catelogFormTmp.getAuthTmpEditorNames());
								catelogArray.add(i, tmpCatelogJson);
							}
						}
					}
				}
				rtObject.put("description", description);
				rtObject.put("catelogJson", catelogArray);
			}
			request.setAttribute("lui-source", rtObject);
		} catch (Exception e) {
			messages.addError(e);
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		TimeCounter.logCurrentTime("Action-loadTemplate", false, getClass());
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("lui-source", mapping, form, request, response);

	}
	
	
	public ActionForward deleteall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-deleteall", true, getClass());
		KmssMessages messages = new KmssMessages();
		String[] ids = null ;
		String forward = "failure";
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			ids = request.getParameterValues("List_Selected");

			if (ISysAuthConstant.IS_AREA_ENABLED) {
				String[] authIds = SysAuthAreaUtils.removeNoAuthIds(ids,
						request, "method=delete&fdId=${id}");
				int noAuthIdNum = ids.length - authIds.length;
				if (noAuthIdNum > 0) {
					messages.addMsg(new KmssMessage(
							"sys-authorization:area.batch.operation.info",
							noAuthIdNum));
				}

				if (!ArrayUtils.isEmpty(authIds))
					getServiceImp(request).delete(authIds);
			} else if (ids != null) {
				getServiceImp(request).delete(ids);
			}

		} catch (Exception e) {
			messages.addError(e);
			String forwardTemp = CompBklinkUtil.isDeleteConstraintException(e);
			String tempIds = CompBklinkUtil.getIds(ids);
			String httpURL = request.getRequestURI();
			request.setAttribute("httpURL", httpURL);
			request.setAttribute("ids", tempIds);
			request.setAttribute("modelName", "com.landray.kmss.kms.knowledge.model.KmsKnowledgeWikiTemplate");
			// request.setAttribute("searchCondition", "fdModelName:" +
			// modelName);
			if (StringUtil.isNotNull(forwardTemp)) {
				forward = forwardTemp;
			}
		}

		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		TimeCounter.logCurrentTime("Action-deleteall", false, getClass());
		if (messages.hasError())
			return getActionForward(forward, mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);
	}
}

