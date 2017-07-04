package com.landray.kmss.util;

import lotus.domino.NotesException;
import lotus.domino.NotesFactory;
import lotus.domino.Session;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class LotusUtil {
	private static final Log logger = LogFactory.getLog(LotusUtil.class);

	private static String dominoDIIOPServer = ResourceUtil
			.getKmssConfigString("kmss.domino.diiopServer");

	private static String dominoLoginName = ResourceUtil
			.getKmssConfigString("kmss.domino.loginName");

	private static String dominoPassword = ResourceUtil
			.getKmssConfigString("kmss.domino.password");

	private static ThreadLocal session = new ThreadLocal();

	/**
	 * 获取Domino Session，前端调用时自动释放
	 * 
	 * @return
	 * @throws NotesException
	 */
	public static Session getSession() throws NotesException {
		Session dominoSession = (Session) session.get();
		if (StringUtil.isNull(dominoDIIOPServer)) {
			return null;
		}
		if (dominoSession == null) {
			try {
				dominoSession = NotesFactory.createSession(dominoDIIOPServer,
						dominoLoginName, dominoPassword);
				if (logger.isDebugEnabled())
					logger.debug("成功创建Domino Session(" + dominoDIIOPServer
							+ ")");
				session.set(dominoSession);
			} catch (NotesException e) {
				logger.error("创建Domino Session(" + dominoDIIOPServer + ") 失败:"
						+ e.text, e);
				throw e;
			}
		}
		return dominoSession;
	}
	
	public static Session getSession(String dominoDIIOPServer_,String dominoLoginName_,String dominoPassword_) throws NotesException {
		Session dominoSession = (Session) session.get();
		if (StringUtil.isNull(dominoDIIOPServer_)) {
			return null;
		}
		if (dominoSession == null) {
			try {
				dominoSession = NotesFactory.createSession(dominoDIIOPServer_,
						dominoLoginName_, dominoPassword_);
				if (logger.isDebugEnabled())
					logger.debug("成功创建Domino Session(" + dominoDIIOPServer_
							+ ")");
				session.set(dominoSession);
			} catch (NotesException e) {
				logger.error("创建Domino Session(" + dominoDIIOPServer_ + ") 失败:"
						+ e.text, e);
				throw e;
			}
		}
		return dominoSession;
	}

	public static void destroySession() {
		Session dominoSession = (Session) session.get();
		if (dominoSession != null)
			try {
				session.set(null);
				dominoSession.recycle();
				if (logger.isDebugEnabled())
					logger.debug("成功销毁Domino Session(" + dominoDIIOPServer
							+ ")");
			} catch (NotesException e) {
			}
	}
}
