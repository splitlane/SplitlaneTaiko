--[[
    romaji.lua
    a utility to convert romaji to hiragana
]]





local function utf8Decode(s)
    local res, seq, val = {}, 0, nil
    for i = 1, #s do
        local c = string.byte(s, i)
        if seq == 0 then
            table.insert(res, val)
            seq = c < 0x80 and 1 or c < 0xE0 and 2 or c < 0xF0 and 3 or
                c < 0xF8 and 4 or c < 0xFC and 5 or c < 0xFE and 6 or
                error("invalid UTF-8 character sequence")
            val = bit.band(c, 2^(8-seq) - 1)
        else
            val = bit.bor(bit.lshift(val, 6), bit.band(c, 0x3F))
        end
        seq = seq - 1
    end
    table.insert(res, val)
    --table.insert(res, 0)
    return res
end














Romaji = {}


--[Romaji] = {Hiragana, Katakana}
--Check generate.lua
Romaji.Data = {
    To = {
        ['a'] = {'あ', 'ア'},        
        ['i'] = {'い', 'イ'},        
        ['u'] = {'う', 'ウ'},        
        ['e'] = {'え', 'エ'},        
        ['o'] = {'お', 'オ'},        
        ['ka'] = {'か', 'カ'},       
        ['ki'] = {'き', 'キ'},       
        ['ku'] = {'く', 'ク'},       
        ['ke'] = {'け', 'ケ'},       
        ['ko'] = {'こ', 'コ'},       
        ['kya'] = {'きゃ', 'キャ'},  
        ['kyu'] = {'きゅ', 'キュ'},  
        ['kyo'] = {'きょ', 'キョ'},  
        ['sa'] = {'さ', 'サ'},       
        ['shi'] = {'し', 'シ'},      
        ['su'] = {'す', 'ス'},       
        ['se'] = {'せ', 'セ'},       
        ['so'] = {'そ', 'ソ'},       
        ['sha'] = {'しゃ', 'シャ'},  
        ['shu'] = {'しゅ', 'シュ'},  
        ['sho'] = {'しょ', 'ショ'},  
        ['ta'] = {'た', 'タ'},       
        ['chi'] = {'ち', 'チ'},      
        ['tsu'] = {'つ', 'ツ'},      
        ['te'] = {'て', 'テ'},       
        ['to'] = {'と', 'ト'},       
        ['cha'] = {'ちゃ', 'チャ'},  
        ['chu'] = {'ちゅ', 'チュ'},  
        ['cho'] = {'ちょ', 'チョ'},  
        ['na'] = {'な', 'ナ'},       
        ['ni'] = {'に', 'ニ'},       
        ['nu'] = {'ぬ', 'ヌ'},       
        ['ne'] = {'ね', 'ネ'},       
        ['no'] = {'の', 'ノ'},       
        ['nya'] = {'にゃ', 'ニャ'},  
        ['nyu'] = {'にゅ', 'ニュ'},  
        ['nyo'] = {'にょ', 'ニョ'},  
        ['ha'] = {'は', 'ハ'},       
        ['hi'] = {'ひ', 'ヒ'},       
        ['fu'] = {'ふ', 'フ'},       
        ['he'] = {'へ', 'ヘ'},       
        ['ho'] = {'ほ', 'ホ'},       
        ['hya'] = {'ひゃ', 'ヒャ'},  
        ['hyu'] = {'ひゅ', 'ヒュ'},  
        ['hyo'] = {'ひょ', 'ヒョ'},  
        ['ma'] = {'ま', 'マ'},       
        ['mi'] = {'み', 'ミ'},       
        ['mu'] = {'む', 'ム'},       
        ['me'] = {'め', 'メ'},       
        ['mo'] = {'も', 'モ'},       
        ['mya'] = {'みゃ', 'ミャ'},  
        ['myu'] = {'みゅ', 'ミュ'},  
        ['myo'] = {'みょ', 'ミョ'},  
        ['ya'] = {'や', 'ヤ'},       
        ['yu'] = {'ゆ', 'ユ'},       
        ['yo'] = {'よ', 'ヨ'},       
        ['ra'] = {'ら', 'ラ'},       
        ['ri'] = {'り', 'リ'},       
        ['ru'] = {'る', 'ル'},       
        ['re'] = {'れ', 'レ'},       
        ['ro'] = {'ろ', 'ロ'},       
        ['rya'] = {'りゃ', 'リャ'},  
        ['ryu'] = {'りゅ', 'リュ'},  
        ['ryo'] = {'りょ', 'リョ'},  
        ['wa'] = {'わ', 'ワ'},       
        ['wo'] = {'を', 'ヲ'},       
        ['n'] = {'ん', 'ン'},        
        ['ga'] = {'が', 'ガ'},       
        ['gi'] = {'ぎ', 'ギ'},       
        ['gu'] = {'ぐ', 'グ'},       
        ['ge'] = {'げ', 'ゲ'},       
        ['go'] = {'ご', 'ゴ'},       
        ['gya'] = {'ぎゃ', 'ギャ'},  
        ['gyu'] = {'ぎゅ', 'ギュ'},  
        ['gyo'] = {'ぎょ', 'ギョ'},  
        ['za'] = {'ざ', 'ザ'},       
        ['ji'] = {'じ', 'ジ'},       
        ['zu'] = {'ず', 'ズ'},       
        ['ze'] = {'ぜ', 'ゼ'},       
        ['zo'] = {'ぞ', 'ゾ'},       
        ['ja'] = {'じゃ', 'ジャ'},   
        ['ju'] = {'じゅ', 'ジュ'},   
        ['jo'] = {'じょ', 'ジョ'},   
        ['da'] = {'だ', 'ダ'},       
        ['ji'] = {'ぢ', 'ヂ'},       
        ['zu'] = {'づ', 'ヅ'},       
        ['de'] = {'で', 'デ'},       
        ['do'] = {'ど', 'ド'},       
        ['ja'] = {'ぢゃ', 'ヂャ'},   
        ['ju'] = {'ぢゅ', 'ヂュ'},   
        ['jo'] = {'ぢょ', 'ヂョ'},   
        ['ba'] = {'ば', 'バ'},       
        ['bi'] = {'び', 'ビ'},       
        ['bu'] = {'ぶ', 'ブ'},       
        ['be'] = {'べ', 'ベ'},       
        ['bo'] = {'ぼ', 'ボ'},       
        ['bya'] = {'びゃ', 'ビャ'},  
        ['byu'] = {'びゅ', 'ビュ'},  
        ['byo'] = {'びょ', 'ビョ'},  
        ['pa'] = {'ぱ', 'パ'},       
        ['pi'] = {'ぴ', 'ピ'},       
        ['pu'] = {'ぷ', 'プ'},       
        ['pe'] = {'ぺ', 'ペ'},       
        ['po'] = {'ぽ', 'ポ'},       
        ['pya'] = {'ぴゃ', 'ピャ'},  
        ['pyu'] = {'ぴゅ', 'ピュ'},  
        ['pyo'] = {'ぴょ', 'ピョ'},



        --small tsu
        ['si'] = {'し', 'シ'},
        ['kka'] = {'っか', 'ッカ'},
        ['kki'] = {'っき', 'ッキ'},
        ['kku'] = {'っく', 'ック'},
        ['kke'] = {'っけ', 'ッケ'},
        ['kko'] = {'っこ', 'ッコ'},
        ['kkya'] = {'っきゃ', 'ッキャ'},    
        ['kkyu'] = {'っきゅ', 'ッキュ'},    
        ['kkyo'] = {'っきょ', 'ッキョ'},    
        ['ssa'] = {'っさ', 'ッサ'},
        ['sshi'] = {'っし', 'ッシ'},        
        ['ssu'] = {'っす', 'ッス'},
        ['sse'] = {'っせ', 'ッセ'},
        ['sso'] = {'っそ', 'ッソ'},
        ['ssha'] = {'っしゃ', 'ッシャ'},    
        ['sshu'] = {'っしゅ', 'ッシュ'},    
        ['ssho'] = {'っしょ', 'ッショ'},    
        ['tta'] = {'った', 'ッタ'},
        ['cchi'] = {'っち', 'ッチ'},        
        ['ttsu'] = {'っつ', 'ッツ'},        
        ['tte'] = {'って', 'ッテ'},
        ['tto'] = {'っと', 'ット'},
        ['ccha'] = {'っちゃ', 'ッチャ'},    
        ['cchu'] = {'っちゅ', 'ッチュ'},    
        ['ccho'] = {'っちょ', 'ッチョ'},    
        ['hha'] = {'っは', 'ッハ'},
        ['hhi'] = {'っひ', 'ッヒ'},
        ['ffu'] = {'っふ', 'ッフ'},
        ['hhe'] = {'っへ', 'ッヘ'},
        ['hho'] = {'っほ', 'ッホ'},
        ['hhya'] = {'っひゃ', 'ッヒャ'},    
        ['hhyu'] = {'っひゅ', 'ッヒュ'},    
        ['hhyo'] = {'っひょ', 'ッヒョ'},    
        ['mma'] = {'っま', 'ッマ'},
        ['mmi'] = {'っみ', 'ッミ'},
        ['mmu'] = {'っむ', 'ッム'},
        ['mme'] = {'っめ', 'ッメ'},
        ['mmo'] = {'っも', 'ッモ'},
        ['mmya'] = {'っみゃ', 'ッミャ'},    
        ['mmyu'] = {'っみゅ', 'ッミュ'},    
        ['mmyo'] = {'っみょ', 'ッミョ'},    
        ['yya'] = {'っや', 'ッヤ'},
        ['yyu'] = {'っゆ', 'ッユ'},
        ['yyo'] = {'っよ', 'ッヨ'},
        ['rra'] = {'っら', 'ッラ'},
        ['rri'] = {'っり', 'ッリ'},
        ['rru'] = {'っる', 'ッル'},
        ['rre'] = {'っれ', 'ッレ'},
        ['rro'] = {'っろ', 'ッロ'},
        ['rrya'] = {'っりゃ', 'ッリャ'},    
        ['rryu'] = {'っりゅ', 'ッリュ'},    
        ['rryo'] = {'っりょ', 'ッリョ'},    
        ['wwa'] = {'っわ', 'ッワ'},
        ['wwo'] = {'っを', 'ッヲ'},
        ['gga'] = {'っが', 'ッガ'},
        ['ggi'] = {'っぎ', 'ッギ'},
        ['ggu'] = {'っぐ', 'ッグ'},
        ['gge'] = {'っげ', 'ッゲ'},
        ['ggo'] = {'っご', 'ッゴ'},
        ['ggya'] = {'っぎゃ', 'ッギャ'},    
        ['ggyu'] = {'っぎゅ', 'ッギュ'},    
        ['ggyo'] = {'っぎょ', 'ッギョ'},    
        ['zza'] = {'っざ', 'ッザ'},
        ['jji'] = {'っじ', 'ッジ'},
        ['zzu'] = {'っず', 'ッズ'},
        ['zze'] = {'っぜ', 'ッゼ'},
        ['zzo'] = {'っぞ', 'ッゾ'},
        ['jja'] = {'っじゃ', 'ッジャ'},     
        ['jju'] = {'っじゅ', 'ッジュ'},     
        ['jjo'] = {'っじょ', 'ッジョ'},     
        ['dda'] = {'っだ', 'ッダ'},
        ['jji'] = {'っぢ', 'ッヂ'},
        ['zzu'] = {'っづ', 'ッヅ'},
        ['dde'] = {'っで', 'ッデ'},
        ['ddo'] = {'っど', 'ッド'},
        ['jja'] = {'っぢゃ', 'ッヂャ'},     
        ['jju'] = {'っぢゅ', 'ッヂュ'},     
        ['jjo'] = {'っぢょ', 'ッヂョ'},     
        ['bba'] = {'っば', 'ッバ'},
        ['bbi'] = {'っび', 'ッビ'},
        ['bbu'] = {'っぶ', 'ッブ'},
        ['bbe'] = {'っべ', 'ッベ'},
        ['bbo'] = {'っぼ', 'ッボ'},
        ['bbya'] = {'っびゃ', 'ッビャ'},    
        ['bbyu'] = {'っびゅ', 'ッビュ'},    
        ['bbyo'] = {'っびょ', 'ッビョ'},    
        ['ppa'] = {'っぱ', 'ッパ'},
        ['ppi'] = {'っぴ', 'ッピ'},
        ['ppu'] = {'っぷ', 'ップ'},
        ['ppe'] = {'っぺ', 'ッペ'},
        ['ppo'] = {'っぽ', 'ッポ'},
        ['ppya'] = {'っぴゃ', 'ッピャ'},    
        ['ppyu'] = {'っぴゅ', 'ッピュ'},    
        ['ppyo'] = {'っぴょ', 'ッピョ'},
    }
}



function Romaji.ToHiragana(ostr)
    --Config
    local index = 1 --index for Romaji.Data.To, 1 is hiragana, 2 is katakana
    local str = string.lower(ostr) --don't use uppercase, for getting indexes from data

    local out = {}
    local i = 1


    while true do
        --[[
        local s = string.sub(str, i, i)

        --lookup
        if Romaji.Data.To[s] then
            out[#out + 1] = Romaji.Data.To[s][index]
            i = i + 1
        elseif i < #str then
            local s2 = string.sub(str, i, i + 1)
            if Romaji.Data.To[s2] then
                out[#out + 1] = Romaji.Data.To[s2][index]
                i = i + 2
            elseif i < #str - 1 then
                local s3 = string.sub(str, i, i + 2)
                if Romaji.Data.To[s3] then
                    out[#out + 1] = Romaji.Data.To[s3][index]
                    i = i + 3
                end
            else
                i = i + 1
            end
        else
            i = i + 1
        end
        --]]

        local done = false

        if not done and i < #str - 1 then
            local s3 = string.sub(str, i, i + 2)
            if Romaji.Data.To[s3] then
                out[#out + 1] = Romaji.Data.To[s3][index]
                i = i + 3
                done = true
            end
        end
        if not done and i < #str then
            local s2 = string.sub(str, i, i + 1)
            if Romaji.Data.To[s2] then
                out[#out + 1] = Romaji.Data.To[s2][index]
                i = i + 2
                done = true
            end
        end
        if not done then
            local s1 = string.sub(str, i, i)
            if Romaji.Data.To[s1] then
                out[#out + 1] = Romaji.Data.To[s1][index]
                i = i + 1
                done = true
            end
        end
        if not done then
            out[#out + 1] = string.sub(str, i, i)
            i = i + 1
        end


        --next
        if i > #str then
            break
        end
    end

    return table.concat(out)
end

function Romaji.ToRomaji(str)

end




print(Romaji.ToHiragana('senbonzakura123tteomoshiroine'))