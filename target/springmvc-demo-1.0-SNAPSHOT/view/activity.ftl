<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <#include "__ref_common_js.ftl" parse=true />
    <!-- import CSS -->
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
</head>
<body>
<div id="app"  >
    <div>
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
            <el-form-item label="活动名称">
                <el-input v-model="formInline.name" placeholder="名称"></el-input>
            </el-form-item>
            <el-form-item label="活动地点">
                <el-cascader :props="{ checkStrictly: true }" v-model="formInline.place" :options="options" clearable filterable :show-all-levels="false"></el-cascader>
            </el-form-item>

            <el-form-item label="活动时间">
                <el-date-picker
                        v-model="formInline.date"
                        type="daterange"
                        value-format="yyyy-MM-dd"
                        align="right"
                        unlink-panels
                        range-separator="至"
                        start-placeholder="开始日期"
                        end-placeholder="结束日期"
                        :picker-options="pickerOptions">
                </el-date-picker>
            </el-form-item>
            <el-form-item label="活动范围">
                <el-select clearable multiple collapse-tags filterable v-model="formInline.region" placeholder="范围">
                    <el-option  v-for="item in clothesTypes"
                                :key="item.cltId"
                                :label="item.cltName"
                                :value="item.cltId"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item>
                <el-button type="primary" round size="small"  @click="query()">查询</el-button>
            </el-form-item>
        </el-form>
    </div>
    <div v-loading="loading"  >
        <el-descriptions  v-for="item in activity" style="margin-top: 10px"  class="margin-top" :column="3"  border>
            <el-descriptions-item >
                <template slot="label">
                    <i class="el-icon-tickets"></i>
                    活动名称
                </template>
                {{item.actName}}
            </el-descriptions-item>
            <el-descriptions-item>
                <template slot="label">
                    <i class="el-icon-scissors"></i>
                    活动范围
                </template>
                {{item.clothesType.cltName}}
            </el-descriptions-item>
            <el-descriptions-item>
                <template slot="label">
                    <i class="el-icon-notebook-2"></i>
                    活动内容
                </template>
                {{item.actContent}}
            </el-descriptions-item>
            <el-descriptions-item>
                <template slot="label">
                    <i class="el-icon-map-location"></i>
                    活动地点
                </template>
                <el-tag>{{item.city.cityName}}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item>
                <template slot="label">
                    <i class="el-icon-date"></i>
                    活动时间
                </template>
                {{item.actCreateDate}}至{{item.actEndDate}}
            </el-descriptions-item>
            <el-descriptions-item>
                <template slot="label">
                    <i class="el-icon-edit"></i>
                    操作
                </template>
                <el-button type="success" round size="small">了解详情</el-button>
            </el-descriptions-item>
        </el-descriptions>
    </div>
    <div>
        <el-pagination
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                :current-page="current.pageNum"
                :page-sizes="[5, 10, 15, 20]"
                :page-size="current.pageSize"
                layout="total, sizes, prev, pager, next, jumper"
                :total="total">
        </el-pagination>
    </div>
</div>
</body>
<!-- import Vue before Element -->
<script src="https://unpkg.com/vue/dist/vue.js"></script>
<!-- import JavaScript -->
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script>
    new Vue({
        el: '#app',
        data: function() {
            return {
                formInline: {},
                clothesTypes:[],
                options:[],
                total:0,
                current:{
                    pageSize:5,
                    pageNum:1,
                },
                currentPage: 1,
                activity:[],
                loading:true,
                pickerOptions: {
                    shortcuts: [{
                        text: '最近一周',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
                            picker.$emit('pick', [start, end]);
                        }
                    }, {
                        text: '最近一个月',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
                            picker.$emit('pick', [start, end]);
                        }
                    }, {
                        text: '最近三个月',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
                            picker.$emit('pick', [start, end]);
                        }
                    }]
                },
                value1: '',
                value2: ''
            }
        },
        methods:{
            loadings(){
                setTimeout(() => {
                    this.loading = false;
                }, 1000);
            },
            /*条件查询*/
            query(){
                this.loadings();
                var formInline = this.formInline;
                this.allActivity(formInline);
            },
            /*分页*/
            handleSizeChange(val) {
                this.loading = true;
                this.loadings();
                this.current.pageSize=val;
                var formInline = this.formInline;
                this.allActivity(formInline);
            },
            /*分页*/
            handleCurrentChange(val) {
                this.loading = true;
                this.loadings();
                this.current.pageNum = val;
                var formInline = this.formInline;
                this.allActivity(formInline);
            },

            /*查询所有活动*/
            allActivity(formInline){
                var _self = this;
                var current = _self.current;
                $.ajax({
                    url: "/main/activity?pageSize="+current.pageSize+"&pageNum="+current.pageNum+"&system="+"0",
                    type:'get',
                    data:formInline,
                    dataType: "json",
                    success:function (resp){
                        _self.activity = resp.data;
                        _self.total = resp.total;
                    }
                })

            },
            /*城市下拉框*/
            getCity(){
                var _self = this;
                $.ajax({
                    url: "/main/city",
                    type:'get',
                    dataType: "json",
                    success:function (resp){
                        _self.options = _self.getTreeData(resp);
                    }
                })

            },
            // 递归方法  去除chilren的空数组
            getTreeData(data){
                // 循环遍历json数据
                for(var i=0;i<data.length;i++){

                    if(data[i].children.length<1){
                        // children若为空数组，则将children设为undefined
                        data[i].children=undefined;
                    }else {
                        // children若不为空数组，则继续 递归调用 本方法
                        this.getTreeData(data[i].children);
                    }
                }
                return data;
            },

            /*获取衣服类型*/
            getClothingType(){
                var _self = this;
                $.ajax({
                        url: "/main/clothesType",
                        type:'get',
                        dataType: "json",
                        success:function (resp){
                            _self.clothesTypes = resp;
                        },
                })
            },


        },


        created(){
            this.loadings();
            this.allActivity();
            this.getCity();
            this.getClothingType();
        }
    })
</script>
</html>