<%@page import="com.landray.kmss.common.model.IBaseModel"%>
<%@page import="com.landray.kmss.common.service.IBaseService"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.common.dao.HQLInfo"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.ModelUtil"%>
<%@page import="com.landray.kmss.third.pda.util.PdaFlagUtil"%>
<%@page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@page import="com.landray.kmss.sys.organization.model.SysOrgElement"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%@page import="com.landray.kmss.third.pda.util.PdaPlugin"%>
<%@page
	import="com.landray.kmss.sys.property.interfaces.ISysPropertyTemplate"%>
<%
	String appFlag = "";
	if (PdaFlagUtil.checkClientIsPdaApp(request))
		appFlag = "&isAppflag=1";

	String parentIdField = "parentId";
	String parentId = request.getParameter(parentIdField);
	Page queryPage = (Page) request.getAttribute("queryPage");
	JSONObject viewObj = new JSONObject();
	int docCount = queryPage.getTotalrows();
	String strPara = request.getParameter(parentIdField);

	if (docCount == 0) {
		//response.sendRedirect(request.getContextPath() + modelURL);
	} else {
		viewObj.accumulate("pageCount", queryPage.getTotal());//所有页数
		viewObj.accumulate("pageno", queryPage.getPageno()); //当前页码
		viewObj.accumulate("count", docCount); //文档总数
		if (queryPage.getEnd() < docCount - 1)
			viewObj.accumulate("nextPageStart", queryPage.getEnd() + 1); //下页开始数

		JSONArray docArr = new JSONArray();

		for (Object modelObj : queryPage.getList()) {
			String subject = "";
			try {
				subject = (String) PropertyUtils.getProperty(modelObj,
						"docSubject");
			} catch (Exception e) {
				try {
					subject = (String) PropertyUtils.getProperty(
							modelObj, "fdName");
				} catch (Exception e1) {
					subject = "";
				}
			}
			String modelName = PdaPlugin.getPdaParamByParam(modelObj
					.getClass().getName(),
					PdaPlugin.PARAM_PDA_EXTEND_TEMPLATECLASS,
					PdaPlugin.PARAM_PDA_EXTEND_MODELNAME);
			JSONObject obj = new JSONObject();
			obj.accumulate("type", "cate");
			obj.accumulate("subject", subject);
			// 显示下级分类
			String cateId = (String) PropertyUtils.getProperty(
					modelObj, "fdId");
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setSelectBlock("count(*)");
			hqlInfo.setModelName(ModelUtil.getModelClassName(modelObj));
			hqlInfo.setWhereBlock("docCategory.hbmParent.fdId = :cateId");
			hqlInfo.setParameter("cateId", cateId);
			IBaseService baseService = (IBaseService) SpringBeanUtil
					.getBean("KmssBaseService");
			List list = baseService.findList(hqlInfo);
			String url = "";
			JSONArray buttons = new JSONArray();
			if (list.size() > 0) {
				Long total = (Long) list.get(0);
				Class clas = Class.forName(modelName);
				Object mainModel = clas.newInstance();
				String modelURL = ModelUtil.getModelUrl(mainModel);
				modelURL = modelURL.substring(0,
						modelURL.indexOf("?") + 1);
				modelURL += "method=listChildren&categoryId=" + cateId
						+ (StringUtil.isNull(appFlag) ? "" : appFlag);

				// 筛选按钮
				JSONObject filterButton = null;
				String filterURL = PdaPlugin
						.getPdaExtendInfo(modelName,
								PdaPlugin.PARAM_PDA_EXTEND_FILTERURL);
				String templateClass = null;
				if (StringUtil.isNotNull(filterURL)) {
					String param = "templateClass";
					int t = filterURL.indexOf(param);
					templateClass = filterURL.substring(t
							+ param.length() + 1, filterURL.length());
					filterURL = filterURL.substring(0, t - 1);
				}
				if (StringUtil.isNotNull(templateClass)) {
					if (modelObj instanceof ISysPropertyTemplate) {
						if (((ISysPropertyTemplate) modelObj)
								.getSysPropertyTemplate() != null) {
							filterButton = new JSONObject();
							filterURL += "&modelName="
									+ ModelUtil
											.getModelClassName(modelObj);
							filterURL += "&fdCategoryId=" + cateId;
							filterURL += "&mainModelName=" + modelName;
							filterButton.accumulate("type", "filter");
							filterButton.accumulate("name",
									ResourceUtil.getString(
											"phone.button.filter",
											"third-pda"));
							filterButton.accumulate("url", filterURL);
						}
					}
				}
				if (total > 0) {
					String cateURL = ModelUtil.getModelUrl(modelObj);
					cateURL = cateURL.substring(0,
							cateURL.indexOf("?") + 1);
					// 分类有下级
					url = cateURL
							+ "method=pdaCategory"
							+ "&"
							+ parentIdField
							+ "="
							+ cateId
							+ (StringUtil.isNull(appFlag) ? ""
									: appFlag);
					if (StringUtil.isNotNull(cateId)) {
						// 详细文档按钮 
						JSONObject docButton = new JSONObject();
						docButton.accumulate("name", ResourceUtil
								.getString("phone.button.detail.doc",
										"third-pda"));
						docButton.accumulate("url", modelURL);
						docButton.accumulate("type", "list");
						if (filterButton != null) {
							JSONArray btns = new JSONArray();
							btns.element(filterButton);
							docButton.accumulate("subButtons", btns);
						}
						buttons.element(docButton);
					}
				} else {
					url = modelURL;
					if (filterButton != null) {
						buttons.element(filterButton);
					}
				}
				// 新建按钮
				String createTempURL = PdaPlugin.getPdaExtendInfo(
						modelName,
						PdaPlugin.PARAM_PDA_EXTEND_CREATETEMPURL);
				if (StringUtil.isNotNull(createTempURL)
						&& StringUtil.isNotNull(cateId)) {
					JSONObject createButton = new JSONObject();
					createButton.accumulate("name", ResourceUtil
							.getString("button.add"));
					createTempURL = createTempURL.replace("!{cateid}",
							cateId);
					createButton.accumulate("url", createTempURL
							+ (StringUtil.isNull(appFlag) ? ""
									: appFlag));
					createButton.accumulate("type", "doc");
					buttons.element(createButton);
				}
			}
			obj.accumulate("url", url);
			obj.accumulate("buttons", buttons);
			docArr.element(obj);
		}
		viewObj.accumulate("docs", docArr);
	}

	pageContext.setAttribute("viewObj", viewObj.toString());
%>
${viewObj}
