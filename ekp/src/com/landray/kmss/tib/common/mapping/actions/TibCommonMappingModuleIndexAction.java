/**
 * 
 */
package com.landray.kmss.tib.common.mapping.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingModule;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;

/**
 * @author qiujh
 * @version 1.0 2013-12-9
 */
public class TibCommonMappingModuleIndexAction extends ExtendAction {
	protected ITibCommonMappingModuleService tibCommonMappingModuleService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (tibCommonMappingModuleService == null)
			tibCommonMappingModuleService = (ITibCommonMappingModuleService) getBean("tibCommonMappingModuleService");
		return tibCommonMappingModuleService;
	}

	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		// 新UED查询
		CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
				TibCommonMappingModule.class);
	}
	
	public ActionForward uiTreeView(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		TimeCounter.logCurrentTime("Action-index", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			//String id = request.getParameter("id");
			//String path = "javascript:openPage('"+ request.getContextPath()+"/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do";
			JSONArray array = ((ITibCommonMappingModuleService)getServiceImp(request)).treeView(request);
			request.setAttribute("lui-source", array);
			//request.setAttribute("treeUrl", "/tib/common/log/tib_common_log_manage/tibCommonLogManage.do?method=uiTreeView&type=!{value}");
		} catch (Exception e) {
			messages.addError(e);
			e.printStackTrace();
		}

		TimeCounter.logCurrentTime("Action-index", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("lui-source", mapping, form, request,
					response);
		}
	}
	
}
