package com.xiyi.service.Impservice;

import com.xiyi.domain.GiftOrders;
import com.xiyi.domain.MemberStoredValue;
import com.xiyi.domain.MembershipGift;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface MemberCentreServiceImp {


    public void importImg(String encode);


    public Integer insert(String name,String integral);

    public List<MembershipGift> queryImage(String mgId);


    public List<MembershipGift> query();

    public Integer deleteGift(String mgId);

    public MemberStoredValue queryIntegral(String userName);

    public Integer exchangeGift(String userName,Integer giftIntegral,Integer sum,String mgId);

    public List<GiftOrders> getGiftOrders(String userName);

    public List<GiftOrders> queryGift(String goRandom);

    public Integer cashGift(String id);

}
