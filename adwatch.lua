_addon.name = 'Adwatch'
_addon.version = '0.9'
_addon.author = 'Staticvoid'
_addon.commands = {'adwatch', 'aw'}

require('luau')
packets = require('packets')
config = require('config')
require('logger')
files = require('files')

local settings_file = files.new('words_of_interest.xml')
local log_file = files.new('log.log', true) 

local words_of_interest = T{

}
local addon_path = windower.addon_path
local sounds = {
	alert = addon_path .. 'alert.wav',
}

local function save_words()
    local xml_content = '<?xml version="1.0"?>\n<words>\n'
    for _, word in ipairs(words_of_interest) do
        xml_content = xml_content .. string.format('    <word>%s</word>\n', word)
    end
    xml_content = xml_content .. '</words>'

    settings_file:write(xml_content)
    log('Word list updated and saved.')
end

local function load_words()
    if settings_file:exists() then
        local content = settings_file:read()
        for word in content:gmatch('<word>(.-)</word>') do
            if not words_of_interest:contains(word) then
                words_of_interest:append(word)
            end
        end
        log('Loaded words from words_of_interest.xml. \n//aw add <word phrase> to add to the scanner.\n//aw remove <word phrase> to remove from the scanner.\n//aw list to list all watched phrases. \nEnjoy')
    else
        save_words()
    end
end

local function log_message(sender, message)
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    local log_entry = string.format('[%s] [%s] %s\n', timestamp, sender, message)
    
    log_file:append(log_entry)
    log('Message logged to file')
end

load_words()

windower.register_event('incoming chunk', function(id, data)
    if id == 0x017 then
        local chat = packets.parse('incoming', data)
		local sender = chat['Sender Name'] or 'Unknown'
        local cleaned = windower.convert_auto_trans(chat['Message']):lower()
        if (chat['Mode'] == 3 or chat['Mode'] == 1 or chat['Mode'] == 26) then
            for _, v in ipairs(words_of_interest) do
                if cleaned:match(v:lower()) then
					windower.play_sound(sounds.alert)
                    log_message(sender, cleaned)
                end
            end
        end
    end
end)

local function remove_phrase(phrase)
    for i, word in ipairs(words_of_interest) do
        if word:lower() == phrase:lower() then
            table.remove(words_of_interest, i)
            return true
        end
    end
    return false
end


windower.register_event('addon command', function(command, ...)
    local args = {...}
    local action = command:lower()

    if action == 'add' and args[1] then
        local new_phrase = table.concat(args, ' '):lower()
        if not words_of_interest:contains(new_phrase) then
            words_of_interest:append(new_phrase)
            save_words()
            log('Added new phrase: ' .. new_phrase)
        else
            log('Phrase already exists: ' .. new_phrase)
        end

    elseif action == 'remove' and args[1] then
        local phrase_to_remove = table.concat(args, ' '):lower()
        if remove_phrase(phrase_to_remove) then
            save_words()
            log('Removed phrase: ' .. phrase_to_remove)
        else
            log('Phrase not found: ' .. phrase_to_remove)
        end

    elseif action == 'list' then
        log('Watched phrases:')
        for _, phrase in ipairs(words_of_interest) do
            log('- ' .. phrase)
        end

    else
        log('Command help: //adwatch add <phrase> | //adwatch remove <phrase> | //adwatch list')
    end
end)