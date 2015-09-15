using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class Details : Cartable
{
  public Item _itm = null;
  public string category;
  public string size;
  public string rezba;
  public string Img;
  public Item Itm
  {
    get
    {
      int id = 0;
      if (_itm == null && int.TryParse(Request["id"], out id))
      {
        using (DBDataContext db = new DBDataContext())
        {
          _itm = db.Items.FirstOrDefault(I => I.ID == id);
          category = _itm.Category1.Name;
          size = _itm.Size.HasValue ? _itm.Size1.Name.ToString() + " мм" : "";
          rezba = _itm.Rezba.HasValue ? _itm.Rezba1.Name + "\"" : "";
          Img = _itm.Pics.Count > 0 ? _itm.Pics.First().path : "/img/items/no_item_image.png";
        }
      }
      return _itm;
    }
  }
  protected void Page_Load(object sender, EventArgs e)
  {
    using (DBDataContext db = new DBDataContext())
    {
      lvSupplemental.DataSource = from I in db.Items
                                  where I.Category == Itm.Category && I.ID != Itm.ID
                                  select I;
      lvSupplemental.DataBind();

      var data = from IMG in db.Pics
                 where IMG.ItemID == Itm.ID
                 select IMG;
      lvMainImages.DataSource = data;
      lvImages.DataSource = data;
      lvMainImages.DataBind();
      lvImages.DataBind();
    }
  }
}