using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_Categories : System.Web.UI.UserControl
{
  protected void Page_Load(object sender, EventArgs e)
    {
      using (DBDataContext DB = new DBDataContext())
      {
        lvCategories.DataSource = from C in DB.Categories where C.ID != 1 && C.ParentCategory == 1 orderby C.SortOrder select new 
        {
          C.Categories,
          C.ID,
          C.Name,
          Count = GetCategoryCount(C.Categories.ToArray())
        };
        lvCategories.DataBind();
      }
    }

  private int GetCategoryCount(Category[] cats)
  {
    int res = 0;
    foreach(Category c in cats)
    {
      res += c.Items.Count;
    }
    return res;
  }
}