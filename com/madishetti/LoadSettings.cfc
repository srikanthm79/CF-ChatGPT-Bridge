/**
 * LoadSettings is a ColdFusion component (CFC) designed to load settings for ChatGPT
 *
 * @author Srikanth Madishetti
 * @version 1.0
 */
component {
    /**
     * Loads ChatGPT settings from a JSON file and return the settings structure.
     * This function reads the 'ChatGPTSettings.json' file.
     * It deserializes the JSON content and creates settings structure.
     *
     * @return The settings structure.
     * @throws com.madishetti.LoadSettings.SettingsException
     */
    public struct function loadSettings() {
        try {
            // Deserialize ChatGPT settings json
            var settingsPath = GetDirectoryFromPath(GetCurrentTemplatePath());
            var settings = deserializeJSON(fileRead(settingsPath&'/ChatGPTSettings.json'));
            var chatGptSettings = {};
            chatGptSettings.assistantId                  = settings.assistantId;
            chatGptSettings.apiKey                       = settings.apiKey;
            chatGptSettings.assistantEndPoint            = settings.assistantEndPoint;
            chatGptSettings.completionEndpoint           = settings.completionEndpoint;
            chatGptSettings.defaultCompletionTemperature = settings.defaultCompletionTemperature;
            chatGptSettings.defaultCompletionMaxTokens   = settings.defaultCompletionMaxTokens;
            chatGptSettings.defaultCompletionModel       = settings.defaultCompletionModel;
            chatGptSettings.abusiveWords                 = settings.abusiveWords;
            chatGptSettings.assistantMessageLimit        = settings.assistantMessageLimit;
            chatGptSettings.defaultContentLanguage       = settings.defaultContentLanguage;
            chatGptSettings.defaultContentAudience       = settings.defaultContentAudience;
            chatGptSettings.defaultContentTone           = settings.defaultContentTone;
        return chatGptSettings;
        } catch (any e) {
            throw(
                type    = "com.madishetti.LoadSettings.SettingsException",
                message = "ChatGPT - setting couldn't be loaded: " & e.message,
                detail  = e.detail
            );
            
        }
    }
}