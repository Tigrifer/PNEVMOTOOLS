using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_Rezba : System.Web.UI.Page
{
  protected void Page_LoadComplete(object sender, EventArgs e)
  {
    if (!IsPostBack)
    {
      mvRezba.SetActiveView(vAll);
    }
    using (DBDataContext db = new DBDataContext())
    {
      lvSizes.DataSource = db.Rezbas;
      lvSizes.DataBind();
    }
  }

  protected void Add(object sender, EventArgs e)
  {
    using (DBDataContext db = new DBDataContext())
    {
      Rezba rezba;
      if (Session["editingSize"] != null)
      {
        int id = (int)Session["editingSize"];
        rezba = db.Rezbas.FirstOrDefault(S => S.ID == id);
        rezba.Name = txtName.Text.Trim();
      }
      else
      {
        rezba = new Rezba();
        rezba.Name = txtName.Text.Trim();
        db.Rezbas.InsertOnSubmit(rezba);
      }
      db.SubmitChanges();
    }
    Session["editingSize"] = null;
    mvRezba.SetActiveView(vAll);
  }

  protected void EditSize(object sender, EventArgs e)
  {
    Session["editingSize"] = int.Parse(((Button)sender).CommandArgument);
    using (DBDataContext db = new DBDataContext())
    {
      int id = (int)Session["editingSize"];
      Rezba rezba = db.Rezbas.FirstOrDefault(S => S.ID == id);
      if (rezba != null)
      {
        txtName.Text = rezba.Name.ToString();
      }
      else
      {
        mvRezba.SetActiveView(vAll);
        return;
      }
    }
    mvRezba.SetActiveView(vEdit);
  }

  protected void DeleteSize(object sender, EventArgs e)
  {
    int id = int.Parse(((Button)sender).CommandArgument);
    using (DBDataContext db = new DBDataContext())
    {
      Rezba rezba = db.Rezbas.FirstOrDefault(S => S.ID == id);
      db.Rezbas.DeleteOnSubmit(rezba);
      db.SubmitChanges();
    }
  }

  protected void Cancel(object sender, EventArgs e)
  {
    Session["editingSize"] = null;
    mvRezba.SetActiveView(vAll);
  }

  protected void AddSize(object sender, EventArgs e)
  {
    txtName.Text = "";
    mvRezba.SetActiveView(vEdit);
  }
}