package com.xiyi.service.Impservice;

import com.xiyi.domain.Login;

import java.util.Map;

public interface LoginServiceImp {


    public Login login(String userName,String userPwd);

    public Integer registration(String userName,String userPwd,String userPwdAgain,String userPermissions);

    public Map<String,Object> changePassword(String password, String newPassword, String newAgainPassword,String userId);


}
