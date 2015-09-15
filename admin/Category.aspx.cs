using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class admin_Category : System.Web.UI.Page
{
  public string message;
  protected void Page_LoadComplete(object sender, EventArgs e)
  {
    using (DBDataContext db = new DBDataContext())
    {
      lvMainCategories.DataSource = from C in db.Categories
                                    where C.ParentCategory == 1 && C.ID != 1
                                    orderby C.SortOrder
                                    select new
                                    {
                                      C.ID,
                                      C.Name,
                                      Categories = C.Categories.OrderBy(sC => sC.SortOrder)
                                    };
      lvMainCategories.DataBind();
    }
  }

  protected void Up(object sender, EventArgs e)
  {
    int id = int.Parse(((Button)sender).CommandArgument);
    using (DBDataContext db = new DBDataContext())
    {
      Category c = db.Categories.FirstOrDefault(C => C.ID == id);
      int tmp = c.SortOrder;
      Category prev = db.Categories.OrderByDescending(C => C.SortOrder).FirstOrDefault(C => C.ParentCategory == c.ParentCategory && C.SortOrder < c.SortOrder);
      if (prev == null)
        c.SortOrder--;
      else
      {
        c.SortOrder = prev.SortOrder;
        prev.SortOrder = tmp;
      }
      db.SubmitChanges();
      Response.Redirect("/admin/Category.aspx?id=" + c.ParentCategory);
    }
  }
  protected void Down(object sender, EventArgs e)
  {
    int id = int.Parse(((Button)sender).CommandArgument);
    using (DBDataContext db = new DBDataContext())
    {
      Category c = db.Categories.FirstOrDefault(C => C.ID == id);
      int tmp = c.SortOrder;
      Category prev = db.Categories.OrderBy(C => C.SortOrder).FirstOrDefault(C => C.ParentCategory == c.ParentCategory && C.SortOrder > c.SortOrder);
      if (prev == null)
        c.SortOrder--;
      else
      {
        c.SortOrder = prev.SortOrder;
        prev.SortOrder = tmp;
      }
      db.SubmitChanges();
      Response.Redirect("/admin/Category.aspx?id=" + c.ParentCategory);
    }
  }

  protected void DeleteCategory(object sender, EventArgs e)
  {
    try
    {
      int id = int.Parse(((Button)sender).CommandArgument);
      using (DBDataContext db = new DBDataContext())
      {
        Category c = db.Categories.FirstOrDefault(C => C.ID == id);
        db.Categories.DeleteAllOnSubmit(c.Categories);
        db.Categories.DeleteOnSubmit(c);
        db.SubmitChanges();
      }
    }
    catch (Exception ex) { message = string.Format("Невозможно удалить категорию. {0}", ex.Message); }
    message = "";
  }

  [WebMethod]
  public static string UpdateCategoryName(int id, string newName)
  {
    using (DBDataContext db = new DBDataContext())
    {
      Category cat = db.Categories.FirstOrDefault(C => C.ID == id);
      cat.Name = newName;
      db.SubmitChanges();
    }
    return newName;
  }

  [WebMethod]
  public static void AddCategory(int parentID, string name)
  {
    using (DBDataContext db = new DBDataContext())
    {
      Category cat = new Category();
      cat.ParentCategory = parentID;
      cat.Name = name;
      db.Categories.InsertOnSubmit(cat);
      db.SubmitChanges();
    }
  }
}