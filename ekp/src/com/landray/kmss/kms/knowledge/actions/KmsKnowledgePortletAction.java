package com.landray.kmss.kms.knowledge.actions;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.simple.JSONObject;

import com.landray.kmss.common.actions.DataAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseDocService;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.kms.knowledge.service.spring.KmsKnowledgePortletService;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeUtil;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;

public class KmsKnowledgePortletAction extends DataAction {

	protected IKmsKnowledgeCategoryService kmsKnowledgeCategoryService;

	protected IKmsKnowledgeCategoryService getCategoryServiceImp(
			HttpServletRequest request) {
		if (kmsKnowledgeCategoryService == null)
			kmsKnowledgeCategoryService = (IKmsKnowledgeCategoryService) getBean("kmsKnowledgeCategoryService");
		return kmsKnowledgeCategoryService;
	}

	protected IKmsKnowledgeBaseDocService kmsKnowledgeBaseDocService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmsKnowledgeBaseDocService == null)
			kmsKnowledgeBaseDocService = (IKmsKnowledgeBaseDocService) getBean("kmsKnowledgeBaseDocService");
		return kmsKnowledgeBaseDocService;
	}

	protected KmsKnowledgePortletService kmsKnowledgePortletService;

	protected KmsKnowledgePortletService getKnowledgePortletServiceImp(
			HttpServletRequest request) {
		if (kmsKnowledgePortletService == null) {
			kmsKnowledgePortletService = (KmsKnowledgePortletService) getBean("kmsKnowledgePortletService");
		}
		return kmsKnowledgePortletService;
	}

	protected String getParentProperty() {
		return "docCategory";
	}

	/**
	 * 推荐知识数据
	 */
	public ActionForward getIntroKnowledge(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			String parentId = request.getParameter("categoryId");
			boolean isReserve = false;
			if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
				isReserve = true;
			}
			int pageno = 0;
			int rowsize = SysConfigParameters.getRowSize();
			if (s_pageno != null && s_pageno.length() > 0) {
				pageno = Integer.parseInt(s_pageno);
			}
			if (s_rowsize != null && s_rowsize.length() > 0) {
				rowsize = Integer.parseInt(s_rowsize);
			}
			if (isReserve)
				orderby += " desc";
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setOrderBy(" MAX(sysIntroduceMain.fdIntroduceTime) desc");
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);
			changeFindPageHQLInfo(request, hqlInfo);
			String whereBlock = hqlInfo.getWhereBlock();
			if (StringUtil.isNull(whereBlock)) {
				whereBlock = " 1=1 ";
			}
			hqlInfo
					.setSelectBlock(" distinct kmsKnowledgeBaseDoc,MAX(sysIntroduceMain.fdIntroduceTime)");
			hqlInfo
					.setJoinBlock(" ,com.landray.kmss.sys.introduce.model.SysIntroduceMain  sysIntroduceMain ");
			whereBlock += " and kmsKnowledgeBaseDoc.docIsIntroduced =:docIsIntroduced ";
			whereBlock += " and sysIntroduceMain.fdModelId = kmsKnowledgeBaseDoc.fdId";
			whereBlock += " and sysIntroduceMain.fdIntroduceToEssence = 1  GROUP BY  sysIntroduceMain.fdModelId";
			hqlInfo.setParameter("docIsIntroduced", true);
			hqlInfo.setGetCount(false);
			if (!StringUtil.isNull(parentId)) {
				whereBlock += " and kmsKnowledgeBaseDoc.docCategory.fdHierarchyId like :fdHierarchyId";
				hqlInfo.setParameter("fdHierarchyId", "%" + parentId + "%");
			}
			hqlInfo.setWhereBlock(whereBlock);
			List list = getServiceImp(request).findPage(hqlInfo).getList();
			JSONArray rtnArray = this.getIntroArray(request, list);
			request.setAttribute("lui-source", rtnArray);
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("failure");
		} else {
			return getActionForward("lui-source", mapping, form, request,
					response);
		}

	}

	/**
	 * 封装推荐知识
	 * 
	 * @param request
	 * @param hqlInfo
	 * @return
	 */
	private JSONArray getIntroArray(HttpServletRequest request,
			List knowledgeList) throws Exception {
		JSONArray rtnArray = new JSONArray();
		if (knowledgeList != null) {
			for (int i = 0; i < knowledgeList.size(); i++) {
				KmsKnowledgeBaseDoc kmsKnowledgeBaseDoc = (KmsKnowledgeBaseDoc) ((Object[]) knowledgeList
						.get(i))[0];
				JSONObject json = new JSONObject();
				json.put("text", kmsKnowledgeBaseDoc.getDocSubject());
				json.put("image", KmsKnowledgeUtil
						.getImgUrl(kmsKnowledgeBaseDoc));
				json
						.put(
								"href",
								"/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdId="
										+ kmsKnowledgeBaseDoc.getFdId()
										+ "&fdKnowledgeType="
										+ kmsKnowledgeBaseDoc
												.getFdKnowledgeType());
				rtnArray.add(json);
			}
		}
		return rtnArray;
	}

	/**
	 * 获取门户知识
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward getKnowledge(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-getKnowledge", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			JSONArray rtnArray = getKnowledgePortletServiceImp(request)
					.findPortlet(request);
			request.setAttribute("lui-source", rtnArray);
		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-getKnowledge", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("failure");
		} else {
			return getActionForward("lui-source", mapping, form, request,
					response);
		}
	}


}