<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="userinfor.aspx.cs" Inherits="WebForm.userinfor" %>

<%@ Register Src="topbar.ascx" TagPrefix="uc1" TagName="topbar" %>
<%@ Register Src="menu.ascx" TagPrefix="uc1" TagName="menu" %>
<%@ Register Src="footer.ascx" TagPrefix="uc1" TagName="footer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>User Information</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            padding: 20px;
        }

        .banner {
            width: 50%;
            margin: 50px auto;
        }

        .userContainer {
            width: 60%;
            margin: 20px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
            font-size: 16px;
            line-height: 1.6;
        }

        h2 {
            text-align: center;
        }

        .userInfoForm, {
            width: 90%;
            margin-top: 20px;
            padding: 20px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }

        .userInfoForm:hover{
            transform: scale(1.1);
        }

        .userInfoForm .label{
            font-weight: bold;
            font-size: 20px;
            margin-bottom: 10px;
        }

        .userInfoForm .infoText{
            margin-bottom: 10px;
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
        <img src="./img/banner-2.png" alt="Banner" style="width: 100%; height: 100%; object-fit: cover;">
    </div>

    <%-- Include user infor --%>
    <form id="form1" runat="server">
        <div class="userContainer">
            <h2>THÔNG TIN NGƯỜI DÙNG</h2>
            <div class="userInfoForm">
                <div class="infoText">
                    <asp:Label ID="lblUserName" runat="server" Text=""></asp:Label><br />
                    <asp:Label ID="lblUserEmail" runat="server" Text=""></asp:Label><br />
                    <asp:Label ID="lblFullName" runat="server" Text=""></asp:Label><br />
                    <asp:Label ID="lblGender" runat="server" Text=""></asp:Label><br />
                    <asp:Label ID="lblAddressInfo" runat="server" Text=""></asp:Label><br />
                    <asp:Label ID="lblPhoneNum" runat="server" Text=""></asp:Label><br />
                </div>
            </div>
        </div>
    </form>
</body>

<%-- Include menu --%>
<uc1:footer runat="server" />

</html>
