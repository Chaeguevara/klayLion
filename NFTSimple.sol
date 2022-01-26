//Klaytn IDE uses solidity 0.4.24, 0.5.6 versions.
pragma solidity >=0.4.24 <=0.5.6;

contract NFTSimple{
    string public name = "KlayLion";
    string public symbol = "KL";

    mapping(uint256 => address) public tokenOwner;
    mapping(uint256 => string) public tokenURIs;

    //소유한 토큰 리스트
    mapping(address => uint256[]) private _ownedTokens;

    //mint(tokenId,uri,owner)

    //transferFrom(from, to, tokenId) -> change owner
 
    function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public returns (bool) {
        // to에게 토큰 id를 발급한다
        //적힌 글자는 tokenURI
        tokenOwner[tokenId] = to;
        tokenURIs[tokenId] = tokenURI;
        //add token to the list
        _ownedTokens[to].push(tokenId);

        return true;
    }

    function _removeTokenFromList(address from, uint256 tokenId) private{
        // [10, 15, 19, 20] -> 19번 삭제
        // 1. 19번 찾음 -> 20 swap -> 길이를 짧게
        uint256 lastTokenIdex = _ownedTokens[from].length-1;
        for(uint256 i=0; i<_ownedTokens[from].length;i++){
            if(tokenId == _ownedTokens[from][i]){
                _ownedTokens[from][i] = _ownedTokens[from][lastTokenIdex];
                _ownedTokens[from][lastTokenIdex] = tokenId;
                break;
            }
        }
        _ownedTokens[from].length--;
        
    }
    function safeTransferFrom(address from, address to, uint256 tokenId) public{
        require(from == msg.sender, "from != msg.sender");
        require(from == tokenOwner[tokenId], "you are not the owner of the token");
        _removeTokenFromList(from,tokenId);
        _ownedTokens[to].push(tokenId);
        tokenOwner[tokenId] = to;
    }

    function ownedTokens(address owner) public view returns (uint256[] memory){
        return _ownedTokens[owner];
    }
    function setTokenUri(uint256 id, string memory uri) public {
        tokenURIs[id] = uri;
    }
}

contract NFTMarket{
    function buyNFT(uint256 tokenId, address NFTAddress, address to) public returns (bool){
        NFTSimple(NFTAddress).safeTransferFrom(address(this), to, tokenId);
        return true;
    }
}