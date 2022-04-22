package com.xiyi.service.Impservice;

import com.xiyi.domain.Login;

import java.util.List;

public interface TopRightCornerServiceImp {

    public List<Login> InitializeUser();

    public Integer topUp(String userId,String amount);

}
