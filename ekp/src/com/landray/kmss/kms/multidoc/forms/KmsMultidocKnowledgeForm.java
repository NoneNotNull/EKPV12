package com.landray.kmss.kms.multidoc.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeBaseDocForm;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.plugins.interfaces.IKmCkoModifyLogForm;
import com.landray.kmss.sys.attachment.forms.IAttachmentForm;
import com.landray.kmss.sys.bookmark.interfaces.ISysBookmarkForm;
import com.landray.kmss.sys.edition.interfaces.ISysEditionMainForm;
import com.landray.kmss.sys.evaluation.interfaces.ISysEvaluationForm;
import com.landray.kmss.sys.evaluation.interfaces.ISysEvaluationNotesForm;
import com.landray.kmss.sys.introduce.interfaces.ISysIntroduceForm;
import com.landray.kmss.sys.readlog.interfaces.ISysReadLogForm;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainForm;
import com.landray.kmss.sys.tag.forms.SysTagMainForm;
import com.landray.kmss.sys.tag.interfaces.ISysTagMainForm;
import com.landray.kmss.sys.workflow.interfaces.ISysWfMainForm;
import com.landray.kmss.sys.workflow.interfaces.SysWfBusinessForm;

/**
 * 创建日期 2011-九月-04
 * 
 * @author
 */
public class KmsMultidocKnowledgeForm extends KmsKnowledgeBaseDocForm implements
		ISysEvaluationForm, ISysIntroduceForm, ISysReadLogForm, ISysWfMainForm,
		ISysEditionMainForm, ISysRelationMainForm, IAttachmentForm,
		IKmCkoModifyLogForm, ISysBookmarkForm,
		ISysTagMainForm, ISysEvaluationNotesForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = -6755821876346986208L;

	/*
	 * 域模型ID
	 */
	private String fdModelId = null;
	/*
	 * 域模型类名
	 */
	private String fdModelName = null;
	private String fdWorkId = null;
	private String fdPhaseId = null;

	public String getFdModelId() {
		return fdModelId;
	}

	public void setFdModelId(String fdModelId) {
		this.fdModelId = fdModelId;
	}

	public String getFdModelName() {
		return fdModelName;
	}

	public void setFdModelName(String fdModelName) {
		this.fdModelName = fdModelName;
	}

	public String getFdWorkId() {
		return fdWorkId;
	}

	public void setFdWorkId(String fdWorkId) {
		this.fdWorkId = fdWorkId;
	}

	public String getFdPhaseId() {
		return fdPhaseId;
	}

	public void setFdPhaseId(String fdPhaseId) {
		this.fdPhaseId = fdPhaseId;
	}

	/**
	 * 文档类型
	 */
	protected String docType = null;

	/**
	 * @return 文档类型
	 */
	public String getDocType() {
		return docType;
	}

	/**
	 * @param docType
	 *            文档类型
	 */
	public void setDocType(String docType) {
		this.docType = docType;
	}

	private String fdImportInfo = null;

	public String getFdImportInfo() {
		return fdImportInfo;
	}

	public void setFdImportInfo(String fdImportInfo) {
		this.fdImportInfo = fdImportInfo;
	}

	/**
	 * 文件编号
	 */
	private String fdNumber;

	public String getFdNumber() {
		return fdNumber;
	}

	public void setFdNumber(String fdNumber) {
		this.fdNumber = fdNumber;
	}

	/*
	 * （非 Javadoc）
	 * 
	 * @seeorg.apache.struts.action.ActionForm#reset(org.apache.struts.action.
	 * ActionMapping, javax.servlet.http.HttpServletRequest)
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		super.reset(mapping, request);
		fdModelId = null;
		fdModelName = null;
		fdPhaseId = null;
		fdWorkId = null;
		docType = null;
		fdImportInfo = null;
		fdStyle = null;
		fdNumber = null;
		docMainVersion = null;
		docAuxiVersion = null;
		docSourceId = null ;
		sysWfBusinessForm = new SysWfBusinessForm();
	}

	public Class getModelClass() {
		return KmsMultidocKnowledge.class;
	}

	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
		}
		return toModelPropertyMap;
	}

	/*
	 * 样式
	 */
	private String fdStyle = null;

	public String getFdStyle() {
		if (fdStyle == null) {
			return "default";
		}
		return fdStyle;
	}

	public void setFdStyle(String fdStyle) {
		this.fdStyle = fdStyle;
	}

	// ====评分 ===
	protected Double docScore;

	public Double getDocScore() {
		return docScore;
	}

	public void setDocScore(Double docScore) {
		this.docScore = docScore;
	}

	protected FormFile file = null;

	// 文件上传
	public FormFile getFile() {
		return this.file;
	}

	public void setFile(FormFile file) {
		this.file = file;
	}

	// *********************收藏机制(开始)*********************************//
	private String docMarkCount;

	public String getDocMarkCount() {
		return docMarkCount;
	}

	public void setDocMarkCount(String count) {
		this.docMarkCount = count;
	}

	// *********************收藏机制(结束)***************************//

	
	// ==============标签机制 开始==================
	SysTagMainForm SysTagMainForm = new SysTagMainForm();

	public SysTagMainForm getSysTagMainForm() {

		return SysTagMainForm;
	}

	// =================标签机制 结束=======================

	// ==================== 版本号 =========================
	private Long docMainVersion;
	private Long docAuxiVersion;

	public Long getDocMainVersion() {
		return docMainVersion;
	}

	public void setDocMainVersion(Long docMainVersion) {
		this.docMainVersion = docMainVersion;
	}

	public Long getDocAuxiVersion() {
		return docAuxiVersion;
	}

	public void setDocAuxiVersion(Long docAuxiVersion) {
		this.docAuxiVersion = docAuxiVersion;
	}

	// ================== 版本号 结束=========================

	// ================== 流程机制========= ================
	private SysWfBusinessForm sysWfBusinessForm = new SysWfBusinessForm();

	public SysWfBusinessForm getSysWfBusinessForm() {
		return sysWfBusinessForm;
	}
	
	private String docSourceId = null ;

	public String getDocSourceId() {
		return docSourceId;
	}

	public void setDocSourceId(String docSourceId) {
		this.docSourceId = docSourceId;
	}
}
