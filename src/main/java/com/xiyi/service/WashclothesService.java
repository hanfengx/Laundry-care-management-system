package com.xiyi.service;

import com.xiyi.domain.*;
import com.xiyi.mapper.MainActivityMapper;
import com.xiyi.mapper.WashclothesMappers;
import com.xiyi.service.Impservice.WashclothesServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.lang.reflect.Array;
import java.util.*;

@Service
public class WashclothesService implements WashclothesServiceImp {
    @Autowired
    private WashclothesMappers washclothesMapper;

    @Autowired
    MainActivityMapper mainActivityMapper;

    @Override
    public List<Activity> getActivity() {
        return washclothesMapper.getActivity();
    }

    @Override
    public List<Map<String, Object>> getChildCity(String cityId) {
        List<City> city = mainActivityMapper.getCity();
        //创建一个List集合来存放最终的树状结构数据
        List<Map<String, Object>> menuList = new ArrayList<>();
        for (City cc:city) {
            Map<String, Object> map = new HashMap<>();
            if (cc.getId().equals(Integer.parseInt(cityId))){
                map.put("value",cc.getId());
                map.put("label",cc.getCityName());
                menuList.add(map);
                map.put("children", getChildren(city, cc.getId()));
            }
        }
        return menuList;
    }

    @Override
    public List<ClothesType> findActivityClothesType(String cloId) {
        return washclothesMapper.findActivityClothesType(cloId);
    }

    @Override
    public List<ClothesType> findAllClothesType() {

        return washclothesMapper.findAllClothesType();
    }

    /*
    * 处理订单数据
    * */
    @Override
    public Integer newOrders(Order oder) {
        /*将固定组数组转为字符串*/
        String place = Arrays.toString(oder.getPlace());

        /*根据最后一位方便查询价格*/
        Integer clothes = oder.getClothesType()[oder.getClothesType().length-1];
        /*计算固定价格*/
        List<Clothes> price = washclothesMapper.clothesPrice(clothes);
        Integer finalPrice = 0;
        for (Clothes pp:price) {
            finalPrice = Integer.parseInt(pp.getCloPrice());
        }
        /*固定组金额*/
        finalPrice = finalPrice*oder.getNum();

        /*利用遍历循环插入动态数据*/
        List<OderChild> dynamicItem = oder.getDynamicItem();
        Integer fianlMoney = 0;
        Integer finalPrices = 0;
        Integer allGroupPrices = 0;
        for (OderChild child:dynamicItem) {
            /*计算动态组价格*/
            Integer clothe = child.getClothesType()[child.getClothesType().length-1];
            List<Clothes> prices = washclothesMapper.clothesPrice(clothe);
            for (Clothes pp:prices) {
                finalPrices = Integer.parseInt(pp.getCloPrice());
            }
            /*动态组单组金额*/
            Integer groupPrices = 0;
            groupPrices = finalPrices*child.getNum();

            /*动态组总金额*/
            allGroupPrices += groupPrices;
        }
        /*计算总金额*/
        fianlMoney = allGroupPrices+finalPrice;

        /*将数据存入插入类中  方便返回主键值*/
        InsertOrder order = new InsertOrder();
        order.setLoUserId(oder.getUserName());
        order.setLoDate(oder.getDate());
        order.setLoActId(oder.getActId());
        order.setLoCityId(place);
        order.setLoAddress(oder.getAddress());
        order.setFianlMoney(fianlMoney);
        order.setLoState("0");
        order.setLoNote(oder.getNote());
        /*存入订单表*/
        Integer num = washclothesMapper.addOder(order);

        /*存入订单价格表*/
        if (num>0){
            /*将固定组数组转为字符串*/
            String clothesType = Arrays.toString(oder.getClothesType());
            /*固定组存入*/
            washclothesMapper.AddOrdersGoods(order.getLoId(),clothesType,oder.getNum(),finalPrice);

            /*动态组存入*/
            for (OderChild child:dynamicItem) {
                /*计算动态组价格*/
                Integer clothe = child.getClothesType()[child.getClothesType().length-1];
                List<Clothes> prices = washclothesMapper.clothesPrice(clothe);
                for (Clothes pp:prices) {
                    finalPrices = Integer.parseInt(pp.getCloPrice());
                }
                /*动态组单组金额*/
                Integer groupPrices = 0;
                groupPrices = finalPrices*child.getNum();
                /*将动态组数组转为字符串*/
                String clothesTypes = Arrays.toString(child.getClothesType());
                washclothesMapper.AddOrdersGoods(order.getLoId(),clothesTypes,child.getNum(),groupPrices);
            }
        }

        return num;
    }


    /**
     * 递归处理：通过id获取子级，查询子级下的子级
     *
     * @param data 数据库的原始数据
     * @param id   主id
     * @return  该id下得子级
     */
    public List<Map<String, Object>> getChildren(List<City> data, Integer id) {
        List<Map<String, Object>> list = new ArrayList<>();
        if (data == null || data.size() == 0 || id == null) {
            return list;
        }
        for (City entity : data) {
            Map<String, Object> map = new HashMap<>();
            //如果本级id与数据的父id相同，就说明是子父级关系
            if (id.equals(entity.getPId())) {
                map.put("value", entity.getId());
                map.put("label", entity.getCityName());
                //查询子级下的子级
                map.put("children", getChildren(data, entity.getId()));
                list.add(map);
            }
        }
        return list;
    }


}
