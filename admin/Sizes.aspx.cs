using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_Sizes : System.Web.UI.Page
{
  protected void Page_LoadComplete(object sender, EventArgs e)
  {
    if (!IsPostBack)
    {
      mvSizes.SetActiveView(vAll);
    }
    using (DBDataContext db = new DBDataContext())
    {
      lvSizes.DataSource = db.Sizes;
      lvSizes.DataBind();
    }
  }

  protected void Add(object sender, EventArgs e)
  {
    using (DBDataContext db = new DBDataContext())
    {
      Size size;
      int name = 0;
      int.TryParse(txtName.Text.Trim(), out name);
      if (Session["editingSize"] != null)
      {
        int id = (int)Session["editingSize"];
        size = db.Sizes.FirstOrDefault(S => S.ID == id);
        size.Name = name;
      }
      else
      {
        size = new Size();
        size.Name = name;
        db.Sizes.InsertOnSubmit(size);
      }
      db.SubmitChanges();
    }
    Session["editingSize"] = null;
    mvSizes.SetActiveView(vAll);
  }

  protected void EditSize(object sender, EventArgs e)
  {
    Session["editingSize"] = int.Parse(((Button)sender).CommandArgument);
    using (DBDataContext db = new DBDataContext())
    {
      int id = (int)Session["editingSize"];
      Size size = db.Sizes.FirstOrDefault(S => S.ID == id);
      if (size != null)
      {
        txtName.Text = size.Name.ToString();
      }
      else
      {
        mvSizes.SetActiveView(vAll);
        return;
      }
    }
    mvSizes.SetActiveView(vEdit);
  }

  protected void DeleteSize(object sender, EventArgs e)
  {
    int id = int.Parse(((Button)sender).CommandArgument);
    using (DBDataContext db = new DBDataContext())
    {
      Size size = db.Sizes.FirstOrDefault(S => S.ID == id);
      db.Sizes.DeleteOnSubmit(size);
      db.SubmitChanges();
    }
  }

  protected void Cancel(object sender, EventArgs e)
  {
    Session["editingSize"] = null;
    mvSizes.SetActiveView(vAll);
  }

  protected void AddSize(object sender, EventArgs e)
  {
    txtName.Text = "";
    mvSizes.SetActiveView(vEdit);
  }
}