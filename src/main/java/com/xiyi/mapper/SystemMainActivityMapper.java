package com.xiyi.mapper;

import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SystemMainActivityMapper {
    public Integer addAct(@Param("actName") String actName,
                          @Param("startDate") String startDate,
                          @Param("endDate") String endDate,
                          @Param("placeId") int placeId,
                          @Param("actRegion") String actRegion,
                          @Param("actContent")String actContent,
                          @Param("userName")String userName,
                          @Param("actDiscount") String actDiscount);

    public Integer online(@Param("actId") String actId);

    public Integer offline(@Param("actId") String actId);

    public Integer delete(@Param("actId") String actId);

    public List<Activity> queryOne(@Param("actId") String actId);

    public Integer setAct(@Param("actId") int actId,
                          @Param("actName") String actName,
                          @Param("startDate") String startDate,
                          @Param("endDate") String endDate,
                          @Param("placeId") int placeId,
                          @Param("actRegion") String actRegion,
                          @Param("actContent")String actContent,
                          @Param("userName")String userName,
                          @Param("actDiscount")String actDiscount);

    public City getOneCity(@Param("cityId") String cityId);

}
