<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Sizes.ascx.cs" Inherits="controls_Sizes" %>

<div class="category" id="main_size_div">
  <div class="category_title">ДИАМЕТР: <div class="All" onclick="ClearSizes();">СБРОС</div></div>
  <asp:ListView ID="lvSizes" runat="server">
    <ItemTemplate>
      <div class="category_item div_size" id='div_size_<%#Eval("ID")%>'>
        <table>
          <tr>
            <td><input val='<%#Eval("ID")%>' class="size_selector" type="checkbox" id='size<%#Eval("ID")%>' onclick="ProccessDataItemFilter();"/></td>
            <td><label for='size<%#Eval("ID")%>'><%#Eval("Name")%>мм</label> <div class="counter"><%#((System.Data.Linq.EntitySet<Item>)Eval("Items")).Count%></div></td>
          </tr>
        </table>
      </div>
    </ItemTemplate>
  </asp:ListView>
</div>
<script type="text/javascript">
function ClearSizes() {
  $(".size_selector").prop('checked', false);
  ProccessDataItemFilter();
}
</script>