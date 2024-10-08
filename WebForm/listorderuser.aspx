<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="listorderuser.aspx.cs" Inherits="WebForm.listorderuser" %>

<%@ Register Src="topbar.ascx" TagPrefix="uc1" TagName="topbar" %>
<%@ Register Src="menu.ascx" TagPrefix="uc1" TagName="menu" %>
<%@ Register Src="footer.ascx" TagPrefix="uc1" TagName="footer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Danh sách đơn hàng</title>
    <style>
        body {
            background-color: #f0f0f0;
            font-family: Arial, sans-serif;
        }
        .container {
            width: 80%;
            min-height: 420px;
            margin: 20px auto;
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        .action-button {
            padding: 5px 10px;
            cursor: pointer;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 3px;
        }
    </style>
</head>
<body>

    <%-- Include top bar --%>
    <uc1:topbar runat="server" />
    <%-- Include menu --%>
    <uc1:menu runat="server" />

    <form id="form1" runat="server">
        <div class="container">
            <h2>Bảng đơn hàng chờ xác nhận</h2>
            <table>
                <tr>
                    <th>Mã đơn hàng</th>
                    <th>Người đặt hàng</th>
                    <th>Địa chỉ</th>
                    <th>Số điện thoại</th>
                    <th>Tên sản phẩm</th>
                    <th>Loại sản phẩm</th>
                    <th>Số lượng</th>
                    <th>Giá</th>
                    <th>Ngày đặt hàng</th>
                    <th>Thao tác</th>
                </tr>
                <asp:Repeater ID="rptOrders1" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("OrderID") %></td>
                            <td><%# Eval("UserName") %></td>
                            <td><%# Eval("AddressInfo") %></td>
                            <td><%# Eval("PhoneNum") %></td>
                            <td><%# Eval("ProductName") %></td>
                            <td><%# Eval("ProductCategory") %></td>
                            <td><%# Eval("Quantity") %></td>
                            <td><%# Eval("ItemPrice", "{0:C}") %></td>
                            <td><%# Eval("OrderDate", "{0:dd/MM/yyyy}") %></td>
                            <td><asp:Button runat="server" Text="Huỷ đơn hàng" CssClass="action-button" CommandName="DeleteOrder" CommandArgument='<%# Eval("OrderID") %>' OnCommand="ActionCommand" /></td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </div>
        
        <div class="container">
            <h2>Bảng đơn hàng đang giao</h2>
            <table>
                <tr>
                    <th>Mã đơn hàng</th>
                    <th>Người đặt hàng</th>
                    <th>Địa chỉ</th>
                    <th>Số điện thoại</th>
                    <th>Tên sản phẩm</th>
                    <th>Loại sản phẩm</th>
                    <th>Số lượng</th>
                    <th>Giá</th>
                    <th>Ngày đặt hàng</th>
                </tr>
                <asp:Repeater ID="rptOrders2" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("OrderID") %></td>
                            <td><%# Eval("UserName") %></td>
                            <td><%# Eval("AddressInfo") %></td>
                            <td><%# Eval("PhoneNum") %></td>
                            <td><%# Eval("ProductName") %></td>
                            <td><%# Eval("ProductCategory") %></td>
                            <td><%# Eval("Quantity") %></td>
                            <td><%# Eval("ItemPrice", "{0:C}") %></td>
                            <td><%# Eval("OrderDate", "{0:dd/MM/yyyy}") %></td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </div>
        
        <div class="container">
            <h2>Bảng đơn hàng giao thành công</h2>
            <table>
                <tr>
                    <th>Mã đơn hàng</th>
                    <th>Người đặt hàng</th>
                    <th>Địa chỉ</th>
                    <th>Số điện thoại</th>
                    <th>Tên sản phẩm</th>
                    <th>Loại sản phẩm</th>
                    <th>Số lượng</th>
                    <th>Giá</th>
                    <th>Ngày đặt hàng</th>
                </tr>
                <asp:Repeater ID="rptOrders3" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("OrderID") %></td>
                            <td><%# Eval("UserName") %></td>
                            <td><%# Eval("AddressInfo") %></td>
                            <td><%# Eval("PhoneNum") %></td>
                            <td><%# Eval("ProductName") %></td>
                            <td><%# Eval("ProductCategory") %></td>
                            <td><%# Eval("Quantity") %></td>
                            <td><%# Eval("ItemPrice", "{0:C}") %></td>
                            <td><%# Eval("OrderDate", "{0:dd/MM/yyyy}") %></td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </div>
    </form>

</body>

<%-- Include footer --%>
<uc1:footer runat="server" />

</html>

