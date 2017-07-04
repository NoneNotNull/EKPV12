package com.landray.kmss.tib.sys.soap.connector.impl;

import java.io.InputStream;
import java.net.URL;

import org.apache.commons.httpclient.Credentials;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.UsernamePasswordCredentials;
import org.apache.commons.httpclient.auth.AuthScope;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.params.HttpClientParams;
import org.apache.commons.httpclient.params.HttpConnectionManagerParams;
import org.apache.commons.io.IOUtils;

import com.eviware.soapui.impl.wsdl.support.wsdl.WsdlLoader;
import com.landray.sso.client.util.StringUtil;

public class TibSysSoapWsdlLoader extends WsdlLoader {

	private String userName;
	private String password;
	private Integer connTimeOut;
	private Integer soTimeOut;

	private TibSysSoapWsdlLoader(String url) {
		super(url);
	}
	
	public TibSysSoapWsdlLoader(String url, String userName, 
			String password, String connTimeOut, String soTimeOut) {
		super(url);
		if (StringUtil.isNotNull(userName))
			this.userName = userName;
		if (StringUtil.isNotNull(password))
			this.password = password;
		if (StringUtil.isNotNull(connTimeOut))
			this.connTimeOut = Integer.parseInt(connTimeOut);
		if (StringUtil.isNotNull(soTimeOut))
			this.soTimeOut = Integer.parseInt(soTimeOut);
	}

	@Override
	public InputStream load(String address) throws Exception {
		InputStream is = null;
		GetMethod get =null;
		try {
			HttpClient client = new HttpClient();
			HttpClientParams params = new HttpClientParams();

			 get = new GetMethod(address);

			params.setAuthenticationPreemptive(true);
			client.setParams(params);
			// 设置连接超时与请求超时
			HttpConnectionManagerParams connParams = client.getHttpConnectionManager().getParams();
			if (connTimeOut != null && soTimeOut != null) {
				connParams.setConnectionTimeout(connTimeOut);
				connParams.setSoTimeout(soTimeOut);
			}
			if (StringUtil.isNotNull(userName) && StringUtil.isNotNull(password)) {
				Credentials credentials = new UsernamePasswordCredentials(userName,
						password);
				AuthScope scope = new AuthScope(new URL(address).getHost(),
						org.apache.commons.httpclient.auth.AuthScope.ANY_PORT,
						org.apache.commons.httpclient.auth.AuthScope.ANY_REALM);
				client.getState().setCredentials(scope, credentials);
			}

			get.setDoAuthentication(true);

			int status = client.executeMethod(get);
			if (status == 404) {
				throw new Exception("WSDL could not be found at: '" + address
						+ '\'');
			}
			boolean authenticated = status > 0 && status < 400;
			if (authenticated) {
				// inputSource = new InputSource(get.getResponseBodyAsStream());
				is = get.getResponseBodyAsStream();

			} else {
				throw new Exception("Could not authenticate user: '" + userName
						+ "' to WSDL: '" + address + '\'');
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			if(get!=null){
				get.releaseConnection();
			}
			IOUtils.closeQuietly(is);
		}
		return is;

	}

	public void close() {

	}

}
