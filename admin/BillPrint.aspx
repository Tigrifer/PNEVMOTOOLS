<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="BillPrint.aspx.cs" Inherits="admin_BillPrint" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
  <style type="text/css">
    .namesTable{text-align:left;width:100%;}
    .namesTable td{padding:2px 10px;}
    .billtable{width:100%;}
    .billtable td
    {
        padding:5px;
        border:2px solid black;
        text-align:left;
    }
    .billtable th
    {
        padding:5px;
        border:2px solid black;
        text-align:center;
    }
    .noborder{border:0px;font-weight:bold;}
    .itemsTable{display:none;}
    .bottom{font-weight:bold;padding:10px; width:100%;}
    .bottom td{padding:10px;}
    body,html{padding:0;margin:0;}
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="width:800px;margin:0 auto;">
  <h2 style="text-align:center;">VALMEX.RU</h2>
  <div style="text-align:right;">Круглосуточный прием заказов на сайте http://valmex.ru/ </div>
  <div style="text-align:left;font-weight:bold;">Чек № 000000<%=order.ID%> от <%=order.CreatedOn.ToShortDateString()%></div>
  <table class="namesTable">
    <tr>
      <td style="width:100px;">Поставщик: </td>
      <td>ИП Васильвев Василий Васильевич, ИНН 123456789999</td>
    </tr>
    <tr>
      <td>Получатель: </td>
      <td><%=order.Name%></td>
    </tr>
    <tr>
      <td>Адрес: </td>
      <td><%=string.Format("{0} ул. {1} {2} кв. {3}", order.City, order.Street, order.Building, order.Appartmant)%></td>
    </tr>
    <tr>
      <td>Телефон: </td>
      <td><%=order.Phone%>, <%=order.Pnone2%></td>
    </tr>
  </table>
  <br />
  <div style="text-align:right;text-decoration:underline;"><i>Телефон "горячей линии": +7-933-111-33-33</i></div>
  <br />
  <table class="billtable">
    <tr>
      <th style="width:30px;">№</th>
      <th>Товар</th>
      <th style="width:50px;">Кол-во</th>
      <th style="width:30px;">Ед.</th>
      <th style="width:100px;">Цена</th>
      <th style="width:100px;">Сумма</th>
    </tr>
    <asp:ListView ID="lvDetails" runat="server">
      <LayoutTemplate>
        <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
      </LayoutTemplate>
      <ItemTemplate>
        <tr>
          <td><%=(count++).ToString()%></td>
          <td><%#Eval("Name")%></td>
          <td><%#Eval("Count")%></td>
          <td><%#Eval("Ed")%></td>
          <td><%#Eval("Price")%> р.</td>
          <td><%#Eval("Total")%> р.</td>
        </tr>
      </ItemTemplate>
    </asp:ListView>
    <tr>
      <td><%=(count++).ToString()%></td>
      <td>Доставка</td>
      <td></td>
      <td></td>
      <td></td>
      <td><%=order.DeliveryCost.ToString()%> р.</td>
    </tr>
    <tr class="noborder">
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td>Итого: </td>
      <td><%=orderTotal.ToString()%> р.</td>
    </tr>
  </table>
  <br />
  <table class="bottom">
    <tr>
      <td> Отпустил </td>
      <td>________________________</td>
      <td> Получил </td>
      <td>________________________</td>
    </tr>
  </table>
  <br />
  <div style="border-bottom:1px dashed black;"></div>
</div>
</asp:Content>