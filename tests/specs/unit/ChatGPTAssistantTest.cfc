
component
    extends="coldbox.system.testing.BaseModelTest"
{

    /*********************************** LIFE CYCLE Methods ***********************************/

    function beforeAll() {
        super.beforeAll();
        // setup
		model = createMock( "com.madishetti.ChatGPTAssistant");
		validationMock = createMock( "com.madishetti.validation");
		model.init();
    }

    function afterAll() {
        super.afterAll();
    }

    /*********************************** BDD SUITES ***********************************/

    function run() {
        describe( "ChatGPTAssistant suite", function() {
            beforeEach( function( currentSpec ) {
            } );

            it( "Can be created", function() {
                expect( model ).toBeComponent();
            } );

			it( "sendMessage - get response of latest message", function() {
                // Arrange
				model
				  .$("createThread")
				  .$results( "xyzId" );

				validationMock
				  .$("validateMessage")
				  .$results( "" );
				  
				model
				  .$("addMessageToThread");

				model
				  .$("runTheAssistant")
				  .$results( {"id":"xyz" });

				model
				  .$("retryRunAssistantStatus");
				
				var dataArrMock = [];
                dataArrMock[1] = {};
				dataArrMock[1].role ="assistant";
				dataArrMock[1].id ="abc";
				dataArrMock[1].content = [];
				dataArrMock[1].content[1] = {};
				dataArrMock[1].content[1].text.value  = "I am a mock response";
				
				var threadMessagesMock = {"data" : dataArrMock, first_id :"abc"};

				model
				  .$("getThreadMessages")
				  .$results( threadMessagesMock );

				// Act
				var res = model.sendMessage(message="hi",threadId="");
				var obj = deserializeJSON( res );

				// Assert
				expect( isJSON( res ) ).toBeTrue();
                
				expect( obj )
                    .toHaveKey( "threadId" )
                    .toHaveKey( "assistantResponse" );
                expect( obj.threadId ).toBe( "xyzId" );
                expect( obj.assistantResponse ).toBe( "I am a mock response");
            } );

			it( "sendMessage - no response from open AI", function() {
                // Arrange
				model
				  .$("createThread")
				  .$results( "xyzId" );

				validationMock
				  .$("validateMessage")
				  .$results( "" );
				  
				model
				  .$("addMessageToThread");

				model
				  .$("runTheAssistant")
				  .$results( {"id":"xyz" });

				model
				  .$("retryRunAssistantStatus");
				
				var threadMessagesMock = {};

				model
				  .$("getThreadMessages")
				  .$results( threadMessagesMock );

				// Act
				var res = model.sendMessage(message="hi",threadId="");
                var obj = deserializeJSON( res );

				// Assert
				expect( isJSON( res ) ).toBeTrue();
                
				expect( obj )
                    .toHaveLength( 2 )
                    .toHaveKey( "threadId" )
                    .toHaveKey( "assistantResponse" );
                expect( obj.threadId ).toBe( "xyzId" );
                expect( obj.assistantResponse ).toBe( "Sorry, something went wrong. Please try again in a moment.");
            } );

		    it( "sendMessageAndRetrieveAllMessages - get all response message objects", function() {
                // Arrange
				model
				  .$("createThread")
				  .$results( "xyzId" );

				validationMock
				  .$("validateMessage")
				  .$results( "" );
				  
				model
				  .$("addMessageToThread");

				model
				  .$("runTheAssistant")
				  .$results( {"id":"xyz" });

				model
				  .$("retryRunAssistantStatus");
				
				var dataArrMock = [];
				dataArrMock[1] = {};
				dataArrMock[1].role ="assistant";
				dataArrMock[1].id ="abc";
				dataArrMock[1].content = [];
				dataArrMock[1].content[1] = {};
				dataArrMock[1].content[1].text.value  = "I am a mock response";
				
				var threadMessagesMock = {"data" : dataArrMock, first_id :"abc"};

				model
				  .$("getThreadMessages")
				  .$results( threadMessagesMock );

				// Act
				var res = model.sendMessageAndRetrieveAllMessages(message="hi",threadId="");

				// Assert
				expect( res )
                    .toHaveLength( 2 )
                    .toHaveKey( "data" )
                    .toHaveKey( "first_id" );
                expect( res.data ).toBe( dataArrMock );
                expect( res.first_id ).toBe( "abc");
            } );

		} );
	}

}
