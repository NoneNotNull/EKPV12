package com.landray.kmss.km.review.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.constant.SysNotifyConstant;
import com.landray.kmss.km.review.Constant;
import com.landray.kmss.km.review.forms.KmReviewFeedbackInfoForm;
import com.landray.kmss.km.review.model.KmReviewMain;
import com.landray.kmss.km.review.service.IKmReviewFeedbackInfoService;
import com.landray.kmss.km.review.service.IKmReviewMainService;
import com.landray.kmss.sys.notify.interfaces.ISysNotifyMainCoreService;
import com.landray.kmss.sys.notify.interfaces.NotifyContext;
import com.landray.kmss.sys.organization.interfaces.ISysOrgCoreService;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌 反馈信息业务接口实现
 */
public class KmReviewFeedbackInfoServiceImp extends BaseServiceImp implements
		IKmReviewFeedbackInfoService {

	private IKmReviewMainService kmReviewMainService;

	private ISysOrgCoreService sysOrgCoreService;

	private ISysNotifyMainCoreService sysNotifyMainCoreService;

	@SuppressWarnings("unchecked")
	public String add(IExtendForm form, RequestContext requestContext)
			throws Exception {
		boolean isNeedUpdate = false;
		SysOrgElement receiver;
		KmReviewMain main = null;
		List notifyList = new ArrayList();
		KmReviewFeedbackInfoForm infoForm = (KmReviewFeedbackInfoForm) form;
		String mainId = infoForm.getFdMainId();

		String num = super.add(form, requestContext);
		String receiveIds[] = infoForm.getFdNotifyId().split(";");

		if (StringUtil.isNotNull(mainId)) {
			main = (KmReviewMain) kmReviewMainService.findByPrimaryKey(mainId);
			if (!Constant.STATUS_FEEDBACK.equals(main.getDocStatus())) {
				main.setDocStatus(Constant.STATUS_FEEDBACK);
				isNeedUpdate = true;
			}
		}
		if (!"".equals(receiveIds[0])
				&& StringUtil.isNotNull(((KmReviewFeedbackInfoForm) form)
						.getFdNotifyType())) {
			for (int i = 0; i < receiveIds.length; i++) {
				receiver = sysOrgCoreService.findByPrimaryKey(receiveIds[i]);
				notifyList.add(receiver);
			}
			if (main != null) {
				// 添加通知人到可阅读者里
				ArrayUtil.concatTwoList(notifyList, main.getAuthOtherReaders());
				isNeedUpdate = true;
			}
			HashMap map = new HashMap();
			map.put("km-review:kmReviewFeedbackInfo.fdSummary",
					((KmReviewFeedbackInfoForm) form).getFdSummary());
			NotifyContext notifyContext = sysNotifyMainCoreService
					.getContext("km-review:kmReview.feedbackLog.notify");
			notifyContext.setKey("passreadKey");
			notifyContext.setFlag(SysNotifyConstant.NOTIFY_TODOTYPE_ONCE);
			notifyContext.setNotifyType(((KmReviewFeedbackInfoForm) form)
					.getFdNotifyType());
			notifyContext.setNotifyTarget(notifyList);
			sysNotifyMainCoreService.send(main, notifyContext, map);
		}
		if (isNeedUpdate) {
			kmReviewMainService.update(main);
		}
		return num;
	}

	public IKmReviewMainService getKmReviewMainService() {
		return kmReviewMainService;
	}

	public void setKmReviewMainService(IKmReviewMainService kmReviewMainService) {
		this.kmReviewMainService = kmReviewMainService;
	}

	public void setSysOrgCoreService(ISysOrgCoreService sysOrgCoreService) {
		this.sysOrgCoreService = sysOrgCoreService;
	}

	public void setSysNotifyMainCoreService(
			ISysNotifyMainCoreService sysNotifyMainCoreService) {
		this.sysNotifyMainCoreService = sysNotifyMainCoreService;
	}

}
