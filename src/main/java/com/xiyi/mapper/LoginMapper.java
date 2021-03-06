package com.xiyi.mapper;

import com.xiyi.domain.Login;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface LoginMapper {

    public Login login(@Param("userName") String userName,@Param("userPwd") String userPwd);

    public Integer registration(@Param("userName") String userName,@Param("userPwd") String userPwd,@Param("userPermissions") String userPermissions);

    public Integer registrationVip(@Param("userName") String userName);

    public String queryPassword(@Param("password") String password,
                                 @Param("userId") String userId);

    public Integer updatePassword(@Param("newPassword") String newPassword,
                                  @Param("userId") String userId);

}
