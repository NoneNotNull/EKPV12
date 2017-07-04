package com.landray.kmss.tib.sys.sap.connector.model;

import java.text.SimpleDateFormat;
import java.util.Date;

public class TibSysSapJcoMonitor {
	protected String poolName;
	protected Integer activeConCount;
	protected Integer maxUsedCount;
	protected Integer usedCount;
	protected Integer waitConnectCount;
	protected long lastActivityTimestamp;
	protected Integer peakLimit;

	public Integer getPeakLimit() {
		return peakLimit;
	}

	public void setPeakLimit(Integer peakLimit) {
		this.peakLimit = peakLimit;
	}

	public long getLastActivityTimestamp() {
		return lastActivityTimestamp;
	}

	public void setLastActivityTimestamp(long lastActivityTimestamp) {
		this.lastActivityTimestamp = lastActivityTimestamp;
	}

	public Integer getMaxUsedCount() {
		return maxUsedCount;
	}

	public void setMaxUsedCount(Integer maxUsedCount) {
		this.maxUsedCount = maxUsedCount;
	}

	public Integer getUsedCount() {
		return usedCount;
	}

	public void setUsedCount(Integer usedCount) {
		this.usedCount = usedCount;
	}

	public Integer getWaitConnectCount() {
		return waitConnectCount;
	}

	public void setWaitConnectCount(Integer waitConnectCount) {
		this.waitConnectCount = waitConnectCount;
	}

	public String getPoolName() {
		return poolName;
	}

	public void setPoolName(String poolName) {
		this.poolName = poolName;
	}

	public Integer getActiveConCount() {
		return activeConCount;
	}

	public void setActiveConCount(Integer activeConCount) {
		this.activeConCount = activeConCount;
	}

	// 这个用于显示最近活动时间
	public String getLastActivityTimestampString() {
		return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(
				lastActivityTimestamp));
	}
}
