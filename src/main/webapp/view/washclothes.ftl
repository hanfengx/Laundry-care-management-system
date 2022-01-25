<!DOCTYPE html>
<html lang="en">
<head>
    <#include "__ref_common_js.ftl" parse=true />
    <!-- import CSS -->
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <!-- import Vue before Element -->
    <script src="https://unpkg.com/vue/dist/vue.js"></script>
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
            <el-form ref="form" :model="form" >
                    <el-form-item  label="活动名称">
                        <el-col :span="4">
                            <el-select v-model="actOptions.actId">
                                <el-option
                                        v-for="item in actOptions"
                                        :label="item.actName"
                                        :value="item.actId"
                                        @click.native='option(item.actId)'>
                                </el-option>
                            </el-select>
                        </el-col>
                    </el-form-item>
                    <el-form-item label="活动地点">
                        <el-cascader
                                :props="{ checkStrictly: true }"
                                v-model="form.place"
                                :options="form.place"
                                clearable
                                placeholder="请选择活动地点"
                                filterable
                                :show-all-levels="false"></el-cascader>
                    </el-form-item>
                    <el-form-item label="活动时间">
                        <el-col :span="4">
                            <el-date-picker type="date" placeholder="选择日期" v-model="form.date1" style="width: 100%;"></el-date-picker>
                        </el-col>
                        <el-col class="line" :span="0.45">-</el-col>
                        <el-col :span="4">
                            <el-time-picker placeholder="选择时间" v-model="form.date2" style="width: 100%;"></el-time-picker>
                        </el-col>
                    </el-form-item>
                    <el-form-item label="即时配送">
                        <el-switch v-model="form.delivery"></el-switch>
                    </el-form-item>
                    <el-form-item label="活动性质">
                        <el-checkbox-group v-model="form.type">
                            <el-checkbox label="美食/餐厅线上活动" name="type"></el-checkbox>
                            <el-checkbox label="地推活动" name="type"></el-checkbox>
                            <el-checkbox label="线下主题活动" name="type"></el-checkbox>
                            <el-checkbox label="单纯品牌曝光" name="type"></el-checkbox>
                        </el-checkbox-group>
                    </el-form-item>
                    <el-form-item label="特殊资源">
                        <el-radio-group v-model="form.resource">
                            <el-radio label="线上品牌商赞助"></el-radio>
                            <el-radio label="线下场地免费"></el-radio>
                        </el-radio-group>
                    </el-form-item>
                    <el-form-item label="活动形式">
                        <el-col :span="8">
                            <el-input type="textarea" v-model="form.desc"></el-input>
                        </el-col>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="onSubmit">立即创建</el-button>
                        <el-button>取消</el-button>
                    </el-form-item>
                </el-form>
        </div>
    </div>
</body>
<script>
    var vm = new Vue({
        el: '#app',
        data: function() {
            return {
                options:[],
                actOptions:[],
                form: {
                    place:[],
                    name: '',
                    region: '',
                    date1: '',
                    date2: '',
                    delivery: false,
                    type: [],
                    resource: '',
                    desc: ''
                }
            }
        },
        methods:{
            /*根据选择的活动确定城市*/
            option(id){
              var _self = this;
              $.ajax({
                  type:'get',
                  dataType: "json",
                  url:'/washclothes/getCity?actId='+id,
                  success:function (resp){
                      if (resp.grandpaId!=null){
                          _self.form.place=[resp.grandpaId,resp.parentId,resp.childId]
                          _self.options.value = resp.grandpaId;
                          _self.options.label = resp.grandpaName;
                          _self.options.children.value = resp.parentId;
                          _self.options.children.label = resp.parentName;
                          _self.options.children.children.value = resp.childId;
                          _self.options.children.children.label = resp.childName;

                      }else if (resp.parentId!=null){
                          _self.form.place=[resp.parentId,resp.childId]
                          _self.options.value = resp.parentId;
                          _self.options.label = resp.parentName;
                          _self.options.children.value = resp.childId;
                          _self.options.children.label = resp.childName;
                      }else if (resp.childId!=null){
                          _self.form.place=[resp.childId]
                          _self.options.value = resp.childId;
                          _self.options.label = resp.childName;
                      }
                      console.log(_self.options);
                      console.log(_self.form.place);
                  }
              })
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
            onSubmit() {
                console.log('submit!');
            }
        },
        created(){
            this.selectAct();

        }
    })
</script>
</html>