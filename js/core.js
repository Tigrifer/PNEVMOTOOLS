function ProccessDataItemFilter() {
  var categories = new Array();
  $(".sub_item_select:checked").each(function (i, v) {
    categories.push($(v).attr("val"));
  });

  var sizes = new Array();
  $(".size_selector:checked").each(function (i, v) {
    sizes.push($(v).attr("val"));
  });

  var rez = new Array();
  $(".rez_selector:checked").each(function (i, v) {
    rez.push($(v).attr("val"));
  });

  $(".category_selector:checked").each(function (i, v) {
    var parent = $("#div_category_" + $(v).attr("divid"));
    if (parent.find(".sub_item_select:checked").length == 0) // выбрана полностью только главная категория
    {
      parent.find(".sub_item_select").each(function (i, vl) { categories.push($(vl).attr("val")); });
    }
  });

  PageMethods.ApplyFilter(categories, sizes, rez,
  function (result) {
    $("#itemContainer").html(result);
    $("#main_rez_div").show();
    $("#main_size_div").show();

    if (categories.length > 0) {
      if (sizeIDs.length > 0) {
        $(".div_size").hide();
        for (var i = 0; i < sizeIDs.length; i++) {
          var id = sizeIDs[i];
          $("#div_size_" + id).show();
        }
      }
      else
        $("#main_size_div").hide();

      if (rezIDs.length > 0) {
        $(".div_rez").hide();
        for (var i = 0; i < rezIDs.length; i++) {
          var id = rezIDs[i];
          $("#div_rez_" + id).show();
        }
      }
      else
        $("#main_rez_div").hide();
    }
    else {
      $(".div_rez").show();
      $(".div_size").show();
    }
  },
  function () {
    alert("Ошибка фильтрации");
  });
}

function AddToCart(id, count) {
  if (isNaN(parseInt(count)) || parseInt(count) <= 0) {
    ShowMessage("Ошибка", "Введите валидное кол-во выбранного товара, которое хотите приобрести. От 1 до 999.");
    return;
  }
  PageMethods.AddToCart(id, count, function (result) {
    ShowCartMessage(result);
  },
  function () {
    ShowMessage("Ошибка при добавлении товара.", "Возникла ошибка при добавлении товара в корзину.");
  });
}

function ShowCartMessage(result) {
  $("#cartCount").html(result.count);
  $("#cartTotal").html(result.price);
  var ost = parseInt($("#txtDeliveryLimit").html()) - result.price;
  var msg = "Бесплатная доставка.";
  if (ost > 0)
    msg = "До бесплатной доставки осталось " + Math.round(ost * 100)/100 + " руб.";
  ShowMessage("Корзина", "Добавлен товар. В корзине " + result.count + " шт. " + msg + "<br/><a class='link' href='/CartPage.aspx'>Перейти к оформлению покупки.</a>");
}

function UpdateCart(id, count) {
  PageMethods.UpdateCart(id, count, function (result) {
    var itemPrice = $("#pricerCount" + id).attr("price");
    var itemWholePrice = $("#pricerCount" + id).attr("wholeprice");
    var minWhole = $("#pricerCount" + id).attr("minwhole");
    var cartItemCount = $("#pricerCount" + id).val();
    var total = (cartItemCount < minWhole ? itemPrice : itemWholePrice) * cartItemCount;
    $("#lblDeliveryPrice").html(result.delivery);
    $("#lblTotalCount").html(result.count);
    $("#lblTotalPrice").html(result.price + result.delivery);
    $("#CartItems").html("В корзине товаров: " + result.count + "<br/> На сумму: " + result.price + " руб.");
    $("#tdTotalPrice" + id).html(total + " р.");
  });
}

function DeleteCart(itemId, obj) {
  PageMethods.RemoveFromCart(itemId, function (result) {
    $("#lblDeliveryPrice").html(result.delivery);
    $("#lblTotalCount").html(result.count);
    $("#lblTotalPrice").html(result.price + result.delivery);
    $("#CartItems").html("В корзине товаров: " + result.count + "<br/> На сумму: " + result.price + " руб.");
    $(obj).parent().parent().remove();
  });
}

function IncrementValue(input) {
  if ($(input).val() == "")
    $(input).val(1);
  else
    $(input).val(parseInt($(input).val()) + 1);
}

function DecrementValue(input) {
  if ($(input).val() == "" || $(input).val() == 1)
    $(input).val(1);
  else
    $(input).val(parseInt($(input).val()) - 1);
}

function CheckValue(input) {
  var txt = $(input).val();
  if (isNaN(txt) || txt == '' || txt <= 0) $(input).val(1);
}

function CityChanged(obj) {
  $('#txtDeliveryLimit').html($(obj).children('option:selected').attr('dLimit'));
  $.cookie("selectedCityToDeliver", $(obj).children('option:selected').val());
}

function ShowMessage(title, message) {
  if (title == '') title = ' ';
  $("#msgTitle").html(title);
  $("#msgText").html(message);
  $("#msgDivOverlay").show();
  $(".msgContent").css("left", ($(document).width() / 2 - 300) + "px");
}

function HideMessage() {
  $("#msgDivOverlay").hide();
}

function ClearOrderForm() {
  $(".order_table input").val("");
}

function MainMenuClick(p) {
  if (p == '')
    location.href = '/';
  else
    location.href = "/?p=" + p;
}

var isListing = false;
var isAutoListing = true;

function AutoList() {
  if (!isAutoListing) return;
  ScrolListerRight(true);
  setTimeout(function () { AutoList(); }, autoListDelay);
}

function ScrolListerLeft(isAuto) {
  isAutoListing = isAuto;
  if (isListing) return;
  isListing = true;
  if ($("#divLister").scrollLeft() == 0) {
    var last = $("#lScrollContainer").children().last();
    $("#lScrollContainer").prepend(last);
    $("#divLister").scrollLeft(listerStep);
  }
  $("#divLister").animate({ scrollLeft: $("#divLister").scrollLeft() - listerStep }, scrollSpeed, function () { isListing = false; });
}

function ScrolListerRight() {
  if (isListing) return;
  isListing = true;
  if ($("#divLister").scrollLeft() == (listerCount - 1) * listerStep) {
    var first = $("#lScrollContainer").children().first();
    $("#lScrollContainer").append(first);
    $("#divLister").scrollLeft((listerCount - 2) * listerStep);
  }
  $("#divLister").animate({ scrollLeft: $("#divLister").scrollLeft() + listerStep }, scrollSpeed, function () { isListing = false; });
}