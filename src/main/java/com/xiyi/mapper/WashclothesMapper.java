package com.xiyi.mapper;


import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;


@Mapper
public interface WashclothesMapper {


    public List<Activity> getActivity();


}
