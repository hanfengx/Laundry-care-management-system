package com.xiyi.service;

import com.xiyi.domain.Login;
import com.xiyi.mapper.LoginMapper;
import com.xiyi.service.Impservice.LoginServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LoginService implements LoginServiceImp {


    @Autowired
    private LoginMapper loginMapper;

    @Override
    public Login login(String userName, String userPwd) {
        return loginMapper.login(userName,userPwd);
    }

    @Override
    public Integer registration(String userName, String userPwd, String userPwdAgain, String userPermissions) {
        Integer reg = loginMapper.registration(userName,userPwd,userPermissions);
        //向会员表注册
        loginMapper.registrationVip(userName);
        if (userPwd.equals(userPwdAgain)){
            return reg;
        }else {
            return null;
        }

    }
}
