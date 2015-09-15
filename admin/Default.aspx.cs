using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.IO;
using System.Drawing;

public partial class admin_Default : System.Web.UI.Page
{
  protected void Page_LoadComplete(object sender, EventArgs e)
  {
    if (!IsPostBack)
    {
      mvItems.SetActiveView(vView);
      BindDDLists();
    }
    int id=0;
    if (int.TryParse(Request["id"], out id))
      Edit(id);
  }

  protected void Delete(object sender, EventArgs e)
  {
    int id = 0;
    if (int.TryParse(((Button)sender).CommandArgument, out id))
    {
      using (DBDataContext db = new DBDataContext())
      {
        Item itm = db.Items.FirstOrDefault(I => I.ID == id);
        if (itm != null)
        {
          db.Pics.DeleteAllOnSubmit(db.Pics.Where(P => P.ItemID == itm.ID));
          db.Items.DeleteOnSubmit(itm);
          db.SubmitChanges();
        }
      }
    }
  }

  protected void Edit(int id)
  {
    using (DBDataContext db = new DBDataContext())
    {
      Item itm = db.Items.FirstOrDefault(I => I.ID == id);
      if (itm != null)
      {
        txtDescription.Text = itm.Description.Trim();
        txtShortDescription.Text = itm.ShortDescription;
        txtName.Text = itm.Name.Trim();
        txtPrice.Text = itm.Price.ToString();
        txtWeight.Text = itm.Weight.ToString();
        ddlCategory.ClearSelection();
        ddlCategory.Items.FindByValue(itm.Category.ToString()).Selected = true;
        ddlRez.ClearSelection();
        if (itm.Rezba.HasValue)
          ddlRez.Items.FindByValue(itm.Rezba.ToString()).Selected = true;
        ddlSize.ClearSelection();
        if (itm.Size.HasValue)
          ddlSize.Items.FindByValue(itm.Size.ToString()).Selected = true;
        lvImages.DataSource = itm.Pics;
        lvImages.DataBind();
        lblItemsCount.Text = itm.IncomeOrders.Sum(IO => IO.ItemsLeft).ToString();
        txtIncomePricePerItem.Text = ((int)Math.Round(itm.Price * Cart.Currency)).ToString();
      }
      else
        Response.Redirect("/admin/Default.aspx");
    }
    mvItems.SetActiveView(vEdit);
  }

  protected void ShowAddNewForm(object sender, EventArgs e)
  {
    mvItems.SetActiveView(vEdit);
    ddlCategory.ClearSelection();
    ddlRez.ClearSelection();
    ddlSize.ClearSelection();
    txtShortDescription.Text = "";
    txtDescription.Text = "";
    txtName.Text = "";
    txtPrice.Text = "";
    txtWeight.Text = "";
  }

  protected void OnAdd(object sender, EventArgs e)
  {
    using (DBDataContext db = new DBDataContext())
    {
      Item itm;
      bool isInsertNew = true;
      int id = 0;
      if (int.TryParse(Request["id"], out id))
      {
        isInsertNew = false;
        itm = db.Items.FirstOrDefault(I => I.ID == id);
        if (itm == null)
          Response.Redirect("/admin/Defauilt.aspx");
      }
      else
        itm = new Item();
      itm.Category = int.Parse(ddlCategory.SelectedValue);
      itm.Description = txtDescription.Text.Trim();
      itm.ShortDescription = txtShortDescription.Text.Length > 128 ? txtShortDescription.Text.Substring(0, 128).Trim() : txtShortDescription.Text.Trim();
      itm.Name = txtName.Text.Trim();
      itm.Price = double.Parse(txtPrice.Text.Trim().Replace(".", ","));
      if (ddlRez.SelectedValue != "-1")
        itm.Rezba = int.Parse(ddlRez.SelectedValue);
      else
        itm.Rezba = null;
      if (ddlSize.SelectedValue != "-1")
        itm.Size = int.Parse(ddlSize.SelectedValue);
      else
        itm.Size = null;
      int weight=0;
      if (int.TryParse(txtWeight.Text.Trim(), out weight))
        itm.Weight = weight;
      if (isInsertNew)
        db.Items.InsertOnSubmit(itm);
      db.SubmitChanges();
      if (fuFile1.HasFile)
        TrySavePicture(fuFile1.FileName, fuFile1.FileContent, itm.ID, db);
      if (fuFile2.HasFile)
        TrySavePicture(fuFile2.FileName, fuFile2.FileContent, itm.ID, db);
      if (fuFile3.HasFile)
        TrySavePicture(fuFile3.FileName, fuFile3.FileContent, itm.ID, db);
      if (fuFile4.HasFile)
        TrySavePicture(fuFile4.FileName, fuFile4.FileContent, itm.ID, db);
      if (fuFile5.HasFile)
        TrySavePicture(fuFile5.FileName, fuFile5.FileContent, itm.ID, db);
    }
    Response.Redirect("/admin/Default.aspx");
  }

  void TrySavePicture(string name, Stream stream, int itemID, DBDataContext db)
  {
    int maximgSize = 550;
    try
    {
      System.Drawing.Image img = System.Drawing.Image.FromStream(stream);
      if (img.PhysicalDimension.Width > 500 && img.PhysicalDimension.Width > img.PhysicalDimension.Height)
      {
        img = (System.Drawing.Image)(new Bitmap(img, new System.Drawing.Size(maximgSize, (int)(maximgSize / img.PhysicalDimension.Width * img.PhysicalDimension.Height))));
      }
      if (img.PhysicalDimension.Height > maximgSize && img.PhysicalDimension.Height > img.PhysicalDimension.Width)
      {
        img = (System.Drawing.Image)(new Bitmap(img, new System.Drawing.Size((int)(maximgSize / img.PhysicalDimension.Height * img.PhysicalDimension.Width), maximgSize)));
      }
      Pic pic = new Pic() { ItemID = itemID, path = "" };
      db.Pics.InsertOnSubmit(pic);
      db.SubmitChanges();
      string filename = string.Format("item{0}_img{1}.png", itemID, pic.ID);
      pic.path = string.Format("/img/items/{0}", filename);
      img.Save(string.Format("{0}/{1}", Server.MapPath("/img/items/"), filename), System.Drawing.Imaging.ImageFormat.Png);
      db.SubmitChanges();
    }
    catch (Exception ex)
    { }
  }

  protected void Cancel(object sender, EventArgs e)
  {
    Response.Redirect("/admin/Default.aspx");
  }

  protected void OnAddToStore(object sender, EventArgs e)
  {
    using (DBDataContext db = new DBDataContext())
    {
      IncomeOrder io = new IncomeOrder();
      io.ItemID = int.Parse(Request["id"]);
      io.ItemCount = int.Parse(txtIncomeCount.Text);
      io.PricePerItem = int.Parse(txtIncomePricePerItem.Text);
      io.Date = DateTime.Now;
      io.ItemsLeft = io.ItemCount;
      db.IncomeOrders.InsertOnSubmit(io);
      db.SubmitChanges();
    }
  }

  protected void Page_PreRender(object sender, EventArgs e)
  {
    using (DBDataContext db = new DBDataContext())
    {
      int categoryID = int.Parse(ddlCategories.SelectedValue);
      int sizeID = int.Parse(ddlSizes.SelectedValue);
      int rezID = int.Parse(ddlRezs.SelectedValue);
      lvItems.DataSource = from I in db.Items
                           where (categoryID == 0 || I.Category == categoryID) &&
                           (sizeID == 0 || (I.Size.HasValue && sizeID == I.Size.Value)) &&
                           (rezID == 0 || (I.Rezba.HasValue && rezID == I.Rezba.Value))
                           select new
                           {
                             I.ID,
                             I.Name,
                             I.Description,
                             Category = I.Category1.Name,
                             Rez = I.Rezba.HasValue ? I.Rezba1.Name : "",
                             Size = I.Size.HasValue ? I.Size1.Name.ToString() : "0",
                             I.Price,
                             I.Weight,
                             Pic = I.Pics.Count > 0 ? I.Pics.First().path : "/img/items/no_item_image.png",
                             StoreCount = I.IncomeOrders.Count == 0 ? 0 : I.IncomeOrders.Sum(IO => IO.ItemsLeft),
                             UseInLister = I.UseInLister ? "checked='true'" : "",
                             Visible = I.Visible ? "checked" : ""
                           };
      lvItems.DataBind();
    }
  }

  void BindDDLists()
  {
    using(DBDataContext db = new DBDataContext())
    {
      // Category
      var catList = from C in db.Categories
                    where C.ParentCategory != 1
                    orderby C.ParentCategory
                    select new
                    {
                      ID = C.ID,
                      Value= string.Format("{1} - {0}", C.Name, C.Category1.Name)
                    };
      ddlCategory.DataSource = catList;
      ddlCategory.DataTextField = "Value";
      ddlCategory.DataValueField = "ID";
      ddlCategory.DataBind();

      ddlCategories.DataSource = catList;
      ddlCategories.DataTextField = "Value";
      ddlCategories.DataValueField = "ID";
      ListItem itm = new ListItem("Все", "0");
      ddlCategories.DataBind();
      itm.Selected = true;
      ddlCategories.Items.Insert(0, itm);

      // Size
      ddlSize.DataSource = db.Sizes;
      ddlSize.DataValueField = "ID";
      ddlSize.DataTextField = "Name";
      ddlSize.DataTextFormatString = "{0}мм";
      ddlSize.DataBind();
      ListItem defaultLi = new ListItem("Не определено", "-1");
      defaultLi.Selected = true;
      ddlSize.Items.Insert(0, defaultLi);

      ddlSizes.DataSource = db.Sizes;
      ddlSizes.DataValueField = "ID";
      ddlSizes.DataTextField = "Name";
      ddlSizes.DataTextFormatString = "{0}мм";
      ListItem sItem = new ListItem("Все", "0");
      sItem.Selected = true;
      ddlSizes.DataBind();
      ddlSizes.Items.Insert(0, sItem);

      // Rez
      ddlRez.DataSource = db.Rezbas;
      ddlRez.DataValueField = "ID";
      ddlRez.DataTextField = "Name";
      ddlRez.DataBind();
      ddlRez.Items.Insert(0, defaultLi);

      ddlRezs.DataSource = db.Rezbas;
      ddlRezs.DataValueField = "ID";
      ddlRezs.DataTextField = "Name";
      ddlRezs.DataBind();
      ListItem rItem = new ListItem("Все", "0");
      rItem.Selected = true;
      ddlRezs.Items.Insert(0, rItem);
    }
  }

  [WebMethod]
  public static void DeleteImage(int id)
  {
    using (DBDataContext db = new DBDataContext())
    {
      Pic pic = db.Pics.FirstOrDefault(P => P.ID == id);
      if (pic != null)
      {
        db.Pics.DeleteOnSubmit(pic);
        db.SubmitChanges();
      }
    }
  }

  [WebMethod]
  public static void UpdateVisibility(int id, bool visible)
  {
    using (DBDataContext db = new DBDataContext())
    {
      Item itm = db.Items.FirstOrDefault(I => I.ID == id);
      if (itm != null)
      {
        itm.Visible = visible;
        db.SubmitChanges();
      }
    }
  }

  [WebMethod]
  public static bool UpdateLister(int id)
  {
    bool result = false;
    using (DBDataContext db = new DBDataContext())
    {
      Item itm = db.Items.FirstOrDefault(I => I.ID == id);
      if (itm != null)
      {
        itm.UseInLister = !itm.UseInLister;
        result = itm.UseInLister;
        db.SubmitChanges();
      }
    }
    return result;
  }
}