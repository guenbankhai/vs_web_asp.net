<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="menu.ascx.cs" Inherits="WebForm.menu" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Menu Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            padding-top: 20px;
        }
        .menuBar {
            width: 80%;
            height: 50px;
            background-color: #333; /* Màu nền là màu đen nhẹ */
            display: flex;
            justify-content: space-between; /* Canh giữa các mục trong thanh menu */
            align-items: center;
            border-radius: 10px; /* Bo tròn các góc của thanh menu */
            margin: 20px auto; /* Canh giữa thanh menu */
            padding-left: 20px; /* Lề bên trái của thanh menu */
            padding-right: 20px; /* Lề bên phải của thanh menu */
        }
        .menuBar a {
            text-decoration: none;
            font-size: 16px;
            color: white; /* Màu chữ là trắng */
            padding: 10px 20px;
            margin-right: 20px; /* Khoảng cách giữa các mục */
            transition: transform 0.2s ease, font-weight 0.2s ease; /* Hiệu ứng chuyển đổi */
        }
        .menuBar a:hover {
            font-weight: bold; /* Bôi đậm chữ khi rê chuột vào */
            transform: scale(1.05); /* Phóng to một chút */
        }
        .searchBox {
            width: 200px;
            height: 15px;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 5px;
            display: flex;
            align-items: center; /* Căn giữa nội dung trong search box */
        }
        .searchBox input[type="text"] {
            width: 100%;
            height: 100%;
            border: none;
            outline: none;
            padding-left: 5px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="menuBar">
        <div>
            <a runat="server" ID="option1" href="#"></a>
            <a runat="server" ID="option2" href="#"></a>
            <a runat="server" ID="option3" href="#"></a>
            <a runat="server" ID="option4" href="#"></a>
        </div>
        <div class="searchBox">
            <input type="text" placeholder="Tìm kiếm...">
        </div>
    </div>


</body>
</html>
