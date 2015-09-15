<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Categories.ascx.cs" Inherits="controls_Categories" %>
<div class="category">
  <div class="category_title">КАТЕГОРИИ: <div class="All" onclick="ClearCategories();">СБРОС</div></div>
  <asp:ListView ID="lvCategories" runat="server">
    <ItemTemplate>
      <div class="category_item" id="div_category_<%#Eval("ID") %>">
        <table>
          <tr>
            <td style="width:15px;"><input class="category_selector" type="checkbox" id='category<%#Eval("ID")%>' divid="<%#Eval("ID")%>"/></td>
            <td><label for='category<%#Eval("ID")%>'><%#Eval("Name")%></label> <div class="counter"><%#Eval("Count")%></div></td>
          </tr>
        </table>
        <asp:ListView runat="server" ID="lvSubCategory" DataSource='<%#((System.Data.Linq.EntitySet<Category>)Eval("Categories")).OrderBy(C=>C.SortOrder)%>'>
          <ItemTemplate>
            <div class="sub_item">
              <table>
                <tr>
                  <td>&nbsp;</td>
                  <td style="width:15px;"><input val='<%#Eval("ID")%>' id='category<%#Eval("ID")%>' class="sub_item_select" type="checkbox" onclick="ProccessDataItemFilter();"/></td>
                  <td><label for='category<%#Eval("ID")%>'><%#Eval("Name")%></label> <div class="counter"><%#((System.Data.Linq.EntitySet<Item>)Eval("Items")).Count() %></div></td>
                </tr>
              </table>
            </div>
          </ItemTemplate>
        </asp:ListView>
      </div>
    </ItemTemplate>
  </asp:ListView>
</div>
<script type="text/javascript">
  $(document).ready(function () {
    $(".category_selector").prop('checked', false);
    $(".sub_item_select").prop('checked', false);
    $('#category<%=Request["p"]%>').click();
  });
  function ClearCategories() {
    $(".category_selector").prop('checked', false);
    $(".sub_item_select").prop('checked', false);
    $(".sub_item").hide();
    $.each($(".category_selector"), function (i, v) { v.visible_item = false; })
    ProccessDataItemFilter();
  }
  $(".category_selector").click(function () {
    if (!this.visible_item) {
      $("#div_category_" + $(this).attr("divid")).children(".sub_item").show();
      this.visible_item = true;
      ProccessDataItemFilter();
    }
    else {
      this.visible_item = false;
      $("#div_category_" + $(this).attr("divid")).children(".sub_item").hide();
      $("#div_category_" + $(this).attr("divid") + " .sub_item_select").prop('checked', false);
      ProccessDataItemFilter();
    }
  });
</script>