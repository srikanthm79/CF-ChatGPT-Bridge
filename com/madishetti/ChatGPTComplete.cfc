/**
 * chatGPTComplete CFC is designed to validate and generate prompts, call the OpenAI content Completion API, and return responses.
 * 
 * No need to worry about the complete process—use the suggestContent function, which will handle the entire process 
 * and provide the response from the OpenAI Completion API.
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
     * Generates a standardized prompt for content generation.
     *
     * @isReview Indicates whether review of generated content is required. Defaults to false(boolean, required)
     * @purpose Purpose of the content (e.g., resume, LinkedIn profile). (string, required)
     * @description Description or overview of the content to be generated. (string, required)
     * @language Language for the content. Defaults to English. (string, required)
     * @formattingInstructions Formatting guidelines or preferences for the content. Defaults to blank value (string, required)
     * @audience Target audience for the content like (e.g., Travelers, Professionals, Students). (string, required)
     * @tone Desired tone of the content (e.g., formal, casual). (string, required)
     * @keywords Specific keywords or phrases to include. (string, optional)
     * @length Desired length or word count for the content. (string, optional)
     * @reviewInstructions Instructions or comments related to previous content. Defaults to blank value (string, optional)
     *
     * @return The generated prompt.
     * @throws com.madishetti.ChatGPTComplete.generatePromptException
     */
    private string function generatePrompt(
        required boolean isReview="false",
        required string purpose,
        required string description,
        required string language,
        required string formattingInstructions="",
        required string audience,
        required string tone,
        string keywords,
        string length,
        string reviewInstructions=""
    ) {
        var prompt = "";
        try {
            if (arguments.isReview) {
                prompt &= "Review the generated " & arguments.purpose & " and make any necessary revisions." & chr(10);
                prompt &= "Previous Content:"& arguments.description &"." & chr(10);
                prompt &= "Instructions/Comments:" &arguments.reviewInstructions &"." & chr(10) & chr(10);
            } else {
                prompt &= "Generate a " & arguments.purpose & " with the following specifications:" & chr(10);
                prompt &= "1. Description: " & arguments.description & chr(10);
                prompt &= "2. Audience: " & arguments.audience & chr(10);
                prompt &= "3. Tone: " & arguments.tone & chr(10);
                prompt &= "4. Language: " & arguments.language & chr(10);
                promptCnt = 5;
                if(structKeyExists(arguments,"keywords"))
                {
                    prompt &= promptCnt&". Keywords: " & arguments.keywords & chr(10);
                }
                if(structKeyExists(arguments,"length"))
                {
                    prompt &= promptCnt&". Length: " & arguments.length & chr(10);
                }
                prompt &= promptCnt&". Formatting Instructions: " & arguments.formattingInstructions & chr(10) & chr(10);
            }

            return prompt;
        } catch ( Exception e ) {
            throw(
                type    = "com.madishetti.ChatGPTComplete.generatePromptException",
                message = "ChatGPTComplete - problem creating the prompt: " & e.message,
                detail  = e.detail
            );
        }
    }

    /**
     * Retrieves completion from the OpenAI API.
     *
     * @prompt Prompt for generating the completion. (string, required).
     * @maxTokens Maximum number of tokens for the completion. Defaults to settings defaultCompletionMaxTokens (numeric, required).
     * @temperature Temperature parameter for controlling randomness (0 to 1).Defaults to settings defaultCompletionMaxTokens (numeric, required).
     * @model Name of the OpenAI model to use. Defaults to settings defaultCompletionModel (string, required).
     * @apiKey API key for accessing the OpenAI API. Defaults to settings apiKey (string, required).
     *
     * @return The generated  completion from the OpenAI API.
     * @throws com.madishetti.ChatGPTComplete.generatePromptException
     */
    private string function getOpenAICompletion(
        required string prompt,
        required numeric maxTokens=variables.chatGptSettings.defaultCompletionMaxTokens,
        required numeric temperature=variables.chatGptSettings.defaultCompletionTemperature,
        required string model=variables.chatGptSettings.defaultCompletionModel,
        required string apiKey=variables.chatGptSettings.apiKey
    ) {
    // Validate prompt inputs
        var validationError = variables.validation.validateCompletionInputs(
            prompt      = arguments.prompt,
            maxTokens   = arguments.maxTokens,
            temperature = arguments.temperature
        );

        if(validationError.len()){
            throw(
                type    = "com.madishetti.ChatGPTComplete.validateException",
                message = validationError
            );
        }

        // Define API endpoint
        var endpoint = variables.chatGptSettings.completionEndpoint;

        // Define request data
        requestData = {
            "model": arguments.model,
            "prompt": arguments.prompt,
            "max_tokens": arguments.maxTokens,
            "temperature": arguments.temperature
        };

        // Convert request data to JSON
        requestDataJSON = serializeJSON(requestData);

        // Create HTTP request object
        httpService = new Http();
        httpService.setMethod("post");
        httpService.setUrl(endpoint);
        httpService.addParam(type="header", name="Content-Type", value="application/json");
        httpService.addParam(type="header", name="Authorization", value="Bearer #arguments.apiKey#");
        httpService.addParam(type="body", value=requestDataJSON);

        // Send request and get response
        try {
            response = rawHTTPCall( httpRequestObj = httpService);

            // Check if response status code is OK (200)
            if (response.responseHeader.status_Code == 200) {
                // Parse response JSON
                responseData = deserializeJSON(response.fileContent);
                completionText = responseData.choices[1].text; // Extract completion text
                return completionText;
            } else {
                  throw(
                    type    = "com.madishetti.ChatGPTComplete.openAIAPICallException",
                    message = "Error calling Completion API: " & response.statusCode & " - " & response.fileContent
                  );
            }
        } catch (com.madishetti.ChatGPTComplete.validateException e) {
            rethrow;
        } catch (com.madishetti.ChatGPTComplete.openAIAPICallException e) {
            rethrow;
        } catch (any e) {
            // Handle generic error
            throw(
                type    = "com.madishetti.ChatGPTComplete.getOpenAICompletionException",
                message = "ChatGPTComplete - problem calling openAI API: " & e.message,
                detail  = e.detail
            );
        }
    }

    /**
    * Makes a HTTP call.
    *
    * @httpRequestObj http request object. (any, required).
    *
    * @return The response from the HTTP call.
    */
    private any function rawHTTPCall( required any httpRequestObj) {
        return httpRequestObj.send().getPrefix();
    }
  

    /**
     * Call prompt and completion functions and returns completion from the OpenAI API.
     *
     * @isReview Indicates whether review of generated content is required. Defaults to false(boolean, required)
     * @purpose Purpose of the content (e.g., resume, LinkedIn profile). (string, required)
     * @description Description or overview of the content to be generated. (string, required)
     * @language Language for the content. Defaults to English. (string, required)
     * @formattingInstructions Formatting guidelines or preferences for the content. Defaults to blank value (string, required)
     * @audience Target audience for the content like (e.g., Travelers, Professionals, Students). Defaults to general public. (string, required)
     * @tone Desired tone of the content (e.g., formal, casual). Defaults to neutral. (string, required)
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
        required string language,
        required string formattingInstructions="",
        required string audience,
        required string tone,
        string keywords,
        string length,
        string reviewInstructions=""
    ) {
       try {
           arguments.prompt = generatePrompt(argumentCollection = arguments);
           return getOpenAICompletion(argumentCollection = arguments);
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
}