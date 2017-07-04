package com.landray.kmss.kms.multidoc.actions;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.DataAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.kms.multidoc.service.spring.KmsMultidocPortletService;
import com.landray.kmss.kms.multidoc.util.KmsMultidocKnowledgeUtil;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.StringUtil;

public class KmsMultidocKnowledgePortletAction extends DataAction {

	protected IKmsKnowledgeCategoryService kmsKnowledgeCategoryService;

	protected IKmsKnowledgeCategoryService getCategoryServiceImp(HttpServletRequest request) {
		if (kmsKnowledgeCategoryService == null) {
			kmsKnowledgeCategoryService = 
				(IKmsKnowledgeCategoryService) getBean("kmsKnowledgeCategoryService");
		}
		return kmsKnowledgeCategoryService;
	}

	protected String getParentProperty() {
		return "docCategory";
	}

	protected IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;

	protected IKmsMultidocKnowledgeService getServiceImp(
			HttpServletRequest request) {
		if (kmsMultidocKnowledgeService == null)
			kmsMultidocKnowledgeService = (IKmsMultidocKnowledgeService) getBean("kmsMultidocKnowledgeService");
		return kmsMultidocKnowledgeService;
	}
	
	private KmsMultidocPortletService kmsMultidocPortletService;
	
	private KmsMultidocPortletService getMultidocPortletServiceImp(HttpServletRequest request) {
		if (kmsMultidocPortletService == null)
			kmsMultidocPortletService = (KmsMultidocPortletService) getBean("kmsMultidocPortletService");
		return kmsMultidocPortletService;
	}
	
	/**
	 * 获取门户知识
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward getKmsMultidocKnowledge(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception { 
		KmssMessages messages = new KmssMessages();
		try {
			JSONArray rtnArray = getMultidocPortletServiceImp(request).findPortlet(request);
			request.setAttribute("lui-source", rtnArray);
		} catch (Exception e) {
			e.printStackTrace();
			messages.addError(e);
		}
		if (messages.hasError()) {
			return mapping.findForward("lui-failure");
		} else {
			return getActionForward("lui-source", mapping, form, request,
					response);
		}
	}


	/**
	 * 简单经典列表展示数据格式
	 * @param rquest
	 * @param knowList
	 * @return
	 */
	private JSONArray getColArray(HttpServletRequest request, List knowList) {
		JSONArray rtnArray = new JSONArray();
		if(!ArrayUtil.isEmpty(knowList)) {
			for (int i = 0; i < knowList.size(); i++) {
				KmsMultidocKnowledge k = (KmsMultidocKnowledge) knowList.get(i);
				JSONObject json = new JSONObject();
				json.put("catename",k.getDocCategory().getFdName());
				json.put("catehref","/kms/multidoc/?categoryId=" + k.getDocCategory().getFdId());
				json.put("text", k.getDocSubject());
				json.put("created", DateUtil.convertDateToString(k
						.getDocCreateTime(), DateUtil.PATTERN_DATE));
				json
						.put(
								"href",
								"/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId="
										+ k.getFdId());
				json.put("creator", k.getDocAuthor() != null ? k.getDocAuthor().getFdName() : k.getOuterAuthor());
				rtnArray.add(json);
			}
		}
		return rtnArray;
		
	}
	/**
	 * 视图展示数据格式
	 * @param rquest
	 * @param knowList
	 * @return
	 */
	private JSONArray getPicArray(HttpServletRequest request, List knowList)
		throws Exception {
		JSONArray rtnArray = new JSONArray();
		if(!ArrayUtil.isEmpty(knowList)) {
			for (int i = 0; i < knowList.size(); i++) {
				KmsMultidocKnowledge k = (KmsMultidocKnowledge) knowList.get(i);
				JSONObject json = new JSONObject();
				json.put("image",KmsMultidocKnowledgeUtil.getImgUrl(k, request));
				json.put("text", k.getDocSubject());
				json
						.put(
								"href",
								"/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId="
										+ k.getFdId());
				rtnArray.add(json);
			}
		}
		return rtnArray;
		
	}
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		 super.changeFindPageHQLInfo(request, hqlInfo);
		 String whereBlock = hqlInfo.getWhereBlock() + "and kmsMultidocKnowledge.docStatus = '"
				+ SysDocConstant.DOC_STATUS_PUBLISH
				+ "' and kmsMultidocKnowledge.docIsNewVersion=:isNewVersion";
		 //推荐排行，只显示有推荐的知识
		 String showIntro =  request.getParameter("showIntro");
		 if(StringUtil.isNotNull(showIntro) && "true".equals(showIntro)) {
			 whereBlock += 	" and kmsMultidocKnowledge.docIntrCount > :docIntrCount";
			 hqlInfo.setParameter("docIntrCount", 0);
		 }
		 hqlInfo.setParameter("isNewVersion", true);
		 hqlInfo.setWhereBlock(whereBlock);
		 hqlInfo.setGetCount(false);
		 calPercent(request);
	}
	protected String getFindPageWhereBlock(HttpServletRequest request)
			throws Exception {
		return "1=1 ";
	}
	
	/**
	 * 根据显示的列数计算显示的百分比
	 */
	protected void calPercent(HttpServletRequest request) {
		String showType = request.getParameter("showType");
		String showCreator = request.getParameter("showCreator");
		String showCreated = request.getParameter("showCreated");
		String showCate = request.getParameter("showCate");
		String showIntro = request.getParameter("showIntro");	
		int p_subject = 70;
		//五列
		if("5".equals(showType)) {
			 p_subject = 55;
		}
		if(StringUtil.isNotNull(showCreator) && "true".equals(showCreator)) {
			request.setAttribute("showCreator", true);
			request.setAttribute("p_creator", 15);
		}else {
			p_subject += 15;
		}
		if(StringUtil.isNotNull(showCreated) && "true".equals(showCreated)) {
			request.setAttribute("showCreated", true);
			request.setAttribute("p_created", 15);
		}else {
			p_subject += 15;
		}
		if(StringUtil.isNotNull(showIntro) && "true".equals(showIntro)){
			request.setAttribute("showIntro", true);
			request.setAttribute("p_intro", 15);
		} else {
			if("5".equals(showType))
				p_subject += 15;
		}
		if(StringUtil.isNotNull(showCate) && "true".equals(showCate)) {
			request.setAttribute("showCate", true);
		}
		request.setAttribute("p_subject", p_subject);
		
	}

}