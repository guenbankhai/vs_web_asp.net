using System;
using System.Web.UI.WebControls;

namespace WebForm
{
    public partial class topbar : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUserInfo();
            }
        }

        private void LoadUserInfo()
        {
            if (Session["UserRole"] != null && Session["UserName"] != null)
            {
                string userRole = (string)Session["UserRole"];
                string userName = (string)Session["UserName"];

                // Hiển thị nút đăng xuất và thông tin người dùng nếu đã đăng nhập
                LoginLogoutLink.InnerHtml = "<a href='login.aspx'>Đăng xuất</a>";

                UserInfoLiteral.Text = $"<a href=''>{userRole} - {userName}</a>"; // Link tới trang thông tin người dùng
            }
            else
            {
                // Hiển thị nút đăng nhập nếu chưa đăng nhập
                LoginLogoutLink.InnerHtml = "<a href='login.aspx'>Đăng nhập</a>";
            }
        }
    }
}
