package com.landray.kmss.tib.sys.soap.connector.impl;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.xmlbeans.XmlException;

import com.eviware.soapui.impl.WsdlInterfaceFactory;
import com.eviware.soapui.impl.wsdl.WsdlInterface;
import com.eviware.soapui.impl.wsdl.WsdlOperation;
import com.eviware.soapui.impl.wsdl.WsdlProject;
import com.eviware.soapui.impl.wsdl.WsdlRequest;
import com.eviware.soapui.support.SoapUIException;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.util.StringUtil;

/**
 *
 * wsdlproject 工厂
 * date :2012-11-13 下午10:21:08
 */
public class TibSysSoapProjectFactory {
	
	private static final Log log = LogFactory
	.getLog(TibSysSoapProjectFactory.class);
	
	// WsdlInterface存储仓库用来缓存已经抽取过的数据
	private static ConcurrentHashMap<String, Map<String,WsdlInterface>> wsdlInterfaceStore = 
			new ConcurrentHashMap<String, Map<String,WsdlInterface>>(1);
 	
	/**
	 * 获取WsdlProject实例
	 * @return
	 * @throws XmlException
	 * @throws IOException
	 * @throws SoapUIException
	 */
	public static WsdlProject getWsdlProjectInstance() 
			throws XmlException, IOException, SoapUIException { 
		return new WsdlProject();
	}
	
	/**
	 * 获取缓存对象中的WsdlInterface数据
	 * 如果没有这个wsdl 的对象就创建，有就直接获取
	 * @param wsdlUrl WsdlInterface 数据
	 * @param soapVersion soap版本
	 * @return
	 * @throws SoapUIException
	 * @throws XmlException
	 * @throws IOException
	 */
	public static WsdlInterface getWsdlInterfaceInstance(TibSysSoapSetting soapuiSett,
			String soapVersion) throws SoapUIException, XmlException, IOException{
		TimeCounter.logCurrentTime("TibSysSoapProjectFactory-getWsdlInterfaceInstance", true, TibSysSoapProjectFactory.class);
		String serviceId = soapuiSett.getFdId();
		soapVersion = StringUtils.deleteWhitespace(soapVersion);
		// 如果这个连接的数据在缓存区间内 
		if(wsdlInterfaceStore.containsKey(serviceId)){
			Map<String, WsdlInterface> wsdlFaces= wsdlInterfaceStore.get(serviceId);
			if (wsdlFaces.containsKey(soapVersion)) {
				return wsdlFaces.get(soapVersion);
			}
		}
		// 不在缓存区间
		WsdlInterface[] ifaces = importWsdl(soapuiSett);
		if (ifaces.length > 0) {
			WsdlInterface iface = null;
			Map<String, WsdlInterface> ifaceMap = new HashMap<String, WsdlInterface>(1);
			// 把WsdlInterface全部存入大Map
			for (WsdlInterface face : ifaces) {
				String displaySoapVersionName = face.getSoapVersion().getName();
				displaySoapVersionName = StringUtils.deleteWhitespace(displaySoapVersionName);
				ifaceMap.put(displaySoapVersionName, face);
				if (soapVersion != null
						&& displaySoapVersionName.equals(soapVersion))
					iface = face;
			}
			wsdlInterfaceStore.put(serviceId, ifaceMap);
			return iface;
		}
		TimeCounter.logCurrentTime("TibSysSoapProjectFactory-getWsdlInterfaceInstance", false,TibSysSoapProjectFactory.class);
		log.info("获取不到对应的数据");
		return null;
		
	}
	
	/**
	 * 获取WsdlInterface数组
	 * @param wsdlUrl			WSDL地址
	 * @param userName			受保护的用户名
	 * @param password			受保护的密码
	 * @param connTimeOut		连接超时
	 * @param soTimeOut			响应超时
	 * @return					WsdlInterface数组
	 * @throws SoapUIException
	 * @throws XmlException
	 * @throws IOException
	 */
	public static WsdlInterface[] importWsdl(TibSysSoapSetting soapuiSett) 
					throws SoapUIException, XmlException, IOException{
		// 取出需要设置的参数
		String wsdlUrl = soapuiSett.getFdWsdlUrl();
		String proUsername = soapuiSett.getFdloadUser();
		String proPassword = soapuiSett.getFdloadPwd();
		String connTimeOut = soapuiSett.getFdOverTime();
		String soTimeOut = soapuiSett.getFdResponseTime();
		// 创建WsdlLoader，包含HttpClient设置
		
		if(StringUtil.isNotNull(proUsername)&&StringUtil.isNotNull(proPassword)){
			TibSysSoapWsdlLoader wsdlLoader = new TibSysSoapWsdlLoader(wsdlUrl, proUsername, proPassword, connTimeOut, 
					soTimeOut);
			return WsdlInterfaceFactory.importWsdl(getWsdlProjectInstance(),
					wsdlUrl, false, wsdlLoader);
		} else {
			return WsdlInterfaceFactory.importWsdl(getWsdlProjectInstance(), wsdlUrl, false);
		}
		
		
		
	}
	
	/**
	 * 通过wsdlUrl,operationName获取WsdlOperation
	 * @param wsdlUrl			WSDL地址
	 * @param operationName		操作名称（一般为发布WEBSERVICE方法名，在模块中叫绑定函数名称）
	 * @param soapVersion		Soap版本
	 * @return					返回Operation
	 * @throws Exception
	 */
	public static WsdlOperation getWsdlOperation(TibSysSoapSetting soapuiSett, String operationName, 
			String soapVersion) throws Exception {
		// 实例WsdlInterface
		WsdlInterface iface = getWsdlInterfaceInstance(soapuiSett, soapVersion);
		// 找出为当前调用的WebService方法，进行获取Operation
		WsdlOperation wsdlOperation = iface.getOperationByName(operationName);
		return wsdlOperation;
	} 
	
	/**
	 * 获取WSDL请求
	 * @param wsdlUrl			WSDL地址
	 * @param operationName		操作名称（一般为发布WEBSERVICE方法名，在模块中叫绑定函数名称）
	 * @param soapVersion		Soap版本
	 * @return
	 * @throws Exception
	 */
	public static WsdlRequest getRequest(TibSysSoapSetting soapuiSett, String operationName, 
			String soapVersion) throws Exception{
		String wsdlUrl = soapuiSett.getFdWsdlUrl();
		// 拼串一个唯一的请求名称
		String requestName = wsdlUrl +"/"+ operationName +"/"+ soapVersion;
		// 添加一个请求
		WsdlOperation wsdlOperation = getWsdlOperation(soapuiSett, operationName, soapVersion);
		WsdlRequest wsdlRequest = wsdlOperation.getRequestByName(requestName);
		if (wsdlRequest == null) {
			wsdlRequest = wsdlOperation.addNewRequest(requestName);
		}
		return wsdlRequest;
	}
	
	/**
	 * 通过服务ID清除缓存
	 * @param serviceId
	 */
	public static void cleanCacheByServiceId(String serviceId){
		if(StringUtils.isEmpty(serviceId)){
			return ;
		}
		if (wsdlInterfaceStore.containsKey(serviceId)) {
			wsdlInterfaceStore.remove(serviceId);
		}
	}
	
	
	
	

	
	
	
}
