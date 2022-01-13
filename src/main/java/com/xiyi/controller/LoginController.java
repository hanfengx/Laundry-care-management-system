package com.xiyi.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.xiyi.domain.Login;
import com.xiyi.service.Impservice.LoginServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@RestController
@RequestMapping("/laundry/")
public class LoginController {

    @Autowired
    private LoginServiceImp loginServiceImp;

    /*登录*/
    @PostMapping("login")
    public  Login login(@RequestParam("userName") String userName, @RequestParam("userPwd") String userPwd, ServletRequest req){
        Login login = loginServiceImp.login(userName,userPwd);
        HttpServletRequest request = (HttpServletRequest) req;
        HttpSession session = request.getSession(true);
        if (login.getUserName()!=null){
            session.setAttribute("uname",login.getUserName());
        }
        return login;
    }
    /*注册*/
    @PostMapping("registration")
    public  Integer registration(@RequestParam("userName") String userName,
                               @RequestParam("userPwd") String userPwd,
                               @RequestParam("userPwdAgain") String userPwdAgain,
                               @RequestParam(value = "userPermissions",required = false,defaultValue = "0")  String userPermissions){
        Integer reg = loginServiceImp.registration(userName,userPwd,userPwdAgain,userPermissions);
        return reg;
    }

}
