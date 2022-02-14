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
    <title></title>
</head>
<style>
    .el-form{
        margin-left: 120px;
    }
</style>
<body>
    <div id="app" >
        <div style="background-color: white;height: 520px;width: 1450px">
            <div style="height: 10px"></div>
            <el-form ref="form" label-width="100px" :model="form" >
                <el-row>
                    <el-col :span="8">
                        <el-form-item  label="活动名称">
                            <el-select
                                    @clear="setValueNull()"
                                    v-model="actOptions.actId"
                                    clearable
                                    filterable>
                                <el-option
                                        v-for="item in actOptions"
                                        :label="item.actName"
                                        :value="item.actId"
                                        @click.native='option(item.actPlace,item.actScope)'>
                                </el-option>
                            </el-select>
                        </el-form-item>
                    </el-col>
                    <el-col :span="8">
                        <el-form-item label="活动地点">
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
                        <el-form-item label="配送时间">
                            <el-col :span="9">
                                <el-date-picker
                                        type="date"
                                        placeholder="选择日期"
                                        v-model="form.date"
                                        style="width: 100%;"
                                        format="yyyy 年 MM 月 dd 日"
                                        value-format="yyyy-MM-dd"></el-date-picker>
                            </el-col>
                        </el-form-item>
                    </el-col>
                    <el-col :span="8">
                        <el-form-item label="即时配送">
                            <el-switch v-model="form.delivery"></el-switch>
                        </el-form-item>
                    </el-col>

                </el-row>
                <#--第三排-->
                <el-row>
                    <el-col :span="8">
                        <el-form-item label="衣服类型">
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
                        <el-form-item label="衣服数量">
                            <el-input clearable v-model="form.num" placeholder="请输入数量"></el-input>

                        </el-form-item>
                    </el-col>
                </el-row>
                <#--动态排-->
                <el-row v-for="(item, index) in form.dynamicItem" :key="index">
                    <el-col :span="8">
                        <el-form-item label="衣服类型">
                            <el-cascader
                                    v-model="item.value"
                                    :options="clothesOptions"
                                    :key="optionsKey"
                                    clearable
                                    placeholder="请选择衣服种类"
                                    filterable
                                    :show-all-levels="false"></el-cascader>
                        </el-form-item>
                    </el-col>
                    <el-col :span="4">
                        <el-form-item label="衣服数量">
                            <el-input clearable v-model="item.num" placeholder="请输入数量"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="4">
                        <el-form-item>
                            <i style="cursor: pointer" class="el-icon-delete" @click="deleteItem(item, index)"></i>
                        </el-form-item>
                    </el-col>
                </el-row>
                <#--第四排-->
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
                            <el-button type="success" @click="onSubmit" round>立即创建</el-button>
                            <el-button>取消</el-button>
                        </el-form-item>
                    </el-col>
                </el-row>
                </el-form>
        </div>
    </div>
</body>
<script>
    var vm = new Vue({
        el: '#app',
        data: function() {
            return {
                clothesOptions:[],
                optionsKey:1,
                options:[],
                actOptions:[],
                form: {
                    dynamicItem:[],
                    placeChild:[],
                    place:[],
                    name: '',
                    region: '',
                    date: '',
                    delivery: false,
                    num:''
                }
            }
        },
        methods:{


            /*动态删除衣服*/
            deleteItem (item, index) {
                this.form.dynamicItem.splice(index, 1)
            },
            /*动态增加衣服*/
            addItem(){
                this.form.dynamicItem.push({
                    place: '',
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
            option(cityId,cloId){
                var _self = this;
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
            onSubmit() {
                var _self = this;
                console.log(_self.form)
            }
        },
        created(){
            this.selectAct();
            this.setValueNull();

        }
    })
</script>
</html>