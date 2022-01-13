package com.xiyi.service.Impservice;

import com.xiyi.domain.Login;

public interface LoginServiceImp {


    public Login login(String userName,String userPwd);

    public Integer registration(String userName,String userPwd,String userPwdAgain,String userPermissions);

}
