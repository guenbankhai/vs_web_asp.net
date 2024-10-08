using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebForm
{
    public partial class listuser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindUserData();
            }
        }

        private void BindUserData()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT UserId, UserName, UserEmail, FullName, Gender, AddressInfo, PhoneNum FROM Users WHERE UserRole = 'user'", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                con.Open();
                da.Fill(dt);
                con.Close();

                rptUsers.DataSource = dt;
                rptUsers.DataBind();
            }
        }

        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteUser")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    SqlTransaction transaction = con.BeginTransaction();

                    try
                    {
                        // Check and delete related data in Orders table
                        SqlCommand cmdOrders = new SqlCommand("DELETE FROM Orders WHERE UserId = @UserId", con, transaction);
                        cmdOrders.Parameters.AddWithValue("@UserId", userId);
                        cmdOrders.ExecuteNonQuery();

                        // Check and delete related data in Cart table
                        SqlCommand cmdCart = new SqlCommand("DELETE FROM Cart WHERE UserId = @UserId", con, transaction);
                        cmdCart.Parameters.AddWithValue("@UserId", userId);
                        cmdCart.ExecuteNonQuery();

                        // Finally, delete the user from Users table
                        SqlCommand cmdDeleteUser = new SqlCommand("DELETE FROM Users WHERE UserId = @UserId", con, transaction);
                        cmdDeleteUser.Parameters.AddWithValue("@UserId", userId);
                        cmdDeleteUser.ExecuteNonQuery();

                        // Commit transaction if all commands succeed
                        transaction.Commit();

                        // Rebind data after deletion
                        BindUserData();

                        // Display success message
                        ScriptManager.RegisterStartupScript(this, GetType(), "deleteSuccess", "alert('Xoá tài khoản khách hàng thành công.');", true);
                    }
                    catch (Exception ex)
                    {
                        // Roll back the transaction if any command fails
                        transaction.Rollback();

                        // Display error message
                        ScriptManager.RegisterStartupScript(this, GetType(), "deleteError", $"alert('Xoá tài khoản khách hàng thất bại: {ex.Message}');", true);
                    }
                    finally
                    {
                        con.Close();
                    }
                }
            }
        }
    }
}
