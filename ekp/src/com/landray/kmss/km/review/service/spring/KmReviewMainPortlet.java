package com.landray.kmss.km.review.service.spring;

import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.km.review.service.IKmReviewMainService;
import com.landray.kmss.sys.category.interfaces.CategoryUtil;
import com.landray.kmss.sys.workflow.interfaces.SysFlowUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * 我的流程portlet(待我审批的流程、我已审批的流程、我审批的所有流程；我起草的待审、发布、草稿和所有流程)
 * 
 * @author zhuangwl 2010-六月-19
 */
public class KmReviewMainPortlet implements IXMLDataBean {

	private IKmReviewMainService kmReviewMainService;

	public void setKmReviewMainService(IKmReviewMainService kmReviewMainService) {
		this.kmReviewMainService = kmReviewMainService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		String owner = requestInfo.getParameter("owner");// 是否是我审批的
		String status = requestInfo.getParameter("status");
		String myFlow = requestInfo.getParameter("myFlow");
		if (StringUtil.isNotNull(owner)) {
			return getOwnerData(requestInfo, status);
		} else {
			return getMyFlowDate(requestInfo, myFlow);
		}
	}

	private List getOwnerData(RequestContext requestInfo, String status)
			throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		String param = requestInfo.getParameter("rowsize");
		int rowsize = 8;
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
		Page page = kmReviewMainService.findPage(hqlInfo);
		List rtnList = page.getList();
		return rtnList;
	}

	private List getMyFlowDate(RequestContext requestInfo, String myFlow)
			throws Exception {
		String param = requestInfo.getParameter("rowsize");
		int rowsize = 8;
		if (!StringUtil.isNull(param))
			rowsize = Integer.parseInt(param);
		String whereBlock = getTemplateString(requestInfo);
		HQLInfo hqlInfo = new HQLInfo();
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
		Page page = kmReviewMainService.findPage(hqlInfo);
		List rtnList = page.getList();
		return rtnList;
	}
	//分类ID的查询语句
	private String getTemplateString(RequestContext requestInfo)
			throws Exception {
		String fdCategoryId = requestInfo.getParameter("fdCategoryId");
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
