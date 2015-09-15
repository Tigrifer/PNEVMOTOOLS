using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_ItemContainer : System.Web.UI.UserControl
{
  protected void Page_Load(object sender, EventArgs e)
  {
    using (DBDataContext DB = new DBDataContext())
    {
      int p = 0;
      if (string.IsNullOrEmpty(Request["p"]) || !int.TryParse(Request["p"], out p))
      {
        lvItems.DataSource = (from C in DB.Items
                              select new
                              {
                                ID = C.ID,
                                Name = C.Name,
                                Size = C.Size.HasValue ? C.Size1.Name.ToString() : "",
                                Rezba = C.Rezba.HasValue ? C.Rezba1.Name : "",
                                C.Description,
                                Img = C.Pics.Count > 0 ? C.Pics.First().path : "/img/items/no_item_image.png",
                                Price = C.TotalPrice,
                                Weight = C.Weight,
                                ShortDescription = ReplaceBreaks(C.ShortDescription),
                                WholeMinCount = C.WholeMinCount,
                                WholePrice = C.TotalWholePrice
                              }).ToArray().Take(12);
      }
      else
      {
        h4ShowAll.Visible = false;
        lvItems.DataSource = (from C in DB.Items
                              where C.Category1.ParentCategory.HasValue && C.Category1.ParentCategory.Value == p
                              select new
                              {
                                ID = C.ID,
                                Name = C.Name,
                                Size = C.Size.HasValue ? C.Size1.Name.ToString() : "",
                                Rezba = C.Rezba.HasValue ? C.Rezba1.Name : "",
                                C.Description,
                                Img = C.Pics.Count > 0 ? C.Pics.First().path : "/img/items/no_item_image.png",
                                Price = C.TotalPrice,
                                Weight = C.Weight,
                                ShortDescription = ReplaceBreaks(C.ShortDescription),
                                WholeMinCount = C.WholeMinCount,
                                WholePrice = C.TotalWholePrice
                              }).ToArray();
      }
      lvItems.DataBind();
    }
  }

  private string ReplaceBreaks(string shortDescription)
  {
    return string.IsNullOrEmpty(shortDescription) ? "" : shortDescription.Replace("\n", "<br/>");
  }
}