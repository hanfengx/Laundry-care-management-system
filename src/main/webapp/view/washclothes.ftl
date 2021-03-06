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
    <title>订单页面</title>
</head>
<style>
    .el-form{
        margin-left: 120px;
    }

</style>
<body>
    <div id="app" v-loading="loading" >
        <div style="background-color: white;width: 1450px">
            <div style="height: 10px"></div>
            <el-form  :rules="rules" ref="form" label-width="100px" :model="form" >
                <el-row>
                    <el-col :span="8">
                        <el-form-item prop="actId"  label="活动名称">
                            <el-select
                                    @clear="setValueNull()"
                                    v-model="form.actId"
                                    clearable
                                    filterable>
                                <el-option
                                        v-for="item in actOptions"
                                        :label="item.actName"
                                        :value="item.actId"
                                        @click.native='option(item.actPlace,item.actScope,item.actDiscount)'>
                                </el-option>
                            </el-select>
                        </el-form-item>
                    </el-col>
                    <el-col :span="8">
                        <el-form-item prop="place" label="活动地点">
                            <el-cascader
                                    :props="{ checkStrictly: true }"
                                    v-model="form.place"
                                    :key="optionsKey"
                                    :options="options"
                                    clearable
                                    placeholder="请选择活动地点"
                                    filterable
                                    :show-all-levels="false"></el-cascader>
                        </el-form-item>
                    </el-col>
                </el-row>
                <#--第二排-->
                <el-row>
                    <el-col :span="8">
                        <el-form-item prop="date" label="配送时间">
                            <el-col :span="9">
                                <el-date-picker
                                        type="date"
                                        placeholder="选择日期"
                                        v-model="form.date"
                                        style="width: 100%;"
                                        format="yyyy 年 MM 月 dd 日"
                                        :picker-options="pickerOption"
                                        value-format="yyyy-MM-dd"></el-date-picker>
                            </el-col>
                        </el-form-item>
                    </el-col>
                    <el-col :span="8">
                        <el-form-item prop="delivery"  label="即时配送">
                            <el-switch v-model="form.delivery"></el-switch>
                        </el-form-item>
                    </el-col>

                </el-row>
                <#--第三排-->
                <el-row>
                    <el-col :span="8">
                        <el-form-item prop="address" label="详细地址">
                            <el-input
                                    type="textarea"
                                    resize="none"
                                    autosize
                                    placeholder="请输入详细地址"
                                    v-model="form.address">
                            </el-input>
                        </el-form-item>
                    </el-col>
                </el-row>
                <#--第四排-->
                <el-row>
                    <el-col :span="8">
                        <el-form-item prop="clothesType" label="衣服类型">
                            <el-cascader
                                    v-model="form.clothesType"
                                    :options="clothesOptions"
                                    :key="optionsKey"
                                    clearable
                                    placeholder="请选择衣服种类"
                                    filterable
                                    :show-all-levels="false"></el-cascader>
                        </el-form-item>
                    </el-col>
                    <el-col :span="4">
                        <el-form-item prop="num" label="衣服数量">
                            <el-input clearable v-model="form.num" placeholder="请输入数量"></el-input>

                        </el-form-item>
                    </el-col>
                </el-row>

                <#--动态排-->
                <el-row v-for="(item, index) in form.dynamicItem" :key="index">
                    <el-col :span="8">
                        <el-form-item prop="clothesType"  label="衣服类型">
                            <el-cascader
                                    v-model="item.clothesType"
                                    :options="clothesOptions"
                                    :key="optionsKey"
                                    clearable
                                    placeholder="请选择衣服种类"
                                    filterable
                                    :show-all-levels="false"></el-cascader>
                        </el-form-item>
                    </el-col>
                    <el-col :span="4">
                        <el-form-item prop="num" label="衣服数量">
                            <el-input clearable v-model="item.num" placeholder="请输入数量"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="4">
                        <el-form-item>
                            <i style="cursor: pointer" class="el-icon-delete" @click="deleteItem(item, index)"></i>
                        </el-form-item>
                    </el-col>
                </el-row>
                <#--第五排-->
                <el-row>
                    <el-col :span="8">
                        <el-form-item>
                            <el-button @click="addItem" size="mini" type="primary" round>添加衣服</el-button>
                        </el-form-item>
                    </el-col>
                </el-row>
                <#--最后一排-->
                <el-row>
                    <el-col :span="8">
                        <el-form-item>
                            <el-button type="success" @click="onSubmit('form')" round>创建订单</el-button>
                            <el-button type="primary" @click="formReset('form')" round >重置</el-button>
                        </el-form-item>
                    </el-col>
                </el-row>
                </el-form>
        </div>
    </div>
</body>
<script>
    var userName = '${userName}';
    var actId = '${actId}';
    var vm = new Vue({
        el: '#app',
        data: function() {
            return {
                pickerOption:{
                    disabledDate(time){
                        return  time.getTime() < (Date.now() - (24 * 60 * 60 * 1000))
                    },
                },
                loading:true,
                clothesOptions:[],
                optionsKey:1,
                options:[],
                actId:actId,
                actOptions:[],
                form: {
                    actDiscount:'',
                    address:'',
                    userName:userName,
                    dynamicItem:[],
                    place:[],
                    date: '',
                    delivery: false,
                    num:''
                },
                rules:{
                    place: [
                        {required: true, message: '请选择活动地点', trigger: 'blur'}
                    ],
                    date:[
                        {required: true, message: '请选择配送时间', trigger: 'blur'}
                    ],
                    clothesType:[
                        {required: true, message: '请选择衣服类型', trigger: 'blur'}
                    ],
                    num:[
                        {required: true, message: '请输入数量', trigger: 'blur'}
                    ],
                    address:[
                        {required: true, message: '请输入详细地址', trigger: 'blur'}
                    ]

                }
            }
        },
        methods:{

            loadings(){
                setTimeout(() => {
                    this.loading = false;
                }, 1000);
            },
            /*表单重置*/
            formReset(formName){
                this.$refs[formName].resetFields();
            },
            /*动态删除衣服*/
            deleteItem (item, index) {
                this.form.dynamicItem.splice(index, 1)
            },
            /*动态增加衣服*/
            addItem(){
                this.form.dynamicItem.push({
                    clothesType: '',
                    num: ''
                })
            },
            /*活动清除事件*/
            setValueNull(){
                var _self = this;
                /*如果不选活动  cityId=null  选择全国城市*/
                _self.options=[];
                ++_self.optionsKey;
                $.ajax({
                    url: "/main/city",
                    type:'get',
                    dataType: "json",
                    success:function (resp){
                        _self.options = _self.getTreeData(resp);

                    }
                })

                $.ajax({
                    type:'get',
                    dataType: "json",
                    url:'/washclothes/findAllClothesType',
                    success:function (resp){
                        _self.clothesOptions = _self.getTreeData(resp);
                    }
                })
            },
            option(cityId,cloId,actDiscount){
                var _self = this;
                _self.form.actDiscount = actDiscount;
                /*cityId!=null 选择活动所在的城市*/
                _self.options=[];
                ++_self.optionsKey;
                $.ajax({
                    type:'get',
                    dataType: "json",
                    url:'/washclothes/getChildCity?cityId='+cityId,
                    success:function (resp){
                        _self.options = _self.getTreeData(resp);
                    }
                })

                /*衣服的详细分类*/
                $.ajax({
                    type:'get',
                    dataType: "json",
                    url:'/washclothes/findActivityClothesType?cloId='+cloId,
                    success:function (resp){
                        _self.clothesOptions = _self.getTreeData(resp);
                    }
                })

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
            /*活动名称下拉框*/
            selectAct(){
                var _self = this;
                $.ajax({
                    url: '/washclothes/getActivity',
                    type: 'get',
                    dataType: "json",
                    success: function (resp) {
                        _self.actOptions = resp;
                    }

                })
            },
            //提交订单
            onSubmit(formName) {
                var _self = this;
                var form = _self.form;
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        $.ajax({
                            url: '/washclothes/newOrders',
                            data:JSON.stringify(form),
                            type: 'post',
                            contentType: "application/json;charset=UTF-8",
                            dataType: "json",
                            success: function (resp) {
                                if (resp>0){
                                    _self.$message({
                                        message: '创建成功请转到订单管理支付！',
                                        type: 'success'
                                    });
                                }else {
                                    _self.$message({
                                        message: '出错了！请联系管理员！',
                                        type: 'warning'
                                    });
                                }
                            }

                        })
                    } else {
                        _self.$message({
                            message: '订单不完整，请填写完整！',
                            type: 'warning'
                        });
                        return false;
                    }
                });

            }
        },
        created(){
            this.selectAct();
            this.setValueNull();
            this.loadings();

        }
    })
</script>
</html>