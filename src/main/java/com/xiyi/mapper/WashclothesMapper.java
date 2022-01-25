package com.xiyi.mapper;


import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;


@Mapper
public interface WashclothesMapper {


    public List<Activity> getActivity();

    public List<City> getCity(@Param("actId") String actId);
}
