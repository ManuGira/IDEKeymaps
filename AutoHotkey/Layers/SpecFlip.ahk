#Requires AutoHotkey v2.0

; Uses SendInput with blind text to avoid recursion

1::SendInput("{Blind}{Text}+")
2::SendInput("{Blind}{Text}`"")  ; Back tick to escape double quotes
3::SendInput("{Blind}{Text}*")
4::SendInput("{Blind}{Text}ç")
5::SendInput("{Blind}{Text}%")
6::SendInput("{Blind}{Text}&")
7::SendInput("{Blind}{Text}/")
8::SendInput("{Blind}{Text}(")
9::SendInput("{Blind}{Text})")
0::SendInput("{Blind}{Text}=")

+::SendInput("{Blind}{Text}1")
"::SendInput("{Blind}{Text}2")
*::SendInput("{Blind}{Text}3")
ç::SendInput("{Blind}{Text}4")
%::SendInput("{Blind}{Text}5")
&::SendInput("{Blind}{Text}6")
/::SendInput("{Blind}{Text}7")
(::SendInput("{Blind}{Text}8")
)::SendInput("{Blind}{Text}9")
=::SendInput("{Blind}{Text}0")
