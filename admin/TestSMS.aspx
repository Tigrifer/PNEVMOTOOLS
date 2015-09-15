<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="TestSMS.aspx.cs" Inherits="admin_TestSMS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
  <script src="/js/jquery-1.10.0.min.js" type="text/javascript"></script>
  <script type="text/javascript">
    function ChangeTemplate(obj) {
      $(obj).next().html($(obj).val().length);
    }

    $(document).ready(function () {
      ChangeTemplate("#txtUserResponseTemplate");
      ChangeTemplate("#txtAdminResponseTemplate");
    });
  </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<br />
<table class="itemsTable" align="center">
  <tr>
    <th colspan="2">Настройка SMS-рассылки</th>
  </tr>
  <tr>
    <td>Логин:</td>
    <td><asp:TextBox runat="server" ID="txtLogin" /></td>
  </tr>
  <tr>
    <td>Пароль:</td>
    <td><asp:TextBox runat="server" ID="txtPassword" /></td>
  </tr>
  <tr>
    <td>Отправитель</td>
    <td><asp:TextBox ID="txtSender" runat="server"/></td>
  </tr>
  <tr>
    <td>Шаблон ответа для покупателя:</td>
    <td><asp:TextBox ClientIDMode="Static" ID="txtUserResponseTemplate" runat="server" TextMode="MultiLine" Width="300px" onchange="ChangeTemplate(this);" onkeyup="ChangeTemplate(this);"/><div></div></td>
  </tr>
  <tr>
    <td>Шаблон ответа для администратора:</td>
    <td><asp:TextBox ClientIDMode="Static" ID="txtAdminResponseTemplate" runat="server" TextMode="MultiLine" Width="300px" onchange="ChangeTemplate(this);" onkeyup="ChangeTemplate(this);"/><div></div></td>
  </tr>
  <tr>
    <td>Номера телефонов администраторов</td>
    <td><asp:TextBox ID="txtAdminPhones" runat="server" TextMode="MultiLine" Width="300px"/></td>
  </tr>
  <tr>
    <td colspan="2"><asp:Button runat="server" ID="btnSave" OnClick="SaveSettings" Text="Сохранить"/></td>
  </tr>
</table>
<br />
<table class="itemsTable" align="center">
  <tr>
    <th colspan="2">Пробная SMS-рассылка</th>
  </tr>
  <tr>
    <td>Телефон:</td>
    <td><asp:TextBox runat="server" ID="txtNumber" /></td>
  </tr>
  <tr>
    <td>Сообщение:</td>
    <td><asp:TextBox runat="server" ID="txtMessage" TextMode="MultiLine" /></td>
  </tr>
  <tr>
    <td colspan="2"><asp:Button ID="btnSend" OnClick="OnSend" runat="server" Text="Отправить" /></td>
  </tr>
  <tr><td colspan="2"><asp:Label ID="lblMessage" runat="server" Text=""/></td></tr>
</table>
</asp:Content>