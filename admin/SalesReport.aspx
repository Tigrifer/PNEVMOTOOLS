<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesReport.aspx.cs" Inherits="admin_SalesReport" MasterPageFile="~/admin/AdminMasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="text-align:center;">
      <h3>Отчет по продажам</h3>
      <asp:ListView ID="lvReport" runat="server">
        <ItemTemplate>
          <tr>
            <td><%#Eval("ID")%></td>
            <td><%#Eval("OrderID")%></td>
            <td><%#Eval("Name")%></td>
            <td><%#Eval("Description")%></td>
            <td><%#Eval("Count")%></td>
            <td><%#Eval("PricePerItem")%></td>
            <td><%#Eval("TotalPrice")%></td>
            <td><%#Eval("Date")%></td>
          </tr>
        </ItemTemplate>
        <EmptyDataTemplate>
          За указанный период ничего не было продано.
        </EmptyDataTemplate>
        <LayoutTemplate>
          <table class="itemsTable" align="center">
            <tr>
              <th>ID</th>
              <th>Номер ордера</th>
              <th>Название</th>
              <th>Описание</th>
              <th>Колличество</th>
              <th>Цена за ед.</th>
              <th>Цена всего</th>
              <th>Дата</th>
            </tr>
            <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
          </table>
        </LayoutTemplate>
      </asp:ListView>
    </div>
</asp:Content>
