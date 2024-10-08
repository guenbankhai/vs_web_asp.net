using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WebForm
{
    public partial class listorder : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadOrdersByStatus(1, rptOrders1); // Load orders with OrderStatusID = 1 (Pending confirmation)
                LoadOrdersByStatus(2, rptOrders2); // Load orders with OrderStatusID = 2 (Being delivered)
                LoadOrdersByStatus(3, rptOrders3); // Load orders with OrderStatusID = 3 (Successfully delivered)
            }
        }

        private void LoadOrdersByStatus(int orderStatusID, Repeater repeater)
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
                WHERE Orders.OrderStatusID = @OrderStatusID";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
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
                    case "ConfirmOrder":
                        UpdateOrderStatus(orderID, 2); // Change OrderStatusID to 2 (Being delivered)
                        break;
                    case "DeliverOrder":
                        UpdateOrderStatus(orderID, 3); // Change OrderStatusID to 3 (Successfully delivered)
                        break;
                    case "DeleteOrder":
                        DeleteOrder(orderID); // Delete order and related items
                        break;
                    default:
                        break;
                }

                // Reload data after action
                LoadOrdersByStatus(1, rptOrders1); // Reload Pending confirmation orders
                LoadOrdersByStatus(2, rptOrders2); // Reload Being delivered orders
                LoadOrdersByStatus(3, rptOrders3); // Reload Successfully delivered orders
            }
        }

        private void UpdateOrderStatus(int orderID, int newStatusID)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
            string query = "UPDATE Orders SET OrderStatusID = @NewStatusID WHERE OrderID = @OrderID";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@NewStatusID", newStatusID);
                cmd.Parameters.AddWithValue("@OrderID", orderID);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    // Success message
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Xác nhận thành công.');", true);
                }
                catch (Exception ex)
                {
                    // Error message
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Xác nhận thất bại: {ex.Message}');", true);
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
