<!DOCTYPE html>
<html>
<head>
    <title>ChatGPT Chat Assistant Test</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<cfset variables.chatAssistantTestEndPoint = "/examples/ChatAssistantTestEndPoint.cfm">
<cfset variables.chatHeading = "Chat with ChatGPT">
<body>
    <div class="container mt-5">
        <h1 class="text-center">ChatGPT Chat Assistant Test Page</h1>
        <p class="text-center">This page demonstrates the ChatGPT chat assistant. Use the chat box below to interact with the ChatGPT assistant.</p>
        
        <cfinclude template="../chatwizard.cfm">
    </div>
</body>
</html>
