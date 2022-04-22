package com.xiyi.service;

import com.xiyi.domain.GiftOrders;
import com.xiyi.domain.MemberStoredValue;
import com.xiyi.domain.MembershipGift;
import com.xiyi.mapper.MemberCentreMapper;
import com.xiyi.service.Impservice.MemberCentreServiceImp;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class MemberCentreService implements MemberCentreServiceImp {

    private static String file = " ";

    @Autowired
    private MemberCentreMapper memberCentreMapper;

    @Override
    public void importImg(String encode) {
        //将图片流存入静态等待处理
        file = encode;
    }

    @Override
    public Integer insert(String name, String integral) {



        return memberCentreMapper.insert(name,integral,file);
    }

    @Override
    public List<MembershipGift> queryImage(String mgId) {

        return memberCentreMapper.queryImage(mgId);
    }

    @Override
    public List<MembershipGift> query() {

        return memberCentreMapper.query();
    }

    @Override
    public Integer deleteGift(String mgId) {
        return memberCentreMapper.deleteGift(mgId);
    }

    @Override
    public MemberStoredValue queryIntegral(String userName) {
        return memberCentreMapper.queryIntegral(userName);
    }

    @Override
    public Integer exchangeGift(String userName, Integer giftIntegral,Integer sum,String mgId) {
        //对用户进行削减积分
        Integer updateUserIntegral = memberCentreMapper.updateUserIntegral(sum,userName);
        Integer insertGiftOrders = 0;
        if (updateUserIntegral>0){
            //生成订单信息
            String randoms = randoms();
            insertGiftOrders = memberCentreMapper.insertGiftOrders(userName, randoms,mgId);
        }


        return insertGiftOrders;
    }

    @Override
    public List<GiftOrders> getGiftOrders(String userName) {
        return memberCentreMapper.getGiftOrders(userName);
    }

    @Override
    public List<GiftOrders> queryGift(String goRandom) {
        return memberCentreMapper.queryGift(goRandom);
    }

    @Override
    public Integer cashGift(String id) {

        return memberCentreMapper.cashGift(id);
    }

    //生成随机数来用于兑换奖品码
    private String randoms(){
        String random= RandomStringUtils.random(10, "abcdefghijklmnopqrstuvwxyz1234567890");
        return random;
    }



}
