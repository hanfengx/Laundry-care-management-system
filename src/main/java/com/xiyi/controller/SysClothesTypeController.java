package com.xiyi.controller;

import com.xiyi.domain.Clothes;
import com.xiyi.domain.ClothesType;
import com.xiyi.service.SysClothesTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/*
* @author hanfx
* @return 管理员衣服接口
* */
@RestController
@RequestMapping("/clothesType/")
public class SysClothesTypeController {

    @Autowired
    SysClothesTypeService sysClothesTypeService;

    //初始化树形组件
    @GetMapping("getTree")
    public List<ClothesType> getTree(){

        return sysClothesTypeService.getTree();
    }

    //点击树形组件获取子节点
    @GetMapping("getClothes")
    public List<Clothes> getClothes(@RequestParam("value") String value,
                                    @RequestParam("cltCategory") String cltCategory){

        return sysClothesTypeService.getClothes(value,cltCategory);
    }

    //增加衣服  大类或小类
    @GetMapping("addClothes")
    public Integer addClothes(@RequestParam("category") String category,
                              @RequestParam("name") String name,
                              @RequestParam("parentId") String parentId,
                              @RequestParam("price") String price){

        return sysClothesTypeService.addClothes(category, name, parentId, price);
    }

    //修改衣服
    @GetMapping("editClothes")
    public Integer editClothes(@RequestParam("category") String category,
                               @RequestParam("name") String name,
                               @RequestParam("parentId") String parentId,
                               @RequestParam("price") String price){

        return sysClothesTypeService.editClothes(category, name, parentId, price);
    }

    //删除衣服
    @GetMapping("deleteClothes")
    public Integer deleteClothes(@RequestParam("id") String id,
                                 @RequestParam("category") String category){

        return sysClothesTypeService.deleteClothes(id, category);
    }

}
