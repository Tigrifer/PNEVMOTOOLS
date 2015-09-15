<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>
<%@ Register Src="~/controls/Categories.ascx" TagPrefix="uc" TagName="Category" %>
<%@ Register Src="~/controls/Sizes.ascx" TagName="Sizes" TagPrefix="uc" %>
<%@ Register Src="~/controls/Rezba.ascx" TagName="Rezba" TagPrefix="uc" %>
<%@ Register Src="~/controls/ItemContainer.ascx" TagName="Item" TagPrefix="uc" %>
<%@ Register Src="~/controls/Lister.ascx" TagName="Lister" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
  <script type="text/javascript">
     $(document).ready(function () {
       $(".menuitem").hover(function () {
         $(this).removeClass("menuitem");
         $(this).addClass("menuitem_hover");
       });
       $(".menuitem").mouseleave(function () {
         $(this).removeClass("menuitem_hover");
         $(this).addClass("menuitem");
       });

       $("#txtSearch").focus(function () {
         if ($(this).val() == "ПОИСК")
           $(this).val("");
       });

       $("#txtSearch").blur(function () {
         if ($(this).val() == "")
           $(this).val("ПОИСК");
       });
     });
  </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <table class="content">
    <tr>
      <td class="content_left">
        <uc:Category runat="server" ID="ucCategory" />
        <br />
        <uc:Sizes runat="server" ID="ucSizes" />
        <br />
        <uc:Rezba runat="server" ID="ucRezba" />
      </td>
      <td class="content_right" id="itemContainer">
        <uc:Lister runat="server" ID="ucLister" />
        <uc:Item ID="ucItems" runat="server" />
      </td>
    </tr>
  </table>
</asp:Content>

