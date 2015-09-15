<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Rezba.ascx.cs" Inherits="controls_Rezba" %>
<div class="category" id="main_rez_div">
  <div class="category_title">РЕЗЬБА: <div class="All" onclick="ClearRez();">СБРОС</div></div>
  <asp:ListView ID="lvRez" runat="server">
    <ItemTemplate>
      <div class="category_item div_rez" id='div_rez_<%#Eval("ID")%>'>
        <table>
          <tr>
            <td><input val='<%#Eval("ID")%>' class="rez_selector" type="checkbox" id='rez<%#Eval("ID")%>' onclick="ProccessDataItemFilter();"/></td>
            <td><label for='rez<%#Eval("ID")%>'><%#Eval("Name")%></label> <div class="counter"><%#((System.Data.Linq.EntitySet<Item>)Eval("Items")).Count%></div></td>
          </tr>
        </table>
      </div>
    </ItemTemplate>
  </asp:ListView>
</div>
<script type="text/javascript">
  function ClearRez() {
    $(".rez_selector").prop('checked', false);
    ProccessDataItemFilter();
  }
</script>