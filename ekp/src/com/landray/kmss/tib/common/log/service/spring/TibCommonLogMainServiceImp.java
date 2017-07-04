package com.landray.kmss.tib.common.log.service.spring;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.tib.common.log.constant.TibCommonLogConstant;
import com.landray.kmss.tib.common.log.dao.ITibCommonLogMainDao;
import com.landray.kmss.tib.common.log.service.ITibCommonLogMainBackupService;
import com.landray.kmss.tib.common.log.service.ITibCommonLogMainService;
import com.landray.kmss.tib.common.log.service.ITibCommonLogManageService;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.util.StringUtil;

/**
 * TIB_COMMON日志管理业务接口实现
 * 
 * @author 
 * @version 1.0 2012-08-20
 */
public class TibCommonLogMainServiceImp extends BaseServiceImp implements ITibCommonLogMainService {
	
	// 日志管理配置
	private ITibCommonLogManageService tibCommonLogManageService;
	
	public void setTibCommonLogManageService(ITibCommonLogManageService tibCommonLogManageService) {
		this.tibCommonLogManageService = tibCommonLogManageService;
	}
	
	// 日志归档service
	private ITibCommonLogMainBackupService tibCommonLogMainBackupService;
	
	public void setTibCommonLogMainBackupService(
			ITibCommonLogMainBackupService tibCommonLogMainBackupService) {
		this.tibCommonLogMainBackupService = tibCommonLogMainBackupService;
	}

	public void backup() throws Exception {
		// 获取日志保存天数，和日志归档天数
		List<Object[]> day = tibCommonLogManageService
						.findValue("fdLogTime, fdLogLastTime", null, null);
		int saveDay = 31;
		int backupDay = 30;
		if(day.size() > 0) {
			saveDay = (Integer)(day.get(0)[0]);
			backupDay = (Integer)(day.get(0)[1]);
		}
		executeLog(saveDay, false);
		executeLog(backupDay, true); 
	}
	/**
	 * 保存删除超过期限的日志
	 * @param limitDay		期限天数
	 * @param isBackup		是否归档
	 * @throws Exception	
	 */
	public void executeLog(int limitDay, boolean isBackup) throws Exception {
		Calendar backupCalendar = Calendar.getInstance();
		// 算出超出时间日期
		backupCalendar.add(Calendar.DAY_OF_MONTH, -limitDay);
		Date limitDate = backupCalendar.getTime();
		((ITibCommonLogMainDao) getBaseDao()).backup(isBackup,limitDate);
	}

	public JSONArray treeView(String type, String path) throws Exception {
		JSONArray array = new JSONArray();
		// 如果不为空 ，获取这个扩展的信息
		if(StringUtil.isNotNull(type)){
			Map<String, String>  singleInfo=TibCommonMappingIntegrationPlugins.getConfigByType(type);
			if(singleInfo==null){
				return array;
			} else {                           
				// 正常日志
				JSONObject jsonObject = new JSONObject();
				String logType = singleInfo.get(TibCommonMappingIntegrationPlugins.fdIntegrationType);
				String displayName = singleInfo.get(TibCommonMappingIntegrationPlugins.displayName);
				jsonObject.put("value", "normal");
				jsonObject.put("text", "正常日志");
				String n_path=path.replace("!{error}", TibCommonLogConstant.TIB_COMMON_LOG_TYPE_SUCCESS)
					.replace("!{logType}", logType).replace("!{displayName}", displayName)
					.replace("!{subDisplayName}", "正常日志");
				jsonObject.put("href", n_path);
				
				
				// 异常日志
				JSONObject errorJsonObject = new JSONObject();
				errorJsonObject.put("value", "error");
				errorJsonObject.put("text", "异常日志");
				String e_path =path.replace("!{error}", TibCommonLogConstant.TIB_COMMON_LOG_TYPE_ERROR)
					.replace("!{logType}", logType).replace("!{displayName}", displayName)
					.replace("!{subDisplayName}", "异常日志");
				errorJsonObject.put("href", e_path);
				
				// 业务日志
				JSONObject busJsonObject = new JSONObject();
				busJsonObject.put("value", "berror");
				busJsonObject.put("text", "业务异常日志");
				String b_path =path.replace("!{error}", TibCommonLogConstant.TIB_COMMON_LOG_TYPE_BIERROR)
					.replace("!{logType}", logType).replace("!{displayName}", displayName)
					.replace("!{subDisplayName}", "业务异常日志");
				busJsonObject.put("href", b_path);
				array.add(jsonObject);
				array.add(errorJsonObject);
				array.add(busJsonObject);
			}
			
		} else {
			// 如果type不为空则获取集成类型
			List<Map<String, String>>  configs=TibCommonMappingIntegrationPlugins.getConfigs();
			for(Map<String, String> map :configs){
				JSONObject jsonObject = new JSONObject();
				String fdIntegrationType = map.get(TibCommonMappingIntegrationPlugins.fdIntegrationType);
				String displayName = map.get(TibCommonMappingIntegrationPlugins.displayName);
				jsonObject.put("value", fdIntegrationType);
				jsonObject.put("text", displayName);
				jsonObject.put("autoFetch", true);
				array.add(jsonObject);
			}
		}
		return array;
	}
}
