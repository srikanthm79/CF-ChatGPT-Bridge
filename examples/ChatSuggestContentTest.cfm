
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prompt Generator</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 50px;
            background-color: #f8f9fa;
        }
        .form-container {
            max-width: 600px;
            margin: auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .form-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .btn-custom {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-custom:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        .generated-content-container {
            margin-top: 20px;
            text-align: center;
        }
        #generatedContent {
            width: 100%;
            height: 300px;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            background-color: #f8f9fa;
            font-family: monospace;
            resize: none;
        }
    </style>
</head>
<body>
    <cfset variables.response = "">
    <cfset variables.err = "">
    <cfif structKeyExists(form,"purpose")>
        <cfset variables.args = {
            "purpose" : form.purpose,
            "description" : form.description,
            "formattingInstructions" : form.formattingInstructions
        }>
        <cfif structKeyExists(form,"isReview")>
            <cfset variables.args.isReview = true>
            <cfset variables.args.reviewInstructions = form.reviewInstructions>
        </cfif>
        <cftry>
            <cfset variables.chatGPTObj = new com.madishetti.ChatGPT().init()>
            <cfset variables.response = variables.chatGPTObj.suggestContent(argumentCollection = args)>
        <cfcatch type="any">
             <cfset variables.err = cfcatch.message>
             <cfdump var="#cfcatch#">
        </cfcatch>
        </cftry>
        
    </cfif>
    
    <div class="container">
    <cfoutput>
        <cfif len(variables.err)>
            <div class="alert alert-danger">
                <strong>Error:</strong> #variables.err#.
            </div>
        </cfif>
        <cfif len(variables.response)>
            <div class="generated-content-container">
                <label for="generatedContent"><strong>Generated Content:</strong></label>
                <textarea id="generatedContent" readonly>#variables.response#</textarea>
            </div>
        </cfif>
    </cfoutput>  
        <div class="form-container">
            <h2 class="form-header">Generate Prompt</h2>
           
            <form name="suggest" action="ChatSuggestContentTest.cfm" method="post">
                <div class="form-group form-check">
                    <input type="checkbox" class="form-check-input" name="isReview" id="isReview" onclick="callReview();">
                    <label class="form-check-label" for="isReview">Is Review</label>
                </div>
                <div class="form-group" id="reviewInstructions" style="display: none;">
                    <label for="purpose">Review Instructions</label>
                    <textarea class="form-control" id="rins" name="reviewInstructions" rows="3" placeholder="Enter the review instructions"></textarea>
                </div>
                <div class="form-group">
                    <label for="purpose">Purpose</label>
                    <textarea class="form-control" id="purpose" name="purpose" rows="3" placeholder="Enter the purpose of the content"></textarea>
                </div>
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea class="form-control" id="description" name="description" rows="3" placeholder="Enter a description or overview"></textarea>
                </div>
                <div class="form-group">
                    <label for="formattingInstructions">Formatting Instructions</label>
                    <textarea class="form-control" id="formattingInstructions" name="formattingInstructions" rows="3" placeholder="Enter any formatting guidelines or preferences"></textarea>
                </div>
                <button type="submit" class="btn btn-custom btn-block">Generate Prompt</button>
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        function callReview(){
            document.getElementById('description').value = document.getElementById('generatedContent').value;
            document.getElementById('reviewInstructions').style.display = 'block'; 
        }
    </script>
</body>
</html>

