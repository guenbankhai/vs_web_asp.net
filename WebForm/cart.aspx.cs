using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebForm
{
    public partial class cart : System.Web.UI.Page
    {
        private Dictionary<int, int> SelectedProducts
        {
            get
            {
                if (ViewState["SelectedProducts"] == null)
                {
                    ViewState["SelectedProducts"] = new Dictionary<int, int>();
                }
                return (Dictionary<int, int>)ViewState["SelectedProducts"];
            }
            set
            {
                ViewState["SelectedProducts"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {


            if (!IsPostBack)
            {
                LoadCartItems();
                LoadUserInfo();
            }
        }

        private int GetLoggedInUserId()
        {
            // Phương thức để lấy UserId của người dùng đã đăng nhập
            if (Session["UserId"] != null)
            {
                return Convert.ToInt32(Session["UserId"]);
            }
            return -1; // Trả về giá trị UserId không hợp lệ nếu chưa đăng nhập
        }

        private void LoadCartItems()
        {
            int userId = GetLoggedInUserId();
            if (userId != -1)
            {
                string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
                string query = @"SELECT p.ProductID, p.Name AS ProductName, c.Quantity, p.Price, p.Description AS ProductDescription, c.UserId, p.CategoryId, pi.Url AS ImageUrl, cat.Name AS CategoryName
                         FROM Cart c
                         INNER JOIN Products p ON c.ProductID = p.ProductID
                         INNER JOIN ProductImages pi ON p.ProductID = pi.ProductID
                         INNER JOIN Categories cat ON p.CategoryId = cat.CategoryId
                         WHERE c.UserId = @UserId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    try
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        rptCartItems.DataSource = reader;
                        rptCartItems.DataBind();

                        reader.Close();
                    }
                    catch (Exception ex)
                    {
                        // Xử lý lỗi
                        Console.WriteLine("Error: " + ex.Message);
                    }
                }
            }
        }

        protected void chkProduct_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;
            RepeaterItem item = (RepeaterItem)chk.NamingContainer;
            HiddenField hdnProductID = (HiddenField)item.FindControl("hdnProductID");
            HiddenField hdnQuantityID = (HiddenField)item.FindControl("hdnQuantityID");

            int productId = Convert.ToInt32(hdnProductID.Value);
            int quantity = Convert.ToInt32(hdnQuantityID.Value);

            if (chk.Checked)
            {
                // Thêm ProductID và Quantity vào danh sách đã lưu trữ
                if (!SelectedProducts.ContainsKey(productId))
                {
                    SelectedProducts.Add(productId, quantity);
                }
            }
            else
            {
                // Xóa ProductID khỏi danh sách đã lưu trữ (nếu tồn tại)
                if (SelectedProducts.ContainsKey(productId))
                {
                    SelectedProducts.Remove(productId);
                }
            }
        }



        private void LoadUserInfo()
        {
            int userId = GetLoggedInUserId();
            if (userId != -1)
            {
                string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
                string query = @"SELECT FullName, AddressInfo, PhoneNum FROM Users WHERE UserId = @UserId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    try
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            string fullName = reader["FullName"].ToString();
                            string addressInfo = reader["AddressInfo"].ToString();
                            string phoneNum = reader["PhoneNum"].ToString();

                            // Hiển thị thông tin người dùng trực tiếp trên giao diện
                            userInfo.InnerHtml = $"<div>Họ và tên: {fullName}</div><div>Địa chỉ: {addressInfo}</div><div>Số điện thoại: {phoneNum}</div>";
                        }

                        reader.Close();
                    }
                    catch (Exception ex)
                    {
                        // Xử lý lỗi
                        Console.WriteLine("Error: " + ex.Message);
                    }
                }
            }
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            int userId = GetLoggedInUserId();
            if (userId != -1)
            {
                // Kiểm tra xem có sản phẩm nào được chọn không
                if (SelectedProducts.Count == 0)
                {
                    // Hiển thị thông báo cho người dùng nếu không có sản phẩm nào được chọn
                    ScriptManager.RegisterStartupScript(this, GetType(), "NoProductSelectedAlert",
                        "alert('Vui lòng chọn ít nhất một sản phẩm để đặt hàng.');", true);
                    return;
                }

                string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;

                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();

                        SqlTransaction transaction = conn.BeginTransaction();

                        try
                        {
                            foreach (var selectedProduct in SelectedProducts)
                            {
                                int productId = selectedProduct.Key;
                                int quantity = selectedProduct.Value;

                                // Tạo đơn hàng mới cho từng sản phẩm được chọn
                                int newOrderId;
                                string getMaxOrderIdQuery = "SELECT ISNULL(MAX(OrderID), 0) FROM Orders";
                                SqlCommand getMaxOrderIdCmd = new SqlCommand(getMaxOrderIdQuery, conn, transaction);
                                int maxOrderId = Convert.ToInt32(getMaxOrderIdCmd.ExecuteScalar());
                                newOrderId = maxOrderId + 1;

                                string insertOrderQuery = @"
                            INSERT INTO Orders (OrderID, UserId, CreatedAt, OrderStatusID, ShippingCost, Tax, Discount)
                            VALUES (@OrderID, @UserId, @CreatedAt, @OrderStatusID, @ShippingCost, @Tax, @Discount)";

                                SqlCommand insertOrderCmd = new SqlCommand(insertOrderQuery, conn, transaction);
                                insertOrderCmd.Parameters.AddWithValue("@OrderID", newOrderId);
                                insertOrderCmd.Parameters.AddWithValue("@UserId", userId);
                                insertOrderCmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                                insertOrderCmd.Parameters.AddWithValue("@OrderStatusID", 1); // OrderStatusID = 1 for pending confirmation
                                insertOrderCmd.Parameters.AddWithValue("@ShippingCost", 15.00m);
                                insertOrderCmd.Parameters.AddWithValue("@Tax", 0.05m);
                                insertOrderCmd.Parameters.AddWithValue("@Discount", 50.00m);

                                insertOrderCmd.ExecuteNonQuery();

                                // Lấy thông tin giá của sản phẩm
                                decimal price;
                                string getProductPriceQuery = "SELECT Price FROM Products WHERE ProductID = @ProductID";
                                SqlCommand getProductPriceCmd = new SqlCommand(getProductPriceQuery, conn, transaction);
                                getProductPriceCmd.Parameters.AddWithValue("@ProductID", productId);
                                price = Convert.ToDecimal(getProductPriceCmd.ExecuteScalar());

                                decimal calculatedPrice = quantity * (price + (price * 0.05m) - 50.00m) + 15.00m;

                                // Thêm chi tiết đơn hàng (OrderItems) cho sản phẩm hiện tại
                                string insertOrderItemQuery = @"
                            INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price)
                            VALUES (@OrderID, @ProductID, @Quantity, @Price)";

                                SqlCommand insertOrderItemCmd = new SqlCommand(insertOrderItemQuery, conn, transaction);
                                insertOrderItemCmd.Parameters.AddWithValue("@OrderID", newOrderId);
                                insertOrderItemCmd.Parameters.AddWithValue("@ProductID", productId);
                                insertOrderItemCmd.Parameters.AddWithValue("@Quantity", quantity);
                                insertOrderItemCmd.Parameters.AddWithValue("@Price", calculatedPrice);

                                insertOrderItemCmd.ExecuteNonQuery();
                            }

                            // Xoá các sản phẩm đã chọn khỏi giỏ hàng (Cart)
                            string deleteCartItemsQuery = @"
                        DELETE FROM Cart
                        WHERE UserId = @UserId AND ProductID IN (" + string.Join(",", SelectedProducts.Keys) + ")";

                            SqlCommand deleteCartItemsCmd = new SqlCommand(deleteCartItemsQuery, conn, transaction);
                            deleteCartItemsCmd.Parameters.AddWithValue("@UserId", userId);

                            int rowsDeleted = deleteCartItemsCmd.ExecuteNonQuery();

                            // Commit transaction nếu thành công
                            transaction.Commit();

                            // Hiển thị thông báo thành công
                            ScriptManager.RegisterStartupScript(this, GetType(), "OrderSuccessAlert",
                                "alert('Đặt hàng thành công!');", true);

                            // Refresh giỏ hàng sau khi đặt hàng
                            LoadCartItems();
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();

                            // Hiển thị thông báo lỗi
                            ScriptManager.RegisterStartupScript(this, GetType(), "OrderErrorAlert",
                                "alert('Đặt hàng thất bại. Lỗi: " + ex.Message + "');", true);
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Xử lý lỗi kết nối cơ sở dữ liệu
                    ScriptManager.RegisterStartupScript(this, GetType(), "DatabaseErrorAlert",
                        "alert('Đã xảy ra lỗi kết nối đến cơ sở dữ liệu. Vui lòng thử lại sau.');", true);
                }
            }
        }




        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (SelectedProducts.Count > 0)
            {
                string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;

                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();

                        string deleteQuery = @"
                    DELETE FROM Cart
                    WHERE UserId = @UserId AND ProductID IN (" + string.Join(",", SelectedProducts.Keys) + ")";

                        SqlCommand cmd = new SqlCommand(deleteQuery, conn);
                        cmd.Parameters.AddWithValue("@UserId", GetLoggedInUserId());

                        int rowsDeleted = cmd.ExecuteNonQuery();

                        if (rowsDeleted > 0)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "DeleteSuccessAlert",
                                "alert('Xoá thành công " + rowsDeleted + " sản phẩm khỏi giỏ hàng.');", true);

                            LoadCartItems();
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "DeleteFailureAlert",
                                "alert('Xoá thất bại. Không có sản phẩm nào được xoá.');", true);
                        }
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "DeleteErrorAlert",
                        "alert('Xoá thất bại. Lỗi: " + ex.Message + "');", true);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "NoProductsSelectedAlert",
                    "alert('Vui lòng chọn ít nhất một sản phẩm để xoá.');", true);
            }
        }

    }
}
