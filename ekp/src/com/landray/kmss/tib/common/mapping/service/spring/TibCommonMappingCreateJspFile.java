package com.landray.kmss.tib.common.mapping.service.spring;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.URL;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.InitializingBean;

import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.config.loader.ConfigLocationsUtil;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMainService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;

/**
 * 启动时候创建配置文件
 * 
 * @author zhangtian
 * 
 */
public class TibCommonMappingCreateJspFile implements InitializingBean {

	private static final Log logger = LogFactory
			.getLog(TibCommonMappingCreateJspFile.class);

	ITibCommonMappingMainService tibCommonMappingMainService;

	ITibCommonMappingModuleService tibCommonMappingModuleService;

	public ITibCommonMappingModuleService getTibCommonMappingModuleService() {
		return tibCommonMappingModuleService;
	}

	public void setTibCommonMappingModuleService(
			ITibCommonMappingModuleService tibCommonMappingModuleService) {
		this.tibCommonMappingModuleService = tibCommonMappingModuleService;
	}

	public ITibCommonMappingMainService getTibCommonMappingMainService() {
		return tibCommonMappingMainService;
	}

	public void setTibCommonMappingMainService(
			ITibCommonMappingMainService tibCommonMappingMainService) {
		this.tibCommonMappingMainService = tibCommonMappingMainService;
	}

	public void afterPropertiesSet() throws Exception {
//		logger.info("SAP-EKP 表单集成启动重新生成JSP 片段~");
//		// TODO Auto-generated method stub
//		try {
//			List<TibCommonMappingMain> tibCommonMappingMains = tibCommonMappingMainService
//					.findList("", "");
//			for (TibCommonMappingMain tibCommonMappingMain : tibCommonMappingMains) {
//				generateJspFile(tibCommonMappingMain.getFdFormEventFunctionList());
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//			// TODO: handle exception
//			logger.info("SAP-EKP 表单集成重新生成JSP 片段~" + e.toString());
//		}
//		
//		logger.info("SAP-EKP 生成注册文件...");
//		
//
	}
	

	// 用于产生表单事件的jsp片段文件，现在只处理生成表单事件的jsp文件
	private void generateJspFile(List<TibCommonMappingFunc> fdFormEventFunctionListForms)
			throws Exception {
		for (Iterator iterator = fdFormEventFunctionListForms.iterator(); iterator
				.hasNext();) {
			TibCommonMappingFunc tibCommonMappingFunc = (TibCommonMappingFunc) iterator.next();
			String fdId = tibCommonMappingFunc.getFdId();
			
			String type=tibCommonMappingFunc.getFdIntegrationType();
			Map<String, String> pluginCfg= 
			TibCommonMappingIntegrationPlugins.getConfigByType(type);
			if(pluginCfg==null||pluginCfg.isEmpty()){
				logger.debug("没有加载到扩展信息,key:"+type);
				continue;
			}
			String filePath= ConfigLocationsUtil.getWebContentPath()+"/"+pluginCfg.get(TibCommonMappingIntegrationPlugins.formEventPath);
			File formEventJsp = new File(filePath);
			if (!formEventJsp.exists()) {
				formEventJsp.mkdirs();
				if (logger.isDebugEnabled())
					logger.debug("文件夹不存在，创建：");
			}
			
			String fileName = fdId + ".jsp";
			File file = new File(filePath  + fileName);
			String tmpCode = "<%@ page language=\"java\" contentType=\"text/html; charset=UTF-8\" pageEncoding=\"UTF-8\"%>";
			String funcName=pluginCfg.get(TibCommonMappingIntegrationPlugins.formEventFuncName);
			// 兼容旧的数据,没有填写回调函数的时候
			if (tibCommonMappingFunc.getFdJspSegmen().indexOf(funcName+"()") > 0) {
				writeFile(file, tmpCode
						+ tibCommonMappingFunc.getFdJspSegmen().replace(
								funcName+"()", funcName+"('" + fdId + "')"));
			} else {
				// 有回调函数的时候 doWEB(action) 则转换成doWEB('fdid',action);
				writeFile(file, tmpCode
						+ tibCommonMappingFunc.getFdJspSegmen().replace(funcName+"(",
								funcName+"('" + fdId + "',"));
			}

		}
	}
	

	/**
	 * 构建模块注册
	 */
	public void generateRegModelFile() {
		
		URL url=Thread.currentThread().getContextClassLoader().getResource("");
		String fileName =url.getPath()+"com/landray/kmss/third/erp/ModelReg.properties";
		logger.debug("创建配置文件："+fileName);
		//String fileName=ConfigLocationsUtil.getWebContentPath()+"/ModelReg.properties";
		Properties props = new Properties();
		//if (tibCommonMappingModuleService instanceof TibCommonMappingModuleServiceImp) {
		//	TibCommonMappingModuleServiceImp tibCommonMappingModuleServiceImp = (TibCommonMappingModuleServiceImp) tibCommonMappingModuleService;
		StringBuffer buf=new StringBuffer("");	
		try {
				tibCommonMappingModuleService.initRegisterModelHash();
				ConcurrentHashMap<String, Map<String, Object>> regMap = tibCommonMappingModuleService.getRegisterModelHash();
				if (regMap.isEmpty()) {

				} else {
					boolean first=true;
					for (String modelName : regMap.keySet()) {
						SysDictModel s_model = SysDataDict.getInstance()
								.getModel(modelName);
						if(s_model!=null){
							if(first){
								first=false;
							}else{
								buf.append(",");
							}
							buf.append(s_model.getServiceBean());
						}
					}
				}
			if(buf.length()>0){
			props.setProperty("regModelList", buf.toString());
			}
			else{
//				如果没有需要注册的就把名字写成以 -开头的类需要校验,spring配置文件不可以为空,所以需要这么做
				props.setProperty("regModelList", "-*");
			}
			FileOutputStream fos=new FileOutputStream(fileName);
			props.store(fos, "create config for ERP registerModel");
			fos.close();
			logger.info("创建模块注册文件成功："+fileName);
		} catch (Exception e) {
			logger.info("创建模块注册文件出现异常"+e.getMessage());
			e.printStackTrace();
		}
	}

	/**
	 * 写文件
	 * 
	 * @param file
	 * @param content
	 */
	private void writeFile(File file, String content) {
		FileOutputStream out = null;
		Writer outWriter = null;
		try {
			out = new FileOutputStream(file);
			outWriter = new BufferedWriter(new OutputStreamWriter(out, "UTF-8"));
			IOUtils.write(content, outWriter);
		} catch (FileNotFoundException e) {
			throw new RuntimeException("写文件找不到文件错误", e);
		} catch (IOException e) {
			throw new RuntimeException("写文件错误", e);
		} finally {
			IOUtils.closeQuietly(outWriter);
			IOUtils.closeQuietly(out);
		}
	}

}
