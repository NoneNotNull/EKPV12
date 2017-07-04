package com.landray.kmss.common.actions;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.landray.kmss.common.forms.FileUploadForm;
import com.landray.kmss.sys.config.loader.ConfigLocationsUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;

public class FileUploadAction extends Action {
	public static String UPLOAD_FILE_NAME_KEY = "com.landray.kmss.common.actions.UPLOAD_FILE_NAME";

	public static String UPLOAD_FILE_PATH_KEY = "com.landray.kmss.common.actions.UPLOAD_FILE_PATH";

	public static String UPLOAD_METHOD_INVOKE = "invoke";

	public static String UPLOAD_METHOD_INVOKE_FORWARD = "invoke_forward";

	public static String UPLOAD_METHOD_FORWARD = "forward";

	private static final Log logger = LogFactory.getLog(FileUploadAction.class);

	private static ApplicationContext ctx = null;

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		FileUploadForm uploadForm = (FileUploadForm) form;
		try {
			// 获取执行方式
			String type = request.getParameter("method");
			if (type == null || type.trim().length() == 0)
				throw new Exception("UnKnown Operation Method.");

			String link_path = request.getParameter("link_path");
			String beanid = request.getParameter("beanid");

			// 接收数据
			String pointFilePath = request.getParameter("file_path");
			String filename = uploadForm.getFile().getFileName();
			String filePath = getFilePath(request, filename, pointFilePath);
			logger.debug("filePath:" + filePath);
			InputStream in = uploadForm.getFile().getInputStream();
//			String uploadPath = getServlet().getServletContext().getRealPath(
//					filePath);
			String uploadPath =StringUtil.linkPathString(ConfigLocationsUtil.getWebContentPath(),filePath);
			logger.debug("uploadPath:" + uploadPath);
			File outPutFile = new File(uploadPath);
			if (!outPutFile.exists())
				outPutFile.createNewFile();
			FileOutputStream fos = new FileOutputStream(outPutFile);
			int ch = in.read();
			while (ch != -1) {
				fos.write(ch);
				ch = in.read();
			}
			fos.flush();
			fos.close();
			in.close();

			Map params = request.getParameterMap();
			params.put(UPLOAD_FILE_NAME_KEY, filename);
			params.put(UPLOAD_FILE_PATH_KEY, uploadPath);
			request.setAttribute(UPLOAD_FILE_NAME_KEY, filename);
			request.setAttribute(UPLOAD_FILE_PATH_KEY, uploadPath);

			if (type.equals(UPLOAD_METHOD_INVOKE_FORWARD)
					|| type.equals(UPLOAD_METHOD_INVOKE)) {
				IFileUploadAware bean = (IFileUploadAware) getBean(beanid);
				if (bean == null)
					throw new Exception("Can't find bean by id=" + beanid);
				FileUploadReturn fur = bean.execute(params);
				if (fur != null) {
					if (fur.getKmssMessages() != null)
						messages = fur.getKmssMessages();
					if (fur.getBussinessReturn() != null) {
						Map bussinessReturn = fur.getBussinessReturn();
						for (Iterator it = bussinessReturn.keySet().iterator(); it
								.hasNext();) {
							Object key = it.next();
							Object value = bussinessReturn.get(key);
							request.setAttribute(key.toString(), value);
						}
					}
				}
			}

			if (type.equals(UPLOAD_METHOD_FORWARD)
					|| type.equals(UPLOAD_METHOD_INVOKE_FORWARD)) {
				if (!link_path.startsWith("/"))
					link_path = "/" + link_path;
				if (request.getQueryString().length() > 0) {
					if (link_path.indexOf("?") > 0) {
						link_path += "&" + request.getQueryString();
					} else {
						link_path += "?" + request.getQueryString();
					}
				}
				KmssReturnPage.getInstance(request).addMessages(messages)
						.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
				return new ActionForward(link_path);
			}

			// messages.addError(new KmssMessage("errors.norecord"));

		} catch (Exception e) {
			messages.addError(e);
			e.printStackTrace();
		}

		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		if (messages.hasError())
			return mapping.findForward("failure");
		else
			return mapping.findForward("success");
	}

	private String getFilePath(HttpServletRequest request,
			String source_filename, String pointFilePath) {
		String ext = "";
		String source_filename_no_ext = source_filename;
		if (source_filename.indexOf(".") > 0) {
			ext = source_filename.substring(source_filename.lastIndexOf("."));
			source_filename_no_ext = source_filename.substring(0,
					source_filename.lastIndexOf("."));
		}
		String uploadRefPath = (pointFilePath == null || pointFilePath.trim()
				.length() == 0) ? "/WEB-INF/upload/" : pointFilePath;
//		String uploadPath = getServlet().getServletContext().getRealPath(
//				uploadRefPath);
		String uploadPath = StringUtil.linkPathString(ConfigLocationsUtil.getWebContentPath(),uploadRefPath);
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists())
			uploadDir.mkdirs();
		Date today = new Date();
		String formatString = "yyyyMMddHHmmss";
		SimpleDateFormat dateformat = new SimpleDateFormat(formatString);
		String filename = source_filename_no_ext + dateformat.format(today);
		for (int i = 0; i < 10000; i++) {
			String real_filename = filename + "_" + i + ext;
			File file = new File(uploadDir, real_filename);
			if (!file.exists()) {
				return uploadRefPath + real_filename;
			}
		}
		return null;
	}

	/**
	 * 根据spring配置的业务对象名称，取得业务对象实例。
	 * 
	 * @param name
	 *            spring配置的业务对象名称
	 * @return spring的业务对象（service）
	 */
	public Object getBean(String name) {
		if (ctx == null) {
			ctx = WebApplicationContextUtils
					.getRequiredWebApplicationContext(servlet
							.getServletContext());
		}
		return ctx.getBean(name);
	}
}
