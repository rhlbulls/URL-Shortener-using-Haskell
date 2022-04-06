# URL-Shortener-using-Haskell

**Objective:**
  In this project I have implemented a simple URL Shortener that will turn long boring links into a short and sweet ones.
  
**Implementation:**
  I have used a package called as blaze to convert haskell code to html document. Scotty is used to start and run a server on a specific port. Once the server starts running the haskell build will generate a file for read and write operations. After the user types in a link and clicks submit, the link is insert into a map along with the index and written into the file. All the original links, generated links along with their index number is displayed in the home page. If a user tries to hit up an index, the get method will search for the index and redirect to the corresponding link. If the index doesnt exist in the file then it will return 404 not found status.
  
