/**
 * ChatGPT CFC includes functions for interacting with the ChatGPT assistant & ChatGPT Completion API.
 * It allows you to send messages using the sendMessage function leveraging ChatGPT assistant API
 * and retrieve content using the suggestContent function, which leverages the ChatGPT Completion API
 * to generate and provide tailored content based on provided inputs.
 * 
 * @author Srikanth Madishetti
 * @version 1.0
 */
component {

    function init(
        com.madishetti.chatGPTAssistant chatGPTAssistant = new com.madishetti.chatGPTAssistant().init(),
        com.madishetti.chatGPTComplete chatGPTComplete = new com.madishetti.chatGPTComplete().init(),
        com.madishetti.loadSettings loadSettings = new com.madishetti.LoadSettings()
    ) {  
        variables.chatGPTAssistant = arguments.chatGPTAssistant;
        variables.chatGPTComplete = arguments.chatGPTComplete;
        try{
            variables.chatGptSettings = arguments.loadSettings.loadSettings();
        } catch (com.madishetti.LoadSettings.SettingsException e) {
            rethrow;
        }  

        return this;
    }

    /**
     * Retrieves completion from the chatGPT completion OpenAI API.
     *
     * @isReview Indicates whether review of generated content is required. Defaults to false(boolean, required)
     * @purpose Purpose of the content (e.g., resume, LinkedIn profile). (string, required)
     * @description Description or overview of the content to be generated. (string, required)
     * @language Language for the content. Defaults to settings defaultContentLanguage. (string, required)
     * @formattingInstructions Formatting guidelines or preferences for the content. Defaults to blank value (string, required)
     * @audience Target audience for the content like (e.g., Travelers, Professionals, Students). Defaults to settings defaultContentAudience (string, required)
     * @tone Desired tone of the content (e.g., formal, casual). Defaults to settings defaultContentTone. (string, required)
     * @keywords Specific keywords or phrases to include. (string, optional)
     * @length Desired length or word count for the content. (string, optional)
     * @reviewInstructions Instructions or comments related to previous content. Defaults to blank value (string, optional)
     * 
     * @return The generated  completion from the OpenAI API.
     * @throws com.madishetti.ChatGPTComplete.generatePromptException
     * @throws com.madishetti.ChatGPTComplete.validateException
     * @throws com.madishetti.ChatGPTComplete.openAIAPICallException
     * @throws com.madishetti.ChatGPTComplete.getOpenAICompletionException
     */
    public string function suggestContent(
        required boolean isReview="false",
        required string purpose,
        required string description,
        required string language = variables.chatGptSettings.defaultContentLanguage,
        required string formattingInstructions="",
        required string audience = variables.chatGptSettings.defaultContentAudience,
        required string tone = variables.chatGptSettings.defaultContentTone,
        string keywords,
        string length,
        string reviewInstructions=""
    ) { 
        try {
            return variables.chatGPTComplete.suggestContent(argumentCollection = arguments);
        } catch (com.madishetti.ChatGPTComplete.validateException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTComplete.openAIAPICallException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTComplete.getOpenAICompletionException e) {
            rethrow;
        }  catch (com.madishetti.ChatGPTComplete.generatePromptException e) {
            rethrow;
        } 
       
    }

    /**
     * Sends a message to the ChatGPT Assistant and retrieves the latest response. If the threadId is left blank for the first call, the ChatGPT Assistant will
     * return a threadId in the response. This threadId should be used in subsequent calls for the same conversation thread. 
     * Keep in mind that sending a blank threadId will start a new conversation thread, and any previous conversation history will be lost.
     * 
     * @message The message to be sent. (string, required)
     * @threadID The ID of the thread. (string, optinal)
     * 
     * @return The threadId and response generated from the ChatGPT Assistant OpenAI API.
     * @throws com.madishetti.ChatGPTComplete.sendMessage.message.validationException
     * @throws com.madishetti.ChatGPTComplete.createThreadOpenAIApiCallException
     * @throws com.madishetti.ChatGPTComplete.openAIAPICallException
     * @throws com.madishetti.ChatGPTComplete.sendRequestToOpenAIException
     * @throws com.madishetti.ChatGPTComplete.createThreadException
     * @throws com.madishetti.ChatGPTComplete.addMessageToThreadException
     * @throws com.madishetti.ChatGPTComplete.runTheAssistantException
     * @throws com.madishetti.ChatGPTComplete.runTheAssistantStatusException
     * @throws com.madishetti.ChatGPTComplete.retryRunAssistantStatusException
     * @throws com.madishetti.ChatGPTComplete.getThreadMessagesException
     * @throws com.madishetti.ChatGPTComplete.sendMessage.getThreadMessagesException
     * @throws com.madishetti.ChatGPTComplete.sendMessageException
     */
    public string function sendMessage(
        required string message,
        required string threadId 
    ) {
        try {
            return variables.chatGPTAssistant.sendMessage(argumentCollection = arguments);
        } catch (com.madishetti.ChatGPTAssitant.sendMessage.message.validationException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.createThreadOpenAIApiCallException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.openAIAPICallException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.sendRequestToOpenAIException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.createThreadException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.addMessageToThreadException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.runTheAssistantException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.runTheAssistantStatusException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.retryRunAssistantStatusException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.getThreadMessagesException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.sendMessage.getThreadMessagesException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.sendMessageException e) {
            rethrow;
        }
    }

     /**
     * Sends a message to the ChatGPT Assistant and retrieves all messages for a given thread. If the threadId is left blank for the first call, the ChatGPT Assistant will
     * return a threadId in the response. This threadId should be used in subsequent calls for the same conversation thread. 
     * Keep in mind that sending a blank threadId will start a new conversation thread, and any previous conversation history will be lost.
     *
     * @message The message to be sent. (string, required)
     * @threadID The ID of the thread. (string, optinal)
     * 
     * @return Returns a ordered struct of all messages for a given thread generated from the ChatGPT Assistant OpenAI API.
     * @throws com.madishetti.ChatGPTComplete.sendMessage.message.validationException
     * @throws com.madishetti.ChatGPTComplete.createThreadOpenAIApiCallException
     * @throws com.madishetti.ChatGPTComplete.openAIAPICallException
     * @throws com.madishetti.ChatGPTComplete.sendRequestToOpenAIException
     * @throws com.madishetti.ChatGPTComplete.createThreadException
     * @throws com.madishetti.ChatGPTComplete.addMessageToThreadException
     * @throws com.madishetti.ChatGPTComplete.runTheAssistantException
     * @throws com.madishetti.ChatGPTComplete.runTheAssistantStatusException
     * @throws com.madishetti.ChatGPTComplete.retryRunAssistantStatusException
     * @throws com.madishetti.ChatGPTComplete.getThreadMessagesException
     * @throws com.madishetti.ChatGPTComplete.sendMessage.getThreadMessagesException
     * @throws com.madishetti.ChatGPTComplete.sendMessageException
     */
    public struct function sendMessageAndRetrieveAllMessages(
        required string message,
        required string threadId 
    ) {
        try {
            return variables.chatGPTAssistant.sendMessageAndRetrieveAllMessages(argumentCollection = arguments);
        } catch (com.madishetti.ChatGPTAssitant.sendMessage.message.validationException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.createThreadOpenAIApiCallException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.openAIAPICallException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.sendRequestToOpenAIException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.createThreadException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.addMessageToThreadException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.runTheAssistantException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.runTheAssistantStatusException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.retryRunAssistantStatusException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.getThreadMessagesException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.sendMessage.getThreadMessagesException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.sendMessageException e) {
            rethrow;
        }
    }
}
