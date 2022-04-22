package com.xiyi.service.Impservice;

import com.xiyi.domain.Question;

import java.util.List;

public interface QuestionServiceImp {

    public List<Question> Initialize(String question,String ask);

    public Integer askQuestions(String question);

    public Integer whetherLike(String value,String id);

    public Integer addAnswer(String id,String answer);

    public Integer deleteQuestion(String id);

}
