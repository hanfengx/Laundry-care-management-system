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
<div id="app" style="display: none">
    <div>
        <#--搜索框-->
        <el-form label-width="auto" :inline="true" :model="form" class="demo-form-inline">
            <el-row>
                <el-col :span="8">
                    <el-form-item label="用户名">
                        <el-input clearable v-model="form.userId" placeholder="请输入用户名"></el-input>
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
                <el-tag :style="{color:(item.loState=='0'?'#F56C6C':'#67C23A')}">{{paymentStatus(item.loState)}}</el-tag>
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
                <el-button type="success" @click="transmissionModifyState(item.loId)" round>修改状态</el-button>

            </el-descriptions-item>
        </el-descriptions>
    </div>
    <#--查看详情-->
    <div>
        <el-dialog title="查看详情" :visible.sync="checkTheDetails">
            <el-table :data="ordersGoods" border show-summary>
                <el-table-column property="goodName" label="衣服类型" width="150"></el-table-column>
                <el-table-column property="ogNum" label="数量" width="200"></el-table-column>
                <el-table-column property="ogPrice" label="价格"></el-table-column>
            </el-table>
            <div slot="footer" class="dialog-footer">
                <el-button @click="checkTheDetails = false">取 消</el-button>
                <el-button :disabled="true" type="success">{{loState=='0'?'未支付':'已支付'}}</el-button>

            </div>
        </el-dialog>
    </div>
    <#--修改状态-->
    <div>
        <el-dialog title="修改状态" :visible.sync="modifyStateVisible">
            <el-form label-width="auto" :inline="true" :model="stateForm" class="demo-form-inline">
                <el-form-item label="订单状态">
                    <el-select v-model="stateForm.value" clearable placeholder="请选择">
                        <el-option
                                v-for="item in options"
                                :key="item.value"
                                :label="item.label"
                                :value="item.value">
                        </el-option>
                    </el-select>
                </el-form-item>
                <#--modifyState(item.loId)-->
                <el-form-item >
                    <el-button  type="success" @click="modifyState(stateForm.value)">确认</el-button>
                    <el-button  type="danger" @click="modifyStateVisible=false">取消</el-button>
                </el-form-item>
            </el-form>
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
                stateForm:{
                    id:'',
                    value:''
                },
                options:[
                    {label:'正在洗衣',value:'2'},
                    {label:'已完成',value:'3'},
                ],
                modifyStateVisible:false,
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
                    userId:'',
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
            //回显支付状态
            paymentStatus(val){
                if (val == '0'){
                    return '未支付';
                }
                if (val == '1'){
                    return '已支付';
                }
                if (val == '2'){
                    return '正在洗衣';
                }
                if (val == '3'){
                    return '已完成';
                }
            },
            //传输修改状态订单id
            transmissionModifyState(id){
                var _self = this;
                _self.modifyStateVisible=true;
                _self.stateForm.id = id;
            },
            //修改状态
            modifyState(value){
                var _self = this;
                _self.stateForm.value = value;
                console.log(_self.stateForm)
                _self.$confirm('确定修改此订单状态, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    $.ajax({
                        url:'/management/updateState',
                        type:'get',
                        data:_self.stateForm,
                        dataType: 'json',
                        success:function (resp) {
                            if (resp>0){
                                _self.$message({
                                    type: 'success',
                                    message: '修改状态成功!'
                                });
                            }
                            _self.modifyStateVisible=false;
                            _self.loading=true;
                            _self.getOrder();
                            _self.loadings();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消修改'
                    });
                });


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
                    url:'/management/getOrder',
                    type:'get',
                    data:formInline,
                    dataType:'json',
                    success:function (resp){
                        _self.order = resp;
                    }
                })
            },
            loadings(){
                $('#app').css('display','block');
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