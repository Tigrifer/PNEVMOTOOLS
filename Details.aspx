<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Details.aspx.cs" Inherits="Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <div style="float:left;width:400px;border:1px solid lightgray;">
          <div id="imager" style="width:400px; height:350px;overflow:hidden;text-align:center;vertical-align:middle;">
            <img id="mainImage" alt="" src="<%=Img%>" width="400px" />
          </div>
          <div id="shadow" style="display:none;" onclick="EnlargeImageList();">
            <div class="hovered">
            </div>
            <div style="background:url(/img/enlarge.png);width:48px;height:48px;position:absolute;margin:-190px 0 0 175px;cursor:pointer;"></div>
          </div>
        </div>

        <table class="details_table_main" style="width:550px; float:right;margin:0 10px">
          <tr>
            <td colspan="3" style="font-size:18px;"><span style="color:#A9B35D;font-weight:bold;font-size:22px;"><%=Itm.Name%></span><br /><%=Itm.Description%><hr /></td>
          </tr>
        </table>
        <div style="width:560px; height:60px;float:left;">
          <div class="pricer" style="float:right;">
            <div class="pricerCount"><input type="text" value="1" id='pricerCount<%=Itm.ID%>' onchange="CheckValue(this);"/></div>
            <div class="pricerInc" onclick='IncrementValue("#pricerCount<%=Itm.ID%>");'></div>
            <div class="pricerBuy" onclick="AddToCart(<%=Itm.ID%>, $('#pricerCount<%=Itm.ID%>').val());">КУПИТЬ</div>
            <div class="pricerDec" onclick='DecrementValue("#pricerCount<%=Itm.ID%>");'></div>
          </div>
          <div style="float:right;font-size:25px;font-weight:bold;padding:5px 15px;">
            <%=Itm.TotalPrice%>р. <span style="font-size:12px;color:darkred;">от <%=Itm.WholeMinCount%>шт: <%=Itm.TotalWholePrice%>р.</span>
          </div>
        </div>
        <div style="width:100%;height:50px;padding:5px;float:left;">
          <asp:ListView runat="server" ID="lvMainImages">
            <ItemTemplate>
              <img height="50px" alt="" src='<%#Eval("path")%>' style="cursor:pointer;" onclick='$("#mainImage").attr("src", $(this).attr("src"));' />
            </ItemTemplate>
          </asp:ListView>
        </div>
        <br />
        <div>
          <div class="titleLeft"></div>
          <div class="titleCenter" style="width:920px;">Похожие товары</div>
          <div class="titleRight"></div>
        </div>
        <table class="details_table">
          <asp:ListView runat="server" ID="lvSupplemental">
            <LayoutTemplate>
              <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
            </LayoutTemplate>
            <ItemTemplate>
              <tr>
                <td width="100px"><a style="color:#A9B35D;text-decoration:underline;font-weight:bold;" href="/Details.aspx?id=<%#Eval("ID")%>"><%#Eval("Name")%></a></td>
                <td><%#Eval("ShortDescription")%></td>
                <td width="130px" style="text-align:right;font-weight:bold;">
                  <%#Eval("TotalPrice")%>р.<br />
                  <span style="font-size:11px;color:darkred;">от <%#Eval("WholeMinCount")%>шт: <%#Eval("TotalWholePrice")%>р.</span>
                </td>
                <td width="115px;">
                  <div class="smallPricer" style="float:right;">
                    <div class="smallPricerCount"><input type="text" value="1" id='pricerCount<%#Eval("ID")%>' onchange="CheckValue(this);"/></div>
                    <div class="smallPricerInc" onclick='IncrementValue("#pricerCount<%#Eval("ID")%>");'></div>
                    <div class="smallPricerBuy" onclick="AddToCart(<%#Eval("ID")%>, $('#pricerCount<%#Eval("ID")%>').val());"><img alt="" src="/img/whiteCartBox.png" /></div>
                    <div class="smallPricerDec" onclick='DecrementValue("#pricerCount<%#Eval("ID")%>");'></div>
                  </div>
                </td>
              </tr>
            </ItemTemplate>
            <EmptyDataTemplate>
            </EmptyDataTemplate>
          </asp:ListView>
        </table>

  <div id="image_viewer" class="overlay" style="display:none;position:fixed;">
    <div class="overlay shadow">
    </div>
    <div class="overlay_container" id="overlayContainer">
      <div class="CloseImager" onclick="$('#image_viewer').hide()">ЗАКРЫТЬ X</div>
      <table width="100%" id="main_image_table">
        <tr>
          <td align="center"><img id="main_image" alt="" src="" height="400px" /></td>
        </tr>
      </table>
      <table class="previever" cellspacing="5px" id="imageList">
        <tr>
          <asp:ListView runat="server" ID="lvImages">
            <ItemTemplate>
              <td><img height="40px" alt="" src='<%#Eval("path")%>' /></td>
            </ItemTemplate>
          </asp:ListView>
        </tr>
      </table>
    </div>
  </div>

  <script type="text/javascript">
    $(document).ready(function () {
      $("#imager").hover(function () {
        $("#shadow").show();
      });
      $("#shadow").mouseleave(function () {
        $("#shadow").hide();
      });


      $(".details_table tr").hover(function () {
        $(this).css("background", "#E0E0E0");
      });
      $(".details_table tr").mouseleave(function () {
        $(this).css("background", "#FFFFFF");
      });

      $(".previever img").click(function () {
        $(".previever td").removeClass("active");
        $(this).parent().addClass("active");
        $("#main_image").attr("src", $(this).attr("src"));
      });
    });

    function EnlargeImageList() {
      if ($('#imageList td').length == 0)
        return;
      $('#image_viewer').show();
      $('#imageList td').removeClass("active");
      $($('#imageList td')[0]).addClass("active");
      var src1 = $($($('#imageList td')[0]).children()[0]).attr("src");
      $("#main_image").attr("src", src1);
      setTimeout(function () {
        var windowW = $(window).width();
        $("#overlayContainer").css("left", windowW / 2 - $("#overlayContainer").width() / 2 + "px");
        $("#overlayContainer").css("top", "45px");
      }, 10);
    }
  </script>
</asp:Content>

