<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <#include "__ref_common_js.ftl" parse=true />
    <!-- import CSS -->
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
</head>
<body>
<div id="app" style="display: none" >
    <div>
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
            <el-form-item>
                <el-input v-model="formInline.name" placeholder="活动名称"></el-input>
            </el-form-item>
            <el-form-item label="活动地点">
                <el-cascader
                        :props="{ checkStrictly: true }"
                        v-model="formInline.place"
                        :options="options"
                        clearable
                        filterable
                        :show-all-levels="false"></el-cascader>
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
            <el-form-item>
                <el-select multiple collapse-tags clearable filterable v-model="formInline.region" placeholder="活动范围">
                    <el-option  v-for="item in clothesTypes"
                                :key="item.cltId"
                                :label="item.cltName"
                                :value="item.cltId"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item>
                <el-button type="primary"  round @click="query()">查询</el-button>
                <el-button type="success" round  @click="added()">新增</el-button>
            </el-form-item>
        </el-form>
    </div>
    <div v-loading="loading"  >
        <el-descriptions v-for="item in activity" style="margin-top: 10px"  class="margin-top" :column="4"  border>
            <el-descriptions-item size="medium">
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
                    <i class="el-icon-s-goods"></i>
                    活动折扣
                </template>
                {{item.actDiscount/10}}折
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
                <el-button style="margin-left: 20px" type="primary" @click="queryOne(item.actId)" round size="small">修改</el-button>
                <el-button style="margin-left: 20px" v-show="item.actState==2||item.actState==0" @click="actOnline(item.actId)" type="success" round size="small">上线活动</el-button>
                <el-button style="margin-left: 20px"  v-show="item.actState==1" type="warning" @click="actOffline(item.actId)" round size="small">下线活动</el-button>
                <template>
                    <el-popconfirm title="确定删除吗？" @confirm="dele(item.actId)">
                        <el-button style="margin-left: 20px"  slot="reference" type="danger" round @click="" size="small">删除</el-button>
                    </el-popconfirm>
                </template>

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

    <#--增加或修改活动-->
    <el-dialog title="活动" :visible.sync="visible">
        <el-form :model="form" ref="form"  label-width="80px">
            <el-form-item
                    prop="name"
                    label="活动名称"
                    :rules="[
                              { required: true, message: '活动内容不能为空'}
                            ]">
                <el-col :span="8">
                    <el-input  v-model="form.name" placeholder="请输入内容"></el-input>
                </el-col>
            </el-form-item>
            <el-form-item
                    prop="place"
                    label="活动地点"
                    :rules="[
                              { required: true, message: '活动地点不能为空'}
                            ]">
                <el-cascader
                        :props="{ checkStrictly: true }"
                        v-model="form.place"
                        :options="options"
                        clearable
                        placeholder="请选择活动地点"
                        filterable
                        :show-all-levels="false"></el-cascader>
            </el-form-item>

            <el-form-item
                    prop="date"
                    label="活动时间"
                    :rules="[
                              { required: true, message: '活动日期不能为空'}
                            ]">
                <el-date-picker
                        v-model="form.date"
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
            <el-form-item
                    prop="region"
                    label="活动范围"
                    :rules="[
                              { required: true, message: '活动范围不能为空'}
                            ]">
                <el-select clearable  filterable v-model="form.region" placeholder="请选择活动范围">
                    <el-option  v-for="item in clothesTypes"
                                :key="item.cltId"
                                :label="item.cltName"
                                :value="item.cltId"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item
                    prop="actDiscount"
                    label="活动折扣"
                    :rules="[
                              { required: true, message: '折扣不能为空'},
                              { type: 'number', message: '折扣必须为数字值'}
                            ]">
                <el-col :span="8">
                    <el-input
                            show-word-limit
                            type="text"
                            maxlength="2"
                            clearable
                            v-model.number="form.actDiscount"
                            placeholder="请输入折扣"
                            ></el-input>
                </el-col>
            </el-form-item>
            <el-form-item prop="actContent" label="活动内容">
                <el-input
                        type="textarea"
                        :autosize="{ minRows: 2, maxRows: 4}"
                        placeholder="请输入内容"
                        v-model="form.actContent">
                </el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button type="danger"  @click="visible = false">取 消</el-button>
            <el-button type="primary" @click="add(form.actId,'form')">确 定</el-button>
        </div>
    </el-dialog>
</div>
</body>
<!-- import Vue before Element -->
<script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>
<!-- import JavaScript -->
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script>
    var _name='${userName}';
    new Vue({
        el: '#app',
        data: function() {
            return {
                username:_name,
                queryForm:{},
                form:{
                    actId:'',
                    name:'',
                    region:'',
                    date:[],
                    actContent:'',
                    place:[],
                    actDiscount:'',
                    username:_name,
                },
                visible:false,
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
            added(){
                this.visible = !this.visible;
                this.form = {
                    username:_name,
                };
            },
            /*修改活动  查询一个*/
            queryOne(id){
                this.visible = !this.visible;
                var _self = this;
                var cityId = '';
                _self.form={
                    actId:'',
                    name:'',
                    region:'',
                    date:[],
                    actContent:'',
                    place:[],
                    username:_self.username,
                    actDiscount:''
                }
                $.ajax({
                    url: '/main/system/queryOne?actId='+id,
                    type: 'get',
                    dataType: "json",
                    success: function (resp) {
                        _self.form.actId = resp[0].actId;
                        _self.form.name = resp[0].actName;
                        _self.form.actDiscount = parseInt(resp[0].actDiscount);
                        _self.$nextTick(() => {
                            _self.$set(_self.form, "date", [resp[0].actCreateDate, resp[0].actEndDate]);
                            _self.$forceUpdate();
                        });
                        _self.form.actContent = resp[0].actContent;
                        cityId = resp[0].city.id;
                        _self.form.region = resp[0].clothesType.cltId;
                        /*回显城市  数组*/
                        $.ajax({
                            url:'/main/system/getOneCity?cityId='+cityId,
                            type:'get',
                            dataType: "json",
                            success: function (resp) {
                                if (resp.grandpaId!=null){
                                    _self.form.place=[resp.grandpaId,resp.parentId,resp.childId]
                                }else if (resp.parentId!=null){
                                     _self.form.place=[resp.parentId,resp.childId]
                                }else if (resp.childId!=null){
                                    _self.form.place=[resp.childId]
                                }
                            }
                        })

                    }
                })


            },
            /*删除活动*/
            dele(id){
                this.loading = true;
                this.loadings();
                var _self = this;
                $.ajax({
                    url: '/main/system/delete?actId='+id,
                    type: 'get',
                    dataType: "json",
                    success: function (resp) {
                        if (resp>0) {
                            _self.$message({
                                message: '删除活动成功',
                                type: 'success'
                            });
                            var formInline = _self.formInline;
                            _self.allActivity(formInline);
                        }
                    }
                })
            },
            /*上线活动*/
            actOnline(id){
                var _self = this;
                $.ajax({
                    url: '/main/system/online?actId='+id,
                    type: 'get',
                    dataType: "json",
                    success: function (resp) {
                        if (resp>0) {
                            _self.$message({
                                message: '上线活动成功',
                                type: 'success'
                            });
                            var formInline = _self.formInline;
                            _self.allActivity(formInline);
                        }
                    }
                })
            },
            /*下线活动*/
            actOffline(id){
                var _self = this;
                $.ajax({
                    url: '/main/system/offline?actId='+id,
                    type: 'get',
                    dataType: "json",
                    success: function (resp) {
                        if (resp>0) {
                            _self.$message({
                                message: '下线活动成功',
                                type: 'success'
                            });
                            var formInline = _self.formInline;
                            _self.allActivity(formInline);
                        }
                    }
                })
            },
            /*新增活动*/
            add(id,forms){
                var messages = '';
                var src = '';
                if (id){
                    src = '/main/system/setact';
                    messages = '修改成功';
                }else {
                    src = '/main/system/addact';
                    messages = '添加成功';
                }
                var _self = this;
                var forms = forms;
                var form = this.form;
                this.$refs[forms].validate((valid) => {
                    if (valid) {
                        $.ajax({
                            url:src,
                            type:'post',
                            data:form,
                            dataType: "json",
                            success:function (resp) {
                                if (resp>0){
                                    _self.$message({
                                        message: messages,
                                        type: 'success'
                                    });
                                    var formInline = _self.formInline;
                                    _self.allActivity(formInline);
                                }
                            }
                        })
                        this.visible = !this.visible;
                        this.loading = true;
                        this.loadings();
                    } else {
                        _self.$message.error('失败！请重新操作！');
                        return false;
                    }
                });

            },
            loadings(){
                $('#app').css('display','block');
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
                this.loading = true;
                this.loadings();
                var _self = this;
                var current = _self.current;
                $.ajax({
                    url: "/main/activity?pageSize="+current.pageSize+"&pageNum="+current.pageNum+"&system="+"1",
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