
component
    extends="coldbox.system.testing.BaseModelTest"
{

    /*********************************** LIFE CYCLE Methods ***********************************/

    function beforeAll() {
        super.beforeAll();
        // setup
		model = createMock( "com.madishetti.validation");
		model.init();
        makePublic( model, "containsJunkCharacters" );
    }

    function afterAll() {
        super.afterAll();
    }

    /*********************************** BDD SUITES ***********************************/

    function run() {
        describe( "validation suite", function() {
            beforeEach( function( currentSpec ) {
            } );

            it( "Can be created", function() {
                expect( model ).toBeComponent();
            } );

			it( "validateMessage - message empty", function() {
                // Arrange
                var message = "";

				// Act
				var res = model.validateMessage(
                    message=message
                );

				// Assert
				assertEquals(res,"Message cannot be empty.");
                
            } );

			it( "containsJunkCharacters - yes", function() {
                // Arrange
                var str = "âstr";

				// Act
				var res = model.containsJunkCharacters(
                    stringToCheckForJunkCharacters=str
                );

				// Assert
				expect( res ).toBeTrue();
                
            } );

            it( "containsJunkCharacters - no", function() {
                // Arrange
                var str = "test";

				// Act
				var res = model.containsJunkCharacters(
                    stringToCheckForJunkCharacters=str
                );

				// Assert
				expect( res ).toBeFalse();
                
            } );

            it( "validateCompletionInputs - prompt", function() {
                // Arrange
                var prompt = "";
                var maxTokens = 1;
                var temperature = 1;

				// Act
				var res = model.validateCompletionInputs(
                    prompt=prompt,
                    temperature= temperature,
                    maxTokens=maxTokens

                );

				// Assert
				assertEquals(res,"Prompt cannot be empty.");
                
            } );

            it( "validateCompletionInputs - Max tokens", function() {
                // Arrange
                var prompt = "test";
                var maxTokens = 0;
                var temperature = 1;

				// Act
				var res = model.validateCompletionInputs(
                    prompt=prompt,
                    temperature= temperature,
                    maxTokens=maxTokens

                );

				// Assert
				assertEquals(res,"Max tokens must be greater than zero.");
                
            } );

            it( "validateCompletionInputs - Temperature", function() {
                // Arrange
                var prompt = "test";
                var maxTokens = 1;
                var temperature = 2;

				// Act
				var res = model.validateCompletionInputs(
                    prompt=prompt,
                    temperature= temperature,
                    maxTokens=maxTokens

                );

				// Assert
				assertEquals(res,"Temperature must be between 0 and 1.");
                
            } );
        });  
	}

}
