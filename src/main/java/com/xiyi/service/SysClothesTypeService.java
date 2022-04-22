package com.xiyi.service;

import com.xiyi.domain.Clothes;
import com.xiyi.domain.ClothesType;
import com.xiyi.mapper.SysClothesTypeMapper;
import com.xiyi.service.Impservice.SysClothesTypeServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SysClothesTypeService implements SysClothesTypeServiceImp {

    @Autowired
    private SysClothesTypeMapper sysClothesTypeMapper;

    @Override
    public List<ClothesType> getTree() {
        return sysClothesTypeMapper.getTree();
    }

    @Override
    public List<Clothes> getClothes(String value,String cltCategory) {
        //判断是大类还是小类  大类1  小类2
        if (cltCategory.equals("1")){
            return sysClothesTypeMapper.getClothes(value);
        }else{
            return sysClothesTypeMapper.getClotheType(value);
        }
    }

    @Override
    public Integer addClothes(String category, String name, String parentId, String price) {
        //对新增位置进行判断  大类1  小类2     category,name,
        if (category.equals("1")){
            return sysClothesTypeMapper.addBigClothes(name, category);
        }else {
            return sysClothesTypeMapper.addSmallClothes(name, category, price,parentId);
        }

    }

    @Override
    public Integer editClothes(String category, String name, String parentId, String price) {
        //对修改位置进行判断  大类1 小类2  category,name
        if (category.equals("1")){
            // 大类 name  where clt_id = parentId
            return sysClothesTypeMapper.editBigClothes(name, category,parentId);
        }else {
            // 小类 name  where clo_id = parentId
            return sysClothesTypeMapper.editSmallClothes(name,category,price,parentId);
        }
    }

    @Override
    public Integer deleteClothes(String id,String category) {
        //判断删除的类别
        if (category.equals("1")){
            //大类  就要删除大类和关联的小类

            return sysClothesTypeMapper.deleteBigClothes(id)+sysClothesTypeMapper.deleteSmallTypeClothes(id);
        }else {
            return sysClothesTypeMapper.deleteSmallClothes(id);
        }
    }
}
