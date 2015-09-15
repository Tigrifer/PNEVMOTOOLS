using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

public partial class admin_TestSMS : System.Web.UI.Page
{
  protected void Page_LoadComplete(object sender, EventArgs e)
  {
    KeyValueConfigurationCollection config = SMSManager.SMSConfig.AppSettings.Settings;
    txtAdminPhones.Text = config["adminphones"].Value;
    txtAdminResponseTemplate.Text = config["admintemplate"].Value;
    txtLogin.Text = config["login"].Value;
    txtPassword.Text = config["password"].Value;
    txtSender.Text = config["sender"].Value;
    txtUserResponseTemplate.Text = config["usertemplate"].Value;
  }

  protected void OnSend(object sender, EventArgs e)
  {
    SMSStatus status = SMSManager.SendSMSV2ToUser(txtNumber.Text, 0, 0);
    lblMessage.Text = SMSManager.GetStringStatus(status);
  }

  protected void SaveSettings(object sender, EventArgs e)
  {
    Configuration config = SMSManager.SMSConfig;
    config.AppSettings.Settings["login"].Value = txtLogin.Text.Trim();
    config.AppSettings.Settings["password"].Value = txtPassword.Text.Trim();
    config.AppSettings.Settings["usertemplate"].Value = txtUserResponseTemplate.Text;
    config.AppSettings.Settings["admintemplate"].Value = txtAdminResponseTemplate.Text;
    config.AppSettings.Settings["sender"].Value = txtSender.Text;
    config.AppSettings.Settings["adminphones"].Value = txtAdminPhones.Text;
    config.Save();
  }
}