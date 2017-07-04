<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="com.landray.kmss.util.version.*" %>
<%@ page import="com.landray.kmss.common.exception.KmssException" %>
<%@ page import="com.landray.kmss.sys.config.loader.ConfigLocationsUtil" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>导出版本信息</title>
</head>
<body>
<%!
	/**
	 * 下载
	 * 
	 * @param response
	 * @param str
	 * @throws Exception
	 */
	private void download(HttpServletResponse response, String str)
			throws Exception {
		InputStream fis = null;
		OutputStream out = null;
		try {
			fis = new ByteArrayInputStream(str.getBytes("UTF-8"));
			response.reset();
			response.setContentLength(fis.available());
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition",
					"attachment;filename=\"prod.version\"");
			out = response.getOutputStream();
			int c = fis.read();
			while (c != -1) {
				out.write(c);
				c = fis.read();
			}
			response.flushBuffer();
		} catch (IOException e) {
			throw new KmssException(e);
		} finally {
			try {
				if (fis != null) {
					fis.close();
				}
				if (out != null) {
					out.close();
				}
			} catch (Exception e) {
			}
		}
	}
	
	private static File[] getFiles(String dir, String s) {
		// 起始文件夹
		File file = new File(dir);
		s = s.replace('.', '#');
		s = s.replaceAll("#", "\\\\.");
		s = s.replace('*', '#');
		s = s.replaceAll("#", ".*");
		s = s.replace('?', '#');
		s = s.replaceAll("#", ".?");
		s = "^" + s + "$";
		
		Pattern p = Pattern.compile(s);
		List<File> list = filePattern(file, p);
		if (list == null) {
			return null;
		}
		File[] rtn = new File[list.size()];
		list.toArray(rtn);
		return rtn;
	}
	
	/**
	* @param file
	*            File 起始文件夹
	* @param p
	*            Pattern 匹配类型
	* @return ArrayList 其文件夹下的文件夹
	*/
	private static List<File> filePattern(File file, Pattern p) {
		if (file == null) {
			return null;
		} else if (file.isFile()) {
			Matcher fMatcher = p.matcher(file.getName());
			if (fMatcher.matches()) {
				List<File> list = new ArrayList<File>();
				list.add(file);
				return list;
			}
		} else if (file.isDirectory()) {
			File[] files = file.listFiles();
			if (files != null && files.length > 0) {
				List<File> list = new ArrayList<File>();
				for (int i = 0; i < files.length; i++) {
					List<File> rlist = filePattern(files[i], p);
					if (rlist != null) {
						list.addAll(rlist);
					}
				}
				return list;
			}
		}
		return null;
	}
%>
<%
	File[] descriptions = getFiles(ConfigLocationsUtil.getKmssConfigPath(), "description.xml");
	if (descriptions != null && descriptions.length > 0) {
		StringBuffer sb = new StringBuffer();
		for (File description : descriptions) {
			String desFilePath = description.getPath(); // description文件路径
			Description des = VersionXMLUtil.getInstance(desFilePath)
					.getDescriprion();
			if (des == null) {
				System.out.println("获取description.xml文件：" + desFilePath
						+ "版本信息为空");
				continue;
			}
			Module module = des.getModule();
			if (module == null) {
				System.out.println("description.xml文件" + desFilePath
						+ "没有找到版本模块信息!");
				continue;
			}
			if (sb.length() != 0) {
				sb.append("\r\n");
			}
			sb.append(module.getModulePath());
			sb.append("|");
			sb.append(module.getBaseline() != null ? module.getBaseline()
					: "");
			sb.append("|");
			sb.append(module.getIsCustom() != null ? module.getIsCustom()
					: "");
		}
		download(response, sb.toString());
		out.clear();
		out = pageContext.pushBody();
	} else {
		throw new Exception("没有找到版本信息");
	}
%>
</body>
</html>