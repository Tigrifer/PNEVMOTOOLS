using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_Lister : System.Web.UI.UserControl
{
  public int listerCount = 0;
  protected void Page_Load(object sender, EventArgs e)
  {
    using (DBDataContext db = new DBDataContext())
    {
      var data = (from I in db.Items
                  where I.UseInLister
                  select new
                  {
                    Description = I.Description,
                    Path = I.Pics.Count() > 0 ? I.Pics.FirstOrDefault().path : "/img/items/no_item_image.png",
                    ID = I.ID,
                    Name = I.Name,
                    Price = I.TotalPrice
                  });
      lvItems.DataSource = data;
      lvItems.DataBind();
      listerCount = data.Count();
    }
  }
}