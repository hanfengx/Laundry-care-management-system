package com.xiyi.mapper;


import com.xiyi.domain.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;


@Mapper
public interface WashclothesMappers {


    public List<Activity> getActivity();

    public List<ClothesType> findAllClothesType();

    public List<ClothesType> findActivityClothesType(@Param("cloId") String cloId);

    public List<Clothes> clothesPrice(@Param("clothes") Integer clothes);

    public Integer addOder(InsertOrder order);

    Integer AddOrdersGoods(@Param("ogLoId") Integer loId,
                           @Param("ogName") String clothesType,
                           @Param("ogNum") Integer num,
                           @Param("ogPrice") Integer finalPrice);
}
