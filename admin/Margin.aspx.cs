using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_Margin : System.Web.UI.Page
{
  protected void Page_Load(object sender, EventArgs e)
  {
    if (!IsPostBack)
    {
      using (DBDataContext db = new DBDataContext())
      {
        ddlCatergories.DataSource = from C in db.Categories
                                    where C.ParentCategory.Value != 1
                                    orderby C.ParentCategory, C.SortOrder
                                    select new
                                    {
                                      C.ID,
                                      Name = string.Format("{0} - {1}", C.Category1.Name, C.Name)
                                    };
        ddlCatergories.DataValueField = "ID";
        ddlCatergories.DataTextField = "Name";
        ddlCatergories.DataBind();
        ddlCatergories.SelectedIndex = 0;
      }
      SetViewCategories(null, null);
    }
    ddlCatergories.SelectedIndexChanged += new EventHandler(ddlCatergories_SelectedIndexChanged);
    
  }

  void ddlCatergories_SelectedIndexChanged(object sender, EventArgs e)
  {
    SetViewCategories(null, null);
  }

  protected void SetViewCategories(object sender, EventArgs e)
  {
    mvMargin.SetActiveView(vCategories);
    using (DBDataContext db = new DBDataContext())
    {
      int id = int.Parse(ddlCatergories.SelectedValue);
      Item itm = db.Items.Where(I => I.Category == id).FirstOrDefault();
      if (itm != null)
      {
        ddlMarginType.ClearSelection();
        ddlMarginType.Items.FindByValue(itm.MarginType.ToString()).Selected = true;
        txtMargin.Text = itm.MarginValue.ToString();
        txtWholeMargin.Text = itm.WholeMarginValue.ToString();
        txtWholeMin.Text = itm.WholeMinCount.ToString();
      }
      else
      {
        ddlMarginType.SelectedIndex = 0;
        txtMargin.Text = "0";
        txtWholeMargin.Text = "0";
        txtWholeMin.Text = "0";
      }
    }
  }

  protected void SetViewItems(object sender, EventArgs e)
  {
    mvMargin.SetActiveView(vItems);
  }

  protected void SaveCategory(object sender, EventArgs e)
  {
    using (DBDataContext db = new DBDataContext())
    {
      Item[] items = db.Items.Where(I => I.Category == int.Parse(ddlCatergories.SelectedValue)).ToArray();
      foreach (Item itm in items)
      {
        itm.MarginType = byte.Parse(ddlMarginType.SelectedValue);
        itm.MarginValue = int.Parse(txtMargin.Text);
        itm.WholeMarginValue = int.Parse(txtWholeMargin.Text);
        itm.WholeMinCount = int.Parse(txtWholeMin.Text);
      }
      db.SubmitChanges();
    }
    SetViewCategories(null, null);
  }
}