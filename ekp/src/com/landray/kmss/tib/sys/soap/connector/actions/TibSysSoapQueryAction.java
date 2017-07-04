package com.landray.kmss.tib.sys.soap.connector.actions;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.w3c.dom.Document;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.tib.sys.soap.connector.forms.TibSysSoapQueryForm;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapQueryService;
import com.landray.kmss.tib.sys.soap.connector.util.header.SoapInfo;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;


/**
 * 函数查询 Action
 * 
 * @author 
 * @version 1.0 2012-08-28
 */
public class TibSysSoapQueryAction extends ExtendAction {
	protected ITibSysSoapQueryService TibSysSoapQueryService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(TibSysSoapQueryService == null)
			TibSysSoapQueryService = (ITibSysSoapQueryService)getBean("tibSysSoapQueryService");
		return TibSysSoapQueryService;
	}

	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		String funcId = request.getParameter("funcId");
		hqlInfo.setWhereBlock("tibSysSoapQuery.tibSysSoapMain.fdId=:tibSysSoapMainFdId");
		hqlInfo.setParameter("tibSysSoapMainFdId", funcId);
	}

	public ActionForward getXmlResult(ActionMapping mapping,
			ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		KmssMessages messages = new KmssMessages();
		TibSysSoapQueryForm tibSysSoapQueryForm = (TibSysSoapQueryForm)form;
		String xmlString=tibSysSoapQueryForm.getDocInputParam();
		String outString=tibSysSoapQueryForm.getDocOutputParam();
		String soapuiMainId =tibSysSoapQueryForm.getTibSysSoapMainId();
		if (StringUtil.isNotNull(outString)) {
			xmlString = replaceXml(xmlString + outString, soapuiMainId);
		}
		ITibSysSoapMainService erpMainService=(ITibSysSoapMainService)SpringBeanUtil.getBean("tibSysSoapMainService");
		try {
			TibSysSoapMain tibSysSoapMain=(TibSysSoapMain)erpMainService.findByPrimaryKey(soapuiMainId);
			ITibSysSoap tibSysSoap=(ITibSysSoap)SpringBeanUtil.getBean("tibSysSoap");
			// SoapInfo设值
			SoapInfo soapInfo=new SoapInfo();
			soapInfo.setTibSysSoapMain(tibSysSoapMain);
			//soapInfo.setRequestXml(xmlString);
			
			Document doc =DOMHelper.parseXmlString(xmlString);
			soapInfo.setRequestDocument(doc);
			Document rtnDoc=tibSysSoap.inputToOutputDocument(soapInfo);
			
			String resultXml =DOMHelper.nodeToString(rtnDoc,true);
//			System.out.println("end:"+resultXml);
//			
//			//String resultXml = tibSysSoap.inputToAllXml(soapInfo);
//			resultXml = replaceXml(resultXml, soapuiMainId);
//			// 把Input,Output,Fault分别拿出来
//			String inputXml = HeaderOperation.allToPartXml(resultXml, "//Input");
//			tibSysSoapQueryForm.setDocInputParam("<Input>"+ inputXml +"</Input>");
//			if (ParseSoapXmlUtil.isFault(resultXml)) {
//				String faultXml = HeaderOperation.allToPartXml(resultXml, "//Fault");
//			 	tibSysSoapQueryForm.setDocFaultInfo("<Fault>"+ faultXml +"</Fault>");
//			} else {
//				String outputXml = HeaderOperation.allToPartXml(resultXml, "//Output");
//				tibSysSoapQueryForm.setDocOutputParam("<Output>"+ outputXml +"</Output>");
//			}
			
			request.setAttribute("resultXml",resultXml);
		} catch (Exception e) {
			e.printStackTrace();
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, tibSysSoapQueryForm, request,
					response);
		} else {
			return getActionForward("viewResult", mapping, tibSysSoapQueryForm, request,
					response);
		}
	}
	
	private String replaceXml(String resultXml,String mainId){
		String allXmlStr="<?xml version=\"1.0\" encoding=\"UTF-8\"?><web ID=\"!{ID}\" timestamp=\"!{timestamp}\">!{content}</web>";
		allXmlStr =allXmlStr.replace("!{ID}", mainId).replace("!{content}", resultXml).replace("!{timestamp}", new Date().getTime()+"");
		return allXmlStr;
	}
	
	/**
	 * 点击进入查询记录时,再点重新查询所要进入的方法
	 * (就是把查询记录值保存后，继续查询)
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 */
	public ActionForward reQuery(ActionMapping mapping,
			ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		KmssMessages messages = new KmssMessages();
		TibSysSoapQueryForm TibSysSoapQueryForm = (TibSysSoapQueryForm)form;
		try {
			String fdMainId = request.getParameter("fdMainId");
//			TibSysSoapQuery TibSysSoapQuery = (TibSysSoapQuery) getServiceImp(request).
//					findByPrimaryKey(fdId);
			String idXml = TibSysSoapQueryForm.getDocInputParam();
			request.setAttribute("tibSysSoapMainId", fdMainId);
			request.setAttribute("idXml", idXml);
			request.setAttribute("docOutputParam", TibSysSoapQueryForm.getDocOutputParam());
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, TibSysSoapQueryForm, request,
					response);
		} else {
			return getActionForward("reViewQuery", mapping, TibSysSoapQueryForm, request,
					response);
		}
	}
}

