package com.landray.kmss.constant;

public interface SysDocConstant {
    /**
     * 文档状态：废弃<br>
     * 该状态的文档为提交到审批流程中，但审批未通过且不再需要使用该文档
     */
    public static final String DOC_STATUS_DISCARD = "00";

    /**
     * 文档状态：草稿<br>
     * 该状态的文档为初拟但未提交到审批流程中
     */
    public static final String DOC_STATUS_DRAFT = "10";

    /**
     * 文档状态：审批中<br>
     * 该状态的文档为已提交，进行审批流程中
     */
    public static final String DOC_STATUS_EXAMINE = "20";
    
    /**
     * 文档状态：审批驳回<br>
     * 该状态的文档为进行审批流程后，审批未通过，文档需要重新修改
     */
    public static final String DOC_STATUS_REFUSE = "11";

    /**
     * 文档状态：发布<br>
     * 该状态的文档为审批通过后发布的状态
     */
    public static final String DOC_STATUS_PUBLISH = "30";
    
    /**
     * 文档状态：过期<br>
     * 该状态的文档为已发布，但文档的有效期限已经超出指定的时间
     */
    public static final String DOC_STATUS_EXPIRE = "40";


}
