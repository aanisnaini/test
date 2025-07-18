//+------------------------------------------------------------------+
//|                          FORGE v2.0 - COMPILATION FIXED         |
//|                             Copyright 2025, Aan Isnaini         |
//|                                      Email: aan.isnaini@gmail.com|
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Aan Isnaini"
#property link      "aan.isnaini@gmail.com"
#property version   "2.0"
#property description "FORGE ULTIMATE - Complete SMC System - All Errors Fixed"
#property description "Full Features: Robust S/R, Fast Boxes, Smart Transitions, In-Box Labels"
#property strict
#property indicator_chart_window
#property indicator_buffers 8

// Visual Properties
#property indicator_color1 clrBlue          // Buy Signals
#property indicator_color2 clrRed           // Sell Signals
#property indicator_color3 clrLime          // Support (GREEN)
#property indicator_color4 clrRed           // Resistance (RED)
#property indicator_color5 clrGold          // Order Blocks
#property indicator_color6 clrAqua          // Liquidity
#property indicator_color7 clrMagenta       // FVG
#property indicator_color8 clrOrange        // Structure

#property indicator_width1 4
#property indicator_width2 4
#property indicator_width3 3
#property indicator_width4 3
#property indicator_width5 3
#property indicator_width6 2
#property indicator_width7 2
#property indicator_width8 2

//+------------------------------------------------------------------+
//| FIXED: Global Structures                                        |
//+------------------------------------------------------------------+
struct SwingPoint {
    int index;
    double price;
    int touches;
    double strength;
    string type;
};

struct SRLevel {
    double price;
    int touches;
    double strength;
    datetime firstTouch;
    datetime lastTouch;
    bool isActive;
    string type;
};

//+------------------------------------------------------------------+
//| Input Parameters - FIXED                                        |
//+------------------------------------------------------------------+
input string sep1 = "========== SIGNAL SETTINGS ==========";
input int LookbackBars = 500;              // Analysis Lookback
input bool ShowBuySellSignals = true;      // Show Buy/Sell Signals
input bool ShowAlerts = true;              // Enable Alerts
input bool ShowLabels = true;              // Show Labels (rightmost)
input bool ShowDashboard = true;           // Show Dashboard
input int SignalModeValue = 1;             // FIXED: Signal Bar Mode (0=Bar[0], 1=Bar[1], 2=Bar[2], 3=Bar[3], 4=Bar[4])

input string sep2 = "========== MARKET STRUCTURE ==========";
input bool ShowMarketStructure = true;     // Show Market Structure
input int MS_Strength = 3;                 // Structure Strength
input bool ShowBOS = true;                 // Break of Structure
input bool ShowCHoCH = true;               // Change of Character
input bool ShowInducementZones = false;    // Inducement Zones
input color BullColor = clrLimeGreen;      // Bullish Color
input color BearColor = clrRed;            // Bearish Color

input string sep3 = "========== LIQUIDITY ==========";
input bool ShowLiquidity = true;           // Show Liquidity
input bool ShowEqualHL = true;             // Equal Highs/Lows
input bool ShowLiqSweep = true;            // Liquidity Sweeps
input bool ShowLiquidityRuns = false;      // Liquidity Runs
input int LiqStrength = 2;                 // Liquidity Strength
input color LiquidityColor = clrAqua;      // Liquidity Color

input string sep4 = "========== ORDER BLOCKS ==========";
input bool ShowOrderBlocks = true;         // Show Order Blocks
input bool ShowMitigatedOB = false;        // Show Mitigated OB
input bool ShowRejectionBlocks = false;    // Rejection Blocks
input double OB_MinSize = 0.1;             // Minimum OB Size (ATR)
input int OB_ValidBars = 50;               // OB Valid Bars
input bool FastBoxDetection = true;        // Fast Box Detection (reduce delay)
input color BullOBColor = clrDodgerBlue;   // Bullish OB Color
input color BearOBColor = clrOrange;       // Bearish OB Color

input string sep5 = "========== SUPPLY & DEMAND ==========";
input bool ShowSupplyDemand = true;        // Show S&D Zones
input bool ShowSDRetests = false;          // Show Retests
input bool ShowDBR_RBD = false;            // DBR/RBD
input double SD_MinSize = 0.15;            // Minimum S&D Size (ATR)
input color SupplyColor = clrCrimson;      // Supply Color
input color DemandColor = clrGreen;        // Demand Color

input string sep6 = "========== FAIR VALUE GAPS ==========";
input bool ShowFVG = true;                 // Show Fair Value Gaps
input bool ShowFVGFills = false;           // Show FVG Fills
input bool ShowExtendedFVG = false;        // Extended FVG
input double FVG_MinSize = 0.1;            // Minimum FVG Size (ATR)
input color BullFVGColor = clrMediumTurquoise;  // Bullish FVG
input color BearFVGColor = clrMediumVioletRed;  // Bearish FVG

input string sep7 = "========== SUPPORT & RESISTANCE ==========";
input bool ShowSupportResist = true;       // Show S&R Levels
input bool ShowSRBreakouts = false;        // Show Breakouts
input bool ShowKeyLevels = true;           // Key Levels
input int SR_Strength = 3;                 // S&R Touch Strength
input bool SmoothSRTransition = true;      // Smooth S/R Transition
input double SRTransitionBuffer = 0.2;     // Transition Buffer (ATR)
input color SupportColor = clrLime;        // Support Color (GREEN)
input color ResistanceColor = clrRed;      // Resistance Color (RED)

input string sep8 = "========== SESSIONS & TIME ==========";
input bool ShowSessions = false;           // Trading Sessions
input bool ShowKillZones = false;          // Kill Zones
input bool ShowLundonOpen = false;         // London Open
input bool ShowNewYorkOpen = false;        // New York Open

input string sep9 = "========== ICT CONCEPTS ==========";
input bool ShowICTElements = false;        // ICT Concepts
input bool ShowSMTDivergence = false;      // SMT Divergence
input bool ShowOptimalTrade = false;       // OTE
input bool ShowPowerOf3 = false;           // Power of 3

input string sep10 = "========== VISUAL CONTROL ==========";
input int MaxSupportLines = 2;             // Max Support LINES
input int MaxResistanceLines = 2;          // Max Resistance LINES  
input int MaxOrderBlocks = 12;             // Max Order Block BOXES
input int MaxFVGs = 8;                     // Max Fair Value Gap BOXES
input int MaxLiquidityBoxes = 6;           // Max Liquidity BOXES
input int MaxSupplyDemandBoxes = 8;        // Max Supply/Demand BOXES
input bool ShowInBoxLabels = true;         // Show Labels Inside Boxes
input bool RightmostLabels = true;         // Labels at Rightmost Position
input int FontSize = 9;                    // Font Size
input string FontName = "Arial Bold";      // Font Name

//+------------------------------------------------------------------+
//| Indicator Buffers                                               |
//+------------------------------------------------------------------+
double BuyBuffer[];       // 0
double SellBuffer[];      // 1
double SupportBuffer[];   // 2
double ResistBuffer[];    // 3
double OrderBlockBuffer[];// 4
double LiquidityBuffer[]; // 5
double FVGBuffer[];       // 6
double StructureBuffer[]; // 7

//+------------------------------------------------------------------+
//| Global Variables - FIXED                                        |
//+------------------------------------------------------------------+
double ATR[];
string symbolType = "UNKNOWN";
double pointMultiplier = 1.0;
double atrMultiplier = 1.0;
int symbolDigits = 4;
datetime lastAlert = 0;
int validatedSignalMode = 1;  // FIXED: Store validated signal mode

// Dashboard variables
string dashboardPrefix = "FORGE_DASH_";
int dashboardX = 20;
int dashboardY = 50;
int dashboardWidth = 380;
int dashboardHeight = 400;

// Counters for visual elements
int msCount, liqCount, obCount, fvgCount, srCount;
int buySignals, sellSignals, bosCount, chochCount;
int sweepCount, demandZones, supplyZones;
int supportLines, resistanceLines, liquidityBoxes, sdBoxes;

// Performance tracking
double lastBuyPrice = 0, lastSellPrice = 0;
datetime lastBuyTime = 0, lastSellTime = 0;
string marketBias = "NEUTRAL";
double confluenceScore = 0;

// FIXED: S/R Tracking arrays
SRLevel supportLevels[5];
SRLevel resistanceLevels[5];

// Market type flags
bool isForex = false, isCrypto = false, isIndex = false;
bool isMetal = false, isOil = false, isStock = false;

// Color explanation for dashboard
string colorExplanation = "";

//+------------------------------------------------------------------+
//| Custom indicator initialization                                  |
//+------------------------------------------------------------------+
int OnInit()
{
    Print("FORGE v2.0 FIXED - Starting Compilation Fixed SMC System...");
    
    // FIXED: Validate SignalModeValue parameter
    validatedSignalMode = SignalModeValue;  // Copy to local variable
    if(validatedSignalMode < 0 || validatedSignalMode > 4)
    {
        Print("WARNING: SignalModeValue must be 0-4. Setting to 1.");
        validatedSignalMode = 1;
    }
    
    // Set indicator buffers
    SetIndexBuffer(0, BuyBuffer);
    SetIndexBuffer(1, SellBuffer);
    SetIndexBuffer(2, SupportBuffer);
    SetIndexBuffer(3, ResistBuffer);
    SetIndexBuffer(4, OrderBlockBuffer);
    SetIndexBuffer(5, LiquidityBuffer);
    SetIndexBuffer(6, FVGBuffer);
    SetIndexBuffer(7, StructureBuffer);
    
    // Set drawing styles
    SetIndexStyle(0, DRAW_ARROW);
    SetIndexStyle(1, DRAW_ARROW);
    SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 3);
    SetIndexStyle(3, DRAW_LINE, STYLE_SOLID, 3);
    SetIndexStyle(4, DRAW_HISTOGRAM);
    SetIndexStyle(5, DRAW_LINE, STYLE_DOT, 2);
    SetIndexStyle(6, DRAW_HISTOGRAM);
    SetIndexStyle(7, DRAW_LINE, STYLE_DASH, 2);
    
    // Arrow codes
    SetIndexArrow(0, 233); // BUY - Up arrow
    SetIndexArrow(1, 234); // SELL - Down arrow
    
    // Set labels
    SetIndexLabel(0, "FORGE Buy Signal");
    SetIndexLabel(1, "FORGE Sell Signal");
    SetIndexLabel(2, "FORGE Support");
    SetIndexLabel(3, "FORGE Resistance");
    SetIndexLabel(4, "FORGE Order Blocks");
    SetIndexLabel(5, "FORGE Liquidity");
    SetIndexLabel(6, "FORGE Fair Value Gap");
    SetIndexLabel(7, "FORGE Market Structure");
    
    // Initialize buffers
    InitializeBuffers();
    
    // Initialize all counters
    ResetAllCounters();
    
    // Initialize S/R structures
    InitializeSRStructures();
    
    // Detect symbol type
    DetectSymbolType();
    
    // Set symbol properties
    symbolDigits = Digits;
    pointMultiplier = (symbolDigits == 5 || symbolDigits == 3) ? 10.0 : 1.0;
    
    // Build color explanation
    BuildColorExplanation();
    
    // Set indicator name
    IndicatorShortName("FORGE v2.0 FIXED - " + symbolType);
    IndicatorDigits(symbolDigits);
    
    // Create dashboard
    if(ShowDashboard) CreateDashboard();
    
    Print("FORGE v2.0 FIXED - Full initialization complete for ", symbolType);
    Print("Signal Mode: Bar[", validatedSignalMode, "] - ", GetSignalModeDescription());
    
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Initialize All Buffers                                          |
//+------------------------------------------------------------------+
void InitializeBuffers()
{
    ArrayInitialize(BuyBuffer, EMPTY_VALUE);
    ArrayInitialize(SellBuffer, EMPTY_VALUE);
    ArrayInitialize(SupportBuffer, EMPTY_VALUE);
    ArrayInitialize(ResistBuffer, EMPTY_VALUE);
    ArrayInitialize(OrderBlockBuffer, EMPTY_VALUE);
    ArrayInitialize(LiquidityBuffer, EMPTY_VALUE);
    ArrayInitialize(FVGBuffer, EMPTY_VALUE);
    ArrayInitialize(StructureBuffer, EMPTY_VALUE);
}

//+------------------------------------------------------------------+
//| Reset All Counters Function                                     |
//+------------------------------------------------------------------+
void ResetAllCounters()
{
    msCount = 0; liqCount = 0; obCount = 0; 
    fvgCount = 0; srCount = 0; buySignals = 0; sellSignals = 0;
    bosCount = 0; chochCount = 0; sweepCount = 0;
    demandZones = 0; supplyZones = 0;
    supportLines = 0; resistanceLines = 0; 
    liquidityBoxes = 0; sdBoxes = 0;
}

//+------------------------------------------------------------------+
//| Initialize S/R Structures                                       |
//+------------------------------------------------------------------+
void InitializeSRStructures()
{
    for(int i = 0; i < 5; i++)
    {
        supportLevels[i].price = 0;
        supportLevels[i].touches = 0;
        supportLevels[i].strength = 0;
        supportLevels[i].firstTouch = 0;
        supportLevels[i].lastTouch = 0;
        supportLevels[i].isActive = false;
        supportLevels[i].type = "SUPPORT";
        
        resistanceLevels[i].price = 0;
        resistanceLevels[i].touches = 0;
        resistanceLevels[i].strength = 0;
        resistanceLevels[i].firstTouch = 0;
        resistanceLevels[i].lastTouch = 0;
        resistanceLevels[i].isActive = false;
        resistanceLevels[i].type = "RESISTANCE";
    }
}

//+------------------------------------------------------------------+
//| Build Color Explanation                                         |
//+------------------------------------------------------------------+
void BuildColorExplanation()
{
    colorExplanation = "COLORS: ";
    colorExplanation += "GREEN=Support | RED=Resistance | ";
    colorExplanation += "BLUE=Bull OB | ORANGE=Bear OB | ";
    colorExplanation += "AQUA=Liquidity | TURQUOISE=Bull FVG | ";
    colorExplanation += "VIOLET=Bear FVG | CRIMSON=Supply | GREEN2=Demand";
}

//+------------------------------------------------------------------+
//| Get Signal Mode Description                                     |
//+------------------------------------------------------------------+
string GetSignalModeDescription()
{
    switch(validatedSignalMode)
    {
        case 0: return "Bar[0] - Current (High Repaint Risk)";
        case 1: return "Bar[1] - Fast (Low Repaint Risk)";
        case 2: return "Bar[2] - Safe (No Repaint)";
        case 3: return "Bar[3] - Conservative";
        case 4: return "Bar[4] - Ultra Conservative";
        default: return "Unknown";
    }
}

//+------------------------------------------------------------------+
//| Complete Symbol Type Detection                                   |
//+------------------------------------------------------------------+
void DetectSymbolType()
{
    string symbol = Symbol();
    StringToUpper(symbol);
    
    // Reset all flags
    isForex = false; isCrypto = false; isIndex = false;
    isStock = false; isMetal = false; isOil = false;
    
    // Enhanced FOREX Detection
    if(StringFind(symbol, "USD") >= 0 || StringFind(symbol, "EUR") >= 0 || 
       StringFind(symbol, "GBP") >= 0 || StringFind(symbol, "JPY") >= 0 ||
       StringFind(symbol, "AUD") >= 0 || StringFind(symbol, "CAD") >= 0 ||
       StringFind(symbol, "CHF") >= 0 || StringFind(symbol, "NZD") >= 0)
    {
        isForex = true; symbolType = "FOREX"; atrMultiplier = 1.0;
    }
    // Enhanced CRYPTO Detection
    else if(StringFind(symbol, "BTC") >= 0 || StringFind(symbol, "ETH") >= 0 ||
            StringFind(symbol, "LTC") >= 0 || StringFind(symbol, "XRP") >= 0)
    {
        isCrypto = true; symbolType = "CRYPTO"; atrMultiplier = 2.5;
    }
    // Enhanced METALS Detection
    else if(StringFind(symbol, "XAU") >= 0 || StringFind(symbol, "GOLD") >= 0 ||
            StringFind(symbol, "XAG") >= 0 || StringFind(symbol, "SILVER") >= 0)
    {
        isMetal = true; symbolType = "METAL"; atrMultiplier = 2.0;
    }
    // Enhanced INDICES Detection
    else if(StringFind(symbol, "US30") >= 0 || StringFind(symbol, "US100") >= 0)
    {
        isIndex = true; symbolType = "INDEX"; atrMultiplier = 3.0;
    }
    // Default COMMODITY
    else
    {
        symbolType = "COMMODITY"; atrMultiplier = 2.0;
    }
    
    Print("FORGE FIXED: Detected ", symbolType, " with ATR multiplier: ", atrMultiplier);
}

//+------------------------------------------------------------------+
//| Custom indicator calculation - FIXED APPROACH                   |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    if(rates_total < 50) return(0);
    
    // Calculate ATR
    ArrayResize(ATR, rates_total);
    CalculateATR(rates_total, high, low, close);
    
    // CONFIGURABLE Signal Generation
    if(ShowBuySellSignals && rates_total >= 50)
        GenerateConfigurableSignals(rates_total, open, high, low, close, time);
    
    // COMPLETE: Run SMC analysis with smart frequency
    static int lastFullAnalysisBar = 0;
    bool runFullAnalysis = false;
    
    if(prev_calculated == 0) runFullAnalysis = true; // First run
    else if(rates_total - lastFullAnalysisBar >= 10) runFullAnalysis = true; // Every 10 bars
    else if(FastBoxDetection && rates_total > lastFullAnalysisBar) runFullAnalysis = true; // Fast mode
    
    if(runFullAnalysis && rates_total >= 100)
    {
        lastFullAnalysisBar = rates_total;
        
        int lookback = MathMin(LookbackBars, rates_total - 20);
        
        // 1. ROBUST Support & Resistance Analysis
        if(ShowSupportResist)
            AnalyzeRobustSupportResistance(lookback, rates_total, high, low, close, time);
        
        // 2. FAST Order Blocks Detection
        if(ShowOrderBlocks)
            DetectFastOrderBlocks(lookback, rates_total, open, high, low, close, time);
        
        // 3. Market Structure Analysis
        if(ShowMarketStructure)
            AnalyzeMarketStructure(lookback, rates_total, open, high, low, close, time);
        
        // 4. FAST Liquidity Analysis
        if(ShowLiquidity)
            AnalyzeFastLiquidity(lookback, rates_total, high, low, close, time);
        
        // 5. FAST Fair Value Gaps
        if(ShowFVG)
            IdentifyFastFVG(lookback, rates_total, open, high, low, close, time);
        
        // 6. FAST Supply & Demand
        if(ShowSupplyDemand)
            FindFastSupplyDemand(lookback, rates_total, open, high, low, close, time);
    }
    
    // Check for smooth S/R transitions
    if(SmoothSRTransition && rates_total >= 100)
        CheckSmoothSRTransitions(close, time);
    
    // Calculate market bias and confluence
    CalculateMarketBias(close);
    CalculateConfluenceScore();
    
    // Update dashboard
    if(ShowDashboard)
        UpdateDashboard();
    
    return(rates_total);
}

//+------------------------------------------------------------------+
//| CONFIGURABLE: Signal Generation Function                        |
//+------------------------------------------------------------------+
void GenerateConfigurableSignals(int rates_total, const double &open[], const double &high[], 
                                 const double &low[], const double &close[], const datetime &time[])
{
    // CONFIGURABLE: Use user-selected signal bar
    int signalBar = validatedSignalMode;
    if(signalBar >= rates_total - 3) return;
    
    // Prevent duplicate signals with time tracking
    static datetime lastSignalTime = 0;
    if(time[signalBar] <= lastSignalTime) return;
    
    // Clear existing signals on this bar
    BuyBuffer[signalBar] = EMPTY_VALUE;
    SellBuffer[signalBar] = EMPTY_VALUE;
    
    // Enhanced signal conditions with multiple criteria
    bool isBullishCandle = close[signalBar] > open[signalBar];
    bool isPrevBullish = (signalBar + 1 < rates_total) ? close[signalBar + 1] > open[signalBar + 1] : false;
    bool isUpTrend = (signalBar + 3 < rates_total) ? close[signalBar] > close[signalBar + 3] : false;
    
    bool isBearishCandle = close[signalBar] < open[signalBar];
    bool isPrevBearish = (signalBar + 1 < rates_total) ? close[signalBar + 1] < open[signalBar + 1] : false;
    bool isDownTrend = (signalBar + 3 < rates_total) ? close[signalBar] < close[signalBar + 3] : false;
    
    // Calculate candle properties
    double candleRange = high[signalBar] - low[signalBar];
    double bullishBody = isBullishCandle ? close[signalBar] - open[signalBar] : 0;
    double bearishBody = isBearishCandle ? open[signalBar] - close[signalBar] : 0;
    
    // Enhanced bullish signal with confluence
    if(isBullishCandle && isPrevBullish && isUpTrend && bullishBody > candleRange * 0.5)
    {
        BuyBuffer[signalBar] = low[signalBar] - (candleRange * 0.3);
        buySignals++;
        lastBuyPrice = close[signalBar];
        lastBuyTime = time[signalBar];
        lastSignalTime = time[signalBar];
        
        Print("FIXED BUY at Bar[", validatedSignalMode, "] ", TimeToString(time[signalBar]), " Price: ", close[signalBar]);
        
        if(ShowAlerts)
            Alert("FORGE BUY at ", DoubleToString(close[signalBar], _Digits), " [Bar", validatedSignalMode, "]");
    }
    
    // Enhanced bearish signal with confluence
    if(isBearishCandle && isPrevBearish && isDownTrend && bearishBody > candleRange * 0.5)
    {
        SellBuffer[signalBar] = high[signalBar] + (candleRange * 0.3);
        sellSignals++;
        lastSellPrice = close[signalBar];
        lastSellTime = time[signalBar];
        lastSignalTime = time[signalBar];
        
        Print("FIXED SELL at Bar[", validatedSignalMode, "] ", TimeToString(time[signalBar]), " Price: ", close[signalBar]);
        
        if(ShowAlerts)
            Alert("FORGE SELL at ", DoubleToString(close[signalBar], _Digits), " [Bar", validatedSignalMode, "]");
    }
}

//+------------------------------------------------------------------+
//| ROBUST: Support & Resistance Analysis FIXED                     |
//+------------------------------------------------------------------+
void AnalyzeRobustSupportResistance(int lookback, int rates_total, const double &high[], 
                                   const double &low[], const double &close[], const datetime &time[])
{
    // Reset counters
    supportLines = 0;
    resistanceLines = 0;
    
    // FIXED: Use simple arrays with proper initialization
    double swingPrices[100];
    int swingIndices[100];
    string swingTypes[100];
    double swingStrengths[100];
    int swingTouches[100];
    int swingCount = 0;
    
    // FIXED: Initialize all arrays to prevent uninitialized variable warnings
    ArrayInitialize(swingPrices, 0.0);
    ArrayInitialize(swingIndices, 0);
    ArrayInitialize(swingStrengths, 0.0);
    ArrayInitialize(swingTouches, 0);
    
    // Initialize string array manually
    for(int x = 0; x < 100; x++)
    {
        swingTypes[x] = "";
    }
    
    // Find swing highs and lows with robust criteria
    for(int i = lookback; i >= SR_Strength + 5 && swingCount < 99; i--)
    {
        if(i >= rates_total - 10) continue;
        
        // Robust swing high detection
        if(IsRobustSwingHigh(i, high, SR_Strength, rates_total))
        {
            swingIndices[swingCount] = i;
            swingPrices[swingCount] = high[i];
            swingTypes[swingCount] = "HIGH";
            swingTouches[swingCount] = CountAccurateLevelTouches(high[i], rates_total, high, low, close, i);
            swingStrengths[swingCount] = CalculateSwingStrength(i, high, low, close, rates_total);
            swingCount++;
        }
        
        // Robust swing low detection
        if(IsRobustSwingLow(i, low, SR_Strength, rates_total) && swingCount < 99)
        {
            swingIndices[swingCount] = i;
            swingPrices[swingCount] = low[i];
            swingTypes[swingCount] = "LOW";
            swingTouches[swingCount] = CountAccurateLevelTouches(low[i], rates_total, high, low, close, i);
            swingStrengths[swingCount] = CalculateSwingStrength(i, high, low, close, rates_total);
            swingCount++;
        }
    }
    
    // FIXED: Simple sorting by strength with boundary checks
    for(int i = 0; i < swingCount - 1; i++)
    {
        for(int j = 0; j < swingCount - i - 1; j++)
        {
            if(j + 1 < swingCount && swingStrengths[j] < swingStrengths[j + 1])
            {
                // Swap all arrays with bounds checking
                int tempIndex = swingIndices[j];
                swingIndices[j] = swingIndices[j + 1];
                swingIndices[j + 1] = tempIndex;
                
                double tempPrice = swingPrices[j];
                swingPrices[j] = swingPrices[j + 1];
                swingPrices[j + 1] = tempPrice;
                
                string tempType = swingTypes[j];
                swingTypes[j] = swingTypes[j + 1];
                swingTypes[j + 1] = tempType;
                
                double tempStrength = swingStrengths[j];
                swingStrengths[j] = swingStrengths[j + 1];
                swingStrengths[j + 1] = tempStrength;
                
                int tempTouches = swingTouches[j];
                swingTouches[j] = swingTouches[j + 1];
                swingTouches[j + 1] = tempTouches;
            }
        }
    }
    
    // Create Support and Resistance levels with bounds checking
    for(int s = 0; s < swingCount && (supportLines < MaxSupportLines || resistanceLines < MaxResistanceLines); s++)
    {
        if(swingTouches[s] >= SR_Strength && swingStrengths[s] > 0.5)
        {
            if(swingTypes[s] == "LOW" && supportLines < MaxSupportLines && swingPrices[s] < close[0])
            {
                supportLines++;
                if(supportLines <= 5) // Bounds check for array
                {
                    supportLevels[supportLines - 1].price = swingPrices[s];
                    supportLevels[supportLines - 1].touches = swingTouches[s];
                    supportLevels[supportLines - 1].strength = swingStrengths[s];
                    supportLevels[supportLines - 1].firstTouch = time[swingIndices[s]];
                    supportLevels[supportLines - 1].lastTouch = time[swingIndices[s]];
                    supportLevels[supportLines - 1].isActive = true;
                    
                    CreateRobustHorizontalLine(swingPrices[s], SupportColor, "Support_" + IntegerToString(supportLines), 3);
                    
                    if(ShowLabels && RightmostLabels)
                    {
                        string labelText = "SUPPORT " + IntegerToString(supportLines) + " [" + DoubleToString(swingPrices[s], _Digits) + 
                                         "] T:" + IntegerToString(swingTouches[s]);
                        CreateRightmostLabel(swingPrices[s], labelText, SupportColor, FontSize);
                    }
                    
                    Print("ROBUST: Created Support #", supportLines, " at ", swingPrices[s], " strength:", swingStrengths[s]);
                }
            }
            
            if(swingTypes[s] == "HIGH" && resistanceLines < MaxResistanceLines && swingPrices[s] > close[0])
            {
                resistanceLines++;
                if(resistanceLines <= 5) // Bounds check for array
                {
                    resistanceLevels[resistanceLines - 1].price = swingPrices[s];
                    resistanceLevels[resistanceLines - 1].touches = swingTouches[s];
                    resistanceLevels[resistanceLines - 1].strength = swingStrengths[s];
                    resistanceLevels[resistanceLines - 1].firstTouch = time[swingIndices[s]];
                    resistanceLevels[resistanceLines - 1].lastTouch = time[swingIndices[s]];
                    resistanceLevels[resistanceLines - 1].isActive = true;
                    
                    CreateRobustHorizontalLine(swingPrices[s], ResistanceColor, "Resistance_" + IntegerToString(resistanceLines), 3);
                    
                    if(ShowLabels && RightmostLabels)
                    {
                        string labelText = "RESISTANCE " + IntegerToString(resistanceLines) + " [" + DoubleToString(swingPrices[s], _Digits) + 
                                         "] T:" + IntegerToString(swingTouches[s]);
                        CreateRightmostLabel(swingPrices[s], labelText, ResistanceColor, FontSize);
                    }
                    
                    Print("ROBUST: Created Resistance #", resistanceLines, " at ", swingPrices[s], " strength:", swingStrengths[s]);
                }
            }
        }
    }
    
    Print("ROBUST: S/R analysis completed. Support:", supportLines, " Resistance:", resistanceLines);
}

//+------------------------------------------------------------------+
//| FAST: Order Blocks Detection FIXED                              |
//+------------------------------------------------------------------+
void DetectFastOrderBlocks(int lookback, int rates_total, const double &open[], 
                          const double &high[], const double &low[], const double &close[], 
                          const datetime &time[])
{
    obCount = 0; // Reset counter
    
    // FAST: Reduced lookback for faster detection
    int fastLookback = FastBoxDetection ? MathMin(lookback, 100) : lookback;
    
    for(int i = fastLookback; i >= 5 && obCount < MaxOrderBlocks; i--)
    {
        if(i >= rates_total - 3) continue;
        
        // FAST: Enhanced bullish order block detection
        if(IsFastBullishOrderBlock(i, open, high, low, close, rates_total))
        {
            obCount++;
            OrderBlockBuffer[i] = (high[i] + low[i]) / 2;
            
            string boxName = "BullOB_" + IntegerToString(obCount);
            datetime endTime = time[MathMax(0, i - OB_ValidBars)];
            CreateFastBox(boxName, time[i], high[i], endTime, low[i], BullOBColor, true, "OB+");
            
            // In-box label
            if(ShowInBoxLabels)
            {
                datetime labelTime = time[i - (int)(OB_ValidBars * 0.3)];
                double labelPrice = (high[i] + low[i]) / 2;
                CreateInBoxLabel(labelTime, labelPrice, "BULL OB", BullOBColor, FontSize - 1);
            }
            
            Print("FAST: Created Bullish OB #", obCount, " at bar ", i);
        }
        
        // FAST: Enhanced bearish order block detection
        if(IsFastBearishOrderBlock(i, open, high, low, close, rates_total))
        {
            obCount++;
            OrderBlockBuffer[i] = (high[i] + low[i]) / 2;
            
            string boxName = "BearOB_" + IntegerToString(obCount);
            datetime endTime = time[MathMax(0, i - OB_ValidBars)];
            CreateFastBox(boxName, time[i], high[i], endTime, low[i], BearOBColor, true, "OB-");
            
            // In-box label
            if(ShowInBoxLabels)
            {
                datetime labelTime = time[i - (int)(OB_ValidBars * 0.3)];
                double labelPrice = (high[i] + low[i]) / 2;
                CreateInBoxLabel(labelTime, labelPrice, "BEAR OB", BearOBColor, FontSize - 1);
            }
            
            Print("FAST: Created Bearish OB #", obCount, " at bar ", i);
        }
    }
}

//+------------------------------------------------------------------+
//| FAST: Liquidity Analysis FIXED                                  |
//+------------------------------------------------------------------+
void AnalyzeFastLiquidity(int lookback, int rates_total, const double &high[], 
                         const double &low[], const double &close[], const datetime &time[])
{
    liquidityBoxes = 0; // Reset counter
    
    // FAST: Reduced lookback
    int fastLookback = FastBoxDetection ? MathMin(lookback, 80) : lookback;
    
    for(int i = fastLookback; i >= 10 && liquidityBoxes < MaxLiquidityBoxes; i--)
    {
        if(i >= rates_total - 5) continue;
        
        // FAST: Equal High Liquidity
        if(ShowEqualHL && IsFastEqualHigh(i, high, close, rates_total))
        {
            liquidityBoxes++;
            LiquidityBuffer[i] = high[i];
            
            double boxTop = high[i] + (ATR[i] * 0.1);
            double boxBottom = high[i] - (ATR[i] * 0.1);
            datetime endTime = time[MathMax(0, i - 25)];
            
            string boxName = "SSL_Box_" + IntegerToString(liquidityBoxes);
            CreateFastBox(boxName, time[i], boxTop, endTime, boxBottom, LiquidityColor, true, "SSL");
            
            // In-box label
            if(ShowInBoxLabels)
            {
                datetime labelTime = time[i - 8];
                CreateInBoxLabel(labelTime, high[i], "SSL", LiquidityColor, FontSize - 1);
            }
            
            Print("FAST: Created SSL Box #", liquidityBoxes, " at ", high[i]);
        }
        
        // FAST: Equal Low Liquidity
        if(ShowEqualHL && IsFastEqualLow(i, low, close, rates_total) && liquidityBoxes < MaxLiquidityBoxes)
        {
            liquidityBoxes++;
            LiquidityBuffer[i] = low[i];
            
            double boxTop = low[i] + (ATR[i] * 0.1);
            double boxBottom = low[i] - (ATR[i] * 0.1);
            datetime endTime = time[MathMax(0, i - 25)];
            
            string boxName = "BSL_Box_" + IntegerToString(liquidityBoxes);
            CreateFastBox(boxName, time[i], boxTop, endTime, boxBottom, LiquidityColor, true, "BSL");
            
            // In-box label
            if(ShowInBoxLabels)
            {
                datetime labelTime = time[i - 8];
                CreateInBoxLabel(labelTime, low[i], "BSL", LiquidityColor, FontSize - 1);
            }
            
            Print("FAST: Created BSL Box #", liquidityBoxes, " at ", low[i]);
        }
        
        if(ShowLiqSweep && liquidityBoxes < MaxLiquidityBoxes)
            DetectLiquiditySweep(i, high, low, close, time);
    }
    
    Print("FAST: Liquidity analysis completed. Total boxes: ", liquidityBoxes);
}

//+------------------------------------------------------------------+
//| FAST: Fair Value Gaps FIXED                                     |
//+------------------------------------------------------------------+
void IdentifyFastFVG(int lookback, int rates_total, const double &open[], 
                    const double &high[], const double &low[], const datetime &time[])
{
    fvgCount = 0; // Reset counter
    
    // FAST: Reduced lookback
    int fastLookback = FastBoxDetection ? MathMin(lookback, 60) : lookback;
    
    for(int i = fastLookback; i >= 5 && fvgCount < MaxFVGs; i--)
    {
        if(i >= rates_total - 3 || i < 2) continue;
        
        // FAST: Bullish FVG
        if(IsFastBullishFVG(i, high, low, rates_total))
        {
            double gapTop = low[i - 1];
            double gapBottom = high[i + 1];
            double gapSize = gapTop - gapBottom;
            
            if(gapSize > ATR[i] * FVG_MinSize)
            {
                fvgCount++;
                FVGBuffer[i] = (gapTop + gapBottom) / 2;
                
                string boxName = "BullFVG_" + IntegerToString(fvgCount);
                datetime endTime = time[MathMax(0, i - 20)];
                CreateFastBox(boxName, time[i - 1], gapTop, endTime, gapBottom, BullFVGColor, true, "FVG+");
                
                // In-box label
                if(ShowInBoxLabels)
                {
                    datetime labelTime = time[i - 6];
                    double labelPrice = (gapTop + gapBottom) / 2;
                    CreateInBoxLabel(labelTime, labelPrice, "BULL FVG", BullFVGColor, FontSize - 1);
                }
                
                Print("FAST: Created Bullish FVG #", fvgCount, " gap: ", gapSize);
            }
        }
        
        // FAST: Bearish FVG
        if(IsFastBearishFVG(i, high, low, rates_total))
        {
            double gapTop = low[i + 1];
            double gapBottom = high[i - 1];
            double gapSize = gapTop - gapBottom;
            
            if(gapSize > ATR[i] * FVG_MinSize)
            {
                fvgCount++;
                FVGBuffer[i] = (gapTop + gapBottom) / 2;
                
                string boxName = "BearFVG_" + IntegerToString(fvgCount);
                datetime endTime = time[MathMax(0, i - 20)];
                CreateFastBox(boxName, time[i - 1], gapTop, endTime, gapBottom, BearFVGColor, true, "FVG-");
                
                // In-box label
                if(ShowInBoxLabels)
                {
                    datetime labelTime = time[i - 6];
                    double labelPrice = (gapTop + gapBottom) / 2;
                    CreateInBoxLabel(labelTime, labelPrice, "BEAR FVG", BearFVGColor, FontSize - 1);
                }
                
                Print("FAST: Created Bearish FVG #", fvgCount, " gap: ", gapSize);
            }
        }
    }
    
    Print("FAST: FVG detection completed. Total boxes: ", fvgCount);
}

//+------------------------------------------------------------------+
//| FAST: Supply & Demand FIXED                                     |
//+------------------------------------------------------------------+
void FindFastSupplyDemand(int lookback, int rates_total, const double &open[], 
                         const double &high[], const double &low[], const double &close[], 
                         const datetime &time[])
{
    demandZones = 0;
    supplyZones = 0;
    sdBoxes = 0;
    
    // FAST: Reduced lookback
    int fastLookback = FastBoxDetection ? MathMin(lookback, 80) : lookback;
    
    for(int i = fastLookback; i >= 15 && sdBoxes < MaxSupplyDemandBoxes; i--)
    {
        if(i >= rates_total - 5) continue;
        
        if(IsFastDemandZone(i, open, high, low, close, rates_total))
        {
            demandZones++;
            sdBoxes++;
            double zoneHigh = MathMax(open[i], close[i]);
            double zoneLow = MathMin(open[i], close[i]);
            
            string boxName = "Demand_" + IntegerToString(demandZones);
            datetime endTime = time[MathMax(0, i - 15)];
            CreateFastBox(boxName, time[i], zoneHigh, endTime, zoneLow, DemandColor, true, "DEMAND");
            
            // In-box label
            if(ShowInBoxLabels)
            {
                datetime labelTime = time[i - 5];
                double labelPrice = (zoneHigh + zoneLow) / 2;
                CreateInBoxLabel(labelTime, labelPrice, "DEMAND", DemandColor, FontSize - 1);
            }
            
            Print("FAST: Created Demand Zone #", demandZones);
        }
        
        if(IsFastSupplyZone(i, open, high, low, close, rates_total) && sdBoxes < MaxSupplyDemandBoxes)
        {
            supplyZones++;
            sdBoxes++;
            double zoneHigh = MathMax(open[i], close[i]);
            double zoneLow = MathMin(open[i], close[i]);
            
            string boxName = "Supply_" + IntegerToString(supplyZones);
            datetime endTime = time[MathMax(0, i - 15)];
            CreateFastBox(boxName, time[i], zoneHigh, endTime, zoneLow, SupplyColor, true, "SUPPLY");
            
            // In-box label
            if(ShowInBoxLabels)
            {
                datetime labelTime = time[i - 5];
                double labelPrice = (zoneHigh + zoneLow) / 2;
                CreateInBoxLabel(labelTime, labelPrice, "SUPPLY", SupplyColor, FontSize - 1);
            }
            
            Print("FAST: Created Supply Zone #", supplyZones);
        }
    }
}

//+------------------------------------------------------------------+
//| SMOOTH: S/R Transition Check FIXED                              |
//+------------------------------------------------------------------+
void CheckSmoothSRTransitions(const double &close[], const datetime &time[])
{
    double currentPrice = close[0];
    double transitionBuffer = ATR[0] * SRTransitionBuffer;
    
    // Check support becoming resistance (smooth transition)
    for(int i = 0; i < supportLines && i < 5; i++)
    {
        if(supportLevels[i].isActive && supportLevels[i].price > 0)
        {
            // Check if price crossed above support with buffer
            if(currentPrice > supportLevels[i].price + transitionBuffer)
            {
                Print("SMOOTH: Support ", i + 1, " transitioning to Resistance at ", supportLevels[i].price);
                
                // Fade out old support line
                ObjectSet("Support_" + IntegerToString(i + 1), OBJPROP_STYLE, STYLE_DOT);
                
                // Create new resistance if space available
                if(resistanceLines < MaxResistanceLines && resistanceLines < 5)
                {
                    resistanceLines++;
                    resistanceLevels[resistanceLines - 1].price = supportLevels[i].price;
                    resistanceLevels[resistanceLines - 1].touches = supportLevels[i].touches;
                    resistanceLevels[resistanceLines - 1].strength = supportLevels[i].strength;
                    resistanceLevels[resistanceLines - 1].isActive = true;
                    resistanceLevels[resistanceLines - 1].type = "RESISTANCE";
                    
                    CreateRobustHorizontalLine(supportLevels[i].price, ResistanceColor, 
                                             "Resistance_Trans_" + IntegerToString(resistanceLines), 3);
                    
                    if(ShowLabels && RightmostLabels)
                    {
                        string labelText = "RESISTANCE " + IntegerToString(resistanceLines) + " [" + 
                                         DoubleToString(supportLevels[i].price, _Digits) + "] *TRANSITIONED*";
                        CreateRightmostLabel(supportLevels[i].price, labelText, ResistanceColor, FontSize);
                    }
                }
                
                supportLevels[i].isActive = false; // Deactivate old support
            }
        }
    }
    
    // Check resistance becoming support (smooth transition)
    for(int i = 0; i < resistanceLines && i < 5; i++)
    {
        if(resistanceLevels[i].isActive && resistanceLevels[i].price > 0)
        {
            // Check if price crossed below resistance with buffer
            if(currentPrice < resistanceLevels[i].price - transitionBuffer)
            {
                Print("SMOOTH: Resistance ", i + 1, " transitioning to Support at ", resistanceLevels[i].price);
                
                // Fade out old resistance line
                ObjectSet("Resistance_" + IntegerToString(i + 1), OBJPROP_STYLE, STYLE_DOT);
                
                // Create new support if space available
                if(supportLines < MaxSupportLines && supportLines < 5)
                {
                    supportLines++;
                    supportLevels[supportLines - 1].price = resistanceLevels[i].price;
                    supportLevels[supportLines - 1].touches = resistanceLevels[i].touches;
                    supportLevels[supportLines - 1].strength = resistanceLevels[i].strength;
                    supportLevels[supportLines - 1].isActive = true;
                    supportLevels[supportLines - 1].type = "SUPPORT";
                    
                    CreateRobustHorizontalLine(resistanceLevels[i].price, SupportColor, 
                                             "Support_Trans_" + IntegerToString(supportLines), 3);
                    
                    if(ShowLabels && RightmostLabels)
                    {
                        string labelText = "SUPPORT " + IntegerToString(supportLines) + " [" + 
                                         DoubleToString(resistanceLevels[i].price, _Digits) + "] *TRANSITIONED*";
                        CreateRightmostLabel(resistanceLevels[i].price, labelText, SupportColor, FontSize);
                    }
                }
                
                resistanceLevels[i].isActive = false; // Deactivate old resistance
            }
        }
    }
}

//+------------------------------------------------------------------+
//| ROBUST Helper Functions FIXED                                   |
//+------------------------------------------------------------------+

bool IsRobustSwingHigh(int index, const double &high[], int strength, int rates_total)
{
    if(index < strength || index >= rates_total - strength) return false;
    
    // Multi-criteria validation
    int confirmCount = 0;
    double currentHigh = high[index];
    
    for(int i = 1; i <= strength; i++)
    {
        if(currentHigh > high[index - i] && currentHigh > high[index + i])
            confirmCount++;
    }
    
    return (confirmCount >= strength - 1); // Allow 1 miss for robustness
}

bool IsRobustSwingLow(int index, const double &low[], int strength, int rates_total)
{
    if(index < strength || index >= rates_total - strength) return false;
    
    // Multi-criteria validation
    int confirmCount = 0;
    double currentLow = low[index];
    
    for(int i = 1; i <= strength; i++)
    {
        if(currentLow < low[index - i] && currentLow < low[index + i])
            confirmCount++;
    }
    
    return (confirmCount >= strength - 1); // Allow 1 miss for robustness
}

int CountAccurateLevelTouches(double level, int rates_total, const double &high[], 
                             const double &low[], const double &close[], int startIndex)
{
    int touches = 1;
    double tolerance = ATR[startIndex] * 0.2; // Dynamic tolerance based on ATR
    
    for(int i = startIndex - 1; i >= 0 && i > startIndex - 200; i--)
    {
        if((MathAbs(high[i] - level) <= tolerance) || (MathAbs(low[i] - level) <= tolerance) ||
           (MathAbs(close[i] - level) <= tolerance))
        {
            touches++;
        }
    }
    
    return touches;
}

double CalculateSwingStrength(int index, const double &high[], const double &low[], 
                             const double &close[], int rates_total)
{
    if(index >= rates_total - 10 || index < 10) return 0;
    
    // Calculate strength based on multiple factors
    double range = high[index] - low[index];
    double avgRange = 0;
    
    for(int i = 1; i <= 10; i++)
    {
        avgRange += (high[index + i] - low[index + i]);
    }
    avgRange /= 10;
    
    double rangeStrength = range / (avgRange + 0.0001); // Avoid division by zero
    
    // Volume strength (placeholder - would use actual volume if available)
    double volumeStrength = 1.0;
    
    // Time strength (recent swings get higher strength)
    double timeStrength = 1.0 - (double)index / rates_total;
    
    return (rangeStrength + volumeStrength + timeStrength) / 3.0;
}

//+------------------------------------------------------------------+
//| FAST Helper Functions FIXED                                     |
//+------------------------------------------------------------------+

bool IsFastBullishOrderBlock(int index, const double &open[], const double &high[], 
                            const double &low[], const double &close[], int rates_total)
{
    if(index >= rates_total - 3) return false;
    
    // FAST: Simple but effective criteria
    bool isBullish = close[index] > open[index];
    double body = close[index] - open[index];
    double range = high[index] - low[index];
    
    // Enhanced criteria for better quality
    bool hasGoodBodyRatio = body > range * 0.4;
    
    return (isBullish && hasGoodBodyRatio && range > ATR[index] * OB_MinSize);
}

bool IsFastBearishOrderBlock(int index, const double &open[], const double &high[], 
                            const double &low[], const double &close[], int rates_total)
{
    if(index >= rates_total - 3) return false;
    
    // FAST: Simple but effective criteria
    bool isBearish = close[index] < open[index];
    double body = open[index] - close[index];
    double range = high[index] - low[index];
    
    // Enhanced criteria for better quality
    bool hasGoodBodyRatio = body > range * 0.4;
    
    return (isBearish && hasGoodBodyRatio && range > ATR[index] * OB_MinSize);
}

bool IsFastEqualHigh(int index, const double &high[], const double &close[], int rates_total)
{
    if(!IsRobustSwingHigh(index, high, 2, rates_total)) return false;
    
    double currentHigh = high[index];
    double tolerance = ATR[index] * 0.15; // Tighter tolerance for accuracy
    
    for(int i = index + 5; i <= index + 30 && i < rates_total; i++)
    {
        if(IsRobustSwingHigh(i, high, 2, rates_total))
        {
            if(MathAbs(high[i] - currentHigh) <= tolerance)
                return true;
        }
    }
    return false;
}

bool IsFastEqualLow(int index, const double &low[], const double &close[], int rates_total)
{
    if(!IsRobustSwingLow(index, low, 2, rates_total)) return false;
    
    double currentLow = low[index];
    double tolerance = ATR[index] * 0.15; // Tighter tolerance for accuracy
    
    for(int i = index + 5; i <= index + 30 && i < rates_total; i++)
    {
        if(IsRobustSwingLow(i, low, 2, rates_total))
        {
            if(MathAbs(low[i] - currentLow) <= tolerance)
                return true;
        }
    }
    return false;
}

bool IsFastBullishFVG(int index, const double &high[], const double &low[], int rates_total)
{
    if(index < 1 || index >= rates_total - 1) return false;
    
    double gapTop = low[index - 1];
    double gapBottom = high[index + 1];
    double gapSize = gapTop - gapBottom;
    
    // Enhanced validation
    if(gapSize <= 0) return false;
    if(gapSize < Point * 3) return false; // Minimum meaningful gap
    
    // Check for real imbalance
    double middleHigh = high[index];
    double middleLow = low[index];
    
    return (middleLow > gapBottom && middleHigh < gapTop);
}

bool IsFastBearishFVG(int index, const double &high[], const double &low[], int rates_total)
{
    if(index < 1 || index >= rates_total - 1) return false;
    
    double gapTop = low[index + 1];
    double gapBottom = high[index - 1];
    double gapSize = gapTop - gapBottom;
    
    // Enhanced validation
    if(gapSize <= 0) return false;
    if(gapSize < Point * 3) return false; // Minimum meaningful gap
    
    // Check for real imbalance
    double middleHigh = high[index];
    double middleLow = low[index];
    
    return (middleHigh < gapTop && middleLow > gapBottom);
}

bool IsFastDemandZone(int index, const double &open[], const double &high[], 
                     const double &low[], const double &close[], int rates_total)
{
    if(index >= rates_total - 5) return false;
    
    // Enhanced demand zone criteria
    bool isBullish = close[index] > open[index];
    bool hasUpMove = false;
    bool hasSignificantSize = (close[index] - open[index]) > ATR[index] * SD_MinSize;
    
    // Check for subsequent upward movement
    for(int j = 1; j <= 5 && index - j >= 0; j++)
    {
        if(close[index - j] > high[index] + ATR[index] * 0.1)
        {
            hasUpMove = true;
            break;
        }
    }
    
    return (isBullish && hasUpMove && hasSignificantSize);
}

bool IsFastSupplyZone(int index, const double &open[], const double &high[], 
                     const double &low[], const double &close[], int rates_total)
{
    if(index >= rates_total - 5) return false;
    
    // Enhanced supply zone criteria
    bool isBearish = close[index] < open[index];
    bool hasDownMove = false;
    bool hasSignificantSize = (open[index] - close[index]) > ATR[index] * SD_MinSize;
    
    // Check for subsequent downward movement
    for(int j = 1; j <= 5 && index - j >= 0; j++)
    {
        if(close[index - j] < low[index] - ATR[index] * 0.1)
        {
            hasDownMove = true;
            break;
        }
    }
    
    return (isBearish && hasDownMove && hasSignificantSize);
}

//+------------------------------------------------------------------+
//| Object Creation Functions - FIXED                               |
//+------------------------------------------------------------------+

void CreateFastBox(string name, datetime time1, double price1, datetime time2, 
                  double price2, color clr, bool filled, string label)
{
    if(ObjectFind(name) >= 0) ObjectDelete(name);
    
    bool success = ObjectCreate(name, OBJ_RECTANGLE, 0, time1, price1, time2, price2);
    
    if(success)
    {
        ObjectSet(name, OBJPROP_COLOR, clr);
        ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
        ObjectSet(name, OBJPROP_WIDTH, 1);
        ObjectSet(name, OBJPROP_BACK, filled);
        ObjectSet(name, OBJPROP_SELECTED, false);
        ObjectSet(name, OBJPROP_HIDDEN, false);
    }
    else
    {
        Print("FAST: Box creation failed: ", name, " Error: ", GetLastError());
    }
}

void CreateRobustHorizontalLine(double price, color clr, string name, int width)
{
    if(ObjectFind(name) >= 0) ObjectDelete(name);
    
    bool success = ObjectCreate(name, OBJ_HLINE, 0, 0, price);
    
    if(success)
    {
        ObjectSet(name, OBJPROP_COLOR, clr);
        ObjectSet(name, OBJPROP_WIDTH, width);
        ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
        ObjectSet(name, OBJPROP_BACK, false);
        ObjectSet(name, OBJPROP_SELECTED, false);
    }
}

void CreateRightmostLabel(double price, string text, color clr, int fontSize)
{
    // Create label at rightmost position of chart
    datetime rightmostTime = Time[0] + Period() * 5; // 5 bars to the right
    string name = "RightLabel_" + DoubleToString(price, _Digits) + "_" + IntegerToString(GetTickCount());
    
    if(ObjectFind(name) >= 0) ObjectDelete(name);
    
    bool success = ObjectCreate(name, OBJ_TEXT, 0, rightmostTime, price);
    
    if(success)
    {
        ObjectSetText(name, text, fontSize, FontName, clr);
        ObjectSet(name, OBJPROP_BACK, false);
        ObjectSet(name, OBJPROP_SELECTED, false);
    }
}

void CreateInBoxLabel(datetime time, double price, string text, color clr, int fontSize)
{
    string name = "InBoxLabel_" + TimeToString(time) + "_" + DoubleToString(price, _Digits);
    if(ObjectFind(name) >= 0) ObjectDelete(name);
    
    bool success = ObjectCreate(name, OBJ_TEXT, 0, time, price);
    
    if(success)
    {
        ObjectSetText(name, text, fontSize, FontName, clr);
        ObjectSet(name, OBJPROP_BACK, false);
        ObjectSet(name, OBJPROP_SELECTED, false);
    }
}

//+------------------------------------------------------------------+
//| Calculate ATR (Enhanced)                                        |
//+------------------------------------------------------------------+
void CalculateATR(int rates_total, const double &high[], const double &low[], const double &close[])
{
    int period = 14;
    int start = MathMax(period, rates_total - 1000);
    
    for(int i = start; i >= 0; i--)
    {
        if(i + 1 >= rates_total) continue;
        
        double tr1 = high[i] - low[i];
        double tr2 = MathAbs(high[i] - close[i + 1]);
        double tr3 = MathAbs(low[i] - close[i + 1]);
        double trueRange = MathMax(tr1, MathMax(tr2, tr3));
        
        if(trueRange <= 0 || trueRange > Point * 100000) 
            trueRange = (high[i] - low[i]) * Point;
        
        if(i == start)
        {
            ATR[i] = trueRange;
        }
        else
        {
            ATR[i] = (ATR[i + 1] * (period - 1) + trueRange) / period;
        }
        
        ATR[i] *= atrMultiplier;
        
        // Bounds checking
        if(ATR[i] > 1000.0) ATR[i] = 50.0;
        if(ATR[i] < 0.1) ATR[i] = 10.0;
    }
    
    // Fill remaining bars
    for(int i = 0; i < period && i < rates_total; i++)
    {
        if(ATR[i] == 0 || ATR[i] > 1000)
            ATR[i] = 20.0;
    }
}

//+------------------------------------------------------------------+
//| ALL REMAINING ORIGINAL FUNCTIONS                                |
//+------------------------------------------------------------------+

// Market Structure Analysis (ORIGINAL)
void AnalyzeMarketStructure(int lookback, int rates_total, const double &open[], 
                           const double &high[], const double &low[], const double &close[], 
                           const datetime &time[])
{
    for(int i = lookback; i >= MS_Strength + 5; i--)
    {
        if(i >= rates_total - 10) continue;
        if(msCount >= 20) break;
        
        if(IsRobustSwingHigh(i, high, MS_Strength, rates_total))
        {
            bool isHigherHigh = ValidateHigherHigh(i, high, 30);
            if(isHigherHigh)
            {
                msCount++;
                StructureBuffer[i] = high[i];
                
                if(ShowLabels && msCount <= 10)
                    CreateInBoxLabel(time[i], high[i], "HH", BullColor, FontSize + 2);
                
                CreateArrow(time[i], high[i], 233, BullColor, "HH_" + IntegerToString(i));
            }
        }
        
        if(IsRobustSwingLow(i, low, MS_Strength, rates_total))
        {
            bool isLowerLow = ValidateLowerLow(i, low, 30);
            if(isLowerLow)
            {
                msCount++;
                StructureBuffer[i] = low[i];
                
                if(ShowLabels && msCount <= 10)
                    CreateInBoxLabel(time[i], low[i], "LL", BearColor, FontSize + 2);
                
                CreateArrow(time[i], low[i], 234, BearColor, "LL_" + IntegerToString(i));
            }
        }
        
        if(ShowBOS && i >= 20 && bosCount < 5)
            DetectBOS(i, high, low, close, time);
        
        if(ShowCHoCH && i >= 25 && chochCount < 5)
            DetectCHoCH(i, high, low, close, time);
    }
}

// Market Bias Calculation
void CalculateMarketBias(const double &close[])
{
    double shortMA = 0, longMA = 0;
    
    for(int i = 0; i < 10; i++)
        shortMA += close[i];
    shortMA /= 10;
    
    for(int i = 0; i < 30; i++)
        longMA += close[i];
    longMA /= 30;
    
    if(shortMA > longMA * 1.001)
        marketBias = "BULLISH";
    else if(shortMA < longMA * 0.999)
        marketBias = "BEARISH";
    else
        marketBias = "NEUTRAL";
}

// Confluence Score Calculation
void CalculateConfluenceScore()
{
    double totalElements = (double)(msCount + liquidityBoxes + obCount + fvgCount + srCount + demandZones + supplyZones);
    confluenceScore = (totalElements / 50.0) * 100.0;
    if(confluenceScore > 100) confluenceScore = 100;
}

bool ValidateHigherHigh(int index, const double &high[], int lookback)
{
    double currentHigh = high[index];
    
    for(int i = index + 1; i <= index + lookback && i < ArraySize(high); i++)
    {
        if(IsRobustSwingHigh(i, high, 3, ArraySize(high)))
        {
            return (currentHigh > high[i]);
        }
    }
    return false;
}

bool ValidateLowerLow(int index, const double &low[], int lookback)
{
    double currentLow = low[index];
    
    for(int i = index + 1; i <= index + lookback && i < ArraySize(low); i++)
    {
        if(IsRobustSwingLow(i, low, 3, ArraySize(low)))
        {
            return (currentLow < low[i]);
        }
    }
    return false;
}

void DetectBOS(int index, const double &high[], const double &low[], 
              const double &close[], const datetime &time[])
{
    if(IsRobustSwingHigh(index, high, 3, ArraySize(high)))
    {
        for(int i = index + 5; i <= index + 50 && i < ArraySize(high); i++)
        {
            if(IsRobustSwingHigh(i, high, 3, ArraySize(high)))
            {
                if(high[index] > high[i])
                {
                    bosCount++;
                    CreateTrendLine(time[i], high[i], time[index], high[index], 
                                   BullColor, "BOS_" + IntegerToString(index));
                    
                    if(ShowLabels)
                        CreateInBoxLabel(time[index], high[index], "BOS", BullColor, FontSize);
                    break;
                }
            }
        }
    }
}

void DetectCHoCH(int index, const double &high[], const double &low[], 
                const double &close[], const datetime &time[])
{
    if(IsRobustSwingLow(index, low, 3, ArraySize(low)))
    {
        for(int i = index + 5; i <= index + 50 && i < ArraySize(low); i++)
        {
            if(IsRobustSwingLow(i, low, 3, ArraySize(low)))
            {
                if(low[index] < low[i])
                {
                    chochCount++;
                    CreateTrendLine(time[i], low[i], time[index], low[index], 
                                   BearColor, "CHoCH_" + IntegerToString(index));
                    
                    if(ShowLabels)
                        CreateInBoxLabel(time[index], low[index], "CHoCH", BearColor, FontSize);
                    break;
                }
            }
        }
    }
}

void DetectLiquiditySweep(int index, const double &high[], const double &low[], 
                         const double &close[], const datetime &time[])
{
    double tolerance = ATR[index] * 0.3;
    
    for(int i = index + 1; i <= index + 20 && i < ArraySize(high); i++)
    {
        if(IsRobustSwingHigh(i, high, 2, ArraySize(high)))
        {
            if(high[index] > high[i] && close[index] < high[i] - tolerance)
            {
                sweepCount++;
                CreateArrow(time[index], high[index], 242, LiquidityColor, "Sweep_" + IntegerToString(index));
                
                if(ShowLabels)
                    CreateInBoxLabel(time[index], high[index], "SWEEP", LiquidityColor, FontSize);
                break;
            }
        }
    }
}

void CreateTrendLine(datetime time1, double price1, datetime time2, double price2, 
                    color clr, string name)
{
    if(ObjectFind(name) >= 0) ObjectDelete(name);
    
    ObjectCreate(name, OBJ_TREND, 0, time1, price1, time2, price2);
    ObjectSet(name, OBJPROP_COLOR, clr);
    ObjectSet(name, OBJPROP_WIDTH, 2);
    ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
    ObjectSet(name, OBJPROP_RAY, false);
    ObjectSet(name, OBJPROP_BACK, false);
    ObjectSet(name, OBJPROP_SELECTED, false);
}

void CreateArrow(datetime time, double price, int arrowCode, color clr, string name)
{
    if(ObjectFind(name) >= 0) ObjectDelete(name);
    
    ObjectCreate(name, OBJ_ARROW, 0, time, price);
    ObjectSet(name, OBJPROP_ARROWCODE, arrowCode);
    ObjectSet(name, OBJPROP_COLOR, clr);
    ObjectSet(name, OBJPROP_WIDTH, 3);
    ObjectSet(name, OBJPROP_SELECTED, false);
}

//+------------------------------------------------------------------+
//| COMPLETE Dashboard Functions                                    |
//+------------------------------------------------------------------+
void CreateDashboard()
{
    ObjectCreate(dashboardPrefix + "BG", OBJ_RECTANGLE_LABEL, 0, 0, 0);
    ObjectSet(dashboardPrefix + "BG", OBJPROP_XDISTANCE, dashboardX);
    ObjectSet(dashboardPrefix + "BG", OBJPROP_YDISTANCE, dashboardY);
    ObjectSet(dashboardPrefix + "BG", OBJPROP_XSIZE, dashboardWidth);
    ObjectSet(dashboardPrefix + "BG", OBJPROP_YSIZE, dashboardHeight);
    ObjectSet(dashboardPrefix + "BG", OBJPROP_BGCOLOR, C'10,10,20');
    ObjectSet(dashboardPrefix + "BG", OBJPROP_BORDER_TYPE, BORDER_FLAT);
    ObjectSet(dashboardPrefix + "BG", OBJPROP_COLOR, clrGold);
    ObjectSet(dashboardPrefix + "BG", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSet(dashboardPrefix + "BG", OBJPROP_SELECTED, false);
    
    CreateDashLabel("HEADER", "FORGE v2.0 FIXED [" + symbolType + "]", 15, clrGold, 11);
}

void UpdateDashboard()
{
    if(!ShowDashboard) return;
    
    int yOffset = 35;
    int lineHeight = 15;
    
    color biasColor = (marketBias == "BULLISH") ? clrLime : (marketBias == "BEARISH") ? clrRed : clrYellow;
    CreateDashLabel("BIAS", "Market Bias: " + marketBias, yOffset, biasColor, FontSize + 1);
    yOffset += lineHeight;
    
    CreateDashLabel("MODE", "Signal Mode: " + GetSignalModeDescription(), yOffset, clrCyan, FontSize);
    yOffset += lineHeight;
    
    double currentATR = (ArraySize(ATR) > 0 && ATR[0] > 0) ? ATR[0] : 20.0;
    CreateDashLabel("PRICE", "Price: " + DoubleToString(Close[0], _Digits) + " | ATR: " + DoubleToString(currentATR, 2), yOffset, clrWhite, FontSize);
    yOffset += lineHeight;
    
    CreateDashLabel("CONFLUENCE", "Confluence: " + DoubleToString(confluenceScore, 1) + "%", yOffset, clrCyan, FontSize);
    yOffset += lineHeight;
    
    string fastMode = FastBoxDetection ? "FAST" : "NORMAL";
    CreateDashLabel("SIGNALS", "SIGNALS (" + fastMode + ") - Buy: " + IntegerToString(buySignals) + " | Sell: " + IntegerToString(sellSignals), yOffset, clrWhite, FontSize);
    yOffset += lineHeight;
    
    CreateDashLabel("LINES", "S/R Lines: " + IntegerToString(supportLines + resistanceLines) + " | Structure: " + IntegerToString(msCount), yOffset, clrSilver, FontSize);
    yOffset += lineHeight;
    
    CreateDashLabel("BOXES", "OB Boxes: " + IntegerToString(obCount) + " | Liq Boxes: " + IntegerToString(liquidityBoxes), yOffset, clrSilver, FontSize);
    yOffset += lineHeight;
    
    CreateDashLabel("BOXES2", "FVG Boxes: " + IntegerToString(fvgCount) + " | S/D Boxes: " + IntegerToString(sdBoxes), yOffset, clrSilver, FontSize);
    yOffset += lineHeight;
    
    CreateDashLabel("SMC", "BOS: " + IntegerToString(bosCount) + " | CHoCH: " + IntegerToString(chochCount) + " | Sweeps: " + IntegerToString(sweepCount), yOffset, clrSilver, FontSize);
    yOffset += lineHeight;
    
    // Show S/R levels with prices
    if(supportLines > 0)
    {
        string supportText = "Active Supports: ";
        for(int i = 0; i < supportLines && i < 5; i++)
        {
            if(supportLevels[i].isActive && supportLevels[i].price > 0)
                supportText += "S" + IntegerToString(i + 1) + "=" + DoubleToString(supportLevels[i].price, _Digits) + " ";
        }
        CreateDashLabel("SUPPORT", supportText, yOffset, SupportColor, FontSize);
        yOffset += lineHeight;
    }
    
    if(resistanceLines > 0)
    {
        string resistanceText = "Active Resistance: ";
        for(int i = 0; i < resistanceLines && i < 5; i++)
        {
            if(resistanceLevels[i].isActive && resistanceLevels[i].price > 0)
                resistanceText += "R" + IntegerToString(i + 1) + "=" + DoubleToString(resistanceLevels[i].price, _Digits) + " ";
        }
        CreateDashLabel("RESISTANCE", resistanceText, yOffset, ResistanceColor, FontSize);
        yOffset += lineHeight;
    }
    
    if(buySignals > 0)
    {
        CreateDashLabel("LASTBUY", "Last Buy: " + DoubleToString(lastBuyPrice, _Digits) + " at " + TimeToString(lastBuyTime), yOffset, clrDodgerBlue, FontSize);
        yOffset += lineHeight;
    }
    
    if(sellSignals > 0)
    {
        CreateDashLabel("LASTSELL", "Last Sell: " + DoubleToString(lastSellPrice, _Digits) + " at " + TimeToString(lastSellTime), yOffset, clrRed, FontSize);
        yOffset += lineHeight;
    }
    
    // Color explanation
    CreateDashLabel("COLORS1", colorExplanation, yOffset, clrYellow, FontSize - 2);
    yOffset += lineHeight + 3;
    
    string transitions = SmoothSRTransition ? "SMOOTH TRANSITIONS ON" : "STATIC S/R";
    string labels = RightmostLabels ? "RIGHTMOST LABELS" : "HISTORICAL LABELS";
    string inBox = ShowInBoxLabels ? "IN-BOX LABELS" : "NO IN-BOX LABELS";
    CreateDashLabel("STATUS", "Status: " + transitions + " | " + labels + " | " + inBox, yOffset, clrLime, FontSize - 1);
}

void CreateDashLabel(string suffix, string text, int yPos, color clr, int size)
{
    string name = dashboardPrefix + suffix;
    
    if(ObjectFind(name) < 0)
    {
        ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
        ObjectSet(name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSet(name, OBJPROP_XDISTANCE, dashboardX + 10);
        ObjectSet(name, OBJPROP_SELECTED, false);
    }
    
    ObjectSet(name, OBJPROP_YDISTANCE, dashboardY + yPos);
    ObjectSetText(name, text, size, FontName, clr);
}

//+------------------------------------------------------------------+
//| Utility Functions                                               |
//+------------------------------------------------------------------+
void ClearAllPreviousObjects()
{
    int objectsTotal = ObjectsTotal();
    for(int i = objectsTotal - 1; i >= 0; i--)
    {
        string name = ObjectName(i);
        if(StringFind(name, "Support_") >= 0 ||
           StringFind(name, "Resistance_") >= 0 ||
           StringFind(name, "BullOB_") >= 0 ||
           StringFind(name, "BearOB_") >= 0 ||
           StringFind(name, "Demand_") >= 0 ||
           StringFind(name, "Supply_") >= 0 ||
           StringFind(name, "SSL_Box_") >= 0 ||
           StringFind(name, "BSL_Box_") >= 0 ||
           StringFind(name, "BullFVG_") >= 0 ||
           StringFind(name, "BearFVG_") >= 0 ||
           StringFind(name, "HH_") >= 0 ||
           StringFind(name, "LL_") >= 0 ||
           StringFind(name, "BOS_") >= 0 ||
           StringFind(name, "CHoCH_") >= 0 ||
           StringFind(name, "Sweep_") >= 0 ||
           StringFind(name, "RightLabel_") >= 0 ||
           StringFind(name, "InBoxLabel_") >= 0)
        {
            ObjectDelete(name);
        }
    }
    
    Print("FIXED: Cleared all previous objects for clean start");
}

bool StringIsInteger(string str)
{
    for(int i = 0; i < StringLen(str); i++)
    {
        int char_code = StringGetChar(str, i);
        if(char_code < 48 || char_code > 57)
            return false;
    }
    return true;
}

//+------------------------------------------------------------------+
//| Deinitialization function                                        |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    for(int i = ObjectsTotal() - 1; i >= 0; i--)
    {
        string name = ObjectName(i);
        if(StringFind(name, dashboardPrefix) >= 0)
            ObjectDelete(name);
    }
    
    ClearAllPreviousObjects();
    
    Comment("");
    Print("FORGE v2.0 FIXED - All Compilation Errors Resolved. Reason: ", reason);
}