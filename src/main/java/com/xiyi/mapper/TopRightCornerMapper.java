package com.xiyi.mapper;

import com.xiyi.domain.Login;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface TopRightCornerMapper {

    public List<Login> InitializeUser();

    public Integer topUp(@Param("userId") String userId,
                         @Param("amount") String amount);

}
