package com.landray.kmss.tib.sys.core.test;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * 批量文件重命名,用来简化目录迁移的工具
 * 
 * @author zhangtian
 */
public class FileReNameUtil {

	public static void main(String[] args) {
		test();
	}

	public static void test() {

		// #tib-sap
		// String
		// path="E:\\RTCWORKSPACE\\EWEBV4\\src\\com\\landray\\kmss\\tib2\\sap";
		// List<RpInfo> rpInfos=new ArrayList<RpInfo>();
		// rpInfos.add(new RpInfo("SapEkp", "TibSapMapping"));
		// rpInfos.add(new RpInfo("SapRFC", "TibSapRFC"));
		// rpInfos.add(new RpInfo("SapTibCommonEkp", "TibSapMapping"));
		// rpInfos.add(new RpInfo("SapTibCommon", "TibSap"));
		// rpInfos.add(new RpInfo("SapWf", "TibSapWf"));

		// tib-soap
		// SoapEkp=TibSoapMapping
		// SoapRFC=TibSoapRFC
		// SoapTibCommonEkp=TibSoapMapping
		// SoapTibCommon=TibSoap
		// SoapWf=TibSoapWf
		// String
		// path="E:\\RTCWORKSPACE\\EWEBV4\\WebContent\\tib\\common\\mapping";
		// List<RpInfo> rpInfos=new ArrayList<RpInfo>();
		// rpInfos.add(new RpInfo("SoapEkp", "TibSoapMapping"));
		// rpInfos.add(new RpInfo("SoapRFC", "TibSoapRFC"));
		// rpInfos.add(new RpInfo("SoapTibCommonEkp", "TibSoapMapping"));
		// rpInfos.add(new RpInfo("SoapTibCommon", "TibSoap"));
		// rpInfos.add(new RpInfo("SoapWf", "TibSoapWf"));

		// rpInfos.add(new RpInfo("erpEkpTempFuncMain",
		// "tibCommonMappingFuncMain"));
		// rpInfos.add(new RpInfo("erpEkpTempFunc", "tibCommonMappingFunc"));
		// rpInfos.add(new RpInfo("erpEkpModuleSetting",
		// "tibCommonMappingModule"));
		String path = "E:\\RTCWORKSPACE\\EWEBV4\\WebContent\\tib\\common\\log";
		List<RpInfo> rpInfos = new ArrayList<RpInfo>();
		// rpInfos.add(new RpInfo("sap_quartz_", "tib_sap_sync_"));
		// rpInfos.add(new RpInfo("sapQuartz", "tibSapSync"));

		// rpInfos.add(new RpInfo("sap_", "tib_sys_sap_"));
		rpInfos.add(new RpInfo("erp_log_", "tib_common_log_"));
		rpInfos.add(new RpInfo("erpLog", "tibCommonLog"));
		renameFile(path, rpInfos);

	}

	public static void renameFile(String path, List<RpInfo> rpinfos) {

		for (RpInfo rf : rpinfos) {
			renameFile(path, rf.getRp_src(), rf.getRp_tar());
		}

	}

	public static void renameFile(String path, String key, String replace) {
		File file = new File(path);
		if (file.isDirectory()) {
			String[] s = file.list();

			String c_name = file.getName();
			if (c_name.indexOf(key) > -1) {
				String path_s = file.getAbsolutePath();
				String n_name = c_name.replace(key, replace);
				file.renameTo(new File(file.getParent() + "/" + n_name));
				System.out.println("重命名Folder:" + path_s + " -->"
						+ file.getParent() + "/" + n_name);
			}
			for (String s_path : s) {
				String new_path = file.getAbsoluteFile() + "/" + s_path;
				renameFile(new_path, key, replace);
			}
		} else {
			String c_name = file.getName();
			if (c_name.indexOf(key) > -1) {
				String path_s = file.getAbsolutePath();
				String n_name = c_name.replace(key, replace);
				file.renameTo(new File(file.getParent() + "/" + n_name));
				System.out.println("重命名File:" + path_s + " -->"
						+ file.getParent() + "/" + n_name);
			}
		}

	}

}
