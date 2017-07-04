package com.landray.kmss.common.service;

public interface IDispatchCoreService extends ICoreOuterService {
	public void addService(IAdditionalService service);

	public void removeService(IAdditionalService service);

	public void resetService();
}
