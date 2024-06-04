/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.ortussolutions.com
**************************************************************************************
*/
component{
	this.name = "A TestBox Runner Suite " & hash( getCurrentTemplatePath() );
	// any other application.cfc stuff goes below:
	this.sessionManagement = true;
	this.enableNullSupport  = shouldEnableFullNullSupport();

	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );
	// Map back to its root
	

	rootPath                  = reReplaceNoCase(
        this.mappings[ "/tests" ],
        "tests(\\|/)",
        ""
    );
	
    this.mappings[ "/root" ] = rootPath;
	this.mappings[ "/testbox" ] = rootPath&"/testbox";
	this.mappings[ "/system" ] = rootPath&"/testbox/system";
    this.mappings[ "/cbproxies" ] = rootPath&"/modules/cbproxies";

	// any orm definitions go here.

	// request start
	public boolean function onRequestStart( String targetPage ){
		return true;
	}

	public void function onRequestEnd() {
        structDelete( application, "cbController" );
        structDelete( application, "wirebox" );
    }


	private boolean function shouldEnableFullNullSupport() {
		param value = url.keyExists( "FULL_NULL" );
		var system = createObject( "java", "java.lang.System" );
        var value = system.getEnv( "FULL_NULL" ) ?: false;
        return !!value;
    }

	function onError(
        required any exception,
        required string eventName
    ) { 
        writedump(exception);
		// hanlde  exception here
    }
}
