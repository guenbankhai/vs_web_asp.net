<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="detail.aspx.cs" Inherits="WebForm.detail" %>

<%@ Register Src="topbar.ascx" TagPrefix="uc1" TagName="topbar" %>
<%@ Register Src="menu.ascx" TagPrefix="uc1" TagName="menu" %>
<%@ Register Src="footer.ascx" TagPrefix="uc1" TagName="footer" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Product Detail</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            display: flex;
            flex-direction: column;
            align-items: center; /* Căn giữa toàn bộ nội dung theo chiều dọc */
        }

        .productDetailContainer {
            display: flex;
            justify-content: space-around;
            max-width: 1200px;
            width: 100%; /* Sử dụng chiều rộng 100% để đảm bảo độ rộng linh hoạt */
            margin: 20px auto; /* Canh giữa trên dưới */
            margin-bottom: 100px;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .productInfo {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: flex-start;
        }

        .productImageDetail {
            max-width: 400px;
            height: auto;
            margin-right: 20px;
            border: 1px solid #ddd;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }

        .productNameDetail {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .productDescription {
            font-size: 16px;
            color: #666;
            margin-bottom: 20px;
        }

        .productPriceDetail {
            font-size: 20px;
            color: #007bff;
            margin-bottom: 20px;
        }

        .cartButton {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 12px 24px;
            font-size: 18px;
            cursor: pointer;
            align-self: flex-start;
        }

        .cartButtonDisabled {
            background-color: #ccc;
            color: white;
            border: none;
            padding: 12px 24px;
            font-size: 18px;
            cursor: not-allowed;
            align-self: flex-start;
        }

        .orderContainer {
            display: flex;
            align-items: center; /* Canh căn giữa theo chiều dọc */
        }

        .orderContainer input[type="number"] {
            padding: 8px;
            width: 70px;
            margin-left: 50px;
        }

        .listProductContainer {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            max-width: 1200px; /* Giới hạn chiều rộng */
            width: 100%; /* Sử dụng chiều rộng 100% để đảm bảo độ rộng linh hoạt */
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

        h2 {
            text-align: center; /* Canh giữa các tiêu đề h2 */
        }

    </style>
</head>
<body>

    <%-- Include top bar --%>
    <uc1:topbar runat="server" />
    <%-- Include menu --%>
    <uc1:menu runat="server" />

    
    <form id="form1" runat="server">
        <%-- Include product detail --%>
        <h2>CHI TIẾT SẢN PHẨM</h2>
        <div class="productDetailContainer">
            <div>
                <img id="imgProductDetail" runat="server" class="productImageDetail" />
            </div>
            <div class="productInfo">
                <span id="lblProductName" runat="server" class="productNameDetail"></span>
                <br />
                <span id="lblProductDescription" runat="server" class="productDescription"></span>
                <br />
                <span id="lblProductPrice" runat="server" class="productPriceDetail"></span>
                <br />
                <div class="orderContainer">
                    <asp:Button ID="btnAddToCart" runat="server" CssClass="cartButton" Text="Thêm vào giỏ hàng" OnClick="btnAddToCart_Click"/>
                    <input type="number" id="inputQuantity" runat="server" placeholder = 'Số lượng'/>
                </div>
                
            </div>
        </div>>

        <%-- Include list product --%>
        <h2>DANH SÁCH SẢN PHẨM CÙNG DÒNG KHÁC</h2>
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
    </form>

    <script type="text/javascript">
        window.onload = function () {
            var inputQuantity = document.getElementById('<%= inputQuantity.ClientID %>'); // Lấy đối tượng input theo ID

            // Xử lý sự kiện khi nhập liệu vào input
            inputQuantity.addEventListener('input', function () {
                var labelQuantity = document.querySelector('label[for="inputQuantity"]'); // Lấy label theo attribute 'for'

                // Kiểm tra nếu input đã có dữ liệu
                if (inputQuantity.value.trim() !== '') {
                    labelQuantity.style.display = 'none'; // Ẩn label khi input có dữ liệu
                } else {
                    labelQuantity.style.display = 'inline'; // Hiển thị label khi input trống
                }
            });
        };
    </script>

    <script type="text/javascript">
        window.onload = function () {
            var inputQuantity = document.getElementById('<%= inputQuantity.ClientID %>'); // Lấy đối tượng input theo ID

            // Xử lý sự kiện khi nhập liệu vào input
            inputQuantity.addEventListener('input', function () {
                var value = parseInt(inputQuantity.value);

                // Kiểm tra giá trị của input
                if (isNaN(value) || value < 1 || value > 10) {
                    inputQuantity.value = ''; // Nếu giá trị không hợp lệ, đặt lại giá trị thành rỗng
                }

                // Hiển thị 'Số lượng' nếu input trống hoặc có giá trị là 0
                if (inputQuantity.value.trim() === '' || parseInt(inputQuantity.value) === 0) {
                    inputQuantity.value = ''; // Đặt lại giá trị thành rỗng nếu là 0
                    inputQuantity.placeholder = 'Số lượng'; // Hiển thị placeholder là 'Số lượng'
                } else {
                    inputQuantity.placeholder = ''; // Xóa placeholder nếu có giá trị hợp lệ
                }
            });
        };
    </script>

</body>

<%-- Include menu --%>
<uc1:footer runat="server" />

</html>
