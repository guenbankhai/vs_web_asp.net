<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="cart.aspx.cs" Inherits="WebForm.cart" %>

<%@ Register Src="topbar.ascx" TagPrefix="uc1" TagName="topbar" %>
<%@ Register Src="menu.ascx" TagPrefix="uc1" TagName="menu" %>
<%@ Register Src="footer.ascx" TagPrefix="uc1" TagName="footer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Shopping Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            padding: 20px;
        }

        .cartContainer {
            width: 70%;
            background-color: #ffffff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: 0 auto; /* Canh giữa theo chiều ngang */
        }

        .productRow {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }

        .productImage {
            max-width: 100px;
            max-height: 100px;
            margin-right: 20px;
        }

        .productName {
            font-weight: bold;
            flex: 1;
            margin-right: 20px; /* Khoảng cách từ productName đến productInfo */
        }

        .productInfo {
            display: flex;
            flex-direction: column;
            flex: 2; /* Phần tử productInfo chiếm 2/3 phần còn lại của productRow */
        }

        .productPrice {
            color: #007bff;
            margin-bottom: 5px;
        }

        .productCategory {
            margin-bottom: 5px;
        }

        .productQuantity {
            font-weight: bold;
        }

        .productCheckbox {
            margin-right: 20px;
        }

        .userInfo {
            margin-top: 20px;
            margin-bottom: 20px;
        }

        .orderSummary {
            margin-bottom: 20px;
        }

        .buttonContainer {
            text-align: center; /* Căn giữa nội dung trong container */
            margin-top: 20px;
        }

        .confirmButton,
        .deleteButton {
            padding: 10px 20px;
            background-color: #007bff;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px; /* Để tạo khoảng cách giữa các nút */
        }

    </style>
</head>
<body>
    <%-- Include top bar --%>
    <uc1:topbar runat="server" />
    <%-- Include menu --%>
    <uc1:menu runat="server" />

    <form id="form1" runat="server">
        <div class="cartContainer">
            <h2>Shopping cart</h2>
            <input type="checkbox" id="selectAllCheckbox" />
            <label for="selectAllCheckbox">Chọn tất cả</label>

            <div id="cartContent" runat="server">
                    <asp:Repeater ID="rptCartItems" runat="server">
                        <ItemTemplate>
                            <div class="productRow">
                                <div class="productImage">
                                    <asp:Image ID="imgProduct" runat="server" ImageUrl='<%# Eval("ImageUrl") %>' CssClass="productImage" />
                                </div>
                                <div class="productInfo">
                                    <div class="productName"><%# Eval("ProductName") %></div>
                                    <div class="productCategory">Loại: <%# Eval("CategoryName") %></div>
                                    <div class="productPrice">Đơn giá: <%# String.Format("{0:C}", Eval("Price")) %></div>
                                    <div class="productQuantity">Số lượng: <%# Eval("Quantity") %></div>
                                    <asp:CheckBox ID="chkProduct" runat="server" CssClass="productCheckbox" OnCheckedChanged="chkProduct_CheckedChanged" AutoPostBack="true" />
                                    <asp:HiddenField ID="hdnProductID" runat="server" Value='<%# Eval("ProductID") %>' />
                                    <asp:HiddenField ID="hdnQuantityID" runat="server" Value='<%# Eval("Quantity") %>' />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
            </div>

            <!-- Hiển thị thông tin người dùng -->
            <div class="userInfo" id="userInfo" runat="server">
                <!-- Thông tin người dùng sẽ được thêm vào đây từ mã code-behind -->
            </div>
            <div class="orderSummary">
                <div>Tiền giao hàng: $15.00</div>
                <div>VAT: 5%</div>
                <div>Giảm giá: $50.00</div>
            </div>

            <!-- Nút xác nhận và nút xóa -->
            <div class="buttonContainer">
                <asp:Button ID="btnConfirm" runat="server" Text="Xác nhận" CssClass="confirmButton" OnClick="btnConfirm_Click" />
                <asp:Button ID="btnDelete" runat="server" Text="Xoá" CssClass="deleteButton" OnClick="btnDelete_Click" />
            </div>
        </div>

    </form>

    <%-- Include footer --%>
    <uc1:footer runat="server" />

</body>
</html>
