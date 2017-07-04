package com.landray.kmss.code.examine;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.landray.kmss.util.StringUtil;

public class PropertiesExCompare {

	public static String PATH_SRC = "src";
	// 目标文件夹
	private static String urlTarget = "d:\\";
	// 文件夹
	private static String setPathName = "ExCompare";

	private static String  prjOld="ekp3.0";
	private static String  prjNew="ekp3.0_publish";
	public static void main(String args[]) throws IOException {
		createHas();
		System.out.println("导出比较执行完毕");
	}
	private static List listSource = new ArrayList();

	// 文件夹
	public static List getFileDirectiory(String sourceDir, String targetDir) {
		// 获取源文件夹当前下的文件或目录
		File[] file = (new File(sourceDir)).listFiles();
		for (int i = 0; i < file.length; i++) {
			if (file[i].isFile()) {
				// 源文件
				File sourceFile = file[i];
				if (sourceFile.getName().equals(
						"ApplicationResources.properties")) {
					// 目标文件
					File targetFile = new File(new File(targetDir)
							.getAbsolutePath()
							+ File.separator + file[i].getName());
					listSource.add(sourceFile);
				}
			}
			if (file[i].isDirectory()) {
				// 准备复制的源文件夹
				String dir1 = sourceDir + "/" + file[i].getName();
				// 准备复制的目标文件夹
				String dir2 = targetDir + "/" + file[i].getName();
				getFileDirectiory(dir1, dir2);
			}
		}
		return listSource;
	}

	private static List listSources = new ArrayList();
	// 文件夹
	public static List getFileDirectiorys(String sourceDir, String targetDir) {

		// 获取源文件夹当前下的文件或目录
		File[] file = (new File(sourceDir)).listFiles();
		for (int i = 0; i < file.length; i++) {
			if (file[i].isFile()) {
				// 源文件
				File sourceFile = file[i];
				if (sourceFile.getName().equals(
						"ApplicationResources.properties")) {
					// 目标文件
					File targetFile = new File(new File(targetDir)
							.getAbsolutePath()
							+ File.separator + file[i].getName());
					listSources.add(sourceFile);
				}
			}
			if (file[i].isDirectory()) {
				// 准备复制的源文件夹
				String dir1 = sourceDir + "/" + file[i].getName();
				// 准备复制的目标文件夹
				String dir2 = targetDir + "/" + file[i].getName();
				getFileDirectiorys(dir1, dir2);
			}
		}
		return listSources;
	}

	// 获取所有的properties文件名称
	public static List getFileProperty(String urlSource) {
		File[] file = (new File(urlSource)).listFiles();
		List listSourceFiles = new ArrayList();
		for (int i = 0; i < file.length; i++) {
			if (file[i].isDirectory()) {
				String sourceDir = urlSource + "/" + File.separator
						+ file[i].getName();
				String targetDir = urlTarget + "/" + File.separator
						+ file[i].getName();

				if (!file[i].getName().equals(".svn")) {
					listSourceFiles = getFileDirectiory(sourceDir, targetDir);
				}
			}
		}
		return listSourceFiles;
	}

	// 获取所有的properties文件名称
	public static List getFileProperties(String urlSource) {
		File[] file = (new File(urlSource)).listFiles();
		List listSourceFiles = new ArrayList();
		for (int i = 0; i < file.length; i++) {
			if (file[i].isDirectory()) {
				String sourceDir = urlSource + "/" + File.separator
						+ file[i].getName();
				String targetDir = urlTarget + "/" + File.separator
						+ file[i].getName();

				if (!file[i].getName().equals(".svn")) {
					listSourceFiles = getFileDirectiorys(sourceDir, targetDir);
				}
			}
		}
		return listSourceFiles;
	}

	// 比较两list
	public static List compareFileName() throws IOException {
		String filePathNew = "D:\\java\\workspace\\"+prjNew+"\\src\\com\\landray\\kmss\\";
		List listHasnt = new ArrayList();
		List listHas = new ArrayList();
		String sourceOld = "D:/java/workspace/"+prjOld+"/" + PATH_SRC
				+ "/com/landray/kmss/";
		String sourceNew = "D:/java/workspace/"+prjNew+"/" + PATH_SRC
				+ "/com/landray/kmss/";
		List listOld = getFileProperty(sourceOld);
		List listNew = getFileProperties(sourceNew);
		List listOldTrim = new ArrayList();
		List listNewTrim = new ArrayList();
		for (int i = 0; i < listOld.size(); i++) {
			String fileNameOld = listOld.get(i).toString();
			fileNameOld = fileNameOld.replace(
					"D:\\java\\workspace\\"+prjOld+"\\src\\com\\landray\\kmss\\",
					"");
			listOldTrim.add(fileNameOld);
		}
		for (int i = 0; i < listNew.size(); i++) {

			String fileNameNew = listNew.get(i).toString();
			fileNameNew = fileNameNew
					.replace(
							"D:\\java\\workspace\\"+prjNew+"\\src\\com\\landray\\kmss\\",
							"");
			listNewTrim.add(fileNameNew);
		}
		// 两文件夹比较
		for (int i = 0; i < listNewTrim.size(); i++) {
			if (listOldTrim.contains(listNewTrim.get(i))) {
				listHas.add(listNewTrim.get(i));
			} else {
				listHasnt.add(listNewTrim.get(i));
			}
		}
		// 创建新增的资源文件
		for (int i = 0; i < listHasnt.size(); i++) {
			File fileDir = createDir(listHasnt.get(i).toString());// 创建新增的文件夹
			File file = createFile(listHasnt.get(i).toString());// 创建空资源文件
			writeFileHasnt(file, filePathNew, listHasnt.get(i).toString());// 写入资源文件内容
		}
		return listHas;
	}
	// 获取资源文件，写入内容
	public static void writeFileHasnt(File file, String filePath, String path)
			throws IOException {
		BufferedWriter writer = new BufferedWriter(new FileWriter(file));
		Properties newProperties = getProperties(filePath, path);

		for (Enumeration keys = newProperties.keys(); keys.hasMoreElements();) {
			String keyName = (String) keys.nextElement();
			String content = newProperties.getProperty(keyName);
			writer.write(keyName + "="
					+ new String(content.getBytes(), "gb2312"));
			writer.write("\r\n");
		}
		writer.close();
	}

	// 创建目录
	public static File createDir(String newPath) throws FileNotFoundException {
		newPath = "D:\\" + setPathName + "\\"
				+ newPath.replace("ApplicationResources.properties", "");
		File tempFile = new File(newPath);

		// 创建目录
		if (!tempFile.exists()) {
			tempFile.mkdirs();
		}

		return tempFile;
	}

	// 创建空文件
	public static File createFile(String newPath) {
		newPath = "D:\\" + setPathName + "\\"
				+ newPath.replace("ApplicationResources.properties", "");
		File file = new File(newPath
				+ "\\ApplicationResources_zh_CN.properties");
		return file;
	}

	// 写入文件内容
	public static void writeFileHasDif(BufferedWriter writer, String content,
			String keyName) throws IOException {
		writer.write(keyName + "=" + new String(content.getBytes(), "gb2312"));
		writer.write("\r\n");

	}

	// 获取资源文件
	public static Properties getProperties(String filePath, String Path)
			throws IOException {
		FileInputStream newInputStream = new FileInputStream(filePath + Path);
		Map newPropertiesMap = new HashMap();
		Properties newProperties = new Properties();
		newProperties.load(newInputStream);
		newInputStream.close();
		return newProperties;
	}

	// 比较内容
	public static boolean compareFileContent(BufferedWriter writer,
			Properties newProperties, Properties oldProperties)
			throws IOException {
		boolean flag = false;
		for (Enumeration keyss = newProperties.keys(); keyss.hasMoreElements();) {
			String newKeyNames = (String) keyss.nextElement();
			String newContents = newProperties.getProperty(newKeyNames);
			String oldContents = oldProperties.getProperty(newKeyNames);
			if (StringUtil.isNotNull(oldContents)
					&& StringUtil.isNotNull(newContents)
					&& !newContents.equals(oldContents)) {
				writeFileHasDif(writer, newContents, newKeyNames);
				flag = true;
			} else if (StringUtil.isNull(oldContents)
					&& StringUtil.isNotNull(newContents)) {
				writeFileHasDif(writer, newContents, newKeyNames);
				flag = true;
			}
		}
		return flag;
	}

	// 相同的资源文件进行比较
	public static void createHas() throws IOException {
		List listHas = compareFileName();
		boolean flag = false;
		for (int i = 0; i < listHas.size(); i++) {
			File fileDir = createDir(listHas.get(i).toString());// 创建文件夹
			File file = createFile(listHas.get(i).toString()); // 创建空资源文件
			BufferedWriter writer = new BufferedWriter(new FileWriter(file));
			String filePathNew = "D:\\java\\workspace\\"+prjNew+"\\src\\com\\landray\\kmss\\";
			Properties newProperties = getProperties(filePathNew, listHas
					.get(i).toString());
			String filePathOld = "D:\\java\\workspace\\"+prjOld+"\\src\\com\\landray\\kmss\\";
			Properties oldProperties = getProperties(filePathOld, listHas
					.get(i).toString());
			flag = compareFileContent(writer, newProperties, oldProperties);
			writer.close();// 关闭流
			if (!flag) {// 如果flag为false则 删除文件
				file.delete();
				File parentFile = fileDir.getParentFile();
				fileDir.delete();
				parentFile.delete();
			}

		}
	}
}
