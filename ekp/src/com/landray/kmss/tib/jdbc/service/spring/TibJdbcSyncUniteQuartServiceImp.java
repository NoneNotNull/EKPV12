package com.landray.kmss.tib.jdbc.service.spring;

import java.util.Date;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.sys.quartz.interfaces.SysQuartzJobContext;
import com.landray.kmss.tib.common.log.constant.TibCommonLogConstant;
import com.landray.kmss.tib.common.log.interfaces.ITibCommonLogInterface;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.jdbc.iface.ITibJdbcTaskSync;
import com.landray.kmss.tib.jdbc.model.TibJdbcRelation;
import com.landray.kmss.tib.jdbc.model.TibJdbcTaskManage;
import com.landray.kmss.tib.jdbc.service.ITibJdbcSyncUniteQuartzService;
import com.landray.kmss.tib.jdbc.service.ITibJdbcTaskManageService;
import com.landray.kmss.tib.jdbc.util.JdbcRunSyncType;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.SpringBeanUtil;

public class TibJdbcSyncUniteQuartServiceImp implements ITibJdbcSyncUniteQuartzService {
	private Log logger = LogFactory.getLog(TibJdbcSyncUniteQuartServiceImp.class);
	private ITibJdbcTaskManageService tibJdbcTaskManageService;
	
	public void methodJob(SysQuartzJobContext sysQuartzJobContext)
			throws Exception {
		logger.debug("开始执行tibJdbc定时任务");
		KmssMessages messages = new KmssMessages();
		JSONObject jsonObj = JSONObject.fromObject(sysQuartzJobContext
				.getParameter());
		String fdId = (String) jsonObj.get("tibjdbcQuartzId");
		String errorInfor="";
		ITibCommonLogInterface tibCommonLogInterface=null;
		try {
			if(StringUtils.isNotEmpty(fdId)){
				ITibJdbcTaskManageService tibJdbcTaskManageService=(ITibJdbcTaskManageService) SpringBeanUtil.getBean("tibJdbcTaskManageService");
				TibJdbcTaskManage taskManage= (TibJdbcTaskManage) tibJdbcTaskManageService
						.findByPrimaryKey(fdId); 
				List<TibJdbcRelation> list = taskManage.getTibJdbcRelationList();
				// 任务同步
				if(list!=null && list.size()>0){
					Date startDate = new Date();
					System.out.println("startDate="+startDate);
					long start = System.currentTimeMillis();
					tibCommonLogInterface = (ITibCommonLogInterface) SpringBeanUtil
							.getBean("tibCommonLogInterface");
					
					String fdMessages = "";
					String fdExportPar = "";
					boolean flag=true;
					System.out.println("======任务管理同步计时开始======");
					for(TibJdbcRelation tibJdbcRelation :list){
						String syncTypeJson = tibJdbcRelation.getFdSyncType();
						JSONObject json = JSONObject.fromObject(syncTypeJson);
						String syncType = json.getString("syncType");
						// 获取任务分发容器
						Map<String, String> syncTypeMap = JdbcRunSyncType.syncTypeMap;
						ITibJdbcTaskSync taskRun = (ITibJdbcTaskSync) SpringBeanUtil
								.getBean(syncTypeMap.get(syncType));
						// 执行任务并返回日志结果
						Map<String, String> logMap = taskRun.run(tibJdbcRelation, json);
						// 记录日志信息
						fdExportPar += logMap.get("errorDetail") +"<p></p>";
						fdMessages += logMap.get("message") +"<p></p>";
						
						if(StringUtils.isNotEmpty(logMap.get("errorDetail"))){
							flag=false;
						}
					}
					// 判断正常日志还是错误日志
					String fdIsErr = TibCommonLogConstant.TIB_COMMON_LOG_TYPE_SUCCESS;
					//本次迁移结果标志
					if (!flag) {
						fdIsErr = TibCommonLogConstant.TIB_COMMON_LOG_TYPE_ERROR;
					}
					// 写入日志
					tibCommonLogInterface.saveLogMain(taskManage.getFdSubject(), Constant.FD_TYPE_JDBC, 
							startDate, "", fdExportPar, fdMessages, fdIsErr);
					long end = System.currentTimeMillis();
					System.out.println("同步耗时："+ (end - start));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

}
