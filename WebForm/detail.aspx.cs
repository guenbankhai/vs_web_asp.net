using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace WebForm
{
    public partial class detail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Kiểm tra xem có tham số ProductId trên URL hay không
                if (Request.QueryString["ProductId"] != null)
                {
                    string productId = Request.QueryString["ProductId"];

                    // Gọi phương thức để tải thông tin sản phẩm từ cơ sở dữ liệu
                    LoadProductDetails(productId);

                    BindProducts(productId);

                    // Kiểm tra xem sản phẩm có trong giỏ hàng của người dùng hay không
                    if (Session["UserId"] != null)
                    {
                        int userId = Convert.ToInt32(Session["UserId"]);
                        bool productInCart = CheckProductInCart(userId, productId);

                        if (productInCart)
                        {
                            // Nếu sản phẩm đã có trong giỏ hàng, cập nhật nút Add to Cart
                            btnAddToCart.CssClass = "cartButtonDisabled";
                            btnAddToCart.Text = "Đã có trong giỏ";
                            btnAddToCart.Enabled = false;
                        }
                    }
                }
            }
        }

        protected bool CheckProductInCart(int userId, string productId)
        {
            bool productInCart = false;
            string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Cart WHERE UserId = @UserId AND ProductID = @ProductId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@ProductId", productId);

                conn.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());
                if (count > 0)
                {
                    productInCart = true;
                }
            }

            return productInCart;
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                // Nếu Session UserId không có dữ liệu, chuyển hướng sang trang đăng nhập
                Response.Redirect("login.aspx");
                return;
            }

            // Lấy UserId từ Session
            int userId = Convert.ToInt32(Session["UserId"]);

            // Lấy ProductId từ QueryString
            if (Request.QueryString["ProductId"] != null)
            {
                int productId;
                if (int.TryParse(Request.QueryString["ProductId"], out productId))
                {
                    // Lấy Quantity từ input
                    int quantity;
                    if (int.TryParse(inputQuantity.Value, out quantity) && quantity > 0)
                    {
                        // Thực hiện thêm sản phẩm vào giỏ hàng (bảng Cart)
                        string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
                        using (SqlConnection conn = new SqlConnection(connectionString))
                        {
                            string query = "INSERT INTO Cart (UserId, ProductID, Quantity) VALUES (@UserId, @ProductId, @Quantity)";
                            SqlCommand cmd = new SqlCommand(query, conn);
                            cmd.Parameters.AddWithValue("@UserId", userId);
                            cmd.Parameters.AddWithValue("@ProductId", productId);
                            cmd.Parameters.AddWithValue("@Quantity", quantity);

                            try
                            {
                                conn.Open();
                                int rowsAffected = cmd.ExecuteNonQuery();
                                if (rowsAffected > 0)
                                {
                                    // Thêm vào giỏ hàng thành công
                                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Thêm vào giỏ hàng thành công');", true);

                                    // Cập nhật trạng thái của nút btnAddToCart và hiển thị thông tin đã có trong giỏ hàng
                                    btnAddToCart.CssClass = "cartButtonDisabled";
                                    btnAddToCart.Text = "Đã có trong giỏ";
                                    btnAddToCart.Enabled = false;
                                }
                                else
                                {
                                    // Thêm vào giỏ hàng thất bại
                                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Thêm vào giỏ hàng thất bại');", true);
                                }
                            }
                            catch (SqlException ex)
                            {
                                // Xử lý lỗi khi thêm vào giỏ hàng
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('Thêm vào giỏ hàng thất bại: {ex.Message}');", true);
                            }
                            finally
                            {
                                conn.Close();
                            }
                        }
                    }
                    else
                    {
                        // Hiển thị thông báo khi Quantity không hợp lệ
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Số lượng không hợp lệ');", true);
                    }
                }
                else
                {
                    // Hiển thị thông báo khi ProductId không hợp lệ
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('ProductId không hợp lệ');", true);
                }
            }
            else
            {
                // Hiển thị thông báo khi không có ProductId trên URL
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Không tìm thấy sản phẩm');", true);
            }
        }



        private void LoadProductDetails(string productId)
        {
            // Tải thông tin chi tiết của sản phẩm từ cơ sở dữ liệu và hiển thị trên giao diện
            string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT p.ProductId, p.Name, p.Description, p.Price, pi.Url FROM Products p INNER JOIN ProductImages pi ON p.ProductId = pi.ProductId WHERE p.ProductId = @ProductId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ProductId", productId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblProductName.InnerText = reader["Name"].ToString();
                    lblProductDescription.InnerText = reader["Description"].ToString();
                    lblProductPrice.InnerText = string.Format("{0:C}", reader["Price"]);
                    imgProductDetail.Src = reader["Url"].ToString();
                }
                reader.Close();
            }
        }

        private void BindProducts(string productId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
            string query = "SELECT p.ProductId, p.Name, p.Price, pi.Url FROM Products p INNER JOIN ProductImages pi ON p.ProductId = pi.ProductId WHERE p.ProductId <> @ProductId AND p.CategoryId = (SELECT CategoryId FROM Products WHERE ProductId = @ProductId)";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@ProductId", productId); // Thêm tham số ProductId vào câu truy vấn
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                DataTable dataTable = new DataTable();

                try
                {
                    connection.Open();
                    adapter.Fill(dataTable);

                    // Bind data to product list control (e.g., Repeater, DataList, GridView)
                    productList.DataSource = dataTable;
                    productList.DataBind();
                }
                catch (SqlException ex)
                {
                    // Xử lý lỗi kết nối hoặc truy vấn
                    Console.WriteLine("Error: " + ex.Message);
                }
                finally
                {
                    connection.Close();
                }
            }
        }

        protected void btnDetails_Command(object sender, CommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);
            Response.Redirect($"detail.aspx?ProductId={productId}");
        }

    }
}
