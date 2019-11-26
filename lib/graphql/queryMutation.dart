class QueryMutation {

  String addUser(String email, String password) {
    return """
      mutation{
        createUser(inputUser: {
          email: "$email"
          password: "$password"
        }){
          email
          password
        }
      }
    """;
  }

  String loginUser(String email, String password) {
    return """
      query{
        login(email: "$email", password:"$password"){
          token
          userId
        }
      }
    """;
  }

  String getBooks(){
    return """ 
      query{
          book{
              title
              description
              _id
          }
      }
    """;
  }

  String addBook(String title, String description){
    return """
     mutation{
        addBook(inputBook:{
            title: "$title"
            description: "$description"
            
        }){
            title
            description
        }
    }
    """;
  }

}