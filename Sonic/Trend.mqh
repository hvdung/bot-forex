//+------------------------------------------------------------------+
//|                                                        Trend.mqh |
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
//+-----Hàm kiểm tra xem có phải uptrend hay không?-----+
bool IsUpTrend()
{
   double fastBuffer[];
   double highFastBuffer[];
   double lowFastBuffer[];
   double slowBuffer[];
   ArraySetAsSeries(fastBuffer,true);
   ArraySetAsSeries(highFastBuffer,true);
   ArraySetAsSeries(lowFastBuffer,true);
   ArraySetAsSeries(slowBuffer,true);
   double ema34 = iMA(_Symbol, PERIOD_CURRENT, fastEMA, 0, MODE_EMA, PRICE_CLOSE);
   double highema34 = iMA(_Symbol, PERIOD_CURRENT, fastEMA, 0, MODE_EMA, PRICE_HIGH);
   double lowema34 = iMA(_Symbol, PERIOD_CURRENT, fastEMA, 0, MODE_EMA, PRICE_LOW);
   double ema89 = iMA(_Symbol, PERIOD_CURRENT, slowEMA, 0, MODE_EMA, PRICE_CLOSE);
   CopyBuffer(ema34,0,0,1,fastBuffer);
   CopyBuffer(highema34,0,0,1,highFastBuffer);
   CopyBuffer(lowema34,0,0,1,lowFastBuffer);
   CopyBuffer(ema89,0,0,1,slowBuffer);
   double valueEMA34 = fastBuffer[0];
   double valueHighEMA34 = highFastBuffer[0];
   double valueLowEMA34 = lowFastBuffer[0];
   double valueEMA89 = slowBuffer[0];

   if(valueEMA34 > valueEMA89 && valueHighEMA34 > valueEMA89 && valueLowEMA34 > valueEMA89){
      return true;
   } else {
      return false;
   }
}

bool IsDownTrend()
{
   double fastBuffer[];
   double highFastBuffer[];
   double lowFastBuffer[];
   double slowBuffer[];
   ArraySetAsSeries(fastBuffer,true);
   ArraySetAsSeries(highFastBuffer,true);
   ArraySetAsSeries(lowFastBuffer,true);
   ArraySetAsSeries(slowBuffer,true);
   double ema34 = iMA(_Symbol, PERIOD_CURRENT, fastEMA, 0, MODE_EMA, PRICE_CLOSE);
   double highema34 = iMA(_Symbol, PERIOD_CURRENT, fastEMA, 0, MODE_EMA, PRICE_HIGH);
   double lowema34 = iMA(_Symbol, PERIOD_CURRENT, fastEMA, 0, MODE_EMA, PRICE_LOW);
   double ema89 = iMA(_Symbol, PERIOD_CURRENT, slowEMA, 0, MODE_EMA, PRICE_CLOSE);
   CopyBuffer(ema34,0,0,1,fastBuffer);
   CopyBuffer(highema34,0,0,1,highFastBuffer);
   CopyBuffer(lowema34,0,0,1,lowFastBuffer);
   CopyBuffer(ema89,0,0,1,slowBuffer);
   double valueEMA34 = fastBuffer[0];
   double valueHighEMA34 = highFastBuffer[0];
   double valueLowEMA34 = lowFastBuffer[0];
   double valueEMA89 = slowBuffer[0];

   if(valueEMA34 < valueEMA89 && valueHighEMA34 < valueEMA89 && valueLowEMA34 < valueEMA89){
      return true;
   } else {
      return false;
   }
}