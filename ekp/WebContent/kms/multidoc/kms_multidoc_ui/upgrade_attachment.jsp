<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.kms.knowledge.util.KmsKnowledgeUtil"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.landray.kmss.common.dao.HQLInfo"%>
<%@page import="com.landray.kmss.sys.attachment.model.SysAttMain"%>
<%@page import="java.io.File"%>
<%@page import="com.landray.kmss.sys.attachment.util.ThumbnailUtil"%>
<%@page import="com.landray.kmss.sys.attachment.model.SysAttFile"%>
<%@page import="com.landray.kmss.sys.attachment.service.ISysAttMainCoreInnerService"%>
<%@page import="com.landray.kmss.sys.attachment.service.ISysAttUploadService"%>
<%@page import="java.io.File"%>
<%
	//更新文档库播放器中的大图质量
	ISysAttUploadService sysAttUploadService = (ISysAttUploadService) SpringBeanUtil
							.getBean("sysAttUploadService");
	List fileType = Arrays.asList(new Object[] { "pic"});
	List<String> fileTypeList = new ArrayList<String>();
	String allFileType = "";
	allFileType = KmsKnowledgeUtil.getFileTypeHql(fileType, fileTypeList, allFileType);//获得所有完整格式
	
	HQLInfo hqlInfo = new HQLInfo();
	String whereBlock = " fdModelName=:fdModelName and fdKey=:fdKey and fdContentType "+allFileType;
	hqlInfo.setWhereBlock(whereBlock);
	hqlInfo.setParameter("fdModelName", "com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge");
	hqlInfo.setParameter("fdKey","attachment");
	
	ISysAttMainCoreInnerService sysAttMainCoreInnerService = ((ISysAttMainCoreInnerService) SpringBeanUtil.getBean("sysAttMainService"));
	List<?> list = sysAttMainCoreInnerService.findList(hqlInfo);
	for (Object o : list) {
		
		SysAttMain sysAttMain = (SysAttMain) o;
		String attLocation = sysAttMain.getFdAttLocation();
		String contentType = sysAttMain.getFdContentType();
		String picPath = "";
		if("file".equals(attLocation)){
			picPath = sysAttMain.getFdFilePath();
		}else if("server".equals(attLocation)){
			String fileId = sysAttMain.getFdFileId();
			
			sysAttUploadService = (ISysAttUploadService) SpringBeanUtil
					.getBean("sysAttUploadService");
			SysAttFile attFile = sysAttUploadService.getFileById(fileId);
			
			String cfgPath = sysAttUploadService.getDefaultCatalog();
			if (StringUtil.isNotNull(cfgPath)) {
				cfgPath = cfgPath.replace("\\", "/");
			}
			if (cfgPath.endsWith("/"))
				cfgPath = cfgPath.substring(0, cfgPath.length() - 1);
			picPath = cfgPath + attFile.getFdFilePath();
		}
		if("image/jpeg".equals(contentType)||"image/bmp".equals(contentType)){//对图片格式进行更新
			//删除旧的数据
			File dir = new File(picPath + "_"
					+ "s2");
			if (dir.exists()) {
				FileUtil.deleteFile(dir);
			}
			if(new File(picPath).exists()){
				ThumbnailUtil.resizeByFix(Integer.valueOf("2250").intValue(),
						Integer.valueOf("1695").intValue(), picPath + "_"
								+ "s2", FileUtil.getInputStream(new File(picPath)));
			}
		}
		
	}

%>
<div id="optBarDiv">
		<input type="button"
			value="更新完成"
			onclick="#">
</div>

<%@ include file="/resource/jsp/view_down.jsp"%>