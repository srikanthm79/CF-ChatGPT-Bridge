<cfset variables.result = {'response' = '', 'err' = 0}>
<cfset variables.chatGPTObj = new com.madishetti.ChatGPT().init()>
<cfset args.message = form.message>
<cfset args.threadId = form.threadId>
<cftry>
    <cfset variables.result.response = variables.chatGPTObj.sendMessage(argumentCollection = args)>
    <cfcatch type="any">
        <cfset variables.result.response  = cfcatch.message>
        <cfset variables.result.err = 1>
    </cfcatch>
</cftry>
<cfcontent type="application/json">
<cfoutput>
#serializeJSON(variables.result)#
</cfoutput>

