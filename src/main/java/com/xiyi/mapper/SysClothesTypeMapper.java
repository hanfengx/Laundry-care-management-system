package com.xiyi.mapper;

import com.xiyi.domain.Clothes;
import com.xiyi.domain.ClothesType;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SysClothesTypeMapper {

    public List<ClothesType> getTree();

    public List<Clothes> getClothes(@Param("value") String value);

    public List<Clothes> getClotheType(@Param("value") String value);

    public Integer addBigClothes(@Param("name") String name,
                                 @Param("category") String category);

    public Integer addSmallClothes(@Param("name") String name,
                                   @Param("category") String category,
                                   @Param("price") String price,
                                   @Param("parentId") String parentId);

    public Integer editBigClothes(@Param("name") String name,
                                 @Param("category") String category,
                                  @Param("parentId") String parentId);

    public Integer editSmallClothes(@Param("name") String name,
                                   @Param("category") String category,
                                   @Param("price") String price,
                                   @Param("parentId") String parentId);



    public Integer deleteBigClothes(@Param("id") String id);

    public Integer deleteSmallClothes(@Param("id")String id);

    public Integer deleteSmallTypeClothes(@Param("id")String id);

}
