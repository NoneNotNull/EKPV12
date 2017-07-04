package com.landray.kmss.tib.sap.sync.util;

import java.util.ArrayList;
import java.util.List;

public class TibSapSyncLogDetail {
	
	private String target;
	private long useMs;
	private long rowsNum=0;
	private long updateNum=0;
	private long insertNum=0;
	private long success=0;
	private List<String> errorMsg=new ArrayList<String>();
	private List<String> rockList=new ArrayList<String>();
	public String getTarget() {
		return target;
	}
	public void setTarget(String target) {
		this.target = target;
	}
	public long getUseMs() {
		return useMs;
	}
	public void setUseMs(long useMs) {
		this.useMs = useMs;
	}
	public long getRowsNum() {
		return rowsNum;
	}
	public void setRowsNum(long rowsNum) {
		this.rowsNum = rowsNum;
	}
	public List<String> getErrorMsg() {
		return errorMsg;
	}
	public void setErrorMsg(List<String> errorMsg) {
		this.errorMsg = errorMsg;
	}
	public long getSuccess() {
		return success;
	}
	public void setSuccess(long success) {
		this.success = success;
	}
	public String toString() {
		StringBuffer sb=new StringBuffer();
		sb.append("执行"+target);
		sb.append("-花费时间"+useMs+"ms\n");
//		sb.append("执行更新"+updateNum+"条\n");
//		sb.append("执行插入"+insertNum+"条\n");
		sb.append("执行总条数"+rowsNum+"条\n");
		sb.append("成功条数"+(rowsNum-rockList.size())+"条\n");
		sb.append("错误信息");
		if(errorMsg.size()>0){
			sb.append(":[");
		}
		for(String msg:errorMsg){
			sb.append(msg+"\n");
		}
		if(errorMsg.size()>0){
			sb.append("]");
		}
		
		sb.append("]\n");
		sb.append("回滚数据列表-"+rockList.size()+"条");
		if(rockList.size()>0){
			sb.append("：[");
		}
		
		int index =0;
		for(String note:rockList){
			sb.append(note);
			if(index%10==0){
				sb.append("\n");
			}
			else{
				sb.append(",");
			}
		}
		if(rockList.size()>0){
			sb.append("]");
		}
		return sb.toString();
	}
	public long getUpdateNum() {
		return updateNum;
	}
	public void setUpdateNum(long updateNum) {
		this.updateNum = updateNum;
	}
	public long getInsertNum() {
		return insertNum;
	}
	public void setInsertNum(long insertNum) {
		this.insertNum = insertNum;
	}
	public List<String> getRockList() {
		return rockList;
	}
	public void setRockList(List<String> rockList) {
		this.rockList = rockList;
	}
	
	
	

}
