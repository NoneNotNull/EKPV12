package com.landray.kmss.tib.sap.sync.actions;

import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.hibernate.ObjectNotFoundException;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.sys.quartz.model.SysQuartzJob;
import com.landray.kmss.sys.quartz.scheduler.ISysQuartzJobExecutor;
import com.landray.kmss.sys.quartz.service.ISysQuartzJobService;
import com.landray.kmss.tib.sap.sync.forms.TibSapSyncJobForm;
import com.landray.kmss.tib.sap.sync.model.ClocalVo;
import com.landray.kmss.tib.sap.sync.model.TibSapSyncCategory;
import com.landray.kmss.tib.sap.sync.service.ITibSapSyncCategoryService;
import com.landray.kmss.tib.sap.sync.service.ITibSapSyncJobService;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;


/**
 * 定时任务 Action
 * 
 * @author 
 * @version 1.0 2011-10-20
 */
public class TibSapSyncJobAction extends ExtendAction {
	private Log logger = LogFactory.getLog(this.getClass());
	
	protected ITibSapSyncJobService tibSapSyncJobService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSapSyncJobService == null)
			tibSapSyncJobService = (ITibSapSyncJobService)getBean("tibSapSyncJobService");
		return tibSapSyncJobService;
	}
	
	public ActionForward chgenabled(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		String param = request.getParameter("fdEnabled");
		boolean isEnable = (param.equals("1")) || (param.equals("true"));
		try {
			getServiceImp(request);
			if (!(request.getMethod().equals("POST")))
				throw new UnexpectedRequestException();
			String[] ids = request.getParameterValues("List_Selected");
			if (ids != null)
				this.tibSapSyncJobService.updateChgEnabled(ids, isEnable);
		} catch (Exception e) {
			messages.addError(e);
		}
		
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);
	}
	
	public ActionForward run(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
//			 ITibSapSyncJobService tibSapSyncJobService =(ITibSapSyncJobService)getBean("tibSapSyncJobService");
//			 TibSapSyncJob tibSapSyncJob=(TibSapSyncJob) tibSapSyncJobService.findByPrimaryKey(fdId);
			 String ekpQuartz=request.getParameter("fdId");
//			notes:没有启动是不回去
			 ISysQuartzJobService sysJobService=(ISysQuartzJobService)getBean("sysQuartzJobService");
			 
			 SysQuartzJob sysQuartzJob=(SysQuartzJob)sysJobService.findByPrimaryKey(ekpQuartz);
			 boolean flag=false;
			 try{
				 if(!StringUtil.isNull(sysQuartzJob.getFdId())){
						((ISysQuartzJobExecutor) getBean("sysQuartzJobExecutor"))
						.execute(ekpQuartz);
				 } 
			 }catch (ObjectNotFoundException e) {
				 logger.warn("该定时任务没有启动，请先启动才运行~！");
			}
		
		} catch (Exception e) {
			messages.addError(e);
		}
		KmssReturnPage.getInstance(request).addMessages(messages).setTitle(
				new KmssMessage("sys-quartz:sysQuartzJob.running")).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		if (messages.hasError())
			return mapping.findForward("failure");
		else
			return mapping.findForward("success");
	}
	
	
	protected String getFindPageWhereBlock(HttpServletRequest request)
			throws Exception {
		String categoryId=request.getParameter("categoryId");
		String whereBlock=StringUtil.isNotNull(categoryId)?" tibSapSyncJob.docCategory.fdHierarchyId like '%"+categoryId+"%'":null;
		return whereBlock;
	}
	
	public ActionForward getXMLTable(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		String quartzId=request.getParameter("quartzId");
		 getServiceImp(request);
		 Set<ClocalVo> result=tibSapSyncJobService.findTableByQuartzId(quartzId);
		 request.setAttribute("result", result);
		return getActionForward("tableList", mapping, form, request, response);//mapping.findForward("tableList");
	}
	
	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String fdTemplateId = request.getParameter("fdtemplatId");
		if(StringUtil.isNull(fdTemplateId)) return form;
		ITibSapSyncCategoryService service = (ITibSapSyncCategoryService) SpringBeanUtil.getBean("tibSapSyncCategoryService");
		TibSapSyncCategory category = (TibSapSyncCategory) service.findByPrimaryKey(fdTemplateId);
		TibSapSyncJobForm sapForm=(TibSapSyncJobForm)form;
		sapForm.setDocCategoryId(category.getFdId());
		sapForm.setDocCategoryName(category.getFdName());
		return sapForm;
	}
}

