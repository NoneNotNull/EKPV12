package com.landray.kmss.tib.sys.core.test;

import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;

import com.landray.kmss.tib.sys.core.provider.process.events.TibSysCoreExceptionEvent;
import com.landray.kmss.tib.sys.core.provider.process.events.TibSysCoreFinishEvent;
import com.landray.kmss.tib.sys.core.provider.process.events.TibSysCoreReceiveEvent;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysEventDataVo;

public class TestEvent implements ApplicationListener {

	public void onApplicationEvent(ApplicationEvent event) {
		// TODO 自动生成的方法存根

//		监听tib异常事件
		if (event instanceof TibSysCoreExceptionEvent) {
//		返回事件数据
			TibSysEventDataVo td=(TibSysEventDataVo)event.getSource();
//		获取返回数据	
			td.getData();
//		获取返回的key值	
			td.getKey();
			
		} 
//		同上
		else if (event instanceof TibSysCoreFinishEvent) {

		} 
//		同上
		else if (event instanceof TibSysCoreReceiveEvent) {

		}
	}
}
