using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebForm
{
    public partial class menu : System.Web.UI.UserControl
    {
        private void SetMenuBasedOnUserRole(string userRole)
        {
            if (userRole == "admin")
            {
                option1.HRef = "userinfor.aspx";
                option1.InnerText = "Thông tin tài khoản";
                option2.HRef = "listuser.aspx";
                option2.InnerText = "Danh sách khách hàng";
                option3.HRef = "listorder.aspx";
                option3.InnerText = "Danh sách đơn đặt hàng";
            }
            else if (userRole == "user")
            {
                option1.HRef = "index.aspx";
                option1.InnerText = "Danh sách sản phẩm";
                option2.HRef = "userinfor.aspx";
                option2.InnerText = "Thông tin tài khoản";
                option3.HRef = "cart.aspx";
                option3.InnerText = "Giỏ hàng";
                option4.HRef = "listorderuser.aspx";
                option4.InnerText = "Danh sách đơn đặt hàng";
            }
            else
            {
                // Default menu for unauthenticated or unspecified role
                option1.HRef = "index.aspx";
                option1.InnerText = "Danh sách sản phẩm";
                option2.HRef = "login.aspx";
                option2.InnerText = "Thông tin tài khoản";
                option3.HRef = "login.aspx";
                option3.InnerText = "Giỏ hàng";
                option4.HRef = "login.aspx";
                option4.InnerText = "Danh sách đơn đặt hàng";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserRole"] != null)
            {
                string userRole = Session["UserRole"].ToString();
                SetMenuBasedOnUserRole(userRole);
            }
            else
            {
                // Default menu for unauthenticated user (if UserRole is not set)
                SetMenuBasedOnUserRole(null);
            }
        }
    }
}
