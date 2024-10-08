using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebForm
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Lấy tham số category từ URL nếu có
                if (!string.IsNullOrEmpty(Request.QueryString["category"]))
                {
                    int categoryId;
                    if (int.TryParse(Request.QueryString["category"], out categoryId))
                    {
                        BindProductsByCategory(categoryId);
                    }
                    else
                    {
                        // Xử lý nếu categoryId không hợp lệ (ví dụ: không phải là số)
                        // Mặc định hiển thị sản phẩm của Đồng hồ nam
                        BindProductsByCategory(1);
                    }
                }
                else
                {
                    // Mặc định hiển thị sản phẩm của Đồng hồ nam
                    BindProductsByCategory(1);
                }
            }
        }


        private void BindProductsByCategory(int categoryId)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
            string query = "SELECT p.ProductId, p.Name, p.Price, pi.Url FROM Products p " +
                           "INNER JOIN ProductImages pi ON p.ProductId = pi.ProductId " +
                           "WHERE p.CategoryId = @CategoryId";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@CategoryId", categoryId);
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                DataTable dataTable = new DataTable();

                adapter.Fill(dataTable);

                // Bind data to product list control (e.g., Repeater, DataList, GridView)
                productList.DataSource = dataTable;
                productList.DataBind();
            }
        }

        protected void btnDetails_Command(object sender, CommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);
            Response.Redirect($"ProductDetail.aspx?ProductId={productId}");
        }
    }
}