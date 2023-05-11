'neopixel_test

Function random_colour()
  green = RGB(green)
  red = RGB(red)
  blue = RGB(blue)
  purple = RGB(255,0,255)
  yellow = RGB(yellow)
  cyan = RGB(cyan)
  Local neopixel_cols%(5) = (green, blue, red, purple, yellow, cyan)
  idx = Int(6 * Math(RAND))
  random_colour = neopixel_cols%(idx)
End Function

Sub leds_off
  Local b%(7)
  For led = 0 To 7
    b%(led) = black
  Next
  led_show(b%(),8)
End Sub

Sub led_sweep
  Local leds%(7)
  For x = 0 To 7
    For y = 0 To 7
      If x = y Then
        leds%(y) = RGB(0,255,0)
      Else
        leds%(y) = RGB(0,0,0)
      EndIf
    Next
    led_show(leds%(), 8)
    Pause 100
  Next
  leds_off
End Sub

Sub led_disco
  Local b%(7)
  For cycle = 0 To 12
    For led = 0 To 7
      b%(led) = random_colour()
    Next
    led_show(b%(), 8)
    Pause 250
  Next
  leds_off
End Sub

Sub led_all_same(col)
  Local b%(7)
  For led = 0 To 7
    b%(led) = col
  Next
  led_show(b%(), 8)
End Sub

Sub mm.startup
  led_sweep
  RTC gettime
  Print Date$ " " Time$
End Sub

Sub led_blink()
  For flash = 0 To 10
    led_all_same(RGB(255,0,0))
    Pause 50
    leds_off
    Pause 50
  Next
  leds_off
End Sub

Sub led_subset(num_leds, col)
  leds_off
  If num_leds > 0 Then
    Local leds%(num_leds)
    For count = 0 To num_leds
      leds%(count) = col
    Next
    led_show(leds%(), num_leds, col)
  EndIf
End Sub

Sub led_seconds(secs%)
  If secs% >= 1 And secs% <= 8 Then
    led_subset(secs%, RGB(0,0,255))
  ElseIf secs% = 9 Then
    led_subset(9, RGB(0,255,0))
  ElseIf secs% = 0 Then
    leds_off
  EndIf
End Sub

Sub led_clock
  Do
    secs% = Val(Right$(Time$,1))
    led_seconds(secs%)
  Loop
End Sub

'col is only used if num_leds is 1. This is due to limitations of ws2812 lib
Sub led_show(leds%(), num_leds, col)
  If num_leds = 1 Then
    Bitbang WS2812 B, GP5, 1, col
  ElseIf num_leds >= 2 Then
    Bitbang WS2812 B, GP5, num_leds, leds%()
  EndIf
End Sub

Dim b%(7)
SetPin GP5, DOUT
leds_off

'led_clock
'led_blink
'led_disco
'led_sweep
