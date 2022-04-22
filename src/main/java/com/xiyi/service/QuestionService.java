package com.xiyi.service;

import com.xiyi.domain.Question;
import com.xiyi.mapper.QuestionMapper;
import com.xiyi.service.Impservice.QuestionServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class QuestionService implements QuestionServiceImp {

    @Autowired
    private QuestionMapper questionMapper;


    @Override
    public List<Question> Initialize(String question,String ask) {
        return questionMapper.Initialize(question, ask);
    }

    @Override
    public Integer askQuestions(String question) {
        Question ques = new Question();
        ques.setQcnName(question);
        questionMapper.askQuestions(ques);
        Integer success = questionMapper.addLike(ques.getQcnId());
        return success;
    }

    @Override
    public Integer whetherLike(String value, String id) {
        if (value.equals("1")){
            //喜欢
          return questionMapper.isLike(1,id);
        }else {
            return questionMapper.notLike(1,id);
        }
    }
}
