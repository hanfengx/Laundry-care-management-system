package com.xiyi.mapper;

import com.xiyi.domain.Question;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface QuestionMapper {

    public List<Question> Initialize(@Param("question") String question,@Param("ask") String ask);

    public Integer askQuestions(Question ques);

    public Integer addLike(@Param("num") Integer num);

    public Integer isLike(@Param("value") Integer value,
                               @Param("id") String id);

    public Integer notLike(@Param("value") Integer value,
                          @Param("id") String id);

    public Integer addAnswer(@Param("id") String id,@Param("answer") String answer);

    public Integer deleteLike(@Param("id") String id);

    public Integer deleteQuestion(@Param("id") String id);

}
