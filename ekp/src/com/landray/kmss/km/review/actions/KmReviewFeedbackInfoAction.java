package com.landray.kmss.km.review.actions;

import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.km.review.forms.KmReviewFeedbackInfoForm;
import com.landray.kmss.km.review.model.KmReviewMain;
import com.landray.kmss.km.review.service.IKmReviewFeedbackInfoService;
import com.landray.kmss.km.review.service.IKmReviewMainService;
import com.landray.kmss.sys.authentication.user.KMSSUser;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaForm;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌
 */
public class KmReviewFeedbackInfoAction extends ExtendAction

{
	protected IKmReviewFeedbackInfoService kmReviewFeedbackInfoService;

	protected IKmReviewMainService kmReviewMainService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmReviewFeedbackInfoService == null)
			kmReviewFeedbackInfoService = (IKmReviewFeedbackInfoService) getBean("kmReviewFeedbackInfoService");
		return kmReviewFeedbackInfoService;
	}

	public IKmReviewMainService getKmReviewMainService() {
		if (kmReviewMainService == null)
			kmReviewMainService = (IKmReviewMainService) getBean("kmReviewMainService");
		return kmReviewMainService;
	}

	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		StringBuffer buffer = new StringBuffer();
		KmReviewFeedbackInfoForm feedbackInfo = (KmReviewFeedbackInfoForm) form;
		// 设置场所
		if (form instanceof ISysAuthAreaForm) {
			ISysAuthAreaForm sysAuthAreaForm = (ISysAuthAreaForm) form;
			KMSSUser user = UserUtil.getKMSSUser();
			sysAuthAreaForm.setAuthAreaId(user.getAuthAreaId());
			sysAuthAreaForm.setAuthAreaName(user.getAuthAreaName());
		}

		String mainId = feedbackInfo.getFdMainId();
		if (StringUtil.isNotNull(mainId)) {
			KmReviewMain main = (KmReviewMain) getKmReviewMainService()
					.findByPrimaryKey(mainId);
			List readerList = main.getAuthAllReaders();
			for (Iterator it = readerList.iterator(); it.hasNext();) {
				SysOrgElement reader = (SysOrgElement) it.next();
				buffer.append(reader.getFdName()).append("; ");
			}
			if (buffer.length() > 0) {
				feedbackInfo.setFdReaderNames(buffer.substring(0,
						buffer.length() - 1));
			}

		}
		feedbackInfo.setDocCreatorName(UserUtil.getUser().getFdName());
		feedbackInfo.setDocCreatorId(UserUtil.getUser().getFdId().toString());
		feedbackInfo.setDocCreatorTime(DateUtil.convertDateToString(new Date(),
				DateUtil.TYPE_DATETIME, request.getLocale()));
		return feedbackInfo;
	}

	public ActionForward add(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return super.add(mapping, form, request, response);
	}

	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		String whereBlock = hqlInfo.getWhereBlock();
		String mainId = request.getParameter("fdModelId");
		if (StringUtil.isNotNull(mainId)) {
			if (StringUtil.isNull(whereBlock)) {
				whereBlock = " kmReviewFeedbackInfo.kmReviewMain.fdId=:mainId";
			} else {
				whereBlock += " and kmReviewFeedbackInfo.kmReviewMain.fdId=:mainId";
			}
			hqlInfo.setParameter("mainId", mainId);
		}
		hqlInfo.setWhereBlock(whereBlock);
	}

	public ActionForward listdata(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		super.list(mapping, form, request, response);
		return mapping.findForward("listdata");
	}
}
