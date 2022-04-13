package com.xiyi.service.Impservice;

import com.xiyi.domain.Clothes;
import com.xiyi.domain.ClothesType;

import java.util.List;

public interface SysClothesTypeServiceImp {

    public List<ClothesType> getTree();

    public List<Clothes> getClothes(String value,String cltCategory);

    public Integer addClothes(String category,String name,String parentId,String price);

    public Integer editClothes(String category,String name,String parentId,String price);


    public Integer deleteClothes(String id,String category);

}
