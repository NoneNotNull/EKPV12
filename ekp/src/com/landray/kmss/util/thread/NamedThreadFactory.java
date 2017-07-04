/**
 * 
 */
package com.landray.kmss.util.thread;

import java.util.concurrent.ThreadFactory;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 可命名线程工厂
 * <p>
 * 以替换Executors采用的默认工厂，重命名线程名称，方便日志跟踪
 * 
 * @author 傅游翔 2011-02-22
 * 
 */
public class NamedThreadFactory implements ThreadFactory {

	protected static final AtomicInteger poolNumber = new AtomicInteger(1);

	protected final AtomicInteger threadNumber = new AtomicInteger(1);

	protected final String namePrefix;

	/**
	 * @param name
	 *            - 线程限定名
	 */
	public NamedThreadFactory(String name) {
		namePrefix = name + "-pool-" + poolNumber.getAndIncrement()
				+ "-thread-";
	}

	public Thread newThread(Runnable r) {
		Thread t = new Thread(r, namePrefix + threadNumber.getAndIncrement());
		if (t.isDaemon())
			t.setDaemon(false);
		if (t.getPriority() != Thread.NORM_PRIORITY)
			t.setPriority(Thread.NORM_PRIORITY);
		return t;
	}
}
