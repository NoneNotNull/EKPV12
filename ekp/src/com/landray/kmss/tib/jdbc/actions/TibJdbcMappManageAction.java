package com.landray.kmss.tib.jdbc.actions;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONSerializer;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.tib.jdbc.forms.TibJdbcMappManageForm;
import com.landray.kmss.tib.jdbc.model.TibJdbcMappCategory;
import com.landray.kmss.tib.jdbc.model.TibJdbcMappManage;
import com.landray.kmss.tib.jdbc.service.ITibJdbcMappCategoryService;
import com.landray.kmss.tib.jdbc.service.ITibJdbcMappManageService;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;


/**
 * 映射配置 Action
 * 
 * @author 
 * @version 1.0 2013-07-24
 */
public class TibJdbcMappManageAction extends ExtendAction {
	protected ITibJdbcMappManageService tibJdbcMappManageService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibJdbcMappManageService == null)
			tibJdbcMappManageService = (ITibJdbcMappManageService)getBean("tibJdbcMappManageService");
		return tibJdbcMappManageService;
	}
	
	public ActionForward getData(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-getData", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			RequestContext requestInfo = new RequestContext(request);
			Map resultData = ((ITibJdbcMappManageService)getServiceImp(request)).getTableData(requestInfo);
		    List titleList = (List) resultData.get("titleList");
		    List resultList = (List) resultData.get("resultList");
		    request.setAttribute("titleList", titleList);
		    request.setAttribute("resultList", resultList);
		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-list", false, getClass());
		if (messages.hasError()) {
			String contextPath=request.getContextPath();
			request.setAttribute("KMSS_Parameter_StylePath", contextPath+"/resource/style/default/");
			KmssReturnPage.getInstance(request).addMessages(messages).save(request);
			
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("dataList", mapping, form, request, response);
		}
	}
	
	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TibJdbcMappManageForm mainForm = (TibJdbcMappManageForm) form;
		
		String fdTemplateId = request.getParameter("fdtemplatId");

		if (StringUtil.isNull(fdTemplateId))
			return mainForm;

		ITibJdbcMappCategoryService service = (ITibJdbcMappCategoryService) SpringBeanUtil
				.getBean("tibJdbcMappCategoryService");
		TibJdbcMappCategory category = (TibJdbcMappCategory) service
				.findByPrimaryKey(fdTemplateId);
		mainForm.setDocCategoryId(fdTemplateId);
		mainForm.setDocCategoryName(category.getFdName());
		return mainForm;
	}
	
	public ActionForward list(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-list", true, getClass());
		KmssMessages messages = new KmssMessages();
		String forward = request.getParameter("forward");
		String rowNum = request.getParameter("rowNum");
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			String fdtemplatId= request.getParameter("fdtemplatId");
			boolean isReserve = false;
			if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
				isReserve = true;
			}
			int pageno = 0;
			int rowsize = SysConfigParameters.getRowSize();
			if (s_pageno != null && s_pageno.length() > 0) {
				pageno = Integer.parseInt(s_pageno);
			}
			if (s_rowsize != null && s_rowsize.length() > 0) {
				rowsize = Integer.parseInt(s_rowsize);
			}
			if (isReserve)
				orderby += " desc";
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setOrderBy(orderby);
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);
			changeFindPageHQLInfo(request, hqlInfo);
			Page page = getServiceImp(request).findPage(hqlInfo);
			List list =page.getList();
			Map map = tibJdbcMappManageService.getDataSource();
			request.setAttribute("dataSoure", map);
			request.setAttribute("queryPage", page);
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-list", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		}else if(StringUtils.isNotEmpty(forward)){
			request.setAttribute("rowNum", rowNum);
			return getActionForward(forward, mapping, form, request, response);
		} else {
			return getActionForward("list", mapping, form, request, response);
		}
	}
	
	
	protected void changeFindPageHQLInfo(HttpServletRequest request, HQLInfo hqlInfo)
			throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		String categoryId = request.getParameter("categoryId");
		String hql=hqlInfo.getWhereBlock();
		if(!StringUtil.isNull(categoryId)){
			hql=StringUtil.linkString(hql, " and ", "tibJdbcMappManage.docCategory.fdId like :categoryId ");
			hqlInfo.setParameter("categoryId", "%"+categoryId+"%");
		}
		hqlInfo.setWhereBlock(hql);
		
	}
	
	@SuppressWarnings("unchecked")
	public void queryObjectById(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		List list = new ArrayList();
		List dbList = new ArrayList();
		
		String manageId = request.getParameter("manageId");
		String rowNum=request.getParameter("rowNum");
		String selecteType = request.getParameter("selectType");
		//数据源选项
		if(StringUtils.isNotEmpty(selecteType)&& "3".equals(selecteType)){
			ICompDbcpService compDbcpService = (ICompDbcpService) SpringBeanUtil.getBean("compDbcpService");
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setSelectBlock("compDbcp.fdId,compDbcp.fdName");
			dbList = compDbcpService.findList(hqlInfo);
		}
		
		if(StringUtils.isNotEmpty(manageId)){
		    TibJdbcMappManage tibJdbcMappManage= (TibJdbcMappManage)getServiceImp(request).findByPrimaryKey(manageId);
		    String fdMapConfigJson =tibJdbcMappManage.getFdMappConfigJson();
		    String dbId= tibJdbcMappManage.getFdDataSource();//源数据源id
		    response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			list.add(rowNum);
			list.add(dbId);
			list.add(JSONSerializer.toJSON(fdMapConfigJson).toString());

			String fdDataSourceSql= tibJdbcMappManage.getFdDataSourceSql();
			//去掉sql结尾的分号
			if(fdDataSourceSql.indexOf(";")!=-1){
				fdDataSourceSql=fdDataSourceSql.substring(0, fdDataSourceSql.length()-1);
			 }
			Map paraMap = new HashMap();
			paraMap.put("dbId",dbId);
			paraMap.put("sourceSql", fdDataSourceSql);
			// 添加映射Json
			paraMap.put("fdMapConfigJson", fdMapConfigJson);
			
			//时间戳下拉框
			if(StringUtils.isNotEmpty(selecteType)&& "2".equals(selecteType)){	
				list.add(fdDataSourceSql);
				List fieldList =((ITibJdbcMappManageService)getServiceImp(request)).getTableFieldData(paraMap);
				if(fieldList!=null && fieldList.size()>0){
					list.add(fieldList);
				}
			}
			
			//数据源下拉框
			if("3".equals(selecteType) && dbList!=null && dbList.size()>0){
				list.add(dbList);
			}
			
			//源表下拉框
			if(StringUtils.isNotEmpty(selecteType)&& "3".equals(selecteType)){	
				Set<String> sourceFieldSet =((ITibJdbcMappManageService)getServiceImp(request)).getSourceTabFieldData(paraMap);
				if(sourceFieldSet != null && sourceFieldSet.size() > 0){
					list.add(sourceFieldSet);
				}
			}
			out.print(JSONSerializer.toJSON(list).toString());
		}
		
	}
	
	
	public ActionForward edit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-edit", true, getClass());
		KmssMessages messages = new KmssMessages();
		String type=request.getParameter("type");
		try {
			loadActionForm(mapping, form, request, response);
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-edit", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			//return getActionForward("editPage", mapping, form, request, response);
			request.setAttribute("type", type);
			return getActionForward("edit", mapping, form, request, response);
		}
	}
	
	public ActionForward getTabFieldInfo(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
	throws Exception {
		TimeCounter.logCurrentTime("Action-edit", true, getClass());
		KmssMessages messages = new KmssMessages();
		IXMLDataBean tibJdbcLoadTableFieldService = (IXMLDataBean) SpringBeanUtil.getBean("tibJdbcLoadTableFieldService");
		RequestContext requestInfo = new RequestContext(request);
		List list =tibJdbcLoadTableFieldService.getDataList(requestInfo);
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(list);
		return null;
	}
	
	public ActionForward getTargetDBTab(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
	throws Exception {
		TimeCounter.logCurrentTime("Action-getTargetDBTab", true, getClass());
		KmssMessages messages = new KmssMessages();
		IXMLDataBean tibJdbcLoadDBTablService = (IXMLDataBean) SpringBeanUtil.getBean("tibJdbcLoadDBTablService");
		RequestContext requestInfo = new RequestContext(request);
		List list =tibJdbcLoadDBTablService.getDataList(requestInfo);
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(JSONSerializer.toJSON(list).toString());
		return null;
	}
	
	/**
	 * 用于默认选择日志表
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward getLogTabName(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		List list = new ArrayList();
		try {
			IXMLDataBean tibJdbcLoadDBTablService = (IXMLDataBean) SpringBeanUtil.getBean("tibJdbcLoadDBTablService");
			RequestContext requestInfo = new RequestContext(request);
			list = tibJdbcLoadDBTablService.getDataList(requestInfo);
		} catch (Exception e) {
			e.printStackTrace();
			out.print("");
			return null;
		}
		out.print(JSONSerializer.toJSON(list).toString());
		return null;
	}
	
	
}

