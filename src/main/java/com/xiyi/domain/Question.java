package com.xiyi.domain;

import lombok.Data;

import java.util.List;

@Data
public class Question {

    private Integer qcnId;

    private String qcnName;

    private String qcnAsk;

    private QuestionLike questionLike;

}
