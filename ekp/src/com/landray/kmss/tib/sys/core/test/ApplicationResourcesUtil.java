package com.landray.kmss.tib.sys.core.test;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import net.sf.json.JSONObject;

import com.landray.kmss.util.StringUtil;

/**
 * 
 * @author zhangtian 国际化工具，用来快速把文件内容国际化
 */
public class ApplicationResourcesUtil {

	
	public static void main(String[] args) throws Exception {
		
		String path="E:\\RTCWORKSPACE\\EKPNEW\\ETIB\\src\\com\\landray\\kmss\\tib\\common\\mapping\\ApplicationResources.properties";
		String bundle="tib-common-mapping";
		ApplicationVo av=new ApplicationVo(bundle,path,"TibCommonMapping.Lang");
//		生成js 国际化json字符串
		JSONObject json=applicationToJs(av, new String[]{"ROLE"});
		System.out.println(json);
	}
	
	
	
	/**
	 * 
	 * @throws Exception
	 */
	public static void applicationsToJs(List<ApplicationVo> applicationVos)
			throws Exception {
		for(ApplicationVo av:applicationVos){
			JSONObject json=applicationToJs(av, new String[]{"ROLE"});
			
			System.out.println(av.getBundle()+"输出资源文件转化json**********************");
			System.out.println(json.toString());
			System.out.println("*****************************************");
		}
	}

	public static JSONObject applicationToJs(ApplicationVo applicationVo,
			String[] filter) throws Exception {
		JSONObject source = new JSONObject();
		File fromeFile = new File(applicationVo.getPath());
		StringBuffer sb = new StringBuffer();
		BufferedReader input = new BufferedReader(new InputStreamReader(
				new FileInputStream(fromeFile), "UTF-8"));
		String bd = applicationVo.getBundle();
		
		List<String> lines=new ArrayList<String>(1);
		
		
		for (String s = input.readLine(); s != null; s = input.readLine()) {
			if (StringUtil.isNotNull(s)) 
			{
				lines.add(s);
			}
		}
		input.close();
		
		
		Collections.sort(lines, new Comparator<String>() {
			public int compare(String paramT1, String paramT2) {
				// TODO 自动生成的方法存根
				String[] s_a1 = paramT1.split("=");
				String[] s_a2 = paramT2.split("=");
				if (s_a1.length > 1&&s_a2.length>1){
					String s1 = fromUnicode(s_a1[1]);
					String s2 = fromUnicode(s_a2[1]);
					return s2.trim().length()-s1.trim().length();
				} 
				return 0;
			}
			
		}) ;
		//子字符串放在后面
		for(String s:lines){
			String[] s_arry = s.split("=");
			if (s_arry.length > 1) {

				String s1 = s_arry[1];
				String s2 = fromUnicode(s1);
				System.out.println(s2);

				boolean bf = filters(s_arry[0], filter);
				if (bf) {
					String r_s = "<bean:message bundle='!{bd}' key='!{key}'/>"
							.replace("!{bd}", bd).replace("!{key}", s_arry[0]);
					source = exchangeJson(s_arry[0], r_s, source);
				}
			}
		}
		return source;
	}

	/**
	 * 添加json
	 * 
	 * @param key
	 * @param source
	 * @return date.format.date转化为,且跟原有的合并 {date: { format: { date:xx } }
	 * 
	 *         }
	 * 
	 * 
	 * 
	 */
	public static JSONObject exchangeJson(String key, String value,
			JSONObject source) {

		JSONObject curJson = source;
		if (StringUtil.isNotNull(key)) {
			String[] keyArray = key.split("\\.");
			for (int i = 0, len = keyArray.length; i < len; i++) {
				String s = keyArray[i];
				if (i == (len - 1)) {
					curJson.accumulate(s, value);
				} else {
					if (source.containsKey(s)) {
						curJson = (JSONObject) source.get(s);
					} else {
						curJson.element(s, new JSONObject());
						curJson = (JSONObject) curJson.get(s);
					}

				}
			}
		} else {
			return source;
		}
		return source;
	}


	/**
	 * 过滤关键字
	 * 
	 * @param key
	 * @param filter
	 * @return
	 */
	public static boolean filters(String key, String[] filter) {

		for (String s : filter) {
			if (key.indexOf(s) > -1) {
				return false;
			}
		}
		return true;
	}

//	public static void getResourceInfo() throws Exception {
//		File fromeFile = new File(
//				"E:\\RTCWORKSPACE\\EKPCLEAN\\ESAP\\src\\com\\landray\\kmss\\tib\\common\\ApplicationResources.properties");
//		StringBuffer sb = new StringBuffer();
//		BufferedReader input = new BufferedReader(new InputStreamReader(
//				new FileInputStream(fromeFile), "UTF-8"));
//		String bd = "tib-sys-soap-connector";
//		for (String s = input.readLine(); s != null; s = input.readLine()) {
//			sb.append(s + "/r/n");
//			// System.out.println(s);
//			if (StringUtil.isNotNull(s)) {
//				String[] s_arry = s.split("=");
//				if (s_arry.length > 1) {
//
//					String s1 = s_arry[1];
//					String s2 = fromUnicode(s1);
//					System.out.println(s2);
//					//		    	
//					if (s_arry[0].indexOf("ROLE_TIB") > 0) {
//
//					} else {
//						String r_s = "!{jsName}:ff<bean:message bundle=\"!{bd}\" key=\"!{key}\"/>";
//
//						System.out.println(r_s.replace("!{bd}", bd).replace(
//								"!{key}", s_arry[0].trim()).replace("jsName",
//								""));
//					}
//				}
//			}
//		}
//		input.close();
//	}

	public static String fromUnicode(String str) {
		return fromUnicode(str.toCharArray(), 0, str.length(), new char[1024]);
	}

	/*
	 * 
	 * Converts encoded &#92;uxxxx to unicode chars
	 * 
	 * and changes special saved chars to their original forms
	 */

	public static String fromUnicode(char[] in, int off, int len,
			char[] convtBuf) {
		if (convtBuf.length < len) {
			int newLen = len * 2;
			if (newLen < 0) {
				newLen = Integer.MAX_VALUE;
			}
			convtBuf = new char[newLen];
		}
		char aChar;
		char[] out = convtBuf;
		int outLen = 0;
		int end = off + len;
		while (off < end) {
			aChar = in[off++];
			if (aChar == '\\') {
				aChar = in[off++];
				if (aChar == 'u') {
					// Read the xxxx
					int value = 0;
					for (int i = 0; i < 4; i++) {
						aChar = in[off++];
						switch (aChar) {
						case '0':
						case '1':
						case '2':
						case '3':
						case '4':
						case '5':
						case '6':
						case '7':
						case '8':
						case '9':
							value = (value << 4) + aChar - '0';
							break;
						case 'a':
						case 'b':
						case 'c':
						case 'd':
						case 'e':
						case 'f':
							value = (value << 4) + 10 + aChar - 'a';
							break;
						case 'A':
						case 'B':
						case 'C':
						case 'D':
						case 'E':
						case 'F':
							value = (value << 4) + 10 + aChar - 'A';
							break;
						default:
							throw new IllegalArgumentException(
									"Malformed \\uxxxx encoding.");
						}
					}
					out[outLen++] = (char) value;
				} else {
					if (aChar == 't') {
						aChar = '\t';
					} else if (aChar == 'r') {
						aChar = '\r';
					} else if (aChar == 'n') {
						aChar = '\n';
					} else if (aChar == 'f') {
						aChar = '\f';
					}
					out[outLen++] = aChar;
				}
			} else {
				out[outLen++] = (char) aChar;
			}
		}
		return new String(out, 0, outLen);
	}

}
