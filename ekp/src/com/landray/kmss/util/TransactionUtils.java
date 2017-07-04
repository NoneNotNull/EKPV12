package com.landray.kmss.util;

import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

public class TransactionUtils {
	/**
	 * 获取事务管理器对象
	 * 
	 * @return 事务管理器
	 */
	public static PlatformTransactionManager getTransactionManager() {
		return (PlatformTransactionManager) SpringBeanUtil
				.getBean("transactionManager");
	}

	/**
	 * 开始事务，返回默认属性的事务状态对象。如果需要自定义事务属性，请自己编写类似代码即可。 事务对象定义如下
	 * <code>DefaultTransactionDefinition td = new DefaultTransactionDefinition( 
	 *  TransactionDefinition.PROPAGATION_REQUIRED); 
	 *   td.setReadOnly(true);</code>
	 * 
	 * @return 事务状态对象
	 */
	public static TransactionStatus beginTransaction() {
		DefaultTransactionDefinition td = new DefaultTransactionDefinition(
				TransactionDefinition.PROPAGATION_REQUIRED);
		// td.setReadOnly(true);
		TransactionStatus status = getTransactionManager().getTransaction(td);
		return status;
	}

	public static TransactionStatus beginNewTransaction() {
		DefaultTransactionDefinition td = new DefaultTransactionDefinition(
				TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		// td.setReadOnly(true);
		TransactionStatus status = getTransactionManager().getTransaction(td);
		return status;
	}

	public static TransactionStatus beginNewReadTransaction() {
		DefaultTransactionDefinition td = new DefaultTransactionDefinition(
				TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		td.setReadOnly(true);
		TransactionStatus status = getTransactionManager().getTransaction(td);
		return status;
	}

	public static void commit(TransactionStatus status) {
		getTransactionManager().commit(status);
	}

	public static void rollback(TransactionStatus status) {
		if (!status.isCompleted()) {
			getTransactionManager().rollback(status);
		}
	}
	// 调用示例代码：
	// TransactionStatus status = TransactionUtils.beginTransaction();
	// try{
	// dosomthing...
	// TransactionUtils.getTransactionManager().commit(status);
	// }
	// catch(youException e){
	// logger.error("",e);
	// TransactionUtils.getTransactionManager().rollback(status);
	// }
}
