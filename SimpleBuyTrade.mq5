//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#include <Sonic\EntryCondition.mqh>
#include <Sonic\Trend.mqh>
#include <Sonic\TrailingStop.mqh>
CTrade trade;

#define OP_BUY 0
#define OP_SELL 1

input double RiskPercent = 2; // Tỉ lệ rủi ro
input int StopLossATR = 2; // Số lần ATR để đặt Stop Loss
input int Reward = 2; // Số lần take profit
input int fastEMA = 21; // EMA nhanh
input int slowEMA = 89; // EMA chậm

input bool use_time =true;
input string timeStart = "07:00";
input string timeEnd = "17:00";
input int GMT=0;//GMT+7
input string dayofweek = "/2/3/4/5/6/";


void OnTick()
 {
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double Balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double Equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double Close = iClose(_Symbol,PERIOD_CURRENT,0);
   
   int hour = StringToInteger(StringSubstr(timeStart, 0, 2));
   int minute = StringToInteger(StringSubstr(timeStart, 3, 2));
   datetime doit = iTime(Symbol(), PERIOD_D1, 0) + ((hour*60)+minute)*60 ;

   hour = StringSubstr(timeEnd,0,2);
   minute = StringSubstr(timeEnd,3,2);
   datetime stopit = iTime(Symbol(), PERIOD_D1, 0) + (hour*60+minute)*60;

   datetime current_time = TimeCurrent() + GMT*60*60;

   if(current_time >= doit && current_time < stopit) 
   {
      
      if (IsUpTrend())
      {
         if (EntryBuyCondition())
         {
            BuyOnBreakout(Ask);
         }
         
      } else if (IsDownTrend())
      {
         if (EntrySellCondition())
         {
            SellOnBreakout(Bid);
         }
         
      } 
   }
 }

double CalculatePips(double doubleATR) {
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE); // lấy giá trị của một bước giá
   double pipValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE); // lấy giá trị của một pip
   double pipCountX = doubleATR / tickSize / pipValue;
   int pipCount = (int)MathRound(pipCountX);

   return pipCount ;
}



double CalculateATR()
{
   double atrBuffer[];
   double atr = iATR(_Symbol,PERIOD_CURRENT,14);
   ArraySetAsSeries(atrBuffer, true);
   CopyBuffer(atr,0,0,5,atrBuffer);  
   if (atrBuffer[0] > 0)
   {
      double doubleATR = atrBuffer[0] * StopLossATR;
      return doubleATR;
   }
   else {
      Alert("ERROR: ATR equal 0");
      return 1;
   }
}

double CalculateLotSize()
{
   double pipCount = CalculatePips(CalculateATR());
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double riskMoney = AccountInfoDouble(ACCOUNT_BALANCE) * (RiskPercent / 100);
   double moneyLotstep = pipCount * tickValue * lotStep;
   double lots = riskMoney / moneyLotstep * lotStep;

   return NormalizeDouble(lots,2);

}



void BuyOnBreakout(double Ask)
{
   double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double stopLossPrice = currentPrice - CalculateATR();
   // Không đặt chốt lời => set 0
   double TPPrice = currentPrice + Reward * CalculateATR(); 

   // Nếu chưa có order nào thì thực hiện mua

   if(PositionsTotal() == 0){
      trade.Buy(CalculateLotSize(), NULL, Ask, stopLossPrice, TPPrice, "Test lenh mua");
   }
   UpdateTrailingStopLong();
}



void SellOnBreakout(double Bid)
{
   double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double stopLossPrice = currentPrice + CalculateATR();
   // Nếu chưa có order nào thì thực hiện bán
   double TPPrice = currentPrice - Reward * CalculateATR();

   if(PositionsTotal() == 0){
      trade.Sell(CalculateLotSize(), NULL, Bid, stopLossPrice, TPPrice, "Test lenh ban");
   }
   UpdateTrailingStopShort();
}

void CloseAllPosition()
{
   string symbol = Symbol();
   for(int i=0; i<PositionsTotal(); i++)
   {
      string positionSymbol = PositionGetSymbol(i);
      if (positionSymbol == symbol)
      {
         int ticket = PositionGetTicket(i);
         trade.PositionClose(ticket);
      }
   }
}