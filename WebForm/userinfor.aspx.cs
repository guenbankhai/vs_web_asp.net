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
    public partial class userinfor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get UserId from Session
                if (Session["UserId"] != null)
                {
                    int userId = Convert.ToInt32(Session["UserId"]);

                    // Retrieve User Information
                    RetrieveUserInfo(userId);
                }
            }
        }

        private void RetrieveUserInfo(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT UserName, UserEmail, FullName, Gender, AddressInfo, PhoneNum FROM Users WHERE UserId = @UserId";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserId", userId);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();
                if (reader.Read())
                {
                    lblUserName.Text = "Tên đăng nhập: " + reader["UserName"].ToString();
                    lblUserEmail.Text = "Email: " + reader["UserEmail"].ToString();
                    lblFullName.Text = "Họ và tên: " + reader["FullName"].ToString();
                    lblGender.Text = "Giới tính: " + (Convert.ToBoolean(reader["Gender"]) ? "Nam" : "Nữ");
                    lblAddressInfo.Text = "Địa chỉ: " + reader["AddressInfo"].ToString();
                    lblPhoneNum.Text = "Số điện thoại: " + reader["PhoneNum"].ToString();
                }

                reader.Close();
            }
        }
    }
}