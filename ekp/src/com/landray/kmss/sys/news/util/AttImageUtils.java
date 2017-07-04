package com.landray.kmss.sys.news.util;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.sys.attachment.model.SysAttMain;

/**
 * <pre>
 * 2008-12-11
 * 对新闻中的标题图片进行压缩
 * </pre>
 * 
 * @author 傅游翔
 * @see org.apache.commons.io.IOUtils
 */
public class AttImageUtils {
	
	private static final Log log = LogFactory.getLog(AttImageUtils.class);
	
	public static void resetInputStream(SysAttMain sysAttMain) throws IOException {
		if ("pic".equals(sysAttMain.getFdAttType())
				&& "com.landray.kmss.sys.news.model.SysNewsMain".equals(sysAttMain.getFdModelName())
				&& "Attachment".equals(sysAttMain.getFdKey())) {
			long star = 0;
			if (log.isDebugEnabled()) {
				log.debug("执行图片压缩");
				star = System.currentTimeMillis();
			}
			InputStream in = sysAttMain.getInputStream();
			ByteArrayInputStream newIn = ImageUitlsBean.getInstance().compressImage(in);
			sysAttMain.setInputStream(newIn);
			sysAttMain.setFdSize((double) newIn.available());
			IOUtils.closeQuietly(in);
			if (log.isDebugEnabled()) {
				log.debug("图片压缩结束");
				log.debug("共用时间：'" + (System.currentTimeMillis() - star) + "'毫秒...");
			}
		}
	}

}
