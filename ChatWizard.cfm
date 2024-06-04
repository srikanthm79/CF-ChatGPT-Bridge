<!--- This complete snippet includes the HTML, CSS, and JavaScript to create a styled chat wizard that can be embedded 
    into any HTML page. The CSS styles ensure a clean, user-friendly interface for interacting with the ChatGPT assistant.

    Set the local variables chatHeading and chatAssistantTestEndPoint to use the current file.
    The chatHeading variable will store the heading of the chat, while the chatAssistantTestEndPoint variable will store the endpoint for communicating
    with the ChatGPT assistant. For testing purposes, we are using a fake endpoint: examples/ChatAssistantTestEndPoint.cfm.
---> 
<style>
    .chat-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 8px;
        background-color: #f9f9f9;
    }

    .chat-container h1 {
        font-size: 24px;
        text-align: center;
        margin-bottom: 20px;
    }

    #chatHistory {
        width: 100%;
        height: 300px;
        padding: 10px;
        overflow-y: scroll;
        border: 1px solid #ccc;
        border-radius: 4px;
        background-color: #fff;
        resize: none;
        margin-bottom: 10px;
    }

    #sendForm {
        display: flex;
        justify-content: space-between;
    }

    #message {
        flex: 1;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        margin-right: 10px;
    }

    #sendButton {
        padding: 10px 20px;
        background-color: #007bff;
        color: #fff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    #sendButton:hover {
        background-color: #0056b3;
    }

    .wait-message {
    width: 200px; /* Adjust width as needed */
    padding: 10px;
    border: 2px solid #ccc;
    border-radius: 5px;
    font-size: 16px;
    font-weight: bold;
    color: #333;
    text-align: center;
    background-color: #f9f9f9;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .wait-message::placeholder {
        color: #999;
    }
</style>
<cfoutput>
    <div class="chat-container">
        <h1>#variables.chatHeading#</h1>
        <div id="chatHistory"></div><br>
        <form id="sendForm" onSubmit="sendMessage();">
            <input type="text" id="message" name="message" required>
            <input type="submit" id="sendButton" value="Send">
        </form>
    </div>
</cfoutput>
<!-- Include jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    <cfoutput>
        var chatEndPoint = '#variables.chatAssistantTestEndPoint#';
    </cfoutput>
    var threadId = ''; // Define the threadId variable globally
    // Function to send a message to ChatGPT
    function sendMessage() {
            var message = $('#message').val();
            $.ajax({
                url: chatEndPoint,
                type: 'POST',
                dataType: 'json',
                data: {
                    threadId: threadId,
                    message: message
                },
                beforeSend: function() {
                    // Display user input in the chat history
                    $('#chatHistory').append('<p><strong>User</strong>: ' + message + '<\p>');
                    // Clear the input field after submission
                    $('#message').val('Please wait...');
                    $("#message").addClass("yourClassName");
                },
                success: function(endPointResponse) {
                    // Parse the stringified JSON in the response
                    var parsedResponse = JSON.parse(endPointResponse.response);
                    // Dump the keys of the parsed response
                    var keys = Object.keys(parsedResponse);
                    if(endPointResponse.err == 0)
                    {   // Display the response from ChatGPT in the chat history
                        $('#chatHistory').append('<p><strong>Assistant</strong>: ' + parsedResponse.ASSISTANTRESPONSE + '</p>');
                        threadId = parsedResponse.threadId;
                    }
                    else{
                        // Please add your code to handle error
                    }
                    $('#message').val('');
                    $("#message").removeClass("yourClassName");
                },
                error: function(xhr, status, error) {
                    $('#message').val('');
                    $("#message").removeClass("yourClassName");
                    console.error('Error sending message:', error);
                }
            });
        }

        // Event handler for sending message form submission
        $('#sendForm').submit(function(event) {
            event.preventDefault();
        });
</script>
