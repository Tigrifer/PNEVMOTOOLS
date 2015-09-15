<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminLoginPage.aspx.cs" Inherits="admin_AdminLoginPage" %>
<%@ Register Src="~/controls/Capcha.ascx" TagPrefix="uc" TagName="Captcha" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
     table
     {
      border-collapse:collapse;
     }
     .loginTable
     {
      margin:100px auto;
      background:#E7E7E7;
      border:1px solid green;
     }
     .loginTable td{padding:5px;}
     .loginTable th{padding:5px 10px;background:DarkGreen;color:White;}
    </style>
    <script src="js/jquery-1.10.0.min.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
      <div style="text-align:center;">
        <table class="loginTable">
          <tr>
            <th colspan="2">Вход в административную часть сайта.</th>
          </tr>
          <tr>
            <td>Логин:</td>
            <td>
              <asp:TextBox ID="txtLogin" runat="server" ValidationGroup="AdminLogin" />
              <asp:RequiredFieldValidator runat="server"  ValidationGroup="AdminLogin" ControlToValidate="txtLogin" Text="*" ForeColor="Red" SetFocusOnError="true" />
            </td>
          </tr>
          <tr>
            <td>Пароль:</td>
            <td>
              <asp:TextBox runat="server" ID="txtPassword" ValidationGroup="AdminLogin" TextMode="Password" />
              <asp:RequiredFieldValidator runat="server"  ValidationGroup="AdminLogin" ControlToValidate="txtPassword" Text="*" ForeColor="Red" SetFocusOnError="true" />
            </td>
          </tr>
          <tr>
            <td colspan="2" style="font-size:12px;">
              <uc:Captcha runat="server" ID="ucCaptcha" ValidationGroup="AdminLogin" />
            </td>
          </tr>
          <tr>
            <td></td>
            <td>
              <asp:Button runat="server" ValidationGroup="AdminLogin" OnClick="LoginClick" Text="Войти"/>
            </td>
          </tr>
          <tr>
            <td colspan="2">
              <asp:Label ID="lblError" runat="server" />
            </td>
          </tr>
        </table>
      </div>
    </form>
</body>
</html>
