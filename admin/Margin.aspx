<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Margin.aspx.cs" Inherits="admin_Margin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <asp:Button runat="server" OnClick="SetViewCategories" Text="Категории"/>
  <asp:Button runat="server" OnClick="SetViewItems" Text="Товар"/><br /><br />
  <asp:MultiView runat="server" ID="mvMargin">
    <asp:View runat="server" ID="vCategories">
      <asp:DropDownList runat="server" ID="ddlCatergories" AutoPostBack="true" />
    </asp:View>
    <asp:View runat="server" ID="vItems">
      
    </asp:View>
  </asp:MultiView>
  <table>
    <tr>
      <td>Тип наценки</td>
      <td>
        <asp:DropDownList runat="server" ID="ddlMarginType">
          <asp:ListItem Value="0">%</asp:ListItem>
          <asp:ListItem Value="1">Рубли</asp:ListItem>
        </asp:DropDownList>
      </td>
    </tr>
    <tr>
      <td>Розничная наценка к закупочной цене</td>
      <td><asp:TextBox runat="server" ID="txtMargin" /></td>
    </tr>
    <tr>
      <td>Оптовая наценка к закупочной цене</td>
      <td><asp:TextBox runat="server" ID="txtWholeMargin" /></td>
    </tr>
    <tr>
      <td>Опт от</td>
      <td><asp:TextBox runat="server" ID="txtWholeMin" />шт.</td>
    </tr>
    <tr>
      <td colspan="2">
        <asp:Button runat="server" Text="Сохранить" OnClick="SaveCategory" />
      </td>
    </tr>
  </table>
  Отрицательное значение в наценках устанавливает цену продаж оптовой или розничной <u><b>ниже</b></u> закупочной цены.
</asp:Content>

