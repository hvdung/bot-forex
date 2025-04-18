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


bool EntryBuyCondition()
{
   /*
      Đk buy:
      - Giá đóng cửa lớn hơn giá mở cửa (Là 1 nến tăng)
      - Giá low < EMA 21 high && giá close > EMA 21 high
   */
   // Vì hệ thống chạy theo từng tick nên sẽ lấy theo cây nến trước đó.
   double close = iClose(_Symbol, PERIOD_CURRENT, 1);
   double open = iOpen(_Symbol, PERIOD_CURRENT, 1);
   double high = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double low = iLow(_Symbol, PERIOD_CURRENT, 1);
   
   double highFastBuffer[];
   ArraySetAsSeries(highFastBuffer,true);
   double highFastEMA = iMA(_Symbol, PERIOD_CURRENT, fastEMA, 1, MODE_EMA, PRICE_HIGH);
   CopyBuffer(highFastEMA,0,0,1,highFastBuffer);
   
   bool condition = (close > open) && (low < highFastBuffer[0]) && (close > highFastBuffer[0]);
   return condition;
}

bool EntrySellCondition()
{
   /*
      Đk sell:
      - Giá đóng cửa nhỏ hơn giá mở cửa (Là 1 nến đỏ)
      - Giá high > EMA 21 low && giá close < EMA 21 low
   */
    // Vì hệ thống chạy theo từng tick nên sẽ lấy theo cây nến trước đó.
   double close = iClose(_Symbol, PERIOD_CURRENT, 1);
   double open = iOpen(_Symbol, PERIOD_CURRENT, 1);
   double high = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double low = iLow(_Symbol, PERIOD_CURRENT, 1);
   
   double lowFastBuffer[];
   ArraySetAsSeries(lowFastBuffer,true);
   double lowFastEMA = iMA(_Symbol, PERIOD_CURRENT, fastEMA, 1, MODE_EMA, PRICE_LOW);
   CopyBuffer(lowFastEMA,0,0,1,lowFastBuffer);
   
   bool condition = (close < open) && (high > lowFastBuffer[0]) && (close < lowFastBuffer[0]);
   return condition;
}