using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Сводное описание для OrderStatus
/// </summary>
public enum OrderStatus
{
  ZAKAZAN = 1,
  PRINYAT = 2,
  OTGRUZHEN = 3,
  DOSTAVLEN = 4,
  VOZVRASCHEN = 5,
  OTMENEN = 6
}

public class OrderStatusManager
{
  public static string GetTextStatus(OrderStatus status)
  {
    switch (status)
    {
      case OrderStatus.DOSTAVLEN:
        return "Доставлен";
      case OrderStatus.OTGRUZHEN:
        return "Отгружен";
      case OrderStatus.OTMENEN:
        return "Отменен";
      case OrderStatus.PRINYAT:
        return "Принят";
      case OrderStatus.VOZVRASCHEN:
        return "Возвращен";
      case OrderStatus.ZAKAZAN:
        return "Заказан";
    }
    return "Заказан";
  }
}