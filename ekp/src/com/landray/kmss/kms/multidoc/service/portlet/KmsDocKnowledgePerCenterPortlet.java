package com.landray.kmss.kms.multidoc.service.portlet;

import net.sf.json.JSON;
import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.constant.SysNotifyConstant;
import com.landray.kmss.kms.common.interfaces.IKmsDataBean;
import com.landray.kmss.kms.common.util.PluginUtil;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.sys.bookmark.service.ISysBookmarkMainService;
import com.landray.kmss.sys.notify.service.ISysNotifyTodoService;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.util.UserUtil;

/**
 * 个人知识中心
 * 
 * @author hongzq
 * 
 */
public class KmsDocKnowledgePerCenterPortlet implements IKmsDataBean {

	public JSON getDataJSON(RequestContext requestInfo) throws Exception {
		JSONObject jsonObject = new JSONObject();
		SysOrgPerson user = UserUtil.getUser();
		String personId = user.getFdId();
		// 待办
		Long manualCount = sysNotifyTodoService.getTodoCount(personId,
				SysNotifyConstant.NOTIFY_TODOTYPE_MANUAL);
		// 待阅
		Long onceCount = sysNotifyTodoService.getTodoCount(personId,
				SysNotifyConstant.NOTIFY_TODOTYPE_ONCE);
		// 收藏
		int bookCount = getBookCount();
		// 知识
		int docCount = getDocCount();
		jsonObject.put("manualCount", manualCount);
		jsonObject.put("onceCount", onceCount);
		jsonObject.put("bookCount", bookCount);
		jsonObject.put("docCount", docCount);
		jsonObject.put("hasDoc", PluginUtil.isExist("/kms/multidoc"));
		jsonObject.put("hasWiki", PluginUtil.isExist("/kms/wiki"));
		jsonObject.put("hasAsk", PluginUtil.isExist("/kms/ask"));
		jsonObject.put("hasExpert", PluginUtil.isExist("/kms/expert"));
		jsonObject.put("userId", UserUtil.getUser().getFdId());
		return jsonObject;
	}

	/**
	 * 获取收藏总数
	 * 
	 * @return
	 * @throws Exception
	 */
	private int getBookCount() throws Exception {
		HQLInfo info = new HQLInfo();
		info.setSelectBlock("count(*)");
		return ((Number) sysBookmarkMainService.findValue(info).iterator()
				.next()).intValue();
	}

	/**
	 * 获取知识总数~multidoc
	 * 
	 * @return
	 * @throws Exception
	 */
	private int getDocCount() throws Exception {
		HQLInfo info = new HQLInfo();
		info.setSelectBlock("count(*)");
		info
				.setWhereBlock("kmsMultidocKnowledge.docStatus=:docStatus  and kmsMultidocKnowledge.docIsNewVersion = :docIsNewVersion");
		info.setParameter("docStatus", SysDocConstant.DOC_STATUS_PUBLISH);
		info.setParameter("docIsNewVersion", true);
		return ((Number) kmsMultidocKnowledgeService.findValue(info).iterator()
				.next()).intValue();
	}

	private ISysNotifyTodoService sysNotifyTodoService;

	public void setSysNotifyTodoService(
			ISysNotifyTodoService sysNotifyTodoService) {
		this.sysNotifyTodoService = sysNotifyTodoService;
	}

	private ISysBookmarkMainService sysBookmarkMainService;

	public void setSysBookmarkMainService(
			ISysBookmarkMainService sysBookmarkMainService) {
		this.sysBookmarkMainService = sysBookmarkMainService;
	}

	private IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;

	public void setKmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

}
