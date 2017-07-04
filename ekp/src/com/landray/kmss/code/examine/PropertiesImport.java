package com.landray.kmss.code.examine;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * 创建日期 2009-七月-13
 * 
 * @author 周超
 */
public class PropertiesImport {

	public static String PATH_SRC = "src";

	// 目标文件名称可自行修改
	private static String rootDir = "d:\\";
	private static String setPathName = "EKP_Import";
	// 目标文件夹
	private static String urlTarget = "D:\\java\\workspace\\ekp3.0\\";
	// 命令文件
	private static String fileNameBats = "D:\\" + setPathName + ".bat";
	// 根路径
	private static String rootPath = rootDir + setPathName + "\\";
	// 源文件路径
	private static List listSource = new ArrayList();

	public static void main(String args[]) throws IOException {
		writeBatToEn();
		System.out.print("导入完毕");

	}

	// 获取文件夹
	public static List getFileDirectiory(String sourceDir, String targetDir)
			throws IOException {
		// 获取源文件夹当前下的文件或目录
		File[] file = (new File(sourceDir)).listFiles();

		for (int i = 0; i < file.length; i++) {
			if (file[i].isFile()) {
				// 源文件
				File sourceFile = file[i];
				if (sourceFile.getName().endsWith(".properties")) {
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
		String urlSource = rootPath;

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

	// 读入英文
	public static void writeBatToEn() throws IOException {
		String fileNameBat = fileNameBats;// 设置命令文件
		File fileBat = new File(fileNameBat);// 写入的命令文件
		if (fileBat.exists()) {// 如果文件存在则删除 否则追加会重复
			fileBat.delete();
		}

		String src = "src\\com\\landray\\kmss\\";
		FileWriter writerBat = new FileWriter(fileBat, true);// 追加文件
		BufferedWriter bwBat = new BufferedWriter(writerBat);// 写入流
		List listf = getFileProperties();// 获取源文件路径
		for (int i = 0; i < listf.size(); i++) {
			String oldPath = listf.get(i).toString();
			String newPath = oldPath.replace(rootPath, "");
			newPath = newPath.replace(
					"\\ApplicationResources_en_US.properties", "");

			// 必须刷新否则写入为空
			String strContent = "native2ascii   " + oldPath + "  " + urlTarget
					+ src + newPath + "\\ApplicationResources_en_US.properties"
					+ "\r\n";

			bwBat.write(strContent);
			bwBat.newLine();

		}
		bwBat.write("pause " + " 共" + (listf.size()) + "份文件，请核实");
		bwBat.close();

		// 自动执行生成出的bat文件
		Runtime r = Runtime.getRuntime();
		r.exec("cmd.exe /c " + "start " + fileNameBat);
	}
}
