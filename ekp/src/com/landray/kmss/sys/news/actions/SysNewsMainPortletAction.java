package com.landray.kmss.sys.news.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.sys.news.service.ISysNewsMainService;
import com.landray.kmss.sys.portal.util.PortletTimeUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * 创建日期 2013-11-17
 * 
 * @author tanyh
 */
public class SysNewsMainPortletAction extends ExtendAction {

	protected ISysNewsMainService sysNewsMainService;


	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (sysNewsMainService == null)
			sysNewsMainService = (ISysNewsMainService) getBean("sysNewsMainService");
		return sysNewsMainService;
	}
	public ActionForward listPortlet(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		TimeCounter.logCurrentTime("Action-list", true, getClass());
		KmssMessages messages = new KmssMessages();
   try{		
		String rowsize=(String) request.getParameter("rowsize");
		String myNews=(String) request.getParameter("myNews");
		HQLInfo hqlInfo = new HQLInfo();
		if(StringUtil.isNotNull(rowsize)){
				hqlInfo.setRowSize(Integer.parseInt(rowsize));
		}
		String whereBlock="1=1";
	    if(StringUtil.isNotNull(myNews)){
	    	//我发布的
	    	if(myNews.equals("myPublish")){
	           whereBlock+=" and sysNewsMain.docCreator=:docCreator and sysNewsMain.docStatus=:status";
			   hqlInfo.setParameter("docCreator",UserUtil.getUser());
			   hqlInfo.setParameter("status", SysDocConstant.DOC_STATUS_PUBLISH);
			   hqlInfo.setWhereBlock(whereBlock);
	        //我点评的
	    	}else if(myNews.equals("myEv")){
	    		StringBuffer hqlBuffer = new StringBuffer();
				hqlBuffer.append("sysNewsMain.fdId in ");
				// 拼接子查询
				hqlBuffer.append("(select distinct sysEvaluationMain.fdModelId from ");
				hqlBuffer.append(" com.landray.kmss.sys.evaluation.model.SysEvaluationMain"+ " as sysEvaluationMain ");
				hqlBuffer.append("where sysEvaluationMain.fdModelName = :fdModelName ");
				hqlBuffer.append("and sysEvaluationMain.fdEvaluator.fdId = :fdEvaluatorId)");
				hqlInfo.setWhereBlock(hqlBuffer.toString());
				hqlInfo.setParameter("fdModelName","com.landray.kmss.sys.news.model.SysNewsMain");
		        hqlInfo.setParameter("fdEvaluatorId", UserUtil.getUser().getFdId());
	    	}
	    }
	    
	    //时间范围参数
	      String scope=request.getParameter("scope");
	      if(StringUtil.isNotNull(scope)&&!scope.equals("no")){
	        String block=hqlInfo.getWhereBlock();
	        hqlInfo.setWhereBlock(StringUtil.linkString(block, " and ","sysNewsMain.docPublishTime > :fdStartTime"));
	        hqlInfo.setParameter("fdStartTime",PortletTimeUtil.getDateByScope(scope));
	      }
	      
	    if(StringUtil.isNull(hqlInfo.getOrderBy())){
	    	hqlInfo.setOrderBy("sysNewsMain.fdIsTop desc ,sysNewsMain.fdTopTime desc,sysNewsMain.docAlterTime desc");
	    }
	    		hqlInfo.setGetCount(false);
			    Page page = getServiceImp(request).findPage(hqlInfo);
				request.setAttribute("queryPage", page);
		}catch (Exception e) {
				messages.addError(e);
		}
			 TimeCounter.logCurrentTime("Action-list", false, getClass());
			if (messages.hasError()) {
				KmssReturnPage.getInstance(request).addMessages(messages).addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
				return getActionForward("failure", mapping, form, request, response);
			} else {
				return getActionForward("listPortlet", mapping, form, request, response);
			}
		}
    }