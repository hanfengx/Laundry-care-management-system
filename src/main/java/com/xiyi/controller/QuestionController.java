package com.xiyi.controller;

import com.xiyi.domain.Question;
import com.xiyi.service.Impservice.QuestionServiceImp;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/*
* @author hanfx
* 常见问题
* */
@RestController
@Slf4j
@RequestMapping("/question/")
public class QuestionController {

    @Autowired
    private QuestionServiceImp questionServiceImp;

    //初始化页面和查询
    @GetMapping("query")
    public List<Question> Initialize(@RequestParam(value = "question",required = false,defaultValue = "") String question,
                                     @RequestParam(value = "answer",required = false,defaultValue = "") String ask){


        return questionServiceImp.Initialize(question,ask);
    }

    // 提问
    @PostMapping("askQuestions")
    public Integer askQuestions(@RequestParam("name") String question){

        return questionServiceImp.askQuestions(question);
    }

    //点赞或者点踩
    @GetMapping("whetherLike")
    public Integer whetherLike(@RequestParam("value") String value,
                               @RequestParam("id") String id){


        return questionServiceImp.whetherLike(value, id);
    }

    //新增回答
    @PostMapping("addAnswer")
    public Integer addAnswer(@RequestParam("id") String id,
                             @RequestParam("name") String answer){

        return questionServiceImp.addAnswer(id, answer);
    }

    //删除问题
    @GetMapping("deleteQuestion")
    public Integer deleteQuestion(@RequestParam("id") String id){

        return questionServiceImp.deleteQuestion(id);
    }

}
