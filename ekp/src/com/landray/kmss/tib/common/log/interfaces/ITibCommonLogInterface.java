/**
 * 
 */
package com.landray.kmss.tib.common.log.interfaces;

import java.util.Date;

/**
 * @author 邱建华
 * @version 1.0
 * @2012-8-21
 */
public interface ITibCommonLogInterface {
	
	/**
	 * 错误日志接口
	 * @param fdPoolName	服务名称
	 * @param fdStartTime	开始时间（可选，不填即当前时间）
	 * @param fdEndTime		结束时间（可选，不填即当前时间）
	 * @param fdUrl			相关URL（可选）
	 * @param fdImportPar	传入XML（可选，当日志级别为高级时有效）
	 * @param fdExportPar	传出XML（可选，当日志级别为高级时有效）
	 * @param fdMessages	日志内容（可选）
	 */
//	public void logError(String fdPoolName, Date fdStartTime, Date fdEndTime,
//			String fdUrl, String fdImportPar, String fdExportPar, String fdMessages,String logKey);
	
	/**
	 * 业务失败日志接口
	 * @param fdPoolName	服务名称
	 * @param fdStartTime	开始时间（可选，不填即当前时间）
	 * @param fdEndTime		结束时间（可选，不填即当前时间）
	 * @param fdUrl			相关URL（可选）
	 * @param fdImportPar	传入XML（可选，当日志级别为高级时有效）
	 * @param fdExportPar	传出XML（可选，当日志级别为高级时有效）
	 * @param fdMessages	日志内容（可选）
	 */
//	public void logBusinessError(String fdPoolName, Date fdStartTime, Date fdEndTime,
//			String fdUrl, String fdImportPar, String fdExportPar, String fdMessages,String logKey);
	
	/**
	 * 成功日志接口
	 * @param fdPoolName	服务名称
	 * @param fdStartTime	开始时间（可选，不填即当前时间）
	 * @param fdEndTime		结束时间（可选，不填即当前时间）
	 * @param fdUrl			相关URL（可选）
	 * @param fdImportPar	传入XML（可选，当日志级别为高级时有效）
	 * @param fdExportPar	传出XML（可选，当日志级别为高级时有效）
	 * @param fdMessages	日志内容（可选）
	 */
//	public void logSuccess(String fdPoolName, Date fdStartTime, Date fdEndTime,
//			String fdUrl, String fdImportPar, String fdExportPar, String fdMessages,String logKey);
	
	/**
	 * 保存日志接口
	 * @param fdLogType 日志类型 webservice or sap or other  @see com.landray.kmss.third.tibCommon.common.ekp.constant.Constant
	 * @param fdType 基本 or 高级 如果为空则读取数据库的日志配置来处理
	 * @param fdUrl 相关url
	 * @param fdPoolName 服务名称
	 * @param fdEndTime 结束时间
	 * @param fdImportPar 传入参数
	 * @param fdExportPar 传出参数
	 * @param fdMessages 信息
	 * @param fdIsErr @see com.landray.kmss.tib.common.log.constant.TibCommonLogConstant
	 */
	public void saveTibCommonLogMain(String fdLogType,
			Integer fdType, String fdUrl, String fdPoolName, Date fdStartTime,
			Date fdEndTime, String fdImportPar, String fdExportPar,
			String fdMessages, String fdIsErr);
	
	/**
	 * 保存日志(参数简化)
	 * @param fdPoolName	日志记录的名称
	 * @param fdLogType		日志类型
	 * @param fdStartTime	任务开始时间
	 * @param fdImportPar	传入参数
	 * @param fdExportPar	传出参数
	 * @param fdMessages	相关信息
	 * @param fdIsErr		异常类型
	 * @throws Exception
	 */
	public void saveLogMain(String fdPoolName, String fdLogType, Date fdStartTime, 
			String fdImportPar, String fdExportPar, String fdMessages, String fdIsErr) throws Exception;
	
}
