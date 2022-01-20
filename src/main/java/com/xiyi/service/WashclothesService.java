package com.xiyi.service;

import com.xiyi.domain.Activity;
import com.xiyi.mapper.WashclothesMapper;
import com.xiyi.service.Impservice.WashclothesServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WashclothesService implements WashclothesServiceImp {
    @Autowired
    private WashclothesMapper washclothesMapper;

    @Override
    public List<Activity> getActivity() {
        return washclothesMapper.getActivity();
    }
}
