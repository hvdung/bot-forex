//+------------------------------------------------------------------+
//|                                               EntryCondition.mqh |
//|                                                     Hà Việt Dũng |
//|                                                                # |
//+------------------------------------------------------------------+
#property copyright "Hà Việt Dũng"
#property link      "#"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

void UpdateTrailingStopLong()
{
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
      {
         double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         double atrValue = CalculateATR();
         double newStopLoss = currentPrice - atrValue;

         // Move the stop loss only if the new stop loss is higher than the current stop loss
         if(newStopLoss > PositionGetDouble(POSITION_SL))
         {
            trade.PositionModify(ticket, newStopLoss, PositionGetDouble(POSITION_TP));
         }
      }
   }
}

void UpdateTrailingStopShort()
{
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
      {
         double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         double atrValue = CalculateATR();
         double newStopLoss = currentPrice + atrValue;

         // Move the stop loss only if the new stop loss is higher than the current stop loss
         if(newStopLoss > PositionGetDouble(POSITION_SL))
         {
            trade.PositionModify(ticket, newStopLoss, PositionGetDouble(POSITION_TP));
         }
      }
   }
}

