using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Text;


public partial class Controls_Capcha : System.Web.UI.UserControl
{
  /// <summary>
  /// available value until page PreRendered
  /// Once capcha has been validated session would be set to null
  /// </summary>
  public bool IsValid
  {
    get
    {
      if (Session["capcha"] != null)
      {
        try
        {
          string capcha = Session["capcha"].ToString();
          if (txtCapcha.Text == capcha.ToString())
          {
            Session["capcha"] = null;
            return true;
          }
          else
            return false;
        }
        catch (Exception ee)
        { return false; }
      }
      return false;
    }
  }

  public string ValidationGroup { get; set; }

  protected void Page_Load(object sender, EventArgs e)
  {
    txtCapcha.ValidationGroup = this.ValidationGroup;
    valCapcha.ValidationGroup = this.ValidationGroup;
  }

  void Page_PreRender(object sender, EventArgs e)
  {
    txtCapcha.Text = "";
  }
}
