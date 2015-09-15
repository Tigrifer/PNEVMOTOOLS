using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_SalesReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
      using (DBDataContext db = new DBDataContext())
      {
        lvReport.DataSource = (from I in db.OrderDetails
                               select new
                               {
                                 ID = I.ID,
                                 OrderID=I.OrderID,
                                 Name = I.Item.Name,
                                 Description = I.Item.Description,
                                 Count = I.ItemCount,
                                 PricePerItem = I.PricePerItem,
                                 TotalPrice = I.PricePerItem*I.ItemCount,
                                 Date = I.Order.CreatedOn
                               });
        lvReport.DataBind();
      }
    }
}