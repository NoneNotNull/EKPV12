package com.landray.kmss.kms.multidoc.model;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.multidoc.forms.KmsMultidocKnowledgeForm;
import com.landray.kmss.plugins.interfaces.IKmCkoModifyLogModel;
import com.landray.kmss.sys.attachment.model.IAttachment;
import com.landray.kmss.sys.bookmark.interfaces.ISysBookmarkModel;
import com.landray.kmss.sys.edition.interfaces.ISysEditionAutoDeleteModel;
import com.landray.kmss.sys.evaluation.interfaces.ISysEvaluationCountModel;
import com.landray.kmss.sys.evaluation.interfaces.ISysEvaluationModel;
import com.landray.kmss.sys.evaluation.interfaces.ISysEvaluationNotesContent;
import com.landray.kmss.sys.evaluation.interfaces.ISysEvaluationNotesModel;
import com.landray.kmss.sys.introduce.interfaces.ISysIntroduceCountModel;
import com.landray.kmss.sys.introduce.interfaces.ISysIntroduceModel;
import com.landray.kmss.sys.readlog.interfaces.ISysReadLogAutoSaveModel;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainModel;
import com.landray.kmss.sys.tag.interfaces.ISysTagMainModel;
import com.landray.kmss.sys.tag.model.SysTagMain;
import com.landray.kmss.sys.workflow.interfaces.ISysWfMainModel;
import com.landray.kmss.sys.workflow.interfaces.SysWfBusinessModel;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖 知识库文档
 */
public class KmsMultidocKnowledge extends KmsKnowledgeBaseDoc implements
		ISysEvaluationModel, ISysIntroduceModel, ISysReadLogAutoSaveModel,
		ISysWfMainModel, ISysRelationMainModel, ISysEditionAutoDeleteModel,
		IAttachment, IKmCkoModifyLogModel, ISysBookmarkModel,
		ISysTagMainModel, ISysEvaluationCountModel,
		ISysIntroduceCountModel, InterceptFieldEnabled, 
		ISysEvaluationNotesContent, ISysEvaluationNotesModel{

	private static final long serialVersionUID = 8942501479306050996L;

	public KmsMultidocKnowledge() {
		super();
		setDocType("com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge");
	}

	/*
	 * 主表ID
	 */
	protected String fdModelId = null;
	/*
	 * 主表域模型
	 */
	protected String fdModelName = null;
	protected String fdWorkId = null;
	protected String fdPhaseId = null;

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
	 * @deprecated 请调用getDocCategory
	 * @return
	 */
	public KmsKnowledgeCategory getKmsMultidocTemplate() {
		return this.docCategory;
	}

	/**
	 * @deprecated 请调用setDocCategory
	 */
	public void setKmsMultidocTemplate(IBaseModel model) {
		this.docCategory = (KmsKnowledgeCategory) model;
	}

	private String fdImportInfo;

	public String getFdImportInfo() {
		return fdImportInfo;
	}

	public void setFdImportInfo(String fdImportInfo) {
		this.fdImportInfo = fdImportInfo;
	}

	/**
	 * 文件编号
	 */
	protected String fdNumber;

	public String getFdNumber() {
		return fdNumber;
	}

	public void setFdNumber(String fdNumber) {
		this.fdNumber = fdNumber;
	}

	public Class getFormClass() {
		return KmsMultidocKnowledgeForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
		}
		return toFormPropertyMap;
	}

	/*
	 * 流程机制
	 */
	private SysWfBusinessModel sysWfBusinessModel = new SysWfBusinessModel();

	public SysWfBusinessModel getSysWfBusinessModel() {
		return sysWfBusinessModel;
	}

	// *********************收藏机制(开始)***********************//

	private Integer docMarkCount = Integer.valueOf(0);

	public Integer getDocMarkCount() {
		return docMarkCount;
	}

	public void setDocMarkCount(Integer count) {
		this.docMarkCount = count;
	}

	// *********************收藏机制(结束)***********************//
	
	// ===========标签机制开始=========
	private SysTagMain sysTagMain = null;

	public SysTagMain getSysTagMain() {

		return sysTagMain;
	}

	public void setSysTagMain(SysTagMain sysTagMain) {
		this.sysTagMain = sysTagMain;
	}

	// ==============标签机制结束========

	// ====评分 ===
	protected Double docScore;

	public Double getDocScore() {
		return docScore;
	}

	public void setDocScore(Double docScore) {
		this.docScore = docScore;
	}

	/*
	 * 附件路径（导入用到）
	 */
	private String attPath;

	public String getAttPath() {
		return attPath;
	}

	public void setAttPath(String attPath) {
		this.attPath = attPath;
	}

	/*
	 * 属性（导入用到）
	 */
	private String extendData;

	public String getExtendData() {
		return extendData;
	}

	public void setExtendData(String extendData) {
		this.extendData = extendData;
	}

	/*
	 * 标签（导入用到）
	 */
	private String tags;

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

	/*
	 * 作者（导入用到）
	 */
	private String authorName;

	public String getAuthorName() {
		return authorName;
	}

	public void setAuthorName(String authorName) {
		this.authorName = authorName;
	}

	// **********KMS文档知识库知识文档是否处理完成 开始* **********

	// 1:结束 0：未结束
	private String fdWorkStatus = "0";

	public String getFdWorkStatus() {
		// 若是KMS文档知识库 则一旦发布，可将工作项设置为完成状态
		if (SysDocConstant.DOC_STATUS_PUBLISH.equals(docStatus)) {
			fdWorkStatus = "1";
		}
		return fdWorkStatus;
	}

	public void setFdWorkStatus(String fdWorkStatus) {
		this.fdWorkStatus = fdWorkStatus;
	}

	// **********KMS文档知识库知识文档是否处理完成 结束* **********

	private String docSourceId = null ;

	public String getDocSourceId() {
		return docSourceId;
	}

	public void setDocSourceId(String docSourceId) {
		this.docSourceId = docSourceId;
	}
}
