
component
    extends="coldbox.system.testing.BaseModelTest"
{

    /*********************************** LIFE CYCLE Methods ***********************************/

    function beforeAll() {
        super.beforeAll();
        // setup
		model = createMock( "com.madishetti.ChatGPTComplete");
		validationMock = createMock( "com.madishetti.validation");
		model.init();
        makePublic( model, "generatePrompt" );
    }

    function afterAll() {
        super.afterAll();
    }

    /*********************************** BDD SUITES ***********************************/

    function run() {
        describe( "ChatGPTComplete suite", function() {
            beforeEach( function( currentSpec ) {
            } );

            it( "Can be created", function() {
                expect( model ).toBeComponent();
            } );

			it( "generatePrompt - generate correct prompt", function() {
                // Arrange
				 var purpose ="test";
                 var description ="xyz";
                 var language ="apples";
                 var audience = "someone";
                 var tone = "bananas";
                 var expectedRes = "Generate a test with the following specifications:#chr(10)#1. Description: xyz#chr(10)#2. Audience: someone#chr(10)#3. Tone: bananas#chr(10)#4. Language: apples#chr(10)#5. Formatting Instructions: test#chr(10)##chr(10)#";


				// Act
				var res = model.generatePrompt(
                    purpose=purpose,
                    description=description,
                    language=language,
                    audience=audience,
                    tone=tone,
                    formattingInstructions="test"
                );

				// Assert
				assertEquals(res,expectedRes);
                
            } );

            it( "generatePrompt - generate correct prompt for review", function() {
                // Arrange
				 var purpose ="test";
                 var description ="xyz";
                 var language ="apples";
                 var audience = "someone";
                 var tone = "bananas";
                 var expectedRes = "Review the generated test and make any necessary revisions.#chr(10)#Previous Content:xyz.#chr(10)#Instructions/Comments:.#chr(10)##chr(10)#";


				// Act
				var res = model.generatePrompt(
                    isReview=true,
                    purpose=purpose,
                    description=description,
                    language=language,
                    audience=audience,
                    tone=tone
                );
				// Assert
				assertEquals(res,expectedRes);
                
            } );

            it( "suggestContent - get content", function() {
                // Arrange
				 var purpose ="test";
                 var description ="xyz";
                 var language ="apples";
                 var audience = "someone";
                 var tone = "bananas";

                model
				  .$("generatePrompt")
				  .$results( "ss");
                model
				  .$("getOpenAICompletion")
				  .$results( "test string");

				// Act
				var res = model.suggestContent(
                    isReview=false,
                    purpose=purpose,
                    description=description,
                    language=language,
                    audience=audience,
                    tone=tone
                );
				// Assert
				assertEquals(res,"test string");
                
            } );

			

		} );
	}

}
