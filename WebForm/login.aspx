<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="WebForm.login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Đăng nhập - Web bán đồng hồ</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #60a9f7; /* Màu nền của trang web */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        #loginBlock {
            width: 350px;
            background-color: #ffffff; /* Màu nền của khung đăng nhập */
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1); /* Đổ bóng khung đăng nhập */
        }

        #loginBlock h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #007bff; /* Màu chữ tiêu đề */
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        .form-control {
            width: calc(100% - 20px); /* Tạo khoảng cách vừa phải cho input */
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ced4da;
            border-radius: 4px;
        }

        #btnLogin {
            background-color: #007bff;
            color: #ffffff;
            border: none;
            padding: 12px 20px;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
        }

        #btnLogin:hover {
            background-color: #0056b3; /* Màu nền khi hover */
        }

    </style>
</head>
<body>
    <form id="formLogin" runat="server">
        <div id="loginBlock">
            <h2>Đăng nhập - Web bán đồng hồ</h2>
            <div class="form-group">
                <label for="txtUsername">Tên đăng nhập:</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" />
            </div>
            <div class="form-group">
                <label for="txtPassword">Mật khẩu:</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" />
                <asp:Label ID="lblErrorMessage" runat="server" Text="" ForeColor="red"></asp:Label>
            </div>
            <div style="text-align: center;">
                <asp:Button ID="btnLogin" runat="server" Text="Đăng nhập" OnClick="btnLogin_Click" />
            </div>
        </div>
    </form>
</body>
</html>


