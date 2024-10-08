<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="topbar.ascx.cs" Inherits="WebForm.topbar" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Top Bar</title>
    <style>
        /* CSS để tùy chỉnh top bar */
        .topbar {
            background-color: #007bff;
            height: 30px;
            width: 100%;
            display: flex;
            justify-content: space-between; /* Canh giữa các phần tử trong top bar */
            align-items: center;
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000; /* Đảm bảo top bar hiển thị trên cùng */
            padding: 0 20px; /* Khoảng cách giữa các phần tử */
        }
        a {
            text-decoration: none;
            color: #ffffff;
        }

        .userInfo a {
           padding-right: 50px;
        }
    </style>
</head>
<body>
    <div class="topbar">
        <div>
            <a runat="server" ID="LoginLogoutLink" href="login.aspx">Đăng nhập</a>
        </div>
        <div class="userInfo">
            <%-- Hiển thị thông tin người dùng --%>
            <asp:Literal ID="UserInfoLiteral" runat="server"></asp:Literal>
        </div>
    </div>
</body>
</html>
