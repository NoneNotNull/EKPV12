package com.landray.kmss.code.examine;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.IOUtils;
/**
 * 创建日期 2009-七月-02
 * 
 * @author 周超
 */
public class PropertiesPrinter {

	public static String PATH_SRC = "src";

	public static String PATH_WEB = "WebContent";
	// 目标文件名称可自行修改
	static String setPathName = "15";
	// 目标文件夹
	static String urlTarget = "D:\\" + setPathName + "\\";
	// 命令文件
	static String fileNameBats = "D:\\" + setPathName + ".bat";
	// 根路径
	static String rootPath = "D:\\java\\workspace\\ekp3.0\\";
	// 源文件路径
	static List listSource = new ArrayList();

	public static void main(String args[]) throws IOException {
		writeBatToCN();

	}

	// 文件夹
	public static List getFileDirectiory(String sourceDir, String targetDir)
			throws IOException {

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

	// 获取所有的properties文件名称
	public static List getFileProperties() throws IOException {
		String urlSource = PATH_SRC + "/com/landray/kmss/";
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

	// 读出中文
	public static void writeBatToCN() throws IOException {
		String fileNameBat = fileNameBats;// 设置命令文件
		File fileBat = new File(fileNameBat);// 写入的命令文件
		if (fileBat.exists()) {// 如果文件存在则删除 否则追加会重复
			fileBat.delete();
		}

		FileWriter writerBat = new FileWriter(fileBat, true);// 追加文件
		BufferedWriter bwBat = new BufferedWriter(writerBat);// 写入流

		List listf = getFileProperties();// 获取源文件路径

		for (int i = 0; i < listf.size(); i++) {
			String oldPath = listf.get(i).toString();
			String strPath = oldPath.replace("src\\com\\landray\\kmss\\", "");
			String strRep = strPath.replace("ApplicationResources.properties",
					"");
			String newPath = urlTarget + strRep;
			String filename = rootPath + oldPath;
			FileReader fr = new FileReader(filename);
			BufferedReader br = null;
			StringBuilder sb = new StringBuilder();
			String str;
			try {
				br = new BufferedReader(fr);
				while ((str = br.readLine()) != null) {
					sb.append(str + "\r\n");
				}
			} finally {
				// 关闭流
				IOUtils.closeQuietly(br);
			}
			File tempFile = new File(newPath);
			// 创建目录
			if (!tempFile.exists()) {
				tempFile.mkdirs();
			}
			// 写入Bat命令文件中的内容 为转换命令
			String strContent = "native2ascii -reverse " + rootPath + oldPath
					+ "  " + tempFile
					+ "\\ApplicationResources_zh_CN.properties" + "\r\n";
			bwBat.write(strContent);
			bwBat.newLine();
			bwBat.flush();// 必须刷新否则写入为空

		}
		bwBat.write("pause " + " 共" + (listf.size()) + "份文件，请核实");
		bwBat.close();
		// 自动执行生成出的bat文件
		Runtime r = Runtime.getRuntime();
		r.exec("cmd.exe /c " + "start " + fileNameBat);
	}

}
