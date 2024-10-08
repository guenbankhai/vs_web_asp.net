<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="footer.ascx.cs" Inherits="WebForm.footer" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Footer Page</title>
    <style>
        .footer {
            background-color: #000;
            color: #fff;
            margin-top: 50px;
            width: 100%;
            height: 200px;
            display: flex;
            justify-content: center; /* Canh giữa theo chiều ngang */
            align-items: center; /* Canh giữa theo chiều dọc */
        }

        .footer-content {
            width: 80%; /* Chiếm 80% chiều rộng của footer */
            text-align: left; /* Căn lề trái cho nội dung */
        }

        .footer p {
            margin: 5px 0;
            font-size: 14px;
            line-height: 1.5;
        }


    </style>
</head>
<body>
    <footer class="footer">
        <div class="footer-content">
            <p>© 2003 - Bản quyền của Công Ty TNHH Thương Mại Dịch Vụ Đồng Hồ.</p>
            <p>VPĐD: 1 Đ. Độc Lập, Quán Thánh, Ba Đình, Hà Nội</p>
            <p>Email: webdongho.2024@gmail.com</p>
            <p>Hotline: 0987 654 321 (Zalo)</p>
            <p>Giờ mở cửa: 8:30 - 21:30, Thứ 2 - Chủ nhật</p>
        </div>
    </footer>
</body>
</html>