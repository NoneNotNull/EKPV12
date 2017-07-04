package com.landray.kmss.kms.multidoc.actions;

import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.kms.common.util.PageBean;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.sys.workflow.interfaces.SysFlowUtil;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.sunbor.web.tag.Page;

/**
 * KMS个人主页 我的知识
 * 
 * @author yangf 20110922
 */
public class KmsMultidocKnowledgePersonalAction extends ExtendAction {

	@Override
	protected IBaseService getServiceImp(HttpServletRequest request) {
		return null;
	}

	private IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;

	public IKmsMultidocKnowledgeService getKmsMultidocKnowledgeService() {
		if (kmsMultidocKnowledgeService == null) {
			kmsMultidocKnowledgeService = (IKmsMultidocKnowledgeService) getBean("kmsMultidocKnowledgeService");
		}
		return kmsMultidocKnowledgeService;
	}

	/*
	 * 我的知识
	 */
	public ActionForward myDoc(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-myKmDoc", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			boolean isReserve = false;
			if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
				isReserve = true;
			}
			int pageno = 0;
			int rowsize = 5;
			if (s_pageno != null && s_pageno.length() > 0) {
				pageno = Integer.parseInt(s_pageno);
			}
			if (s_rowsize != null && s_rowsize.length() > 0) {
				rowsize = Integer.parseInt(s_rowsize);
			}
			if (isReserve)
				orderby += " desc";

			String fdPersonId = request.getParameter("fdPersonId");
			String docStatus = request.getParameter("docStatus");
			String isDocStatusEqual = docStatus.equals("30") ? "=" : "<>";
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setOrderBy(orderby);
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);
			hqlInfo
					.setWhereBlock("kmsMultidocKnowledge.docCreator.fdId = :fdPersonId and kmsMultidocKnowledge.docStatus "
							+ isDocStatusEqual
							+ " '"
							+ SysDocConstant.DOC_STATUS_PUBLISH + "'");
			hqlInfo.setParameter("fdPersonId", fdPersonId);

			Page page = getKmsMultidocKnowledgeService().findPage(hqlInfo);
			page.setPagingListSize(6);
			List<KmsMultidocKnowledge> docList = page.getList();
			Iterator<KmsMultidocKnowledge> iterator = docList.iterator();

			// 拼装json对象
			JSONArray itemList = new JSONArray();
			while (iterator.hasNext()) {
				KmsMultidocKnowledge doc = iterator.next();
				JSONObject dataObject = new JSONObject();
				dataObject.put("fdId", doc.getFdId());
				dataObject.put("docSubject", doc.getDocSubject());
				dataObject.put("docTemplateName", doc.getDocCategory()
						.getFdName());
				dataObject.put("docAuthorName",
						doc.getDocAuthor() != null ? doc.getDocAuthor()
								.getFdName() : doc.getOuterAuthor());
				dataObject.put("docReadCount", doc.getDocReadCount());
				dataObject.put("docEvalCount", doc.getDocEvalCount());
				dataObject.put("docCreateTime", DateUtil.convertDateToString(
						doc.getDocCreateTime(), DateUtil.TYPE_DATETIME, request
								.getLocale()));
				itemList.add(dataObject);
			}

			PageBean pageBean = new PageBean(page);
			pageBean.setItemList(itemList);
			// 写入http头部信息，输出json文本
			response.setContentType("application/jsonp");
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.println(pageBean.toString(1));
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-myKmDoc", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("failure");
		}
		return null;
	}

	/*
	 * 我的审批
	 */
	public ActionForward myReview(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-myReview", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			boolean isReserve = false;
			if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
				isReserve = true;
			}
			int pageno = 0;
			int rowsize = 5;
			if (s_pageno != null && s_pageno.length() > 0) {
				pageno = Integer.parseInt(s_pageno);
			}
			if (s_rowsize != null && s_rowsize.length() > 0) {
				rowsize = Integer.parseInt(s_rowsize);
			}
			if (isReserve)
				orderby += " desc";

			// 工作流状态
			String flowStatus = request.getParameter("flowStatus");
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setOrderBy(orderby);
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);
			if ("1".equals(flowStatus)) {
				SysFlowUtil.buildLimitBlockForMyApproved(
						"kmsMultidocKnowledge", hqlInfo);

			}
			if ("0".equals(flowStatus)) {
				SysFlowUtil.buildLimitBlockForMyApproval(
						"kmsMultidocKnowledge", hqlInfo);
			}

			Page page = getKmsMultidocKnowledgeService().findPage(hqlInfo);
			page.setPagingListSize(6);
			List<KmsMultidocKnowledge> docList = page.getList();
			Iterator<KmsMultidocKnowledge> iterator = docList.iterator();

			// 拼装json对象
			JSONArray itemList = new JSONArray();
			while (iterator.hasNext()) {
				KmsMultidocKnowledge doc = iterator.next();
				JSONObject dataObject = new JSONObject();
				dataObject.put("fdId", doc.getFdId());
				dataObject.put("docSubject", doc.getDocSubject());
				dataObject.put("docTemplateName", doc.getDocCategory()
						.getFdName());
				dataObject.put("docAuthorName",
						doc.getDocAuthor() != null ? doc.getDocAuthor()
								.getFdName() : doc.getOuterAuthor());
				dataObject.put("docReadCount", doc.getDocReadCount());
				dataObject.put("docEvalCount", doc.getDocEvalCount());
				dataObject.put("docCreateTime", DateUtil.convertDateToString(
						doc.getDocCreateTime(), DateUtil.TYPE_DATETIME, request
								.getLocale()));
				itemList.add(dataObject);
			}

			PageBean pageBean = new PageBean(page);
			pageBean.setItemList(itemList);
			// 写入http头部信息，输出json文本
			response.setContentType("application/jsonp");
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.println(pageBean.toString(1));
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-myReview", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("failure");
		}
		return null;
	}

	/*
	 * 我的点评
	 */
	public ActionForward myEvaluate(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-myReview", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			boolean isReserve = false;
			if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
				isReserve = true;
			}
			int pageno = 0;
			int rowsize = 5;
			if (s_pageno != null && s_pageno.length() > 0) {
				pageno = Integer.parseInt(s_pageno);
			}
			if (s_rowsize != null && s_rowsize.length() > 0) {
				rowsize = Integer.parseInt(s_rowsize);
			}
			if (isReserve)
				orderby += " desc";

			String fdPersonId = request.getParameter("fdPersonId");
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setOrderBy(orderby);
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);

			StringBuffer hqlBuffer = new StringBuffer();
			hqlBuffer.append("kmsMultidocKnowledge.fdId in ");
			// 拼接子查询
			hqlBuffer
					.append("(select distinct sysEvaluationMain.fdModelId from ");
			hqlBuffer
					.append(" com.landray.kmss.sys.evaluation.model.SysEvaluationMain"
							+ " as sysEvaluationMain ");
			hqlBuffer
					.append("where sysEvaluationMain.fdModelName = :fdModelName ");
			hqlBuffer
					.append("and sysEvaluationMain.fdEvaluator.fdId = :fdEvaluatorId)");

			hqlInfo.setWhereBlock(hqlBuffer.toString());
			hqlInfo.setParameter("fdModelName",
					"com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge");
			hqlInfo.setParameter("fdEvaluatorId", fdPersonId);

			Page page = getKmsMultidocKnowledgeService().findPage(hqlInfo);
			page.setPagingListSize(6);
			List<KmsMultidocKnowledge> docList = page.getList();
			Iterator<KmsMultidocKnowledge> iterator = docList.iterator();

			// 拼装json对象
			JSONArray itemList = new JSONArray();
			while (iterator.hasNext()) {
				KmsMultidocKnowledge doc = iterator.next();
				JSONObject dataObject = new JSONObject();
				dataObject.put("fdId", doc.getFdId());
				dataObject.put("docSubject", doc.getDocSubject());
				dataObject.put("docTemplateName", doc.getDocCategory()
						.getFdName());
				dataObject.put("docAuthorName",
						doc.getDocAuthor() != null ? doc.getDocAuthor()
								.getFdName() : doc.getOuterAuthor());
				dataObject.put("docReadCount", doc.getDocReadCount());
				dataObject.put("docEvalCount", doc.getDocEvalCount());
				dataObject.put("docCreateTime", DateUtil.convertDateToString(
						doc.getDocCreateTime(), DateUtil.TYPE_DATETIME, request
								.getLocale()));
				itemList.add(dataObject);
			}

			PageBean pageBean = new PageBean(page);
			pageBean.setItemList(itemList);
			// 写入http头部信息，输出json文本
			response.setContentType("application/jsonp");
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.println(pageBean.toString(1));
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-myReview", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("failure");
		}
		return null;
	}

	/*
	 * 我的推荐
	 */
	public ActionForward myIntroduce(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-myReview", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			boolean isReserve = false;
			if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
				isReserve = true;
			}
			int pageno = 0;
			int rowsize = 5;
			if (s_pageno != null && s_pageno.length() > 0) {
				pageno = Integer.parseInt(s_pageno);
			}
			if (s_rowsize != null && s_rowsize.length() > 0) {
				rowsize = Integer.parseInt(s_rowsize);
			}
			if (isReserve)
				orderby += " desc";

			String fdPersonId = request.getParameter("fdPersonId");
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setOrderBy(orderby);
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);

			StringBuffer hqlBuffer = new StringBuffer();
			hqlBuffer.append("kmsMultidocKnowledge.fdId in ");
			// 拼接子查询
			hqlBuffer
					.append("(select distinct sysIntroduceMain.fdModelId from ");
			hqlBuffer
					.append(" com.landray.kmss.sys.introduce.model.SysIntroduceMain"
							+ " as sysIntroduceMain ");
			hqlBuffer
					.append("where sysIntroduceMain.fdModelName = :fdModelName ");
			hqlBuffer
					.append("and sysIntroduceMain.fdIntroducer.fdId = :fdIntroducerId)");

			hqlInfo.setWhereBlock(hqlBuffer.toString());
			hqlInfo.setParameter("fdModelName",
					"com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge");
			hqlInfo.setParameter("fdIntroducerId", fdPersonId);

			Page page = getKmsMultidocKnowledgeService().findPage(hqlInfo);
			page.setPagingListSize(6);
			List<KmsMultidocKnowledge> docList = page.getList();
			Iterator<KmsMultidocKnowledge> iterator = docList.iterator();

			// 拼装json对象
			JSONArray itemList = new JSONArray();
			while (iterator.hasNext()) {
				KmsMultidocKnowledge doc = iterator.next();
				JSONObject dataObject = new JSONObject();
				dataObject.put("fdId", doc.getFdId());
				dataObject.put("docSubject", doc.getDocSubject());
				dataObject.put("docTemplateName", doc.getDocCategory()
						.getFdName());
				dataObject.put("docAuthorName",
						doc.getDocAuthor() != null ? doc.getDocAuthor()
								.getFdName() : doc.getOuterAuthor());
				dataObject.put("docReadCount", doc.getDocReadCount());
				dataObject.put("docIntrCount", doc.getDocIntrCount());
				dataObject.put("docCreateTime", DateUtil.convertDateToString(
						doc.getDocCreateTime(), DateUtil.TYPE_DATETIME, request
								.getLocale()));
				itemList.add(dataObject);
			}

			PageBean pageBean = new PageBean(page);
			pageBean.setItemList(itemList);
			// 写入http头部信息，输出json文本
			response.setContentType("application/jsonp");
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.println(pageBean.toString(1));
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-myReview", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("failure");
		}
		return null;
	}
}
