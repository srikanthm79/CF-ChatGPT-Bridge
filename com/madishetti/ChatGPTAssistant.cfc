/**
 * chatGPTAssistant is designed to facilitates interaction with the ChatGPT Assistant by providing functions for
 * creating threads, sending messages, and handling responses.
 * 
 * No need to worry about the entire process—simply use the sendMessage function, which will manage everything
 * and deliver the response from the OpenAI chatAssistant API.
 * 
 * @author Srikanth Madishetti
 * @version 1.0
 */
component {

    function init(
        com.madishetti.validation validation = new com.madishetti.validation(),
        com.madishetti.loadSettings loadSettings = new com.madishetti.LoadSettings()
    ) {  
        variables.validation = arguments.validation;
        try{
            variables.chatGptSettings = arguments.loadSettings.loadSettings();
        } catch (com.madishetti.LoadSettings.SettingsException e) {
            rethrow;
        }  

        return this;
    }

    /**
     * Make a request to OpenAI.
     *
     * @endpoint Endpoint url. (string, required).
     * @method HTTP method (e.g., GET, POST). (string, required).
     * @body request body. (any, required).
     *
     * @return The generated response from the OpenAI API.
     * @throws com.madishetti.ChatGPTComplete.generatePromptException
     */
    private any function sendRequestToOpenAI(
        required string endpoint,
        required string method,
        struct body
    ) {
        var httpResult = '';
        try {
            // Create HTTP request object
            httpService = new Http();
            httpService.setMethod(arguments.method);
            httpService.setUrl(arguments.endpoint);
            httpService.addParam(type="header", name="OpenAI-Beta", value="assistants=v2");
            httpService.addParam(type="header", name="Authorization", value="Bearer #variables.chatGptSettings.apiKey#");
            if (method is "post") {
                httpService.addParam(type="header", name="Content-Type", value="application/json");
            }
            if (structKeyExists(arguments,"body") && !structIsEmpty(arguments.body)) {
                httpService.addParam(type="body", value=serializeJSON(arguments.body));
            }
            
            // Make HTTP call
            httpResult = httpService.send().getPrefix();
        
            if (httpResult.responseHeader.status_Code eq 200) {
                return deserializeJSON(httpResult.fileContent);
            } else {
                throw(
                  type    = "com.madishetti.ChatGPTAssitant.openAIAPICallException",
                  message = "Error calling Assistant API: " & httpResult.statusCode & " - " & httpResult.fileContent
                );
          }

        } catch (com.madishetti.ChatGPTAssitant.openAIAPICallException e) {
            rethrow;
        } catch (any e) {
            // Handle generic error
            throw(
                type    = "com.madishetti.ChatGPTAssitant.sendRequestToOpenAIException",
                message = "ChatGPTAssitant - problem calling openAI API: " & e.message,
                detail  = e.detail
            );
        }
    }
  
    /**
     * Retrieves new thread for communication with the ChatGPT Assistant.
     *
     * @return The generated ID of the created thread from the OpenAI API.
     * @throws com.madishetti.ChatGPTAssitant.createThreadOpenAIApiCallException
     * @throws com.madishetti.ChatGPTAssitant.openAIAPICallException
     * @throws com.madishetti.ChatGPTAssitant.sendRequestToOpenAIException
     * @throws com.madishetti.ChatGPTAssitant.createThreadException
     */
    private string function createThread() {
        var createThreadEndpoint = "#variables.chatGptSettings.assistantEndPoint#/threads";
        try {
            var createThreadResponse = sendRequestToOpenAI(
                endpoint = createThreadEndpoint,
                method = "post",
                body={}
            );
            if (isStruct(createThreadResponse) and structKeyExists(createThreadResponse, "id")) {
                return createThreadResponse.id;
            } else {
                throw(
                  type    = "com.madishetti.ChatGPTAssitant.createThreadOpenAIApiCallException",
                  message = "Error calling Assistant API: " & createThreadResponse
                );
            }
        } catch (com.madishetti.ChatGPTAssitant.createThreadOpenAIApiCallException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.openAIAPICallException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.sendRequestToOpenAIException e) {
            rethrow;
        } catch (any e) {
            // Handle generic error
            throw(
                type    = "com.madishetti.ChatGPTAssitant.createThreadException",
                message = "ChatGPTAssitant - problem creating thread id: " & e.message,
                detail  = e.detail
            );
        }
        
    }

    /**
     * Adds a message to the specified thread.
     *
     * @threadID The ID of the thread. (string, required).
     * @message The message to be added to the thread. (string, required).
     * 
     * @return The response generated from the request to the OpenAI API for adding the message.
     * @throws com.madishetti.ChatGPTComplete.openAIAPICallException
     * @throws com.madishetti.ChatGPTComplete.sendRequestToOpenAIException
     * @throws com.madishetti.ChatGPTComplete.addMessageToThreadException
     */
    private any function addMessageToThread(
        required string threadID, 
        required string message
    ) {
        var addMessageEndpoint = "#variables.chatGptSettings.assistantEndPoint#/threads/#threadID#/messages";
        try {
            var addMessageResponse = sendRequestToOpenAI(
                endpoint = addMessageEndpoint,
                method = "post",
                body = {"role": "user", "content": message}
            );
            return addMessageResponse;
        } catch (com.madishetti.ChatGPTAssitant.openAIAPICallException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.sendRequestToOpenAIException e) {
            rethrow;
        } catch (any e) {
            // Handle generic error
            throw(
                type    = "com.madishetti.ChatGPTAssitant.addMessageToThreadException",
                message = "ChatGPTAssitant - problem adding message: " & e.message,
                detail  = e.detail
            );
        }
                 
    }

    /**
     * Runs the assistant for the specified thread.
     *
     * @threadID The ID of the thread. (string, required).
     * 
     * @return The response generated from the request to the OpenAI API for running the assistant.
     * @throws com.madishetti.ChatGPTComplete.openAIAPICallException
     * @throws com.madishetti.ChatGPTComplete.sendRequestToOpenAIException
     * @throws com.madishetti.ChatGPTComplete.runTheAssistantException
     */
    private any function runTheAssistant(required string threadID) {
        var getRunTheAssistantEndpoint = "#variables.chatGptSettings.assistantEndPoint#/threads/#arguments.threadID#/runs";
        try {
            var runTheAssistantResponse = sendRequestToOpenAI(
                endpoint = getRunTheAssistantEndpoint,
                method = "post",
                body = {"assistant_id": variables.chatGptSettings.assistantID, "instructions": ""}
            );
            return runTheAssistantResponse;
        } catch (com.madishetti.ChatGPTAssitant.openAIAPICallException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.sendRequestToOpenAIException e) {
            rethrow;
        } catch (any e) {
            // Handle generic error
            throw(
                type    = "com.madishetti.ChatGPTAssitant.runTheAssistantException",
                message = "ChatGPTAssitant - problem running the assistant: " & e.message,
                detail  = e.detail
            );
        }
    }

    /**
     * Checks the run status of the assistant for the specified thread and run.
     *
     * @threadID The ID of the thread. (string, required).
     * @runID The ID of the run. (string, required).
     * 
     * @return The response generated from the request to the OpenAI API for checking the run status.
     * @throws com.madishetti.ChatGPTComplete.openAIAPICallException
     * @throws com.madishetti.ChatGPTComplete.sendRequestToOpenAIException
     * @throws com.madishetti.ChatGPTComplete.runTheAssistantStatusException
     */
    private any function runTheAssistantStatus(
        required string threadID, 
        required string runID) 
    {
        var getRunTheAssistantStatusEndpoint = "#variables.chatGptSettings.assistantEndPoint#/threads/#arguments.threadID#/runs/#arguments.runID#";
        try {
            var runTheAssistantStatusResponse = sendRequestToOpenAI(
                endpoint = getRunTheAssistantStatusEndpoint,
                method = "get"
            );
            return runTheAssistantStatusResponse;
        } catch (com.madishetti.ChatGPTAssitant.openAIAPICallException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.sendRequestToOpenAIException e) {
            rethrow;
        } catch (any e) {
            // Handle generic error
            throw(
                type    = "com.madishetti.ChatGPTAssitant.runTheAssistantStatusException",
                message = "ChatGPTAssitant - problem running the assistant status: " & e.message,
                detail  = e.detail
            );
        }
    }

    /**
     * Retrieves the messages for the specified thread.
     *
     * @threadID The ID of the thread. (string, required).
     * 
     * @return The response generated from the request to the OpenAI API for retrieve the thread messages.
     * @throws com.madishetti.ChatGPTComplete.openAIAPICallException
     * @throws com.madishetti.ChatGPTComplete.sendRequestToOpenAIException
     * @throws com.madishetti.ChatGPTComplete.getThreadMessagesException
     */
    private any function getThreadMessages(required string threadID) {
        var getThreadMessagesEndpoint = "#variables.chatGptSettings.assistantEndPoint#/threads/#arguments.threadID#/messages?limit=#variables.chatGptSettings.assistantMessageLimit#";
        try {
            var getThreadMessagesResponse = sendRequestToOpenAI(
                endpoint = getThreadMessagesEndpoint,
                method = "get"
            );
            return getThreadMessagesResponse;
        } catch (com.madishetti.ChatGPTAssitant.openAIAPICallException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.sendRequestToOpenAIException e) {
            rethrow;
        } catch (any e) {
            // Handle generic error
            throw(
                type    = "com.madishetti.ChatGPTAssitant.getThreadMessagesException",
                message = "ChatGPTAssitant - problem getting the thread messages: " & e.message,
                detail  = e.detail
            );
        }
    }

    /**
     * Sends a message to the ChatGPT Assistant and retrieves the latest response.
     *
     * @message The message to be sent. (string, required)
     * @threadID The ID of the thread. Defaults to createThread(). (string, required)
     * 
     * @return The threadId and the latest response generated from the ChatGPT Assistant OpenAI API.
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
        if( not arguments.threadId.len())
        {
            arguments.threadId = createThread();
        }
        var response = { 'threadId': arguments.threadId, assistantResponse = "" };
        // Validate message
        try {
            var validationResult = variables.validation.validateMessage(arguments.message);
            if (validationResult.len()) {
                throw(
                    type    = "com.madishetti.ChatGPTAssitant.sendMessage.message.validationException",
                    message = "Error in sending message: " & validationResult
                    );
            }
            // Add Message to thread
            addMessageToThread(threadId = arguments.threadId, message = arguments.message);

            // Run Assistant
            var runAssistant = runTheAssistant(threadId =arguments.threadId);

            // Run assistant retry
            retryRunAssistantStatus(threadId = arguments.threadId,runId = runAssistant.id );
            
            // Get thread messages
            var threadMessages = getThreadMessages(threadId = arguments.threadId);
            if (!isStruct(threadMessages)) {
                throw(
                    type    = "com.madishetti.ChatGPTAssitant.sendMessage.getThreadMessagesException",
                    message = "Failed to retrieve messages: " & threadMessages
                    );
            }
            var assistantResponse = "Sorry, something went wrong. Please try again in a moment.";
            if (structKeyExists(threadMessages, "data") && structKeyExists(threadMessages, "first_id")) {
                for (message in threadMessages.data) {
                    if (message.role == "assistant" && message.id == threadMessages.first_id) {
                        if (message.content.len() && structKeyExists(message.content[1],"text")) {
                            assistantResponse = message.content[1].text.value;
                        }
                        break;
                    }
                }
            }
            response.assistantResponse = assistantResponse;
            return serializeJSON(response);
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
        } catch (any e) {
            // Handle generic error
            throw(
                type    = "com.madishetti.ChatGPTAssitant.sendMessageException",
                message = "ChatGPTAssitant - problem sending message: " & e.message,
                detail  = e.detail
            );
        }
    }

    /**
     * Retries to run the Assistant status check until it is completed or maximum retries reached.
     *
     * @threadID The ID of the thread. (string, required)
     * @runAssistantId The ID of the current running Assistant. (string, required)
     * 
     * @throws com.madishetti.ChatGPTComplete.sendMessage.message.openAIAPICallException
     * @throws com.madishetti.ChatGPTComplete.sendMessage.message.sendRequestToOpenAIException
     * @throws com.madishetti.ChatGPTComplete.sendMessage.message.runTheAssistantStatusException
     * @throws com.madishetti.ChatGPTComplete.sendMessage.message.retryRunAssistantStatusException
     */
    private void function retryRunAssistantStatus(
        required string threadId,
        required string runId
    ) {

        var retry = 0;
        // Max retries
        var maxRetries = 15;
        // Delay between retries
        var delay = false;
        var delayTime = 5000;
        var status = false;
        try {
            do {
                if (delay) {
                    sleep(delayTime);
                }
                status = (runTheAssistantStatus(threadId = arguments.threadId, runId = arguments.runId).status == "completed" ? true : false);
                retry++;
                delay = true;
            } while (retry < maxRetries && status == false);
        } catch (com.madishetti.ChatGPTAssitant.openAIAPICallException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.sendRequestToOpenAIException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTAssitant.runTheAssistantStatusException e) {
            rethrow;
        } catch (any e) {
            // Handle generic error
            throw(
                type    = "com.madishetti.ChatGPTAssitant.retryRunAssistantStatusException",
                message = "ChatGPTAssitant - problem retry run Assistant status: " & e.message,
                detail  = e.detail
            );
        }
    }

    /**
     * Sends a message to the ChatGPT Assistant and retrieves all messages for a given thread.
     *
     * @message The message to be sent. (string, required)
     * @threadID The ID of the thread. Defaults to createThread(). (string, required)
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
        if( not arguments.threadId.len())
        {
            arguments.threadId = createThread();
        }
        var response = { 'threadId': arguments.threadId, assistantResponse = "" };
        // Validate message
        try {
            var validationResult = variables.validation.validateMessage(arguments.message);
            if (validationResult.len()) {
                throw(
                    type    = "com.madishetti.ChatGPTAssitant.sendMessage.message.validationException",
                    message = "Error in sending message: " & validationResult
                    );
            }
            // Add message to thread
            addMessageToThread(threadId = arguments.threadId, message = arguments.message);
            var runAssistant = runTheAssistant(arguments.threadId);

            // Run assistant retry
            retryRunAssistantStatus(threadId = arguments.threadId,runId = runAssistant.id );
            
            // Get thread messages
            var threadMessages = getThreadMessages(threadId = arguments.threadId);
            if (!isStruct(threadMessages)) {
                throw(
                    type    = "com.madishetti.ChatGPTAssitant.sendMessage.getThreadMessagesException",
                    message = "Failed to retrieve messages: " & threadMessages
                    );
            }
            return threadMessages;
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
        } catch (any e) {
            // Handle generic error
            throw(
                type    = "com.madishetti.ChatGPTAssitant.sendMessageException",
                message = "ChatGPTAssitant - problem sending message: " & e.message,
                detail  = e.detail
            );
        }
    }
}