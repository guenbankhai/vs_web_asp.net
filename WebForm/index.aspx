<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="WebForm.index" %>

<%@ Register Src="topbar.ascx" TagPrefix="uc1" TagName="topbar" %>
<%@ Register Src="menu.ascx" TagPrefix="uc1" TagName="menu" %>
<%@ Register Src="footer.ascx" TagPrefix="uc1" TagName="footer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Product List</title>
    <style>
        /* CSS để tùy chỉnh giao diện sản phẩm và phần giới thiệu đối tác */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            display: flex;
            flex-direction: column;
            align-items: center; /* Căn giữa toàn bộ nội dung theo chiều dọc */
        }

        .banner {
            width: 100%;
            margin: 20px auto; /* Canh giữa banner và thanh menu */
        }

        .listProductContainer {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            max-width: 1200px; /* Giới hạn chiều rộng */
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .listProductContainer a {
            text-decoration: none; 
        }

        .productContainer {
            flex: 0 0 calc(25% - 20px); /* Chia bốn cột (25%) với margin 10px giữa các sản phẩm */
            max-width: calc(25% - 20px); /* Đảm bảo không vượt quá 25% chiều rộng */
            box-sizing: border-box;
            padding: 15px;
            text-align: center;
            border: 1px solid #ccc;
            margin: 10px;
            position: relative;
        }

        .productImage {
            width: 150px;
            height: 150px;
            transition: filter 0.3s ease; /* Hiệu ứng làm mờ */
        }

        .productName {
            font-size: 16px;
            font-weight: bold;
            color: #333; /* Màu chữ tên sản phẩm */
        }

        .productPrice {
            font-size: 14px;
            color: #007bff; /* Màu chữ giá tiền */
        }

        .detailButton {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: #007bff; /* Màu nền của nút "Chi tiết" */
            color: white; /* Màu chữ của nút "Chi tiết" */
            border: none;
            padding: 8px 16px;
            cursor: pointer;
            opacity: 0; /* Ẩn nút "Chi tiết" ban đầu */
            transition: opacity 0.3s ease; /* Hiệu ứng hiển thị */
        }

        .detailButton:hover {
            background-color: #0056b3; /* Màu nền khi hover vào nút "Chi tiết" */
        }

        .productContainer:hover .productImage {
            filter: blur(3px); /* Làm mờ ảnh khi hover vào sản phẩm */
        }

        .productContainer:hover .detailButton {
            opacity: 1; /* Hiển thị nút "Chi tiết" khi hover vào sản phẩm */
        }

        .listCategory {
            padding-bottom: 30px
        }

        .listCategory a {
            text-decoration: none; /* Loại bỏ gạch chân */
            color: #007bff; /* Màu chữ ban đầu */
            margin: 0 10px; /* Khoảng cách giữa các nút */
            padding: 8px 16px; /* Độ dày của nút */
            border: 1px solid #007bff; /* Viền của nút */
            border-radius: 5px; /* Độ cong viền */
            transition: all 0.3s ease; /* Hiệu ứng chuyển động trơn tru */
        }
        .listCategory a:hover {
            background-color: #007bff; /* Màu nền khi hover */
            color: white; /* Màu chữ khi hover */
        }

        .top4 {
            background-color: #000;
            width: 100%;
            color: #fff;
            display: flex;
            flex-direction: column; /* Hiển thị các phần tử theo chiều dọc */
            justify-content: center;
            align-items: center;
            padding: 20px;
            box-sizing: border-box;
        }

        .top4-row {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            margin-bottom: 10px;
        }

        .top4-item {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            margin-right: 20px; /* Khoảng cách giữa các cột */
        }

        .logo-small {
            width: 50px; /* Kích thước mới của logo */
            height: 50px;
            margin-right: 5px; /* Khoảng cách giữa logo và nội dung của thẻ a */
        }

        .top4-item a {
            color: #fff; /* Đổi màu chữ sang trắng */
            text-decoration: none;
            transition: color 0.3s ease;
            margin-top: 10px; /* Khoảng cách với dòng trên */
            text-align: center; /* Căn giữa nội dung của thẻ a */
        }

        .top4-item a:hover {
            color: #ff0000; /* Đổi màu chữ sang đỏ khi hover */
        }

        .partners {
            margin-top: 30px;
            text-align: center;
            width: 80%; /* Chiều rộng của phần giới thiệu đối tác */
            border-top: 2px solid #ccc; /* Đường phân chia */
            border-bottom: 2px solid #ccc; /* Đường phân chia */

            padding-top: 30px; /* Khoảng cách từ đường phân chia */
        }

        .partners h2 {
            font-size: 24px;
            margin-bottom: 20px;
        }

        .partner-logos {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap; /* Cho phép các logo trên nhiều dòng */
        }

        .partner-logos img {
            width: 140px; /* Kích thước mới của logo đối tác */
            height: auto;
            margin: 10px; /* Khoảng cách giữa các logo */
        }

        /* CSS cho phần giới thiệu các doanh nhân đã tin tưởng */
        .customer-gallery {
            display: flex;
            justify-content: center;
            align-items: flex-start; /* Canh lên đầu ảnh khách hàng */
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .customer-item {
            cursor: pointer;
            margin: 10px;
            transition: transform 0.3s ease, opacity 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center; /* Căn giữa nội dung trong mỗi item */
        }

        .customer-item img {
            width: 100px;
            height: 100px;
            border-radius: 50%; /* Làm cho ảnh tròn */
            object-fit: cover;
        }

        .customer-info {
            display: none;
            margin-top: 10px;
            padding: 10px;
            font-size: 14px;
            text-align: center;
            width: 100%; /* Độ rộng của thông tin khách hàng */
        }

        .customer-item.active {
            transform: scale(1.3); /* Thu nhỏ lại khi được chọn */
            opacity: 1;
        }

        .customer-info.active {
            display: block;
        }


    </style>
</head>
<body>
 
    <%-- Include top bar --%>
    <uc1:topbar runat="server" />
    <%-- Include menu --%>
    <uc1:menu runat="server" />
    <%-- Include banner --%>
    <div class="banner">
        <img src="./img/banner-1.png" alt="Banner" style="width: 100%; height: 100%; object-fit: cover;">
    </div>
    <%-- Include top 4 --%>
    <div class="top4">
        <div class="top4-row">
            <h2>5 LÍ DO KHIẾN BẠN KHÔNG THỂ KHÔNG CHỌN WEBBANDONGHO.COM</h2>
        </div>
        <div class="top4-row">
            <div class="top4-item">
                <img src="./img/partner.png" alt="Logo 1" class="logo-small" />
            </div>
            <div class="top4-item">
                <img src="./img/businessmen.png" alt="Logo 2" class="logo-small" />
            </div>
            <div class="top4-item">
                <img src="./img/warranty.png" alt="Logo 3" class="logo-small" />
            </div>
            <div class="top4-item">
                <img src="./img/heart.png" alt="Logo 4" class="logo-small" />
            </div>
        </div>
        <div class="top4-row">
            <div class="top4-item">
                <a href="#dai-ly">ĐẠI LÝ ỦY QUYỀN CHÍNH THỨC CỦA HÃNG</a>
            </div>
            <div class="top4-item">
                <a href="#lua-chon">LỰA CHỌN HÀNG ĐẦU CỦA GIỚI DOANH NHÂN</a>
            </div>
            <div class="top4-item">
                <a href="#bao-hanh">TRUNG TÂM BẢO HÀNH HIỆN ĐẠI HÀNG ĐẦU VIỆT NAM</a>
            </div>
            <div class="top4-item">
                <a href="#phuc-vu">PHỤC VỤ KHÁCH HÀNG TỪ TRÁI TIM</a>
            </div>
        </div>
    </div>



    <%-- Include list product --%>
    <h2>DANH SÁCH SẢN PHẨM</h2>
    <div class="listCategory">
        <a href="index.aspx?category=1">Đồng hồ nam</a> |
        <a href="index.aspx?category=2">Đồng hồ nữ</a> |
        <a href="index.aspx?category=3">Đồng hồ unisex</a>
    </div>
    <div class="listProductContainer">
        <asp:Repeater ID="productList" runat="server">
            <ItemTemplate>
                <div class="productContainer">
                    <img src='<%# Eval("Url") %>' class="productImage" />
                    <br />
                    <span class="productName"><%# Eval("Name") %></span>
                    <br />
                    <span class="productPrice"><%# Eval("Price", "{0:C}") %></span>
                    <br />
                    <a href='<%# $"detail.aspx?ProductId={Eval("ProductId")}" %>' class="detailButton">Chi tiết</a>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <%-- Include partner --%>
    <div class="partners">
        <h2>CÁC ĐỐI TÁC CỦA CHÚNG TÔI</h2>
        <div class="partner-logos">
            <img src="./img/partner-1.png" alt="Partner 1" />
            <img src="./img/partner-2.png" alt="Partner 2" />
            <img src="./img/partner-3.png" alt="Partner 3" />
            <img src="./img/partner-4.png" alt="Partner 4" />
            <img src="./img/partner-5.png" alt="Partner 5" />
            <img src="./img/partner-6.png" alt="Partner 6" />
            <img src="./img/partner-7.png" alt="Partner 7" />
        </div>
    </div>

    <%-- Include partner introduction --%>
    <div class="featured-customers">
        <h2>CÁC DOANH NHÂN ĐÃ TIN TƯỞNG SỬ DỤNG SẢN PHẨM CỦA CHÚNG TÔI</h2>
        <div class="customer-gallery">
            <div class="customer-item" data-name="businessmen-1">
                <img src="./img/businessmen-1.png" alt="Businessmen 1" />
                <div class="customer-info">
                    <p>LẠI THỊ HẢI LÝ</p>
                    <p>Chuyên gia giao dục</p>
                </div>
            </div>
            <div class="customer-item" data-name="businessmen-2">
                <img src="./img/businessmen-2.png" alt="Businessmen 2" />
                <div class="customer-info">
                    <p>KIỀU PHẠM</p>
                    <p>Ca sĩ</p>
                </div>
            </div>
            <div class="customer-item" data-name="businessmen-3">
                <img src="./img/businessmen-3.png" alt="Businessmen 3" />
                <div class="customer-info">
                    <p>LƯU LAN ANH</p>
                    <p>Á hoàng Kim Cương EMPIRE 2017</p>

                </div>
            </div>
            <div class="customer-item" data-name="businessmen-4">
                <img src="./img/businessmen-4.png" alt="Businessmen 4" />
                <div class="customer-info">
                    <p>LẠI TIẾN MẠNH</p>
                    <p>CEO MIBRAND</p>
                </div>
            </div>
            <div class="customer-item" data-name="businessmen-5">
                <img src="./img/businessmen-5.png" alt="Businessmen 5" />
                <div class="customer-info">
                    <p>TRẦN NGỌC MINH</p>
                    <p>Giám đốc công ty TNHH HEMPEL VIỆT NAM</p>
                </div>
            </div>
            <div class="customer-item" data-name="businessmen-6">
                <img src="./img/businessmen-6.png" alt="Businessmen 6" />
                <div class="customer-info">
                    <p>TRẦN QUÝ HẢI</p>
                    <p>Giáo sư</p>
                </div>
            </div>
        </div>
    </div>


    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const customerItems = document.querySelectorAll(".customer-item");
            let currentIndex = 0;
            let intervalId = null;

            function showCustomer(index) {
                // Ẩn tất cả các khách hàng và thông tin của khách hàng
                customerItems.forEach(item => {
                    item.classList.remove("active");
                    item.querySelector(".customer-info").classList.remove("active");
                });

                // Hiển thị khách hàng được chọn
                customerItems[index].classList.add("active");
                customerItems[index].querySelector(".customer-info").classList.add("active");
            }

            function startInterval() {
                // Reset interval khi chuyển đổi giữa các khách hàng
                if (intervalId) {
                    clearInterval(intervalId);
                }
                intervalId = setInterval(() => {
                    currentIndex = (currentIndex + 1) % customerItems.length;
                    showCustomer(currentIndex);
                }, 2000); // Chuyển đổi khách hàng sau mỗi 2 giây
            }

            // Bắt sự kiện click trên mỗi khách hàng
            customerItems.forEach((item, index) => {
                item.addEventListener("click", () => {
                    // Dừng interval khi click vào một khách hàng
                    clearInterval(intervalId);
                    currentIndex = index; // Đặt lại chỉ số của khách hàng hiện tại
                    showCustomer(currentIndex); // Hiển thị khách hàng được chọn

                    // Khởi động lại interval để tự động chuyển đổi
                    startInterval();
                });
            });

            // Khởi động bộ đếm thời gian tự động chuyển đổi khách hàng ban đầu
            startInterval();
        });
    </script>
    
</body>

 <%-- Include menu --%>
<uc1:footer runat="server" />

</html>