/**
 * 
 */
package com.landray.kmss.tib.common.log.interfaces;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.transaction.TransactionStatus;

import com.landray.kmss.tib.common.log.constant.TibCommonLogConstant;
import com.landray.kmss.tib.common.log.model.TibCommonLogMain;
import com.landray.kmss.tib.common.log.service.ITibCommonLogMainService;
import com.landray.kmss.tib.common.log.service.ITibCommonLogManageService;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.TransactionUtils;

/**
 * @author 邱建华
 * @version 1.0
 * @2012-8-21
 */
public class TibCommonLogInterfaceImpl implements ITibCommonLogInterface {

	private static final Log logger = LogFactory
			.getLog(TibCommonLogInterfaceImpl.class);

	private ITibCommonLogManageService tibCommonLogManageService;
	private ITibCommonLogMainService tibCommonLogMainService;

	public void setTibCommonLogManageService(
			ITibCommonLogManageService tibCommonLogManageService) {
		this.tibCommonLogManageService = tibCommonLogManageService;
	}


	public void setTibCommonLogMainService(
			ITibCommonLogMainService tibCommonLogMainService) {
		this.tibCommonLogMainService = tibCommonLogMainService;
	}

	public void saveTibCommonLogMain(String fdLogType, Integer fdType, String fdUrl,
			String fdPoolName, Date fdStartTime, Date fdEndTime,
			String fdImportPar, String fdExportPar, String fdMessages,
			String fdIsErr) {
		TibCommonLogMain tibCommonLogMain = new TibCommonLogMain(fdLogType, fdType, fdUrl,
				fdPoolName, fdStartTime, fdEndTime, fdImportPar, fdExportPar,
				fdMessages, fdIsErr);
		if (fdStartTime == null) {
			tibCommonLogMain.setFdStartTime(new Date());
		} else {
			tibCommonLogMain.setFdStartTime(fdStartTime);
		}
		if (fdEndTime == null) {
			tibCommonLogMain.setFdEndTime(new Date());
		} else {
			tibCommonLogMain.setFdEndTime(fdEndTime);
		}
		if (StringUtil.isNotNull(fdUrl)) {
			tibCommonLogMain.setFdUrl(fdUrl);
		} else {
			tibCommonLogMain.setFdUrl("");
		}
		// 新事务防止报错回滚，无法新建
		TransactionStatus status = null;
		// 日志级别,赋初值
		// Integer fdType = fd;
		try {
			if (StringUtil.isNotNull(fdImportPar)
					|| StringUtil.isNotNull(fdExportPar)) {
				// 获取日志类型
				List<?> result = tibCommonLogManageService.findValue("fdLogType", null,
						null);
				if (result == null || result.isEmpty()) {
					logger.warn("没有配置TIB_COMMON日志,将不保存当前日志~");
					return;
				}
				fdType = (Integer) result.get(0);
			}
			// 开启新事务,不影响其他事务的保存操作
			if (null == status) {
				status = TransactionUtils.beginNewTransaction();
			}
			// 如果type为空则使用默认值
			if (fdType == null) {
				fdType = TibCommonLogConstant.TIB_COMMON_LOG_LEVEL_DEFAULT;
			}
			// 如果配置的不是高级的日志，则屏蔽传入参数传出参数的保存
			if (!TibCommonLogConstant.TIB_COMMON_LOG_LEVEL_TOP.equals(fdType)) {
				tibCommonLogMain.setFdExportPar("");
				tibCommonLogMain.setFdImportPar("");
			}
			// 添加日志
			tibCommonLogMainService.add(tibCommonLogMain);
			// 显示提交事务
			TransactionUtils.getTransactionManager().commit(status);
		} catch (Exception e) {
			e.printStackTrace();
			// 回滚事务
			if (status != null) {
				TransactionUtils.getTransactionManager().rollback(status);
				status = null;
			}
		} finally {
			if (status != null) {
				status = null;
			}
		}

	}

	public void saveLogMain(String fdPoolName, String fdLogType, Date fdStartTime,
			String fdImportPar, String fdExportPar, String fdMessages, String fdIsErr)
			throws Exception {
		// 日志级别
		int fdType = TibCommonLogConstant.TIB_COMMON_LOG_LEVEL_DEFAULT;
		// 新事务防止报错回滚，无法新建
		TransactionStatus status = null;
		try {
			if (StringUtil.isNotNull(fdExportPar)) {
				// 获取日志类型
				List<?> result = tibCommonLogManageService.findValue("fdLogType", null,
						null);
				if (result == null || result.isEmpty()) {
					logger.warn("没有配置TIB_COMMON日志,将不保存当前日志~");
					return;
				}
				fdType = (Integer) result.get(0);
			}
			// 开启新事务,不影响其他事务的保存操作
			if (null == status) {
				status = TransactionUtils.beginNewTransaction();
			}
			TibCommonLogMain tibCommonLogMain = new TibCommonLogMain(fdLogType, fdType,
					fdPoolName, fdStartTime, fdImportPar, fdExportPar,
					fdMessages, fdIsErr);
			// 添加日志
			tibCommonLogMainService.add(tibCommonLogMain);
			// 显示提交事务
			TransactionUtils.getTransactionManager().commit(status);
		} catch (Exception e) {
			e.printStackTrace();
			// 回滚事务
			if (status != null) {
				TransactionUtils.getTransactionManager().rollback(status);
				status = null;
			}
		} finally {
			if (status != null) {
				status = null;
			}
		}
	}

}
