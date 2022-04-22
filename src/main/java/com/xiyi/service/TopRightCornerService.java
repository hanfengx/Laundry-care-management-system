package com.xiyi.service;

import com.xiyi.domain.Login;
import com.xiyi.mapper.TopRightCornerMapper;
import com.xiyi.service.Impservice.TopRightCornerServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TopRightCornerService implements TopRightCornerServiceImp {

    @Autowired
    private TopRightCornerMapper topRightCornerMapper;

    @Override
    public List<Login> InitializeUser() {
        return topRightCornerMapper.InitializeUser();
    }

    @Override
    public Integer topUp(String userId, String amount) {
        return topRightCornerMapper.topUp(userId, amount);
    }
}
