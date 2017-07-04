package com.landray.kmss.tib.sys.soap.connector.actions;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.ArrayUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.authorization.interfaces.SysAuthAreaUtils;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.tib.sys.soap.connector.forms.TibSysSoapSettCategoryForm;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettCategoryService;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.StringUtil;


/**
 * 分类信息 Action
 * 
 * @author kezm
 * @version 1.0 2013-06-16
 */
public class TibSysSoapSettCategoryAction extends ExtendAction {
	protected ITibSysSoapSettCategoryService tibSysSoapSettCategoryService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSysSoapSettCategoryService == null)
			tibSysSoapSettCategoryService = (ITibSysSoapSettCategoryService)getBean("tibSysSoapSettCategoryService");
		return tibSysSoapSettCategoryService;
	}
	
	@Override
	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		String parentId = request.getParameter("parentId");
		TibSysSoapSettCategoryForm categoryForm = (TibSysSoapSettCategoryForm) super
				.createNewForm(mapping, form, request, response);
		if (StringUtil.isNotNull(parentId)) {
			TibSysSoapSettCategoryForm category = (TibSysSoapSettCategoryForm) getServiceImp(request)
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
	
	/**
	 * 新UED展现分类树
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward uiCateTree(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-currentCate", true, getClass());
		KmssMessages messages = new KmssMessages();
		String currId = request.getParameter("categoryId");
		String modelName = request.getParameter("modelName");
		JSONArray array = new JSONArray();
		if (StringUtil.isNotNull(currId)) {
			SysDictModel cateModel = SysDataDict.getInstance().getModel(
					modelName);
			IBaseService service = (IBaseService) getBean(cateModel
					.getServiceBean());
			String tableName = ModelUtil.getModelTableName(modelName);
			Object[] cate = findOne(service, tableName, currId, request);
			JSONObject json = new JSONObject();
			if (cate != null) {
				json.put("text", cate[0]);
				json.put("value", cate[1]);
			}
			array.element(json);

			request.setAttribute("lui-source", array);
		}
		TimeCounter.logCurrentTime("Action-currentCate", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("lui-source", mapping, form, request,
					response);
		}
	}
	
	protected Object[] findOne(IBaseService service, String tableName,
			String categoryId, HttpServletRequest request) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock(tableName + ".fdName, " + tableName + ".fdId, "
				+ tableName + ".fdHierarchyId, " + tableName
				+ ".hbmParent.fdId");
		hqlInfo.setWhereBlock(tableName + ".fdId=:categoryId");
		hqlInfo.setParameter("categoryId", categoryId);
		this.buildValue(request, hqlInfo, tableName);
		return (Object[]) service.findValue(hqlInfo).get(0);
	}
	
	protected void buildValue(HttpServletRequest request, HQLInfo hqlInfo,
			String tableName) {
		String prefix = "qq.";
		Enumeration enume = request.getParameterNames();
		String whereBlock = hqlInfo.getWhereBlock();
		while (enume.hasMoreElements()) {
			String name = (String) enume.nextElement();
			if (name != null && name.trim().startsWith(prefix)) {
				String value = request.getParameter(name);
				if (StringUtil.isNotNull(value)) {
					name = name.trim().substring(prefix.length());
					String[] ___val = value.split("[;；,，]");

					String ___block = "";
					for (int i = 0; i < ___val.length; i++) {
						String param = "kmss_ext_props_"
								+ HQLUtil.getFieldIndex();
						___block = StringUtil.linkString(___block, " or ",
								tableName + "." + name + " =:" + param);
						hqlInfo.setParameter(param, ___val[i]);
					}
					whereBlock += " and (" + ___block + ")";
				}
			}
		}
		hqlInfo.setWhereBlock(whereBlock);
	}
}

