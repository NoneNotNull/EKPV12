/**
 * 
 */
package com.landray.kmss.tib.common.inoutdata.util;

import java.io.File;

/**
 * @author 邱建华
 * @version 1.0 2013-1-7
 */
public class TibCommonInoutdataFileUtil {

	/**
	 * 删除目录，包括其下的所有子目录和文件
	 * 
	 * @param dir 			被删除的目录名
	 * @return boolean 		是否删除成功
	 * @throws Exception 	删除目录过程中的任何异常
	 */
	public static boolean deleteDir(File dir) throws Exception {
		if (dir.isFile()) {
			deleteFile(dir);
		}
		File[] files = dir.listFiles();
		if (files != null) {
			for (File file : files) {
				if (file.isFile()) {
					file.delete();
				} else {
					deleteDir(file);
				}
			}
		}
		return dir.delete();
	}
	
	/**
	 * 删除文件
	 * 
	 * @param file 			被删除文件
	 * @return boolean 		是否删除成功
	 * @throws Exception 	删除文件过程中的任何异常
	 */
	private static boolean deleteFile(File file) throws Exception {
		if (file.isDirectory()) {
			return deleteDir(file);
		}
		if (!file.exists()) {
			return false;
		}
		return file.delete();
	}
}
