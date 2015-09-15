using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security;
using System.Drawing;
using System.Web.Security;

public partial class admin_AdminLoginPage : System.Web.UI.Page
{
  protected void Page_Load(object sender, EventArgs e)
  {
    if (User.Identity.IsAuthenticated)
      Response.Redirect("/admin/Default.aspx");
  }

  protected void LoginClick(object sender, EventArgs e)
  {
    if (!ucCaptcha.IsValid)
    {
      lblError.Text = "Неправильно введен код защиты.";
      lblError.ForeColor = Color.Red;
      return;
    }
    if (FormsAuthentication.Authenticate(txtLogin.Text.Trim(), txtPassword.Text.Trim()))
    {
      lblError.Text = "You are logged in!";
      lblError.ForeColor = Color.Green;
      FormsAuthentication.RedirectFromLoginPage(txtLogin.Text.Trim(), false);
    }
    else
    {
      lblError.Text = "Неверное имя пользователя или пароль.";
      lblError.ForeColor = Color.Red;
    }
  }
}