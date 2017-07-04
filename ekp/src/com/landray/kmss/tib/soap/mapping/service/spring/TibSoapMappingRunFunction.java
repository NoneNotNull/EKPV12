package com.landray.kmss.tib.soap.mapping.service.spring;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.formula.parser.FormulaParser;
import com.landray.kmss.sys.metadata.interfaces.ISysMetadataParser;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFuncExt;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncXmlOperateService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMainService;
import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.tib.sys.soap.connector.util.header.SoapInfo;
import com.landray.kmss.util.StringUtil;

public class TibSoapMappingRunFunction {
	
	private static final Log log = LogFactory
			.getLog(TibSoapWfRobotNodeRunWebServiceService.class);
	private ITibCommonMappingMainService tibCommonMappingMainService;
	private ITibCommonMappingFuncXmlOperateService tibSoapMappingWebServiceXmlOperateService;
	private ITibSysSoapMainService tibSysSoapMainService;
	private ITibSysSoap tibSysSoap;
	private ISysMetadataParser sysMetadataParser;
	
	public void setTibCommonMappingMainService(
			ITibCommonMappingMainService tibCommonMappingMainService) {
		this.tibCommonMappingMainService = tibCommonMappingMainService;
	}

	public void setTibSoapMappingWebServiceXmlOperateService(
			ITibCommonMappingFuncXmlOperateService tibSoapMappingWebServiceXmlOperateService) {
		this.tibSoapMappingWebServiceXmlOperateService = tibSoapMappingWebServiceXmlOperateService;
	}

	public void setTibSysSoapMainService(
			ITibSysSoapMainService tibSysSoapMainService) {
		this.tibSysSoapMainService = tibSysSoapMainService;
	}

	public void setTibSysSoap(ITibSysSoap tibSysSoap) {
		this.tibSysSoap = tibSysSoap;
	}

	public void setSysMetadataParser(ISysMetadataParser sysMetadataParser) {
		this.sysMetadataParser = sysMetadataParser;
	}

	public void runWS(TibCommonMappingFunc tibCommonMappingFunc, IBaseModel mainModel) throws Exception {
		try {
			if(tibCommonMappingFunc==null){
				log.error("执行 Soap TibCommonMappingFunc 中找不到关联的配置映射信息,请检查TibCommonMappingFunc是否存在");
				throw new Exception("Execute soap robot node, See log TibCommonMappingFunc");
			}
			
			// 判断是否注册启用
			String fdTemplateId = tibCommonMappingFunc.getFdTemplateId();
			HQLInfo hqlInfo=new HQLInfo();
			hqlInfo.setSelectBlock(" tibCommonMappingMain.fdMainModelName ");
			hqlInfo.setWhereBlock(" tibCommonMappingMain.fdTemplateId=:fdTemplateId");
			hqlInfo.setParameter("fdTemplateId", fdTemplateId);
			List<String> list=tibCommonMappingMainService.findValue(hqlInfo);
			
			if (list != null && !list.isEmpty()) {
				String fdTemplateName = (String) list.get(0);
				// 没注册
				if (!tibSoapMappingWebServiceXmlOperateService
						.ifRegister(fdTemplateName,Constant.FD_TYPE_SOAP)) {
					return ;
				} else {
					// 已经注册
					Document doc= DOMHelper.parseXmlString(tibCommonMappingFunc
							.getFdRfcParamXml());
					NodeList n_list=doc.getElementsByTagName("web");
					Node curNode = DOMHelper.getElementNode(n_list, 0);
					Node attrNode = curNode.getAttributes().getNamedItem("ID");
					String attrId = attrNode.getTextContent();
					if(StringUtil.isNull(attrId)){
						log.error("Soap 模板中配置的web节点ID属性 没有找到对应的配置信息!");
						return ;
					} else {
						TibSysSoapMain tibSysSoapMain= (TibSysSoapMain)tibSysSoapMainService.findByPrimaryKey(attrId,null,true);
						if(tibSysSoapMain==null){
							log.error("Soap 模板中没有找到配置的web 节点没有ID属性!");
							return ;
						}
						FormulaParser formulaParser = FormulaParser.getInstance(mainModel);
						NodeList nodelist=doc.getElementsByTagName("Input");
						tibSoapMappingWebServiceXmlOperateService.setInputInfo(nodelist, formulaParser);
						String resetXml =DOMHelper.nodeToString((Node)doc);
						SoapInfo soapInfo =new SoapInfo();
						soapInfo.setRequestXml(resetXml);
						soapInfo.setTibSysSoapMain(tibSysSoapMain);
						String result=tibSysSoap.inputToAllXml(soapInfo);
						
						String[] mergeXml=new String[4];
						mergeXml[0]="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
						mergeXml[1]="<web ID=\"!{fdId}\">".replace("!{fdId}", tibCommonMappingFunc.getFdId());
						mergeXml[2]=result;
						mergeXml[3]="</web>";
						String real_result=StringUtils.join(mergeXml);
						org.w3c.dom.Document res_doc= DOMHelper.parseXmlString(real_result);
						NodeList res_nList=res_doc.getElementsByTagName("Output");
						// 把值存入m_store
						boolean flagBussiness = tibSoapMappingWebServiceXmlOperateService
								.setOutputInfo(res_nList, formulaParser,
										mainModel, true);
						NodeList fault_nList= res_doc.getElementsByTagName("Fault");
						// 程序异常
						if(fault_nList.getLength()>0){
							programFaultInfo(fault_nList, formulaParser, mainModel);
							Node faultNode=DOMHelper.getElementNode(fault_nList, 0);
							String faultStr=DOMHelper.nodeToString(faultNode, true);
							throw new Exception("WEBSERVICE return Fault:\n"+faultStr);
						}
						// 发生了业务异常进行处理
						if(!flagBussiness){
							tibSoapMappingWebServiceXmlOperateService.businessException(null, tibCommonMappingFunc, mainModel);
						}
						sysMetadataParser.saveModel(mainModel);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			// 程序异常
			TibCommonMappingFuncExt exProgram = tibCommonMappingFunc.getFdExtend().get(1);
			tibSoapMappingWebServiceXmlOperateService.programException(e, exProgram, mainModel);
		} finally {
			// 用传出参数修改model后保存更新此model，出现异常也必须保存可能赋值的错误信息
			sysMetadataParser.saveModel(mainModel);
		}
	}
	
	private void programFaultInfo(NodeList nodeList, FormulaParser parser,
			IBaseModel mainModel) throws Exception {
		// fault节点赋值
		tibSoapMappingWebServiceXmlOperateService.setOutputInfo(nodeList, parser,
				mainModel, true);
	}
}
