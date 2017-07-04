package com.landray.kmss.kms.knowledge.util;

import java.util.List;

import org.apache.commons.io.FilenameUtils;

import com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc;
import com.landray.kmss.sys.attachment.model.SysAttMain;
import com.landray.kmss.sys.attachment.util.SysAttUtil;
import com.landray.kmss.sys.filestore.util.SysFileStoreUtil;
import com.landray.kmss.sys.filestore.util.SysFileStoreUtil.FileConverter;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.StringUtil;

import edu.emory.mathcs.backport.java.util.Arrays;

public class KmsKnowledgeUtil {
	/**
	 * 封面图片url,若没上传封面,则取附件的第一条的缩略图
	 * 
	 * @param expert
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static String getImgUrl(KmsKnowledgeBaseDoc baseDoc)
			throws Exception {
		StringBuffer sb = new StringBuffer();
		sb.append("/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do");
		sb.append("?");
		sb.append("method=docThumb");
		sb.append("&");
		sb.append("modelName=com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc");
		sb.append("&");
		sb.append("fdId=" + baseDoc.getFdId());
		sb.append("&");
		sb.append("knowledgeType=" + baseDoc.getFdKnowledgeType());
		return sb.toString();
	}

	/**
	 * 格式化文件大小的显示，以MB，B，G等单位结尾
	 * 
	 * @param fileSize
	 * @return
	 */
	public static String format(String fileSize) {
		String result = "";
		int index;
		double size;
		// fileSize = new String(fileSize);
		if (StringUtil.isNotNull(fileSize)) {
			if ((index = fileSize.indexOf("E")) > 0) {
				size = (Float.parseFloat(fileSize.substring(0, index)) * Math
						.pow(10,
								Integer.parseInt(fileSize.substring(index + 1))));
			} else {
				size = Double.parseDouble(fileSize);
			}
			if (size < 1024)
				result = size + "B";
			else {
				double ksize = Math.round(size * 100 / 1024);
				size = ksize / 100;
				// size = Math.round(size * 100 / 1024) / 100;
				if (size < 1024)
					result = size + "KB";
				else {
					double msize = Math.round(size * 100 / 1024);
					size = msize / 100;
					// size = Math.round(size * 100 / 1024) / 100;
					if (size < 1024)
						result = size + "M";
					else {
						size = Math.round(size * 100 / 1024) / (double) 100;
						result = size + "G";
					}
				}
			}
		}
		return result;
	}

	// 文件格式筛选组合
	public static String getFileTypeHql(List valueList,
			List<String> fileTypeList, String allFileType) {
		if (valueList.contains("doc")) {
			fileTypeList.add("application/msword");
			fileTypeList
					.add("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
		}
		if (valueList.contains("ppt")) {
			fileTypeList.add("application/vnd.ms-powerpoint");
			fileTypeList
					.add("application/vnd.openxmlformats-officedocument.presentationml.presentation");
		}
		if (valueList.contains("pdf")) {
			fileTypeList.add("application/pdf");
		}
		if (valueList.contains("excel")) {
			fileTypeList.add("application/vnd.ms-excel");
			fileTypeList
					.add("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		}
		if (valueList.contains("pic")) {
			String[] imgType = { "image/bmp", "image/jpeg", "image/gif",
					"image/cis-cod", "image/ief", "image/png", "image/pipeg",
					"image/x-icon", "image/x-xwindowdump",
					"image/x-portable-anymap", "image/tiff" };
			fileTypeList.addAll(Arrays.asList(imgType));
		}
		if (valueList.contains("sound")) {
			String[] soundType = { "audio/mpeg", "audio/x-wav", "audio/ogg" };
			fileTypeList.addAll(Arrays.asList(soundType));
		}
		if (valueList.contains("video")) {
			String[] videoType = { "audio/x-pn-realaudio", "audio/wrf",
					"audio/f4v", "video/mp4", "video/3gpp", "video/wmv9",
					"video/x-ms-wmv", "video/x-flv", "video/x-ms-asf",
					"video/x-msvideo", "video/x-sgi-movie", "video/quicktime",
					"video/mpeg", "video/x-la-asf" };
			fileTypeList.addAll(Arrays.asList(videoType));
		}
		if (valueList.contains("others")) {
			String[] allType = {
					"application/vnd.openxmlformats-officedocument.presentationml.presentation",
					"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
					"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
					"audio/x-pn-realaudio", "audio/wrf", "audio/f4v",
					"video/mp4", "video/3gpp", "video/wmv9", "video/x-ms-wmv",
					"video/x-flv", "video/x-ms-asf", "video/x-msvideo",
					"video/x-sgi-movie", "video/quicktime", "video/mpeg",
					"video/x-la-asf", "audio/mpeg", "audio/x-wav", "audio/ogg",
					"image/bmp", "image/jpeg", "image/gif", "image/cis-cod",
					"image/ief", "image/png", "image/pipeg", "image/x-icon",
					"image/x-xwindowdump", "image/x-portable-anymap",
					"image/tiff", "application/vnd.ms-excel",
					"application/pdf", "application/vnd.ms-powerpoint",
					"application/msword" };

			List<String> interType = ArrayUtil.convertArrayToList(allType);
			interType.removeAll(fileTypeList);
			StringBuilder sBuilder = new StringBuilder();
			for (String inter : interType) {
				sBuilder.append("'" + inter + "',");
			}
			allFileType = " not in ("
					+ sBuilder.substring(0, sBuilder.length() - 1) + ")";
		} else {
			StringBuilder sBuilder = new StringBuilder();
			for (String ls : fileTypeList) {
				sBuilder.append("'" + ls + "',");
			}
			allFileType = " in ("
					+ sBuilder.substring(0, sBuilder.length() - 1) + ")";

		}
		return allFileType;
	}

	public static String getThumbUrlByAttMain(SysAttMain attmain) {
		String imgAttUrl = "";
		String fileName = FilenameUtils.getExtension(attmain.getFdFileName());
		String extName = fileName.substring(fileName.lastIndexOf(".") + 1);
		List<FileConverter> converters = SysFileStoreUtil.getFileConverters(
				extName, attmain.getFdModelName());
		if (converters.size() > 0) {
			FileConverter converter = converters.get(0);
			if (converter.getConverterKey().equals("image2thumbnail"))
				imgAttUrl = "/sys/attachment/sys_att_main/sysAttMain.do?method=view&filekey=image2thumbnail_s1&fdId="
						+ attmain.getFdId();
			else
				imgAttUrl = "/sys/attachment/sys_att_main/sysAttMain.do?method=view&filethumb=yes&fdId="
						+ attmain.getFdId();
		}
		return imgAttUrl;
	}
}