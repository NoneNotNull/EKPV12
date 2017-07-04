package com.landray.kmss.km.review.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.km.review.service.IKmReviewMainService;
import com.landray.kmss.sys.category.interfaces.CategoryUtil;
import com.landray.kmss.sys.portal.util.PortletTimeUtil;
import com.landray.kmss.sys.workflow.interfaces.SysFlowUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * 创建日期 2013-11-16
 * 
 * @author 朱湖强
 */
public class KmReviewMainPortletAction extends ExtendAction {
	protected IKmReviewMainService kmReviewMainService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmReviewMainService == null)
			kmReviewMainService = (IKmReviewMainService) getBean("kmReviewMainService");
		return kmReviewMainService;
	}

	
	public ActionForward listPortlet(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-listPortlet", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String owner = request.getParameter("owner");// 是否是我审批的
			String status = request.getParameter("status");
			String myFlow = request.getParameter("myFlow");
			HQLInfo hqlInfo = new HQLInfo();
			if (StringUtil.isNotNull(owner)) {
				getOwnerData(request, status, hqlInfo);
			} else {
				getMyFlowDate(request, myFlow,hqlInfo);
			}
			hqlInfo.setGetCount(false);
			//时间范围参数
		      String scope=request.getParameter("scope");
		      if(StringUtil.isNotNull(scope)&&!scope.equals("no")){
		        String block=hqlInfo.getWhereBlock();
		        if ("all".equals(myFlow)) {
		        	hqlInfo.setWhereBlock(StringUtil.linkString(block, " and ","kmReviewMain.docPublishTime > :fdStartTime"));
		        }else{
		        	hqlInfo.setWhereBlock(StringUtil.linkString(block, " and ","kmReviewMain.docCreateTime > :fdStartTime"));
		        }
		        hqlInfo.setParameter("fdStartTime",PortletTimeUtil.getDateByScope(scope));
		      }
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("queryPage", page);
		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-listPortlet", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("listPortlet", mapping, form, request,
					response);
		}
	}
	

	private void getOwnerData(HttpServletRequest request, String status,HQLInfo hqlInfo)
			throws Exception {
		
		String param = request.getParameter("rowsize");
		int rowsize = 6;
		if (!StringUtil.isNull(param))
			rowsize = Integer.parseInt(param);
		String whereBlock = "";
		if ("all".equals(status)) {
			whereBlock = StringUtil.linkString(whereBlock, " AND ",
					"kmReviewMain.docCreator.fdId=:creatorId");
			hqlInfo.setParameter("creatorId", UserUtil.getUser().getFdId());
		} else {
			whereBlock = StringUtil.linkString(whereBlock, " AND ",
					"kmReviewMain.docStatus=:docStatus AND kmReviewMain.docCreator.fdId=:creatorId");
			hqlInfo.setParameter("docStatus", status);
			hqlInfo.setParameter("creatorId", UserUtil.getUser().getFdId());
		}
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo
				.setOrderBy("kmReviewMain.docPublishTime desc , kmReviewMain.docCreateTime desc");
		hqlInfo.setRowSize(rowsize);
		hqlInfo.setPageNo(1);
		hqlInfo.setGetCount(false);
	}

	private void getMyFlowDate(HttpServletRequest request, String myFlow,HQLInfo hqlInfo)
			throws Exception {
		String param = request.getParameter("rowsize");
		int rowsize = 6;
		if (!StringUtil.isNull(param))
			rowsize = Integer.parseInt(param);
		String whereBlock = getTemplateString(request);
		if ("executed".equals(myFlow)) {
			SysFlowUtil.buildLimitBlockForMyApproved("kmReviewMain", hqlInfo);
		} else if ("unExecuted".equals(myFlow)) {
			SysFlowUtil.buildLimitBlockForMyApproval("kmReviewMain", hqlInfo);
		} else if ("all".equals(myFlow)) {
			hqlInfo.setWhereBlock(whereBlock);
		}
		hqlInfo
				.setOrderBy("kmReviewMain.docPublishTime desc , kmReviewMain.docCreateTime desc");
		hqlInfo.setRowSize(rowsize);
		hqlInfo.setPageNo(1);
		hqlInfo.setGetCount(false);
	}
	//分类ID的查询语句
	private String getTemplateString(HttpServletRequest request)
			throws Exception {
		String fdCategoryId = request.getParameter("fdCategoryId");
		StringBuffer whereBlock = new StringBuffer();
		if (StringUtil.isNotNull(fdCategoryId)) {
			// 选择的分类
			String templateProperty = "kmReviewMain.fdTemplate";
			whereBlock.append(CategoryUtil.buildChildrenWhereBlock(
					fdCategoryId, null, templateProperty));
		} else {
			whereBlock.append("1=1 ");
		}
		return whereBlock.toString();

	}

}
