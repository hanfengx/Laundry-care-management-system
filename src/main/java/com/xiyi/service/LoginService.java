package com.xiyi.service;

import com.xiyi.domain.Login;
import com.xiyi.mapper.LoginMapper;
import com.xiyi.service.Impservice.LoginServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

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

    @Override
    public Map<String,Object> changePassword(String password, String newPassword, String newAgainPassword,String userId) {
        Map<String, Object> map = new HashMap<>();
        //先校验原来的密码是否有问题
        String userName = loginMapper.queryPassword(password,userId);
        if (userName!=null){
            //校验两次密码是否一致
            if (newPassword.equals(newAgainPassword)){
                //存入新密码
                Integer update = loginMapper.updatePassword(newPassword, userId);
                if (update>0){
                    map.put("msg","修改成功");
                    map.put("code","200");
                }else {
                    map.put("msg","修改失败");
                    map.put("code","500");
                }
            }else {
                map.put("msg","两次密码不一致");
                map.put("code","500");
            }
        }else {
            map.put("msg","原密码错误");
            map.put("code","500");
        }
        return map;
    }
}
