local version = "6.1"

function autoinviter_Handler( msg, box)
    msg = string.lower(msg)

    if( not msg or msg == "" or msg == "help" ) then
        print (WRAI_HELP)
    elseif( msg == "list" ) then
        print (WRAI_LIST_WORDS);
        for i, _ in pairs (magics) do
            print( "  "..i)
        end
    else
        if( magics[msg] ) then
            magics[msg] = nil
            print (WRAI_WORD_REMOVED:format(msg))
        else
            magics[msg] = 1
            print (WRAI_WORD_ADDED:format(msg))
        end
    end
end

function autoinviter_Whisper(...)
    local msg, user = ...
    msg = string.lower(msg)
    if( magics[msg] ) then
        SendChatMessage(WRAI_INVITE_MESSAGE, "WHISPER", nil, user);
        InviteUnit(user)
    end
    
end

function autoinviter_BNWhisper(...)
    local msg, sender, _,  _, _, _, _, _, _, _, _, _, presenceID = ...;
    msg = string.lower(msg)
    local _, givenName, battleTag, _, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, isRIDFriend, broadcastTime, canSoR = BNGetFriendInfoByID(presenceID)
    if( toonName ~= nil and client == 'WoW' and magics[msg]  ) then
        BNSendWhisper(presenceID, WRAI_INVITE_MESSAGE);
        BNInviteFriend(toonID);
    elseif( client ~= "WoW" and magics[msg] ) then
        BNSendWhisper(presenceID, WRAI_OTHER_GAME);
    end
end

function autoinviter_Init()
    print(WRAI_INIT_MESSAGE:format(version))
    if( not magics) then
        print(WRAI_FIRST_RUN);
        magics = {};
        for i = 1, table.getn(WRAI_DEFAULT_MAGICS) do
            magics[WRAI_DEFAULT_MAGICS[i]] = 1;
        end
    end
    
    SLASH_ACM1 = '/acm';
    SLASH_ACM2 = '/wracm';
    
    SlashCmdList["ACM"] = autoinviter_Handler
    autoinviter_Frame:RegisterEvent("CHAT_MSG_WHISPER")
    autoinviter_Frame:RegisterEvent("CHAT_MSG_BN_WHISPER")

end
