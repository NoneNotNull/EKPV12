package com.landray.kmss.code;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

public class CopyRunner {
	private String path;

	private String[] fromInfo;

	private String[] toInfo;

	private String[] fromStrings = new String[7];

	private String[] toStrings = new String[7];

	private String replace(String srcText, String fromStr, String toStr) {
		if (srcText == null)
			return null;
		StringBuffer rtnVal = new StringBuffer();
		String rightText = srcText;
		for (int i = rightText.indexOf(fromStr); i > -1; i = rightText
				.indexOf(fromStr)) {
			rtnVal.append(rightText.substring(0, i));
			rtnVal.append(toStr);
			rightText = rightText.substring(i + fromStr.length());
		}
		rtnVal.append(rightText);
		return rtnVal.toString();
	}

	private String replaceStrings(String srcText) {
		String rtnVal = srcText;
		for (int i = 0; i < fromStrings.length; i++) {
			rtnVal = replace(rtnVal, fromStrings[i], toStrings[i]);
		}
		return rtnVal;
	}

	public CopyRunner(String project, String fromModule, String toModule) {
		path = replace(new File("").getAbsolutePath(), "\\", "/");
		int i = path.lastIndexOf('/');
		path = path.substring(0, i) + "/" + project;
		fromInfo = fromModule.split("/");
		toInfo = toModule.split("/");
		// km/review
		fromStrings[0] = fromModule;
		toStrings[0] = toModule;
		// kmss.km.review
		fromStrings[1] = "kmss." + fromInfo[0] + "." + fromInfo[1];
		toStrings[1] = "kmss." + toInfo[0] + "." + toInfo[1];
		// km_review_
		fromStrings[2] = fromInfo[0] + "_" + fromInfo[1] + "_";
		toStrings[2] = toInfo[0] + "_" + toInfo[1] + "_";
		// kmReview
		fromStrings[3] = fromInfo[0]
				+ fromInfo[1].substring(0, 1).toUpperCase()
				+ fromInfo[1].substring(1);
		toStrings[3] = toInfo[0] + toInfo[1].substring(0, 1).toUpperCase()
				+ toInfo[1].substring(1);
		// KmReview
		fromStrings[4] = fromInfo[0].substring(0, 1).toUpperCase()
				+ fromInfo[0].substring(1)
				+ fromInfo[1].substring(0, 1).toUpperCase()
				+ fromInfo[1].substring(1);
		toStrings[4] = toInfo[0].substring(0, 1).toUpperCase()
				+ toInfo[0].substring(1)
				+ toInfo[1].substring(0, 1).toUpperCase()
				+ toInfo[1].substring(1);
		// KMREVIEW
		fromStrings[5] = fromInfo[0].toUpperCase() + fromInfo[1].toUpperCase();
		toStrings[5] = toInfo[0].toUpperCase() + toInfo[1].toUpperCase();
		// km-review
		fromStrings[6] = fromInfo[0] + "-" + fromInfo[1];
		toStrings[6] = toInfo[0] + "-" + toInfo[1];
	}

	public void Run() throws Exception {
		CopyPath(path + "/src/com/landray/kmss/" + fromInfo[0] + "/"
				+ fromInfo[1], path + "/src/com/landray/kmss/" + toInfo[0]
				+ "/" + toInfo[1]);
		CopyPath(path + "/WebContent/" + fromInfo[0] + "/" + fromInfo[1], path
				+ "/WebContent/" + toInfo[0] + "/" + toInfo[1]);
		CopyPath(path + "/WebContent/WEB-INF/KmssConfig/" + fromInfo[0] + "/"
				+ fromInfo[1], path + "/WebContent/WEB-INF/KmssConfig/"
				+ toInfo[0] + "/" + toInfo[1]);
		System.out.println("拷贝完成");
	}

	private void CopyPath(String fromPath, String toPath) throws Exception {
		System.out.println("正在拷贝：" + fromPath + " -> " + toPath);
		File fromFile = new File(fromPath);
		File toFile = new File(toPath);
		if (fromFile.isDirectory()) {
			toFile.mkdir();
			String[] files = fromFile.list();
			if (files != null) {
				for (int i = 0; i < files.length; i++) {
					if (files[i].startsWith("."))
						continue;
					CopyPath(fromPath + "/" + files[i], toPath + "/"
							+ replaceStrings(files[i]));
				}
			}
		} else {
			StringBuffer sb = new StringBuffer();
			BufferedReader input = new BufferedReader(new InputStreamReader(
					new FileInputStream(fromFile), "UTF-8"));
			for (String s = input.readLine(); s != null; s = input.readLine())
				sb.append(s + "\r\n");
			input.close();

			toFile.createNewFile();
			BufferedWriter output = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(toFile), "UTF-8"));
			output.write(replaceStrings(sb.toString()));
			output.close();
		}
	}

	public static void main(String[] args) throws Exception {
		new CopyRunner("ekp", "km/resource", "km/meetingres").Run();
	}
}
