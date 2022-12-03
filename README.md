# URL-Shortener-using-Haskell

## Objective:
  
  In this project, I created a basic URL Shortener that converts long, boring links into short, snappy links. 
  
## Implementation:
  
* To convert haskell code to an HTML document, I used the blaze package. 
* Scotty is a command line tool that is being used to start and run a server on a given port. 
* The haskell build will generate a file for read and write operations once the server is up and running. The link is inserted into a map along with the index and written into the file after the user types in a link and hits submit. 
* The home page displays all of the original and created links, as well as their index numbers. If a user attempts to access an index, the get method will look for it and redirect to the appropriate link. 
* It will return 404 not found status if the index does not exist in the file. 
  
