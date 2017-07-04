package com.landray.kmss.tib.sys.core.provider.actions;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ArrayUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionRedirect;
import org.hibernate.Session;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.authorization.interfaces.SysAuthAreaUtils;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceService;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreTagService;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;


/**
 * 标签信息 Action
 * 
 * @author 
 * @version 1.0 2013-03-27
 */
public class TibSysCoreTagAction extends ExtendAction {
	protected ITibSysCoreTagService tibSysCoreTagService;
	protected ITibSysCoreIfaceService tibSysCoreIfaceService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSysCoreTagService == null)
			tibSysCoreTagService = (ITibSysCoreTagService)getBean("tibSysCoreTagService");
		return tibSysCoreTagService;
	}
	
	protected IBaseService getIfaceServiceImp(HttpServletRequest request) {
		if(tibSysCoreIfaceService == null)
			tibSysCoreIfaceService = (ITibSysCoreIfaceService)getBean("tibSysCoreIfaceService");
		return tibSysCoreIfaceService;
	}
	
	public ActionForward list(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-list", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			Session session = getServiceImp(request).getBaseDao().getHibernateSession();
			String hql = "SELECT fdIfaceTag.fdId, fdIfaceTag.fdTagName, count(tibSysCoreIface.fdId) " +
					"FROM com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface tibSysCoreIface " +
					"right join  tibSysCoreIface.fdIfaceTags fdIfaceTag group by fdIfaceTag.fdId, fdIfaceTag.fdTagName";
			List<Object[]> list = session.createQuery(hql).list();
			// 查询其他标签
			String hql2 = "SELECT tibSysCoreIface.fdId " +
					"FROM com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface tibSysCoreIface " +
					"left join  tibSysCoreIface.fdIfaceTags fdIfaceTag where fdIfaceTag is null";
			int size = session.createQuery(hql2).list().size();
			list.add(new Object[]{"", "其他", size});
			request.setAttribute("list", list);
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-list", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("list", mapping, form, request, response);
		}
	}
	
	public ActionForward deleteall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-deleteall", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String ids = request.getParameter("List_Selected");
			String[] idArr = ids.split(",");
			if (ISysAuthConstant.IS_AREA_ENABLED) {
				String[] authIds = SysAuthAreaUtils.removeNoAuthIds(idArr,
						request, "method=delete&fdId=${id}");
				int noAuthIdNum = idArr.length - authIds.length;
				if (noAuthIdNum > 0) {
					messages.addMsg(new KmssMessage(
							"sys-authorization:area.batch.operation.info",
							noAuthIdNum));
				}

				if (!ArrayUtils.isEmpty(authIds))
					getServiceImp(request).delete(authIds);
			} else if (idArr != null) {
				getServiceImp(request).delete(idArr);
			}

		} catch (Exception e) {
			messages.addError(e);
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		TimeCounter.logCurrentTime("Action-deleteall", false, getClass());
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else {
			ActionRedirect redirect = new ActionRedirect(mapping.findForward("actionList"));
			return redirect;
		}
			
	}
}

