package com.landray.kmss.code.examine;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.landray.kmss.util.StringUtil;

public class PropertiesImCompare {

	public static void main(String[] args) throws IOException {
		writeBatToEn();
		appandHas();
		System.out.println("执行完毕");
	}
	// 目标文件名称可自行修改
	private static String setPathName = "ImCompare";
	public static String PATH_SRC = "src";
	// 命令文件
	private static String fileNameBats = "D:\\" + setPathName
			+ "_importAPPand.bat";
	private static String rootPath = "D:\\" + setPathName + "\\";
	// 目标文件夹
	private static String urlTarget = "D:\\java\\workspace\\ekp3.0\\src\\com\\landray\\kmss\\";

	private static List listSource = new ArrayList();
	private static List listSources = new ArrayList();
	// 获取文件夹
	public static List getFileDirectiory(String sourceDir, String targetDir)
			throws IOException {
		// 获取源文件夹当前下的文件或目录
		File[] file = (new File(sourceDir)).listFiles();
		for (int i = 0; i < file.length; i++) {
			if (file[i].isFile()) {
				// 源文件
				File sourceFile = file[i];
				if (sourceFile.getName().endsWith("en.properties")) {
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

	// 获取所有的properties文件名称
	public static List getFileProperty(String urlSource) throws IOException {
		File[] file = (new File(urlSource)).listFiles();
		List listSourceFiles = new ArrayList();
		for (int i = 0; i < file.length; i++) {
			if (file[i].isDirectory()) {
				String sourceDir = urlSource + "/" + File.separator
						+ file[i].getName();
				String targetDir = urlTarget + "/" + File.separator
						+ file[i].getName();
				listSourceFiles = getFileDirectiory(sourceDir, targetDir);
			}
		}
		return listSourceFiles;
	}

	// 文件夹en.properties workspace里面的
	public static List getFileDirectiorys(String sourceDir, String targetDir) {
		// 获取源文件夹当前下的文件或目录
		File[] file = (new File(sourceDir)).listFiles();
		for (int i = 0; i < file.length; i++) {
			if (file[i].isFile()) {
				// 源文件
				File sourceFile = file[i];
				if (sourceFile.getName().endsWith("en.properties")) {
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

	// 获取所有的properties文件名称 workspace里面的
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

	// 获取PropertiesList
	public static List getFileTirmPropertiy(String prex) throws IOException {
		List listProperties = new ArrayList();
		listProperties = getFileProperty(prex);
		List listProTrim = new ArrayList();
		for (int i = 0; i < listProperties.size(); i++) {
			String fileName = listProperties.get(i).toString();
			fileName = fileName.replace(prex, "");
			listProTrim.add(fileName);
		}
		return listProTrim;
	}

	// 获取PropertiesList workspace里面的
	public static List getFileTirmProperties(String prex) throws IOException {
		List listProperties = new ArrayList();
		listProperties = getFileProperties(prex);
		List listProTrim = new ArrayList();
		for (int i = 0; i < listProperties.size(); i++) {
			String fileName = listProperties.get(i).toString();
			fileName = fileName.replace(prex, "");
			listProTrim.add(fileName);
		}
		return listProTrim;
	}

	// 比较两list
	public static List compareFileName() throws IOException {
		List listHasnt = new ArrayList();
		List listHas = new ArrayList();
		List listOldTrim = getFileTirmProperties(urlTarget);
		List listNewTrim = getFileTirmPropertiy(rootPath);
		String filePathPre = rootPath;
		// 两文件夹比较
		for (int i = 0; i < listNewTrim.size(); i++) {
			if (listOldTrim.contains(listNewTrim.get(i))) {
				listHas.add(listNewTrim.get(i));
			} else {
				listHasnt.add(listNewTrim.get(i));
			}
		}
		for (int i = 0; i < listHasnt.size(); i++) {
			System.out.println("listHasnt" + i + " = "
					+ listHasnt.get(i).toString());
		}
		for (int i = 0; i < listHas.size(); i++) {
			System.out.println("listHas" + i + " = "
					+ listHas.get(i).toString());
		}

		// 创建新增的资源文件
		for (int i = 0; i < listHasnt.size(); i++) {
			File file = createFile(listHasnt.get(i).toString());// 创建空资源文件
			writeFileHasnt(file, filePathPre, listHasnt.get(i).toString());
			System.out.println(listHasnt.get(i).toString());
			// 写入资源文件内容
		}
		return listHas;
	}

	// 创建空文件
	public static File createFile(String newPath) {
		newPath = urlTarget
				+ newPath.replace("ApplicationResources_en.properties", "");
		File file = new File(newPath + "\\ApplicationResources_en.properties");
		return file;
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

	public static void writeFileHasnt(File file, String filePath, String path)
			throws IOException {
		Properties newProperties = getProperties(filePath, path);
		FileOutputStream outPutStream = new FileOutputStream(file);
		newProperties.store(outPutStream, "");
		outPutStream.close();

	}

	// 对于已经存在的资源文件 进行比较 如果内容多增出来，那么在后面追加

	public static void appandHas() throws IOException {
		List listHas = compareFileName();// 获取已经存在的资源文件
		for (int i = 0; i < listHas.size(); i++) {
			String filePathNew = rootPath;
			Properties newProperties = getProperties(filePathNew, listHas
					.get(i).toString());
			String filePathOld = urlTarget;
			Properties oldProperties = getProperties(filePathOld, listHas
					.get(i).toString());
			String path = listHas.get(i).toString();

			Properties properties = compareFileContent(newProperties,
					oldProperties);// 比较两资源文件
			File file = createFile(listHas.get(i).toString());// 创建空资源文件
			System.out.println("比较文件=" + listHas.get(i).toString());
			FileOutputStream outPutStream = new FileOutputStream(file);
			properties.store(outPutStream, "");
			outPutStream.close();

		}
	}

	// 比较内容
	public static Properties compareFileContent(Properties newProperties,
			Properties oldProperties) throws IOException {
		boolean flag = false;
		Properties properties = new Properties();
		for (Enumeration keyss = newProperties.keys(); keyss.hasMoreElements();) {
			String newKeyNames = (String) keyss.nextElement();
			String newContents = newProperties.getProperty(newKeyNames);
			String oldContents = oldProperties.getProperty(newKeyNames);
			if (StringUtil.isNotNull(oldContents)
					&& StringUtil.isNotNull(newContents)
					&& !newContents.equals(oldContents)) {
				properties.setProperty(newKeyNames, newContents);
				System.out.println("newContents=" + newContents);
				flag = true;
			} else if (StringUtil.isNull(oldContents)
					&& StringUtil.isNotNull(newContents)) {
				properties.setProperty(newKeyNames, newContents);
				System.out.println("newContents=" + newContents);
				flag = true;
			}

		}
		for (Enumeration keys = oldProperties.keys(); keys.hasMoreElements();) {
			String oldKeyName = (String) keys.nextElement();
			String oldContent = newProperties.getProperty(oldKeyName);
			properties.setProperty(oldKeyName, oldContent);
			System.out.println("oldContent=" + oldContent);
		}

		return properties;
	}

	// 读入英文
	public static void writeBatToEn() throws IOException {
		String fileNameBat = fileNameBats;// 设置命令文件
		File fileBat = new File(fileNameBat);// 写入的命令文件
		if (fileBat.exists()) {// 如果文件存在则删除 否则追加会重复
			fileBat.delete();
		}
		FileWriter writerBat = new FileWriter(fileBat, true);// 追加文件
		BufferedWriter bwBat = new BufferedWriter(writerBat);// 写入流
		List listf = getFilePropertyBat(rootPath);;// 获取源文件路径
		for (int i = 0; i < listf.size(); i++) {
			String oldPath = listf.get(i).toString();
			String newPath = oldPath.replace(rootPath, "");
			newPath = newPath.replace(
					"\\ApplicationResources_zh_CN.properties", "");

			// 必须刷新否则写入为空
			String strContent = "native2ascii   " + oldPath + " " + rootPath
					+ newPath + "\\ApplicationResources_en.properties" + "\r\n";

			System.out.println(strContent);

			bwBat.write(strContent);
			bwBat.newLine();

		}
		bwBat.write("pause " + " 共" + (listf.size()) + "份文件，请核实");
		bwBat.close();

		// 自动执行生成出的bat文件
		Runtime r = Runtime.getRuntime();
		r.exec("cmd.exe /c " + "start " + fileNameBat);
	}

	private static List listSourceBat = new ArrayList();

	// 获取文件夹
	public static List getFileDirectioryBat(String sourceDir, String targetDir)
			throws IOException {
		// 获取源文件夹当前下的文件或目录
		File[] file = (new File(sourceDir)).listFiles();
		for (int i = 0; i < file.length; i++) {
			if (file[i].isFile()) {
				// 源文件
				File sourceFile = file[i];
				if (sourceFile.getName().endsWith("zh_CN.properties")) {
					listSourceBat.add(sourceFile);
				}
			}
			if (file[i].isDirectory()) {
				// 准备复制的源文件夹
				String dir1 = sourceDir + "/" + file[i].getName();
				// 准备复制的目标文件夹
				String dir2 = targetDir + "/" + file[i].getName();
				getFileDirectioryBat(dir1, dir2);
			}
		}
		return listSourceBat;
	}

	// 获取所有的properties文件名称
	public static List getFilePropertyBat(String urlSource) throws IOException {
		File[] file = (new File(urlSource)).listFiles();
		List listSourceFiles = new ArrayList();
		for (int i = 0; i < file.length; i++) {
			if (file[i].isDirectory()) {
				String sourceDir = urlSource + "/" + File.separator
						+ file[i].getName();
				String targetDir = urlTarget + "/" + File.separator
						+ file[i].getName();
				listSourceFiles = getFileDirectioryBat(sourceDir, targetDir);
			}
		}
		return listSourceFiles;
	}

}
