/**
 *  Validate.cfc component is designed to validate prompt inputs and chat messages, checking for abusive words and junk characters.
 *  This component is extendable, allowing for broader validation checks using services like WebPurify, Azure Cognitive Content Safety, Amazon Comprehend, and more.
 * 
 * @author Srikanth Madishetti
 * @version 1.0
 */
component {

    function init(
        com.madishetti.loadSettings loadSettings = new com.madishetti.LoadSettings()
    ) {  
       try{
        variables.chatGptSettings = arguments.loadSettings.loadSettings();
       } catch (com.madishetti.LoadSettings.SettingsException e) {
        rethrow;
       }  
        return this;
    }
   
    /**
     * Generates an error message if any issues are found in the given message.
     *
     * @message message which need to be validated. (string, required)
     *
     * @return Error message if validation fails, empty string if validation succeeds.
     */
    public string function validateMessage(required string message) {
        // Validation logic for the message
        if (!arguments.message.len()) {
            return "Message cannot be empty.";
        }
          // Check for junk characters
        if (containsJunkCharacters(arguments.message)) {
            return "Message contains invalid characters.";
        }

        // Check for abusive words or patterns
        if (containsAbusiveWords(arguments.message)) {
            return "Message contains abusive language.";
        }
        // Add more validation rules as needed
        return "";
    }

    /**
     * Generates an error message if any issues are found in the given prompt inputs.
     *
     * @prompt prompt for generating the completion. (string, required)
     * @maxTokens maximum number of token for the completion. (numeric, required)
     * @temperature temperature parameter for controlling randomness (0 to 1). (numeric, required)
     *
     * @return an error message if any issues are found in the given message; otherwise, returns an empty value.
     */
    public string function validateCompletionInputs(
        required string prompt,
        required numeric maxTokens,
        required numeric temperature
    ) {
        // Check if prompt is empty or null
        if (!arguments.prompt.len()) {
            return "Prompt cannot be empty.";
        }

        // Check if maxTokens is within a valid range
        if (arguments.maxTokens <= 0) {
            return "Max tokens must be greater than zero.";
        }

        // Check if temperature is within the valid range (0 to 1)
        if (arguments.temperature < 0 || arguments.temperature > 1) {
            return "Temperature must be between 0 and 1.";
        }

        // Add more validation rules as needed

        // Validation passed
        return "";
    }

    /**
     * Checks for junk characters for given string.
     *
     * @stringToCheckForJunkCharacters string to check for junk characters. (string, required)
     *
     * @return true if the string contains junk characters; otherwise, returns false.
     */

    private boolean function containsJunkCharacters(
        required string stringToCheckForJunkCharacters
      ) {
         
        // Check for junk characters
        if (reFind("[^\x20-\x7E]", arguments.stringToCheckForJunkCharacters)) {
            return true;
        }

        return false;

    }
      
    /**
     * Checks for abusive words for given string.
     *
     * @stringToCheckForAbusiveWords string to check for abusive words. (string, required)
     * @abusiveWords list of abusiveWords that are not allowed. Defaults to settings abusiveWords (string, required).
     *
     * @return true if the string contains abusive words; otherwise, returns false.
     */
    private boolean function containsAbusiveWords(
        required string stringToCheckForAbusiveWords,
        required string abusiveWords=variables.chatGptSettings.abusiveWords
      ) {
         
         // Check for abusive words or patterns
        for (word in arguments.abusiveWords) {
            if (reFindNoCase(word, arguments.stringToCheckForAbusiveWords)) {
                return true;
            }
        }

        return false;

    }
}