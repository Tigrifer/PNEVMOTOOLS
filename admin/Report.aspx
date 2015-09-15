<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Report.aspx.cs" Inherits="admin_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
  <link rel="Stylesheet" type="text/css" href="/css/jquery-ui.css"/>
  <script src="/js/jquery-ui.js" type="text/javascript"></script>
  <style type="text/css">
    .ui-datepicker table{font-size:10px !important;}
    .summary{background:#555;color:White;font-weight:bold;text-align:center;}
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<asp:RadioButtonList ID="rblReportType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ReportTypeChanged" RepeatDirection="Horizontal">
  <asp:ListItem Selected="True" Text="Доходы" Value="1" />
  <asp:ListItem Text="Расходы" Value="2" />
</asp:RadioButtonList>
<br />
<table style="font-size:12px;">
  <tr>
    <td>
      От: <input type="text" id="datefrom" runat="server" clientidmode="Static"/>
    </td>
    <td>
      До: <input type="text" id="dateto" runat="server" clientidmode="Static"/>
    </td>
    <td><asp:Button runat="server" Text="Обновить" OnClick="Refresh" /></td>
  </tr>
</table>
<asp:MultiView runat="server" ID="mvReports">
  <asp:View runat="server" ID="vSales">
    <h3>Выручка</h3>
    <table class="itemsTable">
          <tr>
            <th>ID</th>
            <th>Email</th>
            <th>Дата</th>
            <th>Доставка</th>
            <th>Сумма</th>
          </tr>
          <asp:ListView runat="server" ID="lvSales">
            <LayoutTemplate>
                <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
            </LayoutTemplate>
            <ItemTemplate>
          <tr>
            <td><%#Eval("ID")%></td>
            <td><%#Eval("Email")%></td>
            <td><%#Eval("Date")%></td>
            <td><%#Eval("Delivery")%> р.</td>
            <td><%#Eval("Amount")%> р.</td>
          </tr>
            </ItemTemplate>
          </asp:ListView>
          <tr class="summary">
            <td>Итого:</td>
            <td></td>
            <td></td>
            <td id="totalDelivery" runat="server">0 р.</td>
            <td id="totalAmount" runat="server">0 р.</td>
          </tr>
    </table>
  </asp:View>
  <asp:View runat="server" ID="vOutlay">
    <h3>Расходы</h3>
    <table class="itemsTable">
      <tr>
        <th>ID</th>
        <th>ID товара</th>
        <th>Дата</th>
        <th>Кол-во</th>
        <th>Цена за единицу товара</th>
        <th>Сумма</th>
      </tr>
      <asp:ListView runat="server" ID="lvOutlayBuy">
        <LayoutTemplate>
            <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
        </LayoutTemplate>
        <ItemTemplate>
      <tr>
        <td><%#Eval("ID")%></td>
        <td><%#Eval("ItemID")%></td>
        <td><%#Eval("Date")%></td>
        <td><%#Eval("Count")%></td>
        <td><%#Eval("PricePerItem")%> р.</td>
        <td><%#Eval("Amount")%> р.</td>
      </tr>
        </ItemTemplate>
      </asp:ListView>
     <%-- <asp:ListView ID="lvOutlayDelivery" runat="server">
        <LayoutTemplate>
          <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
        </LayoutTemplate>
        <ItemTemplate>
        </ItemTemplate>
      </asp:ListView>--%>
      <tr class="summary">
        <td>Итого:</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td id="outlayTotal" runat="server">0 р.</td>
      </tr>
    </table>
  </asp:View>
</asp:MultiView>
  <script type="text/javascript">
  $(document).ready(function () {
      $("#datefrom").datepicker({ dateFormat: 'dd-mm-yy' });
      $("#dateto").datepicker({ dateFormat: 'dd-mm-yy' });
    });
  </script>
</asp:Content>

