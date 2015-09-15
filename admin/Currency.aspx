<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Currency.aspx.cs" Inherits="admin_Currency" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<br /><br />
 <table align="center" class="itemsTable">
  <tr><th>Курс евро к рублю</th></tr>
  <tr><td>
    <asp:TextBox runat="server" ID="txtCurrency" ValidationGroup="currency" onclick="this.select();" />
    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="currency" Text="*" SetFocusOnError="true" ControlToValidate="txtCurrency" runat="server"/>
  </td></tr>
  <tr><td>Курс евро (EUR) по ЦБРФ: 1EUR = <asp:Label runat="server" ID="lblCBRF" /> RUR</td></tr>
  <tr><td><asp:CheckBox runat="server" ID="cbxIsAuto" Text="Использовать курс ЦБРФ автоматически"/></td></tr>
  <tr><td style="color:Gray;font-size:12px;">Формат ввода данных:<br /> 12<br /> 45.6<br /> 22,79</td></tr>
  <tr><td><asp:Button ID="Button1" ValidationGroup="currency" runat="server" OnClick="SaveCurrency" Text="Сохранить"/></td></tr>
  <tr><td><asp:Label runat="server" ID="txtMessage" /></td></tr>
 </table>
</asp:Content>

