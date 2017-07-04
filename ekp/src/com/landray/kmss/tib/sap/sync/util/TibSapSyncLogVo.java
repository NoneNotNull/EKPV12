package com.landray.kmss.tib.sap.sync.util;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;


/**
 * 定时任务日志中间对象
 * @author zhangtian
 *
 */
public class TibSapSyncLogVo {
	
	private String functionId;
	private Date startDate;
	private List<String> errList=new ArrayList<String>();
	private String tibSapSyncName;
	private List<TibSapSyncLogDetail> details=new ArrayList<TibSapSyncLogDetail>();
	private boolean fdErr=false;

	public String getFunctionId() {
		return functionId;
	}

	public void setFunctionId(String functionId) {
		this.functionId = functionId;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public List<String> getErrList() {
		return errList;
	}

	public void setErrList(List<String> errList) {
		this.errList = errList;
	}

	public String getTibSapSyncName() {
		return tibSapSyncName;
	}

	public void setTibSapSyncName(String tibSapSyncName) {
		this.tibSapSyncName = tibSapSyncName;
	}

	public List<TibSapSyncLogDetail> getDetails() {
		return details;
	}

	public void setDetails(List<TibSapSyncLogDetail> details) {
		this.details = details;
	}
	
	public boolean isFdErr() {
		return fdErr;
	}

	public void setFdErr(boolean fdErr) {
		this.fdErr = fdErr;
	}

	public String toString() {
			StringBuffer sb=new StringBuffer();
			sb.append("执行 bapi functionId :"+functionId+"\n");
			sb.append("启动时间 ："+startDate.toString()+"\n");
			sb.append("所属定时任务:"+tibSapSyncName+"\n");
			sb.append("错误信息：[");
			for(String msg:errList){
				sb.append(msg+"\n");
			}
			sb.append("]\n");
			sb.append("明细信息：{\n");
			for(TibSapSyncLogDetail detail:details){
				sb.append("[\n"+detail.toString()+"\n]");
			}
			sb.append("}");
			return sb.toString();
	}
	
	
	
	
	

}
