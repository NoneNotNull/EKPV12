package com.landray.kmss.tib.soap.mapping.service.spring;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.formula.parser.FormulaParser;
import com.landray.kmss.sys.metadata.interfaces.ISysMetadataParser;
import com.landray.kmss.sys.workflow.engine.INodeServiceActionResult;
import com.landray.kmss.sys.workflow.engine.WorkflowEngineContext;
import com.landray.kmss.sys.workflow.engine.spi.model.SysWfNode;
import com.landray.kmss.sys.workflow.support.oa.robot.interfaces.ISysWfRobotNodeService;
import com.landray.kmss.sys.workflow.support.oa.robot.support.AbstractRobotNodeServiceImp;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFuncExt;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncXmlOperateService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMainService;
import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.tib.sys.soap.connector.util.header.SoapInfo;
import com.landray.kmss.util.StringUtil;

/**
 * WebService函数机器人节点实现
 * 
 * @author LINMINGMING
 * 
 */
public class TibSoapWfRobotNodeRunWebServiceService extends
		AbstractRobotNodeServiceImp implements ISysWfRobotNodeService {
	private static final Log log = LogFactory
			.getLog(TibSoapWfRobotNodeRunWebServiceService.class);
	
	private ITibCommonMappingFuncService tibCommonMappingFuncService;

	public void setTibCommonMappingFuncService(
			ITibCommonMappingFuncService tibCommonMappingFuncService) {
		this.tibCommonMappingFuncService = tibCommonMappingFuncService;
	}

	private ITibCommonMappingFuncXmlOperateService tibCommonMappingFuncXmlOperateService;


	public void setTibCommonMappingFuncXmlOperateService(
			ITibCommonMappingFuncXmlOperateService tibCommonMappingFuncXmlOperateService) {
		this.tibCommonMappingFuncXmlOperateService = tibCommonMappingFuncXmlOperateService;
	}

	public void setTibSysSoapMainService(
			ITibSysSoapMainService tibSysSoapMainService) {
		this.tibSysSoapMainService = tibSysSoapMainService;
	}

	public void setTibSysSoap(ITibSysSoap tibSysSoap) {
		this.tibSysSoap = tibSysSoap;
	}

	private ISysMetadataParser sysMetadataParser;

	public void setSysMetadataParser(ISysMetadataParser sysMetadataParser) {
		this.sysMetadataParser = sysMetadataParser;
	}

	private ITibCommonMappingMainService tibCommonMappingMainService;

	public void setTibCommonMappingMainService(
			ITibCommonMappingMainService tibCommonMappingMainService) {
		this.tibCommonMappingMainService = tibCommonMappingMainService;
	}
	
	private ITibSysSoapMainService tibSysSoapMainService;
	
	private ITibSysSoap tibSysSoap ;


	public INodeServiceActionResult execute(WorkflowEngineContext context,
			SysWfNode node) throws Exception {
		String cfgContent = getConfigContent(context, node);
		if (cfgContent == null) {
			return getDefaultActionResult(context, node);
		}
		IBaseModel mainModel = context.getMainModel();
		TibCommonMappingFuncExt exProgram = null;
		try {
			// 获得JSON配置
			JSONObject json = (JSONObject) JSONValue.parse(cfgContent);
			String funcId = (String) json.get("funcId");
			TibCommonMappingFunc tibCommonMappingFunc = getFunc(funcId);
			
			if(tibCommonMappingFunc==null){
				log.error("执行 Soap机器人节点, 执行 Soap TibCommonMappingFunc 中找不到关联的配置映射信息,请检查TibCommonMappingFunc 的"+funcId+"是否存在,或者重新创建机器人节点创建关联关系~");
				throw new Exception("Execute soap robot node, See log TibCommonMappingFunc");
			}
			
			
			// 程序异常
			exProgram = tibCommonMappingFunc.getFdExtend().get(1);
			if (tibCommonMappingFunc == null) {
				return getDefaultActionResult(context, node);
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
//				没注册
				if (!tibCommonMappingFuncXmlOperateService
						.ifRegister(fdTemplateName,Constant.FD_TYPE_SOAP))
					return getDefaultActionResult(context, node);
//				已经注册
				else{
					
					org.w3c.dom.Document doc= DOMHelper.parseXmlString(tibCommonMappingFunc
							.getFdRfcParamXml());
					NodeList n_list=doc.getElementsByTagName("web");
					org.w3c.dom.Node curNode=DOMHelper.getElementNode(n_list, 0);
					
					org.w3c.dom.Node attrNode=curNode.getAttributes().getNamedItem("ID");
					String attrId =attrNode.getTextContent();
					if(StringUtil.isNull(attrId)){
						log.error("Soap 模板中配置的web节点ID属性 没有找到对应的配置信息!");
						return getDefaultActionResult(context, node);
					}
					else{
						TibSysSoapMain tibSysSoapMain= (TibSysSoapMain)tibSysSoapMainService.findByPrimaryKey(attrId,null,true);
						
						if(tibSysSoapMain==null){
							log.error("Soap 模板中没有找到配置的web 节点没有ID属性!");
							return getDefaultActionResult(context, node);
						}
						FormulaParser formulaParser = FormulaParser.getInstance(mainModel);
						NodeList nodelist=doc.getElementsByTagName("Input");
						tibCommonMappingFuncXmlOperateService.setInputInfo(nodelist, formulaParser);
						String resetXml =DOMHelper.nodeToString((org.w3c.dom.Node)doc);
						
						SoapInfo soapInfo =new SoapInfo();
						soapInfo.setRequestXml(resetXml);
						soapInfo.setTibSysSoapMain(tibSysSoapMain);
						String result=tibSysSoap.inputToAllXml(soapInfo);
						
						String[] mergeXml=new String[4];
						mergeXml[0]="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
						mergeXml[1]="<web ID=\"!{fdId}\">".replace("!{fdId}", funcId);
						mergeXml[2]=result;
						mergeXml[3]="</web>";
						String real_result=StringUtils.join(mergeXml);
						org.w3c.dom.Document res_doc= DOMHelper.parseXmlString(real_result);
						NodeList res_nList=res_doc.getElementsByTagName("Output");
						// 把值存入m_store
						boolean flagBussiness = tibCommonMappingFuncXmlOperateService
								.setOutputInfo(res_nList, formulaParser,
										mainModel, true);
						NodeList fault_nList= res_doc.getElementsByTagName("Fault");
						
//						程序异常
						if(fault_nList.getLength()>0){
							programFaultInfo(fault_nList, formulaParser, mainModel);
							Node faultNode=DOMHelper.getElementNode(fault_nList, 0);
							String faultStr=DOMHelper.nodeToString(faultNode, true);
							throw new Exception("WEBSERVICE return Fault:\n"+faultStr);
						}
						//						发生了业务异常进行处理
						if(!flagBussiness){
							tibCommonMappingFuncXmlOperateService.businessException(null, tibCommonMappingFunc, mainModel);
						}
						sysMetadataParser.saveModel(mainModel);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			tibCommonMappingFuncXmlOperateService.programException(e, exProgram, mainModel);
		} finally {
			// 用传出参数修改model后保存更新此model，出现异常也必须保存可能赋值的错误信息
			sysMetadataParser.saveModel(mainModel);
		}
		return getDefaultActionResult(context, node);
	}
	
	private void programFaultInfo(NodeList nodeList, FormulaParser parser,
			IBaseModel mainModel) throws Exception {
		// fault节点赋值
		tibCommonMappingFuncXmlOperateService.setOutputInfo(nodeList, parser,
				mainModel, true);
	}

	private TibCommonMappingFunc getFunc(String funcId) throws Exception {
		TibCommonMappingFunc tibCommonMappingFunc = (TibCommonMappingFunc) tibCommonMappingFuncService
				.findByPrimaryKey(funcId, TibCommonMappingFunc.class, true);
		return tibCommonMappingFunc;
	}

	public void settibCommonMappingFuncXmlOperateService(
			ITibCommonMappingFuncXmlOperateService tibCommonMappingFuncXmlOperateService) {
		this.tibCommonMappingFuncXmlOperateService = tibCommonMappingFuncXmlOperateService;
	}


	public void settibSysSoapMainService(ITibSysSoapMainService tibSysSoapMainService) {
		this.tibSysSoapMainService = tibSysSoapMainService;
	}

	public ITibSysSoap gettibSysSoap() {
		return tibSysSoap;
	}

	public void settibSysSoap(ITibSysSoap tibSysSoap) {
		this.tibSysSoap = tibSysSoap;
	}
	
	
	
	


}
