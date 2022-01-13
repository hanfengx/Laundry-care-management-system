package com.xiyi.mapper;

import com.xiyi.common.PageResult;
import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import com.xiyi.domain.ClothesType;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MainActivityMapper {


    public List<Activity> allActivity(@Param("actName") String actName,
                                      @Param("region") String region,
                                      @Param("startDate") String startDate,
                                      @Param("endDate")String endDate,
                                      @Param("placeId") Integer placeId);



    public List<City> getCity();

    /*衣服类型*/
    public List<ClothesType> clothesType();

}
