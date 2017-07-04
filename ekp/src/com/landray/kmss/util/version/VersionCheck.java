package com.landray.kmss.util.version;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.landray.kmss.sys.config.loader.ConfigLocationsUtil;
import com.landray.kmss.util.MD5Util;
import com.landray.kmss.util.StringUtil;

public class VersionCheck {
	public static final String PATH_WEB = ConfigLocationsUtil
			.getWebContentPath();

	public static final String PATH_JSP = ConfigLocationsUtil
			.getWebContentPath();

	public static final String PATH_CONFIG = ConfigLocationsUtil
			.getKmssConfigPath();

	public static final String PATH_LIB = ConfigLocationsUtil
			.getWebContentPath()
			+ "/WEB-INF/lib";
	public static final String PATH_MODULE_CLASSES = ConfigLocationsUtil
			.getWebContentPath()
			+ "/WEB-INF/classes/com/landray/kmss";
	private static final List<String> exceptFiles = new ArrayList<String>();

	private static List<String> acceptOtherFolderPaths = new ArrayList<String>();

	static {
		acceptOtherFolderPaths.add(PATH_JSP);
		acceptOtherFolderPaths.add(PATH_JSP + "/sys");
		acceptOtherFolderPaths.add(PATH_CONFIG);
		acceptOtherFolderPaths.add(PATH_CONFIG + "/sys");

		exceptFiles.add(PATH_CONFIG + "/ekp.license");
		exceptFiles.add(PATH_CONFIG + "/kmssconfig.properties");
		exceptFiles.add(PATH_CONFIG + "/ldapconfig.properties");
		exceptFiles.add(PATH_CONFIG + "/ssoconfig.properties");
		exceptFiles.add(PATH_CONFIG + "/landray.license");
		exceptFiles.add(PATH_CONFIG + "/admin.properties");
		exceptFiles.add(PATH_CONFIG + "/LRToken");
	}

	private static HashMap<String, String> prodMd5 = new HashMap<String, String>();

	private static HashMap<String, String> projectMd5 = new HashMap<String, String>();

	/**
	 * 比较版本信息
	 * 
	 * @param path
	 * @param isCore
	 * @return
	 * @throws Exception
	 */
	public static List<Difference> compareVersion(String path, boolean isCore)
			throws Exception {
		if (isCore) {
			exceptFiles.add(PATH_CONFIG + "/version/version.xml");
			exceptFiles.add(PATH_CONFIG + "/version/description.xml");
			exceptFiles.add(PATH_CONFIG + "/version/md5.txt");
		} else {
			exceptFiles.add(PATH_CONFIG + path + "/version/version.xml");
			exceptFiles.add(PATH_CONFIG + path + "/version/description.xml");
			exceptFiles.add(PATH_CONFIG + path + "/version/md5.txt");
		}
		List<Difference> differences = new ArrayList<Difference>();
		String md5Txt = PATH_CONFIG + path + "/version/md5.txt";
		prodMd5 = loadProdMd5File(path, new File(md5Txt), isCore);
		projectMd5 = loadProductMd5FromTarget(path, isCore);
		// 用项目MD5和产品MD5比较
		for (String key : projectMd5.keySet()) {
			String prodFileMd5 = prodMd5.get(key);
			String projectFileMd5 = projectMd5.get(key);
			// 产品md5为空则属于项目增加
			if (StringUtil.isNull(prodFileMd5)) {
				Difference difference = new Difference();
				difference.setFilePath(key.replace(PATH_WEB, ""));
				difference.setProjectMd5(projectFileMd5);
				difference.setType("项目新增");
				differences.add(difference);
			} else {
				// 产品MD5不等于项目MD5则为项目修改
				if (!projectFileMd5.equals(prodFileMd5)) {
					Difference difference = new Difference();
					difference.setFilePath(key.replace(PATH_WEB, ""));
					difference.setProdMd5(prodFileMd5);
					difference.setProjectMd5(projectFileMd5);
					difference.setType("项目修改");
					differences.add(difference);
				}
			}
			// 从产品MD5中移出该文件
			prodMd5.remove(key);
		}
		// 剩下的prodMd5则是项目删除的文件
		for (String key : prodMd5.keySet()) {
			if (!exceptFiles.contains(key)) {
				String prodFileMd5 = prodMd5.get(key);
				Difference difference = new Difference();
				difference.setFilePath(key.replace(PATH_WEB, ""));
				difference.setProjectMd5(prodFileMd5);
				difference.setType("项目删除");
				differences.add(difference);
			}
		}
		return differences;
	}

	/**
	 * 读取产品MD5文件信息
	 * 
	 * @param file
	 * @throws Exception
	 */
	private static HashMap<String, String> loadProdMd5File(String path,
			File file, boolean isCore) throws Exception {
		BufferedReader reader = new BufferedReader(new InputStreamReader(
				new FileInputStream(file), "UTF-8"));
		prodMd5 = new HashMap<String, String>();
		try {
			for (String s = reader.readLine(); s != null; s = reader.readLine()) {
				// s字符串格式：“文件路径=产品md5码,项目md5码”,读取第一个产品md5
				s = s.trim();
				if (s.length() == 0)
					continue;
				int i = s.indexOf("=");
				if (i == -1)
					continue;
				String filePath = s.substring(0, i);
				// 更改为项目路径,将webContent更换为实际项目路径
				filePath = filePath.replace("WebContent", PATH_WEB);
				// core中md5文件中包含一部分公共的src，所以需要排除
				if (!filePath.startsWith("src/")
						&& !filePath.contains(path + "/version/")) {
					String md5String = s.substring(i + 1);
					int j = md5String.indexOf(',');
					if (j == -1) {
						prodMd5.put(filePath, md5String);
					} else {
						prodMd5.put(filePath, md5String.substring(0, j));
					}
				}
			}
		} finally {
			reader.close();
		}
		return prodMd5;
	}

	/**
	 * 从项目文件中读取md5
	 * 
	 * @throws Exception
	 */
	private static HashMap<String, String> loadProductMd5FromTarget(
			String path, boolean isCore) throws Exception {
		projectMd5 = new HashMap<String, String>();
		String jarPath = null;
		// 遍历文件，读取MD5信息
		if (isCore) {
			// core，遍历所有可能的文件
			loadFileMd5(PATH_WEB);
			// 处理jar文件
			jarPath = PATH_LIB + "/kmss_core.jar";
		} else {
			loadFileMd5(PATH_JSP + path);
			loadFileMd5(PATH_CONFIG + path);
			loadFileMd5(PATH_MODULE_CLASSES + path);
			// 处理jar文件
			jarPath = PATH_LIB + "/kmss" + path.replace('/', '_') + ".jar";
		}
		File file = new File(jarPath);
		if (file.exists()) {
			projectMd5.put(jarPath, MD5Util.getMD5String(file));
		}
		return projectMd5;
	}

	/**
	 * 指定目标项目某个文件夹，遍历该文件夹下的文件，读取最新的MD5信息
	 * 
	 * @param basePath
	 *            相对与项目的路径，如WebContent/km/doc，null表示根目录
	 * @throws Exception
	 */
	private static void loadFileMd5(String basePath) throws Exception {
		String path = basePath;
		File folder = new File(path);
		if (folder.exists() && folder.isDirectory()) {
			loadFileMd5(folder, basePath);
		}
	}

	/**
	 * 指定某个文件夹，遍历该文件夹下的文件，读取最新的MD5信息
	 * 
	 * @param folder
	 * @param basePath
	 * @throws Exception
	 */
	private static void loadFileMd5(File folder, String basePath)
			throws Exception {
		File[] files = folder.listFiles();
		for (File file : files) {
			String fileName = file.getName();
			// 检查合法性
			if (fileName.startsWith(".") || fileName.equals("md5.txt"))
				continue;
			if (true && !checkFileInCore(file, basePath))
				continue;
			String filePath = StringUtil.isNull(basePath) ? fileName
					: (basePath + "/" + fileName);
			if (file.isDirectory()) {
				// 遍历下一层目录
				loadFileMd5(file, filePath);
			} else {
				if (!exceptFiles.contains(filePath)) {
					// 写入md5信息
					projectMd5.put(filePath, MD5Util.getMD5String(file));
				}
			}
		}
	}

	/**
	 * 检查某个目录/文件是否属于core，注意：非core目录只能传入第一层，如：WebContent/km目录可以检查出不是core，
	 * 但不能输入WebContent/km/doc目录校验
	 * 
	 * @param file
	 * @param basePath
	 * @return
	 */
	private static boolean checkFileInCore(File file, String basePath) {
		String fileName = file.getName();
		if (file.isDirectory()) {
			String filePath = basePath + "/" + fileName;

			// 排除class目录
			if (filePath.equals(ConfigLocationsUtil.getWebContentPath()
					+ "/WEB-INF/classes"))
				return false;

			// 判断该目录是否混杂其它模块的目录
			if (acceptOtherFolderPaths.contains(basePath)) {
				// 从已经加入的产品文件列表中比较，若该路径未出现过，则不是core模块
				filePath += "/";
				Iterator<String> paths = prodMd5.keySet().iterator();
				while (paths.hasNext()) {
					String path = paths.next();
					if (path.startsWith(filePath)) {
						return true;
					}
				}
				return false;
			}
		} else {
			// 排除jar包、根目录文件
			if (StringUtil.isNull(basePath)
					|| (basePath.equals(PATH_LIB)
							&& fileName.startsWith("kmss_")
							&& fileName.endsWith(".jar") && !fileName
							.equals("kmss_core.jar")))
				return false;
		}
		return true;
	}

}
