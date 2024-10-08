using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebForm
{
    public partial class login : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string query = "SELECT UserRole, UserName, UserId FROM Users WHERE UserName = @Username AND UserPassword = @Password";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@Username", username);
                command.Parameters.AddWithValue("@Password", password);

                SqlDataReader reader = command.ExecuteReader();
                if (reader.Read())
                {
                    string userRole = reader.GetString(0);
                    string userName = reader.GetString(1);
                    int userID = reader.GetInt32(2);

                    // Lưu thông tin người dùng vào Session
                    Session["UserRole"] = userRole;
                    Session["UserName"] = userName;
                    Session["UserId"] = userID;


                    // Đăng nhập thành công, chuyển hướng đến trang chính của ứng dụng
                    Response.Redirect("index.aspx");
                }
                else
                {
                    // Đăng nhập không thành công, hiển thị thông báo lỗi
                    lblErrorMessage.Text = "Tên đăng nhập hoặc mật khẩu không chính xác.";
                }

                reader.Close();
            }
        }
    }
}