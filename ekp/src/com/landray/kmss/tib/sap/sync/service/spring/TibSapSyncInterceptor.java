package com.landray.kmss.tib.sap.sync.service.spring;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;

import com.landray.kmss.tib.sap.sync.service.ITibSapSyncJobService;
import com.landray.kmss.util.StringUtil;

/**
 * 临时方案,使用拦截器同步sapquartz 与sys quartz 的数据部吻合
 * 只针对 在sys 的quartz 页面的启用禁用按钮以及runjob后数据更新sap quartz的数据
 * @author user
 *
 */
public class TibSapSyncInterceptor implements MethodInterceptor{
	
	private ITibSapSyncJobService tibSapSyncJobService;

	public void setTibSapSyncJobService(ITibSapSyncJobService tibSapSyncJobService) {
		this.tibSapSyncJobService = tibSapSyncJobService;
	}


	public Object invoke(MethodInvocation arg0) throws Throwable {
		
		Object rtn=arg0.proceed();
		try{
		if("chgEnabled".equals(arg0.getMethod().getName()))
		{
			if(arg0.getArguments().length==2&&arg0.getArguments()[1] instanceof Boolean)
			{
				String[] ids=(
						String[])arg0.getArguments()[0];
			   Boolean fenable=(
						Boolean)arg0.getArguments()[1];
			   chgEnabledAdapter(ids, fenable);
			}
		}
		else if("runJob".equals(arg0.getMethod().getName()))
		{
			if(arg0.getArguments().length==1&&arg0.getArguments()[0] instanceof String)
			{
				String quartzId=(String)arg0.getArguments()[0];
				if(!StringUtil.isNull(quartzId))
				{
					runJobAdapter(quartzId);
				}
				
			}
		}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return rtn;
	}
	
	public void chgEnabledAdapter(String[] ids,Boolean fenable) throws Exception
	{
		tibSapSyncJobService.updateEnableTibSapSync(ids, fenable);
	}
	
	public void runJobAdapter(String id) throws Exception
	{
		tibSapSyncJobService.getBaseDao().flushHibernateSession();
		tibSapSyncJobService.updateAfterRunJob(id);
	}

}
