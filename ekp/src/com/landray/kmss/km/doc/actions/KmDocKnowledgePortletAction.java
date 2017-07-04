package com.landray.kmss.km.doc.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.km.doc.service.IKmDocKnowledgeService;
import com.landray.kmss.sys.portal.util.PortletTimeUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖
 */
public class KmDocKnowledgePortletAction extends ExtendAction {
	protected IKmDocKnowledgeService kmDocKnowledgeService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmDocKnowledgeService == null)
			kmDocKnowledgeService = (IKmDocKnowledgeService) getBean("kmDocKnowledgeService");
		return kmDocKnowledgeService;
	}

	public ActionForward listPortlet(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-list", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String rowsize = (String) request.getParameter("rowsize");
			String mydoc = (String) request.getParameter("mydoc");
			HQLInfo hqlInfo = new HQLInfo();
			if (StringUtil.isNotNull(rowsize)) {
				hqlInfo.setRowSize(Integer.parseInt(rowsize));
			}
			String whereBlock = "1=1";
			if (StringUtil.isNotNull(mydoc)) {
				// 我上传的知识（不包括草稿\驳回\废弃）
				if (mydoc.equals("mycreate")) {
					whereBlock += " and kmDocKnowledge.docCreator=:docCreator and kmDocKnowledge.docStatus not in (:docstatus)";
					hqlInfo.setParameter("docCreator", UserUtil.getUser());
					hqlInfo.setParameter("docstatus", "["
							+ SysDocConstant.DOC_STATUS_DRAFT + ","
							+ SysDocConstant.DOC_STATUS_REFUSE + ","
							+ SysDocConstant.DOC_STATUS_DISCARD + "]");
					hqlInfo.setWhereBlock(whereBlock);
				}
				// 我点评的知识
				else if (mydoc.equals("myevaluate")) {
					StringBuffer hqlBuffer = new StringBuffer();
					hqlBuffer.append("kmDocKnowledge.fdId in ");
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
							"com.landray.kmss.km.doc.model.KmDocKnowledge");
					hqlInfo.setParameter("fdEvaluatorId", UserUtil.getUser()
							.getFdId());
				}
				// 我推荐的知识
				else if (mydoc.equals("myinstroduce")) {

					StringBuffer hqlBuffer = new StringBuffer();
					hqlBuffer.append("kmDocKnowledge.fdId in ");
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
							"com.landray.kmss.km.doc.model.KmDocKnowledge");
					hqlInfo.setParameter("fdIntroducerId", UserUtil.getUser()
							.getFdId());

				}
			}
			if (StringUtil.isNull(hqlInfo.getOrderBy())) {
				hqlInfo
						.setOrderBy("kmDocKnowledge.docAlterTime desc,kmDocKnowledge.docPublishTime desc,kmDocKnowledge.docCreateTime desc");
			}
			// 时间范围参数
			String scope = request.getParameter("scope");
			if (StringUtil.isNotNull(scope) && !scope.equals("no")) {
				String block = hqlInfo.getWhereBlock();
				hqlInfo.setWhereBlock(StringUtil.linkString(block, " and ",
						"kmDocKnowledge.docCreateTime > :fdStartTime"));
				hqlInfo.setParameter("fdStartTime", PortletTimeUtil
						.getDateByScope(scope));
			}
			hqlInfo.setWhereBlock(StringUtil.linkString(
					hqlInfo.getWhereBlock(), " and ",
					"kmDocKnowledge.docIsNewVersion = 1"));
			hqlInfo.setGetCount(false);
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("queryPage", page);
		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-list", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("listPortlet", mapping, form, request,
					response);
		}
	}

}