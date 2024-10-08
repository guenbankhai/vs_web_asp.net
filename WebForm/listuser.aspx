<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="listuser.aspx.cs" Inherits="WebForm.listuser" %>

<%@ Register Src="topbar.ascx" TagPrefix="uc1" TagName="topbar" %>
<%@ Register Src="menu.ascx" TagPrefix="uc1" TagName="menu" %>
<%@ Register Src="footer.ascx" TagPrefix="uc1" TagName="footer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Danh sách khách hàng</title>
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
            <h2>DANH SÁCH KHÁCH HÀNG</h2>
            <table>
                <tr>
                    <th>Tên đăng nhập</th>
                    <th>Email</th>
                    <th>Họ và tên</th>
                    <th>Giới tính</th>
                    <th>Địa chỉ</th>
                    <th>Số điện thoại</th>
                    <th>Action</th>
                </tr>
<asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
    <ItemTemplate>
        <tr>
            <td><%# Eval("UserName") %></td>
            <td><%# Eval("UserEmail") %></td>
            <td><%# Eval("FullName") %></td>
            <td><%# Convert.ToBoolean(Eval("Gender")) ? "Nam" : "Nữ" %></td>
            <td><%# Eval("AddressInfo") %></td>
            <td><%# Eval("PhoneNum") %></td>
            <td>
                <asp:Button runat="server" Text="Xoá" CssClass="action-button" CommandName="DeleteUser" CommandArgument='<%# Eval("UserId") %>' />
            </td>
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
