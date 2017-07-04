package com.landray.kmss.tib.sys.soap.connector.util.executor;

import java.util.Date;

import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.landray.kmss.tib.common.log.constant.TibCommonLogConstant;
import com.landray.kmss.tib.common.log.interfaces.ITibCommonLogInterface;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.tib.sys.soap.connector.util.executor.handler.ITibSysSoapExecuteHandler;
import com.landray.kmss.tib.sys.soap.connector.util.executor.vo.ITibSysSoapRtn;
import com.landray.kmss.tib.sys.soap.connector.util.header.HeaderOperation;
import com.landray.kmss.tib.sys.soap.connector.util.header.SoapInfo;
import com.landray.kmss.tib.sys.soap.connector.util.xml.ParseSoapXmlUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.sun.org.apache.xerces.internal.util.DOMUtil;

/**
 * 执行器的代理类，代soapExecutor运行执行webservice,且增加记录日志,
 * 合并返回值,分析异常的功能
 * @author zhangtian
 * date :2013-1-15 上午12:36:12
 */
public class SoapExecutorLogProxy extends AbstractSoapExecutor {

	private SoapInfo soapInfo;
	
	private AbstractSoapExecutor soapExecutor;
	
	public SoapExecutorLogProxy(AbstractSoapExecutor soapExecutor,SoapInfo soapInfo ) {
		super(soapExecutor.getTibSysSoapExecuteHandler(), soapExecutor.getPostData());
		this.soapInfo=soapInfo;
		this.soapExecutor=soapExecutor;
	}
	
	/**
	 * 执行webservice 
	 * @return
	 * @throws Exception
	 */
	@Override
	public ITibSysSoapRtn executeSoapui() throws Exception{
		ITibSysSoapRtn tibSysSoapRtn =soapExecutor.executeSoapui();
		//合并返回值，执行完以后只有返回值，没有跟页面配置的信息合并起来
		mergeRtnData(soapInfo, tibSysSoapRtn);
		//记录日志
		logProxySave(soapInfo, tibSysSoapRtn);
		return tibSysSoapRtn;
	}
	
	public void logProxySave(SoapInfo soapInfo, ITibSysSoapRtn tibSysSoapRtn){
		ITibCommonLogInterface tibCommonLogInterface = (ITibCommonLogInterface) SpringBeanUtil
				.getBean("tibCommonLogInterface");
		Date curDate = new Date();
		Document postDocument = null;
		Document rtnDocument = null;
		try{
			postDocument = soapInfo.getSourceDocument();
			rtnDocument= tibSysSoapRtn.getRtnDocument();
			if(ITibSysSoapRtn.ERP_SOAPUI_EAR_TYPE_ERROR.equals(tibSysSoapRtn.getRtnType())){
				tibCommonLogInterface.saveTibCommonLogMain(
						Constant.FD_TYPE_SOAP, null, soapInfo
								.getTibSysSoapMain().getTibSysSoapSetting()
								.getFdWsdlUrl(), soapInfo.getTibSysSoapMain()
								.getDocSubject(), curDate, new Date(), DOMHelper.nodeToString(postDocument, true), DOMHelper.nodeToString(rtnDocument, true),
						"执行webservice异常",
						TibCommonLogConstant.TIB_COMMON_LOG_TYPE_ERROR);
			} else if(ITibSysSoapRtn.ERP_SOAPUI_EAR_TYPE_ERROR.equals(tibSysSoapRtn.getRtnType())) {
				tibCommonLogInterface.saveTibCommonLogMain(
						Constant.FD_TYPE_SOAP, null, soapInfo
								.getTibSysSoapMain().getTibSysSoapSetting()
								.getFdWsdlUrl(), soapInfo.getTibSysSoapMain()
								.getDocSubject(), curDate, new Date(), DOMHelper.nodeToString(postDocument, true), DOMHelper.nodeToString(rtnDocument, true),
						"成功日志:TibSysSoapImpl",
						TibCommonLogConstant.TIB_COMMON_LOG_TYPE_SUCCESS);
				
			}
		}catch (Exception e) {
			e.printStackTrace();
			try{
				tibCommonLogInterface.saveTibCommonLogMain(Constant.FD_TYPE_SOAP,
					null, soapInfo.getTibSysSoapMain().getTibSysSoapSetting()
							.getFdWsdlUrl(), soapInfo.getTibSysSoapMain()
							.getDocSubject(), curDate, new Date(),DOMHelper.nodeToString(postDocument, true), DOMHelper.nodeToString(rtnDocument, true),
					"程序执行失败:TibSysSoapImpl:" + e.getMessage(),
					TibCommonLogConstant.TIB_COMMON_LOG_TYPE_SUCCESS);
			}catch(Exception ex){
				ex.printStackTrace();
			}
		}
	}
	

	public Document getPostData() {
		return soapExecutor.getPostData();
	}

	public void setPostData(Document postData) {
		soapExecutor.setPostData(postData);
	}

	public ITibSysSoapExecuteHandler getTibSysSoapExecuteHandler() {
		return soapExecutor.getTibSysSoapExecuteHandler();
	}

	public void setTibSysSoapExecuteHandler(
			ITibSysSoapExecuteHandler tibSysSoapExecuteHandler) {
		soapExecutor.setTibSysSoapExecuteHandler(tibSysSoapExecuteHandler);
	}
	
	
	public void mergeRtnData(SoapInfo soapInfo, ITibSysSoapRtn tibSysSoapRtn)
			throws Exception {
		// 包含全部节点的document
		Document source = soapInfo.getSourceDocument();
		// 值包含返回值的doc
		Document rtnDocument = tibSysSoapRtn.getRtnDocument();
		if (ITibSysSoapRtn.ERP_SOAPUI_EAR_TYPE_SUCCESS.equals(tibSysSoapRtn
				.getRtnType())) {
			Node node = HeaderOperation.allToPartNode(source, "//Output");
			Node rtnNode = rtnDocument.getDocumentElement();
			if (node != null && rtnNode != null) {
				ParseSoapXmlUtil.loopComment(node, rtnNode);
				// 增加Output
				DOMUtil.copyInto(rtnNode, node.getParentNode());
				node.getParentNode().removeChild(node);
				// 删除fault节点
				Node removeNode = HeaderOperation.selectNode("//Fault", source);
				if (removeNode != null) {
					removeNode.getParentNode().removeChild(removeNode);
				}
			}

		} else if (ITibSysSoapRtn.ERP_SOAPUI_EAR_TYPE_ERROR
				.equals(tibSysSoapRtn.getRtnType())) {
			Node node = HeaderOperation.allToPartNode(source, "//Fault");
			Node rtnNode = rtnDocument.getDocumentElement();
			if (node != null && rtnNode != null) {
				ParseSoapXmlUtil.loopComment(node, rtnNode);
				// 增加Output
				DOMUtil.copyInto(rtnNode, node.getParentNode());
				node.getParentNode().removeChild(node);
				// 删除fault节点
				Node removeNode = HeaderOperation
						.selectNode("//Output", source);
				if (removeNode != null) {
					removeNode.getParentNode().removeChild(removeNode);
				}
			}
		}
		tibSysSoapRtn.resetRtnDocument(source);
	}

	public SoapInfo getSoapInfo() {
		return soapInfo;
	}

	public void setSoapInfo(SoapInfo soapInfo) {
		this.soapInfo = soapInfo;
	}

	public AbstractSoapExecutor getSoapExecutor() {
		return soapExecutor;
	}

	public void setSoapExecutor(AbstractSoapExecutor soapExecutor) {
		this.soapExecutor = soapExecutor;
	}
	
	


}
