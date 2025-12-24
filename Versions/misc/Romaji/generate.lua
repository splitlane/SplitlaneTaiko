--[[
    generate.lua

    quick and dirty script for generating the tables

    https://en.wikipedia.org/wiki/Hepburn_romanization#Romanization_charts
]]

local input = [[
あ ア a	い イ i	う ウ u	え エ e	お オ o
か カ ka	き キ ki	く ク ku	け ケ ke	こ コ ko	きゃ キャ kya	きゅ キュ kyu	きょ キョ kyo
さ サ sa	し シ shi	す ス su	せ セ se	そ ソ so	しゃ シャ sha	しゅ シュ shu	しょ ショ sho
た タ ta	ち チ chi	つ ツ tsu	て テ te	と ト to	ちゃ チャ cha	ちゅ チュ chu	ちょ チョ cho
な ナ na	に ニ ni	ぬ ヌ nu	ね ネ ne	の ノ no	にゃ ニャ nya	にゅ ニュ nyu	にょ ニョ nyo
は ハ ha	ひ ヒ hi	ふ フ fu	へ ヘ he	ほ ホ ho	ひゃ ヒャ hya	ひゅ ヒュ hyu	ひょ ヒョ hyo
ま マ ma	み ミ mi	む ム mu	め メ me	も モ mo	みゃ ミャ mya	みゅ ミュ myu	みょ ミョ myo
や ヤ ya	ゆ ユ yu	よ ヨ yo
ら ラ ra	り リ ri	る ル ru	れ レ re	ろ ロ ro	りゃ リャ rya	りゅ リュ ryu	りょ リョ ryo
わ ワ wa	を ヲ wo
ん ン n
が ガ ga	ぎ ギ gi	ぐ グ gu	げ ゲ ge	ご ゴ go	ぎゃ ギャ gya	ぎゅ ギュ gyu	ぎょ ギョ gyo
ざ ザ za	じ ジ ji	ず ズ zu	ぜ ゼ ze	ぞ ゾ zo	じゃ ジャ ja	じゅ ジュ ju	じょ ジョ jo
だ ダ da	ぢ ヂ ji	づ ヅ zu	で デ de	ど ド do	ぢゃ ヂャ ja	ぢゅ ヂュ ju	ぢょ ヂョ jo
ば バ ba	び ビ bi	ぶ ブ bu	べ ベ be	ぼ ボ bo	びゃ ビャ bya	びゅ ビュ byu	びょ ビョ byo
ぱ パ pa	ぴ ピ pi	ぷ プ pu	ぺ ペ pe	ぽ ポ po	ぴゃ ピャ pya	ぴゅ ピュ pyu	ぴょ ピョ pyo
]]
--[[
    todo: add extended
    todo: add small tsu

    https://github.com/aleckretch/Romaji-to-Japanese-Converter
]]
local oldinput = input
input = [[
し シ si
]]

local vowel = {
    a = true,
    e = true,
    i = true,
    o = true,
    u = true,
}

--autogen
oldinput:gsub('(.-) (.-) (.-)[\t\n]', function(a, b, c)
    --small tsu (two consonants in a row)
    if not vowel[c:sub(1, 1)] and c:sub(1, 1) ~= 'n' then
        input = input .. 'っ' .. a .. ' ッ' .. b .. ' ' .. c:sub(1, 1) .. c .. '\n'
    end
end)
input = oldinput .. input



local out = {}
input:gsub('(.-) (.-) (.-)[\t\n]', function(a, b, c)
    print(a, b, c)
    out[#out + 1] = '[\''
    out[#out + 1] = c
    out[#out + 1] = '\'] = {\''
    out[#out + 1] = a
    out[#out + 1] = '\', \''
    out[#out + 1] = b
    out[#out + 1] = '\'},\n'
end)

print(table.concat(out))