package com.landray.kmss.tib.sys.sap.connector.actions;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.sys.sap.connector.forms.TibSysSapRfcSearchInfoForm;
import com.landray.kmss.tib.sys.sap.connector.impl.TibSysSapJcoFunctionUtil;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcSearchInfoService;
import com.landray.kmss.tib.sys.sap.connector.util.TibSysSapExcelUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * rfc函数查询 Action
 * 
 * @author zhangtian
 * @version 1.0 2011-12-20
 */
public class TibSysSapRfcSearchInfoAction extends ExtendAction {
	protected ITibSysSapRfcSearchInfoService tibSysSapRfcSearchInfoService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (tibSysSapRfcSearchInfoService == null)
			tibSysSapRfcSearchInfoService = (ITibSysSapRfcSearchInfoService) getBean("tibSysSapRfcSearchInfoService");
		return tibSysSapRfcSearchInfoService;
	}

	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request, HQLInfo hqlInfo)
			throws Exception {
		String rfcSettingId = request.getParameter("rfcSettingId");
		if (StringUtil.isNotNull(rfcSettingId)) {
			hqlInfo.setWhereBlock(" tibSysSapRfcSearchInfo.fdRfc.fdId=:fdRfcFdId ");
			hqlInfo.setParameter("fdRfcFdId", rfcSettingId);
		}
	}

	private boolean isNumberic(String value) {
		Pattern pattern = Pattern.compile("[0-9]*");
		Matcher isNum = pattern.matcher(value.trim());
		return isNum.matches();
	}

	public ActionForward getXmlResult(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		TimeCounter.logCurrentTime("Action-getResultXml", true, getClass());
		KmssMessages messages = new KmssMessages();
		TibSysSapRfcSearchInfoForm rfcForm = (TibSysSapRfcSearchInfoForm) form;
		try {

			String result = (String) request.getParameter("fdxml");
			String fdRfcSettingId = (String) request
					.getParameter("fdRfcSetting");
			// xml数据过滤,限制每个table只过滤100条。
			String rows = (String) request.getParameter("rowsize");
			int rowsize = 0;
			boolean flag = false;
			if (StringUtil.isNotNull(rows)) {
				if (isNumberic(rows)) {
					rowsize = Integer.valueOf(rows);
					flag = true;
				} else {
					flag = false;
				}
			} else {
				rowsize = 100;
				flag = true;
			}
			TibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil = (TibSysSapJcoFunctionUtil) SpringBeanUtil
					.getBean("tibSysSapJcoFunctionUtil");
			String resultXml = null;
			if (flag) {
				// resultXml = filterXmlRow(resultXml, rowsize - 1);
				resultXml = (String) tibSysSapJcoFunctionUtil.getXMltoFunction(
						result, rowsize).getResult();
			} else {
				resultXml = (String) tibSysSapJcoFunctionUtil
						.getXMltoFunction(result).getResult();

			}

			rfcForm.setFdData(resultXml);
			rfcForm.setFdRfcId(fdRfcSettingId);

		} catch (Exception e) {
			messages.addError(e);
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		TimeCounter.logCurrentTime("Action-getResultXml", false, getClass());
		if (messages.hasError())
			return getActionForward("failure", mapping, rfcForm, request,
					response);
		else
			return getActionForward("view_result", mapping, rfcForm, request,
					response);

	}

	/**
	 * 过滤行数,只针对table的过滤，不针对import,export 过滤,凡是records row属性>rowsize过滤
	 * 
	 * @param xml
	 * @param rowsize
	 * @return private String filterXmlRow(String xml, int rowsize) { try {
	 *         Document xmlDOM = DocumentHelper.parseText(xml); List<Element>
	 *         records = xmlDOM .selectNodes("/jco/tables/table/records[@row>'"
	 *         + rowsize + "']"); for (int i = 0; i < records.size(); i++) {
	 *         records.get(i).detach(); } return xmlDOM.asXML(); } catch
	 *         (DocumentException e) { return ""; }
	 * 
	 *         }
	 */
	public ActionForward saveByData(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String result = (String) request.getParameter("fdxml");
		String fdRfcSettingId = (String) request.getParameter("fdRfcSetting");
		TibSysSapRfcSearchInfoForm rfcForm = (TibSysSapRfcSearchInfoForm) form;
		rfcForm.setFdData(result);
		rfcForm.setFdRfcId(fdRfcSettingId);
		return super.save(mapping, rfcForm, request, response);

	}

	public ActionForward saveByExcel(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-saveByExcel", true, getClass());
		KmssMessages messages = new KmssMessages();

		String targetXml = request.getParameter("fdData");
		String targetRfcId = request.getParameter("fdRfcId");
		String docSubject = request.getParameter("docSubject");
		TibSysSapExcelUtil tibSysSapExcelUtil = (TibSysSapExcelUtil) SpringBeanUtil
				.getBean("tibSysSapExcelUtil");
		HSSFWorkbook wb = tibSysSapExcelUtil.xmlForExcel(targetXml, targetRfcId);
		try {
			// OutputStream os=new FileOutputStream("E:\\workbook.xls");
			// wb.write(os);
			// os.flush();
			// os.close();
			// System.out.println("end");
			response.reset();
			response.setContentType("application/vnd.ms-excel");
			response.setCharacterEncoding("UTF-8");
			// 下载标题乱码问题
			docSubject = new String(docSubject.getBytes("GB2312"), "ISO-8859-1");
			response.setHeader("Content-Disposition", "attachment;filename="
					+ docSubject + ".xls");
			wb.write(response.getOutputStream());
			return null;
		} catch (Exception e) {
			messages.addError(e);
			return getActionForward("failure", mapping, form, request, response);
		}
	}

	public ActionForward queryEdit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-queryEdit", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			loadActionForm(mapping, form, request, response);
			TibSysSapRfcSearchInfoForm rfcForm = (TibSysSapRfcSearchInfoForm) form;
			// System.out.println(rfcForm.getFdRfcId());
			request.setAttribute("rfcId", rfcForm.getFdRfcId());

		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-queryEdit", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("query_edit", mapping, form, request,
					response);
		}

	}
}
