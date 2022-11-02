class GraphQlQueryStrings {
  static const envdQuery = """
    query {
      consignments(first: 100) {
        totalCount
        items {
          # The consignment number
          number
          # The forms attached to this consignment
          forms {
            # Program name e.g. LPAC1
            type
            # The form serial number
            serialNumber
          }
          # The url for the printed form
          pdfUrl
          # These are self-explantory meta fields that are pre-filled during creation/update
          submittedAt
          updatedAt
          updatedBy
          # The current status of the consignment
          status
          # The current species of the consignment
          species
          # These are the movement fields for all forms
          owner {
            address {
              line1
              postcode
              state
              town
            }
            name
            pic
          }
          destination {
            address {
              line1
              postcode
              state
              town
            }
            name
            pic
          }
          consignee {
            address {
              line1
              postcode
              state
              town
            }
            name
            pic
          }
          origin {
            address {
              line1
              postcode
              state
              town
            }
            name
            pic
          }
          # A global declaration across all forms in the consignment
          declaration {
            accept
            address {
              line1
              postcode
              state
              town
            }
            certificateNumber
            date
            email
            fullName
            phone
            signature
          }
          # The list of questions for the consignment based on the forms attached (this will be dynamic due to this)
          questions {
            # The question id, you will need ths in order to answer it
            id
            # The question text, i.e. the actual question itself
            text
            # The question help, a long text field in markdown to explain the question
            help
            # The type of the question. This will help in choosing how to diplay the question,
            # The type can be SINGLE_CHOICE, MULTIPLE_CHOICE, STRING, NUMBER etc
            type
            # If this question has a limited field of answers, this will contain how to display the
            # answer and what the value to send for it is
            # If this contains nothing, then the user can answer it with anything they want
            acceptableAnswers {
              displayName
              value
            }
            # This is a list of questions that are related to this one, can be n-levels deep
            # When there is no `trigger` defined, this means that the child question is always visible
            # When there is a `trigger` defined, this means that the child question is only visible when the condition passes
            # e.g. if the `trigger` is: `{ id: '1', value: 'Yes }`, this means that the question with id "1" must have a value of "Yes" for this to be visible
            # typically, that question will be the parent question which is containing this child question
            childQuestions {
              id
              text
              help
              type
              acceptableAnswers {
                displayName
                value
              }
              triggers {
                questionId
                value
              }
            }
          }
          # These are the answers to the questions presented above. The `questionId` will allow you to figure out what to insert as the current answer
          answers {
            # The question id 
            questionId
            # The value of the answer
            value
            # An index if this is part of an array to indicate position, otherwise null
            index
          }
        }
      }
    }
    """;
}
