package com.xiyi.mapper;

import com.xiyi.domain.Activity;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface WashclothesMapper {

    public List<Activity> getActivity();

}


