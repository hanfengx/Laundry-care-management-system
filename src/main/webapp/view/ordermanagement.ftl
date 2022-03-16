<!DOCTYPE html>
<html lang="en">
<head>
    <#include "__ref_common_js.ftl" parse=true />
    <!-- import CSS -->
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <!-- import Vue before Element -->
    <script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>
    <!-- import JavaScript -->
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <meta charset="UTF-8">
    <title>订单</title>
</head>
<style>
    .label{
        width: 150px;
    }
    .activeNames{
        width: 120px;
    }
    .city{
        width: 250px;
    }
</style>
<body>
<div id="app" >
    <div>
        <#--搜索框-->
        <el-form label-width="auto" :inline="true" :model="form" class="demo-form-inline">
            <el-row>
                <el-col :span="8">
                    <el-form-item label="活动名称">
                        <el-input clearable v-model="form.activity" placeholder="请输入参加的活动"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="8">
                    <el-form-item  label="支付状态">
                        <el-select  clearable  v-model="form.state" placeholder="是否及时配送">
                            <el-option label="已支付" value="1"></el-option>
                            <el-option label="未支付" value="0"></el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
                <el-col :span="6">
                    <el-form-item label="订单日期">
                        <el-date-picker
                                v-model="form.date"
                                value-format="yyyy-MM-dd"
                                format="yyyy 年 MM 月 dd 日"
                                type="date"
                                placeholder="选择日期">
                        </el-date-picker>
                    </el-form-item>
                </el-col>
                <el-col :span="1">
                    <el-form-item>
                        <el-button @click="selectAll(form)" type="primary" round  icon="el-icon-search">查询</el-button>
                    </el-form-item>
                </el-col>
            </el-row>
        </el-form>
    </div>
    <div v-loading="loading">
        <el-descriptions v-for="(item) in order.slice((query.currentPage-1)*(query.pageSize),query.currentPage*(query.pageSize))" style="margin-top: 10px" class="margin-top"  :column="3"  border>
            <el-descriptions-item content-class-name="activeNames" label-class-name="label">
                <template slot="label">
                    <i class="el-icon-s-finance"></i>
                    活动名称
                </template>
                {{item.activity?item.activity.actName:'未参加活动'}}
            </el-descriptions-item>
            <el-descriptions-item content-class-name="city" label-class-name="label">
                <template slot="label">
                    <i class="el-icon-location-outline"></i>
                    配送区域
                </template>
                {{item.cityName}}
            </el-descriptions-item>
            <el-descriptions-item label-class-name="label">
                <template slot="label">
                    <i class="el-icon-date"></i>
                    订单时间
                </template>
                {{item.loDate}}
            </el-descriptions-item>
            <el-descriptions-item label-class-name="label">
                <template slot="label">
                    <i class="el-icon-bicycle"></i>
                    支付状态
                </template>
                <el-tag :style="{color:(item.loState=='0'?'#F56C6C':'#67C23A')}">{{item.loState=='0'?'待付款':'已支付'}}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item label-class-name="label">
                <template slot="label">
                    <i class="el-icon-map-location"></i>
                    详细地址
                </template>
                {{item.loAddress}}
            </el-descriptions-item>
            <el-descriptions-item label-class-name="label">
                <template slot="label">
                    <i class="el-icon-set-up"></i>
                    操作
                </template>
                <el-button type="primary" @click="checkTheDetail(item.ordersGoods,item.loState)" round>查看详情</el-button>
                <el-button type="info" :disabled="item.loState=='0'?false:true" round @click="editOrder(item.actCityId,item.loId,item.loCityId,item.loAddress)" >修改地址</el-button>
                <el-button type="danger" :disabled="item.loState=='0'?false:true" @click="deleteOrder(item.loId)" round>删除订单</el-button>
            </el-descriptions-item>
        </el-descriptions>
    </div>

    <div>
        <el-dialog title="查看详情" :visible.sync="checkTheDetails">
            <el-table :data="ordersGoods" border show-summary>
                <el-table-column property="goodName" label="衣服类型" width="150"></el-table-column>
                <el-table-column property="ogNum" label="数量" width="200"></el-table-column>
                <el-table-column property="ogPrice" label="价格"></el-table-column>
            </el-table>
            <div slot="footer" class="dialog-footer">
                <el-button @click="checkTheDetails = false">取 消</el-button>
                <el-button :disabled="loState=='0'?false:true" type="success" @click="pay(ordersGoods)">{{loState=='0'?'支 付':'已支付'}}</el-button>

            </div>
        </el-dialog>
    </div>

    <#--修改-->
    <div>
        <el-dialog title="修改订单" :visible.sync="ChangeOrder">
            <el-form ref="form" label-width="100px" :model="form">
                <el-form-item label="所在城市">
                    <el-cascader
                            :props="{ checkStrictly: true }"
                            v-model="form.orderCity"
                            :options="citys"
                            clearable
                            placeholder="请选择城市"
                            filterable
                            :show-all-levels="false"></el-cascader>
                </el-form-item>
                <el-form-item label="详细地址">
                    <el-input v-model="form.orderPlace"></el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="ChangeOrder = false">取 消</el-button>
                <el-button type="success" @click="revise(form)">确定修改</el-button>

            </div>
        </el-dialog>
    </div>
    <div>
        <el-pagination
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                :current-page.sync="query.currentPage"
                :page-sizes="[5, 10, 15, 20]"
                :page-size="query.pageSize"
                layout="total, sizes, prev, pager, next, jumper"
                :total="order.length">
        </el-pagination>
    </div>
</div>
</body>
<script>
    var userName = '${userName}';

    var vm = new Vue({
        el: '#app',
        data: function() {
            return {
                ChangeOrder:false,
                operateDisable:false,
                checkTheDetails:false,
                query: {
                    currentPage: 1,
                    pageSize: 5,
                },
                loading:true,
                userId:userName,
                order:[],
                ordersGoods:[],
                form:{
                    activity:'',
                    date:'',
                    state:''
                },
                loState:'',
                citys:[],
                form:{
                    loId:'',
                    orderCity:[],
                    orderPlace:''

                },

            }
        },
        methods:{
            //删除订单
            deleteOrder(loId){
                var _self = this;
                $.ajax({
                    url:'/management/deleteOrder?loId='+loId,
                    type:'get',
                    dataType:'json',
                    success:function (resp){
                        if (resp>0){
                            _self.$message({
                                message: '删除成功！',
                                type: 'success'
                            });
                            _self.loading=true;
                            _self.getOrder();
                            _self.loadings();
                        }else {
                            _self.$message.error('删除失败');
                        }
                    }
                })
            },
            //确定修改
            revise(form){
                var _self = this;
                $.ajax({
                    url : '/management/revise',
                    type : 'post',
                    data: form,
                    dataType: 'json',
                    success:function (resp) {
                        if (resp>0){
                            _self.$message({
                                message: '修改成功！',
                                type: 'success'
                            });
                            _self.ChangeOrder = false;
                            _self.loading=true;
                            _self.getOrder();
                            _self.loadings();

                        }else {
                            _self.$message.error('修改失败');
                        }
                    }
                })
            },
            //修改地址页面回显
            editOrder(actCityId,loId,loCityId,loAddress){
                var _self = this;
                _self.ChangeOrder = true;
                var loCityArr = loCityId.replace("[","").replace("]","").replace(/\s*/g,"").split(',');
                _self.form.orderPlace = loAddress;
                //回显订单城市
                _self.form.orderCity = [];
                loCityArr.forEach(function(data,index,arr){
                    _self.form.orderCity.push(+data);
                });
                _self.form.loId = loId;
                if (actCityId!=null){
                    //回显该活动城市
                    $.ajax({
                        url:'/washclothes/getChildCity?cityId='+actCityId,
                        type:'get',
                        dataType:'json',
                        success:function (resp) {
                            _self.citys = _self.getTreeData(resp);
                        }
                    })

                }else {
                    //回显所有城市
                    $.ajax({
                        url:'/main/city',
                        type:'get',
                        dataType:'json',
                        success:function (resp) {
                            _self.citys = _self.getTreeData(resp);
                        }
                    })
                }

            },
            // 递归方法  去除chilren的空数组
            getTreeData(data){
                // 循环遍历json数据
                for(var i=0;i<data.length;i++){
                    if (data[i].children){
                        if(data[i].children.length<1){
                            // children若为空数组，则将children设为undefined
                            data[i].children=undefined;
                        }else {
                            // children若不为空数组，则继续 递归调用 本方法
                            this.getTreeData(data[i].children);
                        }
                    }
                }
                return data;
            },
            //支付功能
            pay(ordersGoods){
                var _self = this;
                _self.checkTheDetails = true;
                var ordersGoods = ordersGoods;
                var num = 0;
                var price = 0;
                var sum = 0;
                for (var ordersGoodsKey in ordersGoods) {
                    num = parseFloat(ordersGoods[ordersGoodsKey].ogNum);
                    price = parseFloat(ordersGoods[ordersGoodsKey].ogPrice);
                    sum += num*price;
                }

                //支付
                var pay = {
                    sum:sum,
                    userId:userName,
                    loId:ordersGoods[0].ogLoId
                }
                $.ajax({
                    url:'/management/pay',
                    type:'get',
                    data:pay,
                    dataType: 'json',
                    success:function (resp) {
                        if (resp>0){
                            _self.$message({
                                message: '支付成功！',
                                type: 'success'
                            });
                            _self.checkTheDetails=false;
                            _self.loading=true;
                            _self.getOrder();
                            _self.loadings();
                        }else {
                            _self.$message.error('支付失败！余额不足');
                        }
                    }
                })
            },
            //查看详情
            checkTheDetail(ordersGoods,loState){
                var _self = this;
                _self.operateDisable=false;
                _self.checkTheDetails = true;
                _self.ordersGoods = ordersGoods;
                for (var ordersGoodsKey in _self.ordersGoods) {
                    _self.ordersGoods[ordersGoodsKey].sum = 0;
                    _self.ordersGoods[ordersGoodsKey].sum = parseFloat(_self.ordersGoods[ordersGoodsKey].ogPrice)*parseFloat(_self.ordersGoods[ordersGoodsKey].ogNum);
                }
                _self.loState = loState;
            },
            //查询
            selectAll(form){
                var _self = this;
                this.loading = true;
                this.loadings();
                var formInline = this.form;
                this.getOrder(formInline);
            },
            //前端分页
            handleSizeChange(val) {
                this.query.pageSize = val;
                this.loading=true;
                this.getOrder();
                this.loadings();
            },
            handleCurrentChange(val) {
                this.query.currentPage = val
                this.loading=true;
                this.getOrder();
                this.loadings();
            },
            //订单回显
            getOrder(formInline){
              var _self = this;
              var userId = _self.userId;
              $.ajax({
                  url:'/management/getOrder?userId='+userId,
                  type:'get',
                  data:formInline,
                  dataType:'json',
                  success:function (resp){
                      _self.order = resp;
                  }
              })
            },
            loadings(){
                setTimeout(() => {
                    this.loading = false;
                }, 1000);
            }
        },
        created(){
            this.loadings();
            this.getOrder();
        }
    })
</script>
</html>