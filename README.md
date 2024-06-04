# CF-ChatGPT-Bridge

## Overview
A simple and straight-forward library to integrate ChatGPT for content completion & chat assistance in Lucee and Adobe ColdFusion, Just use simple functions like suggestContent for completion and sendMessage for chat without needing to understand the intricacies of ChatGPT integration.

This document provides instructions on using `ChatGPT.cfc` straightforward functions `suggestContent` for content completion and `sendMessage` for chat Assistant support. Follow the steps below to initialize the ChatGPT settings, set configuration values, and utilize the ChatGPT methods provided.

## Step 1: Install

You can run this as a standalone application without any frameworks. To run tests and build documentation, please execute `box install`.

## Step 2: Set ChatGPT completion and assistant Configuration Values

Ensure that the necessary ChatGPT completion and assistant Configuration configuration values are set in `ChatGPTSettings.json`.

### API Key
- **apiKey**: The API key used to authenticate requests to the OpenAI API. Keep this key secure and do not share it publicly.

### Assistant Information
- **assistantId**: The unique identifier for the assistant instance. This ID is used to specify which assistant is being interacted with.
- **assistantEndPoint**: The base URL for the OpenAI API where requests to the assistant will be sent.

### Default Completion Settings
- **defaultCompletionModel**: The model used for generating completions, such as a specific version of GPT-3.5.
- **defaultCompletionTemperature**: The temperature setting controls the randomness of the response. Higher values (e.g., 1.0) make the output more random, while lower values (e.g., 0.2) make it more deterministic.
- **defaultCompletionMaxTokens**: The maximum number of tokens (words or parts of words) that can be generated in a single completion. This setting controls the length of the output.
- **completionEndpoint**: The specific endpoint URL used for generating text completions.

### Content Moderation
- **abusiveWords**: A list of words that are considered abusive or inappropriate. The assistant will avoid using these words in its responses.

### Assistant Limits
- **assistantMessageLimit**: The maximum number of messages the assistant can handle in a single interaction or session. This setting helps manage the scope of interactions.

### Content Defaults
- **defaultContentLanguage**: The default language for the content generated by the assistant. Specifies the language in which the assistant will respond.
- **defaultContentAudience**: The intended audience for the content, such as the general public, children, professionals, etc. This helps tailor the tone and complexity of the responses.
- **defaultContentTone**: The default tone of the content, such as neutral, friendly, formal, etc. This setting affects the style and presentation of the responses.


## Step 3: Initialize ChatGPT.cfc

Create an instance of `ChatGPT.cfc` and initialise

```cfml
// Instantiate ChatGPT.cfc
chatGPT = new com.madishetti.ChatGPT().init();
```

or

```cfml
// Create and initialise JedisManager.cfc
chatGPT = createObject("component","com.madishetti.ChatGPT");
chatGPT.init();
```

## Step 4: Use ChatGPT Methods

### suggestContent
The `suggestContent` method facilitates content completion by communicating with the OpenAI completion API and returning the response. You don't need to worry about how to properly create a prompt; simply pass the correct values to the function arguments, and the function will handle the rest.

#### Function Arguments

The `suggestContent` function accepts the following arguments:

- **@isReview**: Indicates whether a review of the generated content is required. Defaults to `false`. (boolean, required)
- **@purpose**: Specifies the purpose of the content (e.g., resume, LinkedIn profile). (string, required)
- **@description**: Provides a description or overview of the content to be generated. (string, required)
- **@language**: Specifies the language for the content. Defaults to `English`. (string, required)
- **@formattingInstructions**: Provides formatting guidelines or preferences for the content. Defaults to a blank value. (string, required)
- **@audience**: Defines the target audience for the content (e.g., travelers, professionals, students). Defaults to `general public`. (string, required)
- **@tone**: Specifies the desired tone of the content (e.g., formal, casual). Defaults to `neutral`. (string, required)
- **@keywords**: Lists specific keywords or phrases to include. (string, optional)
- **@length**: Indicates the desired length or word count for the content. (string, optional)
- **@reviewInstructions**: Provides instructions or comments related to previous content. Defaults to a blank value. (string, optional)

Please ensure you set the correct values for the default content settings to achieve the desired output.

```cfml
//Initialize the arguments struct
variables.args = {
    "purpose": purpose,
    "description": description,
    "formattingInstructions": formattingInstructions
};

// if isReview
    variables.args.isReview = true;
    variables.args.reviewInstructions = reviewInstructions;

// Initialize the ChatGPT object
variables.chatGPT = new com.madishetti.ChatGPT().init();

// Call the suggestContent method with the argument collection
variables.response = variables.chatGPT.suggestContent(argumentCollection = variables.args);
```
Please review the example file named `ChatSuggestContentTest.cfm` in the `examples` folder to test the chatCompletion functionality

### sendMessage
Use the `sendMessage` method to send a message to the ChatGPT Assistant and retrieves the latest response. If the threadId is left blank for the first call, the ChatGPT Assistant will return a threadId in the response. This threadId should be used in subsequent calls for the same conversation thread. Keep in mind that sending a blank threadId will start a new conversation thread, and any previous conversation history will be lost.

```cfml
// Initialize the ChatGPT object
chatGPT = new com.madishetti.ChatGPT().init();

// Call the sendMessage method with the correct message and threadId arguments
response = chatGPT.sendMessage(message = 'test', threadId ='');
```
#### Output
```cfml
{"ASSISTANTRESPONSE":"You're welcome! How can I assist you today? If you have any questions or need help with something specific, feel free to ask!","threadId":"thread_xyz895"}
```
Please review the example file named `ChatAssistantTest.cfm` in the `examples` folder to test the chatCompletion functionality.

Please be aware that a mock API endpoint named `ChatAssistantTestEndPoint.cfm` has been created. This endpoint simulates an API and generates responses from the `sendMessage` function of `ChatGPT`.

#### ChatWizard.cfm
In the main folder, we have `ChatWizard.cfm`, which contains a complete snippet including HTML, CSS, and JavaScript, designed to create a styled chat wizard that can be seamlessly embedded into any HTML page. The CSS styles ensure a clean and user-friendly interface for interacting with the ChatGPT assistant.

To configure the chat wizard, set the following local variables:

- `chatHeading`: This variable stores the heading of the chat.
- `chatAssistantTestEndPoint`: This variable stores the endpoint used for communicating with the ChatGPT assistant. For testing purposes, we are using a fake endpoint: `examples/ChatAssistantTestEndPoint.cfm`. This endpoint mimics an API and returns responses from the `sendMessage` function of ChatGPT.

### sendMessageAndRetrieveAllMessages
Use the `sendMessageAndRetrieveAllMessages` method to send a message to the ChatGPT Assistant and retrieves all messages for a given thread. If the threadId is left blank for the first call, the ChatGPT Assistant will return a threadId in the response. This threadId should be used in subsequent calls for the same conversation thread. Keep in mind that sending a blank threadId will start a new conversation thread, and any previous conversation history will be lost.

```cfml
// Initialize the ChatGPT object
chatGPT = new com.madishetti.ChatGPT().init();

// Call the sendMessage method with the correct message and threadId arguments
response = chatGPT.sendMessageAndRetrieveAllMessages(message = 'test', threadId ='');
```
#### Output
Returns a ordered struct of all messages for a given thread generated from the ChatGPT Assistant OpenAI API.

## Sample Implementation

To test the Chat Assistant chat functionality, please run the file `ChatAssistantTest.cfm`. For testing content completion, run the file `ChatSuggestContentTest.cfm`. These files are located in the `examples` folder.

## ChatGPT Documentation

To access comprehensive documentation about the `ChatGPT` component:

Execute the following command in CommandBox once:
```cfml
run-script build-docs
```
 Please navigate to `servername:portnumber/docs`. This directory contains detailed information to help you better understand the functionality and usage of `CF-ChatGPT-Bridge`.