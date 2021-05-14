<%--
  Created by IntelliJ IDEA.
  User: chengzhi
  Date: 2021/4/22
  Time: 13:59
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html class="x-admin-sm">
<head>
    <meta charset="UTF-8">
    <title>新增维修信息</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/xadmin.css">
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/lib/layui/layui.js"
            charset="utf-8"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/xadmin.js"></script>

    <!-- 让IE8/9支持媒体查询，从而兼容栅格 -->
    <!--[if lt IE 9]>
    <script src="https://cdn.staticfile.org/html5shiv/r29/html5.min.js"></script>
    <script src="https://cdn.staticfile.org/respond.js/1.4.2/respond.min.js"></script>

    <![endif]--></head>

<body>
<div class="layui-fluid">
    <div class="layui-row">
        <form class="layui-form">
            <div class="layui-form-item">
                <label for="L_description" class="layui-form-label">
                    <span class="x-red">*</span>描述</label>
                <div class="layui-input-inline">
                    <input type="text" id="L_description" name="description" lay-verify="descriptions"
                           class="layui-input" autocomplete="off" required=""></div>
            </div>

            <div class="layui-form-item" lay-filter="myDiv">
                <label class="layui-form-label" for="select" style="">任务类型</label>
                <div class="layui-input-inline">
                    <select id="select" name="taskId" lay-filter="mySelect" lay-verify="selects">
                        <option value="">请选择任务类型</option>
                        <c:forEach items="${task}" var="ite">
                            <option value="${ite.taskId}">${ite.taskType}</option>
                        </c:forEach>
                    </select>

                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">发生时间</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" name="occurredTime" value=" "
                           lay-verify="occurredTimes" id="occurredTime" placeholder="yyyy-MM-dd HH:mm:ss">
                </div>
            </div>

            <div class="layui-form-item">
                <label for="select" class="layui-form-label"></label>
                <button class="layui-btn" lay-filter="editBtn" lay-submit="" id="editBtn">新增</button>
            </div>
        </form>
    </div>
</div>
</body>
<script>
    layui.use(['form', 'layer', 'laydate'], function () {
        $ = layui.jquery;
        var form = layui.form,
            layer = layui.layer,
            laydate = layui.laydate;

        //刷新界面 所有元素
        layui.form.render();
        //时间选择器
        laydate.render({
            elem: '#occurredTime'
            , type: 'datetime'
        });

        //自定义验证规则
        form.verify({
            descriptions: function (value) {
                value = value.trim();
                if (value.length < 0 || value == "") {
                    return '请输入描述内容';
                }
            }, occurredTimes: function (value) {
                value = value.trim();
                if (value.length < 0 || value == "") {
                    return '请填写发生时间';
                }
            }, selects: function (value) {
                if (value == "" || value == null) {
                    return '请选中任务类型';
                }
            }
        });

        form.on('submit(editBtn)', function (data) {
            var maintain = data.field;
            //获取当前点击对象的用户id
            $.ajax({
                // 编写json格式，设置属性和值
                url: "${pageContext.request.contextPath}/maintain/addMaintain",
                data: {
                    "description": maintain.description,
                    "taskId": maintain.taskId,
                    "occurredTime": maintain.occurredTime,
                    "userId":${sessionScope.userId}
                },
                async: false,
                dataType: "json",
                type: "post",
                success: function (data) {
                    if (data.flag == "success") {
                        window.parent.location.reload();
                        var index = parent.layer.getFrameIndex(window.name);
                        parent.layer.close(index);
                    } else {
                        alert("删除失败，后端异常", {icon: 5});
                    }
                }
            })
        });
    })
</script>
</html>