package com.landray.kmss.tib.common.inoutdata.actions;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.common.inoutdata.forms.TibCommonInoutdataForm;
import com.landray.kmss.tib.common.inoutdata.service.ITibCommonInoutdataService;
import com.landray.kmss.tib.common.inoutdata.util.TibCommonInoutdataFileUtil;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingMain;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMainService;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.SpringBeanUtil;


/**
 * 主文档 Action
 * CategoryNodeAction
 * @author 邱建华
 * @version 1.0 2013-01-05
 */
public class TibCommonInoutdataAction extends ExtendAction {
	
	protected ITibCommonInoutdataService tibCommonInoutdataService;

	protected ITibCommonInoutdataService getServiceImp(HttpServletRequest request) {
		if(tibCommonInoutdataService == null)
			tibCommonInoutdataService = (ITibCommonInoutdataService)getBean("tibCommonInoutdataService");
		return tibCommonInoutdataService;
	}
	
	/**
	 * 打包下载
	 */
	@SuppressWarnings("unchecked")
	public ActionForward exportZip(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-exportZip", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			// 导出之前删除旧文件目录
			File tempFile = new File(ITibCommonInoutdataService.INIT_PATH+ITibCommonInoutdataService.CONF_PATH);
			TibCommonInoutdataFileUtil.deleteDir(tempFile);
			String[] values = request.getParameterValues("Inoutdata_List_Selected");
			if (values != null) {
				Set<String> filePathSet = new HashSet<String>();
				// 导出文件
				for (String str : values) {
					if (str.indexOf(";") < 0 || (str.indexOf(";") > 0 
							&& "notExport".equals(str.split(";")[0])))
						continue;
					String[] strs = str.split(";");
					String modelName = strs[1];
					String id = strs[0];
					// 装modelName的集合
					List<Map<String, String>> modelInfoList = new ArrayList<Map<String, String>>(); 
					Map<String, String> map = new HashMap<String, String>();
					map.put("fdId", id);
					map.put("modelName", modelName);
					modelInfoList.add(map);
					// 设置相关联的model信息
					getServiceImp(request).setModelInfoList(modelInfoList, id, modelName);
					// 表单流程模版特殊情况处理(导出关联函数)
					if ("com.landray.kmss.km.review.model.KmReviewTemplate".equals(modelName) 
							|| "com.landray.kmss.sys.news.model.SysNewsTemplate".equals(modelName)) {
						ITibCommonMappingMainService tibCommonMappingMainService = (ITibCommonMappingMainService) 
								SpringBeanUtil.getBean("tibCommonMappingMainService");
						HQLInfo hqlInfo = new HQLInfo();
						hqlInfo.setWhereBlock("tibCommonMappingMain.fdTemplateId=:fdTemplateId");
						hqlInfo.setParameter("fdTemplateId", id);
						List<TibCommonMappingMain> erpEkpTempFuncMainList = tibCommonMappingMainService
								.findList(hqlInfo);
						if (!erpEkpTempFuncMainList.isEmpty()) {
							TibCommonMappingMain erpEkpTempFuncMain = erpEkpTempFuncMainList.get(0);
							Map<String, String> tempMap = new HashMap<String, String>();
							String funcMainFdId = erpEkpTempFuncMain.getFdId();
							String funcMainModelName = TibCommonMappingMain.class.getName();
							tempMap.put("fdId", funcMainFdId);
							tempMap.put("modelName", funcMainModelName);
							tempMap.put("notAppend", "notAppend");
							modelInfoList.add(tempMap);
							// 设置相关联的model信息
							getServiceImp(request).setModelInfoList(modelInfoList, 
									funcMainFdId, funcMainModelName);
						}
						
					}
					
					for (Map<String, String> tempMap : modelInfoList) {
						String relationFdId = tempMap.get("fdId");
						String relationModelName = tempMap.get("modelName");
						// 执行导入文件操作
						getServiceImp(request).exportToFile(relationModelName, relationFdId);
						// 分割包名进行拼串包路径(为了下载做准备)
						String[] packs = relationModelName.split("\\.");
						String packPath = "";
						for (int i = 3, len = packs.length; i < len - 2; i++) {
							packPath += "/"+ packs[i];
						}
						filePathSet.add(packPath +"/_"+ relationModelName);
					}
					
				}
				Object[] filePathsObj = (Object[]) filePathSet.toArray();
				int len = filePathsObj.length;
				String[] filePaths = new String[len];
				for (int i = 0; i < len; i++) {
					filePaths[i] = (String) filePathsObj[i];
				}
				
				// ==========打包下载开始=========
				OutputStream out = response.getOutputStream();
				getServiceImp(request).startExport(filePaths);
				File file = new File(ITibCommonInoutdataService.INIT_PATH
						+ "/" + ITibCommonInoutdataService.EXPORT_ZIP);
				InputStream in = new FileInputStream(file);
				try {
					long fileSize = file.length();
					String fileName = ITibCommonInoutdataService.EXPORT_ZIP;
					String filename = new String(fileName.getBytes("UTF-8"),
							"iso8859-1");
					response.setContentLength((int) fileSize);
					response.setContentType("application/x-msdownload");

					if (filename.indexOf(".swf") == -1) {
						response.setHeader("Content-Disposition",
								"attachment;filename=\"" + filename + "\"");
					}
					byte[] b = new byte[in.available()];
					in.read(b);
					out.write(b);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					in.close();
					out.flush();
					out.close();
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-exportZip", false, getClass());
		return null;
	}
	
	/**
	 * 数据分析，上传文件
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward upload(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			TibCommonInoutdataForm upInitForm = (TibCommonInoutdataForm) form;
			// 获取FormFile
			FormFile formFile = upInitForm.getInitfile();
			if (formFile != null) {
				getServiceImp(request).uploadInitData(formFile);
			}
		} catch (Exception e) {
			messages.addError(e);
		}

		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_RETURN).save(request);
			return mapping.findForward("failure");
		} else {
			return showImport(mapping, form, request, response);
		}

	}
	
	/**
	 * 显示导入页面
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward showImport(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		String type = request.getParameter("type");
		try {
//			if ("baseImport".equals(type)) {
				// 导入系统基础数据(暂时不需要用，因为sys/initdata已经有此功能)
//				request.setAttribute("filePaths", getServiceImp(request)
//						.getBaseDataFileDirInfos(request.getLocale())
//						.toString());
//			} else {
				request.setAttribute("filePaths", getServiceImp(request)
						.getFileDirInfos(request.getLocale()).toString());
//			}
		} catch (Exception e) {
			messages.addError(e);
		}

		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_RETURN).save(request);
			return mapping.findForward("failure");
		} else {
			// if ("baseImport".equals(type)) {
			// // 导入系统基础数据(暂时不需要用，因为sys/initdata已经有此功能)
			// return mapping.findForward("base_import");
			// } else
			if ("export".equals(type)) {
				// 重新导入
				return mapping.findForward("exportList");
			} else {
				return mapping.findForward("import");
			}
		}
	}
	
	/**
	 * 开始导入
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward startImport(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			// 导入类型
			String type = request.getParameter("type");
			String[] filePaths = request.getParameterValues("Inoutdata_List_Selected");
			boolean isImportRequired = false;
			boolean isUpdate = false;
			if ("true".equals(request.getParameter("isImportRequired"))) {
				// 是否随机导入必填字段
				isImportRequired = true;
			}
			if ("true".equals(request.getParameter("isUpdate"))) {
				// 是否更新原有数据
				isUpdate = true;
			}
			if (filePaths != null) {
				String pathPrefex = ITibCommonInoutdataService.INIT_PATH + ITibCommonInoutdataService.CONF_PATH;
				getServiceImp(request).startImport(type, filePaths,
						isImportRequired, isUpdate, pathPrefex);
			}
				
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_RETURN).save(request);
			return mapping.findForward("failure");
		} else {
			request.setAttribute("type", request.getParameter("type"));
			return mapping.findForward("status");
		}
	}
	
	/**
	 * 停止导入
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward stopImport(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			getServiceImp(request).stopImport();
		} catch (Exception e) {
			messages.addError(e);
		}

		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		if (messages.hasError()) {
			return mapping.findForward("failure");
		} else {
			return mapping.findForward("success");
		}
	}

}

