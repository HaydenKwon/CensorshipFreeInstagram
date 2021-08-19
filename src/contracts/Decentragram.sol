pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";
  //Store Posts
  mapping(uint => Image) public images;

  uint public imageCount = 0;

  struct Image{
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );
  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  modifier validPost(string memory _imgHash, string memory _description) {
    require(bytes(_description).length > 0);
    require(bytes(_imgHash).length > 0);
    require(msg.sender != address(0x0));
    _;
  } 
  //Creates Images uses imagecount to use the most recent spot of the array
  function uploadImage(string memory _imgHash, string memory _description) public validPost(_imgHash, _description) {
    ++imageCount;
    images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender);
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  } 

  //Tip
  function tipImageOwner(uint _id) public payable {
    //Make sure id is valid(exists)
    require(_id > 0 && _id <= imageCount);
    //Fetches author from image
    Image memory _image = images[_id];
    address payable _author = _image.author;
    //Sends ether to author
    address(_author).transfer(msg.value);
    //updates total tipped
    _image.tipAmount = _image.tipAmount + msg.value;
    //Trigger an event
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
  }

  
}