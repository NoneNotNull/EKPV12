package com.landray.kmss.kms.multidoc.service.portlet;

import java.util.Iterator;
import java.util.List;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.kms.common.service.spring.KmsBaseDataBeanService;
import com.landray.kmss.kms.common.util.PageBean;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.sys.workflow.interfaces.SysFlowUtil;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;

public class KmsDocKnowledgePersonalPortlet extends KmsBaseDataBeanService {

	public JSON myDoc(RequestContext request) throws Exception {

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
		String docStatus = request.getParameter("fdStatus");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setOrderBy(orderby);
		hqlInfo.setPageNo(pageno);
		hqlInfo.setRowSize(rowsize);
		String whereBlock = "kmsMultidocKnowledge.docCreator.fdId = :fdPersonId and kmsMultidocKnowledge.docIsNewVersion = :isNew";
		if (!docStatus.equals("all")) {
			whereBlock += " and kmsMultidocKnowledge.docStatus = :docStatus";
			hqlInfo.setParameter("docStatus", docStatus);
		}
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setParameter("fdPersonId", fdPersonId);
		hqlInfo.setParameter("isNew", true);
		Page page = kmsMultidocKnowledgeService.findPage(hqlInfo);
		page.setPagingListSize(6);
		List<KmsMultidocKnowledge> docList = page.getList();
		Iterator<KmsMultidocKnowledge> iterator = docList.iterator();

		// 拼装json对象
		JSONArray itemList = new JSONArray();
		while (iterator.hasNext()) {
			KmsMultidocKnowledge doc = iterator.next();
			JSONObject dataObject = new JSONObject();
			dataObject.put("fdId", doc.getFdId());
			dataObject.put("docSubject", StringUtil.XMLEscape(doc
					.getDocSubject()));
			dataObject.put("docTemplateName", StringUtil.XMLEscape(doc
					.getKmsMultidocTemplate().getFdName()));
			dataObject.put("docAuthorName", doc.getDocAuthor() != null ? doc
					.getDocAuthor().getFdName() : doc.getOuterAuthor());
			dataObject.put("docReadCount", doc.getDocReadCount());
			dataObject.put("docEvalCount", doc.getDocEvalCount());
			dataObject.put("docCreateTime", DateUtil.convertDateToString(doc
					.getDocCreateTime(), DateUtil.TYPE_DATETIME, request
					.getLocale()));
			itemList.add(dataObject);
		}

		PageBean pageBean = new PageBean(page);
		pageBean.setItemList(itemList);
		return pageBean;
	}

	public JSON myReview(RequestContext request) throws Exception {
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
			SysFlowUtil.buildLimitBlockForMyApproved("kmsMultidocKnowledge",
					hqlInfo);

		}
		if ("0".equals(flowStatus)) {
			SysFlowUtil.buildLimitBlockForMyApproval("kmsMultidocKnowledge",
					hqlInfo);
		}

		Page page = kmsMultidocKnowledgeService.findPage(hqlInfo);
		page.setPagingListSize(6);
		List<KmsMultidocKnowledge> docList = page.getList();
		Iterator<KmsMultidocKnowledge> iterator = docList.iterator();

		// 拼装json对象
		JSONArray itemList = new JSONArray();
		while (iterator.hasNext()) {
			KmsMultidocKnowledge doc = iterator.next();
			JSONObject dataObject = new JSONObject();
			dataObject.put("fdId", doc.getFdId());
			dataObject.put("docSubject", StringUtil.XMLEscape(doc
					.getDocSubject()));
			dataObject.put("docTemplateName", StringUtil.XMLEscape(doc
					.getKmsMultidocTemplate().getFdName()));
			dataObject.put("docAuthorName", doc.getDocAuthor() != null ? doc
					.getDocAuthor().getFdName() : doc.getOuterAuthor());
			dataObject.put("docReadCount", doc.getDocReadCount());
			dataObject.put("docEvalCount", doc.getDocEvalCount());
			dataObject.put("docCreateTime", DateUtil.convertDateToString(doc
					.getDocCreateTime(), DateUtil.TYPE_DATETIME, request
					.getLocale()));
			itemList.add(dataObject);
		}

		PageBean pageBean = new PageBean(page);
		pageBean.setItemList(itemList);
		return pageBean;
	}

	public JSON myEvaluate(RequestContext request) throws Exception {
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
		hqlBuffer.append("(select distinct sysEvaluationMain.fdModelId from ");
		hqlBuffer
				.append(" com.landray.kmss.sys.evaluation.model.SysEvaluationMain"
						+ " as sysEvaluationMain ");
		hqlBuffer.append("where sysEvaluationMain.fdModelName = :fdModelName ");
		hqlBuffer
				.append("and sysEvaluationMain.fdEvaluator.fdId = :fdEvaluatorId)");

		hqlInfo.setWhereBlock(hqlBuffer.toString());
		hqlInfo.setParameter("fdModelName",
				"com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge");
		hqlInfo.setParameter("fdEvaluatorId", fdPersonId);

		Page page = kmsMultidocKnowledgeService.findPage(hqlInfo);
		page.setPagingListSize(6);
		List<KmsMultidocKnowledge> docList = page.getList();
		Iterator<KmsMultidocKnowledge> iterator = docList.iterator();

		// 拼装json对象
		JSONArray itemList = new JSONArray();
		while (iterator.hasNext()) {
			KmsMultidocKnowledge doc = iterator.next();
			JSONObject dataObject = new JSONObject();
			dataObject.put("fdId", doc.getFdId());
			dataObject.put("docSubject", StringUtil.XMLEscape(doc
					.getDocSubject()));
			dataObject.put("docTemplateName", StringUtil.XMLEscape(doc
					.getKmsMultidocTemplate().getFdName()));
			dataObject.put("docAuthorName", doc.getDocAuthor() != null ? doc
					.getDocAuthor().getFdName() : doc.getOuterAuthor());
			dataObject.put("docReadCount", doc.getDocReadCount());
			dataObject.put("docEvalCount", doc.getDocEvalCount());
			dataObject.put("docCreateTime", DateUtil.convertDateToString(doc
					.getDocCreateTime(), DateUtil.TYPE_DATETIME, request
					.getLocale()));
			itemList.add(dataObject);
		}

		PageBean pageBean = new PageBean(page);
		pageBean.setItemList(itemList);
		return pageBean;

	}

	public JSON myIntroduce(RequestContext request) throws Exception {

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
		hqlBuffer.append("(select distinct sysIntroduceMain.fdModelId from ");
		hqlBuffer
				.append(" com.landray.kmss.sys.introduce.model.SysIntroduceMain"
						+ " as sysIntroduceMain ");
		hqlBuffer.append("where sysIntroduceMain.fdModelName = :fdModelName ");
		hqlBuffer
				.append("and sysIntroduceMain.fdIntroducer.fdId = :fdIntroducerId)");

		hqlInfo.setWhereBlock(hqlBuffer.toString());
		hqlInfo.setParameter("fdModelName",
				"com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge");
		hqlInfo.setParameter("fdIntroducerId", fdPersonId);

		Page page = kmsMultidocKnowledgeService.findPage(hqlInfo);
		page.setPagingListSize(6);
		List<KmsMultidocKnowledge> docList = page.getList();
		Iterator<KmsMultidocKnowledge> iterator = docList.iterator();

		// 拼装json对象
		JSONArray itemList = new JSONArray();
		while (iterator.hasNext()) {
			KmsMultidocKnowledge doc = iterator.next();
			JSONObject dataObject = new JSONObject();
			dataObject.put("fdId", doc.getFdId());
			dataObject.put("docSubject", StringUtil.XMLEscape(doc
					.getDocSubject()));
			dataObject.put("docTemplateName", StringUtil.XMLEscape(doc
					.getKmsMultidocTemplate().getFdName()));
			dataObject.put("docAuthorName", doc.getDocAuthor() != null ? doc
					.getDocAuthor().getFdName() : doc.getOuterAuthor());
			dataObject.put("docReadCount", doc.getDocReadCount());
			dataObject.put("docEvalCount", doc.getDocEvalCount());
			dataObject.put("docCreateTime", DateUtil.convertDateToString(doc
					.getDocCreateTime(), DateUtil.TYPE_DATETIME, request
					.getLocale()));
			itemList.add(dataObject);
		}

		PageBean pageBean = new PageBean(page);
		pageBean.setItemList(itemList);
		return pageBean;
	}

	private IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;

	public void setKmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

}
