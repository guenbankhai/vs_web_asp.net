using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebForm
{
    public partial class listorderuser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Load orders for the logged-in user
                if (Session["UserId"] != null && Session["UserId"] is int userId)
                {
                    LoadOrdersByUserAndStatus(userId, 1, rptOrders1);
                    LoadOrdersByUserAndStatus(userId, 2, rptOrders2);
                    LoadOrdersByUserAndStatus(userId, 3, rptOrders3);
                }
            }
        }

        private void LoadOrdersByUserAndStatus(int userId, int orderStatusID, Repeater repeater)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
            string query = @"
        SELECT 
            Orders.OrderID,
            Users.FullName AS UserName,
            Users.AddressInfo,
            Users.PhoneNum,
            Products.Name AS ProductName,
            Categories.Name AS ProductCategory,
            OrderItems.Quantity,
            OrderItems.Price AS ItemPrice,
            Orders.CreatedAt AS OrderDate
        FROM Orders
        INNER JOIN Users ON Orders.UserId = Users.UserId
        INNER JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID
        INNER JOIN Products ON OrderItems.ProductID = Products.ProductID
        INNER JOIN Categories ON Products.CategoryId = Categories.CategoryId
        WHERE Orders.UserId = @UserId AND Orders.OrderStatusID = @OrderStatusID";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@OrderStatusID", orderStatusID);

                try
                {
                    conn.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    adapter.Fill(ds);

                    repeater.DataSource = ds;
                    repeater.DataBind();
                }
                catch (Exception ex)
                {
                    // Handle error
                    Console.WriteLine("Error: " + ex.Message);
                }
            }
        }

        protected void ActionCommand(object sender, CommandEventArgs e)
        {
            int orderID;
            if (int.TryParse(e.CommandArgument.ToString(), out orderID))
            {
                string action = e.CommandName;
                switch (action)
                {
                    case "DeleteOrder":
                        DeleteOrder(orderID); // Delete order and related items
                        break;
                    default:
                        break;
                }

                // Reload data after action
                if (Session["UserId"] != null && Session["UserId"] is int userId)
                {
                    LoadOrdersByUserAndStatus(userId, 1, rptOrders1); // Reload pending confirmation orders
                }
            }
        }

        private void DeleteOrder(int orderID)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
            string queryItems = "DELETE FROM OrderItems WHERE OrderID = @OrderID";
            string queryOrder = "DELETE FROM Orders WHERE OrderID = @OrderID";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmdItems = new SqlCommand(queryItems, conn);
                SqlCommand cmdOrder = new SqlCommand(queryOrder, conn);
                cmdItems.Parameters.AddWithValue("@OrderID", orderID);
                cmdOrder.Parameters.AddWithValue("@OrderID", orderID);

                try
                {
                    conn.Open();
                    // Delete related items first
                    cmdItems.ExecuteNonQuery();
                    // Then delete the order
                    cmdOrder.ExecuteNonQuery();
                    // Success message
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Xoá đơn hàng thành công.');", true);
                }
                catch (Exception ex)
                {
                    // Error message
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Xoá đơn hàng thất bại: {ex.Message}');", true);
                }
            }
        }

    }
}