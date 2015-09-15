using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.Collections.Specialized;
using System.Text;
using System.Configuration;
using System.Security.Cryptography;
using System.Web.Configuration;

/// <summary>
/// Сводное описание для SMSManager
/// </summary>
public class SMSManager
{
  public static Configuration SMSConfig
  {
    get
    {
      return WebConfigurationManager.OpenWebConfiguration("/sms.config");
    }
  }
  public static string PublicSMSKey
  {
    get
    {
      return ConfigurationManager.AppSettings["publicSMSKey"];
    }
  }

  public static string PrivateSMSKey
  {
    get
    {
      return ConfigurationManager.AppSettings["privateSMSKey"];
    }
  }

	public SMSManager()
	{
		
	}

  public const string XMLSendURL = "http://atompark.com/members/sms/xml.php";
  public const string XMLSendTemplate = "<SMS><operations><operation>SEND</operation></operations><authentification><username>{0}</username><password>{1}</password></authentification><message><sender>{2}</sender><text>{3}</text></message><numbers>{4}</numbers></SMS>";

  public static SMSStatus SendSMSV2ToUser(string numberTo, int orderID, int price)
  {
    using (WebClient client = new WebClient())
    {
      NameValueCollection values = new NameValueCollection();
      Configuration config = SMSManager.SMSConfig;
      string message = config.AppSettings.Settings["usertemplate"].Value.Replace("{orderNum}", orderID.ToString()).Replace("{price}", price.ToString());
      values["XML"] = string.Format(XMLSendTemplate, config.AppSettings.Settings["login"].Value, config.AppSettings.Settings["password"].Value, config.AppSettings.Settings["sender"].Value, message, string.Format("<number>{0}</number>", numberTo));
      byte[] response = client.UploadValues(XMLSendURL, values);
      string responseString = Encoding.Default.GetString(response);
      return GetStatus(responseString);
    }
  }

  public static SMSStatus SendSMSV2ToAdmin(string numberTo, string name, int orderID, int itemsCount, int totalPrice)
  {
    using (WebClient client = new WebClient())
    {
      NameValueCollection values = new NameValueCollection();
      Configuration config = SMSManager.SMSConfig;
      string adminnumbers = "";
      StringBuilder sb = new StringBuilder();
      adminnumbers = config.AppSettings.Settings["adminphones"].Value;
      string[] numbers = adminnumbers.Replace("\r", "").Split('\n');
      string adminTemplate = config.AppSettings.Settings["admintemplate"].Value.Replace("{orderNum}", orderID.ToString())
        .Replace("{name}", name).Replace("{phone}", numberTo).Replace("{itemcount}", itemsCount.ToString()).Replace("{price}", totalPrice.ToString());

      foreach (string number in numbers)
      {
        sb.AppendFormat("<number variables=\"{0};\">{1}</number>", adminTemplate, number);
      }
      adminnumbers = sb.ToString();
      values["XML"] = string.Format(XMLSendTemplate, config.AppSettings.Settings["login"].Value, config.AppSettings.Settings["password"].Value, config.AppSettings.Settings["sender"].Value, adminTemplate, adminnumbers);
      byte[] response = client.UploadValues(XMLSendURL, values);
      string responseString = Encoding.Default.GetString(response);
      return GetStatus(responseString);
    }
  }

  public static SMSStatus SendSMS(string numberTo, string message, string numberFrom, bool testSend = false)
  {
    using (WebClient client = new WebClient())
    {
      NameValueCollection values = new NameValueCollection();
      values["action"] = "sendSMS";
      values["datetime"] = "";
      values["key"] = PublicSMSKey;
      values["phone"] = numberTo;
      values["sms_lifetime"] = "0";
      if (testSend)
        values["test"] = "1";
      values["text"] = message;
      values["version"] = "3.0";
      values["sum"] = CheckSum(values);

      byte[] response = client.UploadValues("http://atompark.com/api/sms/3.0/sendSMS", values);

      string responseString = Encoding.Default.GetString(response);
      return GetStatus(responseString);
    }
  }

  public static SMSStatus GetStatus(string xml)
  {
    if (xml.Contains("-1"))
      return SMSStatus.AUTH_FAILED;
    if (xml.Contains("-2"))
      return SMSStatus.XML_ERROR;
    if (xml.Contains("-3"))
      return SMSStatus.NOT_ENOUGH_CREDITS;
    if (xml.Contains("-4"))
      return SMSStatus.NO_RECIPIENTS;
    return SMSStatus.OK;
  }

  public static string CheckSum(NameValueCollection values)
  {
    StringBuilder sb = new StringBuilder();
    foreach (string k in values.Keys)
      sb.Append(values[k]);
    sb.Append(PrivateSMSKey);
    return CalculateMD5Hash(sb.ToString());
  }

  public static string CalculateMD5Hash(string input)
  {
    MD5 md5 = System.Security.Cryptography.MD5.Create();
    byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(input);
    byte[] hash = md5.ComputeHash(inputBytes);
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < hash.Length; i++)
    {
      sb.Append(hash[i].ToString("X2"));
    }
    return sb.ToString();
  }

  public static string GetStringStatus(SMSStatus status)
  {
    switch (status)
    {
      case SMSStatus.AUTH_FAILED:
        return "Не удалось авторизоваться в сервисе рассылки сообщений";
      case SMSStatus.NO_RECIPIENTS:
        return "Неправильно указан получатель";
      case SMSStatus.NOT_ENOUGH_CREDITS:
        return "Недостаточно средств для отправки сообщений";
      case SMSStatus.OK:
        return "Сообщение успешно отправлено.";
      case SMSStatus.XML_ERROR:
        return "Неверно сформирован запрос на сервер SMS.";
    }
    return "Сообщение успешно отправлено.";
  }
}

public enum SMSStatus
{
  AUTH_FAILED = -1,
  XML_ERROR = -2,
  NOT_ENOUGH_CREDITS = -3,
  NO_RECIPIENTS = -4,
  OK = 0
}