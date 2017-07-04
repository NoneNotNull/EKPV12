package com.landray.kmss.tib.jdbc.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ArrayUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.authorization.interfaces.SysAuthAreaUtils;
import com.landray.kmss.tib.jdbc.forms.TibJdbcTaskCategoryForm;
import com.landray.kmss.tib.jdbc.model.TibJdbcTaskCategory;
import com.landray.kmss.tib.jdbc.service.ITibJdbcTaskCategoryService;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;


/**
 * 任务分类 Action
 * 
 * @author 
 * @version 1.0 2013-07-24
 */
public class TibJdbcTaskCategoryAction extends ExtendAction {
	protected ITibJdbcTaskCategoryService tibJdbcTaskCategoryService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibJdbcTaskCategoryService == null)
			tibJdbcTaskCategoryService = (ITibJdbcTaskCategoryService)getBean("tibJdbcTaskCategoryService");
		return tibJdbcTaskCategoryService;
	}
	
	
	@Override
	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		String parentId = request.getParameter("parentId");
		TibJdbcTaskCategoryForm categoryForm = (TibJdbcTaskCategoryForm) super
				.createNewForm(mapping, form, request, response);
		if (StringUtil.isNotNull(parentId)) {
			TibJdbcTaskCategory category = (TibJdbcTaskCategory) getServiceImp(request)
					.findByPrimaryKey(parentId);
			if (category != null) {
				// 设置父类
				categoryForm.setFdParentId(category.getFdId());
				categoryForm.setFdParentName(category.getFdName());
			}
		}
		return categoryForm;
	}
	
	
	public ActionForward deleteall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-deleteall", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String[] ids = request.getParameterValues("List_Selected_Node");

			if (ISysAuthConstant.IS_AREA_ENABLED) {
				String[] authIds = SysAuthAreaUtils.removeNoAuthIds(ids,
						request, "method=delete&fdId=${id}");
				int noAuthIdNum = ids.length - authIds.length;
				if (noAuthIdNum > 0) {
					messages.addMsg(new KmssMessage(
							"sys-authorization:area.batch.operation.info",
							noAuthIdNum));
				}

				if (!ArrayUtils.isEmpty(authIds))
					getServiceImp(request).delete(authIds);
			} else if (ids != null) {
				getServiceImp(request).delete(ids);
			}

		} catch (Exception e) {
			messages.addError(e);
		}

		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		TimeCounter.logCurrentTime("Action-deleteall", false, getClass());
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("tree", mapping, form, request, response);
	}
}

