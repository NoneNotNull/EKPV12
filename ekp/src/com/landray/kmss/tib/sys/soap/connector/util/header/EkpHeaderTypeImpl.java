/**
 * 
 */
package com.landray.kmss.tib.sys.soap.connector.util.header;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.util.MD5Util;

/**
 * @author 邱建华
 * @version 1.0 2012-11-13
 */
public class EkpHeaderTypeImpl extends ISoapHeaderType {

	/**
	 * EKP登录方式处理头部信息
	 * doc是整个请求xml的节点
	 * 扩展只要实现这个方法，doc中的//Envelope/Header写成下面这种形式就可以了。
	 * 创建自己的Header，下面是自己的模版格式
	 * <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	 *			  tns为自定义的命名空间
                  xmlns:tns="http://sys.webservice.client"
                  xmlns:web="http://webservicetest.review.km.kmss.landray.com/">
		   <soapenv:Header>
		   	  <tns:user>admin</tns:user>
			  <tns:password>c4ca4238a0b923820dcc509a6f75849b</tns:password>
		   </soapenv:Header>
	 */
	@Override
	public void buildDocTemplate(Document doc, TibSysSoapSetting soapuiSet) throws Exception {
		Element ele = doc.getDocumentElement();
		// 设置命名空间
		ele.setAttribute("xmlns:tns", "http://sys.webservice.client");
		// 获取头部节点
		Node node = HeaderOperation.selectNode("//Envelope/Header", ele);
		// 创建用户名密码
		Node usernameNode = doc.createElement("tns:user");
		usernameNode.setTextContent(soapuiSet.getFdUserName());
		Node passwordNode = doc.createElement("tns:password");
		passwordNode.setTextContent(MD5Util.getMD5String(soapuiSet.getFdPassword()));
		// 把用户名密码加入头部节点
		node.appendChild(usernameNode);
		node.appendChild(passwordNode);
	}
	
}
