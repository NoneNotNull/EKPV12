package com.landray.kmss.tib.sys.core.test;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.List;

/**
 * 文件内容替换
 * @author zhangtian
 *
 */
public class ReplaceInfo {
	
	public static void main(String[] args) throws Exception {
		ReplaceInfo rpf=new ReplaceInfo();
//		String src="E:\\RTCWORKSPACE\\EWEBV4\\src\\com\\landray\\kmss\\tib2\\common\\log";
//		String tar="E:\\RTCWORKSPACE\\EWEBV4\\src\\com\\landray\\kmss\\tib2\\common\\log2";
//		List<RpInfo> rpInfos=new ArrayList<RpInfo>();
//		RpInfo rf= new RpInfo("Erp", "TibCommon");
//		RpInfo rf1= new RpInfo("erp", "tibCommon");
//		RpInfo rf2= new RpInfo("ERP", "TIB_COMMON");
//		rpInfos.add(rf);
//		rpInfos.add(rf1);
//		rpInfos.add(rf2);
		
//		String src="E:\\RTCWORKSPACE\\EWEBV4\\src\\com\\landray\\kmss\\tib2\\common\\inoutdata";
//		String tar="E:\\RTCWORKSPACE\\EWEBV4\\src\\com\\landray\\kmss\\tib2\\common\\inoutdata2";
//		List<RpInfo> rpInfos=new ArrayList<RpInfo>();
//		RpInfo rf= new RpInfo("Erp", "TibCommon");
//		RpInfo rf1= new RpInfo("erp", "tibCommon");
//		RpInfo rf2= new RpInfo("ERP", "TIB_COMMON");
//		rpInfos.add(rf);
//		rpInfos.add(rf1);
//		rpInfos.add(rf2);
		
//		String src="E:\\RTCWORKSPACE\\EWEBV4\\src\\com\\landray\\kmss\\tib2\\common\\mapping";
//		String tar="E:\\RTCWORKSPACE\\EWEBV4\\src\\com\\landray\\kmss\\tib2\\common\\mapping2";
//		E:\\RTCWORKSPACE\\EWEBV4\\src\\com\\landray\\kmss\\tib2\\sys\\sap\\connector
		String src="E:\\RTCWORKSPACE\\EWEBV4\\src\\com\\landray\\kmss\\tib2\\sys\\soap\\connector";
		String tar="E:\\RTCWORKSPACE\\EWEBV4\\src\\com\\landray\\kmss\\tib2\\sys\\soap\\connector2";
		
		List<RpInfo> rpInfos=new ArrayList<RpInfo>();
		
//		SoapEkp=TibSoapMapping
//		SoapRFC=TibSoapRFC
//		SoapTibCommonEkp=TibSoapMapping
//		SoapTibCommon=TibSoap
//
//		soapEkp=tibSoapMapping
//		soapEkp=tibSoapMapping
//		soapRFC=tibSoapRFC
//		soapTibCommonEkp=tibSoapMapping
//		soapTibCommon=tibSoap
		
		rpInfos.add(new RpInfo("SoapEkp", "TibSysSap"));
		rpInfos.add(new RpInfo("SoapRFC", "TibSysSap"));
		rpInfos.add(new RpInfo("SoapTibCommonEkp", "TibSysSap"));
		rpInfos.add(new RpInfo("SoapTibCommon", "TibSysSap"));
		rpInfos.add(new RpInfo("soapEkp", "tibSoapMapping"));
		rpInfos.add(new RpInfo("soapRFC", "tibSoapRFC"));
		rpInfos.add(new RpInfo("soapTibCommonEkp", "tibSoapMapping"));
		rpInfos.add(new RpInfo("soapTibCommon", "tibSoap"));
		rpInfos.add(new RpInfo("ErpSoap", "TibSysSoap"));
		rpInfos.add(new RpInfo("erpSoap", "tibSysSoap"));
		
		
//		SapEkp=TibSapMapping
//		SapRFC=TibSapRFC
//		SapTibCommonEkp=TibSapMapping
//		SapTibCommon=TibSap
//		SapWf=TibSapWf
//
//		sapEkp=tibSapMapping
//		sapRFC=tibSapRFC
//		sapTibCommonEkp=tibSapMapping
//		sapTibCommon=tibSap
//		sapWf=tibSapWf
//		List<RpInfo> rpInfos=new ArrayList<RpInfo>();
//		rpInfos.add(new RpInfo("Sap", "TibSysSap"));
//		rpInfos.add(new RpInfo("sap", "tibSysSap"));
//		rpInfos.add(new RpInfo("SapTibCommonEkp", "TibSapMapping"));
//		rpInfos.add(new RpInfo("SapTibCommon", "TibSap"));
//		rpInfos.add(new RpInfo("SapWf", "tibSapWf"));
//		rpInfos.add(new RpInfo("sapEkp", "tibSapMapping"));
//		rpInfos.add(new RpInfo("sapRFC", "tibSapRFC"));
//		rpInfos.add(new RpInfo("sapTibCommonEkp", "tibSapMapping"));
//		rpInfos.add(new RpInfo("sapTibCommon", "tibSap"));
//		rpInfos.add(new RpInfo("sapWf", "tibSapWf"));
//		rpInfos.add(new RpInfo("SoapEkp", "TibSoapMapping"));
//		rpInfos.add(new RpInfo("SoapRFC", "TibSoapRFC"));
//		rpInfos.add(new RpInfo("SoapTibCommonEkp", "TibSoapMapping"));
//		rpInfos.add(new RpInfo("SoapTibCommon", "TibSoap"));
//		rpInfos.add(new RpInfo("SoapWf", "tibSoapWf"));
//		rpInfos.add(new RpInfo("soapEkp", "tibSoapMapping"));
//		rpInfos.add(new RpInfo("soapRFC", "tibSoapRFC"));
//		rpInfos.add(new RpInfo("soapTibCommonEkp", "tibSoapMapping"));
//		rpInfos.add(new RpInfo("soapTibCommon", "tibSoap"));
//		rpInfos.add(new RpInfo("soapWf", "tibSoapWf"));
//		
//		
//		
//		RpInfo rf_s1= new RpInfo("ErpEkpTempFuncExtend", "TibCommonMappingFuncExt");
//		RpInfo rf_s2= new RpInfo("ErpEkpTempFuncMain", "TibCommonMappingMain");
//		RpInfo rf_s3= new RpInfo("ErpEkpModuleSetting", "TibCommonMappingModule");
//		RpInfo rf_s4= new RpInfo("ErpEkpTempFunc", "TibCommonMappingFunc");
//		
//		RpInfo rf_s5= new RpInfo("erpEkpTempFuncExtend", "tibCommonMappingFuncExt");
//		RpInfo rf_s6= new RpInfo("erpEkpTempFuncMain", "tibCommonMappingMain");
//		RpInfo rf_s7= new RpInfo("erpEkpModuleSetting", "tibCommonMappingModule");
//		RpInfo rf_s8= new RpInfo("erpEkpTempFunc", "tibCommonMappingFunc");
////		
//		#tib-sap-quartz
//		SapQuartz=TibSapSync
//
//		#content
//		SapQuartz=TibSapSync
//		sapQuartz=tibSapSync
//		RpInfo rf_s9= new RpInfo("SapQuartz", "TibSapSync");
//		RpInfo rf_s0= new RpInfo("sapQuartz", "tibSapSync");
//		
		
//		RpInfo rf_s9= new RpInfo("erp_ekp_temp_func_extend", "tib_common_mapping_func_ext");
//		RpInfo rf_s0= new RpInfo("erp_ekp_temp_func_main", "tib_common_mapping_main");
//		RpInfo rf_s01= new RpInfo("erp_ekp_module_setting", "tib_common_mapping_module");
//		RpInfo rf_s02= new RpInfo("erp_ekp_temp_func", "tib_common_mapping_func");
//		
//		RpInfo rf_s03= new RpInfo("TibCommonMappingTempFuncExtend", "TibCommonMappingFuncExt");
//		RpInfo rf_s04= new RpInfo("TibCommonMappingTempFuncMain", "TibCommonMappingMain");
//		RpInfo rf_s05= new RpInfo("TibCommonMappingModuleSetting", "TibCommonMappingModule");
//		RpInfo rf_s06= new RpInfo("TibCommonMappingTempFunc", "TibCommonMappingFunc");
//		
//		
//		RpInfo rf= new RpInfo("ErpEkp", "TibCommonMapping");
//		RpInfo rf1= new RpInfo("erpEkp", "tibCommonMapping");
//		RpInfo rf2= new RpInfo("ERP_EKP", "TIB_COMMON_MAPPING");
//		rpInfos.add(rf_s1);
//		rpInfos.add(rf_s2);
//		rpInfos.add(rf_s3);
//		rpInfos.add(rf_s4);
//		rpInfos.add(rf_s5);
//		rpInfos.add(rf_s6);
//		rpInfos.add(rf_s7);
//		rpInfos.add(rf_s8);
//		rpInfos.add(rf_s9);
//		rpInfos.add(rf_s0);
//		rpInfos.add(rf_s01);
//		rpInfos.add(rf_s02);
//		rpInfos.add(rf_s03);
//		rpInfos.add(rf_s04);
//		rpInfos.add(rf_s05);
//		rpInfos.add(rf_s06);
//		rpInfos.add(rf);
//		rpInfos.add(rf1);
//		rpInfos.add(rf2);
		rpf.replaceFile(src, tar, rpInfos);
	}
	
	public void replaceFile(String src,String tar,List<RpInfo> rpInfos  ) throws Exception{
		
		File toFile=new File(tar);
		File fromeFile=new File(src);
		if(fromeFile.isDirectory()){
			toFile.mkdir();
			String[] s= fromeFile.list();
			for(String s_path:s){
				String new_path=fromeFile.getAbsoluteFile()+"/"+s_path;
				String f_path=toFile.getAbsoluteFile()+"/"+s_path;
				replaceFile(new_path, f_path, rpInfos);
			}
		}
		else{
		StringBuffer sb = new StringBuffer();
		BufferedReader input = new BufferedReader(new InputStreamReader(
				new FileInputStream(fromeFile), "UTF-8"));
		for (String s = input.readLine(); s != null; s = input.readLine())
			sb.append(s + "\r\n");
		input.close();

		toFile.createNewFile();
		BufferedWriter output = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(toFile), "UTF-8"));
		output.write(replaceStrings(sb.toString(),rpInfos));
		output.close();
		System.out.println("替换文件"+src+"-->"+tar);
		}
	}
	public String replaceStrings(String text,List<RpInfo> RpInfos){
		String rtnVal = text;
		for(RpInfo rf:RpInfos){
			rtnVal=replace(rtnVal,rf.getRp_src(),rf.getRp_tar());
		}
		return rtnVal;
	}
	
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
	
	

}
