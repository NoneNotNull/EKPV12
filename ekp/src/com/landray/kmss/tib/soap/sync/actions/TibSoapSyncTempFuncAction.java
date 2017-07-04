package com.landray.kmss.tib.soap.sync.actions;

import java.io.StringReader;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.tib.soap.sync.service.ITibSoapSyncTempFuncService;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;


/**
 * 定时任务对应函数表 Action
 * 
 * @author 
 * @version 1.0 2014-02-20
 */
public class TibSoapSyncTempFuncAction extends ExtendAction {
	protected ITibSoapSyncTempFuncService tibSoapSyncTempFuncService;
	protected ICompDbcpService compDbcpService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSoapSyncTempFuncService == null)
			tibSoapSyncTempFuncService = (ITibSoapSyncTempFuncService)getBean("tibSoapSyncTempFuncService");
		return tibSoapSyncTempFuncService;
	}
	
	protected IBaseService getCompDbcpService(HttpServletRequest request) {
		if (compDbcpService == null)
			compDbcpService = (ICompDbcpService) getBean("compDbcpService");
		return compDbcpService;
	}
	
	public ActionForm getTableList(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String data = request.getParameter("data");
		if(StringUtil.isNull(data)){ return null;};
		JSONObject jsonObj = (JSONObject) (new JSONParser())
				.parse(new StringReader(data));
		String dbId = (String) jsonObj.get("dbId");
		String queryString = (String) jsonObj.get("queryString");
		getCompDbcpService(request);
		CompDbcp compDbcp = (CompDbcp) compDbcpService.findByPrimaryKey(dbId);
		JSONArray tableList = new JSONArray();
		if (compDbcp != null) {
			DataSet ds = new DataSet(compDbcp.getFdName());
			DatabaseMetaData databaseMetaData = ds.getConnection()
					.getMetaData();
			ResultSet tableSet = databaseMetaData.getTables(null, "%", "%",
					new String[] { "TABLE" });
			String jsonTemplate = "{tableName:'!{fdName}'}";
			while (tableSet.next()) {
				String tableName = tableSet.getString("TABLE_NAME");
				String elementString = jsonTemplate.replace("!{fdName}",
						tableName);
				if(tableName.startsWith(queryString)){
				tableList.add(elementString);
				}
			}
			ds.close();
		}
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(tableList.toString());

		return null;
	}

	public ActionForm getFieldList(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		try{
			getCompDbcpService(request);
			String data = request.getParameter("data");
			JSONObject jsonObj = (JSONObject) (new JSONParser())
					.parse(new StringReader(data));
			String tableName = (String) jsonObj.get("table");
			String dbId = (String) jsonObj.get("dbId");
			String result = findFieldList(tableName, dbId);
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(result);
		}catch (Exception e) {
			JSONObject jso=new JSONObject();
			jso.put("MSG", ResourceUtil.getString("tibSoapSyncJob.dataLoadError", "tib-soap-sync"));
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(jso.toString());
		}
		return null;
	}

	private String findFieldList(String tableName, String dbId)
			throws Exception {
		CompDbcp compDbcp = (CompDbcp) compDbcpService.findByPrimaryKey(dbId);
		JSONArray fieldList = new JSONArray();
		String jsonTemplate = "{fieldName:'!{fdName}',dataType:'!{dataType}'}";
		if (compDbcp != null) {
			DataSet ds = new DataSet(compDbcp.getFdName());
			DatabaseMetaData databaseMetaData = ds.getConnection()
					.getMetaData();
			ResultSet columnSet = databaseMetaData.getColumns(null, "%", 
					tableName, "%");

			while (columnSet.next()) {
				String columnName = columnSet.getString("COLUMN_NAME");
				String sqlType = columnSet.getString("TYPE_NAME");
				String elementString = jsonTemplate.replace("!{fdName}",
						columnName).replace("!{dataType}", sqlType);
				fieldList.add(elementString);
			}
			ds.close();
		}
		return fieldList.toString();
	}

	public ActionForm getDBList(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		getCompDbcpService(request);
		List<CompDbcp> compDbcpList = compDbcpService.findList(null, null);
		JSONArray dbcpList = new JSONArray();
		String jsonTemplate = "{fdName:'!{fdName}',compId:'!{compId}'}";
		for (CompDbcp compDbcp : compDbcpList) {
			String elementString = jsonTemplate.replace("!{fdName}",
					compDbcp.getFdName()).replace("!{compId}",
					compDbcp.getFdId());
			dbcpList.add(elementString);
		}
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(dbcpList.toString());

		return null;
	}
	
	
	public ActionForward listDStable(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		getServiceImp(request);
		String tableName=request.getParameter("tableName");
		String dbID =request.getParameter("dbID");
		String tempId =request.getParameter("tempId");
		
		TimeCounter.logCurrentTime("Action-list", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			boolean isReserve = false;
			if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
				isReserve = true;
			}
			int pageno = 0;
			int rowsize = 0;
			if (s_pageno != null && s_pageno.length() > 0) {
				pageno = Integer.parseInt(s_pageno);
			}
			if (s_rowsize != null && s_rowsize.length() > 0) {
				rowsize = Integer.parseInt(s_rowsize);
			}
			if (isReserve)
				orderby += " desc";
			Page page=tibSoapSyncTempFuncService.findPageByData(dbID,tableName,tempId,pageno,rowsize,orderby );
			request.setAttribute("tableName",tableName);
			request.setAttribute("dbID",dbID);
			request.setAttribute("tempId",tempId);
			request.setAttribute("queryPage", page);
		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-list", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("list_table", mapping, form, request, response);
		}
	}
}

