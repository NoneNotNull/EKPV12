package com.landray.kmss.kms.multidoc.util;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Enumeration;
import java.util.List;

import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipFile;
import org.apache.tools.zip.ZipOutputStream;

import com.landray.kmss.sys.attachment.model.SysAttMain;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 解压压缩多附件
 * 
 * @author Administrator
 * 
 */
public class ZipUtil {
	static final int BUFFER = 2048;
	static final String resourcePath = ResourceUtil.getKmssConfigString(
			"kmss.resource.path").trim();

	public static String createZip(List<SysAttMain> filePathList) {
		String zipPathName = null;
		if (filePathList.size() == 0)
			return null;
		try {
			Long ctm = System.currentTimeMillis();
			String zipName = String.valueOf(ctm) + ".zip";
			zipPathName = resourcePath + "/" + zipName;
			BufferedInputStream origin = null;
			FileOutputStream dest = new FileOutputStream(zipPathName);
			ZipOutputStream out = new ZipOutputStream(new BufferedOutputStream(
					dest));
			byte data[] = new byte[BUFFER];
			// File f = new File("e:\\test\\a\\");
			// File files[] = f.listFiles();

			for (SysAttMain fp : filePathList) {
				String filepath = fp.getFdFilePath();
				FileInputStream fi = new FileInputStream(filepath);
				origin = new BufferedInputStream(fi, BUFFER);

				ZipEntry entry = new ZipEntry(fp.getFdFileName());
				out.putNextEntry(entry);
				int count;
				while ((count = origin.read(data, 0, BUFFER)) != -1) {
					out.write(data, 0, count);
				}
				origin.close();
			}
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return zipPathName;
	}

	public static void Unzip(String argv[]) {
		try {
			String fileName = "E:\\test\\myfiles.zip";
			String filePath = "E:\\test\\";
			ZipFile zipFile = new ZipFile(fileName);
			Enumeration emu = zipFile.getEntries();
			int i = 0;
			while (emu.hasMoreElements()) {
				ZipEntry entry = (ZipEntry) emu.nextElement();
				// 会把目录作为一个file读出一次，所以只建立目录就可以，之下的文件还会被迭代到。
				if (entry.isDirectory()) {
					new File(filePath + entry.getName()).mkdirs();
					continue;
				}
				BufferedInputStream bis = new BufferedInputStream(zipFile
						.getInputStream(entry));
				File file = new File(filePath + entry.getName());
				// 加入这个的原因是zipfile读取文件是随机读取的，这就造成可能先读取一个文件
				// 而这个文件所在的目录还没有出现过，所以要建出目录来。
				File parent = file.getParentFile();
				if (parent != null && (!parent.exists())) {
					parent.mkdirs();
				}
				FileOutputStream fos = new FileOutputStream(file);
				BufferedOutputStream bos = new BufferedOutputStream(fos, BUFFER);

				int count;
				byte data[] = new byte[BUFFER];
				while ((count = bis.read(data, 0, BUFFER)) != -1) {
					bos.write(data, 0, count);
				}
				bos.flush();
				bos.close();
				bis.close();
			}
			zipFile.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
/**
 * 流方式下载
 * */
	public static void createZipByStream(List<InputStream> streamList,List<String> fileNameList,
			OutputStream outt) {
		if (streamList.size() == 0 || fileNameList.size() == 0){
			return;
		}
		if (streamList.size() !=fileNameList.size() ){
			return;
		}
		try {
			BufferedInputStream origin = null;
			ZipOutputStream out = new ZipOutputStream(new BufferedOutputStream(
					outt));
			byte data[] = new byte[BUFFER];
			out.setEncoding("GBK");
			for (int i=0;i<streamList.size();i++) {
				 
				InputStream inputStream = streamList.get(i) ;
				origin = new BufferedInputStream(inputStream, BUFFER);
				ZipEntry entry = new ZipEntry(fileNameList.get(i));
				out.putNextEntry(entry);
				int count;
				while ((count = origin.read(data, 0, BUFFER)) != -1) {
					out.write(data, 0, count);
				}
				origin.close();
			}
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public static Double getFileSize(String filePath) {
		double rev = 0.0d;
		if (!StringUtil.isNotNull(filePath))
			return rev;
		File f = null;
		try {
			f = new File(filePath);
			if (f.exists()) {
				FileInputStream fis = null;
				fis = new FileInputStream(f);
				rev = (double) fis.available(); // 单位：B

				fis.close();
			}
		} catch (Exception e) {
		}
		return rev;
	}
}
