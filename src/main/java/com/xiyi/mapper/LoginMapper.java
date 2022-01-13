package com.xiyi.mapper;

import com.xiyi.domain.Login;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface LoginMapper {

    public Login login(@Param("userName") String userName,@Param("userPwd") String userPwd);

    public Integer registration(@Param("userName") String userName,@Param("userPwd") String userPwd,@Param("userPermissions") String userPermissions);

}
