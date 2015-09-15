using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_BillPrint : System.Web.UI.Page
{
  public int count = 1;
  public Order order;
  public double orderTotal = 0;
  protected void Page_Load(object sender, EventArgs e)
  {
    using (DBDataContext DB = new DBDataContext())
    {
      int id = int.Parse(Request["id"]);
      var od = (from OD in DB.OrderDetails
                where OD.OrderID == id
                select new
                {
                  Name = OD.Item.Name,
                  Count = OD.ItemCount,
                  Ed = "шт.",
                  Price = OD.PricePerItem,
                  Total = (OD.PricePerItem * OD.ItemCount)
                }).ToArray();
      foreach (var od_ in od)
        orderTotal += od_.Total;
      lvDetails.DataSource = od;
      lvDetails.DataBind();
      order = DB.Orders.FirstOrDefault(O => O.ID == id);
      orderTotal += order.DeliveryCost;
    }
  }
}